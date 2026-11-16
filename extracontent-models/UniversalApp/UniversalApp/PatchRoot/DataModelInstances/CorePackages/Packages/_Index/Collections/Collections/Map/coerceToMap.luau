local parent = script.Parent
local parent2 = parent.Parent
local parent3 = parent2.Parent

local Map = require(parent.Map)
local Object = require(parent2.Object)
local InstanceOf = require(parent3.InstanceOf)
require(parent3.ES7Types)

local function coerceToMap(p)
	return InstanceOf(p, Map) and p or Map.new(Object.entries(p))
end

return coerceToMap
