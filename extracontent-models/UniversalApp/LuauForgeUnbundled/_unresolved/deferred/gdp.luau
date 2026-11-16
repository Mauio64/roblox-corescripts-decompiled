return function(items, p2)
	local result = {}

	for k, item in pairs(items) do
		result[k] = {}

		for k2, v5 in pairs(item) do
			result[k][k2] = v5
		end

		local v5 = p2 and p2[k]

		if v5 then
			result[k].lastUpdated = v5.lastUpdated
		end
	end

	return result
end
