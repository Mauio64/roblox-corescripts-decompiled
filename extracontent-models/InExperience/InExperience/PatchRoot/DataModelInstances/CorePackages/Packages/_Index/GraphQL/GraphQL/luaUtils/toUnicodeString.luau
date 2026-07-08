local ParentParent = script.Parent.Parent.Parent
local String = require(ParentParent.LuauPolyfill).String

return function(p1) -- line: 6
	-- upvalues: String (copy)
	local v4 = "0000" .. string.format("%x", p1)

	return "\"\\u" .. String.slice(v4, -4):upper() .. "\""
end
