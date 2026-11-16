local function inputBindingsEqual(items, items2): boolean
	if items == items2 then
		return true
	end

	for k, item in pairs(items) do
		local item2 = items2[k]

		if
			item2 == nil
			or (item.kind ~= item2.kind or item.keyCode ~= item2.keyCode or item.action ~= item2.action)
		then
			return false
		end

		local meta = item.meta
		local meta2 = item2.meta

		if meta == meta2 then
			continue
		end

		if typeof(meta) ~= "table" or typeof(meta2) ~= "table" then
			return false
		end

		for k2, v in pairs(meta) do
			if v ~= meta2[k2] then
				return false
			end
		end

		for k2 in pairs(meta2) do
			if meta[k2] == nil then
				return false
			end
		end
	end

	for k in pairs(items2) do
		if items[k] == nil then
			return false
		end
	end

	return true
end

return inputBindingsEqual
