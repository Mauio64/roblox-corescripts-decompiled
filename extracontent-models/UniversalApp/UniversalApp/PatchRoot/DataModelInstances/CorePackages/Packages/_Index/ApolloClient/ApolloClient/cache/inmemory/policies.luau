local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local HttpService = game:GetService("HttpService")
local LuauPolyfill = require(ParentParentParent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Object = LuauPolyfill.Object
local Set = LuauPolyfill.Set
local Map = LuauPolyfill.Map
local isCallable = require(ParentParent.luaUtils.isCallable)
local objectKeysForEach = require(ParentParent.luaUtils.objectKeysForEach)
local LuauRegExp = require(ParentParentParent.LuauRegExp)
local t1 = {}
local makeFieldFunctionOptions = nil
local makeMergeObjectsFunction = nil
local keyArgsFnFromSpecifier = nil
local keyFieldsFnFromSpecifier = nil
local makeAliasMap = nil
local computeKeyObject = nil

require(ParentParentParent.GraphQL)

local Trie = require(ParentParent.wry.trie).Trie
local invariant = require(ParentParent.jsutils.invariant)
local invariant2 = invariant.invariant
local InvariantError = invariant.InvariantError
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
local hasOwnProperty = require(ParentParent.luaUtils.hasOwnProperty)
local fieldNameFromStoreName = helpers.fieldNameFromStoreName
local storeValueIsStoreObject = helpers.storeValueIsStoreObject
local selectionSetMatchesResult = helpers.selectionSetMatchesResult
local TypeOrFieldNameRegExp = helpers.TypeOrFieldNameRegExp
local cacheSlot = require(script.Parent.reactiveVars).cacheSlot

require(script.Parent.Parent.core.types.common)
require(script.Parent.writeToStore_types)
getStoreKeyName:setStringify(require(script.Parent["object-canon"]).canonicalStringify)
require(script.Parent.policies_types)

local function argsFromFieldSpecifier(p1) -- line: 145
	-- upvalues: argumentsObjectFromField (copy)
	if p1.args ~= nil then
		return p1.args
	end

	if p1.field then
		return (argumentsObjectFromField(p1.field, p1.variables))
	end

	return nil
end
local function defaultDataIdFromObject(_, p3, p4) -- line: 159
	-- upvalues: HttpService (copy)
	local __typename = p3.__typename
	local id = p3.id
	local _id = p3._id

	if type(__typename) == "string" then
		if p4 then
			if id ~= nil then
				p4.keyObject = {
					id = id
				}
			elseif _id ~= nil then
				p4.keyObject = {
					_id = _id
				}
			else
				p4.keyObject = nil
			end
		end

		if id == nil then
			id = _id
		end

		if id ~= nil then
			local v56 = type(id)

			return string.format("%s:%s", __typename, if v56 ~= "number" and v56 ~= "string" then HttpService:JSONEncode(id) else id)
		end
	end

	return nil
end

t1.defaultDataIdFromObject = defaultDataIdFromObject

local function nullKeyFieldsFn(_) -- line: 191
	return nil
end
local function simpleKeyArgsFn(_, p7) -- line: 194
	return p7.fieldName
end
local function mergeTrueFn(_, p9, p10, p11) -- line: 201
	return p11:mergeObjects(p9, p10)
end
local function mergeFalseFn(_, _, p14) -- line: 205
	return p14
end

local t2 = {}

t2.__index = t2

function t2.new(t3: {[any]: any}) -- line: 312
	-- upvalues: t2 (copy), Map (copy), Object (copy), defaultDataIdFromObject (copy)
	local self = setmetatable({}, t2)

	self.typePolicies = {}
	self.toBeAdded = {}
	self.supertypeMap = Map.new(nil)
	self.fuzzySubtypes = Map.new(nil)
	self.cache = nil
	self.rootIdsByTypename = {}
	self.rootTypenamesById = {}
	self.usingPossibleTypes = false
	self.config = t3
	self.config = Object.assign({
		dataIdFromObject = defaultDataIdFromObject
	}, t3)
	self.cache = self.config.cache
	self:setRootTypename("Query")
	self:setRootTypename("Mutation")
	self:setRootTypename("Subscription")

	if t3.possibleTypes then
		self:addPossibleTypes(t3.possibleTypes)
	end

	if t3.typePolicies then
		self:addTypePolicies(t3.typePolicies)
	end

	return self
end
function t2.identify(p15, p16, p17, p18) -- line: 353
	-- upvalues: getTypenameFromResult (copy), keyFieldsFnFromSpecifier (ref)
	local v73 = if not p17 or not p18 then p16.__typename else getTypenameFromResult(p16, p17, p18)

	if v73 == p15.rootTypenamesById.ROOT_QUERY then
		return { "ROOT_QUERY" }
	end

	local t4 = {
		typename = v73,
		selectionSet = p17,
		fragmentMap = p18
	}
	local v75 = nil
	local v76 = v73 and p15:getTypePolicy(v73)
	local v77 = if not v76 or not v76.keyFn then p15.config.dataIdFromObject else v76.keyFn

	while v77 do
		local v78 = v77(v76, p16, t4)

		if type(v78) ~= "table" then
			v75 = v78

			break
		end

		v77 = keyFieldsFnFromSpecifier(v78)
	end

	local v79 = if not v75 then nil else tostring(v75)

	if t4.keyObject then
		return {
			v79,
			t4.keyObject
		}
	end

	return { v79 }
end
function t2.addTypePolicies(p19, p20) -- line: 425
	-- upvalues: objectKeysForEach (copy), Object (copy), hasOwnProperty (copy)
	objectKeysForEach(p20, function(p21) -- line: 427
		-- upvalues: p20 (copy), Object (copy), p19 (copy), hasOwnProperty (copy)
		local v200 = p20[p21]
		local queryType = v200.queryType
		local mutationType = v200.mutationType
		local subscriptionType = v200.subscriptionType
		local v204 = Object.assign({}, v200, {
			queryType = Object.None,
			mutationType = Object.None,
			subscriptionType = Object.None
		})

		if queryType then
			p19:setRootTypename("Query", p21)
		end

		if mutationType then
			p19:setRootTypename("Mutation", p21)
		end

		if subscriptionType then
			p19:setRootTypename("Subscription", p21)
		end

		if hasOwnProperty(p19.toBeAdded, p21) then
			table.insert(p19.toBeAdded[p21], v204)

			return
		end

		p19.toBeAdded[p21] = { v204 }
	end)
end
function t2.updateTypePolicy(t5: {[any]: any}, s1: string, p22) -- line: 471
	-- upvalues: isCallable (copy), mergeTrueFn (ref), mergeFalseFn (ref), nullKeyFieldsFn (copy), keyFieldsFnFromSpecifier (ref), objectKeysForEach (copy), simpleKeyArgsFn (copy), keyArgsFnFromSpecifier (ref)
	local v85 = t5:getTypePolicy(s1)
	local keyFields = p22.keyFields
	local fields = p22.fields

	local function setMerge(t6: {[any]: any}, p23) -- line: 475
		-- upvalues: isCallable (copy), mergeTrueFn (ref), mergeFalseFn (ref)
		if isCallable(p23) then
			t6.merge = p23

			return
		end

		if p23 == true then
			t6.merge = mergeTrueFn

			return
		end

		if p23 == false then
			t6.merge = mergeFalseFn

			return
		end

		t6.merge = t6.merge
	end

	local merge = p22.merge

	if isCallable(merge) then
		v85.merge = merge
	elseif merge == true then
		v85.merge = mergeTrueFn
	elseif merge == false then
		v85.merge = mergeFalseFn
	else
		v85.merge = v85.merge
	end

	if keyFields == false then
		v85.keyFn = nullKeyFieldsFn
	else
		local v90 = type(keyFields)

		if v90 == "table" then
			v85.keyFn = keyFieldsFnFromSpecifier(keyFields)
		elseif v90 == "function" then
			v85.keyFn = keyFields
		else
			v85.keyFn = v85.keyFn
		end
	end

	if fields then
		objectKeysForEach(fields, function(p24) -- line: 530
			-- upvalues: t5 (copy), s1 (copy), fields (copy), simpleKeyArgsFn (copy), keyArgsFnFromSpecifier (ref), isCallable (copy), mergeTrueFn (ref), mergeFalseFn (ref)
			local v208 = t5:getFieldPolicy(s1, p24, true)
			local v209 = fields[p24]

			if type(v209) == "function" then
				v208.read = v209
			else
				local keyArgs = v209.keyArgs
				local read = v209.read
				local merge2 = v209.merge

				if keyArgs == false then
					v208.keyFn = simpleKeyArgsFn
				else
					local v213 = type(keyArgs)

					if v213 == "table" then
						v208.keyFn = keyArgsFnFromSpecifier(keyArgs)
					elseif v213 == "function" then
						v208.keyFn = keyArgs
					else
						v208.keyFn = v208.keyFn
					end
				end

				if type(read) == "function" then
					v208.read = read
				end

				if isCallable(merge2) then
					v208.merge = merge2
				elseif merge2 == true then
					v208.merge = mergeTrueFn
				elseif merge2 == false then
					v208.merge = mergeFalseFn
				else
					v208.merge = v208.merge
				end
			end

			if v208.read and v208.merge then
				v208.keyFn = v208.keyFn or simpleKeyArgsFn
			end
		end)
	end
end
function t2.setRootTypename(t7: {[any]: any}, s2: string, s3: string?) -- line: 588
	-- upvalues: invariant2 (copy)
	if s3 == nil then
		s3 = s2
	end

	local v94 = "ROOT_" .. string.upper(s2)
	local v95 = t7.rootTypenamesById[v94]

	if s3 ~= v95 then
		local v96 = not v95 or v95 == s2

		if not v96 then
			invariant2(v96, ("Cannot change root %s __typename more than once"):format(s2))
		end

		if v95 then
			t7.rootIdsByTypename[v95] = nil
		end

		t7.rootIdsByTypename[s3] = v94
		t7.rootTypenamesById[v94] = s3
	end
end
function t2.addPossibleTypes(t8: {[any]: any}, t9: {[any]: any}) -- line: 617
	-- upvalues: objectKeysForEach (copy), Array (copy), TypeOrFieldNameRegExp (copy), LuauRegExp (copy)
	t8.usingPossibleTypes = true
	objectKeysForEach(t9, function(p25) -- line: 620
		-- upvalues: t8 (copy), Array (copy), t9 (copy), TypeOrFieldNameRegExp (copy), LuauRegExp (copy)
		t8:getSupertypeSet(p25, true)
		Array.forEach(t9[p25], function(p26) -- line: 627
			-- upvalues: t8 (copy), p25 (copy), TypeOrFieldNameRegExp (copy), LuauRegExp (copy)
			t8:getSupertypeSet(p26, true):add(p25)

			local v257 = TypeOrFieldNameRegExp:exec(p26)

			if not v257 or p26 ~= v257[1] then
				t8.fuzzySubtypes:set(p26, LuauRegExp.new(p26))
			end
		end)
	end)
end
function t2.getTypePolicy(t10: {[any]: any}, s4: string) -- line: 639
	-- upvalues: hasOwnProperty (copy), Object (copy), Array (copy)
	if not hasOwnProperty(t10.typePolicies, s4) then
		t10.typePolicies[s4] = {}

		local v101 = t10.typePolicies[s4]

		v101.fields = {}

		local v102 = t10.supertypeMap:get(s4)

		if v102 and v102.size > 0 then
			v102:forEach(function(p27) -- line: 673
				-- upvalues: t10 (copy), Object (copy), v101 (copy)
				local v216 = t10:getTypePolicy(p27)
				local fields = v216.fields
				local v218 = Object.assign(table.clone(v216), {
					fields = Object.None
				})

				Object.assign(v101, v218)
				Object.assign(v101.fields, fields)
			end)
		end
	end

	local v103 = t10.toBeAdded[s4]

	if v103 and #v103 > 0 then
		Array.forEach(Array.splice(v103, 1), function(p28) -- line: 690
			-- upvalues: t10 (copy), s4 (copy)
			t10:updateTypePolicy(s4, p28)
		end)
	end

	return t10.typePolicies[s4]
end
function t2.getFieldPolicy(t11: {[any]: any}, s5: string?, s6: string, b1: boolean) -- line: 698
	if s5 then
		local fields = t11:getTypePolicy(s5).fields

		if fields[s6] then
			return fields[s6]
		end

		if b1 then
			fields[s6] = {}

			return fields[s6]
		end

		return nil
	end

	return nil
end
function t2.getSupertypeSet(t12: {[any]: any}, s7: string, b2: boolean) -- line: 725
	-- upvalues: Set (copy)
	local v112 = t12.supertypeMap:get(s7)

	if not v112 and b2 then
		v112 = Set.new()
		t12.supertypeMap:set(s7, v112)
	end

	return v112
end
function t2.fragmentMatches(t13: {[any]: any}, p29, s8: string?, t14: {[any]: any}?, t15: {[any]: any}?) -- line: 736
	-- upvalues: Array (copy), invariant2 (copy), selectionSetMatchesResult (copy)
	if not p29.typeCondition then
		return true
	end

	if not s8 then
		return false
	end

	local value = p29.typeCondition.name.value

	if s8 == value then
		return true
	end

	if t13.usingPossibleTypes and t13.supertypeMap:has(value) then
		local v119 = t13:getSupertypeSet(s8, true)
		local t16 = { v119 }

		local function maybeEnqueue(s9: string) -- line: 767
			-- upvalues: t13 (copy), Array (copy), t16 (copy)
			local v221 = t13:getSupertypeSet(s9, false)

			if v221 and (v221.size > 0 and Array.indexOf(t16, v221) < 1) then
				table.insert(t16, v221)
			end
		end

		local v122 = t14 ~= nil and t13.fuzzySubtypes.size > 0
		local v123 = false

		for v124, _ in t16 do
			local v126 = t16[v124]

			if v126:has(value) then
				if not v119:has(value) then
					if v123 then
						invariant2.warn(("Inferring subtype %s of supertype %s"):format(s8, value))
					end

					v119:add(value)
				end

				return true
			end

			v126:forEach(maybeEnqueue)

			if v122 and v124 == #t16 and selectionSetMatchesResult(p29.selectionSet, t14, t15) then
				v122 = false
				v123 = true
				Array.forEach(t13.fuzzySubtypes:entries(), function(p30) -- line: 834
					-- upvalues: s8 (copy), t13 (copy), Array (copy), t16 (copy)
					local v223 = p30[2]
					local v224 = p30[1]
					local v225 = v223:exec(s8)

					if v225 and v225[1] == s8 then
						local v226 = t13:getSupertypeSet(v224, false)

						if v226 and v226.size > 0 and Array.indexOf(t16, v226) < 1 then
							table.insert(t16, v226)
						end
					end

					return 1
				end)
			end
		end
	end

	return false
end
function t2.hasKeyArgs(t17: {[any]: any}, s10: string?, s11: string) -- line: 852
	local v130 = t17:getFieldPolicy(s10, s11, false)

	return v130 ~= nil and v130.keyFn ~= nil
end
function t2.getStoreFieldName(p31, p32) -- line: 859
	-- upvalues: argumentsObjectFromField (copy), keyArgsFnFromSpecifier (ref), storeKeyNameFromField (copy), getStoreKeyName (copy), fieldNameFromStoreName (copy)
	local typename = p32.typename
	local fieldName = p32.fieldName
	local v135 = p31:getFieldPolicy(typename, fieldName, false)
	local v136 = nil
	local v137 = if not v135 then nil else v135.keyFn

	if v137 and typename then
		local t18 = {
			typename = typename,
			fieldName = fieldName,
			field = p32.field or nil,
			variables = p32.variables
		}
		local v139 = if p32.args == nil then if not p32.field then nil else argumentsObjectFromField(p32.field, p32.variables) else p32.args

		while v137 do
			local v140 = v137(v139, t18)

			if type(v140) ~= "table" then
				v136 = v140 or fieldName

				break
			end

			v137 = keyArgsFnFromSpecifier(v140)
		end
	end

	if v136 == nil then
		v136 = if not p32.field then getStoreKeyName(fieldName, if p32.args == nil then if not p32.field then nil else argumentsObjectFromField(p32.field, p32.variables) else p32.args) else storeKeyNameFromField(p32.field, p32.variables)
	end

	if v136 == false then
		return fieldName
	end

	if fieldName == fieldNameFromStoreName(v136) then
		return v136
	end

	return fieldName .. ":" .. v136
end
function t2.readField(t19: {[any]: any}, p33, t20: {[any]: any}) -- line: 930
	-- upvalues: fieldNameFromStoreName (copy), makeFieldFunctionOptions (ref), cacheSlot (copy)
	local from = p33.from

	if not from then
		return
	end

	if not p33.field and not p33.fieldName then
		return
	end

	if p33.typename == nil then
		local v145 = t20.store:getFieldValue(from, "__typename")

		if v145 then
			p33.typename = v145
		end
	end

	local v146 = t19:getStoreFieldName(p33)
	local v147 = fieldNameFromStoreName(v146)
	local v148 = t20.store:getFieldValue(from, v146)
	local v149 = t19:getFieldPolicy(p33.typename, v147, false)
	local v150 = if not v149 then nil else v149.read

	if v150 then
		local v151 = makeFieldFunctionOptions(t19, from, p33, t20, t20.store:getStorage(if not from.__ref then from else from.__ref, v146))

		return (cacheSlot:withValue(t19.cache, v150, {
			v148,
			v151
		}))
	end

	return v148
end
function t2.getMergeFunction(t21: {[any]: any}, s12: string?, s13: string, s14: string?) -- line: 990
	local v156 = t21:getFieldPolicy(s12, s13, false)
	local v157 = v156 and v156.merge

	if not v157 and s14 then
		v157 = t21:getTypePolicy(s14)

		if v157 then
			return v157.merge
		end
	end

	return v157
end
function t2.runMergeFunction(t22: {[any]: any}, p34, p35, t23: {[any]: any}, p36, p37) -- line: 1021
	-- upvalues: mergeTrueFn (ref), makeMergeObjectsFunction (ref), mergeFalseFn (ref), makeFieldFunctionOptions (ref)
	local field = t23.field
	local typename = t23.typename
	local merge = t23.merge

	if merge == mergeTrueFn then
		return makeMergeObjectsFunction(p36.store)(t23, p34, p35)
	end

	if merge == mergeFalseFn then
		return p35
	end

	if p36.overwrite then
		p34 = nil
	end

	return merge(t23, p34, p35, makeFieldFunctionOptions(t22, nil, {
		typename = typename,
		fieldName = field.name.value,
		field = field,
		variables = p36.variables
	}, p36, p37 or {}))
end

t1.Policies = t2

function makeFieldFunctionOptions(t24: {[any]: any}, p38, p39, t25: {[any]: any}, p40) -- line: 1081
	-- upvalues: fieldNameFromStoreName (copy), argumentsObjectFromField (copy), isReference (copy), Object (copy), hasOwnProperty (copy), invariant2 (copy), stringifyForDisplay (copy), Array (copy), makeMergeObjectsFunction (ref)
	local v172 = t24:getStoreFieldName(p39)
	local v173 = fieldNameFromStoreName(v172)
	local v174 = p39.variables or t25.variables

	return {
		args = if p39.args == nil then if not p39.field then nil else argumentsObjectFromField(p39.field, p39.variables) else p39.args,
		field = p39.field or nil,
		fieldName = v173,
		storeFieldName = v172,
		variables = v174,
		isReference = function(_, ...) -- line: 1101
			-- upvalues: isReference (copy)
			return isReference(...)
		end,
		toReference = t25.store.toReference,
		storage = p40,
		cache = t24.cache,
		canRead = t25.store.canRead,
		readField = function(_, p43, ...) -- line: 1108
			-- upvalues: Object (copy), p38 (copy), hasOwnProperty (copy), invariant2 (copy), stringifyForDisplay (copy), Array (copy), v174 (copy), t24 (copy), t25 (copy)
			local v230 = type(p43)
			local t26 = {
				if v230 ~= "table" then p43 else Object.assign(table.clone(p43), if p43.from ~= Object.None then nil else {
					from = "<Object.None>"
				}),
				if not (select("#", ...) >= 1) then nil else "<nil>"
			}
			local t27

			if v230 == "string" then
				t27 = {
					fieldName = p43,
					from = if not (select("#", ...) >= 1) then p38 else ...
				}
			else
				if v230 ~= "table" then
					invariant2.warn(("Unexpected readField arguments: %s"):format(stringifyForDisplay(Array.from(t26))))

					return
				end

				t27 = Object.assign({}, p43)

				if not hasOwnProperty(p43, "from") then
					t27.from = p38
				end
			end

			if _G.__DEV__ and t27.from == nil then
				invariant2.warn(("Undefined 'from' passed to readField with arguments %s"):format(stringifyForDisplay(Array.from(t26))))
			end

			if t27.variables == nil then
				t27.variables = v174
			end

			return t24:readField(t27, t25)
		end,
		mergeObjects = makeMergeObjectsFunction(t25.store)
	}
end
function makeMergeObjectsFunction(t28: {[any]: any}) -- line: 1175
	-- upvalues: Array (copy), InvariantError (copy), isNonNullObject (copy), isReference (copy), storeValueIsStoreObject (copy), Object (copy)
	return function(_, p45, p46) -- line: 1176
		-- upvalues: Array (copy), InvariantError (copy), isNonNullObject (copy), t28 (copy), isReference (copy), storeValueIsStoreObject (copy), Object (copy)
		if Array.isArray(p45) or Array.isArray(p46) then
			error(InvariantError.new("Cannot automatically merge arrays"))
		end

		if isNonNullObject(p45) and isNonNullObject(p46) then
			local v236 = t28:getFieldValue(p45, "__typename")
			local v237 = t28:getFieldValue(p46, "__typename")

			if v236 ~= nil and (v237 ~= nil and v236 ~= v237) then
				return p46
			end

			if isReference(p45) and storeValueIsStoreObject(p46) then
				t28:merge(p45.__ref, p46)

				return p45
			end

			if storeValueIsStoreObject(p45) and isReference(p46) then
				t28:merge(p45, p46.__ref)

				return p46
			end

			if storeValueIsStoreObject(p45) and storeValueIsStoreObject(p46) then
				return Object.assign({}, p45, p46)
			end
		end

		return p46
	end
end

local function keyObjEncode(t29: {[any]: any}, t30: {[any]: any}) -- line: 1226
	-- upvalues: Array (copy), keyObjEncode (copy), HttpService (copy)
	assert(typeof(t30) == "table", "specifier must be an array")

	if not next(t30) then
		return "[]"
	end

	return "{" .. Array.join(Array.filter(Array.map(t30, function(p47, p48) -- line: 1236
		-- upvalues: Array (copy), t29 (copy), t30 (copy), keyObjEncode (copy), HttpService (copy)
		if Array.isArray(p47) then
			return ""
		end

		if not t29[p47] then
			return ""
		end

		if p48 < #t30 then
			local v240 = if not Array.isArray(t30[p48 + 1]) then HttpService:JSONEncode(t29[p47]) else keyObjEncode(t29[p47], t30[p48 + 1])

			return HttpService:JSONEncode(p47) .. ":" .. v240
		end

		return HttpService:JSONEncode(p47) .. ":" .. HttpService:JSONEncode(t29[p47])
	end), function(p49) -- line: 1259
		return p49 ~= ""
	end), ",") .. "}"
end

function keyArgsFnFromSpecifier(p50) -- line: 1268
	-- upvalues: keyObjEncode (copy), computeKeyObject (ref)
	return function(p51, p52) -- line: 1269
		-- upvalues: keyObjEncode (copy), computeKeyObject (ref), p50 (copy)
		if p51 then
			return ("%s:%s"):format(p52.fieldName, (keyObjEncode(computeKeyObject(p51, p50, false), p50)))
		end

		return p52.fieldName
	end
end
function keyFieldsFnFromSpecifier(p53) -- line: 1281
	-- upvalues: Trie (copy), canUseWeakMap (copy), makeAliasMap (ref), computeKeyObject (ref), keyObjEncode (copy)
	local v180 = Trie.new(canUseWeakMap)

	return function(_, p55, p56) -- line: 1283
		-- upvalues: v180 (copy), makeAliasMap (ref), computeKeyObject (ref), p53 (copy), keyObjEncode (copy)
		local aliasMap = nil

		if p56.selectionSet and p56.fragmentMap then
			local v248 = v180:lookupArray({
				p56.selectionSet,
				p56.fragmentMap
			})

			if v248.aliasMap then
				aliasMap = v248.aliasMap
			else
				v248.aliasMap = makeAliasMap(p56.selectionSet, p56.fragmentMap)
				aliasMap = v248.aliasMap
			end
		end

		p56.keyObject = computeKeyObject(p55, p53, true, aliasMap)

		local keyObject = p56.keyObject

		return ("%s:%s"):format(p56.typename or "null", (keyObjEncode(keyObject, p53)))
	end
end
function makeAliasMap(p57, p58) -- line: 1311
	-- upvalues: Set (copy), Array (copy), isField (copy), makeAliasMap (ref), getFragmentFromSelection (copy)
	local t31 = {}
	local v184 = Set.new({ p57 })

	for _, v186 in v184 do
		Array.forEach(v186.selections, function(p59) -- line: 1316
			-- upvalues: isField (copy), t31 (copy), makeAliasMap (ref), p58 (copy), getFragmentFromSelection (copy), v184 (copy)
			if isField(p59) then
				if p59.alias then
					local value = p59.alias.value
					local value2 = p59.name.value

					if value2 ~= value then
						local aliases

						if t31.aliases then
							aliases = t31.aliases
						else
							t31.aliases = {}
							aliases = t31.aliases
						end

						aliases[value2] = value
					end
				end

				if p59.selectionSet then
					local subsets

					if t31.subsets then
						subsets = t31.subsets
					else
						t31.subsets = {}
						subsets = t31.subsets
					end

					subsets[p59.name.value] = makeAliasMap(p59.selectionSet, p58)

					return
				end
			else
				local v255 = getFragmentFromSelection(p59, p58)

				if v255 then
					v184:add(v255.selectionSet)
				end
			end
		end)
	end

	return t31
end
function computeKeyObject(t32: {[any]: any}, p60, b3: boolean, t33: {[any]: any}?) -- line: 1361
	-- upvalues: computeKeyObject (ref), hasOwnProperty (copy), invariant2 (copy)
	local t34 = {}
	local v192 = nil

	for _, v194 in p60 do
		if type(v194) == "table" then
			if type(v192) == "string" then
				local v195 = t33 and t33.subsets
				local v196 = v195 and v195[v192]

				t34[v192] = computeKeyObject(t32[v192], v194, b3, v196)
			end
		else
			local v197 = t33 and t33.aliases
			local v198 = if not v197 or not v197[v194] then v194 else v197[v194]

			if hasOwnProperty(t32, v198) then
				v192 = v194
				t34[v192] = t32[v198]
			else
				invariant2(not b3, ("Missing field '%s' while computing key fields"):format(v198))
				v192 = nil
			end
		end
	end

	return t34
end

t1.None = Object.None

return t1
