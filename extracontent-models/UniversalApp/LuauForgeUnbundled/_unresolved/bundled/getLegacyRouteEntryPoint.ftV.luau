local function getLegacyRouteEntryPoint(items)
	if items == nil then
		return nil
	end

	local names = {}

	for k, item in items do
		if item.name then
			table.insert(names, item.name)
		end
	end

	return table.concat(names, "/")
end

return getLegacyRouteEntryPoint
