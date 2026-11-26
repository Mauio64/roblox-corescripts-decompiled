local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceRodux/Rodux")
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceRodux/AvatarExperienceCommon")

return Rodux.makeActionCreator("SetOrderForTryOns", function(p2)
	return { itemIdToOrderMap = p2 }
end)
