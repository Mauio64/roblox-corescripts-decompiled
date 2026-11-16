local BulkPurchaseApp = script:FindFirstAncestor("BulkPurchaseApp")

require(BulkPurchaseApp.Store.Types)
require(BulkPurchaseApp.Enums.BulkPurchasePromptStateEnum)

local function selectPromptState(p)
	return p.promptState
end

return selectPromptState
