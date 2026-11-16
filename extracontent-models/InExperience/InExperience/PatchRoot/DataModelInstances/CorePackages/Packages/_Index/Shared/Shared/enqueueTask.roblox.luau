local parent = script.Parent.Parent
local LuauPolyfill = require(parent.LuauPolyfill)
local setTimeout = LuauPolyfill.setTimeout

return function(p)
	return setTimeout(p, 0)
end
