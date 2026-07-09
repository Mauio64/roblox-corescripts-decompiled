local Parent = script:FindFirstAncestor("SduiSharedContent").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)

require(Parent.SduiCompat)

local function SduiText(t1: {[any]: any}) -- line: 52
	-- upvalues: React (copy), Foundation (copy)
	return React.createElement(Foundation.Text, {
		AnchorPoint = t1.anchorPoint,
		AutomaticSize = t1.automaticSize,
		LayoutOrder = t1.layoutOrder,
		Position = t1.position,
		RichText = t1.richText,
		Rotation = t1.rotation,
		Size = t1.size,
		SizeConstraint = t1.sizeConstraint,
		Text = t1.text,
		TextTruncate = t1.textTruncate,
		TextWrapped = t1.textWrapped,
		TextXAlignment = t1.textXAlignment,
		TextYAlignment = t1.textYAlignment,
		Visible = t1.visible,
		ZIndex = t1.zIndex,
		aspectRatio = t1.aspectRatio,
		backgroundStyle = t1.backgroundStyle,
		cornerRadius = t1.cornerRadius,
		cursor = t1.cursorType,
		fontStyle = t1.fontStyle,
		isDisabled = t1.isDisabled,
		onActivated = t1.onActivated,
		onSecondaryActivated = t1.onSecondaryActivated,
		padding = t1.padding,
		scale = t1.scale,
		selection = if t1.selectable == nil then nil else {
			Selectable = t1.selectable
		},
		tag = t1.tag,
		testId = t1.testId,
		textStyle = t1.textStyle
	}, t1.children)
end

return SduiText
