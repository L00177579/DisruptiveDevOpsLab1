param (
    [string] $resourceGroup,
    [string] $templateFilePath,
    [string] $bicepParameters
)

az deployment group create `
--resource-group $resourceGroup `
--template-file $templateFilePath `
--parameters bicepParameters `
--verbose
