local function mapLast(t1: {[any]: any}, p1: ((...any) -> ...any)) -- line: 12
	for i = #t1, 1, -1 do
		local v5 = p1(t1[i], i)

		if v5 ~= nil then
			return v5
		end
	end

	return nil
end

return mapLast
