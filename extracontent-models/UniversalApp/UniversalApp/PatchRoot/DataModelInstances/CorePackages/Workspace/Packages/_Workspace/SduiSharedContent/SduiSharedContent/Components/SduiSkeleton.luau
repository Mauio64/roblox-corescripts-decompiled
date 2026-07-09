local Parent = script:FindFirstAncestor("SduiSharedContent").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)

require(Parent.SduiCompat)

local Skeleton = Foundation.Skeleton

local function SduiSkeleton(t1: {[any]: any}) -- line: 28
	-- upvalues: React (copy), Skeleton (copy)
	return React.createElement(Skeleton, {
		radius = t1.radius,
		Size = t1.size,
		LayoutOrder = t1.layoutOrder,
		AnchorPoint = t1.anchorPoint,
		Position = t1.position,
		Visible = t1.visible,
		ZIndex = t1.zIndex,
		testId = t1.testId
	})
end

return React.memo(SduiSkeleton)
