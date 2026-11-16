local function getAdjacentTabName(list, p: string, p2: number)
	if #list < 2 then
		return nil
	end

	local clone = table.clone(list)
	table.sort(clone, function(a, b): boolean
		return a.tabIndex < b.tabIndex
	end)
	local v = nil

	for k, v2 in clone do
		if v2.name == p then
			v = k
			break
		end
	end

	if v == nil then
		return nil
	end

	local v2 = #clone

	return clone[(v - 1 + p2) % v2 + 1].name
end

return getAdjacentTabName
