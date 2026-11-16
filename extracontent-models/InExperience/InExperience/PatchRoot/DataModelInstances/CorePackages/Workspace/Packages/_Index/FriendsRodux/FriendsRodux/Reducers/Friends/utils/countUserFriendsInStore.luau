return function(items)
	local result = {}

	for k, item in pairs(items) do
		result[k] = #item
	end

	return result
end
