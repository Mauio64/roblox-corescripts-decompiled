local function assertUniqueSourceIds(items)
	local idSet = {}

	for _, item in items do
		local v = type(item.id) == "string" and item.id ~= ""
		assert(v, "Autocomplete source id is required")
		assert(idSet[item.id] == nil, "Duplicate autocomplete source id: " .. item.id)
		idSet[item.id] = true
	end
end

return assertUniqueSourceIds
