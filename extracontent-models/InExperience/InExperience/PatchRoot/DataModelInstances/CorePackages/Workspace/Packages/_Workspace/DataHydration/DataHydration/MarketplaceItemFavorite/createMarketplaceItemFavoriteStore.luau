local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

local DiscoveryUtils = require(parent.DiscoveryUtils)
require(parent.LuauPolyfill)
local logResponseError = DiscoveryUtils.logResponseError

local createDataCache = require(DataHydration.createDataCache)
local createDataResolver = require(DataHydration.createDataResolver)
require(DataHydration.DataHydrationTypes)
require(script.Parent.MarketplaceItemFavoriteStoreTypes)
local MarketplaceItemFavoriteUrlBuilder = require(script.Parent.MarketplaceItemFavoriteUrlBuilder)
local fetchMarketplaceItemFavorite = require(script.Parent.fetchMarketplaceItemFavorite)
local requestMarketplaceItemFavoriteUpdate = require(script.Parent.requestMarketplaceItemFavoriteUpdate)

local function getStatusCode(p) -- 1 equivalent call inferred from this helper
	return if type(p) == "table" then p.StatusCode else nil
end

local function createMarketplaceItemFavoriteStore(data)
	local itemType = data.itemType
	local endpointName = MarketplaceItemFavoriteUrlBuilder.getEndpointName(itemType)
	local v = {}
	local v2 = {}

	local dataCache = createDataCache()
	local dataResolver = createDataResolver({
		cache = dataCache,
		supportsMultiGet = false,
		supportsMutations = true,
		logError = function(p)
			logResponseError(endpointName, p)
		end,
		onClear = function()
			table.clear(v)
		end,
		fetchFn = function(p: string, _)
			local v3 = v2[p]
			return fetchMarketplaceItemFavorite(itemType, p):andThen(function(p2)
				if v2[p] == v3 then
					return {
						isFavorited = p2.responseBody ~= nil
					}
				end

				return dataCache.getItem(p).data(false)
			end)
		end
	})

	local function getServerFavorited(p: string) -- 2 equivalent calls inferred from this helper
		local data2 = dataCache.getItem(p).data(false)
		return if data2 then data2.isFavorited else nil
	end

	local function showFavoriteCount(p: string, p2, flag: boolean) -- 2 equivalent calls inferred from this helper
		local baselineCount = p2.baselineCount

		if baselineCount == nil or data.setFavoriteCount == nil then
			return
		end

		local v3 = flag == p2.baselineFavorited and 0 or flag and 1 or -1

		data.setFavoriteCount(p, (math.max(0, baselineCount + v3)))
	end

	local function finishToggle(p: string, p2, p3: string)
		v[p] = nil
		dataResolver.clearMutation(p)
		local serverFavorited = getServerFavorited(p) -- inferred equivalent call

		if serverFavorited == nil then
			return
		end

		showFavoriteCount(p, p2, serverFavorited) -- inferred equivalent call
		local onSettled = p2.callbacks and p2.callbacks.onSettled

		if p2.hasWritten and onSettled then
			onSettled({ type = p3, isFavorited = serverFavorited })
		end
	end

	local writeDesired

	local function continueToggle(p: string, p2, p3: string) -- 3 equivalent calls inferred from this helper
		if p2.desired == getServerFavorited(p) then -- inferred equivalent call
			finishToggle(p, p2, p3)
		else
			writeDesired(p, p2)
		end
	end

	writeDesired = function(p: string, state)
		local desired = state.desired
		state.isWriting = true
		state.hasWritten = true
		local onWriteStart = state.callbacks and state.callbacks.onWriteStart

		if onWriteStart then
			onWriteStart(desired)
		end

		requestMarketplaceItemFavoriteUpdate(itemType, p, desired):andThen(function()
			if v[p] ~= state then
				return
			end

			state.isWriting = false
			v2[p] = (v2[p] or 0) + 1
			dataCache.updateItem(p, { isFavorited = desired })
			continueToggle(p, state, "success") -- inferred equivalent call
		end):catch(function(p2)
			if v[p] ~= state then
				return
			end

			state.isWriting = false
			logResponseError(endpointName, { StatusCode = getStatusCode(p2) }) -- inferred equivalent call

			if state.desired == desired then
				finishToggle(p, state, "error")
				return
			end

			continueToggle(p, state, "success") -- inferred equivalent call
		end)
	end

	return {
		getFavorite = function(p: string)
			return dataResolver.getOptimisticCachedItem(p)
		end,
		getAndFetchFavorite = function(p: string)
			return dataResolver.getOptimisticAndFetchItem(p)
		end,
		toggleFavorite = function(p: string, callbacks): boolean
			local data2 = dataResolver.getOptimisticCachedItem(p).data(false)

			if data2 == nil then
				return false
			end

			local v3 = not data2.isFavorited

			local v4 = v[p]

			if v4 == nil then
				v4 = {
					desired = v3,
					isWriting = false,
					hasWritten = false,
					baselineFavorited = data2.isFavorited,
					baselineCount = 0,
					callbacks = 0
				}
				local baselineCount

				if data.getFavoriteCount then
					baselineCount = data.getFavoriteCount(p)
				end

				v4.baselineCount = baselineCount
				v4.callbacks = callbacks

				v[p] = v4
			else
				v4.desired = v3

				if callbacks then
					v4.callbacks = callbacks
				end
			end

			dataResolver.setMutation(p, { isFavorited = v3 })
			showFavoriteCount(p, v4, v3) -- inferred equivalent call

			if not v4.isWriting then
				continueToggle(p, v4, "success") -- inferred equivalent call
			end

			return true
		end,
		updateItems = dataCache.updateItems,
		clear = dataResolver.clear,
		dispose = dataResolver.dispose
	}
end

return createMarketplaceItemFavoriteStore
