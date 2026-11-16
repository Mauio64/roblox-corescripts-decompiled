local None = require(script.Parent.Parent.None)
local copyDeep = require(script.Parent.copyDeep)
local function joinDeep(...)
	local result = {}

	for i = 1, select("#", ...) do
		local v = select(i, ...)

		if not v then
			continue
		end

		for k, v2 in pairs(v) do
			if v2 == None then
				result[k] = nil
			elseif type(v2) == "table" then
				if result[k] == nil or type(result[k] ~= "table") then
					result[k] = copyDeep(v2)
				else
					result[k] = joinDeep(result[k], v2)
				end
			else
				result[k] = v2
			end
		end
	end

	return result
end

return joinDeep
