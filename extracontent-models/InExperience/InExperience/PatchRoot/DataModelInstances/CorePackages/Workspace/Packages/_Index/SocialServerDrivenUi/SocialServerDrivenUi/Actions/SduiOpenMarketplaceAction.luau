local parent = script:FindFirstAncestor("SocialServerDrivenUi").Parent

require(parent.SduiCoreSystem)
local AvatarExperienceNavigation = require(parent.AvatarExperienceNavigation)
local AvatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen

return function(_, _, p, _)
	p.dependencies.getNavigation().navigate(AvatarScreen.Catalog)
end
