local parent = script:FindFirstAncestor("SduiSharedContent").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
require(parent.SduiCompat)

local function SduiText(props)
	return React.createElement(Foundation.Text, {
		AnchorPoint = props.anchorPoint,
		AutomaticSize = props.automaticSize,
		LayoutOrder = props.layoutOrder,
		Position = props.position,
		RichText = props.richText,
		Rotation = props.rotation,
		Size = props.size,
		SizeConstraint = props.sizeConstraint,
		Text = props.text,
		TextTruncate = props.textTruncate,
		TextWrapped = props.textWrapped,
		TextXAlignment = props.textXAlignment,
		TextYAlignment = props.textYAlignment,
		Visible = props.visible,
		ZIndex = props.zIndex,
		aspectRatio = props.aspectRatio,
		backgroundStyle = props.backgroundStyle,
		cornerRadius = props.cornerRadius,
		cursor = props.cursorType,
		fontStyle = props.fontStyle,
		isDisabled = props.isDisabled,
		onActivated = props.onActivated,
		onSecondaryActivated = props.onSecondaryActivated,
		padding = props.padding,
		scale = props.scale,
		selection = props.selectable ~= nil and { Selectable = props.selectable } or nil,
		tag = props.tag,
		testId = props.testId,
		textStyle = props.textStyle
	}, props.children)
end

return SduiText
