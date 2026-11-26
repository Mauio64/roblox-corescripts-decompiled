local function mapCatalogDiscountInfoToPriceDiscountDetails(p2)
	if type(p2) ~= "table" or type(p2.discounts) ~= "table" or #p2.discounts == 0 then
		return nil
	end

	local result = {}

	for i, discount in ipairs(p2.discounts) do
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
