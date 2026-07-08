local t1 = {}
local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local LuauPolyfill = require(ParentParentParent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local instanceof = LuauPolyfill.instanceof
local Map = LuauPolyfill.Map
local Object = LuauPolyfill.Object
local Set = LuauPolyfill.Set
local WeakMap = LuauPolyfill.WeakMap
local Promise = require(ParentParentParent.Promise)
local HttpService = game:GetService("HttpService")
local isCallable = require(ParentParent.luaUtils.isCallable)
local toJSBoolean = require(ParentParent.utilities.globals.null).toJSBoolean

require(ParentParentParent.GraphQL)

local invariant = require(ParentParent.jsutils.invariant)
local invariant2 = invariant.invariant
local InvariantError = invariant.InvariantError
local equal = require(ParentParent.jsutils.equal)
local execute = require(script.Parent.Parent.link.core).execute
local canonicalStringify = require(script.Parent.Parent.cache).canonicalStringify
local utilities = require(script.Parent.Parent.utilities)
local getDefaultValues = utilities.getDefaultValues
local getOperationDefinition = utilities.getOperationDefinition
local getOperationName = utilities.getOperationName
local hasClientExports = utilities.hasClientExports
local graphQLResultHasError = utilities.graphQLResultHasError
local removeConnectionDirectiveFromDocument = utilities.removeConnectionDirectiveFromDocument
local _ = utilities.canUseWeakMap
local Observable = utilities.Observable
local asyncMap = utilities.asyncMap
local isNonEmptyArray = utilities.isNonEmptyArray
local Concast = utilities.Concast
local makeUniqueId = utilities.makeUniqueId
local isDocumentNode = utilities.isDocumentNode
local isNonNullObject = utilities.isNonNullObject
local errors = require(script.Parent.Parent.errors)
local ApolloError = errors.ApolloError
local isApolloError = errors.isApolloError

require(script.Parent.watchQueryOptions_types)

local ObservableQuery = require(script.Parent.ObservableQuery)

require(script.Parent.ObservableQuery_types)

local ObservableQuery2 = ObservableQuery.ObservableQuery
local applyNextFetchPolicy = ObservableQuery.applyNextFetchPolicy
local networkStatus = require(script.Parent.networkStatus)
local NetworkStatus = networkStatus.NetworkStatus
local isNetworkRequestInFlight = networkStatus.isNetworkRequestInFlight

require(script.Parent.types)

local LocalState = require(script.Parent.LocalState).LocalState
local QueryInfo = require(script.Parent.QueryInfo)
local QueryInfo2 = QueryInfo.QueryInfo
local shouldWriteResult = QueryInfo.shouldWriteResult
local CacheWriteBehavior = QueryInfo.CacheWriteBehavior
local hasOwnProperty = require(ParentParent.luaUtils.hasOwnProperty)
local t2 = {}

t2.__index = t2

function t2.new(t3: {[any]: any}) -- line: 310
	-- upvalues: t2 (copy), Map (copy), WeakMap (copy), LocalState (copy), Boolean (copy)
	local cache = t3.cache
	local link = t3.link
	local queryDeduplication = t3.queryDeduplication
	local onBroadcast = t3.onBroadcast
	local ssrMode = t3.ssrMode
	local clientAwareness = t3.clientAwareness
	local localState = t3.localState
	local assumeImmutableResults = t3.assumeImmutableResults

	if queryDeduplication == nil then
		queryDeduplication = false
	end

	if ssrMode == nil then
		ssrMode = false
	end

	if clientAwareness == nil then
		clientAwareness = {}
	end

	local self = setmetatable({}, t2)

	self.clientAwareness = {}
	self.queries = Map.new()
	self.fetchCancelFns = Map.new()
	self.transformCache = WeakMap.new()
	self.queryIdCounter = 1
	self.requestIdCounter = 1
	self.mutationIdCounter = 1
	self.inFlightLinkObservables = Map.new()
	self.cache = cache
	self.link = link
	self.queryDeduplication = queryDeduplication
	self.clientAwareness = clientAwareness
	self.localState = localState or LocalState.new({
		cache = cache
	})
	self.ssrMode = ssrMode
	self.assumeImmutableResults = Boolean.toJSBoolean(assumeImmutableResults)
	self.onBroadcast = onBroadcast

	if Boolean.toJSBoolean(self.onBroadcast) then
		self.mutationStore = {}
	end

	return self
end
function t2.stop(p1) -- line: 390
	-- upvalues: InvariantError (copy)
	p1.queries:forEach(function(_, p3) -- line: 391
		-- upvalues: p1 (copy)
		p1:stopQueryNoBroadcast(p3)
	end)
	p1:cancelPendingFetches(InvariantError.new("QueryManager stopped while query was in flight"))
end
function t2.cancelPendingFetches(p4, p5) -- line: 398
	p4.fetchCancelFns:forEach(function(p6) -- line: 399
		-- upvalues: p5 (copy)
		return p6(p5)
	end)
	p4.fetchCancelFns:clear()
end
function t2.mutate(p7, p8) -- line: 405
	-- upvalues: Promise (copy), invariant2 (copy), Boolean (copy), asyncMap (copy), Object (copy), graphQLResultHasError (copy), ApolloError (copy), isCallable (copy), instanceof (copy)
	return Promise.resolve():andThen(function() -- line: 408
		-- upvalues: p8 (copy), invariant2 (copy), Boolean (copy), p7 (copy), Promise (copy), asyncMap (copy), Object (copy), graphQLResultHasError (copy), ApolloError (copy), isCallable (copy), instanceof (copy)
		local mutation = p8.mutation
		local variables = p8.variables
		local optimisticResponse = p8.optimisticResponse
		local updateQueries = p8.updateQueries
		local refetchQueries = p8.refetchQueries
		local awaitRefetchQueries = p8.awaitRefetchQueries
		local update = p8.update
		local onQueryUpdated = p8.onQueryUpdated
		local errorPolicy = p8.errorPolicy
		local fetchPolicy = p8.fetchPolicy
		local keepRootFields = p8.keepRootFields
		local context = p8.context
		local u246 = if refetchQueries ~= nil then refetchQueries else {}

		if awaitRefetchQueries == nil then
			awaitRefetchQueries = false
		end

		if errorPolicy == nil then
			errorPolicy = "none"
		end

		invariant2(mutation, "mutation option is required. You must specify your GraphQL document in the mutation option.")
		invariant2(not Boolean.toJSBoolean(fetchPolicy) or fetchPolicy == "no-cache", "Mutations only support a 'no-cache' fetchPolicy. If you don't want to disable the cache, remove your fetchPolicy setting to proceed with the default mutation behavior.")

		local v247 = p7:generateMutationId()
		local document = p7:transform(mutation).document
		local u249 = p7:getVariables(document, variables)

		if p7:transform(document).hasClientExports then
			u249 = p7.localState:addExportedVariables(document, u249, context):expect()
		end

		local u250

		if Boolean.toJSBoolean(p7.mutationStore) then
			p7.mutationStore[v247] = {
				loading = true,
				error = nil,
				mutation = document,
				variables = u249
			}
			u250 = p7.mutationStore[v247]
		else
			u250 = p7.mutationStore
		end

		if Boolean.toJSBoolean(optimisticResponse) then
			p7:markMutationOptimistic(optimisticResponse, {
				mutationId = v247,
				document = document,
				variables = u249,
				fetchPolicy = fetchPolicy,
				errorPolicy = errorPolicy,
				context = context,
				updateQueries = updateQueries,
				update = update,
				keepRootFields = keepRootFields
			})
		end

		p7:broadcastQueries()

		local v251 = p7

		return Promise.new(function(resolve, reject) -- line: 486
			-- upvalues: asyncMap (copy), p7 (copy), document (ref), Object (copy), context (copy), optimisticResponse (copy), u249 (ref), graphQLResultHasError (copy), errorPolicy (ref), ApolloError (copy), Boolean (copy), u250 (ref), isCallable (copy), u246 (ref), v247 (copy), fetchPolicy (copy), update (copy), updateQueries (copy), awaitRefetchQueries (ref), onQueryUpdated (copy), keepRootFields (copy), v251 (copy), instanceof (copy)
			return asyncMap(p7:getObservableFromLink(document, Object.assign({}, context, {
				optimisticResponse = optimisticResponse
			}), u249, false), function(p9) -- line: 494
				-- upvalues: graphQLResultHasError (copy), errorPolicy (ref), ApolloError (copy), Boolean (copy), u250 (ref), Object (copy), isCallable (copy), u246 (ref), p7 (copy), v247 (copy), document (ref), u249 (ref), fetchPolicy (copy), context (copy), update (copy), updateQueries (copy), awaitRefetchQueries (ref), optimisticResponse (copy), onQueryUpdated (copy), keepRootFields (copy)
				if graphQLResultHasError(p9) and errorPolicy == "none" then
					error(ApolloError.new({
						graphQLErrors = p9.errors
					}))
				end

				if Boolean.toJSBoolean(u250) then
					u250.loading = false
					u250.error = nil
				end

				local v342 = Object.assign({}, p9)

				if isCallable(u246) then
					u246 = u246(v342)
				end

				if errorPolicy == "ignore" and graphQLResultHasError(v342) then
					v342.errors = nil
				end

				return p7:markMutationResult({
					mutationId = v247,
					result = v342,
					document = document,
					variables = u249,
					fetchPolicy = fetchPolicy,
					errorPolicy = errorPolicy,
					context = context,
					update = update,
					updateQueries = updateQueries,
					awaitRefetchQueries = awaitRefetchQueries,
					refetchQueries = u246,
					removeOptimistic = Boolean.toJSBoolean(optimisticResponse) and v247 or nil,
					onQueryUpdated = onQueryUpdated,
					keepRootFields = keepRootFields
				})
			end):subscribe({
				next = function(_, p11) -- line: 534
					-- upvalues: v251 (copy), resolve (copy)
					v251:broadcastQueries()
					resolve(p11)
				end,
				error = function(_, p13) -- line: 544
					-- upvalues: Boolean (copy), u250 (ref), optimisticResponse (copy), v251 (copy), v247 (copy), reject (copy), instanceof (copy), ApolloError (copy)
					if Boolean.toJSBoolean(u250) then
						u250.loading = false
						u250.error = p13
					end

					if Boolean.toJSBoolean(optimisticResponse) then
						v251.cache:removeOptimistic(v247)
					end

					v251:broadcastQueries()
					reject(instanceof(p13, ApolloError) and p13 or ApolloError.new({
						networkError = p13
					}))
				end
			})
		end)
	end)
end
function t2.markMutationResult(t4: {[any]: any}, t5: {[any]: any}, p14) -- line: 563
	-- upvalues: shouldWriteResult (copy), Boolean (copy), hasOwnProperty (copy), getOperationName (copy), Array (copy), Object (copy), Promise (copy), toJSBoolean (copy)
	if p14 == nil then
		p14 = t4.cache
	end

	local result = t5.result
	local t6 = {}
	local v74 = t5.fetchPolicy == "no-cache"

	if not v74 and shouldWriteResult(result, t5.errorPolicy) then
		table.insert(t6, {
			dataId = "ROOT_MUTATION",
			result = result.data,
			query = t5.document,
			variables = t5.variables
		})

		local updateQueries = t5.updateQueries

		if updateQueries ~= nil then
			t4.queries:forEach(function(p15, p16) -- line: 600
				-- upvalues: Boolean (copy), hasOwnProperty (copy), updateQueries (copy), t4 (copy), p14 (ref), result (ref), getOperationName (copy), t6 (copy)
				local observableQuery = p15.observableQuery
				local v255 = if not Boolean.toJSBoolean(observableQuery) then observableQuery else observableQuery.queryName

				if not Boolean.toJSBoolean(v255) or not hasOwnProperty(updateQueries, v255) then
					return
				end

				local v256 = updateQueries[v255]
				local v257 = t4.queries:get(p16)
				local document = v257.document
				local variables = v257.variables
				local v260 = p14:diff({
					returnPartialData = true,
					optimistic = false,
					query = document,
					variables = variables
				})
				local result2 = v260.result

				if v260.complete and Boolean.toJSBoolean(result2) then
					local v262 = updateQueries
					local t7 = {
						mutationResult = result
					}
					local v265

					if Boolean.toJSBoolean(document) then
						local v264 = getOperationName(document)

						v265 = if not Boolean.toJSBoolean(v264) then nil else v264
					else
						v265 = nil
					end

					t7.queryName = v265
					t7.queryVariables = variables

					local v266 = v256(v262, result2, t7)

					if Boolean.toJSBoolean(v266) then
						table.insert(t6, {
							dataId = "ROOT_QUERY",
							result = v266,
							query = document,
							variables = variables
						})
					end
				end
			end)
		end
	end

	if #t6 > 0 or Boolean.toJSBoolean(t5.refetchQueries) or Boolean.toJSBoolean(t5.update) or Boolean.toJSBoolean(t5.onQueryUpdated) or Boolean.toJSBoolean(t5.removeOptimistic) then
		local t8 = {}

		t4:refetchQueries({
			optimistic = false,
			updateCache = function(_, p18) -- line: 667
				-- upvalues: v74 (copy), Array (copy), t6 (copy), t5 (copy), Boolean (copy), t4 (copy), result (ref), Object (copy)
				if not v74 then
					Array.forEach(t6, function(p19) -- line: 669
						-- upvalues: p18 (copy)
						return p18:write(p19)
					end)
				end

				local update = t5.update

				if update ~= nil and Boolean.toJSBoolean(update) then
					if not v74 then
						local v270 = p18:diff({
							id = "ROOT_MUTATION",
							optimistic = false,
							returnPartialData = true,
							query = t4:transform(t5.document).asQuery,
							variables = t5.variables
						})

						if v270.complete then
							result = Object.assign({}, result, {
								data = v270.result
							})
						end
					end

					update(t5, p18, result, {
						context = t5.context,
						variables = t5.variables
					})
				end

				if not v74 and not t5.keepRootFields then
					p18:modify({
						id = "ROOT_MUTATION",
						fields = function(_, p21, p22) -- line: 711
							local fieldName = p22.fieldName
							local DELETE = p22.DELETE

							if fieldName == "__typename" then
								return p21
							end

							return DELETE
						end
					})
				end
			end,
			include = t5.refetchQueries,
			removeOptimistic = t5.removeOptimistic,
			onQueryUpdated = Boolean.toJSBoolean(t5.onQueryUpdated) and t5.onQueryUpdated or nil
		}):forEach(function(p23) -- line: 737
			-- upvalues: t8 (copy)
			return table.insert(t8, p23)
		end)

		if t5.awaitRefetchQueries or Boolean.toJSBoolean(t5.onQueryUpdated) then
			return Promise.all(Array.filter(t8, toJSBoolean)):andThen(function() -- line: 746
				-- upvalues: result (ref)
				return result
			end)
		end
	end

	return Promise.resolve(result)
end
function t2.markMutationOptimistic(t9: {[any]: any}, p24, t10: {[any]: any}) -- line: 755
	-- upvalues: isCallable (copy), Object (copy), invariant2 (copy)
	local u80 = if not isCallable(p24) then p24 else p24(t10.variables)

	return t9.cache:recordOptimisticTransaction(function(p25) -- line: 776
		-- upvalues: t9 (copy), Object (copy), t10 (copy), u80 (ref), invariant2 (copy)
		local ok, result = pcall(function() -- line: 777
			-- upvalues: t9 (copy), Object (copy), t10 (copy), u80 (ref), p25 (copy)
			t9:markMutationResult(Object.assign({}, t10, {
				result = {
					data = u80
				}
			}), p25)
		end)

		if not ok then
			invariant2.error(result)
		end
	end, t10.mutationId)
end
function t2.fetchQuery(t11: {[any]: any}, s1: string, p26, p27) -- line: 786
	return t11:fetchQueryObservable(s1, p26, p27).promise
end
function t2.getQueryStore(p28) -- line: 794
	local t12 = {}

	p28.queries:forEach(function(p29, p30) -- line: 796
		-- upvalues: t12 (copy)
		t12[p30] = {
			variables = p29.variables,
			networkStatus = p29.networkStatus,
			networkError = p29.networkError,
			graphQLErrors = p29.graphQLErrors
		}
	end)

	return t12
end
function t2.resetErrors(t13: {[any]: any}, s2: string) -- line: 807
	-- upvalues: Boolean (copy)
	local v89 = t13.queries:get(s2)

	if Boolean.toJSBoolean(v89) then
		v89.networkError = nil
		v89.graphQLErrors = {}
	end
end
function t2.transform(p31, p32) -- line: 815
	-- upvalues: removeConnectionDirectiveFromDocument (copy), Boolean (copy), hasClientExports (copy), getDefaultValues (copy), getOperationDefinition (copy), Object (copy), Array (copy)
	local transformCache = p31.transformCache

	if not transformCache:has(p32) then
		local v93 = p31.cache:transformDocument(p32)
		local v94 = removeConnectionDirectiveFromDocument(p31.cache:transformForLink(v93))
		local v95 = p31.localState:clientQuery(v93)
		local v96 = if not Boolean.toJSBoolean(v94) then v94 else p31.localState:serverQuery(v94)
		local t14 = {
			document = v93,
			hasClientExports = hasClientExports(v93),
			hasForcedResolvers = p31.localState:shouldForceResolvers(v93),
			clientQuery = v95,
			serverQuery = v96,
			defaultVars = getDefaultValues(getOperationDefinition(v93)),
			asQuery = Object.assign({}, v93, {
				definitions = Array.map(v93.definitions, function(p33) -- line: 842
					-- upvalues: Object (copy)
					if p33.kind == "OperationDefinition" and p33.operation ~= "query" then
						return (Object.assign({}, p33, {
							operation = "query"
						}))
					end

					return p33
				end)
			})
		}

		local function add(p34) -- line: 851
			-- upvalues: transformCache (copy), t14 (copy)
			if p34 ~= nil and not transformCache:has(p34) then
				transformCache:set(p34, t14)
			end
		end

		if p32 ~= nil and not transformCache:has(p32) then
			transformCache:set(p32, t14)
		end

		if v93 ~= nil and not transformCache:has(v93) then
			transformCache:set(v93, t14)
		end

		if v95 ~= nil and not transformCache:has(v95) then
			transformCache:set(v95, t14)
		end

		if v96 ~= nil and not transformCache:has(v96) then
			transformCache:set(v96, t14)
		end
	end

	return transformCache:get(p32)
end
function t2.getVariables(p35, p36, p37) -- line: 868
	-- upvalues: Object (copy)
	return Object.assign({}, p35:transform(p36).defaultVars, p37)
end
function t2.watchQuery(p38, p39) -- line: 872
	-- upvalues: Object (copy), QueryInfo2 (copy), ObservableQuery2 (copy)
	local v104 = Object.assign({}, p39, {
		variables = p38:getVariables(p39.query, p39.variables)
	})

	if typeof(v104.notifyOnNetworkStatusChange) == "nil" then
		v104.notifyOnNetworkStatusChange = false
	end

	local v105 = QueryInfo2.new(p38.cache)
	local v106 = ObservableQuery2.new({
		queryManager = p38,
		queryInfo = v105,
		options = v104
	})

	p38.queries:set(v106.queryId, v105)
	v105:init({
		document = v104.query,
		observableQuery = v106,
		variables = v104.variables
	})

	return v106
end
function t2.query(t15: {[any]: any}, p40, s3: string?) -- line: 900
	-- upvalues: invariant2 (copy), Boolean (copy)
	if s3 == nil then
		s3 = t15:generateQueryId()
	end

	invariant2(p40.query, "query option is required. You must specify your GraphQL document in the query option.")
	invariant2(p40.query.kind == "Document", "You must wrap the query string in a \"gql\" tag.")
	invariant2(not Boolean.toJSBoolean(p40.returnPartialData), "returnPartialData option only supported on watchQuery.")
	invariant2(not Boolean.toJSBoolean(p40.pollInterval), "pollInterval option only supported on watchQuery.")

	return t15:fetchQuery(s3, p40):andThen(function(p41) -- line: 927
		-- upvalues: t15 (copy), s3 (ref)
		t15:stopQuery(s3)

		return p41
	end):catch(function(p42) -- line: 931
		-- upvalues: t15 (copy), s3 (ref)
		t15:stopQuery(s3)
		error(p42)
	end)
end
function t2.generateQueryId(p43) -- line: 937
	local queryIdCounter = p43.queryIdCounter

	p43.queryIdCounter = p43.queryIdCounter + 1

	return (tostring(queryIdCounter))
end
function t2.generateRequestId(p44) -- line: 944
	local requestIdCounter = p44.requestIdCounter

	p44.requestIdCounter = p44.requestIdCounter + 1

	return requestIdCounter
end
function t2.generateMutationId(p45) -- line: 951
	local mutationIdCounter = p45.mutationIdCounter

	p45.mutationIdCounter = p45.mutationIdCounter + 1

	return (tostring(mutationIdCounter))
end
function t2.stopQueryInStore(t16: {[any]: any}, s4: string) -- line: 958
	t16:stopQueryInStoreNoBroadcast(s4)
	t16:broadcastQueries()
end
function t2.stopQueryInStoreNoBroadcast(t17: {[any]: any}, s5: string) -- line: 963
	-- upvalues: Boolean (copy)
	local v121 = t17.queries:get(s5)

	if Boolean.toJSBoolean(v121) then
		v121:stop()
	end
end
function t2.clearStore(p46) -- line: 970
	-- upvalues: InvariantError (copy), Boolean (copy), NetworkStatus (copy)
	p46:cancelPendingFetches(InvariantError.new("Store reset while query was in flight (not completed in link chain)"))
	p46.queries:forEach(function(p47, _) -- line: 978
		-- upvalues: Boolean (copy), NetworkStatus (copy)
		if Boolean.toJSBoolean(p47.observableQuery) then
			p47.networkStatus = NetworkStatus.loading

			return
		end

		p47:stop()
	end)

	if Boolean.toJSBoolean(p46.mutationStore) then
		p46.mutationStore = {}
	end

	return p46.cache:reset()
end
function t2.resetStore(p49) -- line: 996
	return p49:clearStore():andThen(function() -- line: 1003
		-- upvalues: p49 (copy)
		return p49:reFetchObservableQueries()
	end)
end
function t2.getObservableQueries(p50, p51) -- line: 1008
	-- upvalues: Map (copy), Set (copy), Array (copy), isDocumentNode (copy), isNonNullObject (copy), Boolean (copy), makeUniqueId (copy), ObservableQuery2 (copy), Object (copy), invariant2 (copy), HttpService (copy)
	if p51 == nil then
		p51 = "active"
	end

	local v127 = Map.new(nil)
	local v128 = Map.new(nil)
	local v129 = Set.new()

	if Array.isArray(p51) then
		Array.forEach(p51, function(p52) -- line: 1023
			-- upvalues: v128 (copy), isDocumentNode (copy), p50 (copy), isNonNullObject (copy), Boolean (copy), v129 (copy)
			if typeof(p52) == "string" then
				v128:set(p52, false)

				return
			end

			if isDocumentNode(p52) then
				v128:set(p50:transform(p52).document, false)

				return
			end

			if isNonNullObject(p52) and Boolean.toJSBoolean(p52.query) then
				v129:add(p52)
			end
		end)
	end

	p50.queries:forEach(function(p53, p54) -- line: 1034
		-- upvalues: Boolean (copy), p51 (ref), v127 (copy), v128 (copy)
		local observableQuery = p53.observableQuery
		local document = p53.document

		if Boolean.toJSBoolean(observableQuery) then
			if p51 == "all" then
				v127:set(p54, observableQuery)

				return
			end

			local queryName = observableQuery.queryName

			if observableQuery.options.fetchPolicy == "standby" or not observableQuery:hasObservers() then
				return
			end

			if p51 == "active" or Boolean.toJSBoolean(queryName) and v128:has(queryName) or Boolean.toJSBoolean(document) and v128:has(document) then
				v127:set(p54, observableQuery)

				if Boolean.toJSBoolean(queryName) then
					v128:set(queryName, true)
				end

				if Boolean.toJSBoolean(document) then
					v128:set(document, true)
				end
			end
		end
	end)

	if Boolean.toJSBoolean(v129.size) then
		for _, v131 in v129 do
			local v132 = makeUniqueId("legacyOneTimeQuery")
			local v133 = p50:getQuery(v132):init({
				document = v131.query,
				variables = v131.variables
			})
			local v134 = ObservableQuery2.new({
				queryManager = p50,
				queryInfo = v133,
				options = Object.assign({}, v131, {
					fetchPolicy = "network-only"
				})
			})

			v133:setObservableQuery(v134)
			v127:set(v132, v134)
		end
	end

	if _G.__DEV__ and Boolean.toJSBoolean(v128.size) then
		v128:forEach(function(p55, p56) -- line: 1086
			-- upvalues: invariant2 (copy), HttpService (copy)
			if not p55 then
				invariant2.warn(("Unknown query %s%s requested in refetchQueries options.include array"):format(typeof(p56) ~= "string" and "" or "named ", HttpService:JSONEncode(p56)))
			end
		end)
	end

	return v127
end
function t2.reFetchObservableQueries(t18: {[any]: any}, b1: boolean?) -- line: 1101
	-- upvalues: Boolean (copy), Promise (copy), Array (copy), toJSBoolean (copy)
	if b1 == nil then
		b1 = false
	end

	local t19 = {}

	t18:getObservableQueries(not Boolean.toJSBoolean(b1) and "active" or "all"):forEach(function(p57, p58) -- line: 1109
		-- upvalues: Boolean (copy), b1 (ref), t19 (copy), t18 (copy)
		local fetchPolicy = p57.options.fetchPolicy

		p57:resetLastResults()

		if Boolean.toJSBoolean(b1) or fetchPolicy ~= "standby" and fetchPolicy ~= "cache-only" then
			table.insert(t19, p57:refetch())
		end

		t18:getQuery(p58):setDiff(nil)
	end)
	t18:broadcastQueries()

	return Promise.all(Array.filter(t19, toJSBoolean))
end
function t2.setObservableQuery(p59, p60) -- line: 1124
	p59:getQuery(p60.queryId):setObservableQuery(p60)
end
function t2.startGraphQLSubscription(p61, p62) -- line: 1128
	-- upvalues: shouldWriteResult (copy), graphQLResultHasError (copy), ApolloError (copy), Observable (copy)
	local query = p62.query
	local fetchPolicy = p62.fetchPolicy
	local errorPolicy = p62.errorPolicy
	local variables = p62.variables
	local context = p62.context

	if p62.context == nil then
		context = {}
	end

	local document = p61:transform(query).document
	local v149 = p61:getVariables(document, variables)

	local function makeObservable(p63) -- line: 1140
		-- upvalues: p61 (copy), document (ref), context (ref), fetchPolicy (copy), shouldWriteResult (copy), errorPolicy (copy), graphQLResultHasError (copy), ApolloError (copy)
		return p61:getObservableFromLink(document, context, p63):map(function(p64) -- line: 1141
			-- upvalues: fetchPolicy (copy), shouldWriteResult (copy), errorPolicy (copy), p61 (copy), document (ref), p63 (copy), graphQLResultHasError (copy), ApolloError (copy)
			if fetchPolicy ~= "no-cache" then
				if shouldWriteResult(p64, errorPolicy) then
					p61.cache:write({
						dataId = "ROOT_SUBSCRIPTION",
						query = document,
						result = p64.data,
						variables = p63
					})
				end

				p61:broadcastQueries()
			end

			if graphQLResultHasError(p64) then
				error(ApolloError.new({
					graphQLErrors = p64.errors
				}))
			end

			return p64
		end)
	end

	if p61:transform(document).hasClientExports then
		local v151 = p61.localState:addExportedVariables(document, v149, context):andThen(makeObservable)

		return Observable.new(function(p65) -- line: 1171
			-- upvalues: v151 (copy)
			local u296 = nil

			v151:andThen(function(p66) -- line: 1173
				-- upvalues: u296 (ref), p65 (copy)
				u296 = p66:subscribe(p65)

				return u296
			end, p65.error)

			return function() -- line: 1177
				-- upvalues: u296 (ref)
				if u296 ~= nil then
					return u296:unsubscribe()
				end

				return u296
			end
		end)
	end

	return makeObservable(v149)
end
function t2.stopQuery(t20: {[any]: any}, s6: string) -- line: 1190
	t20:stopQueryNoBroadcast(s6)
	t20:broadcastQueries()
end
function t2.stopQueryNoBroadcast(t21: {[any]: any}, s7: string) -- line: 1195
	t21:stopQueryInStoreNoBroadcast(s7)
	t21:removeQuery(s7)
end
function t2.removeQuery(t22: {[any]: any}, s8: string) -- line: 1200
	t22.fetchCancelFns:delete(s8)
	t22:getQuery(s8):stop()
	t22.queries:delete(s8)
end
function t2.broadcastQueries(p67) -- line: 1211
	-- upvalues: Boolean (copy)
	if Boolean.toJSBoolean(p67.onBroadcast) then
		p67:onBroadcast()
	end

	p67.queries:forEach(function(p68, _) -- line: 1216
		return p68:notify()
	end)
end
function t2.getLocalState(p70) -- line: 1221
	return p70.localState
end
function t2.getObservableFromLink(t23: {[any]: any}, p71, p72, p73, b2: boolean?) -- line: 1225
	-- upvalues: Boolean (copy), getOperationName (copy), Object (copy), Map (copy), canonicalStringify (copy), Concast (copy), execute (copy), Observable (copy), toJSBoolean (copy), asyncMap (copy)
	if b2 == nil then
		b2 = if not Boolean.toJSBoolean(p72) then t23.queryDeduplication else if p72.queryDeduplication == nil then t23.queryDeduplication else p72.queryDeduplication
	end

	local serverQuery = t23:transform(p71).serverQuery
	local context, v173

	if Boolean.toJSBoolean(serverQuery) then
		local inFlightLinkObservables = t23.inFlightLinkObservables
		local link = t23.link
		local t24 = {
			query = serverQuery,
			variables = p73,
			operationName = Boolean.toJSBoolean(getOperationName(serverQuery)) and getOperationName(serverQuery) or nil,
			context = t23:prepareContext(Object.assign({}, p72, {
				forceFetch = not b2
			}))
		}

		context = t24.context

		if b2 then
			local v170 = inFlightLinkObservables:get(serverQuery)
			local v171 = Boolean.toJSBoolean(v170) and v170 or Map.new(nil)

			inFlightLinkObservables:set(serverQuery, v171)

			local v172 = canonicalStringify(p73)

			v173 = v171:get(v172)

			if not Boolean.toJSBoolean(v173) then
				v173 = Concast.new({ (execute(link, t24)) })
				v171:set(v172, v173)
				v173:cleanup(function() -- line: 1277
					-- upvalues: Boolean (copy), v171 (copy), v172 (copy), inFlightLinkObservables (copy), serverQuery (copy)
					if Boolean.toJSBoolean(v171:delete(v172)) and v171.size < 1 then
						inFlightLinkObservables:delete(serverQuery)
					end
				end)
			end
		else
			v173 = Concast.new({ (execute(link, t24)) })
		end
	else
		v173 = Concast.new({ Observable.of({
			data = {}
		}) })
		context = t23:prepareContext(p72)
	end

	local clientQuery = t23:transform(p71).clientQuery

	if toJSBoolean(clientQuery) then
		v173 = asyncMap(v173, function(p74) -- line: 1298
			-- upvalues: t23 (copy), clientQuery (copy), context (ref), p73 (copy)
			return t23.localState:runResolvers({
				document = clientQuery,
				remoteResult = p74,
				context = context,
				variables = p73
			})
		end)
	end

	return v173
end
function t2.getResultsFromLink(p75, p76, p77, p78) -- line: 1311
	-- upvalues: asyncMap (copy), isNonEmptyArray (copy), ApolloError (copy), Boolean (copy), NetworkStatus (copy), isApolloError (copy)
	p76.lastRequestId = p75:generateRequestId()

	local lastRequestId = p76.lastRequestId

	return asyncMap(p75:getObservableFromLink(p76.document, p78.context, p78.variables), function(p79) -- line: 1321
		-- upvalues: isNonEmptyArray (copy), lastRequestId (copy), p76 (copy), p78 (copy), ApolloError (copy), p77 (copy), Boolean (copy), NetworkStatus (copy)
		local v301 = isNonEmptyArray(p79.errors)

		if lastRequestId >= p76.lastRequestId then
			if v301 and p78.errorPolicy == "none" then
				error(p76:markError(ApolloError.new({
					graphQLErrors = p79.errors
				})))
			end

			p76:markResult(p79, p78, p77)
			p76:markReady()
		end

		local t25 = {
			loading = false,
			data = p79.data,
			networkStatus = Boolean.toJSBoolean(p76.networkStatus) and p76.networkStatus or NetworkStatus.ready
		}

		if v301 and p78.errorPolicy ~= "ignore" then
			t25.errors = p79.errors
		end

		return t25
	end, function(p80) -- line: 1350
		-- upvalues: isApolloError (copy), ApolloError (copy), lastRequestId (copy), p76 (copy)
		local v304 = if not isApolloError(p80) then ApolloError.new({
			networkError = p80
		}) else p80

		if lastRequestId >= p76.lastRequestId then
			p76:markError(v304)
		end

		error(v304)
	end)
end
function t2.fetchQueryObservable(t26: {[any]: any}, s9: string, p81, p82) -- line: 1368
	-- upvalues: NetworkStatus (copy), Object (copy), Promise (copy), Concast (copy), applyNextFetchPolicy (copy)
	if p82 == nil then
		p82 = NetworkStatus.loading
	end

	local document = t26:transform(p81.query).document
	local v186 = t26:getVariables(document, p81.variables)
	local v187 = t26:getQuery(s9)
	local fetchPolicy = p81.fetchPolicy
	local errorPolicy = p81.errorPolicy
	local returnPartialData = p81.returnPartialData
	local notifyOnNetworkStatusChange = p81.notifyOnNetworkStatusChange
	local context = p81.context

	if fetchPolicy == nil then
		fetchPolicy = "cache-first"
	end

	if errorPolicy == nil then
		errorPolicy = "none"
	end

	if returnPartialData == nil then
		returnPartialData = false
	end

	if notifyOnNetworkStatusChange == nil then
		notifyOnNetworkStatusChange = false
	end

	if context == nil then
		context = {}
	end

	local v193 = Object.assign({}, p81, {
		query = document,
		variables = v186,
		fetchPolicy = fetchPolicy,
		errorPolicy = errorPolicy,
		returnPartialData = returnPartialData,
		notifyOnNetworkStatusChange = notifyOnNetworkStatusChange,
		context = context
	})

	local function fromVariables(p83) -- line: 1417
		-- upvalues: v193 (copy), t26 (copy), v187 (copy), p82 (ref)
		v193.variables = p83

		return t26:fetchQueryByPolicy(v187, v193, p82)
	end

	local u195 = nil

	t26.fetchCancelFns:set(s9, function(p84) -- line: 1430
		-- upvalues: Promise (copy), u195 (ref)
		Promise.delay(0):andThen(function() -- line: 1433
			-- upvalues: u195 (ref), p84 (copy)
			return u195:cancel(p84)
		end)
	end)
	u195 = Concast.new((function() -- line: 1441
		-- upvalues: t26 (copy), v193 (copy), fromVariables (copy)
		if t26:transform(v193.query).hasClientExports then
			return t26.localState:addExportedVariables(v193.query, v193.variables, v193.context):andThen(fromVariables)
		end

		return fromVariables(v193.variables)
	end)())
	u195:cleanup(function() -- line: 1458
		-- upvalues: t26 (copy), s9 (copy), applyNextFetchPolicy (copy), p81 (copy)
		t26.fetchCancelFns:delete(s9)
		applyNextFetchPolicy(p81)
	end)

	return u195
end
function t2.refetchQueries(p85, p86) -- line: 1466
	-- upvalues: Boolean (copy), makeUniqueId (copy), Map (copy), instanceof (copy), QueryInfo2 (copy)
	local updateCache = p86.updateCache
	local include = p86.include
	local optimistic = p86.optimistic
	local removeOptimistic = p86.removeOptimistic
	local onQueryUpdated = p86.onQueryUpdated

	if optimistic == nil then
		optimistic = false
	end

	if removeOptimistic == nil then
		removeOptimistic = if not Boolean.toJSBoolean(optimistic) then nil else makeUniqueId("refetchQueries")
	end

	local v203 = Map.new(nil)

	if Boolean.toJSBoolean(include) then
		p85:getObservableQueries(include):forEach(function(p87, p88) -- line: 1490
			-- upvalues: v203 (copy), p85 (copy)
			v203:set(p88, {
				oq = p87,
				lastDiff = p85:getQuery(p88):getDiff()
			})
		end)
	end

	local v204 = Map.new(nil)

	if Boolean.toJSBoolean(updateCache) then
		p85.cache:batch({
			update = updateCache,
			optimistic = not not optimistic and (not not Boolean.toJSBoolean(removeOptimistic) and removeOptimistic),
			removeOptimistic = removeOptimistic,
			onWatchUpdated = function(_, p90, p91, p92) -- line: 1545
				-- upvalues: instanceof (copy), QueryInfo2 (copy), Boolean (copy), onQueryUpdated (copy), v203 (copy), p86 (copy), v204 (copy)
				local v313 = if not instanceof(p90.watcher, QueryInfo2) then instanceof(p90.watcher, QueryInfo2) else p90.watcher.observableQuery

				if Boolean.toJSBoolean(v313) then
					if onQueryUpdated then
						v203:delete(v313.queryId)

						local v314 = onQueryUpdated(p86, v313, p91, p92)

						if v314 == true then
							v314 = v313:refetch()
						end

						if v314 ~= false then
							v204:set(v313, v314)
						end

						return false
					end

					if onQueryUpdated then
						v203:set(v313.queryId, {
							oq = v313,
							lastDiff = p92,
							diff = p91
						})
					end
				end

				return nil
			end
		})
	end

	if Boolean.toJSBoolean(v203.size) then
		v203:forEach(function(t27: {[any]: any}, s10: string) -- line: 1593
			-- upvalues: onQueryUpdated (copy), p86 (copy), v204 (copy), p85 (copy)
			local oq = t27.oq
			local lastDiff = t27.lastDiff
			local diff = t27.diff
			local v320 = nil

			if onQueryUpdated ~= nil then
				if diff == nil then
					local queryInfo = oq.queryInfo

					queryInfo:reset()
					diff = queryInfo:getDiff()
				end

				v320 = onQueryUpdated(p86, oq, diff, lastDiff)
			end

			if onQueryUpdated == nil or v320 == true then
				v320 = oq:refetch()
			end

			if v320 ~= false then
				v204:set(oq, v320)
			end

			local v322 = string.find(s10, "legacyOneTimeQuery")

			if v322 ~= nil and v322 >= 1 then
				p85:stopQueryNoBroadcast(s10)
			end
		end)
	end

	if Boolean.toJSBoolean(removeOptimistic) then
		p85.cache:removeOptimistic(removeOptimistic)
	end

	return v204
end
function t2.fetchQueryByPolicy(p93, p94, p95, p96) -- line: 1653
	-- upvalues: Boolean (copy), NetworkStatus (copy), isNonEmptyArray (copy), equal (copy), invariant2 (copy), Array (copy), Observable (copy), Object (copy), isNetworkRequestInFlight (copy), CacheWriteBehavior (copy)
	local query = p95.query
	local variables = p95.variables
	local fetchPolicy = p95.fetchPolicy
	local refetchWritePolicy = p95.refetchWritePolicy
	local errorPolicy = p95.errorPolicy
	local returnPartialData = p95.returnPartialData
	local context = p95.context
	local notifyOnNetworkStatusChange = p95.notifyOnNetworkStatusChange
	local networkStatus2 = p94.networkStatus

	p94:init({
		document = query,
		variables = variables,
		networkStatus = p96
	})

	local function readCache() -- line: 1679
		-- upvalues: p94 (copy), variables (copy)
		return p94:getDiff(variables)
	end
	local function resultsFromCache(p97, p98) -- line: 1683
		-- upvalues: Boolean (copy), p94 (copy), NetworkStatus (copy), isNonEmptyArray (copy), equal (copy), returnPartialData (copy), invariant2 (copy), Array (copy), Observable (copy), Object (copy), isNetworkRequestInFlight (copy), p93 (copy), query (copy), context (copy), variables (copy)
		if p98 == nil then
			p98 = Boolean.toJSBoolean(p94.networkStatus) and p94.networkStatus or NetworkStatus.loading
		end

		local result = p97.result

		if _G.__DEV__ and p97.missing ~= nil and isNonEmptyArray(p97.missing) and not equal(result, {}) and not Boolean.toJSBoolean(returnPartialData) then
			invariant2.debug(("Missing cache result fields: %s"):format(Array.join(Array.map(p97.missing, function(p99) -- line: 1701
				-- upvalues: Array (copy)
				return Array.join(p99.path, ".")
			end), ", ")), p97.missing)
		end

		local function fromData(p100) -- line: 1710
			-- upvalues: Observable (copy), Object (copy), isNetworkRequestInFlight (copy), p98 (ref), Boolean (copy), p97 (copy)
			return Observable.of((Object.assign({}, {
				data = p100,
				loading = isNetworkRequestInFlight(p98),
				networkStatus = p98
			}, if not Boolean.toJSBoolean(p97.complete) then {
				partial = true
			} else nil)))
		end

		if Boolean.toJSBoolean(result) and p93:transform(query).hasForcedResolvers then
			return p93.localState:runResolvers({
				onlyRunForcedResolvers = true,
				document = query,
				remoteResult = {
					data = result
				},
				context = context,
				variables = variables
			}):andThen(function(p101) -- line: 1737
				-- upvalues: fromData (copy), Boolean (copy)
				return fromData(Boolean.toJSBoolean(p101.data) and p101.data or nil)
			end)
		end

		return fromData(result)
	end

	local u220 = if fetchPolicy ~= "no-cache" then if p96 ~= NetworkStatus.refetch or refetchWritePolicy == "merge" then CacheWriteBehavior.MERGE else CacheWriteBehavior.OVERWRITE else CacheWriteBehavior.FORBID

	local function resultsFromLink() -- line: 1758
		-- upvalues: p93 (copy), p94 (copy), u220 (ref), variables (copy), context (copy), fetchPolicy (copy), errorPolicy (copy)
		return p93:getResultsFromLink(p94, u220, {
			variables = variables,
			context = context,
			fetchPolicy = fetchPolicy,
			errorPolicy = errorPolicy
		})
	end

	local v222 = notifyOnNetworkStatusChange and (typeof(networkStatus2) == "number" and (networkStatus2 ~= p96 and isNetworkRequestInFlight(p96)))

	if fetchPolicy == "cache-first" then
		local v223 = p94:getDiff(variables)

		if Boolean.toJSBoolean(v223.complete) then
			return { resultsFromCache(v223, p94:markReady()) }
		end

		if Boolean.toJSBoolean(returnPartialData) or Boolean.toJSBoolean(v222) then
			return {
				resultsFromCache(v223),
				resultsFromLink()
			}
		end

		return { resultsFromLink() }
	end

	if fetchPolicy == "cache-and-network" then
		local v224 = p94:getDiff(variables)

		if Boolean.toJSBoolean(v224.complete) or Boolean.toJSBoolean(returnPartialData) or Boolean.toJSBoolean(v222) then
			return {
				resultsFromCache(v224),
				resultsFromLink()
			}
		end

		return { resultsFromLink() }
	end

	if fetchPolicy == "cache-only" then
		return { resultsFromCache(p94:getDiff(variables), p94:markReady()) }
	end

	if fetchPolicy == "network-only" then
		if Boolean.toJSBoolean(v222) then
			return {
				resultsFromCache(readCache()),
				resultsFromLink()
			}
		end

		return { resultsFromLink() }
	end

	if fetchPolicy == "no-cache" then
		if Boolean.toJSBoolean(v222) then
			return {
				resultsFromCache(p94:getDiff()),
				resultsFromLink()
			}
		end

		return { resultsFromLink() }
	end

	if fetchPolicy == "standby" then
		return {}
	end

	local v225 = p94:getDiff(variables)

	if Boolean.toJSBoolean(v225.complete) then
		return { resultsFromCache(v225, p94:markReady()) }
	end

	if Boolean.toJSBoolean(returnPartialData) or Boolean.toJSBoolean(v222) then
		return {
			resultsFromCache(v225),
			resultsFromLink()
		}
	end

	return { resultsFromLink() }
end
function t2.getQuery(t28: {[any]: any}, s11: string) -- line: 1834
	-- upvalues: Boolean (copy), QueryInfo2 (copy)
	if Boolean.toJSBoolean(s11) and not t28.queries:has(s11) then
		t28.queries:set(s11, QueryInfo2.new(t28.cache))
	end

	return t28.queries:get(s11)
end
function t2.prepareContext(p102, p103) -- line: 1841
	-- upvalues: Object (copy)
	if p103 == nil then
		p103 = {}
	end

	local v230 = p102.localState:prepareContext(p103)

	return Object.assign({}, v230, {
		clientAwareness = p102.clientAwareness
	})
end

t1.QueryManager = t2

return t1
