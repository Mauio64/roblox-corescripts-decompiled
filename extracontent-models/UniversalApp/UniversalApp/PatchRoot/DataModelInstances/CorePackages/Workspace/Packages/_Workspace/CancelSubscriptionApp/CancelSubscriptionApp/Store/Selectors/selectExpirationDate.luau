local CancelSubscriptionApp = script:FindFirstAncestor("CancelSubscriptionApp")

require(CancelSubscriptionApp.Store.Types)

local function selectExpirationDate(p1) -- line: 7
	return p1.expirationDate
end

return selectExpirationDate
