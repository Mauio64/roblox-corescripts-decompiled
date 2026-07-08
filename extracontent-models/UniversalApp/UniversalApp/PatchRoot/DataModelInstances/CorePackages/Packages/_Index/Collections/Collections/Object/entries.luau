local ParentParent = script.Parent.Parent.Parent

require(ParentParent.ES7Types)

return function(p1) -- line: 24
	assert(p1 ~= nil, "cannot get entries from a nil value")

	local v3 = typeof(p1)
	local t1 = {}

	if v3 == "table" then
		for k, v in pairs(p1) do
			table.insert(t1, {
				k,
				v
			})
		end

		return t1
	end

	if v3 == "string" then
		for i = 1, string.len(p1) do
			t1[i] = {
				tostring(i),
				(string.sub(p1, i, i))
			}
		end
	end

	return t1
end
