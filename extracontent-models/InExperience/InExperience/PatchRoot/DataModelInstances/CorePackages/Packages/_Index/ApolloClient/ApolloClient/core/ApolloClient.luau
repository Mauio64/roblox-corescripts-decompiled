local t1 = {}
local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local LuauPolyfill = require(ParentParentParent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Object = LuauPolyfill.Object
local setTimeout = LuauPolyfill.setTimeout
local Promise = require(ParentParentParent.Promise)

require(ParentParentParent.GraphQL)

local invariant = require(ParentParent.jsutils.invariant)
local invariant2 = invariant.invariant
local InvariantError = invariant.InvariantError
local core = require(script.Parent.Parent.link.core)
local ApolloLink = core.ApolloLink
local execute = core.execute

require(script.Parent.Parent.cache)

local compact = require(script.Parent.Parent.utilities).compact
local version = require(script.Parent.Parent.version).version
local HttpLink = require(script.Parent.Parent.link.http).HttpLink
local QueryManager = require(script.Parent.QueryManager).QueryManager

require(script.Parent.ObservableQuery_types)
require(ParentParent.core.types)
require(script.Parent.watchQueryOptions_types)
require(script.Parent.watchQueryOptions)

local LocalState = require(script.Parent.LocalState).LocalState

require(script.Parent.ApolloClient_types)

local function mergeOptions(p1, p2) -- line: 133
	-- upvalues: compact (copy), Boolean (copy), Object (copy)
	return compact(p1, p2, Boolean.toJSBoolean(p2.variables) and {
		variables = Object.assign({}, p1.variables, p2.variables)
	} or p2.variables)
end

t1.mergeOptions = mergeOptions

local t2 = {}

t2.__index = t2

function t2.new(t3: {[any]: any}) -- line: 189
	-- upvalues: t2 (copy), Boolean (copy), HttpLink (copy), ApolloLink (copy), InvariantError (copy), setTimeout (copy), version (copy), LocalState (copy), QueryManager (copy)
	local self = setmetatable({}, t2)

	self.defaultOptions = {}
	self.resetStoreCallbacks = {}
	self.clearStoreCallbacks = {}

	local uri = t3.uri
	local credentials = t3.credentials
	local headers = t3.headers
	local cache = t3.cache
	local defaultOptions = t3.defaultOptions
	local resolvers = t3.resolvers
	local typeDefs = t3.typeDefs
	local fragmentMatcher = t3.fragmentMatcher
	local name = t3.name
	local version2 = t3.version
	local v37 = t3.ssrMode ~= nil and t3.ssrMode
	local v38 = if t3.ssrForceFetchDelay ~= nil then t3.ssrForceFetchDelay else 0
	local v39 = if t3.connectToDevTools ~= nil then t3.connectToDevTools else typeof(_G) == "table" and (not Boolean.toJSBoolean(_G.__APOLLO_CLIENT__) and _G.__DEV__)
	local v40 = t3.queryDeduplication == nil or t3.queryDeduplication
	local v41 = t3.assumeImmutableResults ~= nil and t3.assumeImmutableResults
	local link = t3.link

	if not Boolean.toJSBoolean(link) then
		link = if not Boolean.toJSBoolean(uri) then ApolloLink.empty() else HttpLink.new({
			uri = uri,
			credentials = credentials,
			headers = headers
		})
	end

	if not Boolean.toJSBoolean(cache) then
		error(InvariantError.new("To initialize Apollo Client, you must specify a 'cache' property in the options object. \nFor more information, please visit: https://go.apollo.dev/c/docs"))
	end

	self.link = link
	self.cache = cache
	self.disableNetworkFetches = Boolean.toJSBoolean(v37) and v37 or v38 > 0
	self.queryDeduplication = v40
	self.defaultOptions = Boolean.toJSBoolean(defaultOptions) and defaultOptions or {}
	self.typeDefs = typeDefs

	if Boolean.toJSBoolean(v38) then
		setTimeout(function() -- line: 271
			-- upvalues: self (copy)
			self.disableNetworkFetches = false

			return self.disableNetworkFetches
		end, v38)
	end

	self.version = version
	self.localState = LocalState.new({
		cache = cache,
		client = self,
		resolvers = resolvers,
		fragmentMatcher = fragmentMatcher
	})
	self.queryManager = QueryManager.new({
		cache = self.cache,
		link = self.link,
		queryDeduplication = v40,
		ssrMode = v37,
		clientAwareness = {
			name = name,
			version = version2
		},
		localState = self.localState,
		assumeImmutableResults = v41,
		onBroadcast = if not v39 then nil else function() -- line: 425
		end
	})

	return self
end
function t2.stop(p3) -- line: 438
	p3.queryManager:stop()
end
function t2.watchQuery(p4, p5) -- line: 461
	-- upvalues: Boolean (copy), mergeOptions (copy), Object (copy)
	if Boolean.toJSBoolean(p4.defaultOptions.watchQuery) then
		p5 = mergeOptions(p4.defaultOptions.watchQuery, p5)
	end

	if p4.disableNetworkFetches and (p5.fetchPolicy == "network-only" or p5.fetchPolicy == "cache-and-network") then
		p5 = Object.assign({}, p5, {
			fetchPolicy = "cache-first"
		})
	end

	return p4.queryManager:watchQuery(p5)
end
function t2.query(p6, p7) -- line: 486
	-- upvalues: Boolean (copy), mergeOptions (copy), invariant2 (copy), Object (copy)
	if Boolean.toJSBoolean(p6.defaultOptions.query) then
		p7 = mergeOptions(p6.defaultOptions.query, p7)
	end

	invariant2(p7.fetchPolicy ~= "cache-and-network", "The cache-and-network fetchPolicy does not work with client.query, because client.query can only return a single result. Please use client.watchQuery to receive multiple results from the cache and the network, or consider using a different fetchPolicy, such as cache-first or network-only.")

	if p6.disableNetworkFetches and p7.fetchPolicy == "network-only" then
		p7 = Object.assign({}, p7, {
			fetchPolicy = "cache-first"
		})
	end

	return p6.queryManager:query(p7)
end
function t2.mutate(p8, p9) -- line: 513
	-- upvalues: Boolean (copy), mergeOptions (copy)
	if Boolean.toJSBoolean(p8.defaultOptions.mutate) then
		p9 = mergeOptions(p8.defaultOptions.mutate, p9)
	end

	return p8.queryManager:mutate(p9)
end
function t2.subscribe(p10, p11) -- line: 526
	return p10.queryManager:startGraphQLSubscription(p11)
end
function t2.readQuery(t4: {[any]: any}, p12, b1: boolean?) -- line: 539
	if b1 == nil then
		b1 = false
	end

	return t4.cache:readQuery(p12, b1)
end
function t2.readFragment(t5: {[any]: any}, p13, b2: boolean?) -- line: 560
	if b2 == nil then
		b2 = false
	end

	return t5.cache:readFragment(p13, b2)
end
function t2.writeQuery(p14, p15) -- line: 572
	p14.cache:writeQuery(p15)
	p14.queryManager:broadcastQueries()
end
function t2.writeFragment(p16, p17) -- line: 588
	p16.cache:writeFragment(p17)
	p16.queryManager:broadcastQueries()
end
function t2.__actionHookForDevTools(t6: {[any]: any}, p18: ((...any) -> ...any)) -- line: 593
	t6.devToolsHookCb = p18
end
function t2.__requestRaw(p19, p20) -- line: 597
	-- upvalues: execute (copy)
	return execute(p19.link, p20)
end
function t2.resetStore(p21) -- line: 617
	-- upvalues: Promise (copy), Array (copy)
	return Promise.delay(0):andThen(function() -- line: 619
		-- upvalues: p21 (copy)
		return p21.queryManager:clearStore()
	end):andThen(function() -- line: 622
		-- upvalues: Promise (copy), Array (copy), p21 (copy)
		return Promise.all(Array.map(p21.resetStoreCallbacks, function(p22) -- line: 623
			return p22()
		end))
	end):andThen(function() -- line: 627
		-- upvalues: p21 (copy)
		return p21:reFetchObservableQueries()
	end)
end
function t2.clearStore(p23) -- line: 636
	-- upvalues: Promise (copy), Array (copy)
	return Promise.delay(0):andThen(function() -- line: 638
		-- upvalues: p23 (copy)
		return p23.queryManager:clearStore()
	end):andThen(function() -- line: 641
		-- upvalues: Promise (copy), Array (copy), p23 (copy)
		return Promise.all(Array.map(p23.clearStoreCallbacks, function(p24) -- line: 642
			return p24()
		end))
	end)
end
function t2.onResetStore(t7: {[any]: any}, p25: ((...any) -> ...any)) -- line: 653
	-- upvalues: Array (copy)
	table.insert(t7.resetStoreCallbacks, p25)

	return function() -- line: 655
		-- upvalues: t7 (copy), Array (copy), p25 (copy)
		t7.resetStoreCallbacks = Array.filter(t7.resetStoreCallbacks, function(p26) -- line: 656
			-- upvalues: p25 (copy)
			return p26 ~= p25
		end)
	end
end
function t2.onClearStore(t8: {[any]: any}, p27: ((...any) -> ...any)) -- line: 667
	-- upvalues: Array (copy)
	table.insert(t8.clearStoreCallbacks, p27)

	return function() -- line: 669
		-- upvalues: t8 (copy), Array (copy), p27 (copy)
		t8.clearStoreCallbacks = Array.filter(t8.clearStoreCallbacks, function(p28) -- line: 670
			-- upvalues: p27 (copy)
			return p28 ~= p27
		end)
	end
end
function t2.reFetchObservableQueries(t9: {[any]: any}, b3: boolean?) -- line: 688
	return t9.queryManager:reFetchObservableQueries(b3)
end
function t2.refetchQueries(p29, p30) -- line: 703
	-- upvalues: Promise (copy), invariant2 (copy)
	local t10 = {}
	local t11 = {}

	p29.queryManager:refetchQueries(p30):forEach(function(p31, p32) -- line: 708
		-- upvalues: t10 (copy), t11 (copy)
		table.insert(t10, p32)
		table.insert(t11, p31)
	end)

	local v78 = Promise.all(t11)

	v78.queries = t10
	v78.results = t11
	v78:catch(function(p33) -- line: 723
		-- upvalues: invariant2 (copy)
		invariant2.debug(("In client.refetchQueries, Promise.all promise rejected with error %s"):format(p33.message))
	end)

	return v78
end
function t2.getObservableQueries(p34, p35) -- line: 738
	if p35 == nil then
		p35 = "active"
	end

	return p34.queryManager:getObservableQueries(p35)
end
function t2.extract(t12: {[any]: any}, b4: boolean?) -- line: 748
	return t12.cache:extract(b4)
end
function t2.restore(p36, p37) -- line: 759
	return p36.cache:restore(p37)
end
function t2.addResolvers(p38, p39) -- line: 766
	p38.localState:addResolvers(p39)
end
function t2.setResolvers(p40, p41) -- line: 773
	p40.localState:setResolvers(p41)
end
function t2.getResolvers(p42) -- line: 780
	return p42.localState:getResolvers()
end
function t2.setLocalStateFragmentMatcher(p43, p44) -- line: 787
	p43.localState:setFragmentMatcher(p44)
end
function t2.setLink(p45, p46) -- line: 794
	p45.queryManager.link = p46
	p45.link = p45.queryManager.link
end

t1.ApolloClient = t2

return t1
