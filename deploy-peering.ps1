   # Define the parameters file path
   $PeeringParams = "parameters/vnetPeering.json"

   # Define the deployment name (use a unique timestamp)
   $DeploymentNamePeer = "DeployPeerResources-$(Get-Date -Format 'yyyyMMddTHHmmss')"

   # Deploy the Bicep file at the subscription level
   New-AzSubscriptionDeployment `
   -Name $DeploymentNamePeer `
   -Location "northcentralus" `
   -TemplateFile "createPeering.bicep" `
   -TemplateParameterFile $PeeringParams