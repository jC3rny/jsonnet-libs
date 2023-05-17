// These are the defaults for this components configuration.
// When calling the function to generate the component's manifest,
// you can pass an object structured like the default to overwrite default values.
{
  local defaults = self,
  name: error 'must provide name',
  namespace: error 'must provide namespace',
  // Issuer Configuration https://cert-manager.io/docs/configuration/
  /*
  acme: {
      // You must replace this email address with your own.
      // Let's Encrypt will use this to contact you about expiring
      // certificates, and issues related to your account.
      email: 'user@example.com',
      server: 'https://acme-staging-v02.api.letsencrypt.org/directory',
      privateKeySecretRef: {
        // Secret resource that will be used to store the account's private key.
        name: 'example-issuer-account-key',
      },
      solvers: [
        {
          dns01: {
            azureDNS: {
              clientID: 'AZURE_CERT_MANAGER_SP_APP_ID',
              clientSecretSecretRef: {
              # The following is the secret we created in Kubernetes. Issuer will use this to present challenge to Azure DNS.
                name: 'azuredns-config',
                key: 'client-secret',
              },
              subscriptionID: 'AZURE_SUBSCRIPTION_ID',
              tenantID: 'AZURE_TENANT_ID',
              resourceGroupName: 'AZURE_DNS_ZONE_RESOURCE_GROUP',
              hostedZoneName: 'AZURE_DNS_ZONE',
              # Azure Cloud Environment, default to AzurePublicCloud
              environment: 'AzurePublicCloud',
            },
          },
        },
      ],
    },
  */
  commonAnnotations:: {},
  commonLabels:: {},
}
