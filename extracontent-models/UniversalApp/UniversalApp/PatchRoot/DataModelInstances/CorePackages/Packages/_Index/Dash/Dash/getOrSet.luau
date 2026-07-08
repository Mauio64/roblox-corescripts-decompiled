local function getOrSet(t1: {[any]: any}, p1, p2: ((...any) -> ...any)) -- line: 13
	if t1[p1] == nil then
		t1[p1] = p2(t1, p1)
	end

	return t1[p1]
end

return getOrSet
