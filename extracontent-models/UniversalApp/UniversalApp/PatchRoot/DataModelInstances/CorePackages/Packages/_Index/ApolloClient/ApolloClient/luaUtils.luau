local parent = script.Parent.Parent
local LuauPolyfill = require(parent.LuauPolyfill)
local Object = LuauPolyfill.Object

local makeIntervalImpl = require(script.makeIntervalImpl)

return Object.assign({ Object = require(script.Object) }, makeIntervalImpl(delay))
