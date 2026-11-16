local None = require(script.Parent.Parent.None)

local function zipAll(...)
	local v = select("#", ...)
	local v2 = #select(1, ...)
	local result = {}

	for i = 2, v do
		local count = #select(i, ...)

		if v2 < count then
			v2 = count
		end
	end

	for i = 1, v2 do
		result[i] = {}

		for j = 1, v do
			if select(j, ...)[i] == nil then
				result[i][j] = None
			else
				result[i][j] = select(j, ...)[i]
			end
		end
	end

	return result
end

return zipAll
