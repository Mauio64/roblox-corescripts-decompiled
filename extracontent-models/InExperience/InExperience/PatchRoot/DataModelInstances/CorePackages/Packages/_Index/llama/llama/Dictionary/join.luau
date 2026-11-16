local None = require(script.Parent.Parent.None)

local function join(...)
	local result = {}

	for i = 1, select("#", ...) do
		local v = select(i, ...)

		if not v then
			continue
		end

		for k, v2 in pairs(v) do
			if v2 == None then
				result[k] = nil
			else
				result[k] = v2
			end
		end
	end

	return result
end

return join
