local function reduce(t1: {[any]: any}, p1: ((...any) -> ...any), p2) -- line: 14
	for v5, v6 in t1 do
		p2 = p1(p2, v6, v5)
	end

	return p2
end

return reduce
