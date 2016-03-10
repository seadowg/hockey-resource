def hockey_version_response_with_id(id)
  <<-json
    {"version":"#{id}","shortversion":"0.4.0","title":"Disruptions","timestamp":1457610555,"appsize":1051559,"notes":"","mandatory":false,"external":false,"device_family":null,"id":9000,"app_id":281017,"minimum_os_version":"4.3","config_url":"https://rink.hockeyapp.net/manage/apps/281017/app_versions/3","restricted_to_tags":false,"status":1,"tags":[],"expired_at":null,"created_at":"2016-03-10T11:49:15Z","updated_at":"2016-03-10T11:49:15Z","sdk_version":null,"block_crashes":false,"app_owner":"Dis"}
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
