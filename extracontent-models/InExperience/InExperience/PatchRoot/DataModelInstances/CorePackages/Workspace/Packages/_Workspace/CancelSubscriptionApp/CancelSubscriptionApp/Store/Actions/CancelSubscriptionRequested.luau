local parent = script:FindFirstAncestor("CancelSubscriptionApp").Parent
local Rodux = require(parent.Rodux)

return Rodux.makeActionCreator("CancelSubscriptionRequested", function(subscriptionId: string)
	return { subscriptionId = subscriptionId }
end)
