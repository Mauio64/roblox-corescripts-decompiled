local DiscoveryUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DiscoveryUtils")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/LuauPolyfill")
local logResponseError = DiscoveryUtils.logResponseError

local createDataCache = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataCache")
local createDataResolver = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataResolver")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/DataHydrationTypes")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/MarketplaceItemFavorite/MarketplaceItemFavoriteStoreTypes")
local MarketplaceItemFavoriteUrlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/MarketplaceItemFavorite/MarketplaceItemFavoriteUrlBuilder")
local fetchMarketplaceItemFavorite = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/MarketplaceItemFavorite/fetchMarketplaceItemFavorite")
local requestMarketplaceItemFavoriteUpdate = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/MarketplaceItemFavorite/requestMarketplaceItemFavoriteUpdate")

local function getStatusCode(p2)
	if type(p2) == "table" then
		return p2.StatusCode
	end

	return nil
end

local function createMarketplaceItemFavoriteStore(data)
	local itemType = data.itemType
	local endpointName = MarketplaceItemFavoriteUrlBuilder.getEndpointName(itemType)
	local v5 = {}
	local v6 = {}

	local v7 = createDataCache()
	local v8 = createDataResolver({
		cache = v7,
		supportsMultiGet = false,
		supportsMutations = true,
		logError = function(p2)
			logResponseError(endpointName, p2)
		end,
		onClear = function()
			table.clear(v5)
		end,
		fetchFn = function(p2, p3)
			local v9 = v6[p2]
			return fetchMarketplaceItemFavorite(itemType, p2):andThen(function(p4)
				if v6[p2] == v9 then
					return {
						isFavorited = p4.responseBody ~= nil
					}
				end

				return v7.getItem(p2).data(false)
			end)
		end
	})

	local function getServerFavorited(p2)
		local data2 = v7.getItem(p2).data(false)

		if data2 then
			return data2.isFavorited
		end

		return nil
	end

	local function showFavoriteCount(p2, p3, p4)
		local baselineCount = p3.baselineCount

		if baselineCount == nil or data.setFavoriteCount == nil then
			return
		end

		local v9 = p4 == p3.baselineFavorited and 0 or p4 and 1 or -1

		data.setFavoriteCount(p2, (math.max(0, baselineCount + v9)))
	end

	local function finishToggle(p2, data2, p3)
		v5[p2] = nil
		v8.clearMutation(p2)
		local data3 = v7.getItem(p2).data(false)
		local isFavorited = if data3 then data3.isFavorited else nil

		if isFavorited == nil then
			return
		end

		local baselineCount = data2.baselineCount

		if baselineCount ~= nil and data.setFavoriteCount ~= nil then
			local v9 = isFavorited == data2.baselineFavorited and 0 or isFavorited and 1 or -1

			data.setFavoriteCount(p2, (math.max(0, baselineCount + v9)))
		end

		local onSettled = data2.callbacks and data2.callbacks.onSettled

		if data2.hasWritten and onSettled then
			onSettled({ type = p3, isFavorited = isFavorited })
		end
	end

	local writeDesired

	local function continueToggle(p2, p3, p4)
		local desired = p3.desired
		local data2 = v7.getItem(p2).data(false)
		local v9 = if data2 then data2.isFavorited else nil

		if desired == v9 then
			finishToggle(p2, p3, p4)
		else
			writeDesired(p2, p3)
		end
	end

	writeDesired = function(p2, state)
		local desired = state.desired
		state.isWriting = true
		state.hasWritten = true
		local onWriteStart = state.callbacks and state.callbacks.onWriteStart

		if onWriteStart then
			onWriteStart(desired)
		end

		requestMarketplaceItemFavoriteUpdate(itemType, p2, desired):andThen(function()
			if v5[p2] ~= state then
				return
			end

			state.isWriting = false
			v6[p2] = (v6[p2] or 0) + 1
			v7.updateItem(p2, { isFavorited = desired })
			local v9 = p2
			local v10 = state
			local desired2 = v10.desired
			local data2 = v7.getItem(v9).data(false)
			local v11 = if data2 then data2.isFavorited else nil

			if desired2 == v11 then
				finishToggle(v9, v10, "success")
			else
				writeDesired(v9, v10)
			end
		end):catch(function(p3)
			if v5[p2] ~= state then
				return
			end

			state.isWriting = false
			local v12 = if type(p3) == "table" then p3.StatusCode else nil

			logResponseError(endpointName, { StatusCode = v12 })

			if state.desired == desired then
				finishToggle(p2, state, "error")
				return
			end

			local v13 = p2
			local v14 = state
			local desired2 = v14.desired
			local data2 = v7.getItem(v13).data(false)
			local v15 = if data2 then data2.isFavorited else nil

			if desired2 == v15 then
				finishToggle(v13, v14, "success")
			else
				writeDesired(v13, v14)
			end
		end)
	end

	return {
		getFavorite = function(p2)
			return v8.getOptimisticCachedItem(p2)
		end,
		getAndFetchFavorite = function(p2)
			return v8.getOptimisticAndFetchItem(p2)
		end,
		toggleFavorite = function(p2, callbacks): boolean
			local data2 = v8.getOptimisticCachedItem(p2).data(false)

			if data2 == nil then
				return false
			end

			local v9 = not data2.isFavorited

			local v10 = v5[p2]

			if v10 == nil then
				v10 = {
					desired = v9,
					isWriting = false,
					hasWritten = false,
					baselineFavorited = data2.isFavorited,
					baselineCount = 0,
					callbacks = 0
				}
				local v11 = if data.getFavoriteCount then data.getFavoriteCount(p2) else nil
				v10.baselineCount = v11
				v10.callbacks = callbacks

				v5[p2] = v10
			else
				v10.desired = v9

				if callbacks then
					v10.callbacks = callbacks
				end
			end

			v8.setMutation(p2, { isFavorited = v9 })
			local baselineCount = v10.baselineCount

			if baselineCount ~= nil and data.setFavoriteCount ~= nil then
				local v11 = v9 == v10.baselineFavorited and 0 or v9 and 1 or -1

				data.setFavoriteCount(p2, (math.max(0, baselineCount + v11)))
			end

			if v10.isWriting then
				return true
			end

			local desired = v10.desired
			local data3 = v7.getItem(p2).data(false)
			local v11 = if data3 then data3.isFavorited else nil

			if desired == v11 then
				finishToggle(p2, v10, "success")
			else
				writeDesired(p2, v10)
			end

			return true
		end,
		updateItems = v7.updateItems,
		clear = v8.clear,
		dispose = v8.dispose
	}
end

return createMarketplaceItemFavoriteStore
