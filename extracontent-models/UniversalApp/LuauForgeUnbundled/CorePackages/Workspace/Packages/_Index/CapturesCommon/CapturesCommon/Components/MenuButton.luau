local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/CapturesCommon/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/CapturesCommon/React")

local view = Foundation.View
local button = Foundation.Button
local buttonSize = Foundation.Enums.ButtonSize
local buttonVariant = Foundation.Enums.ButtonVariant

return function(props)
	return React.createElement(
		view,
		{
			AnchorPoint = props.AnchorPoint,
			LayoutOrder = props.LayoutOrder,
			Position = props.Position,
			tag = "bg-action-subtle align-x-center align-y-center auto-xy padding-bottom-medium"
		},
		{
			ShowMoreButton = React.createElement(button, {
				onActivated = props.onActivated,
				size = buttonSize.Small,
				text = props.text,
				variant = buttonVariant.Subtle
			})
		}
	)
end
