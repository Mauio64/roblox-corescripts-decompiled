local insert = table.insert

local function slice(list, value: number?, p: number?)
	local result = {}

	local v = value or 1
	local v2 = p or #list

	if v < 0 then
		v = #list + v
	end

	if v2 and v2 < 0 then
		v2 = #list + v2
	end

	for i = v, v2 do
		insert(result, list[i])
	end

	return result
end

return slice
