local module = require("@luauforge/deferred/gQM")
local module2 = require("@luauforge/deferred/gRz")

local function BackgroundsPlusSubscribeBanner(props)
	return module.createElement(module2, {
		message = props.message,
		actionText = props.actionText,
		onActivated = props.onActivated,
		showPlusIcon = props.showPlusIcon == true,
		LayoutOrder = props.LayoutOrder,
		testId = "BackgroundsPlusSubscribeBanner"
	})
end

return module.memo(BackgroundsPlusSubscribeBanner)
