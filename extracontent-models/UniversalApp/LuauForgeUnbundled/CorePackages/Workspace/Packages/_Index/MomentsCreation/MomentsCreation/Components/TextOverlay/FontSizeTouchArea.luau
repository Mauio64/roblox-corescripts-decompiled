local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/React")

local view = Foundation.View

local function FontSizeTouchArea(props)
	return React.createElement(
		view,
		{
			ref = props.touchAreaRef,
			tag = "size-full",
			testId = "font-size-slider-touch-area",
			ZIndex = props.ZIndex
		},
		{
			DragDetector = React.createElement("UIDragDetector", {
				DragStyle = Enum.UIDragDetectorDragStyle.Scriptable,
				SelectionModeDragSpeed = UDim2.new(),
				[React.Event.DragStart] = props.onDragStarted,
				[React.Event.DragContinue] = props.onDrag
			})
		}
	)
end

return FontSizeTouchArea
