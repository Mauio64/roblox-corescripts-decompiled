local parent = script.Parent.Parent.Parent.Parent
local LuauPolyfill = require(parent.LuauPolyfill)
local Object = LuauPolyfill.Object
return {
	compact = function(...)
		return Object.assign({}, ...)
	end
}
