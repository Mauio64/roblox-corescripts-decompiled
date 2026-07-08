local function mapOne(t1: {[any]: any}, p1: ((...any) -> ...any)?) -- line: 14
	for v4, v5 in t1 do
		local v6 = if not p1 then v5 else p1(v5, v4)

		if v6 ~= nil then
			return v6
		end
	end

	return nil
end

return mapOne
