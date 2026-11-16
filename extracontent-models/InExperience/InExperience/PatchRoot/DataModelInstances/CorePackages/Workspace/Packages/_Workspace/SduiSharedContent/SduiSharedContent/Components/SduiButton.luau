local parent = script:FindFirstAncestor("SduiSharedContent").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
require(parent.SduiCompat)

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppSduiGameTileFeedback = SharedFlags.FFlagLuaAppSduiGameTileFeedback

local function SduiButton(props)
	local createElement = React.createElement
	local button = Foundation.Button
	local ref

	if FFlagLuaAppSduiGameTileFeedback then
		ref = props.buttonRef
	end

	return createElement(button, {
		ref = ref,
		AnchorPoint = props.anchorPoint,
		LayoutOrder = props.layoutOrder,
		Position = props.position,
		Selectable = props.selectable,
		Visible = props.visible,
		ZIndex = props.zIndex,
		cursor = props.cursorType,
		fillBehavior = props.fillBehavior,
		icon = props.icon,
		inputDelay = props.inputDelay,
		isDisabled = props.isDisabled,
		isLoading = props.isLoading,
		onActivated = props.onActivated,
		size = props.size,
		tag = props.tag,
		testId = props.testId,
		text = props.text,
		variant = props.variant,
		width = props.width
	})
end

return SduiButton
