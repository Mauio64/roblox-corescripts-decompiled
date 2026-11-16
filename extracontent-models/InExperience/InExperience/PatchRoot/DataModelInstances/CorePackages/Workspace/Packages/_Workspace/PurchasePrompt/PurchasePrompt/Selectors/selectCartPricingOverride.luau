local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local parent = PurchasePrompt.Parent

local IAPExperience = require(parent.IAPExperience)

local deriveCartPricingView = IAPExperience.deriveCartPricingView

local types = require(PurchasePrompt.types)
local productTypeEnum = types.ProductTypeEnum
local RequestType = require(PurchasePrompt.Enums.RequestType)

local function isCartPricingKind(productPayload, requestType: string?): boolean -- 1 equivalent call inferred from this helper
	if type(productPayload) == "table" then
		local kind = productPayload.kind

		if kind == productTypeEnum.Asset or kind == productTypeEnum.Bundle or kind == productTypeEnum.Look then
			return true
		end
	end

	return requestType == RequestType.GamePass or requestType == RequestType.Product
end

local function selectCartPricingOverride(data)
	if data == nil then
		return nil
	end

	local productPayload = data.productPayload
	local requestType = data.promptRequest and data.promptRequest.requestType

	if not isCartPricingKind(productPayload, requestType) then -- inferred equivalent call
		return nil
	end

	local cartPricing = data.cartPricing

	if cartPricing == nil then
		return nil
	end

	local v = deriveCartPricingView(cartPricing.response)

	if v == nil then
		return nil
	end

	return { priceInRobux = v.priceAfterDiscount, basePriceInRobux = v.originalPrice }
end

return selectCartPricingOverride
