$Region = "WestUS2"
$ResourceGroup = "cosmos-db-lab"
Login-AzureRmAccount
New-AzureRmResourceGroup -Name $ResourceGroup -Location $Region
New-AzureRmResourceGroupDeployment -ResourceGroupName $ResourceGroup -TemplateFile .\infrastructure\arm-template.json -Name "lab"
