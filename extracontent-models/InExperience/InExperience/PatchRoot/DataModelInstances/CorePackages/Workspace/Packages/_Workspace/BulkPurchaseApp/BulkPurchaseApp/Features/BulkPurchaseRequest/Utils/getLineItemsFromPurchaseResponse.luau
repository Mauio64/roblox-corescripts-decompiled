local v1 = game:DefineFastFlag("BulkPurchaseHandleMissingFulfillmentGroupsKey", false)

local function getLineItemsFromPurchaseResponse(t1: {[any]: any}) -- line: 17
	-- upvalues: v1 (copy)
	if v1 then
		if t1.fulfillmentGroups and t1.fulfillmentGroups[1] and t1.fulfillmentGroups[1].lineItems then
			return t1.fulfillmentGroups[1].lineItems
		end

		return {}
	end

	if t1.fulfillmentGroups[1] then
		return t1.fulfillmentGroups[1].lineItems
	end

	return {}
end

return getLineItemsFromPurchaseResponse
