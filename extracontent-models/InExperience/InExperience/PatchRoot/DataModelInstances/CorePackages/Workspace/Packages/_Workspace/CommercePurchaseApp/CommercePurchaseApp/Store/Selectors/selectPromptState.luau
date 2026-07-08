local CommercePurchaseApp = script:FindFirstAncestor("CommercePurchaseApp")

require(CommercePurchaseApp.Store.Types)
require(CommercePurchaseApp.Enums.CommercePurchasePromptStateEnum)

local function selectPromptState(p1) -- line: 8
	return p1.commercePurchaseState.promptState
end

return selectPromptState
