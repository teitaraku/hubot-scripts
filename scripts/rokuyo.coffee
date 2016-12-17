# Description:
#   tell me rokuyo
#
# Commands:
#   hubot <rokuyo> - 今日の六曜を返します
#
# Notes:
#   

module.exports = (robot) ->
  robot.respond /rokuyo|六曜/i, (msg) ->
    request = robot.http("http://api.sekido.info/qreki")
                   .query(output: 'json')
                   .get()
    request (err, res, body) ->
      json = JSON.parse body
      rokuyo = json['rokuyou']

      switch rokuyo
        when 0
          responseMessage = """
          本日は大安なり。
          大安。大いに安し。何をするにも成功しないことはない日。
          """
        when 1
          responseMessage = """
          赤口。正午だけが吉。午前中、午後は凶。
          """
        when 2
          responseMessage = """
          先勝。先んずれば即ち勝つ。午前中が吉、午後２時から６時は凶。
          """
        when 3
          responseMessage = """
          友引。凶事に友を引く朝は吉、昼は凶、夕は大吉。
          """
        when 4
          responseMessage = """
          先負。先んずれば即ち負ける。午前中は凶、午後は吉。
          """
        when 5
          responseMessage = """
          仏滅。仏も滅するような大凶日。
          """
        else
          responseMessage = "エラー"

      msg.send "#{responseMessage}"
