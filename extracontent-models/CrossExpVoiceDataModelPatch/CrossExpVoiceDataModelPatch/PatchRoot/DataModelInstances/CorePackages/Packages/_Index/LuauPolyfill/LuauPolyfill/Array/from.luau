local parent = script.Parent
local parent2 = parent.Parent
local isArray = require(parent.isArray)
local instanceof = require(parent2.instanceof)
local Set = require(parent2.Set)
local Map = require(parent2.Map)

local fromString = require(script.fromString)
local fromSet = require(script.fromSet)
local fromMap = require(script.fromMap)
local fromArray = require(script.fromArray)

require(parent2.types)

return function(p, callback, p2)
	if p == nil then
		error("cannot create array from a nil value")
	end

	local typeName = typeof(p)

	if typeName == "table" and isArray(p) then
		return (fromArray(p, callback, p2))
	end

	if instanceof(p, Set) then
		return (fromSet(p, callback, p2))
	end

	if instanceof(p, Map) then
		return (fromMap(p, callback, p2))
	end

	if typeName == "string" then
		return (fromString(p, callback, p2))
	end

	return {}
end
