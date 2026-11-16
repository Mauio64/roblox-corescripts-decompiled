local CorePackages = game:GetService("CorePackages")

local function registerInExperienceActions()
	local SduiSharedContent = require(CorePackages.Workspace.Packages.SduiSharedContent)
	SduiSharedContent.registerSharedActions()
	local ServerDrivenUi = require(CorePackages.Workspace.Packages.ServerDrivenUi)
	ServerDrivenUi.registerDiscoveryActions()
end

return registerInExperienceActions
