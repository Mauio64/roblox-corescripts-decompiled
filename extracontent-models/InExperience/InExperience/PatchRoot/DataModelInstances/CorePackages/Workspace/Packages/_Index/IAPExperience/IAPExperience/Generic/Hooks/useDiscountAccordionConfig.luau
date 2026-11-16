local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local React = require(parent2.React)
local Foundation = require(parent2.Foundation)
local IconName = Foundation.Enums.IconName

require(parent.ProductPurchase.PricingTypes)

local function useDiscountAccordionConfig(data)
	local itemPrice = data.itemPrice
	local hasSubscriptionDiscount = data.hasSubscriptionDiscount
	local blackbirdSummaryText = data.blackbirdSummaryText
	local savingsSummary = data.savingsSummary
	local showAccordion

	if itemPrice.basePriceInRobux > itemPrice.priceInRobux then
		showAccordion = hasSubscriptionDiscount or #itemPrice.discounts >= 2
	else
		showAccordion = false
	end

	local accordionHeaderText = React.useMemo(function()
		if savingsSummary == nil or savingsSummary == "" then
			return blackbirdSummaryText
		end

		return savingsSummary
	end, { savingsSummary, blackbirdSummaryText })
	local accordionLeadingIcon

	if hasSubscriptionDiscount then
		accordionLeadingIcon = IconName.RobloxPlus
	else
		accordionLeadingIcon = IconName.Tag
	end

	return {
		showAccordion = showAccordion,
		accordionHeaderText = accordionHeaderText,
		accordionLeadingIcon = accordionLeadingIcon
	}
end

return useDiscountAccordionConfig
