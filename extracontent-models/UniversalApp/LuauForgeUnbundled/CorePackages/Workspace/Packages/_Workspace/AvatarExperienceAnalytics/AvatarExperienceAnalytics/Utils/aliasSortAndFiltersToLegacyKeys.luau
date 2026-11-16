local v5 = {
	sort = "sortEnumValue",
	filterSalesType = "filterSalesTypeEnumValue",
	filterCreators = "filterCreatorsTypeEnumValue",
	filterPrice = "filterPriceEnumValue",
	filterUnavailableItems = "filterUnavailableItemsEnumValue"
}

local function aliasSortAndFiltersToLegacyKeys(p2)
	if type(p2) ~= "table" then
		return p2
	end

	local clone = table.clone(p2)

	for k, v6 in v5 do
		local v7 = p2[k]

		if v7 ~= nil then
			clone[v6] = v7
		end
	end

	return clone
end

return aliasSortAndFiltersToLegacyKeys
