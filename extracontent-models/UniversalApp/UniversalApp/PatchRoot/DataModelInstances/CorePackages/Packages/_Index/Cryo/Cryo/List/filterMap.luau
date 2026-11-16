local function filterMap(list, callback)
	local result = {}
	local v = 1

	for i = 1, #list do
		local v2 = callback(list[i], i)

		if v2 == nil then
			continue
		end

		result[v] = v2
		v += 1
	end

	return result
end

return filterMap
