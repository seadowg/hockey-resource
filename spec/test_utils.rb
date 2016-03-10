def hockey_version_response(id: 10, version: 9000, config_url: "http://example.com")
  <<-json
    {"version":"#{version}","shortversion":"0.4.0","title":"Disruptions","timestamp":1457610555,"appsize":1051559,"notes":"","mandatory":false,"external":false,"device_family":null,"id":#{id},"app_id":281017,"minimum_os_version":"4.3","config_url":"#{config_url}","restricted_to_tags":false,"status":1,"tags":[],"expired_at":null,"created_at":"2016-03-10T11:49:15Z","updated_at":"2016-03-10T11:49:15Z","sdk_version":null,"block_crashes":false,"app_owner":"Dis"}
    json
end

def input_json(params)
  json = JSON.parse(<<-json)
    {
      "source": {
        "app_id": "APP_ID",
        "token": "TOKEN"
      }
    }
    json

  json["params"] = params
  json.to_json
end
