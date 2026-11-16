local function normalizeValue(item)
	if typeof(item) == "EnumItem" then
		return item.Name
	end

	if typeof(item) ~= "table" then
		return item
	end

	local result = {}

	for k, item2 in item do
		result[k] = normalizeValue(item2)
	end

	return result
end

return normalizeValue
