local CancelSubscriptionApp = script:FindFirstAncestor("CancelSubscriptionApp")
local parent = CancelSubscriptionApp.Parent
local Rodux = require(parent.Rodux)

require(CancelSubscriptionApp.Enums.ErrorStateEnum)

return Rodux.makeActionCreator("CancelSubscriptionFailed", function(errorState, subscriptionId: string)
	return { errorState = errorState, subscriptionId = subscriptionId }
end)
