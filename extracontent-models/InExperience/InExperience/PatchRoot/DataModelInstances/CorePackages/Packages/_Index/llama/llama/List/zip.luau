local function zip(...)
	local v = select("#", ...)
	local v2 = #select(1, ...)
	local result = {}

	for i = 2, v do
		local count = #select(i, ...)

		if count < v2 then
			v2 = count
		end
	end

	for i = 1, v2 do
		result[i] = {}

		for j = 1, v do
			result[i][j] = select(j, ...)[i]
		end
	end

	return result
end

return zip
