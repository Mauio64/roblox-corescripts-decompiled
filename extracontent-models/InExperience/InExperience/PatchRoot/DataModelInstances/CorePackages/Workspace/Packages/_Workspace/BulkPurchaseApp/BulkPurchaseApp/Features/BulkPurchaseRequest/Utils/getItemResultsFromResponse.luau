local BulkPurchaseApp = script:FindFirstAncestor("BulkPurchaseApp")

require(BulkPurchaseApp.Store.Types)
local filterPurchasableItems = require(script.Parent.filterPurchasableItems)
local getLineItemsFromPurchaseResponse = require(script.Parent.getLineItemsFromPurchaseResponse)
local lineItemToStatus = require(script.Parent.lineItemToStatus)

local function getItemResultsFromResponse(p, p2)
	local v = filterPurchasableItems(p2)
	local lineItemsFromPurchaseResponse = getLineItemsFromPurchaseResponse(p)

	local itemResults = {}

	for k, v2 in v do
		local v3 = lineItemsFromPurchaseResponse[k]

		if v3 then
			itemResults[v2.id] = lineItemToStatus(v3)
		end
	end

	return itemResults
end

return getItemResultsFromResponse
