local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local LuauPolyfill = require(parent2.LuauPolyfill)
local Array = LuauPolyfill.Array
local Object = LuauPolyfill.Object
local Boolean = LuauPolyfill.Boolean
local Set = LuauPolyfill.Set
local WeakMap = LuauPolyfill.WeakMap

local HttpService = game:GetService("HttpService")
local utilities = require(parent.utilities)
local null = utilities.NULL

local assertSelectionSetForIdValue

require(parent2.GraphQL)

local optimism = require(parent.optimism)
local wrap = optimism.wrap

local invariant = require(parent.jsutils.invariant)
local invariant2 = invariant.invariant
local invariantError = invariant.InvariantError

local utilities2 = require(script.Parent.Parent.Parent.utilities)
local isField = utilities2.isField
local resultKeyNameFromField = utilities2.resultKeyNameFromField

local isReference = utilities2.isReference
local makeReference = utilities2.makeReference

local createFragmentMap = utilities2.createFragmentMap

local shouldInclude = utilities2.shouldInclude
local addTypenameToDocument = utilities2.addTypenameToDocument
local getDefaultValues = utilities2.getDefaultValues
local getFragmentDefinitions = utilities2.getFragmentDefinitions
local getMainDefinition = utilities2.getMainDefinition
local getQueryDefinition = utilities2.getQueryDefinition
local mergeDeepArray = utilities2.mergeDeepArray
local getFragmentFromSelection = utilities2.getFragmentFromSelection
local maybeDeepFreeze = utilities2.maybeDeepFreeze
local isNonNullObject = utilities2.isNonNullObject
local canUseWeakMap = utilities2.canUseWeakMap
require(script.Parent.Parent.core.types.Cache)

require(script.Parent.types)

local entityStore = require(script.Parent.entityStore)
local maybeDependOnExistenceOfEntity = entityStore.maybeDependOnExistenceOfEntity
local supportsResultCaching = entityStore.supportsResultCaching

local helpers = require(script.Parent.helpers)
local getTypenameFromStoreObject = helpers.getTypenameFromStoreObject
require(script.Parent.policies)

local common = require(script.Parent.Parent.core.types.common)
local missingFieldError = common.MissingFieldError

local objectcanon = require(script.Parent["object-canon"])
local canonicalStringify = objectcanon.canonicalStringify
local objectCanon = objectcanon.ObjectCanon

local function missingFromInvariant(p, context)
	return missingFieldError.new(p.message, Array.slice(context.path), context.query, context.variables)
end

local function execSelectionSetKeyArgs(data) -- 2 equivalent calls inferred from this helper
	return { data.selectionSet, data.objectOrReference, data.context, data.context.canonizeResults }
end

local class = {}
class.__index = class

function class:resetCanon()
	self.canon = objectCanon.new()
end

local function makeSelectionSetCacheKey(_, p, p2, p3, p4)
	if not supportsResultCaching(p3.store) then
		return nil
	end

	local store = p3.store

	p2 = isReference(p2) and p2.__ref or p2
	return store:makeCacheKey(p, p2, p3.varString, p4)
end

local function makeSubSelectedCacheKey(_, data)
	local field = data.field
	local array = data.array
	local context = data.context

	if supportsResultCaching(context.store) then
		return context.store:makeCacheKey(field, array, context.varString)
	end

	return nil
end

function class.new(p)
	local object = setmetatable({}, class)

	object.knownResults = WeakMap.new()

	object.config = Object.assign(table.clone(p), {
		addTypename = p.addTypename ~= false
	})

	object.canon = p.canon or objectCanon.new()

	object.executeSelectionSet = wrap(function(_, data)
		local canonizeResults = data.context.canonizeResults
		local v = execSelectionSetKeyArgs(data) -- inferred equivalent call
		v[4] = not canonizeResults

		local v2 = object.executeSelectionSet:peek(table.unpack(v))

		if v2 == nil then
			maybeDependOnExistenceOfEntity(data.context.store, data.enclosingRef.__ref)

			return object:execSelectionSetImpl(data)
		end

		if canonizeResults then
			return Object.assign(table.clone(v2), { result = object.canon:admit(v2.result) })
		end

		return v2
	end, {
		max = object.config.resultCacheMaxSize,
		keyArgs = function(_, ...)
			return execSelectionSetKeyArgs(...) -- inferred equivalent call
		end,
		makeCacheKey = makeSelectionSetCacheKey
	}, object)

	object.executeSubSelectedArray = wrap(function(_, p2)
		maybeDependOnExistenceOfEntity(p2.context.store, p2.enclosingRef.__ref)
		return object:execSubSelectedArrayImpl(p2)
	end, { max = object.config.resultCacheMaxSize, makeCacheKey = makeSubSelectedCacheKey }, object)

	return object
end

function class.diffQueryAgainstStore(object, data)
	local store = data.store
	local query = data.query
	local rootId = data.rootId
	local variables = data.variables
	local returnPartialData = data.returnPartialData
	local canonizeResults = data.canonizeResults
	local v = rootId == nil and "ROOT_QUERY" or rootId

	local v2 = returnPartialData == nil or returnPartialData

	local canonizeResults2 = canonizeResults == nil or canonizeResults

	local policies = object.config.cache.policies

	local variables2 = Object.assign({}, getDefaultValues(getQueryDefinition(query)), variables)

	local reference = makeReference(v)
	local v3 = object:executeSelectionSet({
		selectionSet = getMainDefinition(query).selectionSet,
		objectOrReference = reference,
		enclosingRef = reference,
		context = {
			store = store,
			query = query,
			policies = policies,
			variables = variables2,
			varString = canonicalStringify(variables2),
			canonizeResults = canonizeResults2,
			fragmentMap = createFragmentMap(getFragmentDefinitions(query)),
			path = {}
		}
	})

	local v4 = v3.missing and #v3.missing > 0

	if v4 and not v2 then
		error(v3.missing[1])
	end

	return {
		result = v3.result,
		missing = v3.missing,
		complete = not v4
	}
end

function class.isFresh(data, p, p2, p3, p4): boolean
	if supportsResultCaching(p4.store) and data.knownResults:get(p) == p3 then
		local v = data.executeSelectionSet:peek(p3, p2, p4, data.canon:isKnown(p))

		if v and p == v.result then
			return true
		end
	end

	return false
end

function class:execSelectionSetImpl(data)
	local selectionSet = data.selectionSet
	local objectOrReference = data.objectOrReference
	local enclosingRef = data.enclosingRef
	local context = data.context

	if
		objectOrReference.__ref
		and not (context.policies.rootTypenamesById[objectOrReference.__ref] or context.store:has(objectOrReference.__ref))
	then
		return {
			result = self.canon.empty,
			missing = { missingFromInvariant(
					invariantError.new(("Dangling reference to missing %s object"):format(objectOrReference.__ref)),
					context
				) }
		}
	end

	local variables = context.variables
	local policies = context.policies
	local v = {}
	local v2 = { result = null }
	local fieldValue = context.store:getFieldValue(objectOrReference, "__typename")

	if self.config.addTypename and type(fieldValue) == "string" and not policies.rootIdsByTypename[fieldValue] then
		table.insert(v, { __typename = fieldValue })
	end

	local function getMissing() -- 2 equivalent calls inferred from this helper
		if not v2.missing then
			v2.missing = {}
		end

		return v2.missing
	end

	local function handleMissing(p) -- 2 equivalent calls inferred from this helper
		if p.missing then
			local missing = getMissing() -- inferred equivalent call

			for _, v3 in p.missing do
				table.insert(missing, v3)
			end
		end

		return p.result
	end

	local v3 = Set.new(selectionSet.selections)

	for _, field in v3 do
		if not shouldInclude(field, variables) then
			continue
		end

		if isField(field) then
			local v4 = policies:readField(
				{
					fieldName = field.name.value,
					field = field,
					variables = context.variables,
					from = objectOrReference
				},
				context
			)

			local v5 = resultKeyNameFromField(field)
			table.insert(context.path, v5)

			if v4 == nil then
				if not addTypenameToDocument:added(field) then
					table.insert(
						getMissing(), -- inferred equivalent call
						missingFromInvariant(
							invariantError.new(("Can't find field '%s' on %s"):format(
								field.name.value,
								isReference(objectOrReference) and objectOrReference.__ref .. " object" or "object " .. HttpService:JSONEncode(objectOrReference)
							)),
							context
						)
					)
				end
			elseif Array.isArray(v4) then
				v4 = handleMissing(self:executeSubSelectedArray({ -- inferred equivalent call
					field = field,
					array = v4,
					enclosingRef = enclosingRef,
					context = context
				}))
			elseif field.selectionSet then
				if v4 ~= null then
					local v6 = {
						selectionSet = field.selectionSet,
						objectOrReference = v4,
						enclosingRef = 0,
						context = 0
					}
					local enclosingRef2

					if isReference(v4) then
						enclosingRef2 = v4 or enclosingRef
					else
						enclosingRef2 = enclosingRef
					end

					v6.enclosingRef = enclosingRef2
					v6.context = context
					v4 = handleMissing(self:executeSelectionSet(v6)) -- inferred equivalent call
				end
			elseif context.canonizeResults then
				v4 = self.canon:pass(v4)
			end

			if v4 ~= nil then
				table.insert(v, { [v5] = v4 })
			end

			local v6 = table.remove(context.path) == v5

			if not v6 then
				invariant2(v6)
			end
		else
			local fragmentFromSelection = getFragmentFromSelection(field, context.fragmentMap)

			if fragmentFromSelection and policies:fragmentMatches(fragmentFromSelection, fieldValue) then
				Array.forEach(fragmentFromSelection.selectionSet.selections, v3.add, v3)
			end
		end
	end

	local v4 = mergeDeepArray(v)

	if context.canonizeResults then
		v2.result = self.canon:admit(v4)
	else
		v2.result = maybeDeepFreeze(v4)
	end

	self.knownResults:set(v2.result, selectionSet)

	return v2
end

function class:execSubSelectedArrayImpl(data)
	local field = data.field
	local array = data.array
	local enclosingRef = data.enclosingRef
	local context = data.context

	local missing2 = nil

	local function handleMissing(p, p2: number)
		if p.missing then
			missing2 = missing2 or {}

			local missing = p.missing

			for i = 1, #missing do
				table.insert(missing2, missing[i])
			end
		end

		invariant2(table.remove(context.path) == p2)

		return p.result
	end

	if field.selectionSet then
		array = Array.filter(array, function(p)
			return context.store:canRead(p)
		end)
	end

	local mapped = Array.map(array, function(list, p: number)
		if list == null then
			return null
		end

		table.insert(context.path, p)

		if Array.isArray(list) and #list > 0 then
			return handleMissing(
				self:executeSubSelectedArray({
					field = field,
					array = list,
					enclosingRef = enclosingRef,
					context = context
				}),
				p
			)
		end

		if Boolean.toJSBoolean(field.selectionSet) then
			return handleMissing(self:executeSelectionSet({
				selectionSet = field.selectionSet,
				objectOrReference = list,
				enclosingRef = isReference(list) and list or enclosingRef,
				context = context
			}), p)
		end

		if _G.__DEV__ then
			assertSelectionSetForIdValue(context.store, field, list)
		end

		local v = table.remove(context.path) == p

		if not v then
			invariant2(v)
		end

		return list
	end)

	if context.canonizeResults then
		mapped = self.canon:admit(mapped)
	end

	return { result = mapped, missing = missing2 }
end

assertSelectionSetForIdValue = function(store, field, list)
	if not field.selectionSet then
		local v = Set.new({ list })

		for _, v2 in v do
			if not isNonNullObject(v2) then
				continue
			end

			invariant2(
				not isReference(v2),
				("Missing selection set for object of type %s returned for query field %s"):format(
					getTypenameFromStoreObject(store, v2) or "nil",
					field.name.value
				)
			)

			Array.forEach(Object.values(v2), v.add, v)
		end
	end
end

return { StoreReader = class }
