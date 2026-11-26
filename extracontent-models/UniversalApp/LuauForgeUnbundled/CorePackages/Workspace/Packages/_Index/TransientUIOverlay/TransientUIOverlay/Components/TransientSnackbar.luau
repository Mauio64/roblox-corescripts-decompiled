local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/TransientUIOverlay/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/TransientUIOverlay/React")

local foundationProvider = Foundation.FoundationProvider
local snackbar = Foundation.Snackbar
local view = Foundation.View
local usePreferences = Foundation.Hooks.usePreferences
local useTokens = Foundation.Hooks.useTokens

require("@game/CorePackages/Workspace/Packages/_Index/TransientUIOverlay/TransientUIOverlay/Types")

local function TransientSnackbar(props)
	local v5 = useTokens()
	local v6 = usePreferences()

	local element = React.createElement(snackbar, {
		title = props.title,
		icon = props.icon,
		action = props.actionText and {
			text = props.actionText,
			onActivated = props.onAction or function() end
		} or nil,
		LayoutOrder = 1,
		testId = "transient-snackbar"
	})

	local element2 = React.createElement(view, {
		Position = UDim2.new(0.5, 0, 1, -v5.Padding.XLarge),
		tag = "anchor-bottom-center auto-xy",
		testId = "transient-snackbar-anchor"
	}, { Snackbar = element })

	if props.colorMode == nil then
		return element2
	end

	return (React.createElement("Folder", nil, {
		Provider = React.createElement(foundationProvider, {
			colorMode = props.colorMode,
			device = props.device,
			preferences = {
				preferredTextSize = v6.preferredTextSize,
				preferredTransparency = v6.preferredTransparency,
				reducedMotion = v6.reducedMotion
			}
		}, { Anchor = element2 })
	}))
end

return TransientSnackbar
