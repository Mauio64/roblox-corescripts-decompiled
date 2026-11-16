local React = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/React")
local iconName = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/Foundation").Enums.IconName

require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/ProductPurchase/PricingTypes")

local function useDiscountAccordionConfig(data)
	local itemPrice = data.itemPrice
	local hasSubscriptionDiscount = data.hasSubscriptionDiscount
	local blackbirdSummaryText = data.blackbirdSummaryText
	local savingsSummary = data.savingsSummary
	local v5

	if itemPrice.basePriceInRobux > itemPrice.priceInRobux then
		v5 = hasSubscriptionDiscount or #itemPrice.discounts >= 2
	else
		v5 = false
	end

	local v6 = React.useMemo(function()
		if savingsSummary == nil or savingsSummary == "" then
			return blackbirdSummaryText
		end

		return savingsSummary
	end, { savingsSummary, blackbirdSummaryText })

	local v7 = if hasSubscriptionDiscount then iconName.RobloxPlus else iconName.Tag

	return { showAccordion = v5, accordionHeaderText = v6, accordionLeadingIcon = v7 }
end

return useDiscountAccordionConfig
