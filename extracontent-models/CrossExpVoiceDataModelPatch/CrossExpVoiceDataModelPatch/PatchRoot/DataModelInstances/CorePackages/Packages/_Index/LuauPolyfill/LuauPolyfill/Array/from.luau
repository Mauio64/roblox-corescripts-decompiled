local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local isArray = require(scriptParent.isArray)
local instanceof = require(scriptParentParent.instanceof)
local Set = require(scriptParentParent.Set)
local Map = require(scriptParentParent.Map)
local fromString = require(script.fromString)
local fromSet = require(script.fromSet)
local fromMap = require(script.fromMap)
local fromArray = require(script.fromArray)

require(scriptParentParent.types)

return function(p1, p2: ((...any) -> ...any)?, p3) -- line: 23
	-- upvalues: isArray (copy), fromArray (copy), instanceof (copy), Set (copy), fromSet (copy), Map (copy), fromMap (copy), fromString (copy)
	if p1 == nil then
		error("cannot create array from a nil value")
	end

	local v14 = typeof(p1)

	if v14 == "table" and isArray(p1) then
		return (fromArray(p1, p2, p3))
	end

	if instanceof(p1, Set) then
		return (fromSet(p1, p2, p3))
	end

	if instanceof(p1, Map) then
		return (fromMap(p1, p2, p3))
	end

	if v14 == "string" then
		return (fromString(p1, p2, p3))
	end

	return {}
end
