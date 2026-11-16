return function(items, p)
	local result = {}

	for _, item in pairs(items) do
		local v = tostring(item)
		local v2 = p[v]

		if v2 then
			result[v] = v2
		end
	end

	return result
end
