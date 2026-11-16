local AvatarExperienceNavigation = script:FindFirstAncestor("AvatarExperienceNavigation")
local parent = AvatarExperienceNavigation.Parent
local React = require(parent.React)
local ArgCheck = require(parent.ArgCheck)
local AvatarRouteContext = require(AvatarExperienceNavigation.AvatarRoute.Context.AvatarRouteContext)
require(AvatarExperienceNavigation.AvatarRoute.Types)

local function useAvatarRoute()
	local v = React.useContext(AvatarRouteContext)
	return ArgCheck.isNotNil(v, "AvatarRouteContext")
end

return useAvatarRoute
