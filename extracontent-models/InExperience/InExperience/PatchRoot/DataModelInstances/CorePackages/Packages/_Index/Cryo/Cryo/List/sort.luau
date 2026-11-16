local function sort(list, p)
	local result = {}

	for i = 1, #list do
		result[i] = list[i]
	end

	table.sort(result, p)

	return result
end

return sort
