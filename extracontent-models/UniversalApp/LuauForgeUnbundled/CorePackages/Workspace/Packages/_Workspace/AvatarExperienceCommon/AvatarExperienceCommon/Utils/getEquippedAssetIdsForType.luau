return function(p2, p3)
	local result = {}

	if not p2 then
		return result
	end

	local v5 = p2[p3]

	if v5 then
		for k, v6 in v5 do
			table.insert(result, k)
		end
	end

	return result
end
