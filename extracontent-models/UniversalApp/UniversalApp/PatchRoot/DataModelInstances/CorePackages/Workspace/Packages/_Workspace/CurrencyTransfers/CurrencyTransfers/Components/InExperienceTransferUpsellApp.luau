local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")
local CurrencyTransfersParent = CurrencyTransfers.Parent
local React = require(CurrencyTransfersParent.React)
local InExperienceRobuxTransferSubscriptionUpsell = require(CurrencyTransfers.Components.InExperienceRobuxTransferSubscriptionUpsell)
local useRobuxTransferSubscriptionUpsellListenerEffect = require(CurrencyTransfers.Hooks.useRobuxTransferSubscriptionUpsellListenerEffect)

local function InExperienceTransferUpsellApp() -- line: 16
	-- upvalues: React (copy), useRobuxTransferSubscriptionUpsellListenerEffect (copy), InExperienceRobuxTransferSubscriptionUpsell (copy)
	local v7, v8 = React.useState(false)
	local v9 = React.useCallback(function() -- line: 19
		-- upvalues: v8 (copy)
		v8(true)
	end, {})
	local v10 = React.useCallback(function() -- line: 23
		-- upvalues: v8 (copy)
		v8(false)
	end, {})

	useRobuxTransferSubscriptionUpsellListenerEffect(v9)

	if not v7 then
		return nil
	end

	return React.createElement("ScreenGui", {
		DisplayOrder = 8,
		ScreenInsets = Enum.ScreenInsets.None,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	}, {
		SubscriptionUpsell = React.createElement(InExperienceRobuxTransferSubscriptionUpsell, {
			onClose = v10
		})
	})
end

return InExperienceTransferUpsellApp
