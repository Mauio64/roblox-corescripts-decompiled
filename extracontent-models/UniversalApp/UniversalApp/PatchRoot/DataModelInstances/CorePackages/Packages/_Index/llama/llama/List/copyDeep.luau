local function copyDeep(p1) -- line: 2
	-- upvalues: copyDeep (copy)
	local v3 = type(p1)

	assert(v3 == "table", "expected a table for first argument, got " .. v3)

	local t1 = {}

	for i = 1, #p1 do
		if type(p1[i]) == "table" then
			t1[i] = copyDeep(p1[i])
		else
			t1[i] = p1[i]
		end
	end

	return t1
end

return copyDeep
