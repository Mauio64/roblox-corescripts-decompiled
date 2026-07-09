local BulkPurchaseApp = script:FindFirstAncestor("BulkPurchaseApp")

require(BulkPurchaseApp.Store.Types)
require(BulkPurchaseApp.Enums.BulkPurchasePromptStateEnum)

local function selectPromptState(p1) -- line: 9
	return p1.promptState
end

return selectPromptState
