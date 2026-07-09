local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local Rodux = require(CorePackages.Packages.Rodux)
local Modules = CoreGui.RobloxGui.Modules

require(Modules.AvatarExperience.Common.Types)
require(CorePackages.Workspace.Packages.AvatarExperienceRodux)
require(CorePackages.Workspace.Packages.AvatarExperienceCommon)

return Rodux.makeActionCreator(script.Name, function(p1, p2, n1: number?, p3) -- line: 22
	return {
		assetTypeId = p1,
		assetId = p2,
		overrideOrder = n1,
		overrideAdjustments = p3
	}
end)
