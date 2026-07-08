local function filter(t1: {[any]: any}, p1: ((...any) -> ...any)) -- line: 6
	local t2 = {}

	for v5, v6 in t1 do
		if p1(v6, v5) then
			t2[v5] = v6
		end
	end

	return t2
end

return filter
