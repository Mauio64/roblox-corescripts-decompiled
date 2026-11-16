local parent = script.Parent.Parent
local parent2 = parent.Parent

local LuauPolyfill = require(parent2.LuauPolyfill)
local Array = LuauPolyfill.Array
local Object = LuauPolyfill.Object
local Boolean = LuauPolyfill.Boolean
local String = LuauPolyfill.String
local Promise = require(parent2.Promise)

local null = require(parent.utilities.globals.null)
local null2 = null.NULL

local GraphQL = require(parent2.GraphQL)

local visit = GraphQL.visit
local v = GraphQL.BREAK
local invariant = require(parent.jsutils.invariant)
local invariant2 = invariant.invariant

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

local cache = require(script.Parent.Parent.cache)
local cacheSlot = cache.cacheSlot

local class = {}
class.__index = class

function class.new(data)
	local object = setmetatable({}, class)
	local cache2 = data.cache
	local client = data.client
	local resolvers = data.resolvers
	local fragmentMatcher = data.fragmentMatcher

	object.cache = cache2

	if client ~= nil then
		object.client = client
	end

	if resolvers ~= nil then
		object:addResolvers(resolvers)
	end

	if fragmentMatcher ~= nil then
		object:setFragmentMatcher(fragmentMatcher)
	end

	return object
end

function class:addResolvers(p)
	self.resolvers = Boolean.toJSBoolean(self.resolvers) and self.resolvers or {}

	if Array.isArray(p) then
		Array.forEach(p, function(p2)
			self.resolvers = mergeDeep(self.resolvers, p2)
		end)
	else
		self.resolvers = mergeDeep(self.resolvers, p)
	end
end

function class:setResolvers(p)
	self.resolvers = {}
	self:addResolvers(p)
end

function class.getResolvers(p)
	return Boolean.toJSBoolean(p.resolvers) and p.resolvers or {}
end

function class:runResolvers(data)
	local document = data.document
	local remoteResult = data.remoteResult
	local context = data.context
	local variables = data.variables
	local v2 = data.onlyRunForcedResolvers

	if data.onlyRunForcedResolvers == nil then
		v2 = false
	end

	if Boolean.toJSBoolean(document) then
		return self:resolveDocument(document, remoteResult.data, context, variables, self.fragmentMatcher, v2):andThen(function(p)
			return Object.assign({}, remoteResult, { data = p.result })
		end)
	end

	return Promise.resolve(remoteResult)
end

function class:setFragmentMatcher(fragmentMatcher)
	self.fragmentMatcher = fragmentMatcher
end

function class.getFragmentMatcher(p)
	return p.fragmentMatcher
end

function class.clientQuery(p, p2)
	if hasDirectives({ "client" }, p2) and Boolean.toJSBoolean(p.resolvers) then
		return p2
	end

	return null2
end

function class.serverQuery(_, p)
	return removeClientSetsFromDocument(p)
end

function class:prepareContext(p)
	local cache2 = self.cache
	return Object.assign({}, p, {
		cache = cache2,
		getCacheKey = function(_, p2)
			return cache2:identify(p2)
		end
	})
end

function class:addExportedVariables(p, p2, p3)
	local v2 = p2 == nil and {} or p2

	local v3 = p3 == nil and {} or p3

	if not Boolean.toJSBoolean(p) then
		return Promise.resolve(Object.assign({}, v2))
	end

	local rootValueFromCache = self:buildRootValueFromCache(p, v2)
	return self:resolveDocument(
		p,
		Boolean.toJSBoolean(rootValueFromCache) and rootValueFromCache or {},
		self:prepareContext(v3),
		v2
	):andThen(function(p4)
		return Object.assign({}, v2, p4.exportedVariables)
	end)
end

function class:shouldForceResolvers(p)
	local v2 = false
	visit(p, {
		Directive = {
			enter = function(_, p2)
				if p2.name.value == "client" and Boolean.toJSBoolean(p2.arguments) then
					v2 = Array.some(p2.arguments, function(p3): boolean
						return p3.name.value == "always" and p3.value.kind == "BooleanValue" and p3.value.value == true
					end)

					if v2 then
						return v
					end
				end

				return nil
			end
		}
	})

	return v2
end

function class:buildRootValueFromCache(p, variables)
	return self.cache:diff({
		query = buildQueryFromSelectionSet(p),
		variables = variables,
		returnPartialData = true,
		optimistic = false
	}).result
end

function class:resolveDocument(p, p2, p3, p4, callback, onlyRunForcedResolvers: boolean?)
	local v2 = p3 == nil and {} or p3

	local variables = p4 == nil and {} or p4

	local fn = callback == nil and function(): boolean
		return true
	end or callback

	if onlyRunForcedResolvers == nil then
		onlyRunForcedResolvers = false
	end

	local mainDefinition = getMainDefinition(p)
	local fragmentMap = createFragmentMap((getFragmentDefinitions(p)))

	local operation = mainDefinition.operation

	local defaultOperationType = not Boolean.toJSBoolean(operation) and "Query"
		or string.upper((string.sub(operation, 1, 1))) .. String.slice(operation, 2)

	local cache2 = self.cache
	local client = self.client
	local v3 = {
		fragmentMap = fragmentMap,
		context = Object.assign({}, v2, { cache = cache2, client = client }),
		variables = variables,
		fragmentMatcher = fn,
		defaultOperationType = defaultOperationType,
		exportedVariables = {},
		onlyRunForcedResolvers = onlyRunForcedResolvers
	}

	return self:resolveSelectionSet(mainDefinition.selectionSet, p2, v3):andThen(function(p5)
		return { result = p5, exportedVariables = v3.exportedVariables }
	end)
end

function class:resolveSelectionSet(p, p2, object)
	local fragmentMap = object.fragmentMap
	local context = object.context
	local variables = object.variables
	local v2 = { p2 }

	local function execute(p3)
		if not Boolean.toJSBoolean(shouldInclude(p3, variables)) then
			return Promise.resolve(nil)
		end

		if isField(p3) then
			return self:resolveField(p3, p2, object):andThen(function(p4)
				if typeof(p4) ~= "nil" then
					local v3 = { [resultKeyNameFromField(p3)] = p4 }
					table.insert(v2, v3)
				end
			end)
		end

		local v3

		if isInlineFragment(p3) then
			v3 = p3
		else
			v3 = fragmentMap[p3.name.value]
			invariant2(v3, ("No fragment named %s"):format(p3.name.value))
		end

		if v3 and v3.typeCondition ~= nil then
			local value = v3.typeCondition.name.value

			if Boolean.toJSBoolean(object:fragmentMatcher(p2, value, context)) then
				return self:resolveSelectionSet(v3.selectionSet, p2, object):andThen(function(p4)
					table.insert(v2, p4)
				end)
			end
		end

		return Promise.resolve(nil)
	end

	return Promise.all(Array.map(p.selections, execute)):andThen(function()
		return mergeDeepArray(v2)
	end)
end

function class:resolveField(field, p, data)
	local variables = data.variables
	local value = field.name.value
	local v2 = resultKeyNameFromField(field)
	local v3 = value ~= v2
	local v4 = Boolean.toJSBoolean(p[v2]) and p[v2] or p[value]
	local resolved = Promise.resolve(v4)

	if not data.onlyRunForcedResolvers or self:shouldForceResolvers(field) then
		local __typename = Boolean.toJSBoolean(p.__typename) and p.__typename or data.defaultOperationType
		local v5

		if Boolean.toJSBoolean(self.resolvers) then
			v5 = self.resolvers[tostring(__typename)]
		else
			v5 = self.resolvers
		end

		if Boolean.toJSBoolean(v5) then
			if v3 then
				v2 = value
			end

			local v6 = v5[v2]

			if Boolean.toJSBoolean(v6) then
				resolved = Promise.resolve(cacheSlot:withValue(self.cache, v6, {
					p,
					argumentsObjectFromField(field, variables),
					data.context,
					{ field = field, fragmentMap = data.fragmentMap }
				}))
			end
		end
	end

	return resolved:andThen(function(p2)
		if p2 == nil then
			p2 = v4
		end

		if field.directives ~= nil then
			Array.forEach(field.directives, function(p3)
				if p3.name.value == "export" and Boolean.toJSBoolean(p3.arguments) then
					Array.forEach(p3.arguments, function(p4)
						if p4.name.value == "as" and p4.value.kind == "StringValue" then
							data.exportedVariables[p4.value.value] = p2
						end
					end)
				end
			end)
		end

		if not Boolean.toJSBoolean(field.selectionSet) or (p2 == nil or p2 == null2) then
			return p2
		end

		if Array.isArray(p2) then
			return self:resolveSubSelectedArray(field, p2, data)
		end

		if Boolean.toJSBoolean(field.selectionSet) then
			return self:resolveSelectionSet(field.selectionSet, p2, data)
		end

		return nil
	end)
end

function class:resolveSubSelectedArray(p, p2, p3)
	return Promise.all(Array.map(p2, function(p4)
		if p4 == null2 then
			return null2
		end

		if Array.isArray(p4) then
			return self:resolveSubSelectedArray(p, p4, p3)
		end

		if Boolean.toJSBoolean(p.selectionSet) then
			return self:resolveSelectionSet(p.selectionSet, p4, p3)
		end

		return nil
	end))
end

return { LocalState = class }
