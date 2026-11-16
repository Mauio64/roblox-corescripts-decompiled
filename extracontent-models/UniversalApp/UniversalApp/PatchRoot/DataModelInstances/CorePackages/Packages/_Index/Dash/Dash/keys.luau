local insert = table.insert

local function keys(items)
	local result = {}

	for k, _ in items do
		insert(result, k)
	end

	return result
end

return keys
