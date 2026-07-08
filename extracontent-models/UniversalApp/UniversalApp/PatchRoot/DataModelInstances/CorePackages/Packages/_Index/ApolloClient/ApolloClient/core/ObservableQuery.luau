local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local t1 = {}
local LuauPolyfill = require(ParentParentParent.LuauPolyfill)
local Boolean = LuauPolyfill.Boolean
local Object = LuauPolyfill.Object
local Set = LuauPolyfill.Set
local setTimeout = LuauPolyfill.setTimeout
local clearTimeout = LuauPolyfill.clearTimeout
local isCallable = require(ParentParent.luaUtils.isCallable)
local Promise = require(ParentParentParent.Promise)
local invariant = require(ParentParent.jsutils.invariant).invariant
local equal = require(ParentParent.jsutils.equal)
local networkStatus = require(script.Parent.networkStatus)
local NetworkStatus = networkStatus.NetworkStatus
local isNetworkRequestInFlight = networkStatus.isNetworkRequestInFlight
local utilities = require(script.Parent.Parent.utilities)
local compact = utilities.compact
local cloneDeep = utilities.cloneDeep
local getOperationDefinition = utilities.getOperationDefinition
local Observable = utilities.Observable
local iterateObserversSafely = utilities.iterateObserversSafely
local isNonEmptyArray = utilities.isNonEmptyArray
local fixObservableSubclass = utilities.fixObservableSubclass
local ApolloError = require(script.Parent.Parent.errors).ApolloError

require(script.Parent.types)
require(script.Parent.watchQueryOptions_types)
require(script.Parent.QueryInfo)
require(script.Parent.ObservableQuery_types)

local defaultSubscriptionObserverErrorCallback = nil
local u27 = false
local self = setmetatable({}, {
	__index = Observable
})

function self.__index(p1, p2) -- line: 89
	-- upvalues: self (copy)
	if p2 == "variables" then
		return p1.options.variables
	end

	if rawget(p1, p2) then
		return (rawget(p1, p2))
	end

	if rawget(self, p2) then
		return (rawget(self, p2))
	end

	return getmetatable(self).__index[p2]
end
function self.__newindex(p3, p4, p5) -- line: 103
	if p4 == "variables" then
		error("setting getter-only property 'variables'")
	end

	rawset(p3, p4, p5)
end
function self.new(t2: {[any]: any}) -- line: 110
	-- upvalues: Observable (copy), Boolean (copy), defaultSubscriptionObserverErrorCallback (ref), self (copy), Set (copy), iterateObserversSafely (copy), Object (copy), NetworkStatus (copy), getOperationDefinition (copy)
	local queryManager = t2.queryManager
	local queryInfo = t2.queryInfo
	local options = t2.options
	local u38 = nil

	u38 = setmetatable(Observable.new(function(p6) -- line: 120
		-- upvalues: Boolean (copy), defaultSubscriptionObserverErrorCallback (ref), u38 (ref)
		xpcall(function() -- line: 123
			-- upvalues: p6 (copy), Boolean (copy), defaultSubscriptionObserverErrorCallback (ref)
			local _observer = p6._subscription._observer

			if Boolean.toJSBoolean(_observer) and not Boolean.toJSBoolean(_observer.error) then
				_observer.error = defaultSubscriptionObserverErrorCallback
			end
		end, function() -- line: 128
		end)

		local v104 = Boolean.toJSBoolean(u38.observers.size)

		u38.observers:add(p6)

		if Boolean.toJSBoolean(u38.lastError) then
			if Boolean.toJSBoolean(p6.error) then
				p6:error(u38.lastError)
			end
		elseif Boolean.toJSBoolean(u38.lastResult) and Boolean.toJSBoolean(p6.next) then
			p6:next(u38.lastResult)
		end

		if not v104 then
			u38:reobserve():catch(function() -- line: 151
			end)
		end

		return function() -- line: 154
			-- upvalues: u38 (ref), p6 (copy), Boolean (copy)
			if u38.observers:delete(p6) and not Boolean.toJSBoolean(u38.observers.size) then
				u38:tearDownQuery()
			end
		end
	end), self)
	u38.observers = Set.new()
	u38.subscriptions = Set.new()
	u38.observer = {
		next = function(_, p8) -- line: 167
			-- upvalues: Boolean (copy), u38 (ref), iterateObserversSafely (copy)
			if Boolean.toJSBoolean(u38.lastError) or u38:isDifferentFromLastResult(p8) then
				u38:updateLastResult(p8)
				iterateObserversSafely(u38.observers, "next", p8)
			end
		end,
		error = function(_, p10) -- line: 173
			-- upvalues: u38 (ref), Object (copy), NetworkStatus (copy), iterateObserversSafely (copy)
			u38:updateLastResult((Object.assign({}, u38.lastResult, {
				error = p10,
				errors = p10.graphQLErrors,
				networkStatus = NetworkStatus.error,
				loading = false
			})))
			u38.lastError = p10
			iterateObserversSafely(u38.observers, "error", u38.lastError)
		end
	}
	u38.isTornDown = false
	u38.options = options
	u38.queryId = queryManager:generateQueryId()

	local v39 = getOperationDefinition(options.query)

	if not Boolean.toJSBoolean(v39) then
		u38.queryName = v39
	elseif not Boolean.toJSBoolean(v39.name) then
		u38.queryName = v39.name
	else
		u38.queryName = v39.name.value
	end

	u38.initialFetchPolicy = Boolean.toJSBoolean(options.fetchPolicy) and options.fetchPolicy or "cache-first"
	u38.queryManager = queryManager
	u38.queryInfo = queryInfo

	return u38
end
function self.result(p11) -- line: 215
	-- upvalues: Promise (copy), Boolean (copy), setTimeout (copy)
	return Promise.new(function(resolve, reject) -- line: 216
		-- upvalues: p11 (copy), Boolean (copy), setTimeout (copy)
		local u111 = nil
		local t3 = nil

		t3 = {
			next = function(_, p13) -- line: 225
				-- upvalues: resolve (copy), p11 (copy), t3 (ref), Boolean (copy), setTimeout (copy), u111 (ref)
				resolve(p13)
				p11.observers:delete(t3)

				if not Boolean.toJSBoolean(p11.observers.size) then
					p11.queryManager:removeQuery(p11.queryId)
				end

				setTimeout(function() -- line: 242
					-- upvalues: u111 (ref)
					u111:unsubscribe()
				end, 0)
			end,
			error = function(_, p15) -- line: 246
				-- upvalues: reject (copy)
				reject(p15)
			end
		}
		u111 = p11:subscribe(t3)
	end)
end
function self.getCurrentResult(t4: {[any]: any}, b1: boolean?) -- line: 255
	-- upvalues: Boolean (copy), NetworkStatus (copy), Object (copy), isNetworkRequestInFlight (copy), ApolloError (copy)
	if b1 == nil then
		b1 = true
	end

	local lastResult = t4.lastResult
	local v44 = if t4.options.fetchPolicy ~= nil then t4.options.fetchPolicy else "cache-first"
	local v45 = if not Boolean.toJSBoolean(t4.queryInfo.networkStatus) then if not Boolean.toJSBoolean(lastResult) or not Boolean.toJSBoolean(lastResult.networkStatus) then NetworkStatus.ready else lastResult.networkStatus else t4.queryInfo.networkStatus
	local v46 = Object.assign({}, lastResult, {
		loading = isNetworkRequestInFlight(v45),
		networkStatus = v45
	})

	if not t4.queryManager:transform(t4.options.query).hasForcedResolvers then
		local v47 = t4.queryInfo:getDiff()

		if Boolean.toJSBoolean(v47.complete) or Boolean.toJSBoolean(t4.options.returnPartialData) then
			v46.data = v47.result
		else
			v46.data = nil
		end

		if Boolean.toJSBoolean(v47.complete) then
			if v46.networkStatus == NetworkStatus.loading and (v44 == "cache-first" or v44 == "cache-only") then
				v46.networkStatus = NetworkStatus.ready
				v46.loading = false
			end

			v46.partial = nil
		elseif v44 ~= "no-cache" then
			v46.partial = true
		end

		if not Boolean.toJSBoolean(v47.complete) and not Boolean.toJSBoolean(t4.options.partialRefetch) and not Boolean.toJSBoolean(v46.loading) and not Boolean.toJSBoolean(v46.data) and not Boolean.toJSBoolean(v46.error) then
			v46.error = ApolloError.new({
				clientErrors = v47.missing
			})
		end
	end

	if b1 then
		t4:updateLastResult(v46)
	end

	return v46
end
function self.isDifferentFromLastResult(p16, p17) -- line: 335
	-- upvalues: equal (copy)
	return not equal(p16.lastResultSnapshot, p17)
end
function self.getLastResult(p18) -- line: 341
	return p18.lastResult
end
function self.getLastError(p19) -- line: 345
	return p19.lastError
end
function self.resetLastResults(p20) -- line: 349
	p20.lastResult = nil
	p20.lastResultSnapshot = nil
	p20.lastError = nil
	p20.isTornDown = false
end
function self.resetQueryStoreErrors(p21) -- line: 356
	p21.queryManager:resetErrors(p21.queryId)
end
function self.refetch(p22, p23) -- line: 367
	-- upvalues: Boolean (copy), equal (copy), Object (copy), NetworkStatus (copy)
	local t5 = {
		pollInterval = 0
	}
	local fetchPolicy = p22.options.fetchPolicy

	if fetchPolicy == "no-cache" then
		t5.fetchPolicy = "no-cache"
	elseif fetchPolicy ~= "cache-and-network" then
		t5.fetchPolicy = "network-only"
	end

	if Boolean.toJSBoolean(p23) and not equal(p22.options.variables, p23) then
		p22.options.variables = Object.assign({}, p22.options.variables, p23)
		t5.variables = p22.options.variables
	end

	p22.queryInfo:resetLastWrite()

	return p22:reobserve(t5, NetworkStatus.refetch)
end
function self.fetchMore(p24, p25) -- line: 393
	-- upvalues: Object (copy), Boolean (copy), NetworkStatus (copy), u27 (ref), invariant (copy)
	local v60 = Object.assign({}, (function() -- line: 398
		-- upvalues: Boolean (copy), p25 (copy), Object (copy), p24 (copy)
		if Boolean.toJSBoolean(p25.query) then
			return p25
		end

		return Object.assign({}, p24.options, p25, {
			variables = Object.assign({}, p24.options.variables, p25.variables)
		})
	end)(), {
		fetchPolicy = "no-cache"
	})
	local v61 = p24.queryManager:generateQueryId()

	if Boolean.toJSBoolean(v60.notifyOnNetworkStatusChange) then
		p24.queryInfo.networkStatus = NetworkStatus.fetchMore
		p24:observe()
	end

	return p24.queryManager:fetchQuery(v61, v60, NetworkStatus.fetchMore):andThen(function(p26) -- line: 431
		-- upvalues: p25 (copy), Boolean (copy), u27 (ref), invariant (copy), p24 (copy), v60 (copy)
		local data = p26.data
		local updateQuery = p25.updateQuery

		if Boolean.toJSBoolean(updateQuery) then
			if _G.__DEV__ and (not u27 or not _G.__WARNED_ABOUT_OBSERVABLE_QUERY_UPDATE_QUERY__) then
				invariant.warn("The updateQuery callback for fetchMore is deprecated, and will be removed\nin the next major version of Apollo Client.\n\nPlease convert updateQuery functions to field policies with appropriate\nread and merge functions, or use/adapt a helper function (such as\nconcatPagination, offsetLimitPagination, or relayStylePagination) from\n@apollo/client/utilities.\n\nThe field policy system handles pagination more effectively than a\nhand-written updateQuery function, and you only need to define the policy\nonce, rather than every time you call fetchMore.")
				u27 = true
				_G.__WARNED_ABOUT_OBSERVABLE_QUERY_UPDATE_QUERY__ = u27
			end

			p24:updateQuery(function(p27) -- line: 456
				-- upvalues: updateQuery (copy), p25 (copy), data (copy), v60 (copy)
				return updateQuery(p25, p27, {
					fetchMoreResult = data,
					variables = v60.variables
				})
			end)

			return p26
		end

		p24.queryManager.cache:writeQuery({
			query = v60.query,
			variables = v60.variables,
			data = data
		})

		return p26
	end):andThen(function(p28) -- line: 479
		-- upvalues: p24 (copy), v61 (copy)
		p24.queryManager:stopQuery(v61)
		p24:reobserve()

		return p28
	end):catch(function(p29) -- line: 484
		-- upvalues: p24 (copy), v61 (copy)
		p24.queryManager:stopQuery(v61)
		p24:reobserve()
		error(p29)
	end)
end
function self.subscribeToMore(p30, p31) -- line: 494
	-- upvalues: Boolean (copy), invariant (copy)
	local v64 = p30.queryManager:startGraphQLSubscription({
		query = p31.document,
		variables = p31.variables,
		context = p31.context
	}):subscribe({
		next = function(_, t6: {[any]: any}) -- line: 508
			-- upvalues: p31 (copy), Boolean (copy), p30 (copy)
			local updateQuery = p31.updateQuery

			if Boolean.toJSBoolean(updateQuery) then
				p30:updateQuery(function(p33, p34) -- line: 511
					-- upvalues: updateQuery (copy), t6 (copy)
					local variables = p34.variables

					return updateQuery(p33, {
						subscriptionData = t6,
						variables = variables
					})
				end)
			end
		end,
		error = function(_, p36) -- line: 520
			-- upvalues: Boolean (copy), p31 (copy), invariant (copy)
			if Boolean.toJSBoolean(p31.onError) then
				p31:onError(p36)

				return
			end

			invariant.error("Unhandled GraphQL subscription error", p36)
		end
	})

	p30.subscriptions:add(v64)

	return function() -- line: 531
		-- upvalues: Boolean (copy), p30 (copy), v64 (copy)
		if Boolean.toJSBoolean(p30.subscriptions:delete(v64)) then
			v64:unsubscribe()
		end
	end
end
function self.setOptions(p37, p38) -- line: 538
	return p37:reobserve(p38)
end
function self.setVariables(p39, p40) -- line: 564
	-- upvalues: equal (copy), Boolean (copy), Promise (copy), NetworkStatus (copy)
	if equal(p39.variables, p40) then
		if Boolean.toJSBoolean(p39.observers.size) then
			return p39:result()
		end

		return Promise.resolve()
	end

	p39.options.variables = p40

	if not Boolean.toJSBoolean(p39.observers.size) then
		return Promise.resolve()
	end

	return p39:reobserve({
		fetchPolicy = p39.initialFetchPolicy,
		variables = p40
	}, NetworkStatus.setVariables)
end
function self.updateQuery(t7: {[any]: any}, p41: ((...any) -> ...any)) -- line: 590
	-- upvalues: Boolean (copy)
	local queryManager = t7.queryManager
	local v72 = p41(queryManager.cache:diff({
		returnPartialData = true,
		optimistic = false,
		query = t7.options.query,
		variables = t7.variables,
		previousResult = Boolean.toJSBoolean(t7.lastResult) and t7.lastResult.data or nil
	}).result, {
		variables = t7.variables
	})

	if Boolean.toJSBoolean(v72) then
		queryManager.cache:writeQuery({
			query = t7.options.query,
			data = v72,
			variables = t7.variables
		})
		queryManager:broadcastQueries()
	end
end
function self.startPolling(t8: {[any]: any}, n1: number) -- line: 623
	t8.options.pollInterval = n1
	t8:updatePolling()
end
function self.stopPolling(p42) -- line: 628
	p42.options.pollInterval = 0
	p42:updatePolling()
end
function self.fetch(p43, p44, p45) -- line: 633
	p43.queryManager:setObservableQuery(p43)

	return p43.queryManager:fetchQueryObservable(p43.queryId, p44, p45)
end
function self.updatePolling(p46) -- line: 642
	-- upvalues: Boolean (copy), clearTimeout (copy), invariant (copy), isNetworkRequestInFlight (copy), NetworkStatus (copy), setTimeout (copy)
	local poll = nil

	if Boolean.toJSBoolean(p46.queryManager.ssrMode) then
		return
	end

	local pollingInfo = p46.pollingInfo
	local pollInterval = p46.options.pollInterval

	if not Boolean.toJSBoolean(pollInterval) then
		if Boolean.toJSBoolean(pollingInfo) then
			clearTimeout(pollingInfo.timeout)
			p46.pollingInfo = nil
		end

		return
	end

	if Boolean.toJSBoolean(pollingInfo) and pollInterval == pollingInfo.interval then
		return
	end

	invariant(pollInterval, "Attempted to start a polling query without a polling interval.")

	local g83 = nil

	if Boolean.toJSBoolean(pollingInfo) then
		if pollingInfo then
			g83 = true
		end
	end

	if not g83 then
		p46.pollingInfo = {}
		pollingInfo = p46.pollingInfo
	end

	g83 = false
	pollingInfo.interval = pollInterval

	local function maybeFetch() -- line: 673
		-- upvalues: Boolean (copy), p46 (copy), isNetworkRequestInFlight (copy), NetworkStatus (copy), poll (ref)
		if Boolean.toJSBoolean(p46.pollingInfo) then
			if not isNetworkRequestInFlight(p46.queryInfo.networkStatus) then
				p46:reobserve({
					fetchPolicy = "network-only"
				}, NetworkStatus.poll):andThen(poll, poll)

				return
			end

			poll()
		end
	end

	function poll() -- line: 685
		-- upvalues: p46 (copy), Boolean (copy), clearTimeout (copy), setTimeout (copy), maybeFetch (copy)
		local pollingInfo2 = p46.pollingInfo

		if Boolean.toJSBoolean(pollingInfo2) then
			if pollingInfo2.timeout then
				clearTimeout(pollingInfo2.timeout)
			end

			pollingInfo2.timeout = setTimeout(maybeFetch, pollingInfo2.interval)
		end
	end

	poll()
end
function self.updateLastResult(p47, p48) -- line: 699
	-- upvalues: Boolean (copy), cloneDeep (copy), isNonEmptyArray (copy)
	local lastResult = p47.lastResult

	p47.lastResult = p48

	if Boolean.toJSBoolean(p47.queryManager.assumeImmutableResults) then
		p47.lastResultSnapshot = p48
	else
		p47.lastResultSnapshot = cloneDeep(p48)
	end

	if not isNonEmptyArray(p48.errors) then
		p47.lastError = nil
	end

	return lastResult
end
function self.reobserve(p49, p50, p51) -- line: 715
	-- upvalues: NetworkStatus (copy), compact (copy), Object (copy), Boolean (copy), equal (copy)
	p49.isTornDown = false

	local v91 = p51 == NetworkStatus.refetch or (p51 == NetworkStatus.fetchMore or p51 == NetworkStatus.poll)
	local variables = p49.options.variables
	local v93 = if not v91 then Object.assign(p49.options, compact(p50)) else compact(p49.options, p50)

	if not v91 then
		p49:updatePolling()

		if p50 ~= nil and Boolean.toJSBoolean(p50.variables) and not Boolean.toJSBoolean(p50.fetchPolicy) and not equal(p50.variables, variables) then
			v93.fetchPolicy = p49.initialFetchPolicy

			if p51 == nil then
				p51 = NetworkStatus.setVariables
			end
		end
	end

	local v94 = p49:fetch(v93, p51)

	if not v91 then
		if p49.concast then
			p49.concast:removeObserver(p49.observer, true)
		end

		p49.concast = v94
	end

	v94:addObserver(p49.observer)

	return v94.promise
end
function self.observe(p52) -- line: 785
	p52.observer:next(p52:getCurrentResult(false))
end
function self.hasObservers(p53) -- line: 793
	return p53.observers.size > 0
end
function self.tearDownQuery(p54) -- line: 797
	-- upvalues: Boolean (copy)
	if Boolean.toJSBoolean(p54.isTornDown) then
		return
	end

	if Boolean.toJSBoolean(p54.concast) then
		p54.concast:removeObserver(p54.observer)
		p54.concast = nil
	end

	p54:stopPolling()
	p54.subscriptions:forEach(function(p55) -- line: 809
		return p55:unsubscribe()
	end)
	p54.subscriptions:clear()
	p54.queryManager:stopQuery(p54.queryId)
	p54.observers:clear()
	p54.isTornDown = true
end

fixObservableSubclass(self)
t1.ObservableQuery = self

function defaultSubscriptionObserverErrorCallback(_, p57) -- line: 825
	-- upvalues: invariant (copy)
	invariant.error("Unhandled error", p57.message, p57.stack)
end
function t1.applyNextFetchPolicy(p58) -- line: 833
	-- upvalues: Boolean (copy), isCallable (copy)
	local v101 = if p58.fetchPolicy ~= nil then p58.fetchPolicy else "cache-first"
	local nextFetchPolicy = p58.nextFetchPolicy

	if Boolean.toJSBoolean(nextFetchPolicy) then
		if isCallable(nextFetchPolicy) then
			p58.fetchPolicy = nextFetchPolicy(p58, v101)

			return
		end

		p58.fetchPolicy = nextFetchPolicy
	end
end

return t1
