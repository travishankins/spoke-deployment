az deployment sub validate `
  --name "CreateResourceGroupDeployment" `
  --location "northcentralus" `
  --template-file "modules/resourceGroup.bicep" `
  --parameters "parameters/params.json"
