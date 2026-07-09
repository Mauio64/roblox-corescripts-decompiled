local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)

require(CorePackages.Workspace.Packages.AvatarExperienceRodux)

return Rodux.makeActionCreator(script.Name, function(p1, p2) -- line: 13
	return {
		assetId = p1,
		assetData = p2
	}
end)
