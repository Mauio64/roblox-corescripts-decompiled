local function shallowEqual(items, items2): boolean
	if items == nil then
		return items2 == nil
	end

	if items2 == nil then
		return items == nil
	end

	for k, item in pairs(items) do
		if item ~= items2[k] then
			return false
		end
	end

	for k, item in pairs(items2) do
		if item ~= items[k] then
			return false
		end
	end

	return true
end

return shallowEqual
