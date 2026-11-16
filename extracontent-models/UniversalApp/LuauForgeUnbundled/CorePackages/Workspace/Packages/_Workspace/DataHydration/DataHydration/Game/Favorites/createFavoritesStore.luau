local createDataCache = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataCache")
local createDataResolver = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataResolver")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/DataHydrationTypes")
local FavoritesStoreTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Game/Favorites/FavoritesStoreTypes")
local DiscoveryUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DiscoveryUtils")
local logResponseError = DiscoveryUtils.logResponseError
local discoveryEventErrorLogger = DiscoveryUtils.DiscoveryEventErrorLogger
local module5 = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Game/Favorites/fetchFavorite")
local requestFavoriteUpdate = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Game/Favorites/requestFavoriteUpdate")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Signals")
local FavoritesUrlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Game/Favorites/FavoritesUrlBuilder")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/LuauPolyfill")

local fFlagLuaAppDataHydrationUpdateItem = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/SharedFlags").FFlagLuaAppDataHydrationUpdateItem

local function createFavoritesStore()
	local v5 = createDataCache()
	local v6 = createDataResolver({
		cache = v5,
		supportsMultiGet = false,
		logError = function(p2)
			logResponseError(FavoritesUrlBuilder.FAVORITE_URL, p2)
		end,
		fetchFn = function(p2, p3)
			return module5(p2):andThen(function(p4)
				local responseBody = p4.responseBody

				if not FavoritesStoreTypes.favoriteResponseValidator(responseBody) then
					discoveryEventErrorLogger.reportError(
						"createFavoritesStore",
						"Invalid favorite response",
						{ universeId = p2, responseBody = responseBody }
					)

					error({ StatusCode = p4.responseCode })
				end

				return { isFavorited = responseBody.isFavorited }
			end)
		end
	})

	local function updateFavorite(p2, p3)
		local signal, v7 = Signals.createSignal(nil)

		local data = v5.getItem(p2).data(false)
		v5.updateItem(p2, { isFavorited = p3 })

		requestFavoriteUpdate(p2, p3):andThen(function(p4)
			v7({ type = "success", isFavorited = p3 })
		end):catch(function(p4)
			v5.updateItem(p2, data)

			local statusCode = if type(p4) == "table" and p4.StatusCode then p4.StatusCode else nil
			local v8 = if type(p4) == "table" and p4.StatusMessage then p4.StatusMessage else nil

			discoveryEventErrorLogger.reportError("updateFavorite", "Error updating favorite", {
				universeId = p2,
				statusCode = statusCode,
				statusMessage = v8
			})

			logResponseError(FavoritesUrlBuilder.FAVORITE_UPDATE_URL, { StatusCode = statusCode })

			v7({ type = "error", error = tostring(p4) })
		end)

		return signal
	end

	local favoritesStore = {
		fetchFavorite = v6.fetchItem,
		fetchFavorites = v6.fetchItems,
		getFavorite = v6.getCachedItem,
		getFavorites = v6.getCachedItems,
		getAndFetchFavorite = v6.getAndFetchItem,
		getAndFetchFavorites = v6.getAndFetchItems,
		updateFavorite = updateFavorite,
		updateItem = 0,
		updateItems = 0,
		clear = 0,
		dispose = 0
	}

	local v7 = if fFlagLuaAppDataHydrationUpdateItem then v5.updateItem else nil
	favoritesStore.updateItem = v7
	favoritesStore.updateItems = v5.updateItems

	function favoritesStore.clear()
		v5.clear()
		v6.clear()
	end

	function favoritesStore.dispose()
		v6.dispose()
	end
	return favoritesStore
end

return createFavoritesStore
