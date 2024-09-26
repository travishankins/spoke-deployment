## **Step 1: Set Your Azure Subscription**

You need to set the correct subscription where you want to deploy your resources.

1. Open **PowerShell** and run the following commands:

   ```powershell
   # Set your Azure subscription ID
   $SubscriptionId = "your-subscription-id"

   # Select the subscription
   Select-AzSubscription -SubscriptionId $SubscriptionId
   ```

---

## **Step 2: Deploy the Resource Group**

The Resource Group must be created before deploying any other resources.

1. Create the Resource Group by running this command:

   ```powershell
   # Define the parameters file path
   $ResourceGroupParams = "parameters/resourceGroup.parameters.json"

   # Define the deployment name
   $DeploymentNameRG = "CreateResourceGroupDeployment-$(Get-Date -Format 'yyyyMMddTHHmmss')"

   # Deploy the Resource Group
   New-AzSubscriptionDeployment `
     -Name $DeploymentNameRG `
     -Location "northcentralus" `
     -TemplateFile "modules/resourceGroup.bicep" `
     -TemplateParameterFile $ResourceGroupParams
   ```

   **Result:** The Resource Group will be created in the specified Azure region.

---

## **Step 3: Deploy the Networking Resources**

Once the Resource Group has been created, proceed to deploy the networking resources.

1. Run the following PowerShell command to deploy the networking resources, resource group lock, and role assignments:

   ```powershell
   # Define the parameters file path
   $MainParams = "parameters/main.parameters.json"

   # Define the deployment name
   $DeploymentNameMain = "DeployMainResources-$(Get-Date -Format 'yyyyMMddTHHmmss')"

   # Deploy the main resources
   New-AzSubscriptionDeployment `
     -Name $DeploymentNameMain `
     -Location "northcentralus" `
     -TemplateFile "main.bicep" `
     -TemplateParameterFile $MainParams
   ```

   **Result:** This will deploy the networking resources, apply resource locks, and assign the roles at the subscription level.

---
