local parent = script:FindFirstAncestor("SduiSharedContent").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
require(parent.SduiCompat)

local BannerContext = Foundation.BannerContext

local function SduiBannerContext(props)
	return React.createElement(BannerContext, {
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
