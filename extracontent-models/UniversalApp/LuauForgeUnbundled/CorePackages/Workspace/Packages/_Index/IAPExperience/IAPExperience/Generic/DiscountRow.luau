local React = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/React")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/Foundation")
local getIconRichText = Foundation.Utility.getIconRichText
local iconName = Foundation.Enums.IconName

local formatNumber = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Utility/formatNumber")

local LocalizationService = game:GetService("LocalizationService")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/Localization").Hooks.useLocalization
local PriceLineItem = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Generic/PriceLineItem")

local discountType = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/ProductPurchase/PricingTypes").DiscountType

local iconRichText = getIconRichText(iconName.Robux)

local function resolveLabel(p2, p3)
	if p2 == nil or p2 == "" then
		return p3
	end

	return p2
end

local function RobloxSubscriptionDiscountRow(props)
	local discount = props.discount
	local robloxLocaleId = LocalizationService.RobloxLocaleId

	local v5 = React.useMemo(function()
		return string.format("- %s %s", iconRichText, formatNumber(robloxLocaleId, discount.amountInRobux))
	end, { robloxLocaleId, discount.amountInRobux })
	local v7 = useLocalization({
		discountLabel = discount.percent > 0 and {
			"IAPExperience.PurchasePrompt.Label.BlackbirdDiscountEligibleItems",
			discountPercentage = discount.percent
		} or "IAPExperience.PurchasePrompt.Label.BlackbirdDiscountNoPercent"
	})

	local createElement = React.createElement
	local label = props.label
	local v10 = v7.discountLabel

	if label ~= nil and label ~= "" then
		v10 = label
	end

	return createElement(PriceLineItem, {
		label = v10,
		amount = v5,
		LayoutOrder = props.LayoutOrder
	})
end

local function GenericDiscountRow(props)
	local discount = props.discount
	local robloxLocaleId = LocalizationService.RobloxLocaleId

	local v5 = React.useMemo(function()
		return string.format("- %s %s", iconRichText, formatNumber(robloxLocaleId, discount.amountInRobux))
	end, { robloxLocaleId, discount.amountInRobux })
	local v7 = useLocalization({
		discountLabel = discount.percent > 0 and {
			"IAPExperience.PurchasePrompt.Label.GenericDiscount",
			discountPercentage = discount.percent
		} or "IAPExperience.PurchasePrompt.Label.GenericDiscountNoPercent"
	})

	local createElement = React.createElement
	local label = props.label
	local v10 = v7.discountLabel

	if label ~= nil and label ~= "" then
		v10 = label
	end

	return createElement(PriceLineItem, {
		label = v10,
		amount = v5,
		LayoutOrder = props.LayoutOrder
	})
end

local RobloxSubscriptionDiscountRows = {
	[discountType.BlackbirdSubscription] = RobloxSubscriptionDiscountRow,
	[discountType.RobloxPlusSubscription] = RobloxSubscriptionDiscountRow
}

local function DiscountRow(p2)
	local v5 = RobloxSubscriptionDiscountRows[p2.discount.type] or GenericDiscountRow
	return React.createElement(v5, p2)
end

return DiscountRow
