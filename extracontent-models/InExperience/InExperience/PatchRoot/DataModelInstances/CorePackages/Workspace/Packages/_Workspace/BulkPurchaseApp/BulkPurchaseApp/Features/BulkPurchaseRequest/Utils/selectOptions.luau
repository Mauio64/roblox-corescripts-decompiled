local BulkPurchaseApp = script:FindFirstAncestor("BulkPurchaseApp")

require(BulkPurchaseApp.Store.Types)

local function selectOptions(p)
	return p.options
end

return selectOptions
