# Description
#   A hubot script that creates latex formula images and upload it to Slack.
#
# Commands:
#   hubot formula - create latex formula images and upload it
#
# Author:
#   knjcode <knjcode@gmail.com>

fs = require 'fs'
path = require 'path'
exec = require('child_process').exec

module.exports = (robot) ->

  robot.respond /formula((.*\s*)+)/i, (msg) ->
    formula = msg.match[1].split('\n').join(' ').trim()
    formula = formula[1...-1] if /^\$.*\$$/.test formula

    scriptPath = path.resolve __dirname
    cmd = "#{scriptPath}/create_formula_image.sh #{scriptPath} '#{formula}'"
    robot.logger.debug "Formula: #{formula}"

    exec cmd, (error, stdout, stderr) ->
      if error
        msg.send 'Oops! Failed to create formula image.'
        robot.logger.debug error
        return

      data =
        file: fs.createReadStream(scriptPath + '/result.png')
        channels: msg.envelope.room
      fileName = "formula_from_#{robot.name}.png"

      if robot.adapter?.client?.web?
        web = robot.adapter.client.web
      else
        # for hubot-slack v3 compatibility
        webClient = require('@slack/client').WebClient
        token = process.env.HUBOT_SLACK_TOKEN ? ''
        web = new webClient token

      web.files.upload fileName, data, (err, res) ->
        robot.logger.debug err if err
        robot.logger.debug res unless res.ok
