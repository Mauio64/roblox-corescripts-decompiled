local v5 = {}

local function splitDottedPath(value)
	local v6 = v5[value]

	if v6 ~= nil then
		return v6
	end

	local v7 = string.split(value, ".")
	table.freeze(v7)
	v5[value] = v7
	return v7
end

return splitDottedPath
