local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/Foundation")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiCompat")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SharedFlags")
local fFlagSduiViewContainerRefEnabled = SharedFlags.FFlagSduiViewContainerRefEnabled
local fFlagSduiViewStateLayerAffordance = SharedFlags.FFlagSduiViewStateLayerAffordance

local function SduiView(props)
	local createElement = React.createElement
	local view = Foundation.View
	local v6 = if fFlagSduiViewContainerRefEnabled then props.containerRef else nil
	return createElement(view, {
		ref = v6,
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
		stateLayer = fFlagSduiViewStateLayerAffordance and props.stateLayerAffordance ~= nil and {
			affordance = props.stateLayerAffordance
		} or nil,
		tag = props.tag,
		testId = props.testId
	}, props.children)
end

return React.memo(SduiView)
