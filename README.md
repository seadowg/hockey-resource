## hockey-resource

```yaml
resource_types:
  - name: hockey
    type: docker-image
    source:
      repository: seadowg/hockey-resource

resources:
  - name: github
    type: git
    source:
      uri: https://github.com/robolectric/deckard.git
      branch: master

  - name: hockey
    type: hockey
    source:
      app_id: APP_ID
      token: TOKEN

jobs:
  - name: package
    plan:
      - get: github
        trigger: true
        passed: [test]
      - task: package
        file: github/concourse/tasks/package.yml
      - put: hockey
        params:
          path: package/app.apk
```
