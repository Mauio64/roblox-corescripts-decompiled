local CancelSubscriptionApp = script:FindFirstAncestor("CancelSubscriptionApp")

require(CancelSubscriptionApp.Store.Types)
require(CancelSubscriptionApp.Enums.ErrorStateEnum)

local function selectErrorState(p)
	return p.errorState
end

return selectErrorState
