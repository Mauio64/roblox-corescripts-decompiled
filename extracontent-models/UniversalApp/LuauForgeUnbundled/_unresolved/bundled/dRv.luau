local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)

require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")

return Rodux.makeActionCreator("GrantOutfitByType", function(p2, p3)
	return { outfitTypeId = p2, outfitId = p3 }
end)
