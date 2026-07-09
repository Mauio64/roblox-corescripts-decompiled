local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)

require(CorePackages.Workspace.Packages.AvatarExperienceRodux)
require(CorePackages.Workspace.Packages.AvatarExperienceCommon)

return Rodux.makeActionCreator(script.Name, function(p1, p2, p3) -- line: 18
	return {
		assetId = p1,
		assetTypeId = p2,
		recommendedItems = p3
	}
end)
