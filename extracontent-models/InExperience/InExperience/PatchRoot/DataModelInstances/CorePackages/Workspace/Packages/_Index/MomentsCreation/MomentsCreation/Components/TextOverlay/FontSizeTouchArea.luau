local parent = script:FindFirstAncestor("MomentsCreation").Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

local View = Foundation.View

local function FontSizeTouchArea(props)
	return React.createElement(
		View,
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
