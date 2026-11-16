local function mapCatalogDiscountInfoToPriceDiscountDetails(p)
	if type(p) ~= "table" or type(p.discounts) ~= "table" or #p.discounts == 0 then
		return nil
	end

	local result = {}

	for _, discount in ipairs(p.discounts) do
		table.insert(result, {
			Type = discount.discountCampaign or "",
			AmountInRobux = discount.robuxDiscountAmount or 0,
			Percent = discount.robuxDiscountPercentage or 0,
			LocalizedDiscountAttribution = discount.localizedDiscountAttribution
		})
	end

	return result
end

return mapCatalogDiscountInfoToPriceDiscountDetails
