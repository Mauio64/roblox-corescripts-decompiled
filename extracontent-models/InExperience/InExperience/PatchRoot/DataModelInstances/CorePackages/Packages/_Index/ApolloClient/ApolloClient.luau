local t1 = {}
local scriptParent = script.Parent
local Object = require(scriptParent.LuauPolyfill).Object
local core = require(script.core)

Object.assign(t1, core)
t1.None = core.None

local react = require(script.react)

Object.assign(t1, react)

return t1
