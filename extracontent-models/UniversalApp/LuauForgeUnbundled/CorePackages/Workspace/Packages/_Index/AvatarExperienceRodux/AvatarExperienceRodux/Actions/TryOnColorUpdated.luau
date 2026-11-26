local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceRodux/Rodux")

require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceRodux/AvatarExperienceCommon")

return Rodux.makeActionCreator("TryOnColorUpdated", function(p2, p3)
	return { colors = p2, bodyPartColorRangeIds = p3 }
end)
