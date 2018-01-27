# slack-keep-presence

Marks your user as active when auto-away kicks in

Inspired by [slack-keep-presence](https://github.com/eskerda/slack-keep-presence). This is basically a ruby port with only the presence functionality retained.

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
