local scriptParent = script.Parent
local Object = require(scriptParent.LuauPolyfill).Object
local t1 = {}
local lib = require(script["merge-resolvers"])

Object.assign(t1, lib)

local lib2 = require(script["typedefs-mergers"])

Object.assign(t1, lib2)

local extensions = require(script.extensions)

Object.assign(t1, extensions)

return t1
