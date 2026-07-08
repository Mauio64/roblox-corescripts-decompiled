local BulkPurchaseApp = script:FindFirstAncestor("BulkPurchaseApp")

require(BulkPurchaseApp.Store.Types)

local function convertToDiscountInformationOrNil(p1) -- line: 6
	if type(p1) == "table" then
		if next(p1) == nil then
			return nil
		end

		return p1
	end

	return nil
end

return convertToDiscountInformationOrNil
