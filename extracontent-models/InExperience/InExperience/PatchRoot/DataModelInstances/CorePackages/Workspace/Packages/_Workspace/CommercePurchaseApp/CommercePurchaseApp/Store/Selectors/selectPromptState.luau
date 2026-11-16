local CommercePurchaseApp = script:FindFirstAncestor("CommercePurchaseApp")

require(CommercePurchaseApp.Store.Types)
require(CommercePurchaseApp.Enums.CommercePurchasePromptStateEnum)

local function selectPromptState(p)
	return p.commercePurchaseState.promptState
end

return selectPromptState
