local TransientUIOverlay = script:FindFirstAncestor("TransientUIOverlay")
local parent = TransientUIOverlay.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

local FoundationProvider = Foundation.FoundationProvider
local Snackbar = Foundation.Snackbar
local View = Foundation.View
local usePreferences = Foundation.Hooks.usePreferences
local useTokens = Foundation.Hooks.useTokens

require(TransientUIOverlay.Types)

local function TransientSnackbar(props)
	local v = useTokens()
	local v2 = usePreferences()

	local element = React.createElement(Snackbar, {
		title = props.title,
		icon = props.icon,
		action = props.actionText and {
			text = props.actionText,
			onActivated = props.onAction or function() end
		} or nil,
		LayoutOrder = 1,
		testId = "transient-snackbar"
	})

	local element2 = React.createElement(View, {
		Position = UDim2.new(0.5, 0, 1, -v.Padding.XLarge),
		tag = "anchor-bottom-center auto-xy",
		testId = "transient-snackbar-anchor"
	}, { Snackbar = element })

	if props.colorMode == nil then
		return element2
	end

	return (React.createElement("Folder", nil, {
		Provider = React.createElement(FoundationProvider, {
			colorMode = props.colorMode,
			device = props.device,
			preferences = {
				preferredTextSize = v2.preferredTextSize,
				preferredTransparency = v2.preferredTransparency,
				reducedMotion = v2.reducedMotion
			}
		}, { Anchor = element2 })
	}))
end

return TransientSnackbar
