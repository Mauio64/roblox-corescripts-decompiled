local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local PurchasePromptParent = PurchasePrompt.Parent
local deriveCartPricingView = require(PurchasePromptParent.IAPExperience).deriveCartPricingView
local ProductTypeEnum = require(PurchasePrompt.types).ProductTypeEnum

local function isCartPricingKind(t1: {[any]: any}?) -- line: 38
	-- upvalues: ProductTypeEnum (copy)
	if type(t1) ~= "table" then
		return false
	end

	local kind = t1.kind

	return kind == ProductTypeEnum.Asset or (kind == ProductTypeEnum.Bundle or kind == ProductTypeEnum.Look)
end
local function selectCartPricingOverride(t2: {[any]: any}?) -- line: 46
	-- upvalues: ProductTypeEnum (copy), deriveCartPricingView (copy)
	if t2 == nil then
		return nil
	end

	local productPayload = t2.productPayload
	local v11

	if type(productPayload) ~= "table" then
		v11 = false
	else
		local kind = productPayload.kind

		v11 = kind == ProductTypeEnum.Asset or (kind == ProductTypeEnum.Bundle or kind == ProductTypeEnum.Look)
	end

	if not v11 then
		return nil
	end

	local cartPricing = t2.cartPricing

	if cartPricing == nil then
		return nil
	end

	local v14 = deriveCartPricingView(cartPricing.response)

	if v14 == nil then
		return nil
	end

	return {
		priceInRobux = v14.priceAfterDiscount,
		basePriceInRobux = v14.originalPrice
	}
end

return selectCartPricingOverride
