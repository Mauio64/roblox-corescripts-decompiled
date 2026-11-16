local function filter(list, callback)
	local result = {}
	local v = 1

	for i = 1, #list do
		local item = list[i]

		if not callback(item, i) then
			continue
		end

		result[v] = item
		v += 1
	end

	return result
end

return filter
