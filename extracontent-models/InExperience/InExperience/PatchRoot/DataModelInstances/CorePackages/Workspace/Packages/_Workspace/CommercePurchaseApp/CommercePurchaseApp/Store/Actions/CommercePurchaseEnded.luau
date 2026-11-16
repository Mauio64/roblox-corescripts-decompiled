local parent = script:FindFirstAncestor("CommercePurchaseApp").Parent
local Rodux = require(parent.Rodux)

return Rodux.makeActionCreator("CommercePurchaseEnded", function()
	return {}
end)
