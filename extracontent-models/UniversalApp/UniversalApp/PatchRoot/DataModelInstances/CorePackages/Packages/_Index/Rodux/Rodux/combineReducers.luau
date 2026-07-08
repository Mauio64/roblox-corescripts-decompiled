local function combineReducers(p1) -- line: 4
	return function(p2, p3) -- line: 5
		-- upvalues: p1 (copy)
		if p2 == nil then
			p2 = {}
		end

		local t1 = {}

		for k, v in pairs(p1) do
			t1[k] = v(p2[k], p3)
		end

		return t1
	end
end

return combineReducers
