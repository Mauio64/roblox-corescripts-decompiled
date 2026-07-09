local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local FFlagPurchasePromptCartPricingEnabled = require(PurchasePrompt.Flags.FFlagPurchasePromptCartPricingEnabled)

local function mapCatalogDiscountInfoToPriceDiscountDetails(p1) -- line: 4
	-- upvalues: FFlagPurchasePromptCartPricingEnabled (copy)
	if type(p1) ~= "table" or (type(p1.discounts) ~= "table" or #p1.discounts == 0) then
		return nil
	end

	local t1 = {}

	for _, v in ipairs(p1.discounts) do
		table.insert(t1, {
			Type = v.discountCampaign or "",
			AmountInRobux = v.robuxDiscountAmount or 0,
			Percent = v.robuxDiscountPercentage or 0,
			LocalizedDiscountAttribution = if not FFlagPurchasePromptCartPricingEnabled then nil else v.localizedDiscountAttribution
		})
	end

	return t1
end

return mapCatalogDiscountInfoToPriceDiscountDetails
