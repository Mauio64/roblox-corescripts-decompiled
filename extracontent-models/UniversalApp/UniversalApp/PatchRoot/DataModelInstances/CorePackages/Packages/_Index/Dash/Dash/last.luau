local function last(t1: {[any]: any}, p1: ((...any) -> ...any)?) -- line: 13
	for i = #t1, 1, -1 do
		local v5 = t1[i]

		if not p1 then
			return v5
		end

		if p1 and p1(v5, i) then
			return v5
		end
	end

	return nil
end

return last
