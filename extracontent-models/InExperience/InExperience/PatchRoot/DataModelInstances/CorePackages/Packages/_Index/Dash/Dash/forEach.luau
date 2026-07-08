local function forEach(t1: {[any]: any}, p1: ((...any) -> ...any)) -- line: 12
	for v4, v5 in t1 do
		p1(v5, v4)
	end
end

return forEach
