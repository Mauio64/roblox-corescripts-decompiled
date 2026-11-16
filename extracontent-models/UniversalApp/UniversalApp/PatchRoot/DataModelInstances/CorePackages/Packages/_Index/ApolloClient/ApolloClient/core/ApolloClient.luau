local parent = script.Parent.Parent
local parent2 = parent.Parent

local LuauPolyfill = require(parent2.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Object = LuauPolyfill.Object
local setTimeout = LuauPolyfill.setTimeout

local Promise = require(parent2.Promise)

require(parent2.GraphQL)

local invariant = require(parent.jsutils.invariant)
local invariant2 = invariant.invariant
local invariantError = invariant.InvariantError

local core = require(script.Parent.Parent.link.core)
local apolloLink = core.ApolloLink

local execute = core.execute

require(script.Parent.Parent.cache)

local utilities = require(script.Parent.Parent.utilities)

local compact = utilities.compact
local version = require(script.Parent.Parent.version)
local version2 = version.version

local http = require(script.Parent.Parent.link.http)
local httpLink = http.HttpLink

local QueryManager = require(script.Parent.QueryManager)
local queryManager = QueryManager.QueryManager

require(script.Parent.ObservableQuery_types)

require(parent.core.types)

require(script.Parent.watchQueryOptions_types)

require(script.Parent.watchQueryOptions)

local LocalState = require(script.Parent.LocalState)
local localState = LocalState.LocalState

require(script.Parent.ApolloClient_types)

local function mergeOptions(p, p2)
	return compact(
		p,
		p2,
		Boolean.toJSBoolean(p2.variables) and {
			variables = Object.assign({}, p.variables, p2.variables)
		} or p2.variables
	)
end

local ApolloClient = {}
ApolloClient.mergeOptions = mergeOptions
local class = {}
class.__index = class

function class.new(data)
	local object = setmetatable({}, class)
	object.defaultOptions = {}
	object.resetStoreCallbacks = {}
	object.clearStoreCallbacks = {}

	local uri = data.uri
	local credentials = data.credentials
	local headers = data.headers
	local cache = data.cache
	local defaultOptions = data.defaultOptions
	local resolvers = data.resolvers
	local typeDefs = data.typeDefs
	local fragmentMatcher = data.fragmentMatcher
	local name = data.name
	local version3 = data.version

	local ssrMode = not (data.ssrMode == nil) and data.ssrMode

	local v = data.ssrForceFetchDelay == nil and 0 or data.ssrForceFetchDelay
	local v2

	if data.connectToDevTools == nil then
		if typeof(_G) == "table" then
			v2 = not Boolean.toJSBoolean(_G.__APOLLO_CLIENT__) and _G.__DEV__
		else
			v2 = false
		end
	else
		v2 = data.connectToDevTools
	end

	local queryDeduplication = data.queryDeduplication == nil or data.queryDeduplication
	local assumeImmutableResults

	if data.assumeImmutableResults == nil then
		assumeImmutableResults = false
	else
		assumeImmutableResults = data.assumeImmutableResults
	end

	local link = data.link

	if not Boolean.toJSBoolean(link) then
		if Boolean.toJSBoolean(uri) then
			link = httpLink.new({ uri = uri, credentials = credentials, headers = headers })
		else
			link = apolloLink.empty()
		end
	end

	if not Boolean.toJSBoolean(cache) then
		error(invariantError.new("To initialize Apollo Client, you must specify a 'cache' property in the options object. \nFor more information, please visit: https://go.apollo.dev/c/docs"))
	end

	object.link = link
	object.cache = cache
	object.disableNetworkFetches = Boolean.toJSBoolean(ssrMode) and ssrMode or v > 0
	object.queryDeduplication = queryDeduplication
	object.defaultOptions = Boolean.toJSBoolean(defaultOptions) and defaultOptions or {}
	object.typeDefs = typeDefs

	if Boolean.toJSBoolean(v) then
		setTimeout(function()
			object.disableNetworkFetches = false
			return object.disableNetworkFetches
		end, v)
	end

	object.version = version2

	object.localState = localState.new({
		cache = cache,
		client = object,
		resolvers = resolvers,
		fragmentMatcher = fragmentMatcher
	})

	object.queryManager = queryManager.new({
		cache = object.cache,
		link = object.link,
		queryDeduplication = queryDeduplication,
		ssrMode = ssrMode,
		clientAwareness = { name = name, version = version3 },
		localState = object.localState,
		assumeImmutableResults = assumeImmutableResults,
		onBroadcast = v2 and function() end or nil
	})

	return object
end

function class:stop()
	self.queryManager:stop()
end

function class:watchQuery(p)
	if Boolean.toJSBoolean(self.defaultOptions.watchQuery) then
		p = mergeOptions(self.defaultOptions.watchQuery, p)
	end

	if self.disableNetworkFetches and (p.fetchPolicy == "network-only" or p.fetchPolicy == "cache-and-network") then
		p = Object.assign({}, p, { fetchPolicy = "cache-first" })
	end

	return self.queryManager:watchQuery(p)
end

function class:query(p)
	if Boolean.toJSBoolean(self.defaultOptions.query) then
		p = mergeOptions(self.defaultOptions.query, p)
	end

	invariant2(
		p.fetchPolicy ~= "cache-and-network",
		"The cache-and-network fetchPolicy does not work with client.query, because client.query can only return a single result. Please use client.watchQuery to receive multiple results from the cache and the network, or consider using a different fetchPolicy, such as cache-first or network-only."
	)

	if self.disableNetworkFetches and p.fetchPolicy == "network-only" then
		p = Object.assign({}, p, { fetchPolicy = "cache-first" })
	end

	return self.queryManager:query(p)
end

function class:mutate(p)
	if Boolean.toJSBoolean(self.defaultOptions.mutate) then
		p = mergeOptions(self.defaultOptions.mutate, p)
	end

	return self.queryManager:mutate(p)
end

function class.subscribe(p, p2)
	return p.queryManager:startGraphQLSubscription(p2)
end

function class:readQuery(p, flag: boolean?)
	if flag == nil then
		flag = false
	end

	return self.cache:readQuery(p, flag)
end

function class:readFragment(p, flag: boolean?)
	if flag == nil then
		flag = false
	end

	return self.cache:readFragment(p, flag)
end

function class:writeQuery(p)
	self.cache:writeQuery(p)
	self.queryManager:broadcastQueries()
end

function class:writeFragment(p)
	self.cache:writeFragment(p)
	self.queryManager:broadcastQueries()
end

function class:__actionHookForDevTools(devToolsHookCb)
	self.devToolsHookCb = devToolsHookCb
end

function class.__requestRaw(p, p2)
	return execute(p.link, p2)
end

function class:resetStore()
	return Promise.delay(0):andThen(function()
		return self.queryManager:clearStore()
	end):andThen(function()
		return Promise.all(Array.map(self.resetStoreCallbacks, function(callback)
			return callback()
		end))
	end):andThen(function()
		return self:reFetchObservableQueries()
	end)
end

function class:clearStore()
	return Promise.delay(0):andThen(function()
		return self.queryManager:clearStore()
	end):andThen(function()
		return Promise.all(Array.map(self.clearStoreCallbacks, function(callback)
			return callback()
		end))
	end)
end

function class:onResetStore(callback)
	table.insert(self.resetStoreCallbacks, callback)
	return function()
		self.resetStoreCallbacks = Array.filter(self.resetStoreCallbacks, function(p): boolean
			return p ~= callback
		end)
	end
end

function class:onClearStore(callback)
	table.insert(self.clearStoreCallbacks, callback)
	return function()
		self.clearStoreCallbacks = Array.filter(self.clearStoreCallbacks, function(p): boolean
			return p ~= callback
		end)
	end
end

function class:reFetchObservableQueries(flag: boolean?)
	return self.queryManager:reFetchObservableQueries(flag)
end

function class:refetchQueries(p)
	local queries = {}
	local results = {}
	self.queryManager:refetchQueries(p):forEach(function(p2, p3)
		table.insert(queries, p3)
		table.insert(results, p2)
	end)

	local all = Promise.all(results)

	all.queries = queries
	all.results = results

	all:catch(function(p2)
		invariant2.debug(("In client.refetchQueries, Promise.all promise rejected with error %s"):format(p2.message))
	end)

	return all
end

function class:getObservableQueries(p)
	local v = p == nil and "active" or p

	return self.queryManager:getObservableQueries(v)
end

function class:extract(flag: boolean?)
	return self.cache:extract(flag)
end

function class:restore(p)
	return self.cache:restore(p)
end

function class:addResolvers(p)
	self.localState:addResolvers(p)
end

function class:setResolvers(p)
	self.localState:setResolvers(p)
end

function class:getResolvers()
	return self.localState:getResolvers()
end

function class.setLocalStateFragmentMatcher(p, p2)
	p.localState:setFragmentMatcher(p2)
end

function class:setLink(link)
	self.queryManager.link = link
	self.link = self.queryManager.link
end

ApolloClient.ApolloClient = class

return ApolloClient
