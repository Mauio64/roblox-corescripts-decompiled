local function alwaysTrue(): boolean
	return true
end

local function count(items, p)
	local typeName = type(items)
	assert(typeName == "table", "expected a table for first argument, got " .. typeName)
	local v = p or alwaysTrue
	local count2 = 0

	for k, item in pairs(items) do
		if v(item, k) then
			count2 += 1
		end
	end

	return count2
end

return count
