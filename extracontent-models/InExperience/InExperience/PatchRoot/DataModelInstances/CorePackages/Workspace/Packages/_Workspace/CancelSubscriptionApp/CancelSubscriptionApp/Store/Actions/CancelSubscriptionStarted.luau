local parent = script:FindFirstAncestor("CancelSubscriptionApp").Parent
local Rodux = require(parent.Rodux)

return Rodux.makeActionCreator("CancelSubscriptionStarted", function(subscriptionId: string, expirationDate: string)
	return { subscriptionId = subscriptionId, expirationDate = expirationDate }
end)
