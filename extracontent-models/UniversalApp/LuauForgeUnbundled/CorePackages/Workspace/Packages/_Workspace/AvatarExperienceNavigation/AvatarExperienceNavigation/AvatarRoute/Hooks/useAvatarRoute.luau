local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceNavigation/React")
local ArgCheck = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceNavigation/ArgCheck")
local AvatarRouteContext = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceNavigation/AvatarExperienceNavigation/AvatarRoute/Context/AvatarRouteContext")
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceNavigation/AvatarExperienceNavigation/AvatarRoute/Types")

local function useAvatarRoute()
	local v5 = React.useContext(AvatarRouteContext)
	return ArgCheck.isNotNil(v5, "AvatarRouteContext")
end

return useAvatarRoute
