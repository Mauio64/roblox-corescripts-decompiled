local function values(items)
	local result = {}
	local v = 1

	for _, item in pairs(items) do
		result[v] = item
		v += 1
	end

	return result
end

return values
