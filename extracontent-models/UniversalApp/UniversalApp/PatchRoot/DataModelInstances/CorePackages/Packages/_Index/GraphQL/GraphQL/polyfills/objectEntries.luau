local parent = script.Parent.Parent.Parent
local LuauPolyfill = require(parent.LuauPolyfill)

return { objectEntries = LuauPolyfill.Object.entries }
