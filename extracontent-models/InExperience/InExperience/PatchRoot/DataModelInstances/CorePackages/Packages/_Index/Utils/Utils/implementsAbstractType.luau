local parent = script.Parent.Parent
local LuauPolyfill = require(parent.LuauPolyfill)
local Boolean = LuauPolyfill.Boolean
local ImplementsAbstractType = {}
local GraphQL = require(parent.GraphQL)

local doTypesOverlap = GraphQL.doTypesOverlap
local isCompositeType = GraphQL.isCompositeType

require(script.Parent.types)

function ImplementsAbstractType.implementsAbstractType(p, p2, p3)
	if p3 == nil or p2 == nil then
		return false
	end

	if p2 == p3 then
		return true
	end

	local toJSBoolean = Boolean.toJSBoolean
	local v = isCompositeType(p2)

	if Boolean.toJSBoolean(v) then
		v = isCompositeType(p3)
	end

	if toJSBoolean(v) then
		return doTypesOverlap(p, p2, p3)
	end

	return false
end
return ImplementsAbstractType
