local IAPExperience = script:FindFirstAncestor("IAPExperience")
local IAPExperienceParent = IAPExperience.Parent
local React = require(IAPExperienceParent.React)
local Foundation = require(IAPExperienceParent.Foundation)
local getIconRichText = Foundation.Utility.getIconRichText
local IconName = Foundation.Enums.IconName
local formatNumber = require(IAPExperience.Utility.formatNumber)
local LocalizationService = game:GetService("LocalizationService")
local useLocalization = require(IAPExperienceParent.Localization).Hooks.useLocalization
local PriceLineItem = require(IAPExperience.Generic.PriceLineItem)
local DiscountType = require(IAPExperience.ProductPurchase.PricingTypes).DiscountType
local FFlagPurchasePromptFetchCartPricing = require(IAPExperience.Parent.SharedFlags).FFlagPurchasePromptFetchCartPricing
local v13 = getIconRichText(IconName.Robux)

local function resolveLabel(s1: string?, s2: string) -- line: 32
	if s1 ~= nil and s1 ~= "" then
		return s1
	end

	return s2
end
local function RobloxSubscriptionDiscountRow(t1: {[any]: any}) -- line: 39
	-- upvalues: LocalizationService (copy), React (copy), v13 (copy), formatNumber (copy), useLocalization (copy), PriceLineItem (copy), FFlagPurchasePromptFetchCartPricing (copy)
	local discount = t1.discount
	local RobloxLocaleId = LocalizationService.RobloxLocaleId
	local v24 = React.useMemo(function() -- line: 43
		-- upvalues: v13 (copy), formatNumber (copy), RobloxLocaleId (copy), discount (copy)
		return string.format("- %s %s", v13, formatNumber(RobloxLocaleId, discount.amountInRobux))
	end, {
		RobloxLocaleId,
		discount.amountInRobux
	})
	local v25 = discount.percent > 0
	local v26 = useLocalization({
		discountLabel = not v25 and "IAPExperience.PurchasePrompt.Label.BlackbirdDiscountNoPercent" or {
			"IAPExperience.PurchasePrompt.Label.BlackbirdDiscount",
			discountPercentage = discount.percent
		}
	})
	local createElement = React.createElement
	local v28 = PriceLineItem
	local t2 = {}
	local v32

	if FFlagPurchasePromptFetchCartPricing then
		local label = t1.label
		local discountLabel = v26.discountLabel

		v32 = if label == nil or label == "" then discountLabel else label
	else
		v32 = v26.discountLabel
	end

	t2.label = v32
	t2.amount = v24
	t2.LayoutOrder = t1.LayoutOrder

	return createElement(v28, t2)
end
local function GenericDiscountRow(t3: {[any]: any}) -- line: 65
	-- upvalues: LocalizationService (copy), React (copy), v13 (copy), formatNumber (copy), useLocalization (copy), PriceLineItem (copy), FFlagPurchasePromptFetchCartPricing (copy)
	local discount = t3.discount
	local RobloxLocaleId = LocalizationService.RobloxLocaleId
	local v36 = React.useMemo(function() -- line: 69
		-- upvalues: v13 (copy), formatNumber (copy), RobloxLocaleId (copy), discount (copy)
		return string.format("- %s %s", v13, formatNumber(RobloxLocaleId, discount.amountInRobux))
	end, {
		RobloxLocaleId,
		discount.amountInRobux
	})
	local v37 = discount.percent > 0
	local v38 = useLocalization({
		discountLabel = not v37 and "IAPExperience.PurchasePrompt.Label.GenericDiscountNoPercent" or {
			"IAPExperience.PurchasePrompt.Label.GenericDiscount",
			discountPercentage = discount.percent
		}
	})
	local createElement = React.createElement
	local v40 = PriceLineItem
	local t4 = {}
	local v44

	if FFlagPurchasePromptFetchCartPricing then
		local label = t3.label
		local discountLabel = v38.discountLabel

		v44 = if label == nil or label == "" then discountLabel else label
	else
		v44 = v38.discountLabel
	end

	t4.label = v44
	t4.amount = v36
	t4.LayoutOrder = t3.LayoutOrder

	return createElement(v40, t4)
end

local t5 = {
	[DiscountType.BlackbirdSubscription] = RobloxSubscriptionDiscountRow,
	[DiscountType.RobloxPlusSubscription] = RobloxSubscriptionDiscountRow
}

local function DiscountRow(t6: {[any]: any}) -- line: 96
	-- upvalues: t5 (copy), GenericDiscountRow (copy), React (copy)
	local v46 = t5[t6.discount.type] or GenericDiscountRow

	return React.createElement(v46, t6)
end

return DiscountRow
