local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")
local parent = CurrencyTransfers.Parent
local React = require(parent.React)

local InExperienceRobuxTransferSubscriptionUpsell = require(CurrencyTransfers.Components.InExperienceRobuxTransferSubscriptionUpsell)

local useRobuxTransferSubscriptionUpsellListenerEffect = require(CurrencyTransfers.Hooks.useRobuxTransferSubscriptionUpsellListenerEffect)

local function InExperienceTransferUpsellApp()
	local state, setState = React.useState(false)

	local v = React.useCallback(function()
		setState(true)
	end, {})

	local onClose = React.useCallback(function()
		setState(false)
	end, {})

	useRobuxTransferSubscriptionUpsellListenerEffect(v)

	if state then
		return React.createElement(
			"ScreenGui",
			{
				ScreenInsets = Enum.ScreenInsets.None,
				ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
				DisplayOrder = 8
			},
			{
				SubscriptionUpsell = React.createElement(InExperienceRobuxTransferSubscriptionUpsell, {
					onClose = onClose
				})
			}
		)
	end

	return nil
end

return InExperienceTransferUpsellApp
