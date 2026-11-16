local function alwaysTrue(): boolean
	return true
end

local function count(list, p)
	local typeName = type(list)
	assert(typeName == "table", "expected a table for first argument, got " .. typeName)
	local v = p or alwaysTrue
	local count2 = 0

	for i = 1, #list do
		if v(list[i], i) then
			count2 += 1
		end
	end

	return count2
end

return count
