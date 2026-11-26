local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/React")
local AdaptiveScrollingContext = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Hooks/AdaptiveScrollingContext")

local function useAdaptiveScrolling()
	return React.useContext(AdaptiveScrollingContext)
end

return useAdaptiveScrolling
