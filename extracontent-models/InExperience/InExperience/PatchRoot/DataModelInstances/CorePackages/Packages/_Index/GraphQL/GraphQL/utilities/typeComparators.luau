local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Array = require(ParentParentParent.LuauPolyfill).Array
local definition = require(ParentParent.type.definition)
local isInterfaceType = definition.isInterfaceType
local isObjectType = definition.isObjectType
local isListType = definition.isListType
local isNonNullType = definition.isNonNullType
local isAbstractType = definition.isAbstractType

local function isEqualType(p1, p2) -- line: 24
	-- upvalues: isNonNullType (copy), isEqualType (copy), isListType (copy)
	if p1 == p2 then
		return true
	end

	if isNonNullType(p1) and isNonNullType(p2) then
		return isEqualType(p1.ofType, p2.ofType)
	end

	if isListType(p1) and isListType(p2) then
		return isEqualType(p1.ofType, p2.ofType)
	end

	return false
end
local function isTypeSubTypeOf(p3, p4, p5) -- line: 48
	-- upvalues: isNonNullType (copy), isTypeSubTypeOf (copy), isListType (copy), isAbstractType (copy), isInterfaceType (copy), isObjectType (copy)
	if p4 == p5 then
		return true
	end

	if isNonNullType(p5) then
		if isNonNullType(p4) then
			return isTypeSubTypeOf(p3, p4.ofType, p5.ofType)
		end

		return false
	end

	if isNonNullType(p4) then
		return isTypeSubTypeOf(p3, p4.ofType, p5)
	end

	if isListType(p5) then
		if isListType(p4) then
			return isTypeSubTypeOf(p3, p4.ofType, p5.ofType)
		end

		return false
	end

	if isListType(p4) then
		return false
	end

	return isAbstractType(p5) and ((isInterfaceType(p4) or isObjectType(p4)) and p3:isSubType(p5, p4))
end

return {
	isEqualType = isEqualType,
	isTypeSubTypeOf = isTypeSubTypeOf,
	doTypesOverlap = function(p6, p7, p8) -- line: 97
		-- upvalues: isAbstractType (copy), Array (copy)
		if p7 == p8 then
			return true
		end

		if isAbstractType(p7) then
			if isAbstractType(p8) then
				return Array.some(p6:getPossibleTypes(p7), function(p9) -- line: 106
					-- upvalues: p6 (copy), p8 (copy)
					return p6:isSubType(p8, p9)
				end)
			end

			return p6:isSubType(p7, p8)
		end

		if isAbstractType(p8) then
			return p6:isSubType(p8, p7)
		end

		return false
	end
}
