local function map(t1: {[any]: any}, p1: ((...any) -> ...any)) -- line: 8
	local t2 = {}

	for v5, v6 in t1 do
		local v7, v8 = p1(v6, v5)
		local v9 = if v8 ~= nil then v8 else v5

		if v7 ~= nil then
			t2[v9] = v7
		end
	end

	return t2
end

return map
