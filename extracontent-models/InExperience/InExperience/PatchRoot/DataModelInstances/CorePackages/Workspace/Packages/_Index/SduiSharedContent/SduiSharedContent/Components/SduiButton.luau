local Parent = script:FindFirstAncestor("SduiSharedContent").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)

require(Parent.SduiCompat)

local function SduiButton(t1: {[any]: any}) -- line: 42
	-- upvalues: React (copy), Foundation (copy)
	return React.createElement(Foundation.Button, {
		AnchorPoint = t1.anchorPoint,
		LayoutOrder = t1.layoutOrder,
		Position = t1.position,
		Selectable = t1.selectable,
		Visible = t1.visible,
		ZIndex = t1.zIndex,
		cursor = t1.cursorType,
		fillBehavior = t1.fillBehavior,
		icon = t1.icon,
		inputDelay = t1.inputDelay,
		isDisabled = t1.isDisabled,
		isLoading = t1.isLoading,
		onActivated = t1.onActivated,
		size = t1.size,
		tag = t1.tag,
		testId = t1.testId,
		text = t1.text,
		variant = t1.variant,
		width = t1.width
	})
end

return SduiButton
