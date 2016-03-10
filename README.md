## hockey-resource

```yaml
resource_types:
  - name: hockey
    type: docker-image
    source:
      repository: seadowg/hockey-resource

resources:
  - name: app-repo
    type: git
    source:
      uri: https://github.com/user/app.git
      branch: master

  - name: hockey
    type: hockey
    source:
      app_id: APP_ID
      token: TOKEN

jobs:
  - name: package
    plan:
      - get: app-repo
        trigger: true
      - task: package
        file: app-repo/concourse/tasks/package.yml
      - put: hockey
        params:
          path: package/app.apk
```
