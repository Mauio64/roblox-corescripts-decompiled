local QueryManager = {}

local parent = script.Parent.Parent
local parent2 = parent.Parent

local LuauPolyfill = require(parent2.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local instanceof = LuauPolyfill.instanceof
local Map = LuauPolyfill.Map
local Object = LuauPolyfill.Object
local Set = LuauPolyfill.Set
local WeakMap = LuauPolyfill.WeakMap

local Promise = require(parent2.Promise)
local HttpService = game:GetService("HttpService")

local isCallable = require(parent.luaUtils.isCallable)
local null = require(parent.utilities.globals.null)
local toJSBoolean = null.toJSBoolean

require(parent2.GraphQL)

local invariant = require(parent.jsutils.invariant)
local invariant2 = invariant.invariant
local invariantError = invariant.InvariantError
local equal = require(parent.jsutils.equal)

local core = require(script.Parent.Parent.link.core)

local execute = core.execute

local cache = require(script.Parent.Parent.cache)

local canonicalStringify = cache.canonicalStringify

local utilities = require(script.Parent.Parent.utilities)
local getDefaultValues = utilities.getDefaultValues
local getOperationDefinition = utilities.getOperationDefinition
local getOperationName = utilities.getOperationName
local hasClientExports = utilities.hasClientExports
local graphQLResultHasError = utilities.graphQLResultHasError
local removeConnectionDirectiveFromDocument = utilities.removeConnectionDirectiveFromDocument
local canUseWeakMap = utilities.canUseWeakMap

local observable = utilities.Observable

local asyncMap = utilities.asyncMap
local isNonEmptyArray = utilities.isNonEmptyArray
local concast = utilities.Concast

local makeUniqueId = utilities.makeUniqueId
local isDocumentNode = utilities.isDocumentNode
local isNonNullObject = utilities.isNonNullObject
local errors = require(script.Parent.Parent.errors)
local apolloError = errors.ApolloError

local isApolloError = errors.isApolloError
require(script.Parent.watchQueryOptions_types)

local ObservableQuery = require(script.Parent.ObservableQuery)
require(script.Parent.ObservableQuery_types)
local observableQuery = ObservableQuery.ObservableQuery

local applyNextFetchPolicy = ObservableQuery.applyNextFetchPolicy
local networkStatus = require(script.Parent.networkStatus)
local networkStatus2 = networkStatus.NetworkStatus

local isNetworkRequestInFlight = networkStatus.isNetworkRequestInFlight
require(script.Parent.types)

local LocalState = require(script.Parent.LocalState)
local localState = LocalState.LocalState

local QueryInfo = require(script.Parent.QueryInfo)
local queryInfo = QueryInfo.QueryInfo

local shouldWriteResult = QueryInfo.shouldWriteResult
local CacheWriteBehavior = QueryInfo.CacheWriteBehavior

local hasOwnProperty = require(parent.luaUtils.hasOwnProperty)

local class = {}
class.__index = class

function class.new(data)
	local cache2 = data.cache
	local link = data.link
	local queryDeduplication = data.queryDeduplication
	local onBroadcast = data.onBroadcast
	local ssrMode = data.ssrMode
	local clientAwareness = data.clientAwareness
	local localState2 = data.localState
	local assumeImmutableResults = data.assumeImmutableResults

	if queryDeduplication == nil then
		queryDeduplication = false
	end

	if ssrMode == nil then
		ssrMode = false
	end

	local clientAwareness2 = clientAwareness == nil and {} or clientAwareness

	local object = setmetatable({}, class)

	object.clientAwareness = {}

	object.queries = Map.new()

	object.fetchCancelFns = Map.new()

	object.transformCache = WeakMap.new()

	object.queryIdCounter = 1
	object.requestIdCounter = 1
	object.mutationIdCounter = 1
	object.inFlightLinkObservables = Map.new()

	object.cache = cache2
	object.link = link
	object.queryDeduplication = queryDeduplication
	object.clientAwareness = clientAwareness2
	object.localState = localState2 or localState.new({ cache = cache2 })
	object.ssrMode = ssrMode
	object.assumeImmutableResults = Boolean.toJSBoolean(assumeImmutableResults)
	object.onBroadcast = onBroadcast

	if Boolean.toJSBoolean(object.onBroadcast) then
		object.mutationStore = {}
	end

	return object
end

function class:stop()
	self.queries:forEach(function(_, p)
		self:stopQueryNoBroadcast(p)
	end)

	self:cancelPendingFetches(invariantError.new("QueryManager stopped while query was in flight"))
end

function class:cancelPendingFetches(p)
	self.fetchCancelFns:forEach(function(callback)
		return callback(p)
	end)

	self.fetchCancelFns:clear()
end

function class:mutate(data)
	return Promise.resolve():andThen(function()
		local mutation = data.mutation
		local variables = data.variables
		local optimisticResponse = data.optimisticResponse
		local updateQueries = data.updateQueries
		local refetchQueries = data.refetchQueries
		local awaitRefetchQueries = data.awaitRefetchQueries
		local update = data.update
		local onQueryUpdated = data.onQueryUpdated
		local errorPolicy = data.errorPolicy
		local fetchPolicy = data.fetchPolicy
		local keepRootFields = data.keepRootFields
		local context = data.context

		local refetchQueries2 = refetchQueries == nil and {} or refetchQueries

		if awaitRefetchQueries == nil then
			awaitRefetchQueries = false
		end

		local errorPolicy2 = errorPolicy == nil and "none" or errorPolicy

		invariant2(
			mutation,
			"mutation option is required. You must specify your GraphQL document in the mutation option."
		)

		invariant2(
			not Boolean.toJSBoolean(fetchPolicy) or fetchPolicy == "no-cache",
			"Mutations only support a 'no-cache' fetchPolicy. If you don't want to disable the cache, remove your fetchPolicy setting to proceed with the default mutation behavior."
		)

		local mutationId = self:generateMutationId()
		local document = self:transform(mutation).document

		local variables2 = self:getVariables(document, variables)

		if self:transform(document).hasClientExports then
			variables2 = self.localState:addExportedVariables(document, variables2, context):expect()
		end

		local v

		if Boolean.toJSBoolean(self.mutationStore) then
			self.mutationStore[mutationId] = {
				mutation = document,
				variables = variables2,
				loading = true,
				error = nil
			}

			v = self.mutationStore[mutationId]
		else
			v = self.mutationStore
		end

		if Boolean.toJSBoolean(optimisticResponse) then
			self:markMutationOptimistic(optimisticResponse, {
				mutationId = mutationId,
				document = document,
				variables = variables2,
				fetchPolicy = fetchPolicy,
				errorPolicy = errorPolicy2,
				context = context,
				updateQueries = updateQueries,
				update = update,
				keepRootFields = keepRootFields
			})
		end

		self:broadcastQueries()

		local v2 = self

		return Promise.new(function(callback, callback2)
			return asyncMap(
				self:getObservableFromLink(
					document,
					Object.assign({}, context, { optimisticResponse = optimisticResponse }),
					variables2,
					false
				),
				function(p)
					if graphQLResultHasError(p) and errorPolicy2 == "none" then
						error(apolloError.new({ graphQLErrors = p.errors }))
					end

					if Boolean.toJSBoolean(v) then
						v.loading = false
						v.error = nil
					end

					local v3 = Object.assign({}, p)

					if isCallable(refetchQueries2) then
						refetchQueries2 = refetchQueries2(v3)
					end

					if errorPolicy2 == "ignore" and graphQLResultHasError(v3) then
						v3.errors = nil
					end

					return self:markMutationResult({
						mutationId = mutationId,
						result = v3,
						document = document,
						variables = variables2,
						fetchPolicy = fetchPolicy,
						errorPolicy = errorPolicy2,
						context = context,
						update = update,
						updateQueries = updateQueries,
						awaitRefetchQueries = awaitRefetchQueries,
						refetchQueries = refetchQueries2,
						removeOptimistic = Boolean.toJSBoolean(optimisticResponse) and mutationId or nil,
						onQueryUpdated = onQueryUpdated,
						keepRootFields = keepRootFields
					})
				end
			):subscribe({
				next = function(_, p)
					v2:broadcastQueries()

					callback(p)
				end,
				error = function(_, err)
					if Boolean.toJSBoolean(v) then
						v.loading = false
						v.error = err
					end

					if Boolean.toJSBoolean(optimisticResponse) then
						v2.cache:removeOptimistic(mutationId)
					end

					v2:broadcastQueries()

					callback2(instanceof(err, apolloError) and err or apolloError.new({
						networkError = err
					}))
				end
			})
		end)
	end)
end

function class:markMutationResult(data, object)
	if object == nil then
		object = self.cache
	end

	local result = data.result
	local v = {}
	local v2 = data.fetchPolicy == "no-cache"

	if not v2 then
		local v3 = result

		if shouldWriteResult(v3, data.errorPolicy) then
			table.insert(v, {
				result = result.data,
				dataId = "ROOT_MUTATION",
				query = data.document,
				variables = data.variables
			})

			local updateQueries = data.updateQueries

			if updateQueries ~= nil then
				self.queries:forEach(function(p, p2)
					local v4 = p.observableQuery

					if Boolean.toJSBoolean(v4) then
						v4 = v4.queryName
					end

					if not (Boolean.toJSBoolean(v4) and hasOwnProperty(updateQueries, v4)) then
						return
					end

					local updateQuery = updateQueries[v4]
					local v5 = self.queries:get(p2)
					local document = v5.document
					local variables = v5.variables

					local diff = object:diff({
						query = document,
						variables = variables,
						returnPartialData = true,
						optimistic = false
					})

					local result2 = diff.result

					if diff.complete and Boolean.toJSBoolean(result2) then
						local v6 = { mutationResult = result, queryName = 0, queryVariables = 0 }
						local queryName

						if Boolean.toJSBoolean(document) then
							queryName = getOperationName(document)

							if not Boolean.toJSBoolean(queryName) then
								queryName = nil
							end
						end

						v6.queryName = queryName

						v6.queryVariables = variables
						local v7 = updateQuery(updateQueries, result2, v6)

						if Boolean.toJSBoolean(v7) then
							table.insert(v, {
								result = v7,
								dataId = "ROOT_QUERY",
								query = document,
								variables = variables
							})
						end
					end
				end)
			end
		end
	end

	if
		#v > 0
		or Boolean.toJSBoolean(data.refetchQueries)
		or Boolean.toJSBoolean(data.update)
		or Boolean.toJSBoolean(data.onQueryUpdated)
		or Boolean.toJSBoolean(data.removeOptimistic)
	then
		local v3 = {}

		local v4 = {
			updateCache = function(_, object2)
				if not v2 then
					Array.forEach(v, function(p)
						return object2:write(p)
					end)
				end

				local update = data.update

				if update ~= nil and Boolean.toJSBoolean(update) then
					if not v2 then
						local diff = object2:diff({
							id = "ROOT_MUTATION",
							query = self:transform(data.document).asQuery,
							variables = data.variables,
							optimistic = false,
							returnPartialData = true
						})

						if diff.complete then
							result = Object.assign({}, result, { data = diff.result })
						end
					end

					update(data, object2, result, {
						context = data.context,
						variables = data.variables
					})
				end

				if not (v2 or data.keepRootFields) then
					object2:modify({
						id = "ROOT_MUTATION",
						fields = function(_, p, p2)
							local fieldName = p2.fieldName
							local delete = p2.DELETE

							if fieldName == "__typename" then
								return p
							end

							return delete
						end
					})
				end
			end,
			include = data.refetchQueries,
			optimistic = false,
			removeOptimistic = data.removeOptimistic,
			onQueryUpdated = 0
		}
		local onQueryUpdated

		if Boolean.toJSBoolean(data.onQueryUpdated) then
			onQueryUpdated = data.onQueryUpdated or nil
		end

		v4.onQueryUpdated = onQueryUpdated
		self:refetchQueries(v4):forEach(function(p)
			return table.insert(v3, p)
		end)

		if data.awaitRefetchQueries or Boolean.toJSBoolean(data.onQueryUpdated) then
			return Promise.all(Array.filter(v3, toJSBoolean)):andThen(function()
				return result
			end)
		end
	end

	return Promise.resolve(result)
end

function class:markMutationOptimistic(callback, p)
	if isCallable(callback) then
		callback = callback(p.variables)
	end

	return self.cache:recordOptimisticTransaction(function(p2)
		local success, result = pcall(function()
			self:markMutationResult(Object.assign({}, p, {
				result = { data = callback }
			}), p2)
		end)

		if not success then
			invariant2.error(result)
		end
	end, p.mutationId)
end

function class:fetchQuery(p: string, p2, p3)
	return self:fetchQueryObservable(p, p2, p3).promise
end

function class.getQueryStore(p)
	local queryStore = {}
	p.queries:forEach(function(data, p2)
		queryStore[p2] = {
			variables = data.variables,
			networkStatus = data.networkStatus,
			networkError = data.networkError,
			graphQLErrors = data.graphQLErrors
		}
	end)
	return queryStore
end

function class.resetErrors(p, p2: string)
	local v = p.queries:get(p2)

	if Boolean.toJSBoolean(v) then
		v.networkError = nil
		v.graphQLErrors = {}
	end
end

function class:transform(p)
	local transformCache = self.transformCache

	if not transformCache:has(p) then
		local transformDocument = self.cache:transformDocument(p)
		local serverQuery = removeConnectionDirectiveFromDocument(self.cache:transformForLink(transformDocument))

		local clientQuery = self.localState:clientQuery(transformDocument)

		if Boolean.toJSBoolean(serverQuery) then
			serverQuery = self.localState:serverQuery(serverQuery)
		end

		local v = {
			document = transformDocument,
			hasClientExports = hasClientExports(transformDocument),
			hasForcedResolvers = self.localState:shouldForceResolvers(transformDocument),
			clientQuery = clientQuery,
			serverQuery = serverQuery,
			defaultVars = getDefaultValues(getOperationDefinition(transformDocument)),
			asQuery = Object.assign({}, transformDocument, {
				definitions = Array.map(transformDocument.definitions, function(p2)
					if p2.kind == "OperationDefinition" and p2.operation ~= "query" then
						return (Object.assign({}, p2, { operation = "query" }))
					end

					return p2
				end)
			})
		}

		local function add(p2) -- 4 equivalent calls inferred from this helper
			if p2 ~= nil and not transformCache:has(p2) then
				transformCache:set(p2, v)
			end
		end

		add(p) -- inferred equivalent call
		add(transformDocument) -- inferred equivalent call
		add(clientQuery) -- inferred equivalent call
		add(serverQuery) -- inferred equivalent call
	end

	return transformCache:get(p)
end

function class:getVariables(p, p2)
	return Object.assign({}, self:transform(p).defaultVars, p2)
end

function class:watchQuery(p)
	local options = Object.assign({}, p, {
		variables = self:getVariables(p.query, p.variables)
	})

	if typeof(options.notifyOnNetworkStatusChange) == "nil" then
		options.notifyOnNetworkStatusChange = false
	end

	local queryInfo2 = queryInfo.new(self.cache)
	local observableQuery2 = observableQuery.new({
		queryManager = self,
		queryInfo = queryInfo2,
		options = options
	})

	self.queries:set(observableQuery2.queryId, queryInfo2)

	queryInfo2:init({
		document = options.query,
		observableQuery = observableQuery2,
		variables = options.variables
	})

	return observableQuery2
end

function class:query(data, p: string?)
	if p == nil then
		p = self:generateQueryId()
	end

	invariant2(data.query, "query option is required. You must specify your GraphQL document in the query option.")

	invariant2(data.query.kind == "Document", "You must wrap the query string in a \"gql\" tag.")

	invariant2(
		not Boolean.toJSBoolean(data.returnPartialData),
		"returnPartialData option only supported on watchQuery."
	)

	invariant2(not Boolean.toJSBoolean(data.pollInterval), "pollInterval option only supported on watchQuery.")

	return self:fetchQuery(p, data):andThen(function(p2)
		self:stopQuery(p)
		return p2
	end):catch(function(message)
		self:stopQuery(p)
		error(message)
	end)
end

function class:generateQueryId()
	local queryIdCounter = self.queryIdCounter
	self.queryIdCounter += 1
	return (tostring(queryIdCounter))
end

function class:generateRequestId()
	local requestIdCounter = self.requestIdCounter
	self.requestIdCounter += 1
	return requestIdCounter
end

function class:generateMutationId()
	local mutationIdCounter = self.mutationIdCounter
	self.mutationIdCounter += 1
	return (tostring(mutationIdCounter))
end

function class:stopQueryInStore(p: string)
	self:stopQueryInStoreNoBroadcast(p)
	self:broadcastQueries()
end

function class:stopQueryInStoreNoBroadcast(p: string)
	local v = self.queries:get(p)

	if Boolean.toJSBoolean(v) then
		v:stop()
	end
end

function class:clearStore()
	self:cancelPendingFetches(invariantError.new("Store reset while query was in flight (not completed in link chain)"))

	self.queries:forEach(function(object, _)
		if Boolean.toJSBoolean(object.observableQuery) then
			object.networkStatus = networkStatus2.loading
		else
			object:stop()
		end
	end)

	if Boolean.toJSBoolean(self.mutationStore) then
		self.mutationStore = {}
	end

	return self.cache:reset()
end

function class:resetStore()
	return self:clearStore():andThen(function()
		return self:reFetchObservableQueries()
	end)
end

function class:getObservableQueries(p)
	local v = p == nil and "active" or p

	local observableQueries = Map.new(nil)

	local v2 = Map.new(nil)

	local v3 = Set.new()

	if Array.isArray(v) then
		Array.forEach(v, function(value)
			if typeof(value) == "string" then
				v2:set(value, false)
			elseif isDocumentNode(value) then
				v2:set(self:transform(value).document, false)
			elseif isNonNullObject(value) and Boolean.toJSBoolean(value.query) then
				v3:add(value)
			end
		end)
	end

	self.queries:forEach(function(p2, p3)
		local observableQuery2 = p2.observableQuery
		local document = p2.document

		if Boolean.toJSBoolean(observableQuery2) then
			if v == "all" then
				observableQueries:set(p3, observableQuery2)
				return
			end

			local queryName = observableQuery2.queryName

			if observableQuery2.options.fetchPolicy == "standby" or not observableQuery2:hasObservers() then
				return
			end

			if
				v == "active"
				or Boolean.toJSBoolean(queryName) and v2:has(queryName)
				or Boolean.toJSBoolean(document) and v2:has(document)
			then
				observableQueries:set(p3, observableQuery2)

				if Boolean.toJSBoolean(queryName) then
					v2:set(queryName, true)
				end

				if Boolean.toJSBoolean(document) then
					v2:set(document, true)
				end
			end
		end
	end)

	if Boolean.toJSBoolean(v3.size) then
		for _, v4 in v3 do
			local uniqueId = makeUniqueId("legacyOneTimeQuery")
			local queryInfo2 = self:getQuery(uniqueId):init({
				document = v4.query,
				variables = v4.variables
			})

			local v5 = observableQuery.new({
				queryManager = self,
				queryInfo = queryInfo2,
				options = Object.assign({}, v4, { fetchPolicy = "network-only" })
			})

			queryInfo2:setObservableQuery(v5)
			observableQueries:set(uniqueId, v5)
		end
	end

	if _G.__DEV__ and Boolean.toJSBoolean(v2.size) then
		v2:forEach(function(p2, value)
			if not p2 then
				invariant2.warn(("Unknown query %s%s requested in refetchQueries options.include array"):format(
					typeof(value) == "string" and "named " or "",
					HttpService:JSONEncode(value)
				))
			end
		end)
	end

	return observableQueries
end

function class:reFetchObservableQueries(flag: boolean?)
	if flag == nil then
		flag = false
	end

	local v = {}

	self:getObservableQueries(Boolean.toJSBoolean(flag) and "all" or "active"):forEach(function(object, p)
		local fetchPolicy = object.options.fetchPolicy
		object:resetLastResults()

		if Boolean.toJSBoolean(flag) or fetchPolicy ~= "standby" and fetchPolicy ~= "cache-only" then
			table.insert(v, object:refetch())
		end

		self:getQuery(p):setDiff(nil)
	end)

	self:broadcastQueries()

	return Promise.all(Array.filter(v, toJSBoolean))
end

function class:setObservableQuery(p)
	self:getQuery(p.queryId):setObservableQuery(p)
end

function class:startGraphQLSubscription(data)
	local query = data.query
	local fetchPolicy = data.fetchPolicy
	local errorPolicy = data.errorPolicy
	local variables = data.variables
	local context = data.context
	local v = data.context == nil and {} or context

	local document = self:transform(query).document
	local variables2 = self:getVariables(document, variables)

	local function makeObservable(variables3)
		return self:getObservableFromLink(document, v, variables3):map(function(p)
			if fetchPolicy ~= "no-cache" then
				if shouldWriteResult(p, errorPolicy) then
					self.cache:write({
						query = document,
						result = p.data,
						dataId = "ROOT_SUBSCRIPTION",
						variables = variables3
					})
				end

				self:broadcastQueries()
			end

			if graphQLResultHasError(p) then
				error(apolloError.new({ graphQLErrors = p.errors }))
			end

			return p
		end)
	end

	if not self:transform(document).hasClientExports then
		return makeObservable(variables2)
	end

	local v2 = self.localState:addExportedVariables(document, variables2, v):andThen(makeObservable)

	return observable.new(function(p)
		local v3 = nil
		v2:andThen(function(object)
			v3 = object:subscribe(p)
			return v3
		end, p.error)
		return function()
			if v3 == nil then
				return v3
			end

			return v3:unsubscribe()
		end
	end)
end

function class:stopQuery(p: string)
	self:stopQueryNoBroadcast(p)
	self:broadcastQueries()
end

function class:stopQueryNoBroadcast(p: string)
	self:stopQueryInStoreNoBroadcast(p)
	self:removeQuery(p)
end

function class:removeQuery(p: string)
	self.fetchCancelFns:delete(p)
	self:getQuery(p):stop()
	self.queries:delete(p)
end

function class:broadcastQueries()
	if Boolean.toJSBoolean(self.onBroadcast) then
		self:onBroadcast()
	end

	self.queries:forEach(function(object, _)
		return object:notify()
	end)
end

function class.getLocalState(p)
	return p.localState
end

function class:getObservableFromLink(p, p2, variables, flag: boolean?)
	if flag == nil then
		if Boolean.toJSBoolean(p2) then
			if p2.queryDeduplication == nil then
				flag = self.queryDeduplication
			else
				flag = p2.queryDeduplication
			end
		else
			flag = self.queryDeduplication
		end
	end

	local serverQuery = self:transform(p).serverQuery
	local context, observable2

	if Boolean.toJSBoolean(serverQuery) then
		local inFlightLinkObservables = self.inFlightLinkObservables
		local link = self.link

		local v = { query = serverQuery, variables = variables, operationName = 0, context = 0 }
		local operationName

		if Boolean.toJSBoolean(getOperationName(serverQuery)) then
			operationName = getOperationName(serverQuery) or nil
		end

		v.operationName = operationName
		v.context = self:prepareContext(Object.assign({}, p2, {
			forceFetch = not flag
		}))

		context = v.context

		if flag then
			local v2 = inFlightLinkObservables:get(serverQuery)
			local v3 = Boolean.toJSBoolean(v2) and v2 or Map.new(nil)
			inFlightLinkObservables:set(serverQuery, v3)

			local v4 = canonicalStringify(variables)
			observable2 = v3:get(v4)

			if not Boolean.toJSBoolean(observable2) then
				observable2 = concast.new({ (execute(link, v)) })

				v3:set(v4, observable2)

				observable2:cleanup(function()
					if Boolean.toJSBoolean(v3:delete(v4)) and v3.size < 1 then
						inFlightLinkObservables:delete(serverQuery)
					end
				end)
			end
		else
			observable2 = concast.new({ (execute(link, v)) })
		end
	else
		observable2 = concast.new({ observable.of({ data = {} }) })

		context = self:prepareContext(p2)
	end

	local clientQuery = self:transform(p).clientQuery

	if toJSBoolean(clientQuery) then
		observable2 = asyncMap(observable2, function(remoteResult)
			return self.localState:runResolvers({
				document = clientQuery,
				remoteResult = remoteResult,
				context = context,
				variables = variables
			})
		end)
	end

	return observable2
end

function class:getResultsFromLink(object, p, data)
	object.lastRequestId = self:generateRequestId()
	local lastRequestId = object.lastRequestId

	return asyncMap(self:getObservableFromLink(object.document, data.context, data.variables), function(p2)
		local nonEmptyArray = isNonEmptyArray(p2.errors)

		if lastRequestId >= object.lastRequestId then
			if nonEmptyArray and data.errorPolicy == "none" then
				error(object:markError(apolloError.new({ graphQLErrors = p2.errors })))
			end

			object:markResult(p2, data, p)
			object:markReady()
		end

		local v = {
			data = p2.data,
			loading = false,
			networkStatus = Boolean.toJSBoolean(object.networkStatus) and object.networkStatus or networkStatus2.ready
		}

		if nonEmptyArray and data.errorPolicy ~= "ignore" then
			v.errors = p2.errors
		end

		return v
	end, function(message)
		if not isApolloError(message) then
			message = apolloError.new({ networkError = message })
		end

		if lastRequestId >= object.lastRequestId then
			object:markError(message)
		end

		error(message)
	end)
end

function class:fetchQueryObservable(p: string, data, p2)
	if p2 == nil then
		p2 = networkStatus2.loading
	end

	local document = self:transform(data.query).document
	local variables = self:getVariables(document, data.variables)
	local query = self:getQuery(p)

	local fetchPolicy = data.fetchPolicy
	local errorPolicy = data.errorPolicy
	local returnPartialData = data.returnPartialData
	local notifyOnNetworkStatusChange = data.notifyOnNetworkStatusChange
	local context = data.context

	local fetchPolicy2 = fetchPolicy == nil and "cache-first" or fetchPolicy

	local errorPolicy2 = errorPolicy == nil and "none" or errorPolicy

	if returnPartialData == nil then
		returnPartialData = false
	end

	if notifyOnNetworkStatusChange == nil then
		notifyOnNetworkStatusChange = false
	end

	local context2 = context == nil and {} or context

	local v = Object.assign({}, data, {
		query = document,
		variables = variables,
		fetchPolicy = fetchPolicy2,
		errorPolicy = errorPolicy2,
		returnPartialData = returnPartialData,
		notifyOnNetworkStatusChange = notifyOnNetworkStatusChange,
		context = context2
	})

	local function fromVariables(variables2)
		v.variables = variables2
		return self:fetchQueryByPolicy(query, v, p2)
	end

	local queryObservable = nil

	self.fetchCancelFns:set(p, function(p3)
		Promise.delay(0):andThen(function()
			return queryObservable:cancel(p3)
		end)
	end)

	queryObservable = concast.new((function()
		if self:transform(v.query).hasClientExports then
			return self.localState:addExportedVariables(v.query, v.variables, v.context):andThen(fromVariables)
		end

		return fromVariables(v.variables)
	end)())

	queryObservable:cleanup(function()
		self.fetchCancelFns:delete(p)
		applyNextFetchPolicy(data)
	end)

	return queryObservable
end

function class:refetchQueries(data)
	local updateCache = data.updateCache
	local include = data.include
	local v = data.optimistic
	local removeOptimistic = data.removeOptimistic
	local onQueryUpdated = data.onQueryUpdated

	if v == nil then
		v = false
	end

	if removeOptimistic == nil then
		if Boolean.toJSBoolean(v) then
			removeOptimistic = makeUniqueId("refetchQueries")
		else
			removeOptimistic = nil
		end
	end

	local v2 = Map.new(nil)

	if Boolean.toJSBoolean(include) then
		self:getObservableQueries(include):forEach(function(oq, p)
			v2:set(p, { oq = oq, lastDiff = self:getQuery(p):getDiff() })
		end)
	end

	local v3 = Map.new(nil)

	if Boolean.toJSBoolean(updateCache) then
		local cache2 = self.cache
		local optimistic

		if v and Boolean.toJSBoolean(removeOptimistic) then
			optimistic = removeOptimistic
		else
			optimistic = false
		end

		cache2:batch({
			update = updateCache,
			optimistic = optimistic,
			removeOptimistic = removeOptimistic,
			onWatchUpdated = function(_, p, diff, lastDiff): nil | boolean
				local oq

				if instanceof(p.watcher, queryInfo) then
					oq = p.watcher.observableQuery
				else
					oq = instanceof(p.watcher, queryInfo)
				end

				if not Boolean.toJSBoolean(oq) then
					return nil
				end

				if onQueryUpdated then
					v2:delete(oq.queryId)

					local v4 = onQueryUpdated(data, oq, diff, lastDiff)

					if v4 == true then
						v4 = oq:refetch()
					end

					if v4 ~= false then
						v3:set(oq, v4)
					end

					return false
				elseif onQueryUpdated then
					v2:set(oq.queryId, { oq = oq, lastDiff = lastDiff, diff = diff })
				end

				return nil
			end
		})
	end

	if Boolean.toJSBoolean(v2.size) then
		v2:forEach(function(data2, value: string)
			local oq = data2.oq
			local lastDiff = data2.lastDiff
			local v4 = data2.diff
			local v5

			if onQueryUpdated ~= nil then
				if v4 == nil then
					local queryInfo2 = oq.queryInfo
					queryInfo2:reset()
					v4 = queryInfo2:getDiff()
				end

				v5 = onQueryUpdated(data, oq, v4, lastDiff)
			end

			if onQueryUpdated == nil or v5 == true then
				v5 = oq:refetch()
			end

			if v5 ~= false then
				v3:set(oq, v5)
			end

			local v6 = string.find(value, "legacyOneTimeQuery")

			if v6 ~= nil and v6 >= 1 then
				self:stopQueryNoBroadcast(value)
			end
		end)
	end

	if Boolean.toJSBoolean(removeOptimistic) then
		self.cache:removeOptimistic(removeOptimistic)
	end

	return v3
end

function class:fetchQueryByPolicy(object, data, networkStatus4)
	local query = data.query
	local variables = data.variables
	local fetchPolicy = data.fetchPolicy
	local refetchWritePolicy = data.refetchWritePolicy
	local errorPolicy = data.errorPolicy
	local returnPartialData = data.returnPartialData
	local context = data.context
	local v = data.notifyOnNetworkStatusChange

	local networkStatus3 = object.networkStatus

	object:init({ document = query, variables = variables, networkStatus = networkStatus4 })

	local function readCache() -- 4 equivalent calls inferred from this helper
		return object:getDiff(variables)
	end

	local function resultsFromCache(data2, networkStatus5)
		if networkStatus5 == nil then
			networkStatus5 = Boolean.toJSBoolean(object.networkStatus) and object.networkStatus
				or networkStatus2.loading
		end

		local result = data2.result

		if
			_G.__DEV__
			and data2.missing ~= nil
			and isNonEmptyArray(data2.missing)
			and not (equal(result, {}) or Boolean.toJSBoolean(returnPartialData))
		then
			invariant2.debug(("Missing cache result fields: %s"):format(Array.join(Array.map(data2.missing, function(p)
				return Array.join(p.path, ".")
			end), ", ")), data2.missing)
		end

		local function fromData(p)
			return observable.of((Object.assign(
				{},
				{
					data = p,
					loading = isNetworkRequestInFlight(networkStatus5),
					networkStatus = networkStatus5
				},
				not Boolean.toJSBoolean(data2.complete) and { partial = true } or nil
			)))
		end

		if Boolean.toJSBoolean(result) and self:transform(query).hasForcedResolvers then
			return self.localState:runResolvers({
				document = query,
				remoteResult = { data = result },
				context = context,
				variables = variables,
				onlyRunForcedResolvers = true
			}):andThen(function(p)
				return fromData(Boolean.toJSBoolean(p.data) and p.data or nil)
			end)
		end

		return fromData(result)
	end

	local v2

	if fetchPolicy == "no-cache" then
		v2 = CacheWriteBehavior.FORBID
	elseif networkStatus4 == networkStatus2.refetch and refetchWritePolicy ~= "merge" then
		v2 = CacheWriteBehavior.OVERWRITE
	else
		v2 = CacheWriteBehavior.MERGE
	end

	local function resultsFromLink()
		return self:getResultsFromLink(object, v2, {
			variables = variables,
			context = context,
			fetchPolicy = fetchPolicy,
			errorPolicy = errorPolicy
		})
	end

	if v then
		if typeof(networkStatus3) == "number" and networkStatus3 ~= networkStatus4 then
			v = isNetworkRequestInFlight(networkStatus4)
		else
			v = false
		end
	end

	if fetchPolicy == "cache-first" then
		local cache2 = readCache() -- inferred equivalent call

		if Boolean.toJSBoolean(cache2.complete) then
			return { resultsFromCache(cache2, object:markReady()) }
		end

		if Boolean.toJSBoolean(returnPartialData) or Boolean.toJSBoolean(v) then
			return { resultsFromCache(cache2), resultsFromLink() }
		end

		return { resultsFromLink() }
	elseif fetchPolicy == "cache-and-network" then
		local cache2 = readCache() -- inferred equivalent call

		if Boolean.toJSBoolean(cache2.complete) or Boolean.toJSBoolean(returnPartialData) or Boolean.toJSBoolean(v) then
			return { resultsFromCache(cache2), resultsFromLink() }
		end

		return { resultsFromLink() }
	else
		if fetchPolicy == "cache-only" then
			return { resultsFromCache(readCache(), object:markReady()) } -- inferred equivalent call
		end

		if fetchPolicy == "network-only" then
			if Boolean.toJSBoolean(v) then
				return { resultsFromCache(readCache()), resultsFromLink() }
			end

			return { resultsFromLink() }
		elseif fetchPolicy == "no-cache" then
			if Boolean.toJSBoolean(v) then
				return { resultsFromCache(object:getDiff()), resultsFromLink() }
			end

			return { resultsFromLink() }
		else
			if fetchPolicy == "standby" then
				return {}
			end

			local cache2 = readCache() -- inferred equivalent call

			if Boolean.toJSBoolean(cache2.complete) then
				return { resultsFromCache(cache2, object:markReady()) }
			end

			if Boolean.toJSBoolean(returnPartialData) or Boolean.toJSBoolean(v) then
				return { resultsFromCache(cache2), resultsFromLink() }
			end

			return { resultsFromLink() }
		end
	end
end

function class:getQuery(p: string)
	if Boolean.toJSBoolean(p) and not self.queries:has(p) then
		self.queries:set(p, queryInfo.new(self.cache))
	end

	return self.queries:get(p)
end

function class:prepareContext(p)
	local v = p == nil and {} or p

	local v2 = self.localState:prepareContext(v)
	return Object.assign({}, v2, { clientAwareness = self.clientAwareness })
end

QueryManager.QueryManager = class

return QueryManager
