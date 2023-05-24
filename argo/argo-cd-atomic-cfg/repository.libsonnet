// sources
local defaults = import 'argo-cd-atomic-cfg/repository-default-params.libsonnet';

function(params) {
  local r = self,

  // Combine the defaults and the passed params to make the component's config.
  config:: defaults + params,

  assert std.isObject(r.config.stringData) : 'field "stringData" must be an object',
  assert std.objectHas(r.config.stringData, 'url') && std.isString(r.config.stringData.url) : 'field "stringData.url" must be a string',

  repository: {
    apiVersion: 'v1',
    kind: 'Secret',
    metadata: {
      annotations: r.commonAnnotations,
      labels: r.commonLabels,
      name: r.config.name,
      namespace: r.config.namespace,
    },
    type: 'Opaque',
    stringData: {
      [key]: (r.config.stringData)[key]
      for key in std.objectFields(r.config.stringData)
    },
  },

  commonAnnotations:: r.config.commonAnnotations,
  
  commonLabels:: r.config.commonLabels {
    'argocd.argoproj.io/secret-type': 'repository'
  },

  nameGenerator:: '%s' % [
    local a = std.split(std.rstripChars(std.splitLimit(r.config.stringData.url, '//', 1)[1], '.git'), '@');
    local f = function(input){ output: std.strReplace(std.strReplace(input, '.', '-'), '/', '-') };

    if std.length(a) > 1 then f(a[1]).output else f(a[0]).output
  ],
}