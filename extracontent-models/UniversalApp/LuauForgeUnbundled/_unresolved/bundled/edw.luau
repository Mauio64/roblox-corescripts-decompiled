return function(...)
	local result = {}

	for i = 1, select("#", ...) do
		for k, v5 in pairs((select)(i, ...)) do
			result[k] = v5
		end
	end

	return result
end
