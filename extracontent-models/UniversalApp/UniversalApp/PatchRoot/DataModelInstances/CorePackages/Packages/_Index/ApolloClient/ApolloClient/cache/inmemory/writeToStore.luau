local __DEV__ = _G.__DEV__

local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local LuauPolyfill = require(parent2.LuauPolyfill)
local Boolean = LuauPolyfill.Boolean
local Object = LuauPolyfill.Object
local Map = LuauPolyfill.Map
local Set = LuauPolyfill.Set
local Array = LuauPolyfill.Array

local utilities = require(parent.utilities)
local null = utilities.NULL

local HttpService = game:GetService("HttpService")

require(parent2.GraphQL)

local invariant = require(parent.jsutils.invariant)
local invariant2 = invariant.invariant
local invariantError = invariant.InvariantError

local equal = require(parent.jsutils.equal)

local objectKeysForEach = require(parent.luaUtils.objectKeysForEach)

local utilities2 = require(parent.utilities)
local createFragmentMap = utilities2.createFragmentMap

local getFragmentFromSelection = utilities2.getFragmentFromSelection
local getDefaultValues = utilities2.getDefaultValues
local getFragmentDefinitions = utilities2.getFragmentDefinitions
local getOperationDefinition = utilities2.getOperationDefinition
local getTypenameFromResult = utilities2.getTypenameFromResult
local makeReference = utilities2.makeReference
local isField = utilities2.isField
local resultKeyNameFromField = utilities2.resultKeyNameFromField
local isReference = utilities2.isReference
local shouldInclude = utilities2.shouldInclude
local cloneDeep = utilities2.cloneDeep
local addTypenameToDocument = utilities2.addTypenameToDocument

require(script.Parent.types)

local helpers = require(script.Parent.helpers)
local makeProcessedFieldsMerger = helpers.makeProcessedFieldsMerger
local fieldNameFromStoreName = helpers.fieldNameFromStoreName
local storeValueIsStoreObject = helpers.storeValueIsStoreObject

require(script.Parent.entityStore)

require(script.Parent.Parent.core.types.Cache)

local objectcanon = require(script.Parent["object-canon"])
local canonicalStringify = objectcanon.canonicalStringify

require(script.Parent.writeToStore_types)

local warnAboutDataLoss
local getChildMergeTree
local maybeRecycleChildMergeTree
local mergeMergeTrees
local mergeTreeIsEmpty

local class = {}
class.__index = class

function class.new(cache, reader)
	local self = setmetatable({}, class)
	self.cache = cache
	self.reader = reader
	return self
end

function class:writeToStore(object, data)
	local query = data.query
	local result = data.result
	local dataId = data.dataId
	local variables = data.variables
	local overwrite = data.overwrite
	local operationDefinition = getOperationDefinition(query)
	local processedFieldsMerger = makeProcessedFieldsMerger()

	local variables2 = Object.assign(getDefaultValues(operationDefinition), variables)

	local context = {
		store = object,
		written = {},
		merge = function(p, p2)
			return processedFieldsMerger:merge(p, p2)
		end,
		variables = variables2,
		varString = canonicalStringify(variables2),
		fragmentMap = createFragmentMap(getFragmentDefinitions(query)),
		overwrite = overwrite or false,
		incomingById = Map.new(nil),
		clientOnly = false
	}

	local v = self:processSelectionSet({
		result = result or {},
		dataId = dataId,
		selectionSet = operationDefinition.selectionSet,
		mergeTree = { map = Map.new(nil) },
		context = context
	})

	if not isReference(v) then
		error(invariantError.new(("Could not identify object %s"):format(HttpService:JSONEncode(result))))
	end

	context.incomingById:forEach(function(data2, p)
		local fields = data2.fields
		local mergeTree = data2.mergeTree
		local selections = data2.selections

		local reference = makeReference(p)

		if mergeTree.map.size > 0 then
			fields = self:applyMerges(mergeTree, reference, fields, context)

			if isReference(fields) then
				return
			end
		end

		if __DEV__ and not context.overwrite then
			local v2 = nil
			local function hasSelectionSet(p2: string) -- 1 equivalent call inferred from this helper
				return v2:has(fieldNameFromStoreName(p2))
			end

			v2 = Set.new()
			selections:forEach(function(p2)
				if isField(p2) and p2.selectionSet then
					v2:add(p2.name.value)
				end
			end)

			local function hasMergeFunction(p2: string): boolean -- 1 equivalent call inferred from this helper
				local v3 = mergeTree.map:get(p2)
				return v3 ~= nil and v3.info ~= nil and v3.info.merge ~= nil
			end

			objectKeysForEach(fields, function(p2)
				if hasSelectionSet(p2) and not hasMergeFunction(p2) then -- inferred equivalent call
					warnAboutDataLoss(reference, fields, p2, context.store)
				end
			end)
		end

		object:merge(p, fields)
	end)

	object:retain(v.__ref)

	return v
end

function class:processSelectionSet(data)
	local dataId = data.dataId
	local result = data.result
	local selectionSet = data.selectionSet
	local context = data.context

	local mergeTree = data.mergeTree

	local policies = self.cache.policies

	local v, v2 = table.unpack(policies:identify(result, selectionSet, context.fragmentMap), 1, 2)

	local v3 = dataId or v

	if type(v3) == "string" then
		local selectionSets

		if context.written[v3] == nil then
			selectionSets = {}
			context.written[v3] = selectionSets
		else
			selectionSets = context.written[v3]
		end

		local reference = makeReference(v3)

		if Array.indexOf(selectionSets, selectionSet) >= 1 then
			return reference
		end

		table.insert(selectionSets, selectionSet)

		if self.reader ~= nil and self.reader:isFresh(result, reference, selectionSet, context) then
			return reference
		end
	end

	local merged = {}

	if v2 ~= nil then
		merged = context.merge(merged, v2)
	end

	local typename = v3 and policies.rootTypenamesById[v3]
		or getTypenameFromResult(result, selectionSet, context.fragmentMap)
		or v3 and context.store:get(v3, "__typename")

	if type(typename) == "string" then
		merged.__typename = typename
	end

	local selections = Set.new(selectionSet.selections)

	for _, field in selections do
		if not shouldInclude(field, context.variables) then
			continue
		end

		if isField(field) then
			local v4 = result[resultKeyNameFromField(field)]

			local clientOnly = context.clientOnly

			context.clientOnly = clientOnly or field.directives and Array.some(field.directives, function(p): boolean
				return p.name.value == "client"
			end)

			if v4 == nil then
				if not (context.clientOnly or addTypenameToDocument:added(field)) then
					invariant2.error((string.sub(
						("Missing field '%s' while writing result %s"):format(
							resultKeyNameFromField(field),
							HttpService:JSONEncode(result)
						),
						1,
						1000
					)))
				end
			else
				local storeFieldName = policies:getStoreFieldName({
					typename = typename,
					fieldName = field.name.value,
					field = field,
					variables = context.variables
				})

				local v5 = getChildMergeTree(mergeTree, storeFieldName)

				local v6 = self:processFieldValue(v4, field, context, v5)
				local v7

				if field.selectionSet ~= nil then
					v7 = context.store:getFieldValue(v6, "__typename")

					if not v7 and isReference(v6) then
						local v8 = context.incomingById:get(v6.__ref)

						if v8 == nil then
							v7 = nil
						else
							v7 = v8.fields.__typename
						end
					end
				end

				local mergeFunction = policies:getMergeFunction(typename, field.name.value, v7)

				if mergeFunction == nil then
					maybeRecycleChildMergeTree(mergeTree, storeFieldName)
				else
					v5.info = { field = field, typename = typename, merge = mergeFunction }
				end

				merged = context.merge(merged, { [storeFieldName] = v6 })
			end

			context.clientOnly = clientOnly
		else
			local fragmentFromSelection = getFragmentFromSelection(field, context.fragmentMap)

			if
				fragmentFromSelection
				and policies:fragmentMatches(fragmentFromSelection, typename, result, context.variables)
			then
				Array.forEach(fragmentFromSelection.selectionSet.selections, selections.add, selections)
			end
		end
	end

	if type(v3) ~= "string" then
		return merged
	end

	local v4 = context.incomingById:get(v3)

	if v4 then
		v4.fields = context.merge(v4.fields, merged)
		v4.mergeTree = mergeMergeTrees(v4.mergeTree, mergeTree)

		v4.selections:forEach(selections.add, selections)
		v4.selections = selections
	else
		context.incomingById:set(v3, {
			fields = merged,
			mergeTree = mergeTree,
			selections = selections
		})
	end

	return makeReference(v3)
end

function class:processFieldValue(p, p2, context, mergeTree)
	if p2.selectionSet and p ~= null then
		if Array.isArray(p) then
			return Array.map(p, function(p3, p4)
				local v = self:processFieldValue(p3, p2, context, getChildMergeTree(mergeTree, p4))
				maybeRecycleChildMergeTree(mergeTree, p4)
				return v
			end)
		end

		return self:processSelectionSet({
			result = p,
			selectionSet = p2.selectionSet,
			context = context,
			mergeTree = mergeTree
		})
	elseif __DEV__ then
		return cloneDeep(p)
	else
		return p
	end
end

function class:applyMerges(p, p2, p3, p4, list)
	if p.map.size > 0 and not isReference(p3) then
		local v

		if Array.isArray(p3) then
			v = false
		else
			v = isReference(p2) or storeValueIsStoreObject(p2)
		end

		local v2

		if v then
			v2 = p2
		else
			v2 = nil
		end

		local v3 = p3

		list = v2 ~= nil and not list and (isReference(v2) and { v2.__ref } or { v2 }) or list

		local v4 = nil

		local function getValue(p5, value) -- 2 equivalent calls inferred from this helper
			if not Array.isArray(p5) then
				return p4.store:getFieldValue(p5, (tostring(value)))
			end

			if typeof(value) == "number" then
				return p5[value]
			end

			return nil
		end

		p.map:forEach(function(p5, value)
			local value2 = getValue(v2, value) -- inferred equivalent call
			local value3 = getValue(v3, value) -- inferred equivalent call

			if value3 == nil then
				return
			end

			if list ~= nil then
				table.insert(list, value)
			end

			local v5 = self:applyMerges(p5, value2, value3, p4, list)

			if v5 ~= value3 then
				v4 = v4 or Map.new(nil)

				v4:set(value, v5)
			end

			if list ~= nil then
				invariant2(table.remove(list, #list) == value)
			end
		end)

		if v4 ~= nil then
			p3 = table.clone(v3)

			v4:forEach(function(p5, p6)
				p3[p6] = p5
			end)
		end
	end

	if p.info then
		return self.cache.policies:runMergeFunction(
			p2,
			p3,
			p.info,
			p4,
			Boolean.toJSBoolean(list) and p4.store:getStorage(table.unpack(list)) or nil
		)
	end

	return p3
end

local v = {}

getChildMergeTree = function(p, p2)
	local map = p.map

	if not map:has(p2) then
		map:set(p2, table.remove(v, #v) or { map = Map.new(nil) })
	end

	return (map:get(p2))
end

mergeMergeTrees = function(mergeTree, mergeTree2)
	if mergeTree == mergeTree2 or mergeTree2 == nil or mergeTreeIsEmpty(mergeTree2) then
		return mergeTree
	end

	if mergeTree == nil or mergeTreeIsEmpty(mergeTree) then
		return mergeTree2
	end

	local info

	if mergeTree.info and mergeTree2.info then
		info = Object.assign(table.clone(mergeTree.info), mergeTree2.info)
	else
		info = mergeTree.info or mergeTree2.info
	end

	local size

	if mergeTree.map.size > 0 then
		size = mergeTree2.map.size
	else
		size = mergeTree.map.size
	end

	local map

	if size > 0 then
		map = Map.new()
	elseif mergeTree.map.size > 0 then
		map = mergeTree.map
	else
		map = mergeTree2.map
	end

	local v2 = { info = info, map = map }

	if size > 0 then
		local v3 = Set.new(mergeTree2.map:keys())

		mergeTree.map:forEach(function(p, p2)
			v2.map:set(p2, mergeMergeTrees(p, mergeTree2.map:get(p2)))
			v3:delete(p2)
		end)

		v3:forEach(function(p)
			v2.map:set(p, mergeMergeTrees(mergeTree2.map:get(p), mergeTree.map:get(p)))
		end)
	end

	return v2
end

mergeTreeIsEmpty = function(p)
	local v2 = not p

	if not v2 then
		local info = p.info or p.map.size > 0
		return not info
	end

	return v2
end

maybeRecycleChildMergeTree = function(p, p2)
	local map = p.map

	local v2 = map:get(p2)

	if v2 ~= nil and mergeTreeIsEmpty(v2) then
		table.insert(v, v2)
		map:delete(p2)
	end
end

local v2 = Set.new()

warnAboutDataLoss = function(reference, fields, p: string, store)
	local function getChild(p2) -- 2 equivalent calls inferred from this helper
		local child = store:getFieldValue(p2, p)

		if typeof(child) ~= "table" then
			child = false
		end

		return child
	end

	local child = getChild(reference) -- inferred equivalent call

	if not child then
		return
	end

	local child2 = getChild(fields) -- inferred equivalent call

	if not child2 or isReference(child) or equal(child, child2) then
		return
	end

	if Array.every(Object.keys(child), function(p2): boolean
		return store:getFieldValue(child2, p2) ~= nil
	end) then
		return
	end

	local fieldValue = store:getFieldValue(reference, "__typename")
	local v3 = Boolean.toJSBoolean(fieldValue) and fieldValue or store:getFieldValue(fields, "__typename")

	local v4 = fieldNameFromStoreName(p)
	local formatted = ("%s.%s"):format(v3, v4)

	if v2:has(formatted) then
		return
	end

	v2:add(formatted)

	local fieldValues = {}

	if not (Array.isArray(child) or Array.isArray(child2)) then
		Array.forEach({ child, child2 }, function(p2)
			local fieldValue2 = store:getFieldValue(p2, "__typename")

			if typeof(fieldValue2) == "string" and not Array.includes(fieldValues, fieldValue2) then
				table.insert(fieldValues, fieldValue2)
			end
		end)
	end

	invariant2.warn(("Cache data may be lost when replacing the %s field of a %s object.\n\n\tTo address this problem (which is not a bug in Apollo Client), %sdefine a custom merge function for the %s field, so InMemoryCache can safely merge these objects:\n\n\t  existing: %s\n\t  incoming: %s\n\n\tFor more information about these options, please refer to the documentation:\n\n\t  * Ensuring entity objects have IDs: https://go.apollo.dev/c/generating-unique-identifiers\n\t  * Defining custom merge functions: https://go.apollo.dev/c/merging-non-normalized-objects\n\t"):format(
		v4,
		v3,
		not Boolean.toJSBoolean(#fieldValues) and "" or "either ensure all objects of type " .. Array.join(fieldValues, " and ") .. " have an ID or a custom merge function, or ",
		formatted,
		string.sub(HttpService:JSONEncode(child), 1, 1000),
		(string.sub(HttpService:JSONEncode(child2), 1, 1000))
	))
end

return { StoreWriter = class }
