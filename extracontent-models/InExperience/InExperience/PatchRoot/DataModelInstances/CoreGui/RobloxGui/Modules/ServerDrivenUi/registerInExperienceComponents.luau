local CorePackages = game:GetService("CorePackages")

local function registerInExperienceComponents()
	local SduiSharedContent = require(CorePackages.Workspace.Packages.SduiSharedContent)
	SduiSharedContent.registerSharedUiComponents()
	local SduiFoundation = require(CorePackages.Workspace.Packages.SduiFoundation)
	SduiFoundation.registerFoundationComponents()
	local ServerDrivenUi = require(CorePackages.Workspace.Packages.ServerDrivenUi)
	ServerDrivenUi.registerDiscoveryUiComponents()
end

return registerInExperienceComponents
