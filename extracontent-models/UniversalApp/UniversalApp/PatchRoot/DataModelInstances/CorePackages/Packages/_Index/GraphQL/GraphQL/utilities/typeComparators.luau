local parent = script.Parent.Parent
local parent2 = parent.Parent
local LuauPolyfill = require(parent2.LuauPolyfill)
local Array = LuauPolyfill.Array

local definition = require(parent.type.definition)
local isInterfaceType = definition.isInterfaceType
local isObjectType = definition.isObjectType
local isListType = definition.isListType
local isNonNullType = definition.isNonNullType
local isAbstractType = definition.isAbstractType
local function isEqualType(ofType, ofType2)
	if ofType == ofType2 then
		return true
	end

	if isNonNullType(ofType) and isNonNullType(ofType2) or isListType(ofType) and isListType(ofType2) then
		return isEqualType(ofType.ofType, ofType2.ofType)
	end

	return false
end

local function isTypeSubTypeOf(object, ofType, p)
	if ofType == p then
		return true
	end

	if isNonNullType(p) then
		if isNonNullType(ofType) then
			return isTypeSubTypeOf(object, ofType.ofType, p.ofType)
		end

		return false
	end

	if isNonNullType(ofType) then
		return isTypeSubTypeOf(object, ofType.ofType, p)
	end

	if isListType(p) then
		if isListType(ofType) then
			return isTypeSubTypeOf(object, ofType.ofType, p.ofType)
		end

		return false
	elseif isListType(ofType) then
		return false
	else
		return isAbstractType(p) and (isInterfaceType(ofType) or isObjectType(ofType)) and object:isSubType(p, ofType)
	end
end

return {
	isEqualType = isEqualType,
	isTypeSubTypeOf = isTypeSubTypeOf,
	doTypesOverlap = function(object, p, p2)
		if p == p2 then
			return true
		end

		if isAbstractType(p) then
			if isAbstractType(p2) then
				return Array.some(object:getPossibleTypes(p), function(p3)
					return object:isSubType(p2, p3)
				end)
			end

			return object:isSubType(p, p2)
		elseif isAbstractType(p2) then
			return object:isSubType(p2, p)
		else
			return false
		end
	end
}
