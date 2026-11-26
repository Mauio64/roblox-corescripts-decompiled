local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceRodux/Rodux")
local ArgCheck = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceRodux/ArgCheck")
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceRodux/AvatarExperienceNavigation")

return Rodux.makeActionCreator("SetAvatarSceneRoute", function(p2)
	ArgCheck.isType(p2, "table", "avatarRoute")
	return { avatarRoute = p2 }
end)
