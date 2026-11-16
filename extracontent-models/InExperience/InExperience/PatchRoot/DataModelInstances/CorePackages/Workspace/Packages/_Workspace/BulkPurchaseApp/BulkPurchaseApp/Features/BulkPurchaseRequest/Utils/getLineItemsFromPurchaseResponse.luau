local defineFastFlag = game:DefineFastFlag("BulkPurchaseHandleMissingFulfillmentGroupsKey", false)

local function getLineItemsFromPurchaseResponse(p)
	if defineFastFlag then
		if p.fulfillmentGroups and p.fulfillmentGroups[1] and p.fulfillmentGroups[1].lineItems then
			return p.fulfillmentGroups[1].lineItems
		end

		return {}
	elseif p.fulfillmentGroups[1] then
		return p.fulfillmentGroups[1].lineItems
	else
		return {}
	end
end

return getLineItemsFromPurchaseResponse
