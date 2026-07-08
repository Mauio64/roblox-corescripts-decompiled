local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local PurchaseError = require(PurchasePrompt.Enums.PurchaseError)

local function parseDevProductPurchaseError(p1) -- line: 6
	-- upvalues: PurchaseError (copy)
	if PurchaseError.isMember(p1) then
		return p1
	end

	if type(p1) == "table" and p1.errorCode == "PendingProductsLimitExceeded" then
		return PurchaseError.PendingProductsLimitExceeded
	end

	return p1
end

return parseDevProductPurchaseError
