local parent = script.Parent.Parent
local Number = require(parent.Number)

local NaN = Number.NaN

return function(p: string, value: number)
	local v = typeof(value) ~= "number" and 1 or value

	local v2, v3 = utf8.len(p)
	assert(v2 ~= nil, ("string `%s` has an invalid byte at position %s"):format(p, (tostring(v3))))

	if v2 < v or v < 1 then
		return NaN
	end

	local v4 = utf8.offset(p, v)
	local v5 = utf8.codepoint(p, v4, v4)

	return if v5 == nil then NaN else v5
end
