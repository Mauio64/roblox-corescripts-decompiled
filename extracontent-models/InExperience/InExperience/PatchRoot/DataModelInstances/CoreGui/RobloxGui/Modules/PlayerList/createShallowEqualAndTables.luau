local function createShallowEqualAndTables(t1: {[any]: any}) -- line: 2
	local t2 = {}

	for _, v5 in t1 do
		t2[v5] = true
	end

	return function(p1, p2) -- line: 8
		-- upvalues: t2 (copy)
		for v8, v9 in p1 do
			local v10 = p2[v8]

			if not t2[v8] then
				if v9 == v10 then
					continue
				end

				return false
			end

			if typeof(v9) ~= "table" or typeof(v10) ~= "table" then
				return false
			end

			for v11, v12 in v9 do
				if v12 ~= v10[v11] then
					return false
				end
			end

			for v13, _ in v10 do
				if v9[v13] == nil then
					return false
				end
			end
		end

		for v15, _ in p2 do
			if p1[v15] == nil then
				return false
			end
		end

		return true
	end
end

return createShallowEqualAndTables
