require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/IAPExperience")
local FFlagFixResaleDisplayPrice = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Flags/FFlagFixResaleDisplayPrice")
local selectCartPricingOverride = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Selectors/selectCartPricingOverride")

local function selectPrice(p2)
	local productInfo = p2.productInfo

	local v5 = productInfo.price or 0
	local v6 = productInfo.basePrice or v5
	local priceDiscountDetails = productInfo.priceDiscountDetails or {}

	if FFlagFixResaleDisplayPrice and p2.promptRequest then
		local collectibleItemInstanceId = p2.promptRequest.collectibleItemInstanceId

		if collectibleItemInstanceId and collectibleItemInstanceId ~= "" then
			local expectedPrice = p2.promptRequest.expectedPrice

			if expectedPrice ~= nil then
				v6 = expectedPrice
				v5 = v6
			end
		end
	end

	local v7 = selectCartPricingOverride(p2)

	if v7 ~= nil then
		v5 = v7.priceInRobux

		if v7.basePriceInRobux ~= nil then
			v6 = v7.basePriceInRobux
		end
	end

	return {
		priceInRobux = v5,
		basePriceInRobux = v6,
		discounts = priceDiscountDetails,
		savingsSummaryOverride = productInfo.savingsSummaryOverride
	}
end

return selectPrice
