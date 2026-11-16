local CancelSubscriptionApp = script:FindFirstAncestor("CancelSubscriptionApp")

require(CancelSubscriptionApp.Store.Types)
require(CancelSubscriptionApp.Enums.CancelUserSubscriptionAsyncPromptStateEnum)

local function selectPromptState(p)
	return p.promptState
end

return selectPromptState
