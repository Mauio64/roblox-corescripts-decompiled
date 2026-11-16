local function expectedFields(items, list)
	local set = {}

	for _, item in ipairs(list) do
		set[item] = true
	end

	for k in pairs(set) do
		assert(items[k] ~= nil, string.format("Expected field %q", k))
	end

	for k in pairs(items) do
		assert(set[k] ~= nil, string.format("Did not expect field %q", k))
	end
end

return expectedFields
