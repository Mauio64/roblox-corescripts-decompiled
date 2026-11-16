return function(items, p2)
	local result = {}

	for k, item in pairs(items) do
		local v5 = tostring(item)
		local v6 = p2[v5]

		if v6 then
			result[v5] = v6
		end
	end

	return result
end
