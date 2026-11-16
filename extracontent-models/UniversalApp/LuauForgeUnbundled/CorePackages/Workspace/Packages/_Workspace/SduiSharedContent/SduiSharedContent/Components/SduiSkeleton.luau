local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/Foundation")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiCompat")

local skeleton = Foundation.Skeleton

local function SduiSkeleton(props)
	return React.createElement(skeleton, {
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
