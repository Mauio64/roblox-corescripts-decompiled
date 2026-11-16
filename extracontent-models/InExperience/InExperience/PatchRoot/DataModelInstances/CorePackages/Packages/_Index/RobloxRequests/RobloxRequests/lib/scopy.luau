local function deepcopy(items)
	if type(items) ~= "table" then
		return items
	end

	local result = {}

	for k, item in next, items do
		result[deepcopy(k)] = deepcopy(item)
	end

	setmetatable(result, deepcopy((getmetatable(items))))
	return result
end

return deepcopy
