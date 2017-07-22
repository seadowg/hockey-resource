require 'json'

class Out
  def initialize(args, stdin, stdout, rest_client, file_system)
    @args = args
    @rest_client = rest_client
    @stdin = stdin
    @stdout = stdout
    @file_system = file_system
  end

  def run
    input = @stdin.read
    json_args = JSON.parse(input)
    path = json_args['params']['path']
    responses = @file_system.get("#{@args[0]}/#{path}").map do |apk|
      upload(apk, json_args)
    end
    output = responses.map { |r| parse_response(r) }
    @stdout.write(JSON.generate(output))
  end

  private

  def parse_response(respose)
    version = JSON.parse(respose)
    {
      version: { ref: version['id'].to_s },
      metadata: [
        { name: 'Version Code', value: version['version'] },
        { name: 'Version Page', value: version['config_url'] }
      ]
    }
  end

  def upload(apk, json)
    app_id = json['source']['app_id']
    token = json['source']['token']
    downloadable = json['params']['downloadable']
    @rest_client.post(
      "https://rink.hockeyapp.net/api/2/apps/#{app_id}/app_versions/upload",
      { ipa: apk, status: downloadable ? 2 : 1 },
      'X-HockeyAppToken' => token
    )
  end
end
