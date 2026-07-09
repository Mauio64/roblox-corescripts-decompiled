local CancelSubscriptionApp = script:FindFirstAncestor("CancelSubscriptionApp")
local CancelSubscriptionAppParent = CancelSubscriptionApp.Parent
local Rodux = require(CancelSubscriptionAppParent.Rodux)

require(CancelSubscriptionApp.Enums.ErrorStateEnum)

return Rodux.makeActionCreator("CancelSubscriptionFailed", function(p1, s1: string) -- line: 15
	return {
		errorState = p1,
		subscriptionId = s1
	}
end)
