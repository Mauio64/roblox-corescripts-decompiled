require("@game/CorePackages/Workspace/Packages/_Workspace/SocialServerDrivenUi/SduiCoreSystem")
local avatarScreen = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialServerDrivenUi/AvatarExperienceNavigation").Enums.AvatarScreen

return function(p2, p3, p4, p5)
	p4.dependencies.getNavigation().navigate(avatarScreen.Catalog)
end
