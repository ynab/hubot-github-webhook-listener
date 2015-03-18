# Description:
#   Listens for github webhooks and emits an event for other Hubot scripts to respond to.
#   Inspired _heavily_ (with some verbatim copying) by hubot-github-repo-event-notifier
#
# Configuration:
#
#   1. Create a new webhook for your `myuser/myrepo` repository at:
#      https://github.com/myuser/myrepo/settings/hooks/new
#      Set the webhook url to: <HUBOT_URL>:<PORT>/hubot/github-repo-listener[?param1=value1&param2=value2]
#
#   Incoming webhooks are emitted as events with the name github-repo-event
#   The body of the event is:
#      {
#          eventType,   # The name of the event
#          data,        # The full parsed object body of the posted event
#          query        # The parsed query string of the posted event
#      }
# Commands:
#   None
#
# URLS:
#   POST /hubot/github-repo-listener[?param1=value1&param2=value2]
#
# Notes:
#   For easy local testing, I highly recommend ngrok: https://ngrok.com/
#   1. Install ngrok
#   2. run ngrok: `ngrok 8080`.
#      It will show you a public URL like: `Forwarding  https://7a008da9.ngrok.com -> 127.0.0.1:8080`
#   3. Put that URL in as your Github webhook: `https://7a008da9.ngrok.com/hubot/github-repo-listener`
#   4. Run hubot locally: `HUBOT_GITHUB_TOKEN=some_log_guid bin/hubot -a github --name Hubot`
#   5. Fire off a github event by interacting with your repo. Comment on an issue or a PR for example.
#   6. Navigate to `http://127.0.0.1:4040/`
#      There you can see all webhooks posted to your local machine, and can replay them as many times as you wish.
#
# Authors:
#   Taytay
#   Using code written by: spajus, patcon, and parkr

url           = require('url')
querystring   = require('querystring')

debug = false

module.exports = (robot) ->

  #TODO: Introduce secret so that these are verified:
  # See: https://developer.github.com/webhooks/securing/ and
  # https://gist.github.com/dcollien/c5d86c968cbc85e88286
  robot.router.post "/hubot/github-repo-listener", (req, res) ->
    try
      if (debug)
        robot.logger.info("Github post received: ", req)
      eventBody =
        eventType   : req.headers["x-github-event"]
        signature   : req.headers["X-Hub-Signature"]
        deliveryId  : req.headers["X-Github-Delivery"]
        payload     : req.body
        query       : querystring.parse(url.parse(req.url).query)

      robot.emit "github-repo-event", eventBody
    catch error
      robot.logger.error "Github repo webhook listener error: #{error.stack}. Request: #{req.body}"

    res.end ""
