local None = require(script.Parent.Parent.None)

local function join(...)
	local result = {}
	local v = 1

	for i = 1, select("#", ...) do
		local v2 = select(i, ...)

		if not v2 then
			continue
		end

		for j = 1, #v2 do
			if v2[j] == None then
				continue
			end

			result[v] = v2[j]
			v += 1
		end
	end

	return result
end

return join
