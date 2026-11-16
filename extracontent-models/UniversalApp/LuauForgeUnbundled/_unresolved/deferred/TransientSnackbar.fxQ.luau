local module = require("@luauforge/deferred/fxP")
local module2 = require("@luauforge/deferred/fxM")

local snackbar = module.Snackbar
local view = module.View
local useTokens = module.Hooks.useTokens

require("@luauforge/deferred/fxK")

local function TransientSnackbar(props)
	local v5 = useTokens()

	return module2.createElement(view, {
		Position = UDim2.new(0.5, 0, 1, -v5.Padding.XLarge),
		tag = "anchor-bottom-center auto-xy",
		testId = "transient-snackbar-anchor"
	}, {
		Snackbar = module2.createElement(snackbar, {
			title = props.title,
			icon = props.icon,
			action = props.actionText and {
				text = props.actionText,
				onActivated = props.onAction or function() end
			} or nil,
			LayoutOrder = 1,
			testId = "transient-snackbar"
		})
	})
end

return TransientSnackbar
