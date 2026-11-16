local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

local createDataCache = require(DataHydration.createDataCache)
local createDataResolver = require(DataHydration.createDataResolver)
require(DataHydration.DataHydrationTypes)
local FavoritesStoreTypes = require(script.Parent.FavoritesStoreTypes)
local DiscoveryUtils = require(parent.DiscoveryUtils)
local logResponseError = DiscoveryUtils.logResponseError
local DiscoveryEventErrorLogger = DiscoveryUtils.DiscoveryEventErrorLogger
local fetchFavorite = require(script.Parent.fetchFavorite)
local requestFavoriteUpdate = require(script.Parent.requestFavoriteUpdate)
local Signals = require(parent.Signals)
local FavoritesUrlBuilder = require(script.Parent.FavoritesUrlBuilder)
require(parent.LuauPolyfill)

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppDataHydrationUpdateItem = SharedFlags.FFlagLuaAppDataHydrationUpdateItem

local function createFavoritesStore()
	local dataCache = createDataCache()
	local dataResolver = createDataResolver({
		cache = dataCache,
		supportsMultiGet = false,
		logError = function(p)
			logResponseError(FavoritesUrlBuilder.FAVORITE_URL, p)
		end,
		fetchFn = function(universeId: string, _)
			return fetchFavorite(universeId):andThen(function(p)
				local responseBody = p.responseBody

				if not FavoritesStoreTypes.favoriteResponseValidator(responseBody) then
					DiscoveryEventErrorLogger.reportError("createFavoritesStore", "Invalid favorite response", {
						universeId = universeId,
						responseBody = responseBody
					})

					error({ StatusCode = p.responseCode })
				end

				return { isFavorited = responseBody.isFavorited }
			end)
		end
	})

	local function updateFavorite(universeId: string, isFavorited: boolean)
		local signal, v = Signals.createSignal(nil)

		local data = dataCache.getItem(universeId).data(false)
		dataCache.updateItem(universeId, { isFavorited = isFavorited })

		requestFavoriteUpdate(universeId, isFavorited):andThen(function(_)
			v({ type = "success", isFavorited = isFavorited })
		end):catch(function(p)
			dataCache.updateItem(universeId, data)
			local statusCode

			if type(p) == "table" and p.StatusCode then
				statusCode = p.StatusCode
			end

			local statusMessage

			if type(p) == "table" and p.StatusMessage then
				statusMessage = p.StatusMessage
			end

			DiscoveryEventErrorLogger.reportError("updateFavorite", "Error updating favorite", {
				universeId = universeId,
				statusCode = statusCode,
				statusMessage = statusMessage
			})

			logResponseError(FavoritesUrlBuilder.FAVORITE_UPDATE_URL, { StatusCode = statusCode })

			v({ type = "error", error = tostring(p) })
		end)

		return signal
	end

	local favoritesStore = {
		fetchFavorite = dataResolver.fetchItem,
		fetchFavorites = dataResolver.fetchItems,
		getFavorite = dataResolver.getCachedItem,
		getFavorites = dataResolver.getCachedItems,
		getAndFetchFavorite = dataResolver.getAndFetchItem,
		getAndFetchFavorites = dataResolver.getAndFetchItems,
		updateFavorite = updateFavorite,
		updateItem = 0,
		updateItems = 0,
		clear = 0,
		dispose = 0
	}
	local updateItem

	if FFlagLuaAppDataHydrationUpdateItem then
		updateItem = dataCache.updateItem
	end

	favoritesStore.updateItem = updateItem
	favoritesStore.updateItems = dataCache.updateItems

	function favoritesStore.clear()
		dataCache.clear()
		dataResolver.clear()
	end

	function favoritesStore.dispose()
		dataResolver.dispose()
	end
	return favoritesStore
end

return createFavoritesStore
