local v = {}

local function splitDottedPath(value: string)
	local v2 = v[value]

	if v2 ~= nil then
		return v2
	end

	local v3 = string.split(value, ".")
	table.freeze(v3)
	v[value] = v3
	return v3
end

return splitDottedPath
