local insert = table.insert

local function splitOn(value: string, p: string)
	local result = {}
	local result2 = {}
	local v = 1

	if p then
		local v2, v3 = value:find(p, v)

		while v2 do
			insert(result2, value:sub(v2, v3))
			insert(result, value:sub(v, v2 - 1))
			v = v3 + 1
			v2, v3 = value:find(p, v)
		end

		insert(result, value:sub(v))
		return result, result2
	end

	for i = 1, #value do
		insert(result, value:sub(i, i))
	end

	return result
end

return splitOn
