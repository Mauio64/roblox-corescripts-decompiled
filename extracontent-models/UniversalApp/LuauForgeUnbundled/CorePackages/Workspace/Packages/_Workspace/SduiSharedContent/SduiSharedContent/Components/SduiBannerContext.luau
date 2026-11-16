local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/Foundation")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiCompat")

local bannerContext = Foundation.BannerContext

local function SduiBannerContext(props)
	return React.createElement(bannerContext, {
		text = props.text,
		variant = props.variant,
		presentation = props.presentation,
		icon = props.icon,
		link = props.link,
		onClose = props.onClose,
		AnchorPoint = props.anchorPoint,
		LayoutOrder = props.layoutOrder,
		Position = props.position,
		Visible = props.visible,
		ZIndex = props.zIndex,
		testId = props.testId
	})
end

return React.memo(SduiBannerContext)
