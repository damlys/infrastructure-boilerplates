Lint chart

```shell script
$ helm lint
$ helm template . | kubectl apply --filename=- --dry-run=client
```

Push chart

```shell script
$ export HELM_EXPERIMENTAL_OCI="1"
$ helm chart save . "oci-registry.example.tld/http-server:0.0.0"
$ helm chart push "oci-registry.example.tld/http-server:0.0.0"
```
