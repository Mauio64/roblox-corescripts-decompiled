local function map(list, callback)
	local result = {}

	for i = 1, #list do
		result[i] = callback(list[i], i)
	end

	return result
end

return map
