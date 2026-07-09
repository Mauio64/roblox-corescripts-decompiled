local Parent = script:FindFirstAncestor("CancelSubscriptionApp").Parent
local React = require(Parent.React)
local UIBlox = require(Parent.UIBlox)
local Toast = UIBlox.App.Dialog.Toast
local useLocalization = require(Parent.Localization).Hooks.useLocalization
local v6 = UIBlox.App.ImageSet.Images["icons/logo/block"]
local t1 = {
	heading = "CoreScripts.CancelUserSubscriptionPrompt.SuccessPrompt.Heading"
}

local function CancelUserSubscriptionSuccessPrompt(t2: {[any]: any}) -- line: 17
	-- upvalues: useLocalization (copy), t1 (copy), React (copy), Toast (copy), v6 (copy)
	local v10 = useLocalization(t1)

	return React.createElement(Toast, {
		duration = 3,
		layoutOrder = 1,
		show = true,
		toastContent = {
			swipeUpDismiss = true,
			toastTitle = v10.heading,
			iconImage = v6,
			onAppeared = function() -- line: 23
			end,
			onDismissed = t2.onDismissed or function() -- line: 24
			end
		},
		anchorPoint = Vector2.new(0.5, 0),
		position = UDim2.new(0.5, 0, 0, 20),
		size = UDim2.new(0.5, -24, 0, 0)
	})
end

return CancelUserSubscriptionSuccessPrompt
