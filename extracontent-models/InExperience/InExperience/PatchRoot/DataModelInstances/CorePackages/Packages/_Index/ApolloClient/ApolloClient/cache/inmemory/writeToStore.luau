local __DEV__ = _G.__DEV__
local t1 = {}
local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local LuauPolyfill = require(ParentParentParent.LuauPolyfill)
local Boolean = LuauPolyfill.Boolean
local Object = LuauPolyfill.Object
local Map = LuauPolyfill.Map
local Set = LuauPolyfill.Set
local Array = LuauPolyfill.Array
local NULL = require(ParentParent.utilities).NULL
local HttpService = game:GetService("HttpService")

require(ParentParentParent.GraphQL)

local invariant = require(ParentParent.jsutils.invariant)
local invariant2 = invariant.invariant
local InvariantError = invariant.InvariantError
local equal = require(ParentParent.jsutils.equal)
local objectKeysForEach = require(ParentParent.luaUtils.objectKeysForEach)
local utilities = require(ParentParent.utilities)
local createFragmentMap = utilities.createFragmentMap
local getFragmentFromSelection = utilities.getFragmentFromSelection
local getDefaultValues = utilities.getDefaultValues
local getFragmentDefinitions = utilities.getFragmentDefinitions
local getOperationDefinition = utilities.getOperationDefinition
local getTypenameFromResult = utilities.getTypenameFromResult
local makeReference = utilities.makeReference
local isField = utilities.isField
local resultKeyNameFromField = utilities.resultKeyNameFromField
local isReference = utilities.isReference
local shouldInclude = utilities.shouldInclude
local cloneDeep = utilities.cloneDeep
local addTypenameToDocument = utilities.addTypenameToDocument

require(script.Parent.types)

local helpers = require(script.Parent.helpers)
local makeProcessedFieldsMerger = helpers.makeProcessedFieldsMerger
local fieldNameFromStoreName = helpers.fieldNameFromStoreName
local storeValueIsStoreObject = helpers.storeValueIsStoreObject

require(script.Parent.entityStore)
require(script.Parent.Parent.core.types.Cache)

local canonicalStringify = require(script.Parent["object-canon"]).canonicalStringify

require(script.Parent.writeToStore_types)

local warnAboutDataLoss = nil
local getChildMergeTree = nil
local maybeRecycleChildMergeTree = nil
local mergeMergeTrees = nil
local mergeTreeIsEmpty = nil
local t2 = {}

t2.__index = t2

function t2.new(p1, p2) -- line: 138
	-- upvalues: t2 (copy)
	local self = setmetatable({}, t2)

	self.cache = p1
	self.reader = p2

	return self
end
function t2.writeToStore(p3, p4, p5) -- line: 145
	-- upvalues: getOperationDefinition (copy), makeProcessedFieldsMerger (copy), Object (copy), getDefaultValues (copy), canonicalStringify (copy), createFragmentMap (copy), getFragmentDefinitions (copy), Map (copy), isReference (copy), InvariantError (copy), HttpService (copy), makeReference (copy), __DEV__ (copy), fieldNameFromStoreName (copy), Set (copy), isField (copy), objectKeysForEach (copy), warnAboutDataLoss (ref)
	local query = p5.query
	local result = p5.result
	local dataId = p5.dataId
	local variables = p5.variables
	local overwrite = p5.overwrite
	local v56 = getOperationDefinition(query)
	local v57 = makeProcessedFieldsMerger()
	local v58 = Object.assign(getDefaultValues(v56), variables)
	local t3 = {
		clientOnly = false,
		store = p4,
		written = {},
		merge = function(p6, p7) -- line: 159
			-- upvalues: v57 (copy)
			return v57:merge(p6, p7)
		end,
		variables = v58,
		varString = canonicalStringify(v58),
		fragmentMap = createFragmentMap(getFragmentDefinitions(query)),
		overwrite = overwrite or false,
		incomingById = Map.new(nil)
	}
	local v60 = p3:processSelectionSet({
		result = result or {},
		dataId = dataId,
		selectionSet = v56.selectionSet,
		mergeTree = {
			map = Map.new(nil)
		},
		context = t3
	})

	if not isReference(v60) then
		error(InvariantError.new(("Could not identify object %s"):format(HttpService:JSONEncode(result))))
	end

	t3.incomingById:forEach(function(p8, p9) -- line: 192
		-- upvalues: makeReference (copy), p3 (copy), t3 (copy), isReference (copy), __DEV__ (copy), fieldNameFromStoreName (copy), Set (copy), isField (copy), objectKeysForEach (copy), warnAboutDataLoss (ref), p4 (copy)
		local fields = p8.fields
		local mergeTree = p8.mergeTree
		local selections = p8.selections
		local v142 = makeReference(p9)

		if mergeTree.map.size > 0 then
			local v143 = p3:applyMerges(mergeTree, v142, fields, t3)

			if isReference(v143) then
				return
			end

			fields = v143
		end

		if __DEV__ and not t3.overwrite then
			local u144 = nil

			local function hasSelectionSet(s1: string) -- line: 215
				-- upvalues: u144 (ref), fieldNameFromStoreName (copy)
				return u144:has(fieldNameFromStoreName(s1))
			end

			u144 = Set.new()
			selections:forEach(function(p10) -- line: 219
				-- upvalues: isField (copy), u144 (ref)
				if isField(p10) and p10.selectionSet then
					u144:add(p10.name.value)
				end
			end)

			local function hasMergeFunction(s2: string) -- line: 227
				-- upvalues: mergeTree (copy)
				local v173 = mergeTree.map:get(s2)

				return v173 ~= nil and (v173.info ~= nil and v173.info.merge ~= nil)
			end

			objectKeysForEach(fields, function(p11) -- line: 233
				-- upvalues: u144 (ref), fieldNameFromStoreName (copy), mergeTree (copy), warnAboutDataLoss (ref), v142 (copy), fields (ref), t3 (copy)
				if u144:has(fieldNameFromStoreName(p11)) then
					local v175 = mergeTree.map:get(p11)

					if v175 == nil or (v175.info == nil or v175.info.merge == nil) then
						warnAboutDataLoss(v142, fields, p11, t3.store)
					end
				end
			end)
		end

		p4:merge(p9, fields)
	end)
	p4:retain(v60.__ref)

	return v60
end
function t2.processSelectionSet(t4: {[any]: any}, t5: {[any]: any}) -- line: 258
	-- upvalues: makeReference (copy), Array (copy), getTypenameFromResult (copy), Set (copy), shouldInclude (copy), isField (copy), resultKeyNameFromField (copy), getChildMergeTree (ref), isReference (copy), maybeRecycleChildMergeTree (ref), addTypenameToDocument (copy), invariant2 (copy), HttpService (copy), getFragmentFromSelection (copy), mergeMergeTrees (ref)
	local dataId = t5.dataId
	local result = t5.result
	local selectionSet = t5.selectionSet
	local context = t5.context
	local mergeTree = t5.mergeTree
	local policies = t4.cache.policies
	local v69, v70 = table.unpack(policies:identify(result, selectionSet, context.fragmentMap), 1, 2)
	local v71 = dataId or v69

	if type(v71) == "string" then
		local v72

		if context.written[v71] ~= nil then
			v72 = context.written[v71]
		else
			v72 = {}
			context.written[v71] = v72
		end

		local v73 = makeReference(v71)

		if Array.indexOf(v72, selectionSet) >= 1 then
			return v73
		end

		table.insert(v72, selectionSet)

		if t4.reader ~= nil and t4.reader:isFresh(result, v73, selectionSet, context) then
			return v73
		end
	end

	local t6 = {}

	if v70 ~= nil then
		t6 = context.merge(t6, v70)
	end

	local v75 = v71 and policies.rootTypenamesById[v71] or (getTypenameFromResult(result, selectionSet, context.fragmentMap) or v71 and context.store:get(v71, "__typename"))

	if type(v75) == "string" then
		t6.__typename = v75
	end

	local v76 = Set.new(selectionSet.selections)

	for _, v78 in v76 do
		if shouldInclude(v78, context.variables) then
			if isField(v78) then
				local v79 = result[resultKeyNameFromField(v78)]
				local clientOnly = context.clientOnly

				context.clientOnly = clientOnly or v78.directives and Array.some(v78.directives, function(p12) -- line: 351
					return p12.name.value == "client"
				end)

				if v79 ~= nil then
					local v81 = policies:getStoreFieldName({
						typename = v75,
						fieldName = v78.name.value,
						field = v78,
						variables = context.variables
					})
					local v82 = getChildMergeTree(mergeTree, v81)
					local v83 = t4:processFieldValue(v79, v78, context, v82)
					local v84 = nil

					if v78.selectionSet ~= nil then
						v84 = context.store:getFieldValue(v83, "__typename")

						if not v84 and isReference(v83) then
							local v85 = context.incomingById:get(v83.__ref)

							v84 = if v85 == nil then nil else v85.fields.__typename
						end
					end

					local v86 = policies:getMergeFunction(v75, v78.name.value, v84)

					if v86 ~= nil then
						v82.info = {
							field = v78,
							typename = v75,
							merge = v86
						}
					else
						maybeRecycleChildMergeTree(mergeTree, v81)
					end

					t6 = context.merge(t6, {
						[v81] = v83
					})
				elseif not context.clientOnly and not addTypenameToDocument:added(v78) then
					invariant2.error((string.sub(("Missing field '%s' while writing result %s"):format(resultKeyNameFromField(v78), HttpService:JSONEncode(result)), 1, 1000)))
				end

				context.clientOnly = clientOnly
			else
				local v87 = getFragmentFromSelection(v78, context.fragmentMap)

				if v87 and policies:fragmentMatches(v87, v75, result, context.variables) then
					Array.forEach(v87.selectionSet.selections, v76.add, v76)
				end
			end
		end
	end

	if type(v71) == "string" then
		local v88 = context.incomingById:get(v71)

		if v88 then
			v88.fields = context.merge(v88.fields, t6)
			v88.mergeTree = mergeMergeTrees(v88.mergeTree, mergeTree)
			v88.selections:forEach(v76.add, v76)
			v88.selections = v76
		else
			context.incomingById:set(v71, {
				fields = t6,
				mergeTree = mergeTree,
				selections = v76
			})
		end

		return makeReference(v71)
	end

	return t6
end
function t2.processFieldValue(p13, p14, p15, p16, p17) -- line: 497
	-- upvalues: NULL (copy), __DEV__ (copy), cloneDeep (copy), Array (copy), getChildMergeTree (ref), maybeRecycleChildMergeTree (ref)
	if not p15.selectionSet or p14 == NULL then
		if __DEV__ then
			return cloneDeep(p14)
		end

		return p14
	end

	if Array.isArray(p14) then
		return Array.map(p14, function(p18, p19) -- line: 517
			-- upvalues: p13 (copy), p15 (copy), p16 (copy), getChildMergeTree (ref), p17 (copy), maybeRecycleChildMergeTree (ref)
			local v150 = p13:processFieldValue(p18, p15, p16, getChildMergeTree(p17, p19))

			maybeRecycleChildMergeTree(p17, p19)

			return v150
		end)
	end

	return p13:processSelectionSet({
		result = p14,
		selectionSet = p15.selectionSet,
		context = p16,
		mergeTree = p17
	})
end
function t2.applyMerges(p20, p21, p22, p23, p24, p25) -- line: 532
	-- upvalues: isReference (copy), Array (copy), storeValueIsStoreObject (copy), Map (copy), invariant2 (copy), Boolean (copy)
	if p21.map.size > 0 and not isReference(p23) then
		local v102 = if not (not Array.isArray(p23) and (isReference(p22) or storeValueIsStoreObject(p22))) then nil else p22
		local v103 = p23

		if v102 ~= nil and not p25 then
			p25 = if not isReference(v102) then { v102 } else { v102.__ref }
		end

		local u104 = nil

		local function getValue(p26, p27) -- line: 590
			-- upvalues: Array (copy), p24 (copy)
			if Array.isArray(p26) then
				if typeof(p27) == "number" then
					return p26[p27]
				end

				return nil
			end

			return p24.store:getFieldValue(p26, (tostring(p27)))
		end

		p21.map:forEach(function(p28, p29) -- line: 602
			-- upvalues: v102 (copy), Array (copy), p24 (copy), v103 (copy), p25 (ref), p20 (copy), u104 (ref), Map (copy), invariant2 (copy)
			local v155 = v102
			local v156 = if not Array.isArray(v155) then p24.store:getFieldValue(v155, (tostring(p29))) else if typeof(p29) ~= "number" then nil else v155[p29]
			local v157 = v103
			local v158 = if not Array.isArray(v157) then p24.store:getFieldValue(v157, (tostring(p29))) else if typeof(p29) ~= "number" then nil else v157[p29]

			if v158 == nil then
				return
			end

			if p25 ~= nil then
				table.insert(p25, p29)
			end

			local v159 = p20:applyMerges(p28, v156, v158, p24, p25)

			if v159 ~= v158 then
				u104 = u104 or Map.new(nil)
				u104:set(p29, v159)
			end

			if p25 ~= nil then
				invariant2(p29 == table.remove(p25, #p25))
			end
		end)

		if u104 ~= nil then
			p23 = table.clone(v103)
			u104:forEach(function(p30, p31) -- line: 631
				-- upvalues: p23 (ref)
				p23[p31] = p30
			end)
		end
	end

	if p21.info then
		return p20.cache.policies:runMergeFunction(p22, p23, p21.info, p24, Boolean.toJSBoolean(p25) and p24.store:getStorage(table.unpack(p25)) or nil)
	end

	return p23
end

t1.StoreWriter = t2

local t7 = {}

function getChildMergeTree(p32, p33) -- line: 656
	-- upvalues: t7 (copy), Map (copy)
	local map = p32.map

	if not map:has(p33) then
		map:set(p33, table.remove(t7, #t7) or {
			map = Map.new(nil)
		})
	end

	return (map:get(p33))
end
function mergeMergeTrees(p34, p35) -- line: 666
	-- upvalues: mergeTreeIsEmpty (ref), Object (copy), Map (copy), Set (copy), mergeMergeTrees (ref)
	if p34 == p35 or (p35 == nil or mergeTreeIsEmpty(p35)) then
		return p34
	end

	if p34 == nil or mergeTreeIsEmpty(p34) then
		return p35
	end

	local v111 = if not p34.info or not p35.info then p34.info or p35.info else Object.assign(table.clone(p34.info), p35.info)
	local v112 = if not (p34.map.size > 0) then p34.map.size else p35.map.size
	local v113 = if not (v112 > 0) then if not (p34.map.size > 0) then p35.map else p34.map else Map.new()
	local t8 = {
		info = v111,
		map = v113
	}

	if v112 > 0 then
		local v115 = Set.new(p35.map:keys())

		p34.map:forEach(function(p36, p37) -- line: 696
			-- upvalues: t8 (copy), mergeMergeTrees (ref), p35 (copy), v115 (copy)
			t8.map:set(p37, mergeMergeTrees(p36, p35.map:get(p37)))
			v115:delete(p37)
		end)
		v115:forEach(function(p38) -- line: 701
			-- upvalues: t8 (copy), mergeMergeTrees (ref), p35 (copy), p34 (copy)
			t8.map:set(p38, mergeMergeTrees(p35.map:get(p38), p34.map:get(p38)))
		end)
	end

	return t8
end
function mergeTreeIsEmpty(p39) -- line: 712
	return not p39 or not (p39.info or p39.map.size > 0)
end
function maybeRecycleChildMergeTree(p40, p41) -- line: 718
	-- upvalues: mergeTreeIsEmpty (ref), t7 (copy)
	local map = p40.map
	local v120 = map:get(p41)

	if v120 ~= nil and mergeTreeIsEmpty(v120) then
		table.insert(t7, v120)
		map:delete(p41)
	end
end

local v44 = Set.new()

function warnAboutDataLoss(p42, p43, s3: string, p44) -- line: 733
	-- upvalues: isReference (copy), equal (copy), Array (copy), Object (copy), Boolean (copy), fieldNameFromStoreName (copy), v44 (copy), invariant2 (copy), HttpService (copy)
	local function getChild(p45) -- line: 740
		-- upvalues: p44 (copy), s3 (copy)
		local v166 = p44:getFieldValue(p45, s3)

		return typeof(v166) == "table" and v166
	end

	local v126 = p44:getFieldValue(p42, s3)
	local v127 = typeof(v126) == "table" and v126

	if not v127 then
		return
	end

	local v128 = p44:getFieldValue(p43, s3)
	local v129 = typeof(v128) == "table" and v128

	if not v129 then
		return
	end

	if isReference(v127) then
		return
	end

	if equal(v127, v129) then
		return
	end

	if Array.every(Object.keys(v127), function(p46) -- line: 771
		-- upvalues: p44 (copy), v129 (copy)
		return p44:getFieldValue(v129, p46) ~= nil
	end) then
		return
	end

	local v130 = p44:getFieldValue(p42, "__typename")
	local v131 = Boolean.toJSBoolean(v130) and v130 or p44:getFieldValue(p43, "__typename")
	local v132 = fieldNameFromStoreName(s3)
	local v133 = ("%s.%s"):format(v131, v132)

	if v44:has(v133) then
		return
	end

	v44:add(v133)

	local t9 = {}

	if not Array.isArray(v127) and not Array.isArray(v129) then
		Array.forEach({
			v127,
			v129
		}, function(p47) -- line: 794
			-- upvalues: p44 (copy), Array (copy), t9 (copy)
			local v169 = p44:getFieldValue(p47, "__typename")

			if typeof(v169) == "string" and not Array.includes(t9, v169) then
				table.insert(t9, v169)
			end
		end)
	end

	invariant2.warn(("Cache data may be lost when replacing the %s field of a %s object.\n\n\tTo address this problem (which is not a bug in Apollo Client), %sdefine a custom merge function for the %s field, so InMemoryCache can safely merge these objects:\n\n\t  existing: %s\n\t  incoming: %s\n\n\tFor more information about these options, please refer to the documentation:\n\n\t  * Ensuring entity objects have IDs: https://go.apollo.dev/c/generating-unique-identifiers\n\t  * Defining custom merge functions: https://go.apollo.dev/c/merging-non-normalized-objects\n\t"):format(v132, v131, not Boolean.toJSBoolean(#t9) and "" or "either ensure all objects of type " .. Array.join(t9, " and ") .. " have an ID or a custom merge function, or ", v133, string.sub(HttpService:JSONEncode(v127), 1, 1000), (string.sub(HttpService:JSONEncode(v129), 1, 1000))))
end

return t1
