local function filterItemIds(items, p2)
	if p2 == nil then
		return items
	end

	local result = {}

	for k, item in items do
		if p2[item] then
			table.insert(result, item)
		end
	end

	return result
end

return filterItemIds
