return function(items, p)
	local result = {}

	for k, item in pairs(items) do
		if p[k] then
			result[k] = item < p[k] and item or p[k]
		else
			error("tables did not have matching indices")
			return
		end
	end

	return result
end
