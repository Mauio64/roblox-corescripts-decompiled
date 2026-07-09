local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local PurchasePromptParent = PurchasePrompt.Parent
local getPlayerPrice = require(PurchasePrompt.Utils.getPlayerPrice)
local FFlagAXSupportRentalPurchaseInUnifiedProductPurchaseFlow = require(PurchasePromptParent.SharedFlags).FFlagAXSupportRentalPurchaseInUnifiedProductPurchaseFlow
local FFlagPurchasePromptCartPricingEnabled = require(PurchasePrompt.Flags.FFlagPurchasePromptCartPricingEnabled)
local selectCartPricingOverride = require(script.Parent.selectCartPricingOverride)

local function selectProductPrice(t1: {[any]: any}) -- line: 31
	-- upvalues: getPlayerPrice (copy), FFlagAXSupportRentalPurchaseInUnifiedProductPurchaseFlow (copy), FFlagPurchasePromptCartPricingEnabled (copy), selectCartPricingOverride (copy)
	local collectibleItemInstanceId = t1.promptRequest.collectibleItemInstanceId
	local expectedPrice = t1.promptRequest.expectedPrice
	local v11 = t1.accountInfo.membershipType == 4
	local v12 = getPlayerPrice(t1.productInfo, v11)

	if collectibleItemInstanceId and collectibleItemInstanceId ~= "" or FFlagAXSupportRentalPurchaseInUnifiedProductPurchaseFlow and t1.productPayload and t1.productPayload.timedOptionDays ~= nil then
		v12 = expectedPrice
	end

	if FFlagPurchasePromptCartPricingEnabled then
		local v13 = selectCartPricingOverride(t1)

		if v13 ~= nil then
			v12 = v13.priceInRobux
		end
	end

	return v12
end

return selectProductPrice
