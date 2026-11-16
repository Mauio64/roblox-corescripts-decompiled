local parent = script:FindFirstAncestor("CancelSubscriptionApp").Parent
local React = require(parent.React)
local UIBlox = require(parent.UIBlox)
local Toast = UIBlox.App.Dialog.Toast
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local iconslogoblock = UIBlox.App.ImageSet.Images["icons/logo/block"]

local v = { heading = "CoreScripts.CancelUserSubscriptionPrompt.SuccessPrompt.Heading" }

local function CancelUserSubscriptionSuccessPrompt(p)
	local v2 = useLocalization(v)
	return React.createElement(Toast, {
		toastContent = {
			toastTitle = v2.heading,
			iconImage = iconslogoblock,
			onAppeared = function() end,
			onDismissed = p.onDismissed or function() end,
			swipeUpDismiss = true
		},
		anchorPoint = Vector2.new(0.5, 0),
		duration = 3,
		layoutOrder = 1,
		position = UDim2.new(0.5, 0, 0, 20),
		size = UDim2.new(0.5, -24, 0, 0),
		show = true
	})
end

return CancelUserSubscriptionSuccessPrompt
