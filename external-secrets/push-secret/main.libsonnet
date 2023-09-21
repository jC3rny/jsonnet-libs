// construct
{
  metadata: {
    withAnnotations(annotations): { metadata+: { annotations: annotations } },
    withLabels(labels): { metadata+: { labels: labels } },
    withName(name): { metadata+: { name: name } },
    // Same of the SecretStores
    withNamespace(namespace): { metadata+: { namespace: namespace } },
  },
  new(name): {
    apiVersion: 'external-secrets.io/v1alpha1',
    kind: 'PushSecret',
  } + self.metadata.withName(name=name),
  spec: {
    // Secret store to push secrets to
    secretStoreRefs: {
      withKind(kind): { kind: kind },
      withName(name): { name: name },
    },
    selector: {
      secret: {
        withName(name): { spec+: { selector+: { secret+: { name: name } } } },
      },
    },
    data: {
      match: {
        remoteRef: {
          // Remote reference (where the secret is going to be pushed)
          withRemoteKey(remoteKey): { match+: { remoteRef+: { remoteKey: remoteKey } } },
        },
        // Source Kubernetes secret key to be pushed
        withSecretKey(secretKey): { match+: { secretKey: secretKey } },
      },
    },
    // Refresh interval for which push secret will reconcile
    withRefreshInterval(refreshInterval): { spec+: { refreshInterval: refreshInterval } },
    // A list of secret stores to push secrets to
    withSecretStoreRefs(secretStoreRefs): { spec+: { secretStoreRefs: if std.isArray(v=secretStoreRefs) then secretStoreRefs else [secretStoreRefs] } },
    withData(data): { spec+: { data: if std.isArray(v=data) then data else [data] } },
  },
}
