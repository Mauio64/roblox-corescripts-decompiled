local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local React = require(ParentParentParent.React)
local IconName = require(ParentParentParent.Foundation).Enums.IconName

require(ParentParent.ProductPurchase.PricingTypes)

local function useDiscountAccordionConfig(t1: {[any]: any}) -- line: 24
	-- upvalues: React (copy), IconName (copy)
	local itemPrice = t1.itemPrice
	local hasSubscriptionDiscount = t1.hasSubscriptionDiscount
	local blackbirdSummaryText = t1.blackbirdSummaryText
	local savingsSummary = t1.savingsSummary
	local v11 = itemPrice.basePriceInRobux > itemPrice.priceInRobux and (hasSubscriptionDiscount or #itemPrice.discounts >= 2)
	local v12 = React.useMemo(function() -- line: 33
		-- upvalues: savingsSummary (copy), blackbirdSummaryText (copy)
		if savingsSummary ~= nil and savingsSummary ~= "" then
			return savingsSummary
		end

		return blackbirdSummaryText
	end, {
		savingsSummary,
		blackbirdSummaryText
	})
	local v13 = if hasSubscriptionDiscount then IconName.RobloxPlus else IconName.Tag

	return {
		showAccordion = v11,
		accordionHeaderText = v12,
		accordionLeadingIcon = v13
	}
end

return useDiscountAccordionConfig
