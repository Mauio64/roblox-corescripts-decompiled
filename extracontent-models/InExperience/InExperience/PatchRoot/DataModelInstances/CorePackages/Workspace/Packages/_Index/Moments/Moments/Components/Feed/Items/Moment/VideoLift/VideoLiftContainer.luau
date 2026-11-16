local parent = script:FindFirstAncestor("Moments").Parent

local React = require(parent.React)

local VideoLiftView = require(script.Parent.VideoLiftView)
local useVideoLiftViewModel = require(script.Parent.useVideoLiftViewModel)

local function VideoLiftContainer(p)
	local v = useVideoLiftViewModel(p.feedItemId)
	return React.createElement(
		VideoLiftView,
		{
			size = v.size,
			position = v.position,
			mediaSurface = v.mediaSurface,
			onItemRectChanged = v.onItemRectChanged
		},
		p.children
	)
end

return VideoLiftContainer
