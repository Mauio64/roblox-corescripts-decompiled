local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/React")
local useTimeoutBannerProps = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Components/TimeoutBanner/useTimeoutBannerProps")
local TimeoutBanner = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Components/TimeoutBanner/TimeoutBanner")

local function TimeoutBannerContainer(p2)
	local v5 = useTimeoutBannerProps(p2)
	return React.createElement(TimeoutBanner, v5)
end

return React.memo(TimeoutBannerContainer)
