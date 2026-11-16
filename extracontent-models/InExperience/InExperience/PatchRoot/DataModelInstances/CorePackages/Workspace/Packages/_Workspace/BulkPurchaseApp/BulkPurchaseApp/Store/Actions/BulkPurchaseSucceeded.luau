local BulkPurchaseApp = script:FindFirstAncestor("BulkPurchaseApp")
local parent = BulkPurchaseApp.Parent
local Rodux = require(parent.Rodux)

require(BulkPurchaseApp.Enums.BulkPurchasePromptStateEnum)

return Rodux.makeActionCreator("BulkPurchaseSucceeded", function(promptState, itemStatuses)
	return { promptState = promptState, itemStatuses = itemStatuses }
end)
