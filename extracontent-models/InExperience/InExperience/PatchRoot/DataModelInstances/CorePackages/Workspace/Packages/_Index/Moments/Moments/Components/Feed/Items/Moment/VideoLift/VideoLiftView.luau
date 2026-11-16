local parent = script:FindFirstAncestor("Moments").Parent

local Foundation = require(parent.Foundation)
local MomentsCommon = require(parent.MomentsCommon)
local React = require(parent.React)

local View = Foundation.View
local MediaSurfaceContext = MomentsCommon.Media.MediaSurfaceContext

local vector2 = Vector2.new(0.5, 0.5)

local function VideoLiftView(props)
	return React.createElement(
		View,
		{
			tag = "size-full",
			onAbsolutePositionChanged = props.onItemRectChanged,
			onAbsoluteSizeChanged = props.onItemRectChanged,
			testId = "--moments-item-video-lift"
		},
		{
			Media = React.createElement(
				View,
				{
					AnchorPoint = vector2,
					Position = props.position,
					Size = props.size,
					testId = "--moments-item-video-lift-media"
				},
				{
					Surface = React.createElement(
						MediaSurfaceContext.Provider,
						{ value = props.mediaSurface },
						props.children
					)
				}
			)
		}
	)
end

return VideoLiftView
