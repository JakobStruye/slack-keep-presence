# slack-keep-presence

Marks a slack user as active when auto-away kicks in. Useful for keeping slack bots online.

Inspired by [slack-keep-presence](https://github.com/eskerda/slack-keep-presence). This is basically a ruby port with only the presence functionality retained.

## Features
  - Uses websockets to connect to Slack's real time api to track presence
  - Automatically reconnects if the connection drops and comes back

## Installation

```
$ gem install slack-keep-presence
```

## Usage

```
$ SLACK_TOKEN=<your_token> slack-keep-presence
```

Or set `SLACK_TOKEN` environment variable beforehand

```
$ slack-keep-presence
```

You can get a token linked to your user at https://api.slack.com/docs/oauth-test-tokens

## Motivation

https://twitter.com/slackhq/status/448966862521786368
> Disabling auto-away isn't on our immediate roadmap, but it's on our "someday"
list. Stay tuned! ✨
