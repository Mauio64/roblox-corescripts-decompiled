local Parent = script:FindFirstAncestor("SduiSharedContent").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)

require(Parent.SduiCompat)

local Badge = Foundation.Badge

local function SduiBadge(t1: {[any]: any}) -- line: 28
	-- upvalues: React (copy), Badge (copy)
	return React.createElement(Badge, {
		text = t1.text,
		icon = t1.icon,
		variant = t1.variant,
		testId = t1.testId,
		onAbsoluteSizeChanged = t1.onAbsoluteSizeChanged,
		onAbsolutePositionChanged = t1.onAbsolutePositionChanged,
		AnchorPoint = t1.anchorPoint,
		LayoutOrder = t1.layoutOrder,
		Position = t1.position,
		Visible = t1.visible,
		ZIndex = t1.zIndex
	})
end

return React.memo(SduiBadge)
