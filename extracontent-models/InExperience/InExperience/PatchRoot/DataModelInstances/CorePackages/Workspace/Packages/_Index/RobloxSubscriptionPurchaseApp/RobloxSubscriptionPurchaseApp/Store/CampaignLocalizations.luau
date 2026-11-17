local parent = script:FindFirstAncestor("RobloxSubscriptionPurchaseApp").Parent
local SignalsUtils = require(parent.SignalsUtils)

local sessionScopedSignal, setCampaignLocalizations = SignalsUtils.createSessionScopedSignal({})

return {
	getCampaignLocalizations = sessionScopedSignal,
	setCampaignLocalizations = setCampaignLocalizations
}
