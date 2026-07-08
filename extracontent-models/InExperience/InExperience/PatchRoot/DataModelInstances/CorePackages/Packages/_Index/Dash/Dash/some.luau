local function some(t1: {[any]: any}, p1: ((...any) -> ...any)) -- line: 12
	for v4, v5 in t1 do
		if p1(v5, v4) then
			return true
		end
	end

	return false
end

return some
