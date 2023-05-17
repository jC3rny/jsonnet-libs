# cert-manager CRDs
* source [cert-manager](https://cert-manager.io/docs/)

Use `jetstack/cert-manager-crds` as s dependency using jsonnet package manager ([jsonnet-bundler](https://github.com/jsonnet-bundler/jsonnet-bundler)).
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
          "subdir": "jetstack/cert-manager-crds"
        }
      },
      "version": "jetstack/cert-manager-crds-v0.1.1"
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
local crds = import 'cert-manager-crds/cert-manager-crds.libsonnet';

local clusterIssuer = {
  config+:: {
    namespace: 'cert-manager',
  },
  letsencryptStagingLabels:: {
    'app.kubernetes.io/component': 'cluster-issuer',
    'app.kubernetes.io/instance': 'cert-manager-crds',
    'app.kubernetes.io/name': 'cert-manager-crds',
    'app.kubernetes.io/part-of': 'cert-manager',
  },
};


// construct
local letsencryptStaging = crds.clusterIssuer(clusterIssuer.config {
  local le = self,

  name: 'letsencrypt-staging',
  commonLabels: clusterIssuer.letsencryptStagingLabels,
  acme: {
    email: 'admin@cdn.example.com',
    server: 'https://acme-staging-v02.api.letsencrypt.org/directory',
    privateKeySecretRef: {
      name: le.name + '-account-key',
    },
    solvers: [
      {
        dns01: {
          azureDNS: {
            clientID: '267a6dfd-0884-425b-8a60-ba3dc29cba97',
            clientSecretSecretRef: {
              name: 'letsencrypt-staging-azuredns-config',
              key: 'client-secret',
            },
            subscriptionID: 'f1a4d275-4a44-4287-89a9-ab0f040e9adc',
            tenantID: 'd45c11cc-ce79-4dc8-b28d-005921ba7c88',
            resourceGroupName: 'we-dev-example-cdn',
            hostedZoneName: 'cdn.example.dev',
          },
        },
      },
    ],
  },
});


// compose + patches
letsencryptStaging
```
<br />

Render output
``` shell
jsonnet -J vendor environments/default/main.jsonnet
```
``` json
{
   "clusterIssuer": {
      "apiVersion": "cert-manager.io/v1",
      "kind": "ClusterIssuer",
      "metadata": {
         "annotations": { },
         "labels": {
            "app.kubernetes.io/component": "cluster-issuer",
            "app.kubernetes.io/instance": "cert-manager-crds",
            "app.kubernetes.io/name": "cert-manager-crds",
            "app.kubernetes.io/part-of": "cert-manager"
         },
         "name": "letsencrypt-staging",
         "namespace": "cert-manager"
      },
      "spec": {
         "acme": {
            "email": "admin@cdn.example.com",
            "privateKeySecretRef": {
               "name": "letsencrypt-staging-account-key"
            },
            "server": "https://acme-staging-v02.api.letsencrypt.org/directory",
            "solvers": [
               {
                  "dns01": {
                     "azureDNS": {
                        "clientID": "267a6dfd-0884-425b-8a60-ba3dc29cba97",
                        "clientSecretSecretRef": {
                           "key": "client-secret",
                           "name": "letsencrypt-staging-azuredns-config"
                        },
                        "hostedZoneName": "cdn.example.dev",
                        "resourceGroupName": "we-dev-example-cdn",
                        "subscriptionID": "f1a4d275-4a44-4287-89a9-ab0f040e9adc",
                        "tenantID": "d45c11cc-ce79-4dc8-b28d-005921ba7c88"
                     }
                  }
               }
            ]
         }
      }
   }
}
```
