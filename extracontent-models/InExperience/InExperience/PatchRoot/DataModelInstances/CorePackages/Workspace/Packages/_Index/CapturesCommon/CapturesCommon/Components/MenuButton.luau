local parent = script.Parent.Parent.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

local View = Foundation.View
local Button = Foundation.Button
local ButtonSize = Foundation.Enums.ButtonSize
local ButtonVariant = Foundation.Enums.ButtonVariant

return function(props)
	return React.createElement(
		View,
		{
			AnchorPoint = props.AnchorPoint,
			LayoutOrder = props.LayoutOrder,
			Position = props.Position,
			tag = "bg-action-subtle align-x-center align-y-center auto-xy padding-bottom-medium"
		},
		{
			ShowMoreButton = React.createElement(Button, {
				onActivated = props.onActivated,
				size = ButtonSize.Small,
				text = props.text,
				variant = ButtonVariant.Subtle
			})
		}
	)
end
