local function createUniqueKey() -- line: 4
	local t1 = {}

	return function(p1) -- line: 7
		-- upvalues: t1 (copy)
		if t1[p1] == nil then
			t1[p1] = 1

			return p1
		end

		local v5

		repeat
			local v4 = t1

			v4[p1] = v4[p1] + 1
			v5 = `{ p1 }_{ t1[p1] }`
		until t1[v5] == nil

		return v5
	end
end

return createUniqueKey
