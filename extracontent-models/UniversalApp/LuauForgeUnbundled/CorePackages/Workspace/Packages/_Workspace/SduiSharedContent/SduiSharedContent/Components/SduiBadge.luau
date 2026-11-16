local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/Foundation")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiCompat")

local badge = Foundation.Badge

local function SduiBadge(props)
	return React.createElement(badge, {
		text = props.text,
		icon = props.icon,
		variant = props.variant,
		testId = props.testId,
		onAbsoluteSizeChanged = props.onAbsoluteSizeChanged,
		onAbsolutePositionChanged = props.onAbsolutePositionChanged,
		AnchorPoint = props.anchorPoint,
		LayoutOrder = props.layoutOrder,
		Position = props.position,
		Visible = props.visible,
		ZIndex = props.zIndex
	})
end

return React.memo(SduiBadge)
