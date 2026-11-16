local insert = table.insert

local function reverse(list)
	local result = {}

	for i = #list, 1, -1 do
		insert(result, list[i])
	end

	return result
end

return reverse
