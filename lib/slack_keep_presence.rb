require 'slack_keep_presence/version'
require 'slack'
require 'faye/websocket'
require 'eventmachine'
require 'logger'

module SlackKeepPresence
  class Main
    attr_accessor :logger, :client, :user, :ws, :should_shutdown

    def initialize(options)
      @logger = Logger.new(STDOUT)
      @logger.level = options[:debug] ? Logger::DEBUG : Logger::INFO
      @client = Slack::Client.new(token: ENV['SLACK_TOKEN'])

      get_user
      keep_presence
    end

    def get_user
      auth = client.auth_test

      if !auth['ok']
        logger.info('Unable to authenticate')
        exit(1)
      end

      @user = auth['user_id']
      logger.info("Authenticated as #{user}")
    end

    def clean_shutdown
      puts 'Shutting down...'
      @should_shutdown = true;
      ws.close;
      EM.stop;
      exit
    end

    def keep_presence
      Signal.trap("INT")  { clean_shutdown }
      Signal.trap("TERM") { clean_shutdown }

      EM.run do
        start_realtime
      end
    end

    def start_realtime
      @should_shutdown = false

      rtm = client.post("rtm.connect", batch_presence_aware: true)
      ws_url = rtm['url']

      @ws = Faye::WebSocket::Client.new(ws_url, nil, ping: 30)

      ws.on :open do |event|
        logger.info('Connected to Slack RealTime API')

        payload = {
          type: 'presence_sub',
          ids: [user]
        }

        ws.send(payload.to_json)

        res = client.users_getPresence(user: user)
        logger.debug "#{res}"
      end

      ws.on :message do |event|
        data = JSON.parse(event.data)

        if data['type'] == 'presence_change'
          logger.debug("Got event: #{event.data}")
          next unless data['user'] == user
          next unless data['presence'] == 'away'

          logger.info("Presence changed to #{data['presence']}")

          # Slack's setActive api doesn't seem to be working.
          # For now just reestablish the realtime connection
          # which automatically sets you as active
          # set_active
          # res = client.users_getPresence(user: user)
          # logger.debug "#{res}"

          ws.close
          @ws = nil
          @should_shutdown = true
          start_realtime
        end
      end

      ws.on [:close, :error] do |event|
        next if should_shutdown

        logger.info('Connection to Slack RealTime API terminated, reconnecting')
        sleep 5
        start_realtime
      end
    end

    def set_active
      logger.info("Marking #{user} as active")
      res = client.users_setActive
      logger.debug(res)

      res = client.users_getPresence(user: user)
      logger.debug(res)
    end
  end
end
