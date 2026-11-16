local parent = script:FindFirstAncestor("SduiSharedContent").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
require(parent.SduiCompat)

local Badge = Foundation.Badge

local function SduiBadge(props)
	return React.createElement(Badge, {
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
