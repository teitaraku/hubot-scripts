# Description:
#   マッチしたワードに勝手に反応します
#
# Commands:
#
# Note:
#   

fs = require 'fs'

module.exports = (robot) ->
  robot.hear /(.*)/i, (res) ->
    res.send PatternResponder res

# PatternResponder
#
# 指定したファイルの行にマッチした場合に定型文を返します
# マッチしなかった場合はnullを返します
# regex\tpattern
PatternResponder = (msg) ->
  filePath = 'scripts/eavesdrop/pattern.txt'
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
