local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")

local VideoLiftView = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/Moment/VideoLift/VideoLiftView")
local useVideoLiftViewModel = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/Moment/VideoLift/useVideoLiftViewModel")

local function VideoLiftContainer(p2)
	local v5 = useVideoLiftViewModel(p2.feedItemId)
	return React.createElement(
		VideoLiftView,
		{
			size = v5.size,
			position = v5.position,
			mediaSurface = v5.mediaSurface,
			onItemRectChanged = v5.onItemRectChanged
		},
		p2.children
	)
end

return VideoLiftContainer
