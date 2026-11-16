local function removeValue(list, p)
	local result = {}
	local v = 1

	for i = 1, #list do
		if list[i] == p then
			continue
		end

		result[v] = list[i]
		v += 1
	end

	return result
end

return removeValue
