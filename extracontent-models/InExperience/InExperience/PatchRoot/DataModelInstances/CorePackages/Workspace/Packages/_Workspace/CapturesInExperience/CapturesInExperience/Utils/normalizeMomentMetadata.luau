local function normalizeValue(p1) -- line: 2
	-- upvalues: normalizeValue (copy)
	if typeof(p1) == "EnumItem" then
		return p1.Name
	end

	if typeof(p1) == "table" then
		local t1 = {}

		for v4, v5 in p1 do
			t1[v4] = normalizeValue(v5)
		end

		return t1
	end

	return p1
end

return normalizeValue
