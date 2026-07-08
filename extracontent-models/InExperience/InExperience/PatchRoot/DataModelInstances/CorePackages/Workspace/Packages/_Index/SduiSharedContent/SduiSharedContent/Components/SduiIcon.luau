local Parent = script:FindFirstAncestor("SduiSharedContent").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)

require(Parent.SduiCompat)

local function SduiIcon(t1: {[any]: any}) -- line: 32
	-- upvalues: React (copy), Foundation (copy)
	return React.createElement(Foundation.Icon, {
		name = t1.name,
		style = t1.style,
		size = t1.size,
		variant = t1.variant,
		Rotation = t1.rotation,
		AnchorPoint = t1.anchorPoint,
		LayoutOrder = t1.layoutOrder,
		Position = t1.position,
		Visible = t1.visible,
		ZIndex = t1.zIndex,
		testId = t1.testId
	}, t1.children)
end

return React.memo(SduiIcon)
