local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/Foundation")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiCompat")

local badge = Foundation.Badge

local fFlagSduiBadgeShape = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SharedFlags").FFlagSduiBadgeShape

local function SduiBadge(props)
	local createElement = React.createElement
	local v6 = {
		text = props.text,
		icon = props.icon,
		variant = props.variant,
		shape = 0,
		testId = 0,
		onAbsoluteSizeChanged = 0,
		onAbsolutePositionChanged = 0,
		AnchorPoint = 0,
		LayoutOrder = 0,
		Position = 0,
		Visible = 0,
		ZIndex = 0
	}
	local v7 = if fFlagSduiBadgeShape then props.shape else nil
	v6.shape = v7
	v6.testId = props.testId
	v6.onAbsoluteSizeChanged = props.onAbsoluteSizeChanged
	v6.onAbsolutePositionChanged = props.onAbsolutePositionChanged
	v6.AnchorPoint = props.anchorPoint
	v6.LayoutOrder = props.layoutOrder
	v6.Position = props.position
	v6.Visible = props.visible
	v6.ZIndex = props.zIndex
	return createElement(badge, v6)
end

return React.memo(SduiBadge)
