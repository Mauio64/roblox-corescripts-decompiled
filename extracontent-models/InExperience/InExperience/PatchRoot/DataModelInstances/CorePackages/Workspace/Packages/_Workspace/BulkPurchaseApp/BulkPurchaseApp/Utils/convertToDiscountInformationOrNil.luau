local BulkPurchaseApp = script:FindFirstAncestor("BulkPurchaseApp")

require(BulkPurchaseApp.Store.Types)

local function convertToDiscountInformationOrNil(items)
	if not (type(items) == "table" and next(items) ~= nil) then
		return nil
	end

	return items
end

return convertToDiscountInformationOrNil
