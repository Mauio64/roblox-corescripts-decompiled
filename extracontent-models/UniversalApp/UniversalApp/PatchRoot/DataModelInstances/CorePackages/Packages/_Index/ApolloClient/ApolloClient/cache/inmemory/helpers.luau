local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Array = require(ParentParentParent.LuauPolyfill).Array
local LuauRegExp = require(ParentParentParent.LuauRegExp)

require(ParentParentParent.GraphQL)
require(script.Parent.types)

local utilities = require(ParentParent.utilities)
local isReference = utilities.isReference
local isField = utilities.isField
local DeepMerger = utilities.DeepMerger
local resultKeyNameFromFieldf = utilities.resultKeyNameFromFieldf
local shouldInclude = utilities.shouldInclude
local isNonNullObject = utilities.isNonNullObject
local t1 = {}
local hasOwnProperty = require(ParentParent.luaUtils.hasOwnProperty)

t1.hasOwn = hasOwnProperty

function t1.getTypenameFromStoreObject(p1, p2) -- line: 41
	-- upvalues: isReference (copy)
	if isReference(p2) then
		return (p1:get(p2.__ref, "__typename"))
	end

	if p2 then
		return p2.__typename
	end

	return nil
end

t1.TypeOrFieldNameRegExp = LuauRegExp("^[_a-zA-Z][_0-9a-zA-Z]*", "i")

local t2 = {}

function t1.fieldNameFromStoreName(s1: string) -- line: 64
	-- upvalues: t2 (copy)
	if t2[s1] then
		return t2[s1]
	end

	local v19 = string.match(s1, "^[_a-zA-Z][_0-9a-zA-Z]*") or s1

	t2[s1] = v19

	return v19
end

local function selectionSetMatchesResult(p3, t3: {[any]: any}, t4: {[any]: any}?) -- line: 76
	-- upvalues: isNonNullObject (copy), Array (copy), selectionSetMatchesResult (copy), isField (copy), shouldInclude (copy), resultKeyNameFromFieldf (copy), hasOwnProperty (copy)
	if isNonNullObject(t3) then
		if Array.isArray(t3) then
			return Array.every(t3, function(p4) -- line: 84
				-- upvalues: selectionSetMatchesResult (copy), p3 (copy), t4 (copy)
				return selectionSetMatchesResult(p3, p4, t4)
			end)
		end

		return Array.every(p3.selections, function(p5) -- line: 88
			-- upvalues: isField (copy), shouldInclude (copy), t4 (copy), resultKeyNameFromFieldf (copy), hasOwnProperty (copy), t3 (copy), selectionSetMatchesResult (copy)
			if isField(p5) and shouldInclude(p5, t4) then
				local v26 = resultKeyNameFromFieldf(p5)

				return hasOwnProperty(t3, v26) and (not p5.selectionSet or selectionSetMatchesResult(p5.selectionSet, t3[v26], t4))
			end

			return true
		end)
	end

	return false
end

t1.selectionSetMatchesResult = selectionSetMatchesResult

function t1.storeValueIsStoreObject(p6) -- line: 116
	-- upvalues: isNonNullObject (copy), isReference (copy), Array (copy)
	return isNonNullObject(p6) and (not isReference(p6) and not Array.isArray(p6))
end
function t1.makeProcessedFieldsMerger() -- line: 121
	-- upvalues: DeepMerger (copy)
	return DeepMerger.new()
end

return t1
