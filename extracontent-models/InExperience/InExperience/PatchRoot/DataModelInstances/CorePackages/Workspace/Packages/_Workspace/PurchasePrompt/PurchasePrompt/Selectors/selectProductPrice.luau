local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local parent = PurchasePrompt.Parent
local getPlayerPrice = require(PurchasePrompt.Utils.getPlayerPrice)

local SharedFlags = require(parent.SharedFlags)
local FFlagAXSupportRentalPurchaseInUnifiedProductPurchaseFlow = SharedFlags.FFlagAXSupportRentalPurchaseInUnifiedProductPurchaseFlow
local selectCartPricingOverride = require(script.Parent.selectCartPricingOverride)

local function selectProductPrice(data)
	local collectibleItemInstanceId = data.promptRequest.collectibleItemInstanceId
	local expectedPrice = data.promptRequest.expectedPrice

	local v = data.accountInfo.membershipType == 4

	local productPrice = getPlayerPrice(data.productInfo, v)

	if collectibleItemInstanceId and collectibleItemInstanceId ~= "" then
		productPrice = expectedPrice
	elseif
		FFlagAXSupportRentalPurchaseInUnifiedProductPurchaseFlow
		and data.productPayload
		and data.productPayload.timedOptionDays ~= nil
	then
		productPrice = expectedPrice
	end

	local v2 = selectCartPricingOverride(data)

	if v2 ~= nil then
		productPrice = v2.priceInRobux
	end

	return productPrice
end

return selectProductPrice
