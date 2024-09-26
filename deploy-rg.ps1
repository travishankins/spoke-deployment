# Set your Azure subscription ID
$SubscriptionId = "your-subscription-id"

# Select the subscription
Select-AzSubscription -SubscriptionId $SubscriptionId

# Define the parameters file path
$ResourceGroupParams = "parameters/resourceGroup.parameters.json"

# Define the deployment name
$DeploymentName = "CreateResourceGroupDeployment-$(Get-Date -Format 'yyyyMMddTHHmmss')"

# Deploy the Resource Group
New-AzSubscriptionDeployment `
  -Name $DeploymentName `
  -Location "northcentralus" `
  -TemplateFile "modules/resourceGroup.bicep" `
  -TemplateParameterFile $ResourceGroupParams
