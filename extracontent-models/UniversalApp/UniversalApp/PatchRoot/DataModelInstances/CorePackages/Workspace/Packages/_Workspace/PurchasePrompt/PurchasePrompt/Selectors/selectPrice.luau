local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local PurchasePromptParent = PurchasePrompt.Parent

require(PurchasePromptParent.IAPExperience)

local FFlagFixResaleDisplayPrice = require(PurchasePrompt.Flags.FFlagFixResaleDisplayPrice)
local FFlagPurchasePromptCartPricingEnabled = require(PurchasePrompt.Flags.FFlagPurchasePromptCartPricingEnabled)
local selectCartPricingOverride = require(script.Parent.selectCartPricingOverride)

local function selectPrice(t1: {[any]: any}) -- line: 30
	-- upvalues: FFlagFixResaleDisplayPrice (copy), FFlagPurchasePromptCartPricingEnabled (copy), selectCartPricingOverride (copy)
	local productInfo = t1.productInfo
	local v9 = productInfo.price or 0
	local v10 = productInfo.basePrice or v9
	local v11 = productInfo.priceDiscountDetails or {}

	if FFlagFixResaleDisplayPrice and t1.promptRequest then
		local collectibleItemInstanceId = t1.promptRequest.collectibleItemInstanceId

		if collectibleItemInstanceId and collectibleItemInstanceId ~= "" then
			local expectedPrice = t1.promptRequest.expectedPrice

			if expectedPrice ~= nil then
				v9 = expectedPrice
				v10 = expectedPrice
			end
		end
	end

	if FFlagPurchasePromptCartPricingEnabled then
		local v14 = selectCartPricingOverride(t1)

		if v14 ~= nil then
			v9 = v14.priceInRobux

			if v14.basePriceInRobux ~= nil then
				v10 = v14.basePriceInRobux
			end
		end
	end

	return {
		priceInRobux = v9,
		basePriceInRobux = v10,
		discounts = v11
	}
end

return selectPrice
