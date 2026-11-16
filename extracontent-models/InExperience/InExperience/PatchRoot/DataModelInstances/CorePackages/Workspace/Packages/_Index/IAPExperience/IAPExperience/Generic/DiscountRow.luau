local IAPExperience = script:FindFirstAncestor("IAPExperience")
local parent = IAPExperience.Parent

local React = require(parent.React)

local Foundation = require(parent.Foundation)
local getIconRichText = Foundation.Utility.getIconRichText
local IconName = Foundation.Enums.IconName

local formatNumber = require(IAPExperience.Utility.formatNumber)

local LocalizationService = game:GetService("LocalizationService")
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local PriceLineItem = require(IAPExperience.Generic.PriceLineItem)

local PricingTypes = require(IAPExperience.ProductPurchase.PricingTypes)
local DiscountType = PricingTypes.DiscountType

local iconRichText = getIconRichText(IconName.Robux)

local function resolveLabel(label: string?, discountLabel: string) -- 2 equivalent calls inferred from this helper
	return if label == nil or label == "" then discountLabel else label
end

local function RobloxSubscriptionDiscountRow(props)
	local discount = props.discount
	local robloxLocaleId = LocalizationService.RobloxLocaleId

	local amount = React.useMemo(function()
		return string.format("- %s %s", iconRichText, formatNumber(robloxLocaleId, discount.amountInRobux))
	end, { robloxLocaleId, discount.amountInRobux })
	local v = useLocalization({
		discountLabel = discount.percent > 0 and {
			"IAPExperience.PurchasePrompt.Label.BlackbirdDiscountEligibleItems",
			discountPercentage = discount.percent
		} or "IAPExperience.PurchasePrompt.Label.BlackbirdDiscountNoPercent"
	})

	return React.createElement(PriceLineItem, {
		label = resolveLabel(props.label, v.discountLabel), -- inferred equivalent call
		amount = amount,
		LayoutOrder = props.LayoutOrder
	})
end

local function GenericDiscountRow(props)
	local discount = props.discount
	local robloxLocaleId = LocalizationService.RobloxLocaleId

	local amount = React.useMemo(function()
		return string.format("- %s %s", iconRichText, formatNumber(robloxLocaleId, discount.amountInRobux))
	end, { robloxLocaleId, discount.amountInRobux })
	local v = useLocalization({
		discountLabel = discount.percent > 0 and {
			"IAPExperience.PurchasePrompt.Label.GenericDiscount",
			discountPercentage = discount.percent
		} or "IAPExperience.PurchasePrompt.Label.GenericDiscountNoPercent"
	})

	return React.createElement(PriceLineItem, {
		label = resolveLabel(props.label, v.discountLabel), -- inferred equivalent call
		amount = amount,
		LayoutOrder = props.LayoutOrder
	})
end

local RobloxSubscriptionDiscountRows = {
	[DiscountType.BlackbirdSubscription] = RobloxSubscriptionDiscountRow,
	[DiscountType.RobloxPlusSubscription] = RobloxSubscriptionDiscountRow
}

local function DiscountRow(p)
	local v = RobloxSubscriptionDiscountRows[p.discount.type] or GenericDiscountRow
	return React.createElement(v, p)
end

return DiscountRow
