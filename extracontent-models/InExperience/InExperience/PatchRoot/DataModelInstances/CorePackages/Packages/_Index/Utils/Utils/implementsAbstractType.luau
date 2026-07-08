local ParentParent = script.Parent.Parent
local Boolean = require(ParentParent.LuauPolyfill).Boolean
local t1 = {}
local GraphQL = require(ParentParent.GraphQL)
local doTypesOverlap = GraphQL.doTypesOverlap
local isCompositeType = GraphQL.isCompositeType

require(script.Parent.types)

function t1.implementsAbstractType(p1, p2, p3) -- line: 20
	-- upvalues: Boolean (copy), isCompositeType (copy), doTypesOverlap (copy)
	if p3 == nil or p2 == nil then
		return false
	end

	if p2 == p3 then
		return true
	end

	local toJSBoolean = Boolean.toJSBoolean
	local v11 = isCompositeType(p2)

	if toJSBoolean(if not Boolean.toJSBoolean(v11) then v11 else isCompositeType(p3)) then
		return doTypesOverlap(p1, p2, p3)
	end

	return false
end

return t1
