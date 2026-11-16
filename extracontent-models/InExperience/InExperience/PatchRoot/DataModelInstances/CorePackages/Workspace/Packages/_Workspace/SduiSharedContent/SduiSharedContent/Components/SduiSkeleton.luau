local parent = script:FindFirstAncestor("SduiSharedContent").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
require(parent.SduiCompat)

local Skeleton = Foundation.Skeleton

local function SduiSkeleton(props)
	return React.createElement(Skeleton, {
		radius = props.radius,
		Size = props.size,
		LayoutOrder = props.layoutOrder,
		AnchorPoint = props.anchorPoint,
		Position = props.position,
		Visible = props.visible,
		ZIndex = props.zIndex,
		testId = props.testId
	})
end

return React.memo(SduiSkeleton)
