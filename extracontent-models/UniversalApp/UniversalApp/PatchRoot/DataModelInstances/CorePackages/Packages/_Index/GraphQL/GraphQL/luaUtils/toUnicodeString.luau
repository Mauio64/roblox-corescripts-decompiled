local parent = script.Parent.Parent.Parent
local LuauPolyfill = require(parent.LuauPolyfill)
local String = LuauPolyfill.String

return function(p)
	local v = "0000" .. string.format("%x", p)

	return "\"\\u" .. String.slice(v, -4):upper() .. "\""
end
