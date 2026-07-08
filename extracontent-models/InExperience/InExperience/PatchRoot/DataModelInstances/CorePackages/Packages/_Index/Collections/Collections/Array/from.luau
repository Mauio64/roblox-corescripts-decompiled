local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local scriptParentParentParent = scriptParentParent.Parent
local Set = require(scriptParentParent.Set)
local Map = require(scriptParentParent.Map.Map)
local isArray = require(scriptParent.isArray)
local InstanceOf = require(scriptParentParentParent.InstanceOf)

require(scriptParentParentParent.ES7Types)

local fromString = require(script.fromString)
local fromSet = require(script.fromSet)
local fromMap = require(script.fromMap)
local fromArray = require(script.fromArray)

return function(p1, p2: ((...any) -> ...any)?, p3) -- line: 37
	-- upvalues: isArray (copy), fromArray (copy), InstanceOf (copy), Set (copy), fromSet (copy), Map (copy), fromMap (copy), fromString (copy)
	if p1 == nil then
		error("cannot create array from a nil value")
	end

	local v15 = typeof(p1)

	if v15 == "table" and isArray(p1) then
		return (fromArray(p1, p2, p3))
	end

	if InstanceOf(p1, Set) then
		return (fromSet(p1, p2, p3))
	end

	if InstanceOf(p1, Map) then
		return (fromMap(p1, p2, p3))
	end

	if v15 == "string" then
		return (fromString(p1, p2, p3))
	end

	return {}
end
