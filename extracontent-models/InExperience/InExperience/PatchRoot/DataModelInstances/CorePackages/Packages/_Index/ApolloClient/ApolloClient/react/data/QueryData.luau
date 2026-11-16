local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent
local Promise = require(parent2.Promise)
local LuauPolyfill = require(parent2.LuauPolyfill)
local Boolean = LuauPolyfill.Boolean
local Object = LuauPolyfill.Object

local hasOwnProperty = require(parent.luaUtils.hasOwnProperty)

local equal = require(parent.jsutils.equal)

local errors = require(parent.errors)
local apolloError = errors.ApolloError

local core = require(script.Parent.Parent.Parent.core)

local networkStatus = core.NetworkStatus

require(parent.utilities)

local parser = require(script.Parent.Parent.parser)
local documentType = parser.DocumentType
require(script.Parent.Parent.types.types)

local OperationData = require(script.Parent.OperationData)
local operationData = OperationData.OperationData

local object = setmetatable({}, { __index = operationData })
object.__index = object

function object.new(data)
	local options = data.options
	local context = data.context
	local onNewData = data.onNewData
	local v = operationData.new(options, context)
	v.runLazy = false
	v.previous = {}

	v.onNewData = onNewData

	function v.runLazyQuery(lazyOptions)
		v:cleanup()
		v.runLazy = true
		v.lazyOptions = lazyOptions
		v:onNewData()
	end

	function v.obsRefetch(_, p)
		if Boolean.toJSBoolean(v.currentObservable) then
			return v.currentObservable:refetch(p)
		end

		return nil
	end

	function v.obsFetchMore(_, p)
		if v.currentObservable then
			return (v.currentObservable:fetchMore(p))
		end

		return nil
	end

	function v.obsUpdateQuery(_, callback)
		if v.currentObservable then
			return (v.currentObservable:updateQuery(callback))
		end

		return nil
	end

	function v.obsStartPolling(_, p: number)
		if v.currentObservable then
			return (v.currentObservable:startPolling(p))
		end

		return nil
	end

	function v.obsStopPolling(_)
		if v.currentObservable then
			return (v.currentObservable:stopPolling())
		end

		return nil
	end

	function v.obsSubscribeToMore(p)
		if v.currentObservable then
			return (v.currentObservable:subscribeToMore(p))
		end

		return nil
	end

	return (setmetatable(v, object))
end

function object:execute()
	self:refreshClient()
	local options = self:getOptions()
	local skip = options.skip
	local query = options.query

	if skip or query ~= self.previous.query then
		self:removeQuerySubscription()
		self:removeObservable(not Boolean.toJSBoolean(skip))
		self.previous.query = query
	end

	self:updateObservableQuery()
	return self:getExecuteSsrResult() or self:getExecuteResult()
end

function object:executeLazy()
	if Boolean.toJSBoolean(self.runLazy) then
		return table.pack(self.runLazyQuery, self:execute())
	end

	return table.pack(self.runLazyQuery, {
		loading = false,
		networkStatus = networkStatus.ready,
		called = false,
		data = nil
	})
end

function object:fetchData()
	local options = self:getOptions()

	if Boolean.toJSBoolean(Boolean.toJSBoolean(options.skip) and options.skip or options.ssr == false) then
		return false
	end

	return Promise.new(function(p)
		return self:startQuerySubscription(p)
	end)
end

function object:afterExecute(options)
	local v = options or {}
	local v2 = if v.lazy then v.lazy else false
	self.isMounted = true
	local options2 = self:getOptions()
	local v3 = options2.ssr == false

	if
		Boolean.toJSBoolean(self.currentObservable)
		and not (Boolean.toJSBoolean(v3) or Boolean.toJSBoolean(self:ssrInitiated()))
	then
		self:startQuerySubscription()
	end

	if not Boolean.toJSBoolean(v2) or Boolean.toJSBoolean(self.runLazy) then
		self:handleErrorOrCompleted()
	end

	self.previousOptions = options2
	return function(...)
		return self:unmount(...)
	end
end

function object:cleanup()
	self:removeQuerySubscription()
	self:removeObservable(true)
	self.previous.result = nil
end

function object.getOptions(data)
	local options = getmetatable((getmetatable(data))).__index.getOptions(data)

	if Boolean.toJSBoolean(data.lazyOptions) then
		options.variables = Object.assign({}, options.variables, data.lazyOptions.variables)
		options.context = Object.assign({}, options.context, data.lazyOptions.context)
	end

	if Boolean.toJSBoolean(data.runLazy) then
		data.options.skip = nil
	end

	return options
end

function object:ssrInitiated()
	if Boolean.toJSBoolean(self.context) then
		return self.context.renderPromises
	end

	return self.context
end

function object:getExecuteSsrResult()
	local options = self:getOptions()
	local ssr = options.ssr
	local skip = options.skip
	local v = ssr == false
	local disableNetworkFetches = self:refreshClient().client.disableNetworkFetches
	local v2 = Object.assign({}, {
		loading = true,
		networkStatus = networkStatus.loading,
		called = true,
		data = nil,
		stale = false,
		client = self.client
	}, self:observableQueryFields())

	if
		Boolean.toJSBoolean(v)
		and (Boolean.toJSBoolean(self:ssrInitiated()) or Boolean.toJSBoolean(disableNetworkFetches))
	then
		self.previous.result = v2
		return v2
	end

	if not Boolean.toJSBoolean(self:ssrInitiated()) then
		return nil
	end

	v2 = Boolean.toJSBoolean(self:getExecuteResult()) and self:getExecuteResult() or v2

	if Boolean.toJSBoolean(v2.loading) and not Boolean.toJSBoolean(skip) then
		self.context.renderPromises:addQueryPromise(self, function(): nil
			return nil
		end)
	end

	return v2
end

function object:prepareObservableQueryOptions()
	local options = self:getOptions()
	self:verifyDocumentType(options.query, documentType.Query)
	local displayName = Boolean.toJSBoolean(options.displayName) and options.displayName or "Query"

	if
		Boolean.toJSBoolean(self:ssrInitiated())
		and (options.fetchPolicy == "network-only" or options.fetchPolicy == "cache-and-network")
	then
		options.fetchPolicy = "cache-first"
	end

	return Object.assign({}, options, { displayName = displayName, context = options.context })
end

function object:initializeObservableQuery()
	if Boolean.toJSBoolean(self:ssrInitiated()) then
		self.currentObservable = self.context.renderPromises:getSSRObservable(self:getOptions())
	end

	if not Boolean.toJSBoolean(self.currentObservable) then
		local v = self:prepareObservableQueryOptions()
		self.previous.observableQueryOptions = Object.assign({}, v, { children = Object.None })
		self.currentObservable = self:refreshClient().client:watchQuery(Object.assign({}, v))

		if Boolean.toJSBoolean(self:ssrInitiated()) then
			self.context.renderPromises:registerSSRObservable(self.currentObservable, v)
		end
	end
end

function object:updateObservableQuery()
	if not Boolean.toJSBoolean(self.currentObservable) then
		self:initializeObservableQuery()
		return
	end

	local observableQueryOptions = Object.assign({}, self:prepareObservableQueryOptions(), {
		children = Object.None
	})

	if Boolean.toJSBoolean(self:getOptions().skip) then
		self.previous.observableQueryOptions = observableQueryOptions
	elseif not equal(observableQueryOptions, self.previous.observableQueryOptions) then
		self.previous.observableQueryOptions = observableQueryOptions

		self.currentObservable:setOptions(observableQueryOptions):catch(function() end)
	end
end

function object:startQuerySubscription(callback)
	if callback == nil then
		callback = self.onNewData
	end

	if Boolean.toJSBoolean(self.currentSubscription) or Boolean.toJSBoolean(self:getOptions().skip) then
		return
	end

	self.currentSubscription = self.currentObservable:subscribe({
		next = function(_, data)
			local loading = data.loading
			local networkStatus2 = data.networkStatus
			local data2 = data.data
			local result = self.previous.result

			if
				Boolean.toJSBoolean(result)
				and result.loading == loading
				and result.networkStatus == networkStatus2
				and equal(result.data, data2)
			then
				return
			end

			callback(self)
		end,
		error = function(_, err)
			self:resubscribeToQuery()

			if not hasOwnProperty(err, "graphQLErrors") then
				error(err)
			end

			local result = self.previous.result

			if
				Boolean.toJSBoolean(result) and Boolean.toJSBoolean(result.loading)
				or not equal(err, self.previous.error)
			then
				self.previous.error = err
				callback(self)
			end
		end
	})
end

function object:resubscribeToQuery()
	self:removeQuerySubscription()

	local currentObservable = self.currentObservable

	if Boolean.toJSBoolean(currentObservable) then
		local lastError = currentObservable:getLastError()
		local lastResult = currentObservable:getLastResult()
		currentObservable:resetLastResults()
		self:startQuerySubscription()
		Object.assign(currentObservable, { lastError = lastError, lastResult = lastResult })
	end
end

function object:getExecuteResult()
	local executeResult = self:observableQueryFields()
	local options = self:getOptions()

	if Boolean.toJSBoolean(options.skip) then
		executeResult = Object.assign({}, executeResult, {
			["data"] = Object.None,
			error = Object.None,
			loading = false,
			networkStatus = networkStatus.ready,
			called = true
		})
	elseif Boolean.toJSBoolean(self.currentObservable) then
		local currentResult = self.currentObservable:getCurrentResult()

		local data = currentResult.data
		local loading = currentResult.loading
		local partial = currentResult.partial
		local networkStatus2 = currentResult.networkStatus
		local errors2 = currentResult.errors
		local err = currentResult.error

		if Boolean.toJSBoolean(errors2) and #errors2 > 0 then
			err = apolloError.new({ graphQLErrors = errors2 })
		end

		executeResult = Object.assign({}, executeResult, {
			["data"] = data,
			loading = loading,
			networkStatus = networkStatus2,
			error = err,
			called = true
		})

		if not Boolean.toJSBoolean(loading) then
			if Boolean.toJSBoolean(err) then
				Object.assign(executeResult, {
					data = (self.currentObservable:getLastResult() or {}).data
				})
			else
				local fetchPolicy = self.currentObservable.options.fetchPolicy
				local partialRefetch = options.partialRefetch

				if
					Boolean.toJSBoolean(partialRefetch)
					and Boolean.toJSBoolean(partial)
					and (not Boolean.toJSBoolean(data) or #Object.keys(data) == 0)
					and fetchPolicy ~= "cache-only"
				then
					Object.assign(executeResult, {
						loading = true,
						networkStatus = networkStatus.loading
					})
					executeResult:refetch()
					return executeResult
				end
			end
		end
	end

	executeResult.client = self.client

	self:setOptions(options, true)
	local result = self.previous.result

	if Boolean.toJSBoolean(result) and Boolean.toJSBoolean(result.loading) then
		self.previous.loading = result.loading
	else
		self.previous.loading = false
	end

	if Boolean.toJSBoolean(result) then
		executeResult.previousData = Boolean.toJSBoolean(result.data) and result.data or result.previousData
	else
		executeResult.previousData = result
	end

	self.previous.result = executeResult

	if Boolean.toJSBoolean(self.currentObservable) then
		self.currentObservable:resetQueryStoreErrors()
	end

	return executeResult
end

function object:handleErrorOrCompleted()
	if not (self.currentObservable and self.previous.result) then
		return
	end

	local result = self.previous.result
	local data = result.data
	local loading = result.loading
	local err = result.error

	if not Boolean.toJSBoolean(loading) then
		local options = self:getOptions()

		local query = options.query
		local variables = options.variables
		local onCompleted = options.onCompleted
		local onError = options.onError
		local skip = options.skip

		if
			Boolean.toJSBoolean(self.previousOptions)
			and not Boolean.toJSBoolean(self.previous.loading)
			and equal(self.previousOptions.query, query)
			and equal(self.previousOptions.variables, variables)
		then
			return
		end

		if Boolean.toJSBoolean(onCompleted) and not (Boolean.toJSBoolean(err) or Boolean.toJSBoolean(skip)) then
			onCompleted(data)
		elseif Boolean.toJSBoolean(onError) and Boolean.toJSBoolean(err) then
			onError(err)
		end
	end
end

function object:removeQuerySubscription()
	if Boolean.toJSBoolean(self.currentSubscription) then
		self.currentSubscription:unsubscribe()
		self.currentSubscription = nil
	end
end

function object:removeObservable(flag: boolean)
	if Boolean.toJSBoolean(self.currentObservable) then
		self.currentObservable.tearDownQuery(self.currentObservable)

		if Boolean.toJSBoolean(flag) then
			self.currentObservable = nil
		end
	end
end

function object:observableQueryFields()
	local variables

	if Boolean.toJSBoolean(self.currentObservable) then
		variables = self.currentObservable.variables
	end

	return {
		variables = variables,
		refetch = self.obsRefetch,
		fetchMore = self.obsFetchMore,
		updateQuery = self.obsUpdateQuery,
		startPolling = self.obsStartPolling,
		stopPolling = self.obsStopPolling,
		subscribeToMore = self.obsSubscribeToMore
	}
end

return { QueryData = object }
