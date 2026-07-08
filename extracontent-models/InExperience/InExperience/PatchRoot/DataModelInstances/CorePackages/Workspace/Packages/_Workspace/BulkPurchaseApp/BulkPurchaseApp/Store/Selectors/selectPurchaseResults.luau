local BulkPurchaseApp = script:FindFirstAncestor("BulkPurchaseApp")
local selectRobuxSpent = require(BulkPurchaseApp.Store.Selectors.selectRobuxSpent)
local selectResultItems = require(BulkPurchaseApp.Store.Selectors.selectResultItems)

require(BulkPurchaseApp.Store.Types)

local function selectPurchaseResults(p1) -- line: 14
	-- upvalues: selectRobuxSpent (copy), selectResultItems (copy)
	return {
		RobuxSpent = selectRobuxSpent(p1),
		Items = selectResultItems(p1)
	}
end

return selectPurchaseResults
