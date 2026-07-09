require(script.Parent.types)

local function combineReducers(t1: {[any]: any}) -- line: 6
	return function(p1, p2, p3) -- line: 7
		-- upvalues: t1 (copy)
		local v6 = if p1 ~= nil then p1 else {}
		local t2 = {}
		local v8 = false

		for v9, v10 in t1 do
			local v11 = v6[v9]
			local v12 = v10(v11, p2, p3)

			t2[v9] = v12

			if v12 ~= v11 then
				v8 = true
			end
		end

		if v8 then
			return t2
		end

		return v6
	end
end

return combineReducers
