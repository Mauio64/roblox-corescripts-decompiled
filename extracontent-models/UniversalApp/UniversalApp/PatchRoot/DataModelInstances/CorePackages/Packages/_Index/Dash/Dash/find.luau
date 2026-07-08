local function find(t1: {[any]: any}, p1: ((...any) -> ...any)) -- line: 13
	for v4, v5 in t1 do
		if p1(v5, v4) then
			return v5
		end
	end

	return nil
end

return find
