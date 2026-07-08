local t1 = {}
local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Promise = require(ParentParentParent.Promise)
local LuauPolyfill = require(ParentParentParent.LuauPolyfill)
local Boolean = LuauPolyfill.Boolean
local Object = LuauPolyfill.Object
local hasOwnProperty = require(ParentParent.luaUtils.hasOwnProperty)
local equal = require(ParentParent.jsutils.equal)
local ApolloError = require(ParentParent.errors).ApolloError
local NetworkStatus = require(script.Parent.Parent.Parent.core).NetworkStatus

require(ParentParent.utilities)

local DocumentType = require(script.Parent.Parent.parser).DocumentType

require(script.Parent.Parent.types.types)

local OperationData = require(script.Parent.OperationData).OperationData
local self = setmetatable({}, {
	__index = OperationData
})

self.__index = self

function self.new(t2: {[any]: any}) -- line: 114
	-- upvalues: OperationData (copy), Boolean (copy), self (copy)
	local options = t2.options
	local context = t2.context
	local onNewData = t2.onNewData
	local v19 = OperationData.new(options, context)

	v19.runLazy = false
	v19.previous = {}
	v19.onNewData = onNewData

	function v19.runLazyQuery(p1) -- line: 133
		-- upvalues: v19 (copy)
		v19:cleanup()
		v19.runLazy = true
		v19.lazyOptions = p1
		v19:onNewData()
	end
	function v19.obsRefetch(_, p3) -- line: 140
		-- upvalues: Boolean (copy), v19 (copy)
		if Boolean.toJSBoolean(v19.currentObservable) then
			return v19.currentObservable:refetch(p3)
		end

		return nil
	end
	function v19.obsFetchMore(_, p5) -- line: 147
		-- upvalues: v19 (copy)
		if v19.currentObservable then
			return (v19.currentObservable:fetchMore(p5))
		end

		return nil
	end
	function v19.obsUpdateQuery(_, p7: ((...any) -> ...any)) -- line: 161
		-- upvalues: v19 (copy)
		if v19.currentObservable then
			return (v19.currentObservable:updateQuery(p7))
		end

		return nil
	end
	function v19.obsStartPolling(_, n1: number) -- line: 168
		-- upvalues: v19 (copy)
		if v19.currentObservable then
			return (v19.currentObservable:startPolling(n1))
		end

		return nil
	end
	function v19.obsStopPolling(_) -- line: 172
		-- upvalues: v19 (copy)
		if v19.currentObservable then
			return (v19.currentObservable:stopPolling())
		end

		return nil
	end
	function v19.obsSubscribeToMore(p10) -- line: 187
		-- upvalues: v19 (copy)
		if v19.currentObservable then
			return (v19.currentObservable:subscribeToMore(p10))
		end

		return nil
	end

	return (setmetatable(v19, self))
end
function self.execute(p11) -- line: 200
	-- upvalues: Boolean (copy)
	p11:refreshClient()

	local v21 = p11:getOptions()
	local skip = v21.skip
	local query = v21.query

	if skip or query ~= p11.previous.query then
		p11:removeQuerySubscription()
		p11:removeObservable(not Boolean.toJSBoolean(skip))
		p11.previous.query = query
	end

	p11:updateObservableQuery()

	return p11:getExecuteSsrResult() or p11:getExecuteResult()
end
function self.executeLazy(p12) -- line: 214
	-- upvalues: Boolean (copy), NetworkStatus (copy)
	if not Boolean.toJSBoolean(p12.runLazy) then
		return table.pack(p12.runLazyQuery, {
			loading = false,
			called = false,
			data = nil,
			networkStatus = NetworkStatus.ready
		})
	end

	return table.pack(p12.runLazyQuery, p12:execute())
end
function self.fetchData(p13) -- line: 226
	-- upvalues: Boolean (copy), Promise (copy)
	local v26 = p13:getOptions()

	if Boolean.toJSBoolean(Boolean.toJSBoolean(v26.skip) and v26.skip or v26.ssr == false) then
		return false
	end

	return Promise.new(function(resolve) -- line: 231
		-- upvalues: p13 (copy)
		return p13:startQuerySubscription(resolve)
	end)
end
function self.afterExecute(t3: {[any]: any}, t4: {[any]: any}?) -- line: 236
	-- upvalues: Boolean (copy)
	local v29 = t4 or {}
	local v30 = not not v29.lazy and v29.lazy

	t3.isMounted = true

	local v31 = t3:getOptions()
	local v32 = v31.ssr == false

	if Boolean.toJSBoolean(t3.currentObservable) and (not Boolean.toJSBoolean(v32) and not Boolean.toJSBoolean(t3:ssrInitiated())) then
		t3:startQuerySubscription()
	end

	if not Boolean.toJSBoolean(v30) or Boolean.toJSBoolean(t3.runLazy) then
		t3:handleErrorOrCompleted()
	end

	t3.previousOptions = v31

	return function(...) -- line: 254
		-- upvalues: t3 (copy)
		return t3:unmount(...)
	end
end
function self.cleanup(p14) -- line: 259
	p14:removeQuerySubscription()
	p14:removeObservable(true)
	p14.previous.result = nil
end
function self.getOptions(p15) -- line: 265
	-- upvalues: Boolean (copy), Object (copy)
	local v35 = getmetatable((getmetatable(p15))).__index.getOptions(p15)

	if Boolean.toJSBoolean(p15.lazyOptions) then
		v35.variables = Object.assign({}, v35.variables, p15.lazyOptions.variables)
		v35.context = Object.assign({}, v35.context, p15.lazyOptions.context)
	end

	if Boolean.toJSBoolean(p15.runLazy) then
		p15.options.skip = nil
	end

	return v35
end
function self.ssrInitiated(p16) -- line: 281
	-- upvalues: Boolean (copy)
	if Boolean.toJSBoolean(p16.context) then
		return p16.context.renderPromises
	end

	return p16.context
end
function self.getExecuteSsrResult(p17) -- line: 289
	-- upvalues: Object (copy), NetworkStatus (copy), Boolean (copy)
	local v38 = p17:getOptions()
	local ssr = v38.ssr
	local skip = v38.skip
	local v41 = ssr == false
	local disableNetworkFetches = p17:refreshClient().client.disableNetworkFetches
	local v43 = Object.assign({}, {
		loading = true,
		called = true,
		data = nil,
		stale = false,
		networkStatus = NetworkStatus.loading,
		client = p17.client
	}, p17:observableQueryFields())

	if Boolean.toJSBoolean(v41) and (Boolean.toJSBoolean(p17:ssrInitiated()) or Boolean.toJSBoolean(disableNetworkFetches)) then
		p17.previous.result = v43

		return v43
	end

	if Boolean.toJSBoolean(p17:ssrInitiated()) then
		local v44 = Boolean.toJSBoolean(p17:getExecuteResult()) and p17:getExecuteResult() or v43

		if Boolean.toJSBoolean(v44.loading) and not Boolean.toJSBoolean(skip) then
			p17.context.renderPromises:addQueryPromise(p17, function() -- line: 315
				return nil
			end)
		end

		return v44
	end

	return nil
end
function self.prepareObservableQueryOptions(p18) -- line: 325
	-- upvalues: DocumentType (copy), Boolean (copy), Object (copy)
	local v46 = p18:getOptions()

	p18:verifyDocumentType(v46.query, DocumentType.Query)

	local v47 = Boolean.toJSBoolean(v46.displayName) and v46.displayName or "Query"

	if Boolean.toJSBoolean(p18:ssrInitiated()) and (v46.fetchPolicy == "network-only" or v46.fetchPolicy == "cache-and-network") then
		v46.fetchPolicy = "cache-first"
	end

	return Object.assign({}, v46, {
		displayName = v47,
		context = v46.context
	})
end
function self.initializeObservableQuery(p19) -- line: 341
	-- upvalues: Boolean (copy), Object (copy)
	if Boolean.toJSBoolean(p19:ssrInitiated()) then
		p19.currentObservable = p19.context.renderPromises:getSSRObservable(p19:getOptions())
	end

	if not Boolean.toJSBoolean(p19.currentObservable) then
		local v49 = p19:prepareObservableQueryOptions()

		p19.previous.observableQueryOptions = Object.assign({}, v49, {
			children = Object.None
		})
		p19.currentObservable = p19:refreshClient().client:watchQuery(Object.assign({}, v49))

		if Boolean.toJSBoolean(p19:ssrInitiated()) then
			p19.context.renderPromises:registerSSRObservable(p19.currentObservable, v49)
		end
	end
end
function self.updateObservableQuery(p20) -- line: 358
	-- upvalues: Boolean (copy), Object (copy), equal (copy)
	if not Boolean.toJSBoolean(p20.currentObservable) then
		p20:initializeObservableQuery()

		return
	end

	local v51 = Object.assign({}, p20:prepareObservableQueryOptions(), {
		children = Object.None
	})

	if Boolean.toJSBoolean(p20:getOptions().skip) then
		p20.previous.observableQueryOptions = v51

		return
	end

	if not equal(v51, p20.previous.observableQueryOptions) then
		p20.previous.observableQueryOptions = v51
		p20.currentObservable:setOptions(v51):catch(function() -- line: 378
		end)
	end
end
function self.startQuerySubscription(t5: {[any]: any}, p21: ((...any) -> ...any)?) -- line: 388
	-- upvalues: Boolean (copy), equal (copy), hasOwnProperty (copy)
	if p21 == nil then
		p21 = t5.onNewData
	end

	if Boolean.toJSBoolean(t5.currentSubscription) or Boolean.toJSBoolean(t5:getOptions().skip) then
		return
	end

	t5.currentSubscription = t5.currentObservable:subscribe({
		next = function(_, p23) -- line: 396
			-- upvalues: t5 (copy), Boolean (copy), equal (copy), p21 (ref)
			local loading = p23.loading
			local networkStatus = p23.networkStatus
			local data = p23.data
			local result = t5.previous.result

			if Boolean.toJSBoolean(result) and (loading == result.loading and networkStatus == result.networkStatus and equal(result.data, data)) then
				return
			end

			p21(t5)
		end,
		error = function(_, p25) -- line: 412
			-- upvalues: t5 (copy), hasOwnProperty (copy), Boolean (copy), equal (copy), p21 (ref)
			t5:resubscribeToQuery()

			if not hasOwnProperty(p25, "graphQLErrors") then
				error(p25)
			end

			local result = t5.previous.result

			if Boolean.toJSBoolean(result) and Boolean.toJSBoolean(result.loading) or not equal(p25, t5.previous.error) then
				t5.previous.error = p25
				p21(t5)
			end
		end
	})
end
function self.resubscribeToQuery(p26) -- line: 429
	-- upvalues: Boolean (copy), Object (copy)
	p26:removeQuerySubscription()

	local currentObservable = p26.currentObservable

	if Boolean.toJSBoolean(currentObservable) then
		local v57 = currentObservable:getLastError()
		local v58 = currentObservable:getLastResult()

		currentObservable:resetLastResults()
		p26:startQuerySubscription()
		Object.assign(currentObservable, {
			lastError = v57,
			lastResult = v58
		})
	end
end
function self.getExecuteResult(p27) -- line: 449
	-- upvalues: Boolean (copy), Object (copy), NetworkStatus (copy), ApolloError (copy)
	local v60 = p27:observableQueryFields()
	local v61 = p27:getOptions()

	if Boolean.toJSBoolean(v61.skip) then
		v60 = Object.assign({}, v60, {
			data = Object.None,
			error = Object.None,
			loading = false,
			networkStatus = NetworkStatus.ready,
			called = true
		})
	elseif Boolean.toJSBoolean(p27.currentObservable) then
		local v62 = p27.currentObservable:getCurrentResult()
		local data = v62.data
		local loading = v62.loading
		local partial = v62.partial
		local networkStatus = v62.networkStatus
		local errors = v62.errors
		local error2 = v62.error

		if Boolean.toJSBoolean(errors) and #errors > 0 then
			error2 = ApolloError.new({
				graphQLErrors = errors
			})
		end

		v60 = Object.assign({}, v60, {
			data = data,
			loading = loading,
			networkStatus = networkStatus,
			error = error2,
			called = true
		})

		if not Boolean.toJSBoolean(loading) then
			if Boolean.toJSBoolean(error2) then
				Object.assign(v60, {
					data = (p27.currentObservable:getLastResult() or {}).data
				})
			else
				local fetchPolicy = p27.currentObservable.options.fetchPolicy
				local partialRefetch = v61.partialRefetch

				if Boolean.toJSBoolean(partialRefetch) and Boolean.toJSBoolean(partial) and ((not Boolean.toJSBoolean(data) or #Object.keys(data) == 0) and fetchPolicy ~= "cache-only") then
					Object.assign(v60, {
						loading = true,
						networkStatus = NetworkStatus.loading
					})
					v60:refetch()

					return v60
				end
			end
		end
	end

	v60.client = p27.client
	p27:setOptions(v61, true)

	local result = p27.previous.result

	if Boolean.toJSBoolean(result) and Boolean.toJSBoolean(result.loading) then
		p27.previous.loading = result.loading
	else
		p27.previous.loading = false
	end

	if Boolean.toJSBoolean(result) then
		v60.previousData = Boolean.toJSBoolean(result.data) and result.data or result.previousData
	else
		v60.previousData = result
	end

	p27.previous.result = v60

	if Boolean.toJSBoolean(p27.currentObservable) then
		p27.currentObservable:resetQueryStoreErrors()
	end

	return v60
end
function self.handleErrorOrCompleted(p28) -- line: 554
	-- upvalues: Boolean (copy), equal (copy)
	if not p28.currentObservable or not p28.previous.result then
		return
	end

	local result = p28.previous.result
	local data = result.data
	local loading = result.loading
	local error3 = result.error

	if not Boolean.toJSBoolean(loading) then
		local v77 = p28:getOptions()
		local query = v77.query
		local variables = v77.variables
		local onCompleted = v77.onCompleted
		local onError = v77.onError
		local skip = v77.skip

		if Boolean.toJSBoolean(p28.previousOptions) and not Boolean.toJSBoolean(p28.previous.loading) and equal(p28.previousOptions.query, query) and equal(p28.previousOptions.variables, variables) then
			return
		end

		if Boolean.toJSBoolean(onCompleted) and not Boolean.toJSBoolean(error3) and not Boolean.toJSBoolean(skip) then
			onCompleted(data)

			return
		end

		if Boolean.toJSBoolean(onError) and Boolean.toJSBoolean(error3) then
			onError(error3)
		end
	end
end
function self.removeQuerySubscription(p29) -- line: 583
	-- upvalues: Boolean (copy)
	if Boolean.toJSBoolean(p29.currentSubscription) then
		p29.currentSubscription:unsubscribe()
		p29.currentSubscription = nil
	end
end
function self.removeObservable(t6: {[any]: any}, b1: boolean) -- line: 590
	-- upvalues: Boolean (copy)
	if Boolean.toJSBoolean(t6.currentObservable) then
		t6.currentObservable.tearDownQuery(t6.currentObservable)

		if Boolean.toJSBoolean(b1) then
			t6.currentObservable = nil
		end
	end
end
function self.observableQueryFields(p30) -- line: 599
	-- upvalues: Boolean (copy)
	return {
		variables = if not Boolean.toJSBoolean(p30.currentObservable) then nil else p30.currentObservable.variables,
		refetch = p30.obsRefetch,
		fetchMore = p30.obsFetchMore,
		updateQuery = p30.obsUpdateQuery,
		startPolling = p30.obsStartPolling,
		stopPolling = p30.obsStopPolling,
		subscribeToMore = p30.obsSubscribeToMore
	}
end

t1.QueryData = self

return t1
