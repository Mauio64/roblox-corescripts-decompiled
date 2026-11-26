local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceRodux/Rodux")
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceRodux/AvatarExperienceCommon")

return Rodux.makeActionCreator("SetFullView", function(p2, p3)
	return { avatarScreen = p2, fullViewStatus = p3 }
end)
