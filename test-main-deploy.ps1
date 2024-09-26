az deployment sub validate `
  --name "DeployMainResources" `
  --location "northcentralus" `
  --template-file "main.bicep" `
  --parameters "parameters/params.json"
