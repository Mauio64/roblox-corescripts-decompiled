local parent = script.Parent.Parent
local Number = require(parent.Number)

local NaN = Number.NaN

return function(value: string, value2: number)
	local v = type(value2) ~= "number" and 1 or value2

	local v2 = string.len(value)

	if v < 1 or v2 < v then
		return NaN
	end

	local v3 = utf8.offset(value, v)

	if v3 == nil or v2 < v3 then
		return NaN
	end

	local v4 = utf8.codepoint(value, v3, v3)

	return if v4 == nil then NaN else v4
end
