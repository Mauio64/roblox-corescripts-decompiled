local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)

require(CorePackages.Workspace.Packages.AvatarExperienceRodux)

return Rodux.makeActionCreator(script.Name, function(p1, b1: boolean) -- line: 12
	return {
		assetId = p1,
		isOwned = b1
	}
end)
