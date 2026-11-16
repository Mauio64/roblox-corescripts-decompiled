local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local LuauPolyfill = require(parent2.LuauPolyfill)
local Array = LuauPolyfill.Array

local LuauRegExp = require(parent2.LuauRegExp)

require(parent2.GraphQL)

require(script.Parent.types)

local utilities = require(parent.utilities)

local isReference = utilities.isReference

local isField = utilities.isField
local deepMerger = utilities.DeepMerger
local resultKeyNameFromFieldf = utilities.resultKeyNameFromFieldf
local shouldInclude = utilities.shouldInclude
local isNonNullObject = utilities.isNonNullObject

local hasOwnProperty = require(parent.luaUtils.hasOwnProperty)
local Helpers = {}
Helpers.hasOwn = hasOwnProperty

function Helpers.getTypenameFromStoreObject(object, p)
	if isReference(p) then
		return (object:get(p.__ref, "__typename"))
	end

	return if p then p.__typename else nil
end

Helpers.TypeOrFieldNameRegExp = LuauRegExp("^[_a-zA-Z][_0-9a-zA-Z]*", "i")

local v = {}

function Helpers.fieldNameFromStoreName(value: string)
	if v[value] then
		return v[value]
	end

	local v2 = string.match(value, "^[_a-zA-Z][_0-9a-zA-Z]*") or value
	v[value] = v2
	return v2
end

local function selectionSetMatchesResult(p, p2, p3)
	if not isNonNullObject(p2) then
		return false
	end

	if Array.isArray(p2) then
		return Array.every(p2, function(p4)
			return selectionSetMatchesResult(p, p4, p3)
		end)
	end

	return Array.every(p.selections, function(p4)
		if isField(p4) and shouldInclude(p4, p3) then
			local v2 = resultKeyNameFromFieldf(p4)

			return hasOwnProperty(p2, v2)
				and (not p4.selectionSet or selectionSetMatchesResult(p4.selectionSet, p2[v2], p3))
		end

		return true
	end)
end

Helpers.selectionSetMatchesResult = selectionSetMatchesResult

function Helpers.storeValueIsStoreObject(p)
	return isNonNullObject(p) and not (isReference(p) or Array.isArray(p))
end

function Helpers.makeProcessedFieldsMerger()
	return deepMerger.new()
end

return Helpers
