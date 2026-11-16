local parent = script.Parent.Parent.Parent.Parent

local LuauPolyfill = require(parent.LuauPolyfill)
local Boolean = LuauPolyfill.Boolean

local null = { __value = "null" }

return {
	NULL = null,
	toJSBoolean = function(p)
		return Boolean.toJSBoolean(p) and p ~= null
	end
}
