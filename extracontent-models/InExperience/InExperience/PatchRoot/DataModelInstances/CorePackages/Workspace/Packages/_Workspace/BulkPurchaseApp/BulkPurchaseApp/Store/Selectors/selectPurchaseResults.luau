local BulkPurchaseApp = script:FindFirstAncestor("BulkPurchaseApp")

local selectRobuxSpent = require(BulkPurchaseApp.Store.Selectors.selectRobuxSpent)
local selectResultItems = require(BulkPurchaseApp.Store.Selectors.selectResultItems)
require(BulkPurchaseApp.Store.Types)

local function selectPurchaseResults(p)
	return { RobuxSpent = selectRobuxSpent(p), Items = selectResultItems(p) }
end

return selectPurchaseResults
