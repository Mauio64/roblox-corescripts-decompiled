local deriveCartPricingView = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/IAPExperience").deriveCartPricingView

local productTypeEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/types").ProductTypeEnum
local RequestType = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/RequestType")

local function isCartPricingKind(p2, p3): boolean
	if type(p2) == "table" then
		local kind = p2.kind

		if
			kind == productTypeEnum.Asset
			or kind == productTypeEnum.Bundle
			or kind == productTypeEnum.Look
		then
			return true
		end
	end

	return p3 == RequestType.GamePass or p3 == RequestType.Product
end

local function selectCartPricingOverride(data)
	if data == nil then
		return nil
	end

	local productPayload = data.productPayload
	local requestType = data.promptRequest and data.promptRequest.requestType
	local v5

	if type(productPayload) == "table" then
		local kind = productPayload.kind

		if
			kind == productTypeEnum.Asset
			or kind == productTypeEnum.Bundle
			or kind == productTypeEnum.Look
		then
			v5 = true
		else
			v5 = requestType == RequestType.GamePass or requestType == RequestType.Product
		end
	else
		v5 = requestType == RequestType.GamePass or requestType == RequestType.Product
	end

	if not v5 then
		return nil
	end

	local cartPricing = data.cartPricing

	if cartPricing == nil then
		return nil
	end

	local v6 = deriveCartPricingView(cartPricing.response)

	if v6 == nil then
		return nil
	end

	return { priceInRobux = v6.priceAfterDiscount, basePriceInRobux = v6.originalPrice }
end

return selectCartPricingOverride
