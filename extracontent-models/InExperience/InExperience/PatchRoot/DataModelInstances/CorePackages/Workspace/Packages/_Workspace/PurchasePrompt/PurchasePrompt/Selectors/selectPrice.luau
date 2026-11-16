local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local parent = PurchasePrompt.Parent

require(parent.IAPExperience)
local FFlagFixResaleDisplayPrice = require(PurchasePrompt.Flags.FFlagFixResaleDisplayPrice)
local selectCartPricingOverride = require(script.Parent.selectCartPricingOverride)

local function selectPrice(p)
	local productInfo = p.productInfo

	local priceInRobux = productInfo.price or 0
	local basePriceInRobux = productInfo.basePrice or priceInRobux
	local priceDiscountDetails = productInfo.priceDiscountDetails or {}

	if FFlagFixResaleDisplayPrice and p.promptRequest then
		local collectibleItemInstanceId = p.promptRequest.collectibleItemInstanceId

		if collectibleItemInstanceId and collectibleItemInstanceId ~= "" then
			local expectedPrice = p.promptRequest.expectedPrice

			if expectedPrice ~= nil then
				basePriceInRobux = expectedPrice
				priceInRobux = basePriceInRobux
			end
		end
	end

	local v = selectCartPricingOverride(p)

	if v ~= nil then
		priceInRobux = v.priceInRobux

		if v.basePriceInRobux ~= nil then
			basePriceInRobux = v.basePriceInRobux
		end
	end

	return {
		priceInRobux = priceInRobux,
		basePriceInRobux = basePriceInRobux,
		discounts = priceDiscountDetails,
		savingsSummaryOverride = productInfo.savingsSummaryOverride
	}
end

return selectPrice
