local function union(...)
	local result = {}

	for i = 1, select("#", ...) do
		for k, _ in pairs((select)(i, ...)) do
			result[k] = true
		end
	end

	return result
end

return union
