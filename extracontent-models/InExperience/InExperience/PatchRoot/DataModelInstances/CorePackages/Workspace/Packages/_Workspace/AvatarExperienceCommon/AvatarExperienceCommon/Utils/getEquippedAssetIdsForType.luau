return function(t1: {[any]: any}, s1: string) -- line: 1
	local t2 = {}

	if not t1 then
		return t2
	end

	local v4 = t1[s1]

	if v4 then
		for v5, _ in v4 do
			table.insert(t2, v5)
		end
	end

	return t2
end
