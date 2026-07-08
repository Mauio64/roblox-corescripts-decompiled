local function copyDeep(p1) -- line: 2
	-- upvalues: copyDeep (copy)
	local v3 = type(p1)

	assert(v3 == "table", "expected a table for first argument, got " .. v3)

	local t1 = {}

	for k, v in pairs(p1) do
		if type(v) == "table" then
			t1[k] = copyDeep(v)
		else
			t1[k] = v
		end
	end

	return t1
end

return copyDeep
