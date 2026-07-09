local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)

require(CorePackages.Workspace.Packages.AvatarExperienceRodux)

return Rodux.makeActionCreator(script.Name, function(p1, p2, p3, p4) -- line: 22
	return {
		assetId = tostring(p1),
		moderationStatus = p2,
		assetName = p3,
		universeId = p4
	}
end)
