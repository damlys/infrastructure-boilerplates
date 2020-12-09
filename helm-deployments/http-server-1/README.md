Pull chart

```shell script
$ export HELM_EXPERIMENTAL_OCI="1"
$ helm chart pull "oci-registry.example.tld/http-server:0.0.0"
$ helm chart export "oci-registry.example.tld/http-server:0.0.0"
```

Deploy

```shell script
$ helm \
  --kube-context="example-cluster" \
  --namespace="example-namespace" \
  upgrade "http-server-1" ./http-server \
  --values="./values.yaml" \
  --install \
  --timeout="30s"

$ kubectl \
  --context="example-cluster" \
  --namespace="example-namespace" \
  rollout status deployment "http-server-1-http-server" \
  --timeout="30s"
```

Run smoke tests

```shell script
$ helm \
  --kube-context="example-cluster" \
  --namespace="example-namespace" \
  test "http-server-1" \
  --timeout="30s"
```

Destroy

```shell script
$ helm \
  --kube-context="example-cluster" \
  --namespace="example-namespace" \
  uninstall "http-server-1" \
  --timeout="30s"

$ kubectl \
  --context="example-cluster" \
  --namespace="example-namespace" \
  wait pod \
  --selector="app.kubernetes.io/instance=http-server-1,app.kubernetes.io/component=http-server" \
  --for="delete" \
  --timeout="30s"
```

Rollback

```shell script
$ helm \
  --kube-context="example-cluster" \
  --namespace="example-namespace" \
  rollback "http-server-1" \
  --timeout="30s"

$ kubectl \
  --context="example-cluster" \
  --namespace="example-namespace" \
  rollout status deployment "http-server-1-http-server" \
  --timeout="30s"
```
