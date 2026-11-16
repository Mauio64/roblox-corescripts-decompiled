local function populateDictionaryFromIds(item, p)
	local result = {}

	for k, item2 in pairs(item) do
		if type(item2) == "table" then
			result[k] = populateDictionaryFromIds(item2, p)
		else
			result[k] = p[item2]
		end
	end

	return result
end

return populateDictionaryFromIds
