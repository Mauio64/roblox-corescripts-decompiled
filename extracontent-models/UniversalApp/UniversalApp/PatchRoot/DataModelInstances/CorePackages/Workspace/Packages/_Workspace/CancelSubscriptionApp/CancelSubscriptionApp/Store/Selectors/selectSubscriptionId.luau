local CancelSubscriptionApp = script:FindFirstAncestor("CancelSubscriptionApp")

require(CancelSubscriptionApp.Store.Types)

local function selectSubscriptionId(p1) -- line: 7
	return p1.subscriptionId
end

return selectSubscriptionId
