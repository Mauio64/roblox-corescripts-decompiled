local function fillRequestedNames(items, items2)
	local v5 = {}

	for k, item in items2 do
		if string.sub(item, 1, 6) == "names." then
			table.insert(v5, (string.sub(item, 7)))
		end
	end

	if items == nil or #v5 == 0 then
		return items
	end

	local clones = {}

	for k, item in items do
		local v6 = type(item.names) ~= "table" and {} or table.clone(item.names)

		for k2, v7 in v5 do
			if type(v6[v7]) ~= "string" then
				v6[v7] = ""
			end
		end

		local clone = table.clone(item)
		clone.names = v6
		table.insert(clones, clone)
	end

	return clones
end

return fillRequestedNames
