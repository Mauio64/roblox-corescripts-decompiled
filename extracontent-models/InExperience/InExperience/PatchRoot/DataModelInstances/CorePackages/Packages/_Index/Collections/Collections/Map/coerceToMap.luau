local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local scriptParentParentParent = scriptParentParent.Parent
local Map = require(scriptParent.Map)
local Object = require(scriptParentParent.Object)
local InstanceOf = require(scriptParentParentParent.InstanceOf)

require(scriptParentParentParent.ES7Types)

local function coerceToMap(p1) -- line: 27
	-- upvalues: InstanceOf (copy), Map (copy), Object (copy)
	return InstanceOf(p1, Map) and p1 or Map.new(Object.entries(p1))
end

return coerceToMap
