# Description:
#   Utility commands surrounding Hubot uptime.
#
# Commands:
#   hubot <全角文字> - 雑談できます
# Note:
#   load files in:
#     scripts/talk/random.txt
#     scripts/talk/pattern.txt

fs = require 'fs'

module.exports = (robot) ->
  robot.respond /(.*)/i, (res) ->
    if (res.match[1].match(/^[a-zA-Z\d\s\-\+]+$/))
      return
    r = Math.random()
    if r < 0.95
      response = PatternResponder res
      if response is null
        response = RandomResponder res
    else if r < 0.96
      response = ParrotResponder res
    else
      response = RandomResponder res
    res.send response

# RandomResponder
#
# 指定したファイルに書かれた行をランダムに選んで返します
RandomResponder = (msg) ->
  filePath = 'scripts/talk/random.txt'
  source = fs.readFileSync filePath, 'utf8'
  randomReplies = source.split("\n")
  msg.random randomReplies

# ParrotResponder
#
# オウム返しをします
ParrotResponder = (msg) ->
  msg.match[1]

# PatternResponder
#
# 指定したファイルの行にマッチした場合に定型文を返します
# マッチしなかった場合はnullを返します
# regex\tpattern
PatternResponder = (msg) ->
  filePath = 'scripts/talk/pattern.txt'
  source = fs.readFileSync filePath, 'utf8'
  input = msg.match[1]
  lines = source.split("\n")
  userName = msg.message.user.name

  for l in lines
    splitLine = l.split("\t")
    regex = splitLine[0]
    if input.match(regex)
      if splitLine[1]
        matchedWord = input.match(regex)[0]
        replacedLine = splitLine[1].replace(/%user%/g, userName)
        replacedLine = replacedLine.replace(/%match%/g, matchedWord)
        patterns = replacedLine.split("|")
        return msg.random patterns
  null
