local parent = script:FindFirstAncestor("BulkPurchaseApp").Parent
local Rodux = require(parent.Rodux)

return Rodux.makeActionCreator("BulkPurchaseEnded", function()
	return {}
end)
