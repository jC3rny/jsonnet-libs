// These are the defaults for this components configuration.
// When calling the function to generate the component's manifest,
// you can pass an object structured like the default to overwrite default values.
{
  local defaults = self,
  
  name: error 'must provide name',
  namespace: error 'must provide namespace',
  stringData: {},
  
  commonAnnotations:: {},
  commonLabels:: {},
}