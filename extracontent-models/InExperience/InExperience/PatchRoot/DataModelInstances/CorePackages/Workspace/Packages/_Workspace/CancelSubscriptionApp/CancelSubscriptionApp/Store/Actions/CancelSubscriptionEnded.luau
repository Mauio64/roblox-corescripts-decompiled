local parent = script:FindFirstAncestor("CancelSubscriptionApp").Parent
local Rodux = require(parent.Rodux)

return Rodux.makeActionCreator("CancelSubscriptionEnded", function()
	return {}
end)
