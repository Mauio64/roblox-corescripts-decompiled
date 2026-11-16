local parent = script.Parent.Parent
local parent2 = parent.Parent

local LuauPolyfill = require(parent2.LuauPolyfill)
local Boolean = LuauPolyfill.Boolean
local Object = LuauPolyfill.Object
local Set = LuauPolyfill.Set
local setTimeout = LuauPolyfill.setTimeout
local clearTimeout = LuauPolyfill.clearTimeout

local isCallable = require(parent.luaUtils.isCallable)

local Promise = require(parent2.Promise)

local invariant = require(parent.jsutils.invariant)
local invariant2 = invariant.invariant
local equal = require(parent.jsutils.equal)

local networkStatus = require(script.Parent.networkStatus)
local networkStatus2 = networkStatus.NetworkStatus

local isNetworkRequestInFlight = networkStatus.isNetworkRequestInFlight

local utilities = require(script.Parent.Parent.utilities)

local compact = utilities.compact
local cloneDeep = utilities.cloneDeep
local getOperationDefinition = utilities.getOperationDefinition
local observable = utilities.Observable

local iterateObserversSafely = utilities.iterateObserversSafely
local isNonEmptyArray = utilities.isNonEmptyArray
local fixObservableSubclass = utilities.fixObservableSubclass

local errors = require(script.Parent.Parent.errors)
local apolloError = errors.ApolloError

require(script.Parent.types)

require(script.Parent.watchQueryOptions_types)

require(script.Parent.QueryInfo)

require(script.Parent.ObservableQuery_types)

local defaultSubscriptionObserverErrorCallback

local v = false

local object = setmetatable({}, { __index = observable })
function object.__index(p, p2)
	if p2 == "variables" then
		return p.options.variables
	end

	if rawget(p, p2) then
		return (rawget(p, p2))
	end

	if rawget(object, p2) then
		return (rawget(object, p2))
	end

	return getmetatable(object).__index[p2]
end

function object.__newindex(p, p2, p3)
	if p2 == "variables" then
		error("setting getter-only property 'variables'")
	end

	rawset(p, p2, p3)
end

function object.new(data)
	local queryManager = data.queryManager
	local queryInfo = data.queryInfo
	local options = data.options
	local v2 = nil
	v2 = setmetatable(observable.new(function(object2)
		xpcall(function()
			local observer = object2._subscription._observer

			if Boolean.toJSBoolean(observer) and not Boolean.toJSBoolean(observer.error) then
				observer.error = defaultSubscriptionObserverErrorCallback
			end
		end, function() end)

		local v3 = not Boolean.toJSBoolean(v2.observers.size)
		v2.observers:add(object2)

		if Boolean.toJSBoolean(v2.lastError) then
			if Boolean.toJSBoolean(object2.error) then
				object2:error(v2.lastError)
			end
		elseif Boolean.toJSBoolean(v2.lastResult) and Boolean.toJSBoolean(object2.next) then
			object2:next(v2.lastResult)
		end

		if v3 then
			v2:reobserve():catch(function() end)
		end

		return function()
			if v2.observers:delete(object2) and not Boolean.toJSBoolean(v2.observers.size) then
				v2:tearDownQuery()
			end
		end
	end), object)

	v2.observers = Set.new()
	v2.subscriptions = Set.new()

	v2.observer = {
		next = function(self, p)
			if Boolean.toJSBoolean(v2.lastError) or v2:isDifferentFromLastResult(p) then
				v2:updateLastResult(p)
				iterateObserversSafely(v2.observers, "next", p)
			end
		end,
		error = function(_, lastError)
			v2:updateLastResult((Object.assign({}, v2.lastResult, {
				["error"] = lastError,
				errors = lastError.graphQLErrors,
				networkStatus = networkStatus2.error,
				loading = false
			})))

			v2.lastError = lastError
			iterateObserversSafely(v2.observers, "error", v2.lastError)
		end
	}

	v2.isTornDown = false

	v2.options = options
	v2.queryId = queryManager:generateQueryId()

	local operationDefinition = getOperationDefinition(options.query)

	if Boolean.toJSBoolean(operationDefinition) then
		if Boolean.toJSBoolean(operationDefinition.name) then
			v2.queryName = operationDefinition.name.value
		else
			v2.queryName = operationDefinition.name
		end
	else
		v2.queryName = operationDefinition
	end

	v2.initialFetchPolicy = Boolean.toJSBoolean(options.fetchPolicy) and options.fetchPolicy or "cache-first"

	v2.queryManager = queryManager
	v2.queryInfo = queryInfo
	return v2
end

function object:result()
	return Promise.new(function(callback, callback2)
		local v2 = nil

		local v3 = nil
		v3 = {
			next = function(_, p)
				callback(p)

				self.observers:delete(v3)

				if not Boolean.toJSBoolean(self.observers.size) then
					self.queryManager:removeQuery(self.queryId)
				end

				setTimeout(function()
					v2:unsubscribe()
				end, 0)
			end,
			error = function(_, p)
				callback2(p)
			end
		}

		v2 = self:subscribe(v3)
	end)
end

function object:getCurrentResult(flag: boolean?)
	local v2 = flag == nil or flag

	local lastResult = self.lastResult

	local v3 = self.options.fetchPolicy == nil and "cache-first" or self.options.fetchPolicy
	local networkStatus3

	if Boolean.toJSBoolean(self.queryInfo.networkStatus) then
		networkStatus3 = self.queryInfo.networkStatus
	elseif Boolean.toJSBoolean(lastResult) and Boolean.toJSBoolean(lastResult.networkStatus) then
		networkStatus3 = lastResult.networkStatus
	else
		networkStatus3 = networkStatus2.ready
	end

	local currentResult = Object.assign({}, lastResult, {
		loading = isNetworkRequestInFlight(networkStatus3),
		networkStatus = networkStatus3
	})

	if not self.queryManager:transform(self.options.query).hasForcedResolvers then
		local diff = self.queryInfo:getDiff()

		if Boolean.toJSBoolean(diff.complete) or Boolean.toJSBoolean(self.options.returnPartialData) then
			currentResult.data = diff.result
		else
			currentResult.data = nil
		end

		if Boolean.toJSBoolean(diff.complete) then
			if
				currentResult.networkStatus == networkStatus2.loading
				and (v3 == "cache-first" or v3 == "cache-only")
			then
				currentResult.networkStatus = networkStatus2.ready
				currentResult.loading = false
			end

			currentResult.partial = nil
		elseif v3 ~= "no-cache" then
			currentResult.partial = true
		end

		if not (Boolean.toJSBoolean(diff.complete) or Boolean.toJSBoolean(self.options.partialRefetch) or Boolean.toJSBoolean(currentResult.loading) or Boolean.toJSBoolean(currentResult.data) or Boolean.toJSBoolean(currentResult.error)) then
			currentResult.error = apolloError.new({ clientErrors = diff.missing })
		end
	end

	if v2 then
		self:updateLastResult(currentResult)
	end

	return currentResult
end

function object:isDifferentFromLastResult(p): boolean
	return not equal(self.lastResultSnapshot, p)
end

function object.getLastResult(p)
	return p.lastResult
end

function object.getLastError(p)
	return p.lastError
end

function object:resetLastResults()
	self.lastResult = nil
	self.lastResultSnapshot = nil
	self.lastError = nil
	self.isTornDown = false
end

function object.resetQueryStoreErrors(p)
	p.queryManager:resetErrors(p.queryId)
end

function object:refetch(p)
	local v2 = { pollInterval = 0 }

	local fetchPolicy = self.options.fetchPolicy

	if fetchPolicy == "no-cache" then
		v2.fetchPolicy = "no-cache"
	elseif fetchPolicy ~= "cache-and-network" then
		v2.fetchPolicy = "network-only"
	end

	if Boolean.toJSBoolean(p) and not equal(self.options.variables, p) then
		self.options.variables = Object.assign({}, self.options.variables, p)
		v2.variables = self.options.variables
	end

	self.queryInfo:resetLastWrite()
	return self:reobserve(v2, networkStatus2.refetch)
end

function object:fetchMore(data)
	local assign = Object.assign
	local v2

	if Boolean.toJSBoolean(data.query) then
		v2 = data
	else
		v2 = Object.assign({}, self.options, data, {
			variables = Object.assign({}, self.options.variables, data.variables)
		})
	end

	local v3 = assign({}, v2, { fetchPolicy = "no-cache" })

	local queryId = self.queryManager:generateQueryId()

	if Boolean.toJSBoolean(v3.notifyOnNetworkStatusChange) then
		self.queryInfo.networkStatus = networkStatus2.fetchMore
		self:observe()
	end

	return self.queryManager:fetchQuery(queryId, v3, networkStatus2.fetchMore):andThen(function(p)
		local data2 = p.data
		local updateQuery = data.updateQuery

		if not Boolean.toJSBoolean(updateQuery) then
			self.queryManager.cache:writeQuery({
				query = v3.query,
				variables = v3.variables,
				data = data2
			})

			return p
		end

		if _G.__DEV__ and not (v and _G.__WARNED_ABOUT_OBSERVABLE_QUERY_UPDATE_QUERY__) then
			invariant2.warn([[
The updateQuery callback for fetchMore is deprecated, and will be removed
in the next major version of Apollo Client.

Please convert updateQuery functions to field policies with appropriate
read and merge functions, or use/adapt a helper function (such as
concatPagination, offsetLimitPagination, or relayStylePagination) from
@apollo/client/utilities.

The field policy system handles pagination more effectively than a
hand-written updateQuery function, and you only need to define the policy
once, rather than every time you call fetchMore.]])

			v = true
			_G.__WARNED_ABOUT_OBSERVABLE_QUERY_UPDATE_QUERY__ = v
		end

		self:updateQuery(function(p2)
			return updateQuery(data, p2, { fetchMoreResult = data2, variables = v3.variables })
		end)
		return p
	end):andThen(function(p)
		self.queryManager:stopQuery(queryId)
		self:reobserve()
		return p
	end):catch(function(message)
		self.queryManager:stopQuery(queryId)
		self:reobserve()
		error(message)
	end)
end

function object:subscribeToMore(object2)
	local v2 = self.queryManager:startGraphQLSubscription({
		query = object2.document,
		variables = object2.variables,
		context = object2.context
	}):subscribe({
		next = function(_, subscriptionData)
			local updateQuery = object2.updateQuery

			if Boolean.toJSBoolean(updateQuery) then
				self:updateQuery(function(p, p2)
					return updateQuery(p, {
						subscriptionData = subscriptionData,
						variables = p2.variables
					})
				end)
			end
		end,
		error = function(_, p)
			if Boolean.toJSBoolean(object2.onError) then
				object2:onError(p)
			else
				invariant2.error("Unhandled GraphQL subscription error", p)
			end
		end
	})

	self.subscriptions:add(v2)

	return function()
		if Boolean.toJSBoolean(self.subscriptions:delete(v2)) then
			v2:unsubscribe()
		end
	end
end

function object:setOptions(p)
	return self:reobserve(p)
end

function object:setVariables(variables)
	if equal(self.variables, variables) then
		if Boolean.toJSBoolean(self.observers.size) then
			return self:result()
		end
	else
		self.options.variables = variables

		if Boolean.toJSBoolean(self.observers.size) then
			return self:reobserve(
				{ fetchPolicy = self.initialFetchPolicy, variables = variables },
				networkStatus2.setVariables
			)
		end
	end

	return Promise.resolve()
end

function object:updateQuery(callback)
	local queryManager = self.queryManager

	local cache = queryManager.cache
	local v2 = {
		query = self.options.query,
		variables = self.variables,
		previousResult = 0,
		returnPartialData = true,
		optimistic = false
	}
	local previousResult

	if Boolean.toJSBoolean(self.lastResult) then
		previousResult = self.lastResult.data or nil
	end

	v2.previousResult = previousResult
	local v3 = callback(cache:diff(v2).result, { variables = self.variables })

	if Boolean.toJSBoolean(v3) then
		queryManager.cache:writeQuery({
			query = self.options.query,
			data = v3,
			variables = self.variables
		})

		queryManager:broadcastQueries()
	end
end

function object:startPolling(pollInterval: number)
	self.options.pollInterval = pollInterval
	self:updatePolling()
end

function object:stopPolling()
	self.options.pollInterval = 0
	self:updatePolling()
end

function object:fetch(p, p2)
	self.queryManager:setObservableQuery(self)
	return self.queryManager:fetchQueryObservable(self.queryId, p, p2)
end

function object:updatePolling()
	local poll

	if Boolean.toJSBoolean(self.queryManager.ssrMode) then
		return
	end

	local pollingInfo = self.pollingInfo
	local pollInterval = self.options.pollInterval

	if Boolean.toJSBoolean(pollInterval) then
		if Boolean.toJSBoolean(pollingInfo) and pollingInfo.interval == pollInterval then
			return
		end

		invariant2(pollInterval, "Attempted to start a polling query without a polling interval.")

		if not (Boolean.toJSBoolean(pollingInfo) and pollingInfo) then
			self.pollingInfo = {}
			pollingInfo = self.pollingInfo
		end

		pollingInfo.interval = pollInterval

		local function maybeFetch()
			if Boolean.toJSBoolean(self.pollingInfo) then
				if isNetworkRequestInFlight(self.queryInfo.networkStatus) then
					poll()
				else
					self:reobserve({ fetchPolicy = "network-only" }, networkStatus2.poll):andThen(poll, poll)
				end
			end
		end

		poll = function()
			local pollingInfo2 = self.pollingInfo

			if Boolean.toJSBoolean(pollingInfo2) then
				if pollingInfo2.timeout then
					clearTimeout(pollingInfo2.timeout)
				end

				pollingInfo2.timeout = setTimeout(maybeFetch, pollingInfo2.interval)
			end
		end

		poll()
	elseif Boolean.toJSBoolean(pollingInfo) then
		clearTimeout(pollingInfo.timeout)
		self.pollingInfo = nil
	end
end

function object:updateLastResult(p)
	local lastResult = self.lastResult
	self.lastResult = p

	if Boolean.toJSBoolean(self.queryManager.assumeImmutableResults) then
		self.lastResultSnapshot = p
	else
		self.lastResultSnapshot = cloneDeep(p)
	end

	if not isNonEmptyArray(p.errors) then
		self.lastError = nil
	end

	return lastResult
end

function object:reobserve(p, p2)
	self.isTornDown = false

	local v2 = p2 == networkStatus2.refetch or p2 == networkStatus2.fetchMore or p2 == networkStatus2.poll

	local variables = self.options.variables
	local v3

	if v2 then
		v3 = compact(self.options, p)
	else
		v3 = Object.assign(self.options, compact(p))
	end

	if not v2 then
		self:updatePolling()

		if
			p ~= nil
			and Boolean.toJSBoolean(p.variables)
			and not (Boolean.toJSBoolean(p.fetchPolicy) or equal(p.variables, variables))
		then
			v3.fetchPolicy = self.initialFetchPolicy

			if p2 == nil then
				p2 = networkStatus2.setVariables
			end
		end
	end

	local fetched = self:fetch(v3, p2)

	if not v2 then
		if self.concast then
			self.concast:removeObserver(self.observer, true)
		end

		self.concast = fetched
	end

	fetched:addObserver(self.observer)

	return fetched.promise
end

function object:observe()
	self.observer:next(self:getCurrentResult(false))
end

function object.hasObservers(p): boolean
	return p.observers.size > 0
end

function object:tearDownQuery()
	if Boolean.toJSBoolean(self.isTornDown) then
		return
	end

	if Boolean.toJSBoolean(self.concast) then
		self.concast:removeObserver(self.observer)
		self.concast = nil
	end

	self:stopPolling()

	self.subscriptions:forEach(function(object2)
		return object2:unsubscribe()
	end)

	self.subscriptions:clear()
	self.queryManager:stopQuery(self.queryId)
	self.observers:clear()
	self.isTornDown = true
end

fixObservableSubclass(object)
local ObservableQuery = {}
ObservableQuery.ObservableQuery = object

defaultSubscriptionObserverErrorCallback = function(_, p)
	invariant2.error("Unhandled error", p.message, p.stack)
end

function ObservableQuery:applyNextFetchPolicy()
	local v2 = self.fetchPolicy == nil and "cache-first" or self.fetchPolicy

	local nextFetchPolicy = self.nextFetchPolicy

	if Boolean.toJSBoolean(nextFetchPolicy) then
		if isCallable(nextFetchPolicy) then
			self.fetchPolicy = nextFetchPolicy(self, v2)
		else
			self.fetchPolicy = nextFetchPolicy
		end
	end
end

return ObservableQuery
