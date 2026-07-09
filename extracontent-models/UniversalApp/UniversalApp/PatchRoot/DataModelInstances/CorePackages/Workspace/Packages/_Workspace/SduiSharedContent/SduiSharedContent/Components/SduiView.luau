local Parent = script:FindFirstAncestor("SduiSharedContent").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)

require(Parent.SduiCompat)

local function SduiView(t1: {[any]: any}) -- line: 46
	-- upvalues: React (copy), Foundation (copy)
	return React.createElement(Foundation.View, {
		AnchorPoint = t1.anchorPoint,
		AutomaticSize = t1.automaticSize,
		ClipsDescendants = t1.clipsDescendants,
		GroupTransparency = t1.groupTransparency,
		LayoutOrder = t1.layoutOrder,
		Position = t1.position,
		Rotation = t1.rotation,
		Size = t1.size,
		SizeConstraint = t1.sizeConstraint,
		Visible = t1.visible,
		ZIndex = t1.zIndex,
		aspectRatio = t1.aspectRatio,
		backgroundStyle = t1.backgroundStyle,
		cornerRadius = t1.cornerRadius,
		cursor = t1.cursorType,
		isDisabled = t1.isDisabled,
		onActivated = t1.onActivated,
		onSecondaryActivated = t1.onSecondaryActivated,
		padding = t1.padding,
		scale = t1.scale,
		selection = if t1.selectable == nil then nil else {
			Selectable = t1.selectable
		},
		selectionGroup = t1.selectionGroup,
		tag = t1.tag,
		testId = t1.testId
	}, t1.children)
end

return React.memo(SduiView)
