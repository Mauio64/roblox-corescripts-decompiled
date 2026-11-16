local CancelSubscriptionApp = script:FindFirstAncestor("CancelSubscriptionApp")

require(CancelSubscriptionApp.Store.Types)

local function selectSubscriptionId(p)
	return p.subscriptionId
end

return selectSubscriptionId
