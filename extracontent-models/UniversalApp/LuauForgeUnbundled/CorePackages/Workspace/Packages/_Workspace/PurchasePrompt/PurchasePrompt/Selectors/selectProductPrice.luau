local getPlayerPrice = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/getPlayerPrice")

local fFlagAXSupportRentalPurchaseInUnifiedProductPurchaseFlow = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/SharedFlags").FFlagAXSupportRentalPurchaseInUnifiedProductPurchaseFlow
local selectCartPricingOverride = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Selectors/selectCartPricingOverride")

local function selectProductPrice(data)
	local collectibleItemInstanceId = data.promptRequest.collectibleItemInstanceId
	local expectedPrice = data.promptRequest.expectedPrice

	local v5 = data.accountInfo.membershipType == 4

	local productPrice = getPlayerPrice(data.productInfo, v5)

	if collectibleItemInstanceId and collectibleItemInstanceId ~= "" then
		productPrice = expectedPrice
	elseif
		fFlagAXSupportRentalPurchaseInUnifiedProductPurchaseFlow
		and data.productPayload
		and data.productPayload.timedOptionDays ~= nil
	then
		productPrice = expectedPrice
	end

	local v6 = selectCartPricingOverride(data)

	if v6 ~= nil then
		productPrice = v6.priceInRobux
	end

	return productPrice
end

return selectProductPrice
