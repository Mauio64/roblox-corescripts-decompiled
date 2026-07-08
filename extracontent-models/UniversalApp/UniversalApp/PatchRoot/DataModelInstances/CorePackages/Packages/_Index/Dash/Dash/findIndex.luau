local function findIndex(t1: {[any]: any}, p1: ((...any) -> ...any)) -- line: 10
	for i, v in ipairs(t1) do
		if p1(v, i) then
			return i
		end
	end

	return nil
end

return findIndex
