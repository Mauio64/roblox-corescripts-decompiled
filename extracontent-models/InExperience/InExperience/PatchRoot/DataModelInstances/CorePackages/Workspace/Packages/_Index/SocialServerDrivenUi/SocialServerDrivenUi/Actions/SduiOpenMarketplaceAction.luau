local Parent = script:FindFirstAncestor("SocialServerDrivenUi").Parent

require(Parent.SduiCoreSystem)

local AvatarScreen = require(Parent.AvatarExperienceNavigation).Enums.AvatarScreen

return function(_, _, p3, _) -- line: 12
	-- upvalues: AvatarScreen (copy)
	p3.dependencies.getNavigation().navigate(AvatarScreen.Catalog)
end
