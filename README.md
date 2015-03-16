# hubot-github-webhook-listener

A [Hubot](http://hubot.github.com/) script to that makes it easy to consume [Github Webhooks](https://developer.github.com/webhooks/).

## Installation

From your hubot folder:
`npm install --save hub-github-webhook-listener`

Then, in your `external-scripts.json` file, add: `"hubot-github-webhook-listener"` to the list.

Create a new webhook for your `myuser/myrepo` repository at:
https://github.com/myuser/myrepo/settings/hooks/new
Set the webhook url to: &lt;HUBOT_URL&gt;:&lt;PORT&gt;/hubot/github-repo-listener

For example, if your hubot lives at myhubot.herokuapp.com, then you will set the webhook URL to: http://myhubot.herokuapp.com/hubot/github-repo-listener

## Usage

On every incoming webhook message, a hubot event is emitted as follows

```coffeescript
eventBody =
  eventType   : req.headers["x-github-event"]
  signature   : req.headers["X-Hub-Signature"]
  deliveryId  : req.headers["X-Github-Delivery"]
  payload     : req.body
  query       : querystring.parse(url.parse(req.url).query)

robot.emit "github-repo-event", eventBody
```

For details on these fields, see the [Github Webhook documentation](https://developer.github.com/webhooks/).

You can consume it like so from one of your scripts:
```coffeescript
@robot.on "github-repo-event", (repo_event) =>
  githubPayload = repo_event.payload
  switch(repo_event.eventType)
    when "issue_comment"
      ...
```

NOTE: This script does not emit anything in chat. It is just a background task that makes consuming Github webhooks easier for other scripts.

For another example, see our [Hubot-Github adapter](https://github.com/ynab/hubot-github) that gives you a hubot in your Github issue comments.

## Motivation

I was using [hubot-github-repo-event-notifier](https://github.com/hubot-scripts/hubot-github-repo-event-notifier), but I needed something more generic to power our hubot-github adapter. So, I gutted it, and this script was born.

## Local Testing

For easy local testing, I highly recommend ngrok: https://ngrok.com/

1. Install [ngrok](https://ngrok.com/)
2. run ngrok: `ngrok 8080`.
  It will show you a public URL like: `Forwarding  https://7a008da9.ngrok.com -> 127.0.0.1:8080`
3. Put that URL in as your Github webhook: `https://7a008da9.ngrok.com/hubot/github-repo-listener`
4. Run hubot locally: `HUBOT_GITHUB_TOKEN=some_log_guid bin/hubot -a github --name Hubot`
5. Fire off a github event by interacting with your repo. Comment on an issue or a PR for example.
6. Navigate to `http://127.0.0.1:4040/`
  There you can see all webhooks posted to your local machine, and can replay them as many times as you wish.

## Copyright

Copyright &copy; [YouNeedABudget.com](http://youneedabudget.com), LLC. (Github: [YNAB](http://github.com/ynab))

## Author

Taylor Brown, aka [Taytay](http://github.com/Taytay)

## License

MIT License; see LICENSE for further details.
