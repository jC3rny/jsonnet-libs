// sources
local defaults = import 'cert-manager-crds/cluster-issuer-default-params.libsonnet';

function(params) {
  local ci = self,

  // Combine the defaults and the passed params to make the component's config.
  config:: defaults + params,

  clusterIssuer: {
    apiVersion: 'cert-manager.io/v1',
    kind: 'ClusterIssuer',
    metadata: {
      annotations: ci.commonAnnotations,
      labels: ci.commonLabels,
      name: ci.config.name,
      namespace: ci.config.namespace,
    },
    spec: 
      local acme = (
        // Safety checks for combined config of defaults and params
        assert std.objectHas(ci.config.acme, 'email') && std.isString(ci.config.acme.email) : 'field "acme.email" must be a string';
        assert std.objectHas(ci.config.acme, 'server') && std.isString(ci.config.acme.email) : 'field "acme.server" must be a string';
        assert std.objectHas(ci.config.acme, 'privateKeySecretRef') && std.isObject(ci.config.acme.privateKeySecretRef) : 'field "acme.privateKeySecretRef" must be an object';
        assert std.objectHas(ci.config.acme.privateKeySecretRef, 'name') && std.isString(ci.config.acme.privateKeySecretRef.name) : 'field "acme.privateKeySecretRef.name" must be a string';
        assert std.objectHas(ci.config.acme, 'solvers') && std.isArray(ci.config.acme.solvers) : 'field "acme.solvers" must be an array';

        {
          [key]: (ci.config.acme)[key]
          for key in std.objectFields(ci.config.acme)
          if !std.isArray((ci.config.acme)[key])
        } +
        {
          solvers: [
            solver
            for solver in ci.config.acme.solvers
          ],
        }
      );
    
    {
      // ACME Issuer
      [if std.objectHas(ci.config, 'acme') && std.isObject(ci.config.acme) then 'acme']: acme,
    },
  },

  commonAnnotations:: ci.config.commonAnnotations,
  
  commonLabels:: ci.config.commonLabels,
}
