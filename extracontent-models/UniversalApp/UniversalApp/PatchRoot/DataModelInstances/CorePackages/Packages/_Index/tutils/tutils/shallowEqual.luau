return function(items, items2, options): boolean
	if not (items and items2) then
		return false
	end

	if items == items2 then
		return true
	end

	local v = options or {}

	for k, item in pairs(items) do
		if items2[k] ~= item and not v[k] then
			return false
		end
	end

	for k, item in pairs(items2) do
		if items[k] ~= item and not v[k] then
			return false
		end
	end

	return true
end
