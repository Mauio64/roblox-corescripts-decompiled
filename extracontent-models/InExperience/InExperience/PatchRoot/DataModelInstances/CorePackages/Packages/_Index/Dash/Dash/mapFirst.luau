local function mapFirst(t1: {[any]: any}, p1: ((...any) -> ...any)) -- line: 12
	for i, v in ipairs(t1) do
		local v6 = p1(v, i)

		if v6 ~= nil then
			return v6
		end
	end

	return nil
end

return mapFirst
