local parent = script:FindFirstAncestor("BulkPurchaseApp").Parent
local Rodux = require(parent.Rodux)

return Rodux.makeActionCreator("BulkPurchaseStarted", function(balance: number)
	return { balance = balance }
end)
