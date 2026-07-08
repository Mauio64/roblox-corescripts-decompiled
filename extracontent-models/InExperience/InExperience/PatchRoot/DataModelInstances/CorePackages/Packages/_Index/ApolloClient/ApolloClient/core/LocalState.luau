local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local LuauPolyfill = require(ParentParentParent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Object = LuauPolyfill.Object
local Boolean = LuauPolyfill.Boolean
local String = LuauPolyfill.String
local Promise = require(ParentParentParent.Promise)
local NULL = require(ParentParent.utilities.globals.null).NULL
local t1 = {}
local GraphQL = require(ParentParentParent.GraphQL)
local visit = GraphQL.visit
local BREAK = GraphQL.BREAK
local invariant = require(ParentParent.jsutils.invariant).invariant

require(script.Parent.Parent.cache)

local utilities = require(script.Parent.Parent.utilities)
local argumentsObjectFromField = utilities.argumentsObjectFromField
local buildQueryFromSelectionSet = utilities.buildQueryFromSelectionSet
local createFragmentMap = utilities.createFragmentMap
local getFragmentDefinitions = utilities.getFragmentDefinitions
local getMainDefinition = utilities.getMainDefinition
local hasDirectives = utilities.hasDirectives
local isField = utilities.isField
local isInlineFragment = utilities.isInlineFragment
local mergeDeep = utilities.mergeDeep
local mergeDeepArray = utilities.mergeDeepArray
local removeClientSetsFromDocument = utilities.removeClientSetsFromDocument
local resultKeyNameFromField = utilities.resultKeyNameFromField
local shouldInclude = utilities.shouldInclude

require(script.Parent.ApolloClient_types)
require(script.Parent.types)
require(script.Parent.Parent.link.core)

local cacheSlot = require(script.Parent.Parent.cache).cacheSlot
local t2 = {}

t2.__index = t2

function t2.new(t3: {[any]: any}) -- line: 185
	-- upvalues: t2 (copy)
	local self = setmetatable({}, t2)
	local cache = t3.cache
	local client = t3.client
	local resolvers = t3.resolvers
	local fragmentMatcher = t3.fragmentMatcher

	self.cache = cache

	if client ~= nil then
		self.client = client
	end

	if resolvers ~= nil then
		self:addResolvers(resolvers)
	end

	if fragmentMatcher ~= nil then
		self:setFragmentMatcher(fragmentMatcher)
	end

	return self
end
function t2.addResolvers(p1, p2) -- line: 206
	-- upvalues: Boolean (copy), Array (copy), mergeDeep (copy)
	p1.resolvers = Boolean.toJSBoolean(p1.resolvers) and p1.resolvers or {}

	if Array.isArray(p2) then
		Array.forEach(p2, function(p3) -- line: 209
			-- upvalues: p1 (copy), mergeDeep (copy)
			p1.resolvers = mergeDeep(p1.resolvers, p3)
		end)

		return
	end

	p1.resolvers = mergeDeep(p1.resolvers, p2)
end
function t2.setResolvers(p4, p5) -- line: 217
	p4.resolvers = {}
	p4:addResolvers(p5)
end
function t2.getResolvers(p6) -- line: 222
	-- upvalues: Boolean (copy)
	return Boolean.toJSBoolean(p6.resolvers) and p6.resolvers or {}
end
function t2.runResolvers(t4: {[any]: any}, t5: {[any]: any}) -- line: 230
	-- upvalues: Boolean (copy), Object (copy), Promise (copy)
	local document = t5.document
	local remoteResult = t5.remoteResult
	local context = t5.context
	local variables = t5.variables
	local onlyRunForcedResolvers = t5.onlyRunForcedResolvers

	if t5.onlyRunForcedResolvers == nil then
		onlyRunForcedResolvers = false
	end

	if Boolean.toJSBoolean(document) then
		return t4:resolveDocument(document, remoteResult.data, context, variables, t4.fragmentMatcher, onlyRunForcedResolvers):andThen(function(p7) -- line: 251
			-- upvalues: Object (copy), remoteResult (copy)
			return Object.assign({}, remoteResult, {
				data = p7.result
			})
		end)
	end

	return Promise.resolve(remoteResult)
end
function t2.setFragmentMatcher(t6: {[any]: any}, p8: ((...any) -> ...any)) -- line: 259
	t6.fragmentMatcher = p8
end
function t2.getFragmentMatcher(p9) -- line: 263
	return p9.fragmentMatcher
end
function t2.clientQuery(p10, p11) -- line: 269
	-- upvalues: hasDirectives (copy), Boolean (copy), NULL (copy)
	if hasDirectives({ "client" }, p11) and Boolean.toJSBoolean(p10.resolvers) then
		return p11
	end

	return NULL
end
function t2.serverQuery(_, p13) -- line: 279
	-- upvalues: removeClientSetsFromDocument (copy)
	return removeClientSetsFromDocument(p13)
end
function t2.prepareContext(t7: {[any]: any}, t8: {[any]: any}?) -- line: 283
	-- upvalues: Object (copy)
	local cache = t7.cache

	return Object.assign({}, t8, {
		cache = cache,
		getCacheKey = function(_, p15) -- line: 291
			-- upvalues: cache (copy)
			return cache:identify(p15)
		end
	})
end
function t2.addExportedVariables(p16, p17, p18, p19) -- line: 300
	-- upvalues: Boolean (copy), Object (copy), Promise (copy)
	if p18 == nil then
		p18 = {}
	end

	if p19 == nil then
		p19 = {}
	end

	if Boolean.toJSBoolean(p17) then
		local v64 = p16:buildRootValueFromCache(p17, p18)

		return p16:resolveDocument(p17, Boolean.toJSBoolean(v64) and v64 or {}, p16:prepareContext(p19), p18):andThen(function(p20) -- line: 319
			-- upvalues: Object (copy), p18 (ref)
			return Object.assign({}, p18, p20.exportedVariables)
		end)
	end

	return Promise.resolve(Object.assign({}, p18))
end
function t2.shouldForceResolvers(_, p22) -- line: 327
	-- upvalues: visit (copy), Boolean (copy), Array (copy), BREAK (copy)
	local u67 = false

	visit(p22, {
		Directive = {
			enter = function(_, p24) -- line: 331
				-- upvalues: Boolean (copy), u67 (ref), Array (copy), BREAK (copy)
				if p24.name.value == "client" and Boolean.toJSBoolean(p24.arguments) then
					u67 = Array.some(p24.arguments, function(p25) -- line: 333
						return p25.name.value == "always" and (p25.value.kind == "BooleanValue" and p25.value.value == true)
					end)

					if u67 then
						return BREAK
					end
				end

				return nil
			end
		}
	})

	return u67
end
function t2.buildRootValueFromCache(t9: {[any]: any}, p26, t10: {[any]: any}?) -- line: 350
	-- upvalues: buildQueryFromSelectionSet (copy)
	return t9.cache:diff({
		returnPartialData = true,
		optimistic = false,
		query = buildQueryFromSelectionSet(p26),
		variables = t10
	}).result
end
function t2.resolveDocument(t11: {[any]: any}, p27, p28, p29, t12: {[any]: any}?, p30: ((...any) -> ...any)?, b1: boolean?) -- line: 359
	-- upvalues: getMainDefinition (copy), getFragmentDefinitions (copy), createFragmentMap (copy), Boolean (copy), String (copy), Object (copy)
	if p29 == nil then
		p29 = {}
	end

	if t12 == nil then
		t12 = {}
	end

	if p30 == nil then
		function p30() -- line: 377
			return true
		end
	end

	if b1 == nil then
		b1 = false
	end

	local v78 = getMainDefinition(p27)
	local v79 = getFragmentDefinitions(p27)
	local v80 = createFragmentMap(v79)
	local operation = v78.operation
	local v82 = not Boolean.toJSBoolean(operation) and "Query" or string.upper((string.sub(operation, 1, 1))) .. String.slice(operation, 2)
	local cache = t11.cache
	local client = t11.client
	local t13 = {
		fragmentMap = v80,
		context = Object.assign({}, p29, {
			cache = cache,
			client = client
		}),
		variables = t12,
		fragmentMatcher = p30,
		defaultOperationType = v82,
		exportedVariables = {},
		onlyRunForcedResolvers = b1
	}

	return t11:resolveSelectionSet(v78.selectionSet, p28, t13):andThen(function(p31) -- line: 413
		-- upvalues: t13 (copy)
		return {
			result = p31,
			exportedVariables = t13.exportedVariables
		}
	end)
end
function t2.resolveSelectionSet(t14: {[any]: any}, p32, p33, t15: {[any]: any}) -- line: 418
	-- upvalues: Boolean (copy), shouldInclude (copy), Promise (copy), isField (copy), resultKeyNameFromField (copy), isInlineFragment (copy), invariant (copy), Array (copy), mergeDeepArray (copy)
	local fragmentMap = t15.fragmentMap
	local context = t15.context
	local variables = t15.variables
	local t16 = { p33 }

	local function execute(p34) -- line: 426
		-- upvalues: Boolean (copy), shouldInclude (copy), variables (copy), Promise (copy), isField (copy), t14 (copy), p33 (copy), t15 (copy), t16 (copy), resultKeyNameFromField (copy), isInlineFragment (copy), fragmentMap (copy), invariant (copy), context (copy)
		if not Boolean.toJSBoolean(shouldInclude(p34, variables)) then
			return Promise.resolve(nil)
		end

		if isField(p34) then
			return t14:resolveField(p34, p33, t15):andThen(function(p35) -- line: 433
				-- upvalues: t16 (copy), resultKeyNameFromField (copy), p34 (copy)
				if typeof(p35) ~= "nil" then
					table.insert(t16, {
						[resultKeyNameFromField(p34)] = p35
					})
				end
			end)
		end

		local v121

		if isInlineFragment(p34) then
			v121 = p34
		else
			v121 = fragmentMap[p34.name.value]
			invariant(v121, ("No fragment named %s"):format(p34.name.value))
		end

		if v121 and v121.typeCondition ~= nil then
			local value = v121.typeCondition.name.value

			if Boolean.toJSBoolean(t15:fragmentMatcher(p33, value, context)) then
				return t14:resolveSelectionSet(v121.selectionSet, p33, t15):andThen(function(p36) -- line: 454
					-- upvalues: t16 (copy)
					table.insert(t16, p36)
				end)
			end
		end

		return Promise.resolve(nil)
	end

	return Promise.all(Array.map(p32.selections, execute)):andThen(function() -- line: 462
		-- upvalues: mergeDeepArray (copy), t16 (copy)
		return mergeDeepArray(t16)
	end)
end
function t2.resolveField(t17: {[any]: any}, p37, p38, t18: {[any]: any}) -- line: 467
	-- upvalues: resultKeyNameFromField (copy), Boolean (copy), Promise (copy), cacheSlot (copy), argumentsObjectFromField (copy), Array (copy), NULL (copy)
	local variables = t18.variables
	local value = p37.name.value
	local v101 = resultKeyNameFromField(p37)
	local v102 = value ~= v101
	local v103 = Boolean.toJSBoolean(p38[v101]) and p38[v101] or p38[value]
	local v104 = Promise.resolve(v103)

	if not t18.onlyRunForcedResolvers or t17:shouldForceResolvers(p37) then
		local v105 = Boolean.toJSBoolean(p38.__typename) and p38.__typename or t18.defaultOperationType
		local v106 = if not Boolean.toJSBoolean(t17.resolvers) then t17.resolvers else t17.resolvers[tostring(v105)]

		if Boolean.toJSBoolean(v106) then
			local v107 = v106[if not v102 then v101 else value]

			if Boolean.toJSBoolean(v107) then
				v104 = Promise.resolve(cacheSlot:withValue(t17.cache, v107, {
					p38,
					argumentsObjectFromField(p37, variables),
					t18.context,
					{
						field = p37,
						fragmentMap = t18.fragmentMap
					}
				}))
			end
		end
	end

	return v104:andThen(function(p39) -- line: 512
		-- upvalues: v103 (copy), p37 (copy), Array (copy), Boolean (copy), t18 (copy), NULL (copy), t17 (copy)
		if p39 == nil then
			p39 = v103
		end

		if p37.directives ~= nil then
			Array.forEach(p37.directives, function(p40) -- line: 519
				-- upvalues: Boolean (copy), Array (copy), t18 (copy), p39 (ref)
				if p40.name.value == "export" and Boolean.toJSBoolean(p40.arguments) then
					Array.forEach(p40.arguments, function(p41) -- line: 521
						-- upvalues: t18 (copy), p39 (ref)
						if p41.name.value == "as" and p41.value.kind == "StringValue" then
							t18.exportedVariables[p41.value.value] = p39
						end
					end)
				end
			end)
		end

		if not Boolean.toJSBoolean(p37.selectionSet) then
			return p39
		end

		if p39 == nil or p39 == NULL then
			return p39
		end

		if Array.isArray(p39) then
			return t17:resolveSubSelectedArray(p37, p39, t18)
		end

		if Boolean.toJSBoolean(p37.selectionSet) then
			return t17:resolveSelectionSet(p37.selectionSet, p39, t18)
		end

		return nil
	end)
end
function t2.resolveSubSelectedArray(t19: {[any]: any}, p42, p43, t20: {[any]: any}) -- line: 554
	-- upvalues: Promise (copy), Array (copy), NULL (copy), Boolean (copy)
	return Promise.all(Array.map(p43, function(p44) -- line: 555
		-- upvalues: NULL (copy), Array (copy), t19 (copy), p42 (copy), t20 (copy), Boolean (copy)
		if p44 == NULL then
			return NULL
		end

		if Array.isArray(p44) then
			return t19:resolveSubSelectedArray(p42, p44, t20)
		end

		if Boolean.toJSBoolean(p42.selectionSet) then
			return t19:resolveSelectionSet(p42.selectionSet, p44, t20)
		end

		return nil
	end))
end

t1.LocalState = t2

return t1
