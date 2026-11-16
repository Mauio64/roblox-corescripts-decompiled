local v = {
	sort = "sortEnumValue",
	filterSalesType = "filterSalesTypeEnumValue",
	filterCreators = "filterCreatorsTypeEnumValue",
	filterPrice = "filterPriceEnumValue",
	filterUnavailableItems = "filterUnavailableItemsEnumValue"
}

local function aliasSortAndFiltersToLegacyKeys(p)
	if type(p) ~= "table" then
		return p
	end

	local clone = table.clone(p)

	for k, v2 in v do
		local v3 = p[k]

		if v3 ~= nil then
			clone[v2] = v3
		end
	end

	return clone
end

return aliasSortAndFiltersToLegacyKeys
