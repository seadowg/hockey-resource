require_relative 'fakes'
require_relative 'test_utils'

require_relative '../assets/lib/out'

describe 'out' do
  it 'sends binary to hockey' do
    args = ["/working/dir"]
    stdin = FakeIO.new
    stdout = FakeIO.new
    rest_client = FakeRestClient.new
    fakefs = FakeFS.new

    rest_client.add_response(
      "https://rink.hockeyapp.net/api/2/apps/APP_ID/app_versions/upload",
      hockey_version_response_with_id(9000)
    )

    stdin.write(input_json("path" => "app.apk"))

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

    rest_client.add_response(
      "https://rink.hockeyapp.net/api/2/apps/APP_ID/app_versions/upload",
      hockey_version_response_with_id(9000)
    )

    stdin.write(input_json("path" => "app.apk"))

    action = Out.new(args, stdin, stdout, rest_client, fakefs)
    action.run

    response = JSON.parse(stdout.read)
    expect(response["version"]["ref"]).to eq("9000")
  end

  context "downloadable is true" do
    it "it specifies that version is downloadable" do
      args = ["/working/dir"]
      stdin = FakeIO.new
      stdout = FakeIO.new
      rest_client = FakeRestClient.new
      fakefs = FakeFS.new

      rest_client.add_response(
        "https://rink.hockeyapp.net/api/2/apps/APP_ID/app_versions/upload",
        hockey_version_response_with_id(9000)
      )

      stdin.write(input_json("path" => "app.apk", "downloadable" => true))

      action = Out.new(args, stdin, stdout, rest_client, fakefs)
      action.run

      request = rest_client.posts.first
      expect(request.body[:status]).to eq(2)
    end
  end

  context "downloadable is false" do
    it "it specifies that version is not downloadable" do
      args = ["/working/dir"]
      stdin = FakeIO.new
      stdout = FakeIO.new
      rest_client = FakeRestClient.new
      fakefs = FakeFS.new

      rest_client.add_response(
        "https://rink.hockeyapp.net/api/2/apps/APP_ID/app_versions/upload",
        hockey_version_response_with_id(9000)
      )

      stdin.write(input_json("path" => "app.apk", "downloadable" => false))

      action = Out.new(args, stdin, stdout, rest_client, fakefs)
      action.run

      request = rest_client.posts.first
      expect(request.body[:status]).to eq(1)
    end
  end
end