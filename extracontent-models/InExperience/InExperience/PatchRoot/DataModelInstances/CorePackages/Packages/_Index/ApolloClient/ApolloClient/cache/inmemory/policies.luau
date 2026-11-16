local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local HttpService = game:GetService("HttpService")

local LuauPolyfill = require(parent2.LuauPolyfill)
local Array = LuauPolyfill.Array
local Object = LuauPolyfill.Object
local Set = LuauPolyfill.Set
local Map = LuauPolyfill.Map

local isCallable = require(parent.luaUtils.isCallable)
local objectKeysForEach = require(parent.luaUtils.objectKeysForEach)

local LuauRegExp = require(parent2.LuauRegExp)

local makeFieldFunctionOptions
local makeMergeObjectsFunction
local keyArgsFnFromSpecifier
local keyFieldsFnFromSpecifier
local makeAliasMap
local computeKeyObject

require(parent2.GraphQL)

local trie = require(parent.wry.trie)
local trie2 = trie.Trie
local invariant = require(parent.jsutils.invariant)
local invariant2 = invariant.invariant
local invariantError = invariant.InvariantError

local utilities = require(script.Parent.Parent.Parent.utilities)

local getFragmentFromSelection = utilities.getFragmentFromSelection
local isField = utilities.isField
local getTypenameFromResult = utilities.getTypenameFromResult
local storeKeyNameFromField = utilities.storeKeyNameFromField

local argumentsObjectFromField = utilities.argumentsObjectFromField

local isReference = utilities.isReference
local getStoreKeyName = utilities.getStoreKeyName
local canUseWeakMap = utilities.canUseWeakMap
local isNonNullObject = utilities.isNonNullObject
local stringifyForDisplay = utilities.stringifyForDisplay

local helpers = require(script.Parent.helpers)

local hasOwnProperty = require(parent.luaUtils.hasOwnProperty)
local fieldNameFromStoreName = helpers.fieldNameFromStoreName
local storeValueIsStoreObject = helpers.storeValueIsStoreObject
local selectionSetMatchesResult = helpers.selectionSetMatchesResult
local typeOrFieldNameRegExp = helpers.TypeOrFieldNameRegExp
local reactiveVars = require(script.Parent.reactiveVars)
local cacheSlot = reactiveVars.cacheSlot

require(script.Parent.Parent.core.types.common)

require(script.Parent.writeToStore_types)

local objectcanon = require(script.Parent["object-canon"])
getStoreKeyName:setStringify(objectcanon.canonicalStringify)

require(script.Parent.policies_types)

local function argsFromFieldSpecifier(data) -- 3 equivalent calls inferred from this helper
	if data.args ~= nil then
		return data.args
	end

	if data.field then
		return (argumentsObjectFromField(data.field, data.variables))
	end

	return nil
end

local function defaultDataIdFromObject(_, data, p)
	local __typename = data.__typename
	local id2 = data.id
	local id = data._id

	if type(__typename) ~= "string" then
		return nil
	end

	if p then
		if id2 == nil then
			if id == nil then
				p.keyObject = nil
			else
				p.keyObject = { _id = id }
			end
		else
			p.keyObject = { id = id2 }
		end
	end

	if id2 == nil then
		id2 = id
	end

	if id2 == nil then
		return nil
	end

	local typeName = type(id2)

	if typeName ~= "number" and typeName ~= "string" then
		id2 = HttpService:JSONEncode(id2)
	end

	return string.format("%s:%s", __typename, id2)
end

local Policies = {}
Policies.defaultDataIdFromObject = defaultDataIdFromObject

local function nullKeyFieldsFn(_): nil
	return nil
end

local function simpleKeyArgsFn(_, p)
	return p.fieldName
end

local function mergeTrueFn(_, p, p2, object)
	return object:mergeObjects(p, p2)
end

local function mergeFalseFn(_, _, p)
	return p
end

local class = {}
class.__index = class

function class.new(config)
	local object = setmetatable({}, class)

	object.typePolicies = {}
	object.toBeAdded = {}

	object.supertypeMap = Map.new(nil)

	object.fuzzySubtypes = Map.new(nil)

	object.cache = nil
	object.rootIdsByTypename = {}
	object.rootTypenamesById = {}
	object.usingPossibleTypes = false

	object.config = config
	object.config = Object.assign({ dataIdFromObject = defaultDataIdFromObject }, config)

	object.cache = object.config.cache
	object:setRootTypename("Query")
	object:setRootTypename("Mutation")
	object:setRootTypename("Subscription")

	if config.possibleTypes then
		object:addPossibleTypes(config.possibleTypes)
	end

	if config.typePolicies then
		object:addTypePolicies(config.typePolicies)
	end

	return object
end

function class:identify(p, selectionSet, fragmentMap)
	local typename

	if selectionSet and fragmentMap then
		typename = getTypenameFromResult(p, selectionSet, fragmentMap)
	else
		typename = p.__typename
	end

	if typename == self.rootTypenamesById.ROOT_QUERY then
		return { "ROOT_QUERY" }
	end

	local v = { typename = typename, selectionSet = selectionSet, fragmentMap = fragmentMap }

	local v2 = nil

	local v3 = typename and self:getTypePolicy(typename)
	local v4

	if v3 and v3.keyFn then
		v4 = v3.keyFn
	else
		v4 = self.config.dataIdFromObject
	end

	while v4 do
		local v5 = v4(v3, p, v)

		if type(v5) == "table" then
			v4 = keyFieldsFnFromSpecifier(v5)
		else
			v2 = v5
			break
		end
	end

	local v5

	if v2 then
		v5 = tostring(v2)
	end

	if v.keyObject then
		return { v5, v.keyObject }
	end

	return { v5 }
end

function class:addTypePolicies(p)
	objectKeysForEach(p, function(p2)
		local v = p[p2]
		local queryType = v.queryType
		local mutationType = v.mutationType
		local subscriptionType = v.subscriptionType
		local v2 = Object.assign({}, v, {
			queryType = Object.None,
			mutationType = Object.None,
			subscriptionType = Object.None
		})

		if queryType then
			self:setRootTypename("Query", p2)
		end

		if mutationType then
			self:setRootTypename("Mutation", p2)
		end

		if subscriptionType then
			self:setRootTypename("Subscription", p2)
		end

		if hasOwnProperty(self.toBeAdded, p2) then
			table.insert(self.toBeAdded[p2], v2)
		else
			self.toBeAdded[p2] = { v2 }
		end
	end)
end

function class:updateTypePolicy(p: string, data)
	local typePolicy = self:getTypePolicy(p)
	local keyFields = data.keyFields
	local fields = data.fields

	local function setMerge(p2, merge) -- 2 equivalent calls inferred from this helper
		if isCallable(merge) then
			p2.merge = merge
		elseif merge == true then
			p2.merge = mergeTrueFn
		elseif merge == false then
			p2.merge = mergeFalseFn
		else
			p2.merge = p2.merge
		end
	end

	setMerge(typePolicy, data.merge) -- inferred equivalent call

	if keyFields == false then
		typePolicy.keyFn = nullKeyFieldsFn
	else
		local typeName = type(keyFields)

		if typeName == "table" then
			typePolicy.keyFn = keyFieldsFnFromSpecifier(keyFields)
		elseif typeName == "function" then
			typePolicy.keyFn = keyFields
		else
			typePolicy.keyFn = typePolicy.keyFn
		end
	end

	if fields then
		objectKeysForEach(fields, function(p2)
			local fieldPolicy = self:getFieldPolicy(p, p2, true)
			local field = fields[p2]

			if type(field) == "function" then
				fieldPolicy.read = field
			else
				local keyArgs = field.keyArgs
				local read = field.read
				local merge = field.merge

				if keyArgs == false then
					fieldPolicy.keyFn = simpleKeyArgsFn
				else
					local typeName = type(keyArgs)

					if typeName == "table" then
						fieldPolicy.keyFn = keyArgsFnFromSpecifier(keyArgs)
					elseif typeName == "function" then
						fieldPolicy.keyFn = keyArgs
					else
						fieldPolicy.keyFn = fieldPolicy.keyFn
					end
				end

				if type(read) == "function" then
					fieldPolicy.read = read
				end

				setMerge(fieldPolicy, merge) -- inferred equivalent call
			end

			if fieldPolicy.read and fieldPolicy.merge then
				fieldPolicy.keyFn = fieldPolicy.keyFn or simpleKeyArgsFn
			end
		end)
	end
end

function class:setRootTypename(value: string, p: string?)
	if p == nil then
		p = value
	end

	local v = "ROOT_" .. string.upper(value)
	local rootTypename = self.rootTypenamesById[v]

	if p ~= rootTypename then
		local v2 = not rootTypename or rootTypename == value

		if not v2 then
			invariant2(v2, ("Cannot change root %s __typename more than once"):format(value))
		end

		if rootTypename then
			self.rootIdsByTypename[rootTypename] = nil
		end

		self.rootIdsByTypename[p] = v

		self.rootTypenamesById[v] = p
	end
end

function class:addPossibleTypes(p)
	self.usingPossibleTypes = true

	objectKeysForEach(p, function(p2)
		self:getSupertypeSet(p2, true)

		Array.forEach(p[p2], function(p3)
			self:getSupertypeSet(p3, true):add(p2)

			local v = typeOrFieldNameRegExp:exec(p3)

			if not v or v[1] ~= p3 then
				self.fuzzySubtypes:set(p3, LuauRegExp.new(p3))
			end
		end)
	end)
end

function class:getTypePolicy(p: string)
	if not hasOwnProperty(self.typePolicies, p) then
		self.typePolicies[p] = {}

		local typePolicy = self.typePolicies[p]
		typePolicy.fields = {}

		local v = self.supertypeMap:get(p)

		if v and v.size > 0 then
			v:forEach(function(p2)
				local typePolicy2 = self:getTypePolicy(p2)

				local fields = typePolicy2.fields
				local v2 = Object.assign(table.clone(typePolicy2), { fields = Object.None })

				Object.assign(typePolicy, v2)
				Object.assign(typePolicy.fields, fields)
			end)
		end
	end

	local v = self.toBeAdded[p]

	if v and #v > 0 then
		Array.forEach(Array.splice(v, 1), function(p2)
			self:updateTypePolicy(p, p2)
		end)
	end

	return self.typePolicies[p]
end

function class:getFieldPolicy(p: string?, p2: string, flag: boolean)
	if not p then
		return nil
	end

	local fields = self:getTypePolicy(p).fields

	if fields[p2] then
		return fields[p2]
	end

	if not flag then
		return nil
	end

	fields[p2] = {}
	return fields[p2]
end

function class:getSupertypeSet(p: string, flag: boolean)
	local supertypeSet = self.supertypeMap:get(p)

	if not supertypeSet and flag then
		supertypeSet = Set.new()
		self.supertypeMap:set(p, supertypeSet)
	end

	return supertypeSet
end

function class:fragmentMatches(p, p2: string?, p3, p4): boolean
	if not p.typeCondition then
		return true
	end

	if not p2 then
		return false
	end

	local value = p.typeCondition.name.value

	if p2 == value then
		return true
	end

	if not (self.usingPossibleTypes and self.supertypeMap:has(value)) then
		return false
	end

	local supertypeSet = self:getSupertypeSet(p2, true)
	local supertypeSets = { supertypeSet }
	local function maybeEnqueue(item: string) -- 1 equivalent call inferred from this helper
		local supertypeSet2 = self:getSupertypeSet(item, false)

		if supertypeSet2 and supertypeSet2.size > 0 and Array.indexOf(supertypeSets, supertypeSet2) < 1 then
			table.insert(supertypeSets, supertypeSet2)
		end
	end

	local v

	if p3 == nil then
		v = false
	else
		v = self.fuzzySubtypes.size > 0
	end

	local flag = false

	for k, _ in supertypeSets do
		local v2 = supertypeSets[k]

		if v2:has(value) then
			if not supertypeSet:has(value) then
				if flag then
					invariant2.warn(("Inferring subtype %s of supertype %s"):format(p2, value))
				end

				supertypeSet:add(value)
			end

			return true
		end

		v2:forEach(maybeEnqueue)

		if v and k == #supertypeSets and selectionSetMatchesResult(p.selectionSet, p3, p4) then
			Array.forEach(self.fuzzySubtypes:entries(), function(list): number
				local item = list[2]
				local item2 = list[1]

				local v3 = item:exec(p2)

				if v3 and v3[1] == p2 then
					maybeEnqueue(item2) -- inferred equivalent call
				end

				return 1
			end)
			flag = true
			v = false
		end
	end

	return false
end

function class:hasKeyArgs(p: string?, p2: string): boolean
	local fieldPolicy = self:getFieldPolicy(p, p2, false)

	return fieldPolicy ~= nil and fieldPolicy.keyFn ~= nil
end

function class:getStoreFieldName(data)
	local typename = data.typename
	local fieldName = data.fieldName
	local fieldPolicy = self:getFieldPolicy(typename, fieldName, false)
	local v = nil
	local v2

	if fieldPolicy then
		v2 = fieldPolicy.keyFn
	end

	if v2 and typename then
		local v3 = {
			typename = typename,
			fieldName = fieldName,
			field = data.field or nil,
			variables = data.variables
		}
		local v4 = argsFromFieldSpecifier(data) -- inferred equivalent call

		while v2 do
			local v5 = v2(v4, v3)

			if type(v5) == "table" then
				v2 = keyArgsFnFromSpecifier(v5)
			else
				v = v5 or fieldName
				break
			end
		end
	end

	if v == nil then
		if data.field then
			v = storeKeyNameFromField(data.field, data.variables)
		else
			v = getStoreKeyName(fieldName, argsFromFieldSpecifier(data)) -- inferred equivalent call
		end
	end

	if v == false then
		return fieldName
	end

	if fieldName == fieldNameFromStoreName(v) then
		return v
	end

	return fieldName .. ":" .. v
end

function class:readField(state, p)
	local from = state.from

	if not (from and (state.field or state.fieldName)) then
		return
	end

	local typename = state.typename == nil and p.store:getFieldValue(from, "__typename")

	if typename then
		state.typename = typename
	end

	local storeFieldName = self:getStoreFieldName(state)
	local v = fieldNameFromStoreName(storeFieldName)
	local fieldValue = p.store:getFieldValue(from, storeFieldName)
	local fieldPolicy = self:getFieldPolicy(state.typename, v, false)
	local read

	if fieldPolicy then
		read = fieldPolicy.read
	end

	if not read then
		return fieldValue
	end

	local v2 = makeFieldFunctionOptions

	local store = p.store

	local v3 = if from.__ref then from.__ref else from
	local v4 = { fieldValue, (v2(self, from, state, p, store:getStorage(v3, storeFieldName))) }
	return (cacheSlot:withValue(self.cache, read, v4))
end

function class:getMergeFunction(p: string?, p2: string, p3: string?)
	local fieldPolicy = self:getFieldPolicy(p, p2, false)

	local v = fieldPolicy and fieldPolicy.merge

	if not v and p3 then
		v = self:getTypePolicy(p3)

		if v then
			return v.merge
		end
	end

	return v
end

function class.runMergeFunction(p, p2, p3, data, data2, options)
	local field = data.field
	local typename = data.typename
	local merge = data.merge

	if merge == mergeTrueFn then
		return makeMergeObjectsFunction(data2.store)(data, p2, p3)
	end

	if merge == mergeFalseFn then
		return p3
	end

	if data2.overwrite then
		p2 = nil
	end

	return merge(
		data,
		p2,
		p3,
		makeFieldFunctionOptions(
			p,
			nil,
			{
				typename = typename,
				fieldName = field.name.value,
				field = field,
				variables = data2.variables
			},
			data2,
			options or {}
		)
	)
end

Policies.Policies = class

makeFieldFunctionOptions = function(object, from, data, data2, storage)
	local storeFieldName = object:getStoreFieldName(data)
	local fieldName = fieldNameFromStoreName(storeFieldName)

	local variables = data.variables or data2.variables

	return {
		args = argsFromFieldSpecifier(data), -- inferred equivalent call
		field = data.field or nil,
		fieldName = fieldName,
		storeFieldName = storeFieldName,
		variables = variables,
		isReference = function(_, ...)
			return isReference(...)
		end,
		toReference = data2.store.toReference,
		storage = storage,
		cache = object.cache,
		canRead = data2.store.canRead,
		readField = function(self, fieldName2, ...)
			local typeName = type(fieldName2)
			local v

			if typeName == "table" then
				v = Object.assign(
					table.clone(fieldName2),
					fieldName2.from == Object.None and { from = "<Object.None>" } or nil
				)
			else
				v = fieldName2
			end

			local v2 = { v, select("#", ...) >= 1 and "<nil>" or nil }
			local v3

			if typeName == "string" then
				v3 = { fieldName = fieldName2, from = 0 }
				local from2

				if select("#", ...) >= 1 then
					from2 = ...
				else
					from2 = from
				end

				v3.from = from2
			else
				if typeName ~= "table" then
					invariant2.warn(("Unexpected readField arguments: %s"):format(stringifyForDisplay(Array.from(v2))))

					return
				end

				v3 = Object.assign({}, fieldName2)

				if not hasOwnProperty(fieldName2, "from") then
					v3.from = from
				end
			end

			if _G.__DEV__ and v3.from == nil then
				invariant2.warn(("Undefined 'from' passed to readField with arguments %s"):format(stringifyForDisplay(Array.from(v2))))
			end

			if v3.variables == nil then
				v3.variables = variables
			end

			return object:readField(v3, data2)
		end,
		mergeObjects = makeMergeObjectsFunction(data2.store)
	}
end

makeMergeObjectsFunction = function(store)
	return function(_, p, p2)
		if Array.isArray(p) or Array.isArray(p2) then
			error(invariantError.new("Cannot automatically merge arrays"))
		end

		if not (isNonNullObject(p) and isNonNullObject(p2)) then
			return p2
		end

		local fieldValue = store:getFieldValue(p, "__typename")
		local fieldValue2 = store:getFieldValue(p2, "__typename")
		local v

		if fieldValue == nil or fieldValue2 == nil then
			v = false
		else
			v = fieldValue ~= fieldValue2
		end

		if v then
			return p2
		end

		if isReference(p) and storeValueIsStoreObject(p2) then
			store:merge(p.__ref, p2)
			return p
		end

		if storeValueIsStoreObject(p) and isReference(p2) then
			store:merge(p, p2.__ref)
			return p2
		elseif storeValueIsStoreObject(p) and storeValueIsStoreObject(p2) then
			return Object.assign({}, p, p2)
		end

		return p2
	end
end

local function keyObjEncode(p, list)
	assert(typeof(list) == "table", "specifier must be an array")

	if next(list) then
		return "{" .. Array.join(Array.filter(Array.map(list, function(p2, p3)
			if Array.isArray(p2) or not p[p2] then
				return ""
			end

			if not (p3 < #list) then
				return HttpService:JSONEncode(p2) .. ":" .. HttpService:JSONEncode(p[p2])
			end

			local v

			if Array.isArray(list[p3 + 1]) then
				v = keyObjEncode(p[p2], list[p3 + 1])
			else
				v = HttpService:JSONEncode(p[p2])
			end

			return HttpService:JSONEncode(p2) .. ":" .. v
		end), function(p2): boolean
			return p2 ~= ""
		end), ",") .. "}"
	end

	return "[]"
end

keyArgsFnFromSpecifier = function(p)
	return function(p2, p3)
		if p2 then
			return ("%s:%s"):format(p3.fieldName, (keyObjEncode(computeKeyObject(p2, p, false), p)))
		end

		return p3.fieldName
	end
end

keyFieldsFnFromSpecifier = function(p)
	local v = trie2.new(canUseWeakMap)
	return function(_, p2, state)
		local aliasMap

		if state.selectionSet and state.fragmentMap then
			local array = v:lookupArray({ state.selectionSet, state.fragmentMap })

			if not array.aliasMap then
				array.aliasMap = makeAliasMap(state.selectionSet, state.fragmentMap)
			end

			aliasMap = array.aliasMap
		end

		state.keyObject = computeKeyObject(p2, p, true, aliasMap)
		local keyObject = state.keyObject

		return ("%s:%s"):format(state.typename or "null", (keyObjEncode(keyObject, p)))
	end
end

makeAliasMap = function(selectionSet, fragmentMap)
	local v = Set.new({ selectionSet })
	local aliasMap = {}

	for _, v2 in v do
		Array.forEach(v2.selections, function(data)
			if isField(data) then
				if data.alias then
					local value = data.alias.value
					local value2 = data.name.value

					if value2 ~= value then
						if not aliasMap.aliases then
							aliasMap.aliases = {}
						end

						local aliases = aliasMap.aliases

						aliases[value2] = value
					end
				end

				if data.selectionSet then
					if not aliasMap.subsets then
						aliasMap.subsets = {}
					end

					local subsets = aliasMap.subsets

					subsets[data.name.value] = makeAliasMap(data.selectionSet, fragmentMap)
				end
			else
				local fragmentFromSelection = getFragmentFromSelection(data, fragmentMap)

				if fragmentFromSelection then
					v:add(fragmentFromSelection.selectionSet)
				end
			end
		end)
	end

	return aliasMap
end

computeKeyObject = function(p, items, flag: boolean, p2)
	local keyObject = {}
	local v = nil

	for _, item in items do
		if type(item) == "table" then
			if type(v) == "string" then
				local subsets = p2 and p2.subsets

				local v2 = subsets and subsets[v]

				keyObject[v] = computeKeyObject(p[v], item, flag, v2)
			end
		else
			local aliases = p2 and p2.aliases
			local v2

			if aliases and aliases[item] then
				v2 = aliases[item]
			else
				v2 = item
			end

			if hasOwnProperty(p, v2) then
				keyObject[item] = p[v2]
				v = item
			else
				invariant2(not flag, ("Missing field '%s' while computing key fields"):format(v2))
				v = nil
			end
		end
	end

	return keyObject
end

Policies.None = Object.None

return Policies
