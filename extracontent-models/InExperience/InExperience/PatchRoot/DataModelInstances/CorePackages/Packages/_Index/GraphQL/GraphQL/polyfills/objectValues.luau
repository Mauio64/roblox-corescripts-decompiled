local parent = script.Parent.Parent.Parent
local LuauPolyfill = require(parent.LuauPolyfill)

return { objectValues = LuauPolyfill.Object.values }
