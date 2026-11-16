local function map(items, callback)
	local result = {}

	for k, item in items do
		local v, v2 = callback(item, k)

		if v2 == nil then
			v2 = k
		end

		if v ~= nil then
			result[v2] = v
		end
	end

	return result
end

return map
