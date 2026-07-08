local function expectedFields(p1, p2) -- line: 1
	local t1 = {}

	for _, v in ipairs(p2) do
		t1[v] = true
	end

	for k in pairs(t1) do
		assert(p1[k] ~= nil, string.format("Expected field %q", k))
	end

	for k in pairs(p1) do
		assert(t1[k] ~= nil, string.format("Did not expect field %q", k))
	end
end

return expectedFields
