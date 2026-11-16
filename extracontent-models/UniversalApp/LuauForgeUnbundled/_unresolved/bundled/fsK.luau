local avatarRouteContext = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").AvatarRoute.Context.AvatarRouteContext
local module = require("@luauforge/bundled/fsL")

return function(p2, p3)
	return module(p2, avatarRouteContext.Consumer, "avatarRoute", p3)
end
