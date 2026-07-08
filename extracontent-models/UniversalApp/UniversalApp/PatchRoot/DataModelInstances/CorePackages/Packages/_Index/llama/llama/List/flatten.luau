local function flatten(p1) -- line: 2
	-- upvalues: flatten (copy)
	local v3 = type(p1)

	assert(v3 == "table", "expected a table for first argument, got " .. v3)

	local t1 = {}
	local n1 = 1

	for i = 1, #p1 do
		if type(p1[i]) == "table" then
			local v7 = flatten(p1[i])

			for j = 1, #v7 do
				t1[n1] = v7[j]
				n1 += 1
			end
		else
			t1[n1] = p1[i]
			n1 += 1
		end
	end

	return t1
end

return flatten
