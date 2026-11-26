local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/Foundation")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiCompat")

local function SduiIcon(props)
	return React.createElement(Foundation.Icon, {
		name = props.name,
		style = props.style,
		size = props.size,
		variant = props.variant,
		Rotation = props.rotation,
		AnchorPoint = props.anchorPoint,
		LayoutOrder = props.layoutOrder,
		Position = props.position,
		Visible = props.visible,
		ZIndex = props.zIndex,
		testId = props.testId
	}, props.children)
end

return React.memo(SduiIcon)
