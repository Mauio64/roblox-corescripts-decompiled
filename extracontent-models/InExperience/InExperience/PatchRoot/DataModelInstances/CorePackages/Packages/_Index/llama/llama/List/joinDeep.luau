local None = require(script.Parent.Parent.None)
local copyDeep = require(script.Parent.copyDeep)
local function joinDeep(...)
	local result = {}
	local v = 1

	for i = 1, select("#", ...) do
		local v2 = select(i, ...)

		if not v2 then
			continue
		end

		for j = 1, #v2 do
			if type(v2[j]) == "table" then
				if result[v] == nil or type(result[v] ~= "table") then
					result[v] = copyDeep(v2[j])
				else
					result[v] = joinDeep(result[v], v2[j])
				end
			elseif v2[j] ~= None then
				result[v] = v2[j]
			end

			v += 1
		end
	end

	return result
end

return joinDeep
