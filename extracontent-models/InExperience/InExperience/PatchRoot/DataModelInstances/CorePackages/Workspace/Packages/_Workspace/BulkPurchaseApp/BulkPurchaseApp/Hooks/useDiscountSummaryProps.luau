local BulkPurchaseApp = script:FindFirstAncestor("BulkPurchaseApp")
local parent = BulkPurchaseApp.Parent
local React = require(parent.React)

local IAPExperience = require(parent.IAPExperience)
local DiscountType = IAPExperience.DiscountType

require(BulkPurchaseApp.Store.Types)

local FFlagAXAddOffersToBulkPurchase = require(BulkPurchaseApp.Flags.FFlagAXAddOffersToBulkPurchase)

local function useDiscountSummaryProps(p, priceInRobux: number, p2: string?)
	return React.useMemo(function()
		if not p then
			return nil
		end

		local discounts = {}

		for _, discount in p.discounts do
			table.insert(discounts, {
				type = DiscountType[discount.discountCampaign] or DiscountType.Uncategorized,
				amountInRobux = discount.robuxDiscountAmount or 0,
				percent = discount.robuxDiscountPercentage or 0,
				localizedDiscountAttribution = discount.localizedDiscountAttribution
			})
		end

		local v = {
			itemPrice = {
				basePriceInRobux = p.originalPrice,
				priceInRobux = priceInRobux,
				discounts = discounts
			},
			savingsSummary = 0
		}
		local savingsSummary

		if FFlagAXAddOffersToBulkPurchase then
			savingsSummary = p2
		end

		v.savingsSummary = savingsSummary
		return v
	end, { p, priceInRobux, p2 })
end

return useDiscountSummaryProps
