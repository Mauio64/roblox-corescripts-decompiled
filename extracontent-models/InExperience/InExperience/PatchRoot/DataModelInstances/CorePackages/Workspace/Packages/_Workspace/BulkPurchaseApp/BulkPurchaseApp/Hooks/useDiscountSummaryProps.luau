local BulkPurchaseApp = script:FindFirstAncestor("BulkPurchaseApp")
local BulkPurchaseAppParent = BulkPurchaseApp.Parent
local React = require(BulkPurchaseAppParent.React)
local DiscountType = require(BulkPurchaseAppParent.IAPExperience).DiscountType

require(BulkPurchaseApp.Store.Types)

local FFlagPurchasePromptFetchCartPricing = require(BulkPurchaseAppParent.SharedFlags).FFlagPurchasePromptFetchCartPricing

local function useDiscountSummaryProps(p1, n1: number) -- line: 16
	-- upvalues: React (copy), DiscountType (copy), FFlagPurchasePromptFetchCartPricing (copy)
	return React.useMemo(function() -- line: 20
		-- upvalues: p1 (copy), DiscountType (copy), FFlagPurchasePromptFetchCartPricing (copy), n1 (copy)
		if not p1 then
			return nil
		end

		local t1 = {}

		for _, v11 in p1.discounts do
			table.insert(t1, {
				type = DiscountType[v11.discountCampaign] or DiscountType.Uncategorized,
				amountInRobux = v11.robuxDiscountAmount or 0,
				percent = v11.robuxDiscountPercentage or 0,
				localizedDiscountAttribution = if not FFlagPurchasePromptFetchCartPricing then nil else v11.localizedDiscountAttribution
			})
		end

		return {
			itemPrice = {
				basePriceInRobux = p1.originalPrice,
				priceInRobux = n1,
				discounts = t1
			}
		}
	end, {
		p1,
		n1
	})
end

return useDiscountSummaryProps
