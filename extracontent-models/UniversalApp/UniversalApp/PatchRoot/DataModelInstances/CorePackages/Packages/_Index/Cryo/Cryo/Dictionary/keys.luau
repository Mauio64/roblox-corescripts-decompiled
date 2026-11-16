local function keys(items)
	local result = {}
	local v = 1

	for k in pairs(items) do
		result[v] = k
		v += 1
	end

	return result
end

return keys
