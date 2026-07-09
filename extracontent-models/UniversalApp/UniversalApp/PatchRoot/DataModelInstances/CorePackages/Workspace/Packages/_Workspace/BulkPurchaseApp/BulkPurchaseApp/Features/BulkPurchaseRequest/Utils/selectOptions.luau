local BulkPurchaseApp = script:FindFirstAncestor("BulkPurchaseApp")

require(BulkPurchaseApp.Store.Types)

local function selectOptions(p1) -- line: 7
	return p1.options
end

return selectOptions
