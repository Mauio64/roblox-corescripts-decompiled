local Players = game:GetService("Players")
local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent
require(DataHydration.DataHydrationTypes)
local DataHydrationUtils = require(DataHydration.DataHydrationUtils)
local getLocalPlayerUserId = DataHydrationUtils.getLocalPlayerUserId
local observeLocalPlayerUserId = DataHydrationUtils.observeLocalPlayerUserId
local createRequestQueue = require(DataHydration.createRequestQueue)
local createMutationLayer = require(DataHydration.createMutationLayer)
local Promise = require(parent.Promise)
local Signals = require(parent.Signals)
local SharedFlags = require(parent.SharedFlags)
local FFlagDataHydrationAccountReset = SharedFlags.FFlagDataHydrationAccountReset
local SharedFlags2 = require(parent.SharedFlags)
local FFlagSduiReleaseSearchResultsPageState = SharedFlags2.FFlagSduiReleaseSearchResultsPageState
local FFlagBuildExperienceMonetizationMultiKind = require(DataHydration.Flags.FFlagBuildExperienceMonetizationMultiKind)

local defineFastInt = game:DefineFastInt("LuaAppDataHydrationDefaultBatchSize", 50)
local defineFastInt2 = game:DefineFastInt("LuaAppDataHydrationQueueProcessDelaySec", 1)

local defineFastInt3 = game:DefineFastInt("LuaAppDataHydrationDefaultRequestTimeoutSec", 30)

local function createDataResolver(data)
	local v = data.supportsMultiGet == nil or data.supportsMultiGet
	local requestBatchSize = data.requestBatchSize or defineFastInt
	local v2 = not (v or data.requestBatchSize) and 1 or requestBatchSize

	local queueProcessDelaySec = data.queueProcessDelaySec or defineFastInt2
	local v3 = not (v or data.queueProcessDelaySec) and 0 or queueProcessDelaySec

	local requestTimeoutSec = data.requestTimeoutSec or defineFastInt3
	local cache = data.cache
	local requestQueue = createRequestQueue()

	local v4 = {}

	local v5 = {}
	local thread = nil
	local v6 = getLocalPlayerUserId()

	local v7 = nil
	local v8 = nil
	local v9, v10

	if FFlagDataHydrationAccountReset then
		v9, v10 = Signals.createSignal(0)
	else
		v9 = nil
		v10 = nil
	end

	if FFlagBuildExperienceMonetizationMultiKind then
		v7, v8 = Signals.createSignal(0)
	end

	local v11

	if data.supportsMutations then
		v11 = createMutationLayer()
	else
		v11 = nil
	end

	local function FORCE_FETCH(): boolean
		return true
	end

	local function logError(p) -- 1 equivalent call inferred from this helper
		if data.logError then
			data.logError(p)
		end
	end

	local function isCurrentRequest(p: number?, p2: number?): boolean
		return p2 == v9(false) and p == getLocalPlayerUserId()
	end

	local function snapshotEpochs(items) -- 4 equivalent calls inferred from this helper
		local result = {}

		for _, item in items do
			result[item] = v5[item] or 0
		end

		return result
	end

	local function filterCurrentIds(items, p)
		local result = {}

		for _, item in items do
			if p[item] == (v5[item] or 0) then
				table.insert(result, item)
			end
		end

		return result
	end

	local function handleFailure(p: string, p2, p3: number?, p4: number?, p5)
		if FFlagDataHydrationAccountReset then
			local v12

			if p4 == v9(false) then
				v12 = p3 == getLocalPlayerUserId()
			else
				v12 = false
			end

			if not v12 then
				return
			end
		elseif p3 ~= v6 then
			return
		end

		local v12 = filterCurrentIds(p2, p5)

		if #v12 == 0 then
			return
		end

		logError(p) -- inferred equivalent call

		for _, v13 in v12 do
			v4[v13] = nil
		end

		cache.markItemsAsFailed(v12)

		if v11 then
			v11.drainCommitted(v12, cache.updateItem)
		end
	end

	local function handleSuccess(items, p, p2: number?, p3: number?, p4)
		if FFlagDataHydrationAccountReset then
			local v12

			if p3 == v9(false) then
				v12 = p2 == getLocalPlayerUserId()
			else
				v12 = false
			end

			if not v12 then
				return
			end
		elseif p2 ~= v6 then
			return
		end

		local v12 = filterCurrentIds(p, p4)
		local v13 = {}

		for k, item in items do
			if p4[k] == nil or p4[k] == (v5[k] or 0) then
				v13[k] = item
			end
		end

		for k, _ in v13 do
			v4[k] = nil
		end

		if data.replaceItems then
			cache.replaceItems(v13)
		else
			cache.updateItems(v13)
		end

		local v14 = {}

		for _, v15 in v12 do
			if v13[v15] ~= nil then
				continue
			end

			if v11 and v11.isCommitted(v15) then
				v4[v15] = nil
			else
				table.insert(v14, v15)
			end
		end

		if v11 then
			v11.drainCommitted(v12, cache.updateItem)
		end

		if #v14 > 0 then
			handleFailure("Items missing in response", v14, p2, p3, p4)
		end
	end

	local function scheduleFetch()
		if thread ~= nil or requestQueue.isEmpty() then
			return
		end

		thread = task.delay(v3, function()
			local v12 = v6
			local v13

			if FFlagDataHydrationAccountReset then
				v13 = v9(false)
			else
				v13 = nil
			end

			thread = nil

			if requestQueue.isEmpty() then
				return
			end

			local v14 = requestQueue.pop(v2)

			for _, v15 in v14 do
				v4[v15] = true
			end

			local result2 = snapshotEpochs(v14) -- inferred equivalent call
			local items = cache.getItems(v14)

			local flag = false

			local thread2 = task.delay(requestTimeoutSec, function()
				if data.ignoreResponsesAfterTimeout then
					flag = true
				end

				handleFailure(`No fetch response after {requestTimeoutSec} sec`, v14, v12, v13, result2)
			end)

			local success, result = pcall(function()
				if v then
					data.fetchFn(items):andThen(function(p)
						if flag then
							return
						end

						handleSuccess(p, v14, v12, v13, result2)
						task.cancel(thread2)
					end):catch(function(p)
						if flag then
							return
						end

						handleFailure(p, v14, v12, v13, result2)
						task.cancel(thread2)
					end)

					return
				end

				local v15 = {}

				for _, v16 in v14 do
					local item = items[v16]
					table.insert(v15, data.fetchFn(v16, item))
				end

				Promise.all(v15):andThen(function(p)
					if flag then
						return
					end

					local v16 = {}

					for k, v17 in v14 do
						v16[v17] = p[k]
					end

					handleSuccess(v16, v14, v12, v13, result2)
					task.cancel(thread2)
				end):catch(function(p)
					if flag then
						return
					end

					handleFailure(p, v14, v12, v13, result2)
					task.cancel(thread2)
				end)
			end)

			if not success then
				handleFailure(result, v14, v12, v13, result2)
				task.cancel(thread2)
			end

			scheduleFetch()
		end)
	end

	local function isRequestInQueueOrInFlight(p: string): boolean -- 1 equivalent call inferred from this helper
		if requestQueue.hasItem(p) then
			return true
		end

		return v4[p] ~= nil
	end

	local function getAndFetchItems(p, callback, p2: number?)
		local items, v12 = cache.getItems(p, callback, p2)
		local fetchItems = {}
		local v13 = {}

		for k, item in items do
			fetchItems[k] = item

			if not v12[k] or requestQueue.hasItem(k) or v4[k] ~= nil then
				continue
			end

			requestQueue.push(k)
			table.insert(v13, k)
		end

		if #v13 > 0 then
			cache.resetFailedItems(v13)
		end

		if not requestQueue.isEmpty() and thread == nil then
			if requestQueue.isEmpty() then
				return fetchItems
			end

			thread = task.delay(v3, function()
				local v14 = v6
				local v15

				if FFlagDataHydrationAccountReset then
					v15 = v9(false)
				else
					v15 = nil
				end

				thread = nil

				if requestQueue.isEmpty() then
					return
				end

				local v16 = requestQueue.pop(v2)

				for _, v17 in v16 do
					v4[v17] = true
				end

				local result2 = snapshotEpochs(v16) -- inferred equivalent call
				local items2 = cache.getItems(v16)

				local flag = false

				local thread2 = task.delay(requestTimeoutSec, function()
					if data.ignoreResponsesAfterTimeout then
						flag = true
					end

					handleFailure(`No fetch response after {requestTimeoutSec} sec`, v16, v14, v15, result2)
				end)

				local success, result = pcall(function()
					if v then
						data.fetchFn(items2):andThen(function(p3)
							if flag then
								return
							end

							handleSuccess(p3, v16, v14, v15, result2)
							task.cancel(thread2)
						end):catch(function(p3)
							if flag then
								return
							end

							handleFailure(p3, v16, v14, v15, result2)
							task.cancel(thread2)
						end)

						return
					end

					local v17 = {}

					for _, v18 in v16 do
						local item = items2[v18]
						table.insert(v17, data.fetchFn(v18, item))
					end

					Promise.all(v17):andThen(function(p3)
						if flag then
							return
						end

						local v18 = {}

						for k, v19 in v16 do
							v18[v19] = p3[k]
						end

						handleSuccess(v18, v16, v14, v15, result2)
						task.cancel(thread2)
					end):catch(function(p3)
						if flag then
							return
						end

						handleFailure(p3, v16, v14, v15, result2)
						task.cancel(thread2)
					end)
				end)

				if not success then
					handleFailure(result, v16, v14, v15, result2)
					task.cancel(thread2)
				end

				scheduleFetch()
			end)
		end

		return fetchItems
	end

	local function getAndFetchItem(p: string, callback, p2: number?)
		local item, v12 = cache.getItem(p, callback, p2)

		if v12 and not requestQueue.hasItem(p) and v4[p] == nil then
			cache.resetFailedItem(p)
			requestQueue.push(p)
		end

		if not requestQueue.isEmpty() and thread == nil then
			if requestQueue.isEmpty() then
				return item, v12
			end

			thread = task.delay(v3, function()
				local v13 = v6
				local v14

				if FFlagDataHydrationAccountReset then
					v14 = v9(false)
				else
					v14 = nil
				end

				thread = nil

				if requestQueue.isEmpty() then
					return
				end

				local v15 = requestQueue.pop(v2)

				for _, v16 in v15 do
					v4[v16] = true
				end

				local result2 = snapshotEpochs(v15) -- inferred equivalent call
				local items = cache.getItems(v15)

				local flag = false

				local thread2 = task.delay(requestTimeoutSec, function()
					if data.ignoreResponsesAfterTimeout then
						flag = true
					end

					handleFailure(`No fetch response after {requestTimeoutSec} sec`, v15, v13, v14, result2)
				end)

				local success, result = pcall(function()
					if v then
						data.fetchFn(items):andThen(function(p3)
							if flag then
								return
							end

							handleSuccess(p3, v15, v13, v14, result2)
							task.cancel(thread2)
						end):catch(function(p3)
							if flag then
								return
							end

							handleFailure(p3, v15, v13, v14, result2)
							task.cancel(thread2)
						end)

						return
					end

					local v16 = {}

					for _, v17 in v15 do
						local item2 = items[v17]
						table.insert(v16, data.fetchFn(v17, item2))
					end

					Promise.all(v16):andThen(function(p3)
						if flag then
							return
						end

						local v17 = {}

						for k, v18 in v15 do
							v17[v18] = p3[k]
						end

						handleSuccess(v17, v15, v13, v14, result2)
						task.cancel(thread2)
					end):catch(function(p3)
						if flag then
							return
						end

						handleFailure(p3, v15, v13, v14, result2)
						task.cancel(thread2)
					end)
				end)

				if not success then
					handleFailure(result, v15, v13, v14, result2)
					task.cancel(thread2)
				end

				scheduleFetch()
			end)
		end

		return item, v12
	end

	local function getCachedItem(p: string) -- 1 equivalent call inferred from this helper
		return cache.getItem(p)
	end

	local function getCachedItems(p) -- 1 equivalent call inferred from this helper
		return cache.getItems(p)
	end

	local function fetchItem(p: string, callback)
		return getAndFetchItem(p, callback or FORCE_FETCH)
	end

	local function fetchItems(p, callback)
		return getAndFetchItems(p, callback or FORCE_FETCH)
	end

	local function refetchItem(p: string)
		v5[p] = (v5[p] or 0) + 1
		v4[p] = nil
		cache.resetFailedItem(p)

		if not requestQueue.hasItem(p) then
			requestQueue.push(p)
		end

		if thread == nil and not requestQueue.isEmpty() then
			thread = task.delay(v3, function()
				local v12 = v6
				local v13

				if FFlagDataHydrationAccountReset then
					v13 = v9(false)
				else
					v13 = nil
				end

				thread = nil

				if requestQueue.isEmpty() then
					return
				end

				local v14 = requestQueue.pop(v2)

				for _, v15 in v14 do
					v4[v15] = true
				end

				local result2 = snapshotEpochs(v14) -- inferred equivalent call
				local items = cache.getItems(v14)

				local flag = false

				local thread2 = task.delay(requestTimeoutSec, function()
					if data.ignoreResponsesAfterTimeout then
						flag = true
					end

					handleFailure(`No fetch response after {requestTimeoutSec} sec`, v14, v12, v13, result2)
				end)

				local success, result = pcall(function()
					if v then
						data.fetchFn(items):andThen(function(p2)
							if flag then
								return
							end

							handleSuccess(p2, v14, v12, v13, result2)
							task.cancel(thread2)
						end):catch(function(p2)
							if flag then
								return
							end

							handleFailure(p2, v14, v12, v13, result2)
							task.cancel(thread2)
						end)

						return
					end

					local v15 = {}

					for _, v16 in v14 do
						local item = items[v16]
						table.insert(v15, data.fetchFn(v16, item))
					end

					Promise.all(v15):andThen(function(p2)
						if flag then
							return
						end

						local v16 = {}

						for k, v17 in v14 do
							v16[v17] = p2[k]
						end

						handleSuccess(v16, v14, v12, v13, result2)
						task.cancel(thread2)
					end):catch(function(p2)
						if flag then
							return
						end

						handleFailure(p2, v14, v12, v13, result2)
						task.cancel(thread2)
					end)
				end)

				if not success then
					handleFailure(result, v14, v12, v13, result2)
					task.cancel(thread2)
				end

				scheduleFetch()
			end)
		end

		return cache.getItem(p)
	end

	local function releaseItem(p: string)
		requestQueue.remove(p)

		if v4[p] then
			v4[p] = nil

			v5[p] = (v5[p] or 0) + 1
		end

		if cache.removeItem then
			cache.removeItem(p)
		end
	end

	local function clearResolverState(flag: boolean)
		if FFlagDataHydrationAccountReset then
			v10(v9(false) + 1)
		end

		if thread then
			task.cancel(thread)
			thread = nil
		end

		v4 = {}

		if FFlagDataHydrationAccountReset then
			requestQueue.clear()

			if v11 then
				v11.clearAll()
			end

			if data.onBeforeClear then
				data.onBeforeClear()
			end

			if not flag then
				cache.clear()
			end

			if data.onClear then
				data.onClear()
			end
		else
			cache.clear()
			requestQueue.clear()

			if v11 then
				v11.clearAll()
			end

			if data.onClear then
				data.onClear()
			end
		end
	end

	local function clear() -- 2 equivalent calls inferred from this helper
		clearResolverState(false)
	end

	local localPlayerChangedConnection = nil
	local v12 = nil

	if FFlagDataHydrationAccountReset then
		v12 = observeLocalPlayerUserId(function(p)
			v6 = p
			clearResolverState(data.keepCacheOnAccountReset == true)

			if FFlagBuildExperienceMonetizationMultiKind then
				v8(v7(false) + 1)
			end
		end)
	else
		localPlayerChangedConnection = Players:GetPropertyChangedSignal("LocalPlayer"):Connect(function()
			local localPlayerUserId = getLocalPlayerUserId()

			if localPlayerUserId ~= v6 then
				v6 = localPlayerUserId
				clear() -- inferred equivalent call

				if FFlagBuildExperienceMonetizationMultiKind then
					v8(v7(false) + 1)
				end
			end
		end)
	end

	local function dispose()
		if v12 then
			v12()
			v12 = nil
		end

		if localPlayerChangedConnection then
			localPlayerChangedConnection:Disconnect()
			localPlayerChangedConnection = nil
		end

		if FFlagDataHydrationAccountReset then
			clear() -- inferred equivalent call
		end

		cache.dispose()
	end

	local dataResolver = {
		getAndFetchItems = getAndFetchItems,
		getAndFetchItem = getAndFetchItem,
		getCachedItem = getCachedItem,
		getCachedItems = getCachedItems,
		fetchItem = fetchItem,
		fetchItems = fetchItems,
		refetchItem = refetchItem,
		isRequestInQueueOrInFlight = isRequestInQueueOrInFlight,
		releaseItem = nil,
		dispose = nil,
		clear = nil,
		getAccountGeneration = nil,
		getAccountResetGeneration = nil,
		isCurrentRequest = nil
	}

	if not FFlagSduiReleaseSearchResultsPageState then
		releaseItem = nil
	end

	dataResolver.releaseItem = releaseItem
	dataResolver.dispose = dispose
	dataResolver.clear = clear
	local getAccountGeneration

	if FFlagDataHydrationAccountReset then
		getAccountGeneration = v9
	end

	dataResolver.getAccountGeneration = getAccountGeneration
	local getAccountResetGeneration

	if FFlagBuildExperienceMonetizationMultiKind then
		getAccountResetGeneration = v7
	end

	dataResolver.getAccountResetGeneration = getAccountResetGeneration

	if not FFlagDataHydrationAccountReset then
		isCurrentRequest = nil
	end

	dataResolver.isCurrentRequest = isCurrentRequest

	if not v11 then
		return dataResolver
	end

	function dataResolver.getOptimisticCachedItem(p: string)
		local cachedItem, v13 = getCachedItem(p) -- inferred equivalent call

		return v11.getMergedResult(p, cachedItem), v13
	end

	function dataResolver.getOptimisticCachedItems(p)
		local cachedItems, v13 = getCachedItems(p) -- inferred equivalent call

		local result = {}

		for k, cachedItem in cachedItems do
			result[k] = v11.getMergedResult(k, cachedItem)
		end

		return result, v13
	end

	function dataResolver.getOptimisticAndFetchItem(p: string, callback, p2: number?)
		local fetchItem2, v13 = getAndFetchItem(p, callback, p2)
		return v11.getMergedResult(p, fetchItem2), v13
	end

	function dataResolver.getOptimisticAndFetchItems(p, callback, p2: number?)
		local fetchItems2 = getAndFetchItems(p, callback, p2)
		local result = {}

		for k, fetchItem2 in fetchItems2 do
			result[k] = v11.getMergedResult(k, fetchItem2)
		end

		return result
	end

	function dataResolver.setMutation(p: string, p2)
		v11.set(p, p2)
	end

	function dataResolver.clearMutation(p: string)
		v11.clear(p)
	end

	function dataResolver.commitMutation(p: string)
		if isRequestInQueueOrInFlight(p) then -- inferred equivalent call
			v11.markCommitted(p)
			return
		end

		local v13 = v11.get(p)

		if v13 ~= nil then
			cache.updateItem(p, v13)
		end

		v11.clear(p)
	end

	return dataResolver
end

return createDataResolver
