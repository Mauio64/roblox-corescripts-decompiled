local parent = script:FindFirstAncestor("SduiSharedContent").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
require(parent.SduiCompat)

local Badge = Foundation.Badge

local SharedFlags = require(parent.SharedFlags)
local FFlagSduiBadgeShape = SharedFlags.FFlagSduiBadgeShape

local function SduiBadge(props)
	local createElement = React.createElement
	local v = {
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
	local shape

	if FFlagSduiBadgeShape then
		shape = props.shape
	end

	v.shape = shape
	v.testId = props.testId
	v.onAbsoluteSizeChanged = props.onAbsoluteSizeChanged
	v.onAbsolutePositionChanged = props.onAbsolutePositionChanged
	v.AnchorPoint = props.anchorPoint
	v.LayoutOrder = props.layoutOrder
	v.Position = props.position
	v.Visible = props.visible
	v.ZIndex = props.zIndex
	return createElement(Badge, v)
end

return React.memo(SduiBadge)
