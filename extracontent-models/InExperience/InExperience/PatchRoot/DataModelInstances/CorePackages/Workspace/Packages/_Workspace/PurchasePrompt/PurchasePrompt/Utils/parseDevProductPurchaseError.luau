local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local PurchaseError = require(PurchasePrompt.Enums.PurchaseError)

local function parseDevProductPurchaseError(p)
	if PurchaseError.isMember(p) then
		return p
	end

	if type(p) == "table" and p.errorCode == "PendingProductsLimitExceeded" then
		return PurchaseError.PendingProductsLimitExceeded
	end

	return p
end

return parseDevProductPurchaseError
