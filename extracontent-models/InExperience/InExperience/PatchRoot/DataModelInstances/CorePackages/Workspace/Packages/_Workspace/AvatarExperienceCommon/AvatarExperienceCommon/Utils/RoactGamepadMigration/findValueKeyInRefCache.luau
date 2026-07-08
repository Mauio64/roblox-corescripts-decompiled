local function findValueKeyInRefCache(p1, t1: {[any]: any}) -- line: 1
	for v4, v5 in t1 do
		if p1 == v5.current then
			return v4
		end
	end

	return nil
end

return findValueKeyInRefCache
