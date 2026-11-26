local module = require("@luauforge/deferred/hcT")
local module2 = require("@luauforge/deferred/hcS")

local function BackgroundsPlusSubscribeLink(props)
	return module2.createElement(module.Text, {
		Text = `<u>{props.text}</u>`,
		RichText = true,
		tag = "auto-xy text-body-small text-no-wrap content-default",
		onActivated = props.onActivated,
		LayoutOrder = props.LayoutOrder,
		testId = props.testId or "BackgroundsPlusSubscribeLink"
	})
end

return module2.memo(BackgroundsPlusSubscribeLink)
