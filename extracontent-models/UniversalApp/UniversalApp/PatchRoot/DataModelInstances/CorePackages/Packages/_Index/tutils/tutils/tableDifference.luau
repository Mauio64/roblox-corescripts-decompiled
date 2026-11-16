return function(items, items2)
	local result = {}

	for k, item in pairs(items) do
		if items2[k] ~= items[k] then
			result[k] = item
		end
	end

	for k, item in pairs(items2) do
		if items2[k] ~= items[k] then
			result[k] = item
		end
	end

	return result
end
