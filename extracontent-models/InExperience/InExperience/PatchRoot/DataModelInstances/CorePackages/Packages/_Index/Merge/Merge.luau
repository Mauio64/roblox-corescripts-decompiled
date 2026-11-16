local parent = script.Parent
local LuauPolyfill = require(parent.LuauPolyfill)
local Object = LuauPolyfill.Object
local Merge = {}

local mergeresolvers = require(script["merge-resolvers"])
Object.assign(Merge, mergeresolvers)
local typedefsmergers = require(script["typedefs-mergers"])
Object.assign(Merge, typedefsmergers)
local extensions = require(script.extensions)
Object.assign(Merge, extensions)

return Merge
