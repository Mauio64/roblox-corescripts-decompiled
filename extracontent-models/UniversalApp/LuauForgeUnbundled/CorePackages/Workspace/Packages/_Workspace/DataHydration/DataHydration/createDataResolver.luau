local Players = game:GetService("Players")

require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/DataHydrationTypes")
local DataHydrationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/DataHydrationUtils")
local getLocalPlayerUserId = DataHydrationUtils.getLocalPlayerUserId
local observeLocalPlayerUserId = DataHydrationUtils.observeLocalPlayerUserId
local createRequestQueue = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createRequestQueue")
local createMutationLayer = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createMutationLayer")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Promise")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Signals")
local fFlagDataHydrationAccountReset = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/SharedFlags").FFlagDataHydrationAccountReset
local fFlagSduiReleaseSearchResultsPageState = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/SharedFlags").FFlagSduiReleaseSearchResultsPageState
local FFlagBuildExperienceMonetizationMultiKind = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Flags/FFlagBuildExperienceMonetizationMultiKind")

local defineFastInt = game:DefineFastInt("LuaAppDataHydrationDefaultBatchSize", 50)
local defineFastInt2 = game:DefineFastInt("LuaAppDataHydrationQueueProcessDelaySec", 1)

local defineFastInt3 = game:DefineFastInt("LuaAppDataHydrationDefaultRequestTimeoutSec", 30)

local function createDataResolver(data)
	local v5 = data.supportsMultiGet == nil or data.supportsMultiGet
	local requestBatchSize = data.requestBatchSize or defineFastInt
	local v6 = not (v5 or data.requestBatchSize) and 1 or requestBatchSize

	local queueProcessDelaySec = data.queueProcessDelaySec or defineFastInt2
	local v7 = not (v5 or data.queueProcessDelaySec) and 0 or queueProcessDelaySec

	local requestTimeoutSec = data.requestTimeoutSec or defineFastInt3
	local cache = data.cache
	local v8 = createRequestQueue()

	local v9 = {}

	local v10 = {}
	local thread = nil
	local v11 = getLocalPlayerUserId()

	local v12 = nil
	local v13 = nil
	local v14, v15

	if fFlagDataHydrationAccountReset then
		v14, v15 = Signals.createSignal(0)
	else
		v14 = nil
		v15 = nil
	end

	if FFlagBuildExperienceMonetizationMultiKind then
		v12, v13 = Signals.createSignal(0)
	end

	local v16 = if data.supportsMutations then createMutationLayer() else nil

	local function FORCE_FETCH(): boolean
		return true
	end

	local function logError(p2)
		if data.logError then
			data.logError(p2)
		end
	end

	local function isCurrentRequest(p2, p3): boolean
		return p3 == v14(false) and p2 == getLocalPlayerUserId()
	end

	local function snapshotEpochs(items)
		local result = {}

		for k, item in items do
			result[item] = v10[item] or 0
		end

		return result
	end

	local function filterCurrentIds(items, p2)
		local result = {}

		for k, item in items do
			if p2[item] == (v10[item] or 0) then
				table.insert(result, item)
			end
		end

		return result
	end

	local function handleFailure(p2, p3, p4, p5, p6)
		if fFlagDataHydrationAccountReset then
			local v17 = p5 == v14(false) and p4 == getLocalPlayerUserId()

			if not v17 then
				return
			end
		elseif p4 ~= v11 then
			return
		end

		local v17 = filterCurrentIds(p3, p6)

		if #v17 == 0 then
			return
		end

		if data.logError then
			data.logError(p2)
		end

		for k, v18 in v17 do
			v9[v18] = nil
		end

		cache.markItemsAsFailed(v17)

		if v16 then
			v16.drainCommitted(v17, cache.updateItem)
		end
	end

	local function handleSuccess(items, p2, p3, p4, p5)
		if fFlagDataHydrationAccountReset then
			local v17 = p4 == v14(false) and p3 == getLocalPlayerUserId()

			if not v17 then
				return
			end
		elseif p3 ~= v11 then
			return
		end

		local v17 = filterCurrentIds(p2, p5)
		local v18 = {}

		for k, item in items do
			if p5[k] == nil or p5[k] == (v10[k] or 0) then
				v18[k] = item
			end
		end

		for k, v19 in v18 do
			v9[k] = nil
		end

		if data.replaceItems then
			cache.replaceItems(v18)
		else
			cache.updateItems(v18)
		end

		local v19 = {}

		for k, v20 in v17 do
			if v18[v20] ~= nil then
				continue
			end

			if v16 and v16.isCommitted(v20) then
				v9[v20] = nil
			else
				table.insert(v19, v20)
			end
		end

		if v16 then
			v16.drainCommitted(v17, cache.updateItem)
		end

		if #v19 > 0 then
			handleFailure("Items missing in response", v19, p3, p4, p5)
		end
	end

	local function scheduleFetch()
		if thread ~= nil or v8.isEmpty() then
			return
		end

		thread = task.delay(v7, function()
			local v17 = v11

			local v18 = if fFlagDataHydrationAccountReset then v14(false) else nil

			thread = nil

			if v8.isEmpty() then
				return
			end

			local v19 = v8.pop(v6)

			for k, v20 in v19 do
				v9[v20] = true
			end

			local v20 = {}

			for k, v21 in v19 do
				v20[v21] = v10[v21] or 0
			end

			local items = cache.getItems(v19)

			local flag = false

			local thread2 = task.delay(requestTimeoutSec, function()
				if data.ignoreResponsesAfterTimeout then
					flag = true
				end

				handleFailure(`No fetch response after {requestTimeoutSec} sec`, v19, v17, v18, v20)
			end)

			local success, result = pcall(function()
				if v5 then
					data.fetchFn(items):andThen(function(p2)
						if flag then
							return
						end

						handleSuccess(p2, v19, v17, v18, v20)
						task.cancel(thread2)
					end):catch(function(p2)
						if flag then
							return
						end

						handleFailure(p2, v19, v17, v18, v20)
						task.cancel(thread2)
					end)

					return
				end

				local v21 = {}

				for k, v22 in v19 do
					local item = items[v22]
					table.insert(v21, data.fetchFn(v22, item))
				end

				Promise.all(v21):andThen(function(p2)
					if flag then
						return
					end

					local v22 = {}

					for k, v23 in v19 do
						v22[v23] = p2[k]
					end

					handleSuccess(v22, v19, v17, v18, v20)
					task.cancel(thread2)
				end):catch(function(p2)
					if flag then
						return
					end

					handleFailure(p2, v19, v17, v18, v20)
					task.cancel(thread2)
				end)
			end)

			if not success then
				handleFailure(result, v19, v17, v18, v20)
				task.cancel(thread2)
			end

			scheduleFetch()
		end)
	end

	local function isRequestInQueueOrInFlight(p2): boolean
		if v8.hasItem(p2) then
			return true
		end

		return v9[p2] ~= nil
	end

	local function getAndFetchItems(p2, p3, p4)
		local items, v17 = cache.getItems(p2, p3, p4)
		local fetchItems = {}
		local v18 = {}

		for k, item in items do
			fetchItems[k] = item

			if not v17[k] or v8.hasItem(k) or v9[k] ~= nil then
				continue
			end

			v8.push(k)
			table.insert(v18, k)
		end

		if #v18 > 0 then
			cache.resetFailedItems(v18)
		end

		if not v8.isEmpty() and thread == nil then
			if v8.isEmpty() then
				return fetchItems
			end

			thread = task.delay(v7, function()
				local v19 = v11

				local v20 = if fFlagDataHydrationAccountReset then v14(false) else nil

				thread = nil

				if v8.isEmpty() then
					return
				end

				local v21 = v8.pop(v6)

				for k, v22 in v21 do
					v9[v22] = true
				end

				local v22 = {}

				for k, v23 in v21 do
					v22[v23] = v10[v23] or 0
				end

				local items2 = cache.getItems(v21)

				local flag = false

				local thread2 = task.delay(requestTimeoutSec, function()
					if data.ignoreResponsesAfterTimeout then
						flag = true
					end

					handleFailure(`No fetch response after {requestTimeoutSec} sec`, v21, v19, v20, v22)
				end)

				local success, result = pcall(function()
					if v5 then
						data.fetchFn(items2):andThen(function(p5)
							if flag then
								return
							end

							handleSuccess(p5, v21, v19, v20, v22)
							task.cancel(thread2)
						end):catch(function(p5)
							if flag then
								return
							end

							handleFailure(p5, v21, v19, v20, v22)
							task.cancel(thread2)
						end)

						return
					end

					local v23 = {}

					for k, v24 in v21 do
						local item = items2[v24]
						table.insert(v23, data.fetchFn(v24, item))
					end

					Promise.all(v23):andThen(function(p5)
						if flag then
							return
						end

						local v24 = {}

						for k, v25 in v21 do
							v24[v25] = p5[k]
						end

						handleSuccess(v24, v21, v19, v20, v22)
						task.cancel(thread2)
					end):catch(function(p5)
						if flag then
							return
						end

						handleFailure(p5, v21, v19, v20, v22)
						task.cancel(thread2)
					end)
				end)

				if not success then
					handleFailure(result, v21, v19, v20, v22)
					task.cancel(thread2)
				end

				scheduleFetch()
			end)
		end

		return fetchItems
	end

	local function getAndFetchItem(p2, p3, p4)
		local item, v17 = cache.getItem(p2, p3, p4)

		if v17 and not v8.hasItem(p2) and v9[p2] == nil then
			cache.resetFailedItem(p2)
			v8.push(p2)
		end

		if not v8.isEmpty() and thread == nil then
			if v8.isEmpty() then
				return item, v17
			end

			thread = task.delay(v7, function()
				local v18 = v11

				local v19 = if fFlagDataHydrationAccountReset then v14(false) else nil

				thread = nil

				if v8.isEmpty() then
					return
				end

				local v20 = v8.pop(v6)

				for k, v21 in v20 do
					v9[v21] = true
				end

				local v21 = {}

				for k, v22 in v20 do
					v21[v22] = v10[v22] or 0
				end

				local items = cache.getItems(v20)

				local flag = false

				local thread2 = task.delay(requestTimeoutSec, function()
					if data.ignoreResponsesAfterTimeout then
						flag = true
					end

					handleFailure(`No fetch response after {requestTimeoutSec} sec`, v20, v18, v19, v21)
				end)

				local success, result = pcall(function()
					if v5 then
						data.fetchFn(items):andThen(function(p5)
							if flag then
								return
							end

							handleSuccess(p5, v20, v18, v19, v21)
							task.cancel(thread2)
						end):catch(function(p5)
							if flag then
								return
							end

							handleFailure(p5, v20, v18, v19, v21)
							task.cancel(thread2)
						end)

						return
					end

					local v22 = {}

					for k, v23 in v20 do
						local item2 = items[v23]
						table.insert(v22, data.fetchFn(v23, item2))
					end

					Promise.all(v22):andThen(function(p5)
						if flag then
							return
						end

						local v23 = {}

						for k, v24 in v20 do
							v23[v24] = p5[k]
						end

						handleSuccess(v23, v20, v18, v19, v21)
						task.cancel(thread2)
					end):catch(function(p5)
						if flag then
							return
						end

						handleFailure(p5, v20, v18, v19, v21)
						task.cancel(thread2)
					end)
				end)

				if not success then
					handleFailure(result, v20, v18, v19, v21)
					task.cancel(thread2)
				end

				scheduleFetch()
			end)
		end

		return item, v17
	end

	local function getCachedItem(p2)
		return cache.getItem(p2)
	end

	local function getCachedItems(p2)
		return cache.getItems(p2)
	end

	local function fetchItem(p2, p3)
		return getAndFetchItem(p2, p3 or FORCE_FETCH)
	end

	local function fetchItems(p2, p3)
		return getAndFetchItems(p2, p3 or FORCE_FETCH)
	end

	local function refetchItem(p2)
		v10[p2] = (v10[p2] or 0) + 1
		v9[p2] = nil
		cache.resetFailedItem(p2)

		if not v8.hasItem(p2) then
			v8.push(p2)
		end

		if thread == nil and not v8.isEmpty() then
			thread = task.delay(v7, function()
				local v17 = v11

				local v18 = if fFlagDataHydrationAccountReset then v14(false) else nil

				thread = nil

				if v8.isEmpty() then
					return
				end

				local v19 = v8.pop(v6)

				for k, v20 in v19 do
					v9[v20] = true
				end

				local v20 = {}

				for k, v21 in v19 do
					v20[v21] = v10[v21] or 0
				end

				local items = cache.getItems(v19)

				local flag = false

				local thread2 = task.delay(requestTimeoutSec, function()
					if data.ignoreResponsesAfterTimeout then
						flag = true
					end

					handleFailure(`No fetch response after {requestTimeoutSec} sec`, v19, v17, v18, v20)
				end)

				local success, result = pcall(function()
					if v5 then
						data.fetchFn(items):andThen(function(p3)
							if flag then
								return
							end

							handleSuccess(p3, v19, v17, v18, v20)
							task.cancel(thread2)
						end):catch(function(p3)
							if flag then
								return
							end

							handleFailure(p3, v19, v17, v18, v20)
							task.cancel(thread2)
						end)

						return
					end

					local v21 = {}

					for k, v22 in v19 do
						local item = items[v22]
						table.insert(v21, data.fetchFn(v22, item))
					end

					Promise.all(v21):andThen(function(p3)
						if flag then
							return
						end

						local v22 = {}

						for k, v23 in v19 do
							v22[v23] = p3[k]
						end

						handleSuccess(v22, v19, v17, v18, v20)
						task.cancel(thread2)
					end):catch(function(p3)
						if flag then
							return
						end

						handleFailure(p3, v19, v17, v18, v20)
						task.cancel(thread2)
					end)
				end)

				if not success then
					handleFailure(result, v19, v17, v18, v20)
					task.cancel(thread2)
				end

				scheduleFetch()
			end)
		end

		return cache.getItem(p2)
	end

	local function releaseItem(p2)
		v8.remove(p2)

		if v9[p2] then
			v9[p2] = nil

			v10[p2] = (v10[p2] or 0) + 1
		end

		if cache.removeItem then
			cache.removeItem(p2)
		end
	end

	local function clearResolverState(p2)
		if fFlagDataHydrationAccountReset then
			v15(v14(false) + 1)
		end

		if thread then
			task.cancel(thread)
			thread = nil
		end

		v9 = {}

		if fFlagDataHydrationAccountReset then
			v8.clear()

			if v16 then
				v16.clearAll()
			end

			if data.onBeforeClear then
				data.onBeforeClear()
			end

			if not p2 then
				cache.clear()
			end

			if data.onClear then
				data.onClear()
			end
		else
			cache.clear()
			v8.clear()

			if v16 then
				v16.clearAll()
			end

			if data.onClear then
				data.onClear()
			end
		end
	end

	local localPlayerChangedConnection = nil
	local v17 = nil

	if fFlagDataHydrationAccountReset then
		v17 = observeLocalPlayerUserId(function(p2)
			v11 = p2
			clearResolverState(data.keepCacheOnAccountReset == true)

			if FFlagBuildExperienceMonetizationMultiKind then
				v13(v12(false) + 1)
			end
		end)
	else
		localPlayerChangedConnection = Players:GetPropertyChangedSignal("LocalPlayer"):Connect(function()
			local localPlayerUserId = getLocalPlayerUserId()

			if localPlayerUserId ~= v11 then
				v11 = localPlayerUserId
				clearResolverState(false)

				if FFlagBuildExperienceMonetizationMultiKind then
					v13(v12(false) + 1)
				end
			end
		end)
	end

	local function dispose()
		if v17 then
			v17()
			v17 = nil
		end

		if localPlayerChangedConnection then
			localPlayerChangedConnection:Disconnect()
			localPlayerChangedConnection = nil
		end

		if fFlagDataHydrationAccountReset then
			clearResolverState(false)
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

	if not fFlagSduiReleaseSearchResultsPageState then
		releaseItem = nil
	end

	dataResolver.releaseItem = releaseItem
	dataResolver.dispose = dispose

	function dataResolver.clear()
		clearResolverState(false)
	end
	dataResolver.getAccountGeneration = if fFlagDataHydrationAccountReset then v14 else nil
	dataResolver.getAccountResetGeneration = if FFlagBuildExperienceMonetizationMultiKind then v12 else nil

	if not fFlagDataHydrationAccountReset then
		isCurrentRequest = nil
	end

	dataResolver.isCurrentRequest = isCurrentRequest

	if not v16 then
		return dataResolver
	end

	function dataResolver.getOptimisticCachedItem(p2)
		local item, v20 = cache.getItem(p2)

		return v16.getMergedResult(p2, item), v20
	end

	function dataResolver.getOptimisticCachedItems(p2)
		local items, v20 = cache.getItems(p2)

		local result = {}

		for k, item in items do
			result[k] = v16.getMergedResult(k, item)
		end

		return result, v20
	end

	function dataResolver.getOptimisticAndFetchItem(p2, p3, p4)
		local fetchItem2, v20 = getAndFetchItem(p2, p3, p4)
		return v16.getMergedResult(p2, fetchItem2), v20
	end

	function dataResolver.getOptimisticAndFetchItems(p2, p3, p4)
		local fetchItems2 = getAndFetchItems(p2, p3, p4)
		local result = {}

		for k, fetchItem2 in fetchItems2 do
			result[k] = v16.getMergedResult(k, fetchItem2)
		end

		return result
	end

	function dataResolver.setMutation(p2, p3)
		v16.set(p2, p3)
	end

	function dataResolver.clearMutation(p2)
		v16.clear(p2)
	end

	function dataResolver.commitMutation(p2)
		if v8.hasItem(p2) or v9[p2] ~= nil then
			v16.markCommitted(p2)
			return
		end

		local v20 = v16.get(p2)

		if v20 ~= nil then
			cache.updateItem(p2, v20)
		end

		v16.clear(p2)
	end

	return dataResolver
end

return createDataResolver
