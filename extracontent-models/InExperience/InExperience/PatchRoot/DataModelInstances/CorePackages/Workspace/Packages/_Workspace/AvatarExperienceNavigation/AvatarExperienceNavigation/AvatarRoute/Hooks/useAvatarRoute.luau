local AvatarExperienceNavigation = script:FindFirstAncestor("AvatarExperienceNavigation")
local AvatarExperienceNavigationParent = AvatarExperienceNavigation.Parent
local React = require(AvatarExperienceNavigationParent.React)
local ArgCheck = require(AvatarExperienceNavigationParent.ArgCheck)
local AvatarRouteContext = require(AvatarExperienceNavigation.AvatarRoute.Context.AvatarRouteContext)

require(AvatarExperienceNavigation.AvatarRoute.Types)

local function useAvatarRoute() -- line: 16
	-- upvalues: React (copy), AvatarRouteContext (copy), ArgCheck (copy)
	local v7 = React.useContext(AvatarRouteContext)

	return ArgCheck.isNotNil(v7, "AvatarRouteContext")
end

return useAvatarRoute
