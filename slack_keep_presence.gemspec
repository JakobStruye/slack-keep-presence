
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "slack_keep_presence/version"

Gem::Specification.new do |spec|
  spec.name          = "slack-keep-presence"
  spec.version       = SlackKeepPresence::VERSION
  spec.authors       = ["Josh Frye"]
  spec.email         = ["josh@joshfrye.com"]

  spec.summary       = %q{Disable Slack auto-away}
  spec.description   = %q{Mark your Slack user as active when auto-away kicks in}
  spec.homepage      = 'https://github.com/joshfng/slack_keep_presence'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'bin'
  spec.executables   = ['slack-keep-presence']
  spec.require_paths = ['lib']

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry"

  spec.add_runtime_dependency "slack-api", "~> 1.6"
  spec.add_runtime_dependency "faye-websocket", "~> 0.10.6"
end
