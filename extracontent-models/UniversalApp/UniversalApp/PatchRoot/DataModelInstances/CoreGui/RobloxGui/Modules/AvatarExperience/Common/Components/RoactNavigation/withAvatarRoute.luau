local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local AvatarRouteContext = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).AvatarRoute.Context.AvatarRouteContext
local withContextValue = require(Modules.AvatarExperience.Common.withContextValue)

return function(p1, p2) -- line: 18
	-- upvalues: withContextValue (copy), AvatarRouteContext (copy)
	return withContextValue(p1, AvatarRouteContext.Consumer, "avatarRoute", p2)
end
