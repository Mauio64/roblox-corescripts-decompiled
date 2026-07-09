return function(p1) -- line: 1
	if p1 == nil then
		error("cannot extract keys from a nil value")
	end

	local v2 = typeof(p1)
	local t1 = {}

	if v2 == "table" then
		for k in pairs(p1) do
			table.insert(t1, k)
		end

		return t1
	end

	if v2 == "string" then
		for i = 1, p1:len() do
			t1[i] = tostring(i)
		end
	end

	return t1
end
