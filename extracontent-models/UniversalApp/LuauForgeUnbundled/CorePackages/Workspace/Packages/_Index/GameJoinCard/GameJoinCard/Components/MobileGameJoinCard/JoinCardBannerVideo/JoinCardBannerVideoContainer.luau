local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/React")

local JoinCardBannerVideoView = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Components/MobileGameJoinCard/JoinCardBannerVideo/JoinCardBannerVideoView")
local useJoinCardBannerVideoViewModel = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Components/MobileGameJoinCard/JoinCardBannerVideo/useJoinCardBannerVideoViewModel")

local function JoinCardBannerVideoContainer(p2)
	local v5 = useJoinCardBannerVideoViewModel(p2)
	return React.createElement(JoinCardBannerVideoView, v5)
end

return JoinCardBannerVideoContainer
