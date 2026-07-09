local BulkPurchaseApp = script:FindFirstAncestor("BulkPurchaseApp")

require(BulkPurchaseApp.Store.Types)

local filterPurchasableItems = require(script.Parent.filterPurchasableItems)
local getLineItemsFromPurchaseResponse = require(script.Parent.getLineItemsFromPurchaseResponse)
local lineItemToStatus = require(script.Parent.lineItemToStatus)

local function getItemResultsFromResponse(t1: {[any]: any}, t2: {[any]: any}) -- line: 32
	-- upvalues: filterPurchasableItems (copy), getLineItemsFromPurchaseResponse (copy), lineItemToStatus (copy)
	local v8 = filterPurchasableItems(t2)
	local v9 = getLineItemsFromPurchaseResponse(t1)
	local t3 = {}

	for v11, v12 in v8 do
		local v13 = v9[v11]

		if v13 then
			t3[v12.id] = lineItemToStatus(v13)
		end
	end

	return t3
end

return getItemResultsFromResponse
