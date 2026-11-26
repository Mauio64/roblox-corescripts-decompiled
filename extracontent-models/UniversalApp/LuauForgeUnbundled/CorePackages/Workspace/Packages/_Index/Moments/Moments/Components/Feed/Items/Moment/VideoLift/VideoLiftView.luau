local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Foundation")
local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/MomentsCommon")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")

local view = Foundation.View
local mediaSurfaceContext = MomentsCommon.Media.MediaSurfaceContext

local vector2 = Vector2.new(0.5, 0.5)

local function VideoLiftView(props)
	return React.createElement(
		view,
		{
			tag = "size-full",
			onAbsolutePositionChanged = props.onItemRectChanged,
			onAbsoluteSizeChanged = props.onItemRectChanged,
			testId = "--moments-item-video-lift"
		},
		{
			Media = React.createElement(
				view,
				{
					AnchorPoint = vector2,
					Position = props.position,
					Size = props.size,
					testId = "--moments-item-video-lift-media"
				},
				{
					Surface = React.createElement(
						mediaSurfaceContext.Provider,
						{ value = props.mediaSurface },
						props.children
					)
				}
			)
		}
	)
end

return VideoLiftView
