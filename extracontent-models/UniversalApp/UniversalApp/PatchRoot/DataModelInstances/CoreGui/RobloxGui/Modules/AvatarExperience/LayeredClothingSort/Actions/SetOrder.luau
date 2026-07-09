local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Rodux = require(CorePackages.Packages.Rodux)

require(Modules.AvatarExperience.Common.Types)

return Rodux.makeActionCreator(script.Name, function(p1) -- line: 11
	return {
		assetIdToOrderAndAssetTypeId = p1
	}
end)
