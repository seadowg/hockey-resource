require_relative '../assets/lib/out'

INPUT_JSON = <<-json
  {
    "source": {
      "app_id": "APP_ID",
      "token": "TOKEN"
    },
    "params": {
      "path": "app.apk"
    }
  }
  json

HOCKEY_RESPONSE = <<-json
  {"version":"9000","shortversion":"0.4.0","title":"Disruptions","timestamp":1457610555,"appsize":1051559,"notes":"","mandatory":false,"external":false,"device_family":null,"id":9000,"app_id":281017,"minimum_os_version":"4.3","config_url":"https://rink.hockeyapp.net/manage/apps/281017/app_versions/3","restricted_to_tags":false,"status":1,"tags":[],"expired_at":null,"created_at":"2016-03-10T11:49:15Z","updated_at":"2016-03-10T11:49:15Z","sdk_version":null,"block_crashes":false,"app_owner":"Dis"}
  json

class FakeIO
  def initialize
    @buffer = []
  end

  def write(input)
    @buffer << input
  end

  def read
    @buffer.pop
  end
end

class FakeRestClient
  def initialize
    @response_map = {}
    @posts = []
  end

  def add_response(url, response)
    @response_map[url] = response
  end

  def post(url, body, headers = {})
    @posts << FakePost.new(url, body, headers)

    if @response_map[url]
      @response_map[url]
    else
      ""
    end
  end

  def posts
    @posts
  end
end

class FakePost
  attr_reader :url
  attr_reader :headers
  attr_reader :body

  def initialize(url, body, headers)
    @url = url
    @headers = headers
    @body = body
  end
end

class FakeFS
  def get(path)
    FakeFile.new(path)
  end
end

class FakeFile
  attr_reader :path

  def initialize(path)
    @path = path
  end
end

describe 'out' do  
  it 'sends binary to hockey' do
    args = ["/working/dir"]
    stdin = FakeIO.new
    stdout = FakeIO.new
    rest_client = FakeRestClient.new
    fakefs = FakeFS.new

    rest_client.add_response("https://rink.hockeyapp.net/api/2/apps/APP_ID/app_versions/upload", HOCKEY_RESPONSE)
    stdin.write(INPUT_JSON)

    action = Out.new(args, stdin, stdout, rest_client, fakefs)
    action.run

    expect(rest_client.posts.count).to eq(1)

    request = rest_client.posts.first
    expect(request.url).to eq("https://rink.hockeyapp.net/api/2/apps/APP_ID/app_versions/upload")
    expect(request.headers).to eq({ "X-HockeyAppToken" => "TOKEN" })
    expect(request.body[:ipa].path).to eq("/working/dir/app.apk")
  end

  it 'returns the new version id' do
    args = ["/working/dir"]
    stdin = FakeIO.new
    stdout = FakeIO.new
    rest_client = FakeRestClient.new
    fakefs = FakeFS.new

    rest_client.add_response("https://rink.hockeyapp.net/api/2/apps/APP_ID/app_versions/upload", HOCKEY_RESPONSE)
    stdin.write(INPUT_JSON)

    action = Out.new(args, stdin, stdout, rest_client, fakefs)
    action.run

    response = JSON.parse(stdout.read)
    expect(response["version"]["ref"]).to eq("9000")
  end
end
