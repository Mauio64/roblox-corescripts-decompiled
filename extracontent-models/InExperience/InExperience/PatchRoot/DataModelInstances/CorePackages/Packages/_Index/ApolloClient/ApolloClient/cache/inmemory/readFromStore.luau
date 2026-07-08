local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local LuauPolyfill = require(ParentParentParent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Object = LuauPolyfill.Object
local Boolean = LuauPolyfill.Boolean
local Set = LuauPolyfill.Set
local WeakMap = LuauPolyfill.WeakMap
local HttpService = game:GetService("HttpService")
local NULL = require(ParentParent.utilities).NULL
local assertSelectionSetForIdValue = nil
local t1 = {}

require(ParentParentParent.GraphQL)

local wrap = require(ParentParent.optimism).wrap
local invariant = require(ParentParent.jsutils.invariant)
local invariant2 = invariant.invariant
local InvariantError = invariant.InvariantError
local utilities = require(script.Parent.Parent.Parent.utilities)
local isField = utilities.isField
local resultKeyNameFromField = utilities.resultKeyNameFromField
local isReference = utilities.isReference
local makeReference = utilities.makeReference
local createFragmentMap = utilities.createFragmentMap
local shouldInclude = utilities.shouldInclude
local addTypenameToDocument = utilities.addTypenameToDocument
local getDefaultValues = utilities.getDefaultValues
local getFragmentDefinitions = utilities.getFragmentDefinitions
local getMainDefinition = utilities.getMainDefinition
local getQueryDefinition = utilities.getQueryDefinition
local mergeDeepArray = utilities.mergeDeepArray
local getFragmentFromSelection = utilities.getFragmentFromSelection
local maybeDeepFreeze = utilities.maybeDeepFreeze
local isNonNullObject = utilities.isNonNullObject
local _ = utilities.canUseWeakMap

require(script.Parent.Parent.core.types.Cache)
require(script.Parent.types)

local entityStore = require(script.Parent.entityStore)
local maybeDependOnExistenceOfEntity = entityStore.maybeDependOnExistenceOfEntity
local supportsResultCaching = entityStore.supportsResultCaching
local getTypenameFromStoreObject = require(script.Parent.helpers).getTypenameFromStoreObject

require(script.Parent.policies)

local MissingFieldError = require(script.Parent.Parent.core.types.common).MissingFieldError
local lib = require(script.Parent["object-canon"])
local canonicalStringify = lib.canonicalStringify
local ObjectCanon = lib.ObjectCanon

local function missingFromInvariant(p1, p2) -- line: 114
	-- upvalues: MissingFieldError (copy), Array (copy)
	return MissingFieldError.new(p1.message, Array.slice(p2.path), p2.query, p2.variables)
end
local function execSelectionSetKeyArgs(t2: {[any]: any}) -- line: 147
	return {
		t2.selectionSet,
		t2.objectOrReference,
		t2.context,
		t2.context.canonizeResults
	}
end

local t3 = {}

t3.__index = t3

function t3.resetCanon(p3) -- line: 195
	-- upvalues: ObjectCanon (copy)
	p3.canon = ObjectCanon.new()
end

local function makeSelectionSetCacheKey(_, p5, p6, p7, p8) -- line: 200
	-- upvalues: supportsResultCaching (copy), isReference (copy)
	if supportsResultCaching(p7.store) then
		return p7.store:makeCacheKey(p5, isReference(p6) and p6.__ref or p6, p7.varString, p8)
	end

	return nil
end
local function makeSubSelectedCacheKey(_, p10) -- line: 212
	-- upvalues: supportsResultCaching (copy)
	local field = p10.field
	local array = p10.array
	local context = p10.context

	if supportsResultCaching(context.store) then
		return context.store:makeCacheKey(field, array, context.varString)
	end

	return nil
end

function t3.new(t4: {[any]: any}) -- line: 221
	-- upvalues: t3 (copy), WeakMap (copy), Object (copy), ObjectCanon (copy), wrap (copy), maybeDependOnExistenceOfEntity (copy), makeSelectionSetCacheKey (copy), makeSubSelectedCacheKey (copy)
	local self = setmetatable({}, t3)

	self.knownResults = WeakMap.new()
	self.config = Object.assign(table.clone(t4), {
		addTypename = t4.addTypename ~= false
	})
	self.canon = t4.canon or ObjectCanon.new()
	self.executeSelectionSet = wrap(function(_, p12) -- line: 236
		-- upvalues: self (copy), Object (copy), maybeDependOnExistenceOfEntity (copy)
		local canonizeResults = p12.context.canonizeResults
		local t5 = {
			p12.selectionSet,
			p12.objectOrReference,
			p12.context,
			p12.context.canonizeResults,
			[4] = not canonizeResults
		}
		local v131 = self.executeSelectionSet:peek(table.unpack(t5))

		if v131 ~= nil then
			if canonizeResults then
				return Object.assign(table.clone(v131), {
					result = self.canon:admit(v131.result)
				})
			end

			return v131
		end

		maybeDependOnExistenceOfEntity(p12.context.store, p12.enclosingRef.__ref)

		return self:execSelectionSetImpl(p12)
	end, {
		max = self.config.resultCacheMaxSize,
		keyArgs = function(_, ...) -- line: 271
			local v133 = ...

			return {
				v133.selectionSet,
				v133.objectOrReference,
				v133.context,
				v133.context.canonizeResults
			}
		end,
		makeCacheKey = makeSelectionSetCacheKey
	}, self)
	self.executeSubSelectedArray = wrap(function(_, t6: {[any]: any}) -- line: 281
		-- upvalues: maybeDependOnExistenceOfEntity (copy), self (copy)
		maybeDependOnExistenceOfEntity(t6.context.store, t6.enclosingRef.__ref)

		return self:execSubSelectedArrayImpl(t6)
	end, {
		max = self.config.resultCacheMaxSize,
		makeCacheKey = makeSubSelectedCacheKey
	}, self)

	return self
end
function t3.diffQueryAgainstStore(p15, p16) -- line: 301
	-- upvalues: Object (copy), getDefaultValues (copy), getQueryDefinition (copy), makeReference (copy), getMainDefinition (copy), canonicalStringify (copy), createFragmentMap (copy), getFragmentDefinitions (copy)
	local store = p16.store
	local query = p16.query
	local rootId = p16.rootId
	local variables = p16.variables
	local returnPartialData = p16.returnPartialData
	local canonizeResults = p16.canonizeResults

	if rootId == nil then
		rootId = "ROOT_QUERY"
	end

	if returnPartialData == nil then
		returnPartialData = true
	end

	if canonizeResults == nil then
		canonizeResults = true
	end

	local policies = p15.config.cache.policies
	local v72 = Object.assign({}, getDefaultValues(getQueryDefinition(query)), variables)
	local v73 = makeReference(rootId)
	local v74 = p15:executeSelectionSet({
		selectionSet = getMainDefinition(query).selectionSet,
		objectOrReference = v73,
		enclosingRef = v73,
		context = {
			store = store,
			query = query,
			policies = policies,
			variables = v72,
			varString = canonicalStringify(v72),
			canonizeResults = canonizeResults,
			fragmentMap = createFragmentMap(getFragmentDefinitions(query)),
			path = {}
		}
	})
	local v75 = v74.missing and #v74.missing > 0

	if v75 and not returnPartialData then
		error(v74.missing[1])
	end

	return {
		result = v74.result,
		missing = v74.missing,
		complete = not v75
	}
end
function t3.isFresh(t7: {[any]: any}, t8: {[any]: any}, p17, p18, p19) -- line: 349
	-- upvalues: supportsResultCaching (copy)
	if supportsResultCaching(p19.store) and p18 == t7.knownResults:get(t8) then
		local v81 = t7.executeSelectionSet:peek(p18, p17, p19, t7.canon:isKnown(t8))

		if v81 and t8 == v81.result then
			return true
		end
	end

	return false
end
function t3.execSelectionSetImpl(t9: {[any]: any}, t10: {[any]: any}) -- line: 375
	-- upvalues: missingFromInvariant (copy), InvariantError (copy), NULL (copy), Set (copy), shouldInclude (copy), isField (copy), resultKeyNameFromField (copy), addTypenameToDocument (copy), isReference (copy), HttpService (copy), Array (copy), invariant2 (copy), getFragmentFromSelection (copy), mergeDeepArray (copy), maybeDeepFreeze (copy)
	local selectionSet = t10.selectionSet
	local objectOrReference = t10.objectOrReference
	local enclosingRef = t10.enclosingRef
	local context = t10.context

	if objectOrReference.__ref and (not context.policies.rootTypenamesById[objectOrReference.__ref] and not context.store:has(objectOrReference.__ref)) then
		return {
			result = t9.canon.empty,
			missing = { missingFromInvariant(InvariantError.new(("Dangling reference to missing %s object"):format(objectOrReference.__ref)), context) }
		}
	end

	local variables = context.variables
	local policies = context.policies
	local store = context.store
	local t11 = {}
	local t12 = {
		result = NULL
	}
	local v93 = store:getFieldValue(objectOrReference, "__typename")

	if t9.config.addTypename and type(v93) == "string" and not policies.rootIdsByTypename[v93] then
		table.insert(t11, {
			__typename = v93
		})
	end

	local function getMissing() -- line: 412
		-- upvalues: t12 (copy)
		if not t12.missing then
			t12.missing = {}
		end

		return t12.missing
	end
	local function handleMissing(t13: {[any]: any}) -- line: 421
		-- upvalues: t12 (copy)
		if t13.missing then
			if not t12.missing then
				t12.missing = {}
			end

			local missing = t12.missing

			for _, v139 in t13.missing do
				table.insert(missing, v139)
			end
		end

		return t13.result
	end

	local v96 = Set.new(selectionSet.selections)

	for _, v98 in v96 do
		if shouldInclude(v98, variables) then
			if isField(v98) then
				local v99 = policies:readField({
					fieldName = v98.name.value,
					field = v98,
					variables = context.variables,
					from = objectOrReference
				}, context)
				local v100 = resultKeyNameFromField(v98)

				table.insert(context.path, v100)

				if v99 == nil then
					if not addTypenameToDocument:added(v98) then
						if not t12.missing then
							t12.missing = {}
						end

						table.insert(t12.missing, missingFromInvariant(InvariantError.new(("Can't find field '%s' on %s"):format(v98.name.value, isReference(objectOrReference) and objectOrReference.__ref .. " object" or "object " .. HttpService:JSONEncode(objectOrReference))), context))
					end
				elseif Array.isArray(v99) then
					local v101 = t9:executeSubSelectedArray({
						field = v98,
						array = v99,
						enclosingRef = enclosingRef,
						context = context
					})

					if v101.missing then
						if not t12.missing then
							t12.missing = {}
						end

						local missing = t12.missing

						for _, v104 in v101.missing do
							table.insert(missing, v104)
						end
					end

					v99 = v101.result
				elseif not v98.selectionSet then
					if context.canonizeResults then
						v99 = t9.canon:pass(v99)
					end
				elseif v99 ~= NULL then
					local v105 = t9:executeSelectionSet({
						selectionSet = v98.selectionSet,
						objectOrReference = v99,
						enclosingRef = isReference(v99) and v99 or enclosingRef,
						context = context
					})

					if v105.missing then
						if not t12.missing then
							t12.missing = {}
						end

						local missing = t12.missing

						for _, v108 in v105.missing do
							table.insert(missing, v108)
						end
					end

					v99 = v105.result
				end

				if v99 ~= nil then
					table.insert(t11, {
						[v100] = v99
					})
				end

				local v109 = v100 == table.remove(context.path)

				if not v109 then
					invariant2(v109)
				end
			else
				local v110 = getFragmentFromSelection(v98, context.fragmentMap)

				if v110 and policies:fragmentMatches(v110, v93) then
					Array.forEach(v110.selectionSet.selections, v96.add, v96)
				end
			end
		end
	end

	local v111 = mergeDeepArray(t11)

	if context.canonizeResults then
		t12.result = t9.canon:admit(v111)
	else
		t12.result = maybeDeepFreeze(v111)
	end

	t9.knownResults:set(t12.result, selectionSet)

	return t12
end
function t3.execSubSelectedArrayImpl(t14: {[any]: any}, t15: {[any]: any}) -- line: 553
	-- upvalues: invariant2 (copy), Array (copy), NULL (copy), Boolean (copy), isReference (copy), assertSelectionSetForIdValue (ref)
	local field = t15.field
	local array = t15.array
	local enclosingRef = t15.enclosingRef
	local context = t15.context
	local u118 = nil

	local function handleMissing(t16: {[any]: any}, n1: number) -- line: 558
		-- upvalues: u118 (ref), invariant2 (copy), context (copy)
		if t16.missing then
			u118 = u118 or {}

			local missing = t16.missing

			for i = 1, #missing do
				table.insert(u118, missing[i])
			end
		end

		invariant2(n1 == table.remove(context.path))

		return t16.result
	end

	if field.selectionSet then
		array = Array.filter(array, function(p20) -- line: 577
			-- upvalues: context (copy)
			return context.store:canRead(p20)
		end)
	end

	local v120 = Array.map(array, function(p21, n2: number) -- line: 582
		-- upvalues: NULL (copy), context (copy), Array (copy), handleMissing (copy), t14 (copy), field (copy), enclosingRef (copy), Boolean (copy), isReference (copy), assertSelectionSetForIdValue (ref), invariant2 (copy)
		if p21 == NULL then
			return NULL
		end

		table.insert(context.path, n2)

		if Array.isArray(p21) and #p21 > 0 then
			return (handleMissing(t14:executeSubSelectedArray({
				field = field,
				array = p21,
				enclosingRef = enclosingRef,
				context = context
			}), n2))
		end

		if Boolean.toJSBoolean(field.selectionSet) then
			return (handleMissing(t14:executeSelectionSet({
				selectionSet = field.selectionSet,
				objectOrReference = p21,
				enclosingRef = isReference(p21) and p21 or enclosingRef,
				context = context
			}), n2))
		end

		if _G.__DEV__ then
			assertSelectionSetForIdValue(context.store, field, p21)
		end

		local v147 = n2 == table.remove(context.path)

		if not v147 then
			invariant2(v147)
		end

		return p21
	end)

	return {
		result = if not context.canonizeResults then v120 else t14.canon:admit(v120),
		missing = u118
	}
end

t1.StoreReader = t3

function assertSelectionSetForIdValue(p22, p23, p24) -- line: 643
	-- upvalues: Set (copy), isNonNullObject (copy), invariant2 (copy), isReference (copy), getTypenameFromStoreObject (copy), Array (copy), Object (copy)
	if not p23.selectionSet then
		local v124 = Set.new({ p24 })

		for _, v126 in v124 do
			if isNonNullObject(v126) then
				invariant2(not isReference(v126), ("Missing selection set for object of type %s returned for query field %s"):format(getTypenameFromStoreObject(p22, v126) or "nil", p23.name.value))
				Array.forEach(Object.values(v126), v124.add, v124)
			end
		end
	end
end

return t1
