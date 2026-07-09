require(script.Parent.types)

local t1 = {}

return {
	add = function(n1: number, p1: ((...any) -> ...any)) -- line: 11
		-- upvalues: t1 (ref)
		local v4 = t1[n1]

		if v4 == nil then
			v4 = {}
			t1[n1] = v4
		end

		table.insert(v4, p1)
	end,
	remove = function(n2: number, p2: ((...any) -> ...any)) -- line: 21
		-- upvalues: t1 (ref)
		local v7 = t1[n2]

		if v7 == nil then
			return
		end

		for v8, v9 in v7 do
			if v9 == p2 then
				table.remove(v7, v8)

				break
			end
		end

		if #v7 == 0 then
			t1[n2] = nil
		end
	end,
	clear = function() -- line: 37
		-- upvalues: t1 (ref)
		t1 = {}
	end,
	snapshot = function() -- line: 42
		-- upvalues: t1 (ref)
		if next(t1) == nil then
			return nil
		end

		local t2 = {}

		for v11, v12 in t1 do
			local t3 = {}

			for i = #v12, 1, -1 do
				table.insert(t3, v12[i])
			end

			t2[v11] = t3
		end

		return t2
	end
}
