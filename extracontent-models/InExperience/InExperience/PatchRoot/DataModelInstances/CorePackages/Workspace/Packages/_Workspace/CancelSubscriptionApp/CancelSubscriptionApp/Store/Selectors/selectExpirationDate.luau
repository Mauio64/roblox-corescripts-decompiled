local CancelSubscriptionApp = script:FindFirstAncestor("CancelSubscriptionApp")

require(CancelSubscriptionApp.Store.Types)

local function selectExpirationDate(p)
	return p.expirationDate
end

return selectExpirationDate
