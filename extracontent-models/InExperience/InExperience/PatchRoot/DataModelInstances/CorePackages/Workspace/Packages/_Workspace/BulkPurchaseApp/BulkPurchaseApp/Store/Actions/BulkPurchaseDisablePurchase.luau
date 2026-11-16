local parent = script:FindFirstAncestor("BulkPurchaseApp").Parent
local Rodux = require(parent.Rodux)

return Rodux.makeActionCreator("BulkPurchaseDisablePurchase", function()
	return {}
end)
