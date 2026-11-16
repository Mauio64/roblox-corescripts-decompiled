local function fillRequestedNames(items, items2)
	local v = {}

	for _, item in items2 do
		if string.sub(item, 1, 6) == "names." then
			table.insert(v, (string.sub(item, 7)))
		end
	end

	if items == nil or #v == 0 then
		return items
	end

	local clones = {}

	for _, item in items do
		local names = type(item.names) ~= "table" and {} or table.clone(item.names)

		for _, v2 in v do
			if type(names[v2]) ~= "string" then
				names[v2] = ""
			end
		end

		local clone = table.clone(item)
		clone.names = names
		table.insert(clones, clone)
	end

	return clones
end

return fillRequestedNames
