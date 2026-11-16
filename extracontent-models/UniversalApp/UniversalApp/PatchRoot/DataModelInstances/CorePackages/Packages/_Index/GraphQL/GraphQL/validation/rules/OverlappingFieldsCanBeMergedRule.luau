local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent
local LuauPolyfill = require(parent2.LuauPolyfill)
local Array = LuauPolyfill.Array
local Map = LuauPolyfill.Map
local Object = LuauPolyfill.Object

local null = require(parent.luaUtils.null)
local jsutils = parent.jsutils
local language = parent.language
local GraphQLError = require(parent.error.GraphQLError)
local graphQLError = GraphQLError.GraphQLError
local inspect = require(jsutils.inspect)
local inspect2 = inspect.inspect
local kinds = require(language.kinds)
local kind = kinds.Kind
local printer = require(language.printer)
local Print = printer.print
local definition = require(parent.type.definition)
local getNamedType = definition.getNamedType
local isNonNullType = definition.isNonNullType
local isLeafType = definition.isLeafType
local isObjectType = definition.isObjectType
local isListType = definition.isListType
local isInterfaceType = definition.isInterfaceType
local typeFromAST = require(parent.utilities.typeFromAST)
local typeFromAST2 = typeFromAST.typeFromAST

local OverlappingFieldsCanBeMergedRule = {}

local findConflictsWithinSelectionSet
local collectConflictsBetweenFieldsAndFragment
local collectConflictsBetween
local collectConflictsWithin
local collectConflictsBetweenFragments
local getFieldsAndFragmentNames
local getReferencedFieldsAndFragmentNames
local findConflict
local sameArguments
local doTypesConflict
local subfieldConflicts
local v = nil
local function reasonMessage(item)
	if Array.isArray(item) then
		return table.concat(Array.map(item, function(list)
			local item2 = list[1]
			local item3 = list[2]
			return ("subfields \"%s\" conflict because "):format(item2) .. reasonMessage(item3)
		end), " and ")
	end

	return item
end

function OverlappingFieldsCanBeMergedRule.OverlappingFieldsCanBeMergedRule(object)
	local v2 = v.new()

	local v3 = {}

	return {
		SelectionSet = function(_, p)
			local v4 = findConflictsWithinSelectionSet(object, v3, v2, object:getParentType(), p)

			for _, v5 in ipairs(v4) do
				local v6 = v5[1]
				local v7 = v6[1]
				local v8 = v6[2]
				local v9 = v5[2]
				local v10 = v5[3]

				if Array.isArray(v8) then
					v8 = table.concat(Array.map(v8, function(list)
						local item = list[1]
						local item2 = list[2]
						return ("subfields \"%s\" conflict because "):format(item) .. reasonMessage(item2)
					end), " and ")
				end

				object:reportError(graphQLError.new(
					("Fields \"%s\" conflict because %s. Use different aliases on the fields to fetch both if this was intentional."):format(
						v7,
						v8
					),
					Array.concat(v9, v10)
				))
			end
		end
	}
end

findConflictsWithinSelectionSet = function(object, p, p2, p3, p4)
	local conflictsWithinSelectionSet = {}

	local v2 = getFieldsAndFragmentNames(object, p, p3, p4)

	local v3 = v2[1]
	local v4 = v2[2]

	collectConflictsWithin(object, conflictsWithinSelectionSet, p, p2, v3)

	if #v4 == 0 then
		return conflictsWithinSelectionSet
	end

	for i = 1, #v4 do
		collectConflictsBetweenFieldsAndFragment(object, conflictsWithinSelectionSet, p, p2, false, v3, v4[i])

		for j = i + 1, #v4 do
			collectConflictsBetweenFragments(object, conflictsWithinSelectionSet, p, p2, false, v4[i], v4[j])
		end
	end

	return conflictsWithinSelectionSet
end

collectConflictsBetweenFieldsAndFragment = function(object, p, p2, p3, p4, p5, p6)
	local fragment = object:getFragment(p6)

	if not fragment then
		return
	end

	local v2 = getReferencedFieldsAndFragmentNames(object, p2, fragment)

	local v3 = v2[1]
	local v4 = v2[2]

	if p5 == v3 then
		return
	end

	collectConflictsBetween(object, p, p2, p3, p4, p5, v3)

	for i = 1, #v4 do
		collectConflictsBetweenFieldsAndFragment(object, p, p2, p3, p4, p5, v4[i])
	end
end

collectConflictsBetweenFragments = function(object, p, p2, object2, p3, p4, p5)
	if p4 == p5 or object2:has(p4, p5, p3) then
		return
	end

	object2:add(p4, p5, p3)

	local fragment = object:getFragment(p4)
	local fragment2 = object:getFragment(p5)

	if not (fragment and fragment2) then
		return
	end

	local v2 = getReferencedFieldsAndFragmentNames(object, p2, fragment)

	local v3 = v2[1]
	local v4 = v2[2]

	local v5 = getReferencedFieldsAndFragmentNames(object, p2, fragment2)

	local v6 = v5[1]
	local v7 = v5[2]

	collectConflictsBetween(object, p, p2, object2, p3, v3, v6)

	for i = 1, #v7 do
		collectConflictsBetweenFragments(object, p, p2, object2, p3, p4, v7[i])
	end

	for i = 1, #v4 do
		collectConflictsBetweenFragments(object, p, p2, object2, p3, v4[i], p5)
	end
end

local function findConflictsBetweenSubSelectionSets(p, p2, p3, p4, p5, selectionSet, p6, selectionSet2)
	local conflictsBetweenSubSelectionSets = {}

	local v2 = getFieldsAndFragmentNames(p, p2, p5, selectionSet)

	local v3 = v2[1]
	local v4 = v2[2]

	local v5 = getFieldsAndFragmentNames(p, p2, p6, selectionSet2)

	local v6 = v5[1]
	local v7 = v5[2]

	collectConflictsBetween(p, conflictsBetweenSubSelectionSets, p2, p3, p4, v3, v6)

	if #v7 ~= 0 then
		for i = 1, #v7 do
			collectConflictsBetweenFieldsAndFragment(p, conflictsBetweenSubSelectionSets, p2, p3, p4, v3, v7[i])
		end
	end

	if #v4 ~= 0 then
		for i = 1, #v4 do
			collectConflictsBetweenFieldsAndFragment(p, conflictsBetweenSubSelectionSets, p2, p3, p4, v6, v4[i])
		end
	end

	for i = 1, #v4 do
		for j = 1, #v7 do
			collectConflictsBetweenFragments(p, conflictsBetweenSubSelectionSets, p2, p3, p4, v4[i], v7[j])
		end
	end

	return conflictsBetweenSubSelectionSets
end

collectConflictsWithin = function(p, list, p2, p3, items)
	for _, item in items do
		local v2 = item[1]
		local v3 = item[2]

		if not (#v3 > 1) then
			continue
		end

		for i = 1, #v3 do
			for j = i + 1, #v3 do
				local v4 = findConflict(p, p2, p3, false, v2, v3[i], v3[j])

				if v4 then
					table.insert(list, v4)
				end
			end
		end
	end
end

collectConflictsBetween = function(p, list, p2, p3, p4, object, p5)
	for _, v2 in ipairs(object:keys()) do
		local v3 = p5[v2]

		if not v3 then
			continue
		end

		local v4 = object[v2]

		for i = 1, #v4 do
			for j = 1, #v3 do
				local v5 = findConflict(p, p2, p3, p4, v2, v4[i], v3[j])

				if v5 then
					table.insert(list, v5)
				end
			end
		end
	end
end

findConflict = function(p, p2, p3, flag: boolean, p4: string, list, list2)
	local item = list[1]
	local item2 = list[2]
	local item3 = list[3]
	local item4 = list2[1]
	local item5 = list2[2]
	local item6 = list2[3]

	if not flag then
		if item == item4 then
			flag = false
		else
			flag = isObjectType(item) and isObjectType(item4)
		end
	end

	if not flag then
		local value = item2.name.value
		local value2 = item5.name.value

		if value ~= value2 then
			return {
				{ p4, ("\"%s\" and \"%s\" are different fields"):format(value, value2) },
				{ item2 },
				{ item5 }
			}
		end

		local arguments = item2.arguments or {}

		local arguments2 = item5.arguments or {}

		if not sameArguments(arguments, arguments2) then
			return {
				{ p4, "they have differing arguments" },
				{ item2 },
				{ item5 }
			}
		end
	end

	local kind2 = item3 and item3.type
	local kind3 = item6 and item6.type

	if kind2 and kind3 and doTypesConflict(kind2, kind3) then
		return {
			{ p4, ("they return conflicting types \"%s\" and \"%s\""):format(inspect2(kind2), inspect2(kind3)) },
			{ item2 },
			{ item5 }
		}
	end

	local selectionSet = item2.selectionSet
	local selectionSet2 = item5.selectionSet

	if selectionSet and selectionSet2 then
		local conflictsBetweenSubSelectionSets = findConflictsBetweenSubSelectionSets(
			p,
			p2,
			p3,
			flag,
			getNamedType(kind2),
			selectionSet,
			getNamedType(kind3),
			selectionSet2
		)

		return subfieldConflicts(conflictsBetweenSubSelectionSets, p4, item2, item5)
	end

	return nil
end

local sameValue
local _collectFieldsAndFragmentNames

sameArguments = function(arguments, arguments2)
	if #arguments == #arguments2 then
		return Array.every(arguments, function(p)
			local v2 = Array.find(arguments2, function(p2): boolean
				return p2.name.value == p.name.value
			end)

			if v2 then
				return sameValue(p.value, v2.value)
			end

			return false
		end)
	end

	return false
end

sameValue = function(value, value2): boolean
	return Print(value) == Print(value2)
end

doTypesConflict = function(kind2, kind3)
	if isListType(kind2) then
		if isListType(kind3) then
			return doTypesConflict(kind2.ofType, kind3.ofType)
		end

		return true
	end

	if isListType(kind3) then
		return true
	end

	if isNonNullType(kind2) then
		if isNonNullType(kind3) then
			return doTypesConflict(kind2.ofType, kind3.ofType)
		end

		return true
	end

	if isNonNullType(kind3) then
		return true
	end

	if isLeafType(kind2) or isLeafType(kind3) then
		return kind2 ~= kind3
	end

	return false
end

getFieldsAndFragmentNames = function(p, fieldsAndFragmentNames, p2, p3)
	local fieldsAndFragmentNames2 = fieldsAndFragmentNames[p3]

	if fieldsAndFragmentNames2 then
		return fieldsAndFragmentNames2
	end

	local v2 = Map.new()
	local v3 = {}
	_collectFieldsAndFragmentNames(p, p2, p3, v2, v3)

	fieldsAndFragmentNames2 = { v2, Object.keys(v3) }
	fieldsAndFragmentNames[p3] = fieldsAndFragmentNames2

	return fieldsAndFragmentNames2
end

getReferencedFieldsAndFragmentNames = function(object, p, fragment)
	local v2 = p[fragment.selectionSet]

	if v2 then
		return v2
	end

	local v3 = typeFromAST2(object:getSchema(), fragment.typeCondition)
	return getFieldsAndFragmentNames(object, p, v3, fragment.selectionSet)
end

_collectFieldsAndFragmentNames = function(object, object2, p, p2, p3)
	for _, selection in ipairs(p.selections) do
		local kind2 = selection.kind

		if kind2 == kind.FIELD then
			local value = selection.name.value
			local v2

			if isObjectType(object2) or isInterfaceType(object2) then
				v2 = object2:getFields():get(value)
			end

			if selection.alias then
				value = selection.alias.value
			end

			if not p2[value] then
				p2[value] = {}
			end

			table.insert(p2[value], { object2 or null, selection or null, v2 or null })
		elseif kind2 == kind.FRAGMENT_SPREAD then
			p3[selection.name.value] = true
		elseif kind2 == kind.INLINE_FRAGMENT then
			local typeCondition = selection.typeCondition
			local v2

			if typeCondition then
				v2 = typeFromAST2(object:getSchema(), typeCondition)
			else
				v2 = object2
			end

			_collectFieldsAndFragmentNames(object, v2, selection.selectionSet, p2, p3)
		end
	end
end

subfieldConflicts = function(conflictsBetweenSubSelectionSets, p: string, item, item2)
	if #conflictsBetweenSubSelectionSets > 0 then
		return {
			{
				p,
				Array.map(conflictsBetweenSubSelectionSets, function(list)
					return list[1]
				end)
			},
			Array.reduce(conflictsBetweenSubSelectionSets, function(p2, list)
				local item3 = list[2]
				return Array.concat(p2, item3)
			end, { item }),
			Array.reduce(conflictsBetweenSubSelectionSets, function(p2, list)
				local item3 = list[3]
				return Array.concat(p2, item3)
			end, { item2 })
		}
	end

	return nil
end

v = {}
local v2 = { __index = v }

function v.new()
	local self = setmetatable({}, v2)
	self._data = {}
	return self
end

function v:has(p: string, p2: string, flag: boolean): boolean
	local v3 = self._data[p]
	local v4 = v3 and v3[p2]
	return v4 ~= nil and (flag ~= false or v4 == false)
end

function v:add(p: string, p2: string, flag: boolean)
	self:_pairSetAdd(p, p2, flag)
	self:_pairSetAdd(p2, p, flag)
end

function v:_pairSetAdd(p: string, p2: string, flag: boolean)
	local v3 = self._data[p]

	if not v3 then
		v3 = {}
		self._data[p] = v3
	end

	v3[p2] = flag
end

return OverlappingFieldsCanBeMergedRule
