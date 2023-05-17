# "Sealed Secrets" for Kubernetes
* source [bitnami-labs/sealed-secrets](https://github.com/bitnami-labs/sealed-secrets)

Use `bitnami-labs/sealed-secrets` as s dependency using jsonnet package manager ([jsonnet-bundler](https://github.com/jsonnet-bundler/jsonnet-bundler)).
``` shell
# Initialize a new empty jsonnetfile.json
$ jb init
```
<br />

Update `jsonnetfile.json` file
``` json
{
  "version": 1,
  "dependencies": [
    {
      "source": {
        "git": {
          "remote": "https://github.com/jC3rny/jsonnet-libs.git",
          "subdir": "bitnami-labs/sealed-secrets"
        }
      },
      "version": "bitnami-labs/sealed-secrets-v0.2.1"
    }
  ],
  "legacyImports": true
}
```
<br />

Install new dependencies
``` shel
$ jb install
```
<br />

### Example usage
``` shell
$ mkdir -p environments/default
```
<br />

Create `environments/default/main.jsonnet` file
``` jsonnet
// sources
local ss = import 'sealed-secrets/sealed-secret.libsonnet';

local secretConfig = {
  config+:: {
    namespace: 'cert-manager',
    scope: 'namespace-wide',
  },
  azureDnsConfigLabels:: {
    'app.kubernetes.io/instance': 'cert-manager-crds',
    'app.kubernetes.io/name': 'cert-manager-crds',
    'app.kubernetes.io/part-of': 'cert-manager',
  },
};


// construct
local azureDnsConfigSecret = ss(secretConfig.config {
  name: 'azuredns-config',
  commonLabels: secretConfig.azureDnsConfigLabels,
  encryptedData: {
    'client-secret': 'AgCCuS1jH+9GEujxQPQ08jJKRPG+S0zi5UKCfUCNq4uqS+UaS/Fb/1ZaH/xssi0r1rHmJpCIkm5gRrr3Nwx8SnkT1Ddf7PuryjxoUGPw7BPV4EbupahOWKdT45+pAjcCSr+jEbLEJvlejs=',
  },
});


// compose + patches
azureDnsConfigSecret.sealedSecret
```
<br />

Render deployment
``` shell
jsonnet -J vendor environments/default/main.jsonnet
```
``` json
{
   "apiVersion": "bitnami.com/v1alpha1",
   "kind": "SealedSecret",
   "metadata": {
      "annotations": {
         "sealedsecrets.bitnami.com/namespace-wide": "true"
      },
      "labels": {
         "app.kubernetes.io/instance": "cert-manager-crds",
         "app.kubernetes.io/name": "cert-manager-crds",
         "app.kubernetes.io/part-of": "cert-manager"
      },
      "name": "azuredns-config-sealed",
      "namespace": "cert-manager"
   },
   "spec": {
      "encryptedData": {
         "client-secret": "AgCCuS1jH+9GEujxQPQ08jJKRPG+S0zi5UKCfUCNq4uqS+UaS/Fb/1ZaH/xssi0r1rHmJpCIkm5gRrr3Nwx8SnkT1Ddf7PuryjxoUGPw7BPV4EbupahOWKdT45+pAjcCSr+jEbLEJvlejs=",
      },
      "template": {
         "metadata": {
            "annotations": {
               "sealedsecrets.bitnami.com/managed": "true",
               "sealedsecrets.bitnami.com/namespace-wide": "true"
            },
            "labels": {
               "app.kubernetes.io/instance": "cert-manager-crds",
               "app.kubernetes.io/name": "cert-manager-crds",
               "app.kubernetes.io/part-of": "cert-manager"
            }
         },
         "type": "Opaque"
      }
   }
}
```
