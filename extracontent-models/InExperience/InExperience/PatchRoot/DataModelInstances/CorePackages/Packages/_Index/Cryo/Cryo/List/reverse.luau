local function reverse(list)
	local count = #list
	local v = count + 1
	local result = {}

	for i = 1, count do
		result[i] = list[v - i]
	end

	return result
end

return reverse
