local parent = script:FindFirstAncestor("SduiSharedContent").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
require(parent.SduiCompat)
local SharedFlags = require(parent.SharedFlags)
local FFlagSduiViewContainerRefEnabled = SharedFlags.FFlagSduiViewContainerRefEnabled
local FFlagSduiViewStateLayerAffordance = SharedFlags.FFlagSduiViewStateLayerAffordance

local function SduiView(props)
	local createElement = React.createElement
	local view = Foundation.View
	local ref

	if FFlagSduiViewContainerRefEnabled then
		ref = props.containerRef
	end

	return createElement(view, {
		ref = ref,
		AnchorPoint = props.anchorPoint,
		AutomaticSize = props.automaticSize,
		ClipsDescendants = props.clipsDescendants,
		GroupTransparency = props.groupTransparency,
		LayoutOrder = props.layoutOrder,
		Position = props.position,
		Rotation = props.rotation,
		Size = props.size,
		SizeConstraint = props.sizeConstraint,
		Visible = props.visible,
		ZIndex = props.zIndex,
		aspectRatio = props.aspectRatio,
		backgroundStyle = props.backgroundStyle,
		cornerRadius = props.cornerRadius,
		cursor = props.cursorType,
		isDisabled = props.isDisabled,
		onActivated = props.onActivated,
		onSecondaryActivated = props.onSecondaryActivated,
		padding = props.padding,
		scale = props.scale,
		selection = props.selectable ~= nil and { Selectable = props.selectable } or nil,
		selectionGroup = props.selectionGroup,
		stateLayer = FFlagSduiViewStateLayerAffordance and props.stateLayerAffordance ~= nil and {
			affordance = props.stateLayerAffordance
		} or nil,
		tag = props.tag,
		testId = props.testId
	}, props.children)
end

return React.memo(SduiView)
