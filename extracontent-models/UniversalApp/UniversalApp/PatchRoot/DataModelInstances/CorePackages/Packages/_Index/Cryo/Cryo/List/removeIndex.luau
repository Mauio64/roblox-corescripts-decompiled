local function removeIndex(list, p)
	local v = 0
	local result = {}

	for i = 1, #list do
		if i == p then
			v = 1
		else
			result[i - v] = list[i]
		end
	end

	return result
end

return removeIndex
