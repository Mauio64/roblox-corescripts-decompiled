return function(p1, p2) -- line: 2
	local t1 = {}

	for k, v in pairs(p1) do
		t1[k] = {}

		for k2, v2 in pairs(v) do
			t1[k][k2] = v2
		end

		local v8 = p2 and p2[k]

		if v8 then
			t1[k].lastUpdated = v8.lastUpdated
		end
	end

	return t1
end
