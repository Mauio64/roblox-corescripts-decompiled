local function flatMap(p1, p2) -- line: 2
	-- upvalues: flatMap (copy)
	local v4 = type(p1)

	assert(v4 == "table", "expected a table for first argument, got " .. v4)

	local v5 = type(p2)

	assert(v5 == "function", "expected a function for second argument, got " .. v5)

	local t1 = {}
	local n1 = 1

	for i = 1, #p1 do
		if type(p1[i]) == "table" then
			local v9 = flatMap(p1[i], p2)

			for j = 1, #v9 do
				t1[n1] = v9[j]
				n1 += 1
			end
		else
			local v11 = p2(p1[i], i)

			if v11 ~= nil then
				t1[n1] = v11
				n1 += 1
			end
		end
	end

	return t1
end

return flatMap
