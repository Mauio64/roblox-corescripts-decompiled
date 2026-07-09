local ParentParent = script.Parent.Parent.Parent
local Foundation = require(ParentParent.Foundation)
local React = require(ParentParent.React)
local View = Foundation.View
local Button = Foundation.Button
local ButtonSize = Foundation.Enums.ButtonSize
local ButtonVariant = Foundation.Enums.ButtonVariant

return function(t1: {[any]: any}) -- line: 22
	-- upvalues: React (copy), View (copy), Button (copy), ButtonSize (copy), ButtonVariant (copy)
	return React.createElement(View, {
		tag = "bg-action-subtle align-x-center align-y-center auto-xy padding-bottom-medium",
		AnchorPoint = t1.AnchorPoint,
		LayoutOrder = t1.LayoutOrder,
		Position = t1.Position
	}, {
		ShowMoreButton = React.createElement(Button, {
			onActivated = t1.onActivated,
			size = ButtonSize.Small,
			text = t1.text,
			variant = ButtonVariant.Subtle
		})
	})
end
