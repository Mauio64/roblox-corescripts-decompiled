local None = require(script.Parent.Parent.None)

local function join(...)
	local result = {}

	for i = 1, select("#", ...) do
		local v = select(i, ...)
		local count = #result

		for j = 1, #v do
			if v[j] == None then
				count -= 1
			else
				result[count + j] = v[j]
			end
		end
	end

	return result
end

return join
