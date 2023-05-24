// sources
local defaults = import 'argo-cd-atomic-cfg/repository-default-params.libsonnet';

function(params) {
  local rc = self,

  // Combine the defaults and the passed params to make the component's config.
  config:: defaults + params,

  assert std.isObject(rc.config.stringData) : 'field "stringData" must be an object',
  assert std.objectHas(rc.config.stringData, 'url') && std.isString(rc.config.stringData.url) : 'field "stringData.url" must be a string',

  repoCreds: {
    apiVersion: 'v1',
    kind: 'Secret',
    metadata: {
      annotations: rc.commonAnnotations,
      labels: rc.commonLabels,
      name: rc.config.name,
      namespace: rc.config.namespace,
    },
    type: 'Opaque',
    stringData: {
      [key]: (rc.config.stringData)[key]
      for key in std.objectFields(rc.config.stringData)
    },
  },

  commonAnnotations:: rc.config.commonAnnotations,
  
  commonLabels:: rc.config.commonLabels {
    'argocd.argoproj.io/secret-type': 'repo-creds'
  },

  nameGenerator:: '%s' % [
    local a = std.split(std.rstripChars(std.splitLimit(rc.config.stringData.url, '//', 1)[1], '.git'), '@');
    local f = function(input){ output: std.strReplace(std.strReplace(input, '.', '-'), '/', '-') };

    if std.length(a) > 1 then f(a[1]).output else f(a[0]).output
  ],
}