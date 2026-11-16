local parent = script:FindFirstAncestor("CancelSubscriptionApp").Parent
local Rodux = require(parent.Rodux)

return Rodux.makeActionCreator("CancelSubscriptionSucceeded", function(subscriptionId: string)
	return { subscriptionId = subscriptionId }
end)
