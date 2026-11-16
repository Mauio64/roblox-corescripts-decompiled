local PurchaseError = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/PurchaseError")

local function parseDevProductPurchaseError(p2)
	if PurchaseError.isMember(p2) then
		return p2
	end

	if type(p2) == "table" and p2.errorCode == "PendingProductsLimitExceeded" then
		return PurchaseError.PendingProductsLimitExceeded
	end

	return p2
end

return parseDevProductPurchaseError
