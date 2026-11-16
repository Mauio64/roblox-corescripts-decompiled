local parent = script:FindFirstAncestor("ChatUIPrimitives").Parent
local Foundation = require(parent.Foundation)
local React = require(parent.React)

local v = { name = "lightning-bolt", variant = "Regular" }

local function ExpressionEntryButtonView(props)
	if props.isFullWidth then
		return React.createElement(Foundation.Button, {
			fillBehavior = Foundation.Enums.FillBehavior.Fit,
			onActivated = props.onActivated,
			text = props.text or "",
			variant = Foundation.Enums.ButtonVariant.Standard,
			width = UDim.new(1, 0),
			ref = props.buttonRef
		})
	end

	local icon = props.icon or v
	local icon2 = props.isActive and { name = icon.name, variant = "Filled" } or icon

	local createElement = React.createElement
	local iconButton = Foundation.IconButton
	local v2 = {
		icon = icon2,
		variant = Foundation.Enums.ButtonVariant.Standard,
		size = 0,
		isCircular = true,
		isDisabled = false,
		onActivated = 0,
		ref = 0
	}
	local size

	if props.size == nil then
		size = Foundation.Enums.InputSize.Small
	else
		size = props.size
	end

	v2.size = size

	v2.onActivated = props.onActivated
	v2.ref = props.buttonRef
	return createElement(iconButton, v2)
end

return React.memo(ExpressionEntryButtonView)
