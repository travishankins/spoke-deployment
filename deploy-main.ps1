# Set your Azure subscription ID
$SubscriptionId = "your-subscription-id"

# Select the subscription
Select-AzSubscription -SubscriptionId $SubscriptionId

# Define the parameters file path
$MainParams = "parameters/main.parameters.json"

# Define the deployment name
$DeploymentName = "DeployMainResources-$(Get-Date -Format 'yyyyMMddTHHmmss')"

# Deploy the main resources
New-AzSubscriptionDeployment `
  -Name $DeploymentName `
  -Location "northcentralus" `
  -TemplateFile "main.bicep" `
  -TemplateParameterFile $MainParams
