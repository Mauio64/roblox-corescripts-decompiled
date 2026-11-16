local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/Foundation")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiCompat")

local fFlagLuaAppSduiGameTileFeedback = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SharedFlags").FFlagLuaAppSduiGameTileFeedback

local function SduiButton(props)
	local createElement = React.createElement
	local button = Foundation.Button
	local v6 = if fFlagLuaAppSduiGameTileFeedback then props.buttonRef else nil
	return createElement(button, {
		ref = v6,
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
