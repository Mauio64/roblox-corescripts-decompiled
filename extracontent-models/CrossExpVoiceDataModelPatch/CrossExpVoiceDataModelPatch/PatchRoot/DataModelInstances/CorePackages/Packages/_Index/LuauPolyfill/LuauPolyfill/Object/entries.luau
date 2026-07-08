require(script.Parent.Parent.types)

return function(p1) -- line: 7
	assert(p1 ~= nil, "cannot get entries from a nil value")

	local v2 = typeof(p1)
	local t1 = {}

	if v2 == "table" then
		for k, v in pairs(p1) do
			table.insert(t1, {
				k,
				v
			})
		end

		return t1
	end

	if v2 == "string" then
		for i = 1, string.len(p1) do
			t1[i] = {
				tostring(i),
				(string.sub(p1, i, i))
			}
		end
	end

	return t1
end
