return function(items, p)
	local result = {}

	for k, item in pairs(items) do
		if not p[k] then
			error("tables did not have matching indices")
			return
		end

		item = item < p[k] and p[k] or item
		result[k] = item
	end

	return result
end
