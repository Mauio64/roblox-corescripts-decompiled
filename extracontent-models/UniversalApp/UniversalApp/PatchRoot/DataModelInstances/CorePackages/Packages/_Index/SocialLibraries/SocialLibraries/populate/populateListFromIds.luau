local function populateListFromIds(list, p)
	local result = {}

	for _, item in ipairs(list) do
		if type(item) == "table" then
			table.insert(result, populateListFromIds(item, p))
		else
			table.insert(result, p[item])
		end
	end

	return result
end

return populateListFromIds
