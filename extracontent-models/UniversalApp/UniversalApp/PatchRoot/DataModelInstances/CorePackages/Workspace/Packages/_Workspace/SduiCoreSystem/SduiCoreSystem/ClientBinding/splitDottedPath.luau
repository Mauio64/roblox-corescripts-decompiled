local t1 = {}

local function splitDottedPath(s1: string) -- line: 21
	-- upvalues: t1 (copy)
	local v4 = t1[s1]

	if v4 ~= nil then
		return v4
	end

	local parts = string.split(s1, ".")

	table.freeze(parts)
	t1[s1] = parts

	return parts
end

return splitDottedPath
