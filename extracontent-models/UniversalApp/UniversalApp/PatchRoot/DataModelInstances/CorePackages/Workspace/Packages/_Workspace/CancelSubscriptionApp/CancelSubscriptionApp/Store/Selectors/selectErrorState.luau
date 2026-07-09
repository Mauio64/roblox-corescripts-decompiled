local CancelSubscriptionApp = script:FindFirstAncestor("CancelSubscriptionApp")

require(CancelSubscriptionApp.Store.Types)
require(CancelSubscriptionApp.Enums.ErrorStateEnum)

local function selectErrorState(p1) -- line: 8
	return p1.errorState
end

return selectErrorState
