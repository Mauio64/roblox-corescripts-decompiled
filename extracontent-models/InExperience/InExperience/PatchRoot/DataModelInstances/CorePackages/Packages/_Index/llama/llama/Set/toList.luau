local function toList(items)
	local list = {}
	local v = 1

	for k, _ in pairs(items) do
		list[v] = k
		v += 1
	end

	return list
end

return toList
