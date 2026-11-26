local React = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/React")

local InExperienceRobuxTransferSubscriptionUpsell = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Components/InExperienceRobuxTransferSubscriptionUpsell")

local useRobuxTransferSubscriptionUpsellListenerEffect = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Hooks/useRobuxTransferSubscriptionUpsellListenerEffect")

local function InExperienceTransferUpsellApp()
	local state, setState = React.useState(false)

	local v5 = React.useCallback(function()
		setState(true)
	end, {})

	local v6 = React.useCallback(function()
		setState(false)
	end, {})

	useRobuxTransferSubscriptionUpsellListenerEffect(v5)

	if state then
		return React.createElement(
			"ScreenGui",
			{
				ScreenInsets = Enum.ScreenInsets.None,
				ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
				DisplayOrder = 8
			},
			{
				SubscriptionUpsell = React.createElement(InExperienceRobuxTransferSubscriptionUpsell, { onClose = v6 })
			}
		)
	end

	return nil
end

return InExperienceTransferUpsellApp
