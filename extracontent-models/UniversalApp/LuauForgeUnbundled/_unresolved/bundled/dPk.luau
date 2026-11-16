local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)

require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")

return Rodux.makeActionCreator("AddNewOutfitNotification", function(p2)
	return { outfitType = p2 }
end)
