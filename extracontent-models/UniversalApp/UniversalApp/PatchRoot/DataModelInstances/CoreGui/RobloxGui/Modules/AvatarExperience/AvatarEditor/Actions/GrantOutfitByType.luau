local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)

require(CorePackages.Workspace.Packages.AvatarExperienceCommon)

return Rodux.makeActionCreator(script.Name, function(p1, n1: number) -- line: 13
	return {
		outfitTypeId = p1,
		outfitId = n1
	}
end)
