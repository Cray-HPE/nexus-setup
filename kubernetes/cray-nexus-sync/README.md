Copyright 2020 Hewlett Packard Enterprise Development LP


Restart jobs:

```
kubectl -n nexus get job sync-dtr.dev.cray.com -o json \
    | jq 'del(.spec.selector)' \
    | jq 'del(.spec.template.metadata.labels."controller-uid")' \
    | kubectl replace --force -f -
```
