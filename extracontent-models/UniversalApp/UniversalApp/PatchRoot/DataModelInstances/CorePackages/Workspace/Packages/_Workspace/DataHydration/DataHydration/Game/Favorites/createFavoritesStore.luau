local DataHydration = script:FindFirstAncestor("DataHydration")
local DataHydrationParent = DataHydration.Parent
local createDataCache = require(DataHydration.createDataCache)
local createDataResolver = require(DataHydration.createDataResolver)

require(DataHydration.DataHydrationTypes)

local FavoritesStoreTypes = require(script.Parent.FavoritesStoreTypes)
local DiscoveryUtils = require(DataHydrationParent.DiscoveryUtils)
local logResponseError = DiscoveryUtils.logResponseError
local DiscoveryEventErrorLogger = DiscoveryUtils.DiscoveryEventErrorLogger
local fetchFavorite = require(script.Parent.fetchFavorite)
local requestFavoriteUpdate = require(script.Parent.requestFavoriteUpdate)
local Signals = require(DataHydrationParent.Signals)
local FavoritesUrlBuilder = require(script.Parent.FavoritesUrlBuilder)

require(DataHydrationParent.LuauPolyfill)

local SharedFlags = require(DataHydrationParent.SharedFlags)
local FFlagLuaAppDataHydrationUpdateItem = SharedFlags.FFlagLuaAppDataHydrationUpdateItem
local FFlagSduiFavoritesHydrationStructured = SharedFlags.FFlagSduiFavoritesHydrationStructured

local function createFavoritesStore() -- line: 23
	-- upvalues: createDataCache (copy), createDataResolver (copy), logResponseError (copy), FavoritesUrlBuilder (copy), fetchFavorite (copy), FavoritesStoreTypes (copy), DiscoveryEventErrorLogger (copy), FFlagSduiFavoritesHydrationStructured (copy), Signals (copy), requestFavoriteUpdate (copy), FFlagLuaAppDataHydrationUpdateItem (copy)
	local v17 = createDataCache()
	local v18 = createDataResolver({
		supportsMultiGet = false,
		cache = v17,
		logError = function(p1) -- line: 28
			-- upvalues: logResponseError (copy), FavoritesUrlBuilder (copy)
			logResponseError(FavoritesUrlBuilder.FAVORITE_URL, p1)
		end,
		fetchFn = function(s1: string, _) -- line: 31
			-- upvalues: fetchFavorite (copy), FavoritesStoreTypes (copy), DiscoveryEventErrorLogger (copy), FFlagSduiFavoritesHydrationStructured (copy)
			return fetchFavorite(s1):andThen(function(p3) -- line: 35
				-- upvalues: FavoritesStoreTypes (copy), DiscoveryEventErrorLogger (copy), s1 (copy), FFlagSduiFavoritesHydrationStructured (copy)
				local responseBody = p3.responseBody

				if not FavoritesStoreTypes.favoriteResponseValidator(responseBody) then
					DiscoveryEventErrorLogger.reportError("createFavoritesStore", "Invalid favorite response", {
						universeId = s1,
						responseBody = responseBody
					})
					error({
						StatusCode = p3.responseCode
					})
				end

				if FFlagSduiFavoritesHydrationStructured then
					return {
						isFavorited = responseBody.isFavorited
					}
				end

				return responseBody.isFavorited
			end)
		end
	})

	return {
		fetchFavorite = v18.fetchItem,
		fetchFavorites = v18.fetchItems,
		getFavorite = v18.getCachedItem,
		getFavorites = v18.getCachedItems,
		getAndFetchFavorite = v18.getAndFetchItem,
		getAndFetchFavorites = v18.getAndFetchItems,
		updateFavorite = function(s2: string, b1: boolean) -- line: 53
			-- upvalues: Signals (copy), v17 (copy), FFlagSduiFavoritesHydrationStructured (copy), requestFavoriteUpdate (copy), DiscoveryEventErrorLogger (copy), logResponseError (copy), FavoritesUrlBuilder (copy)
			local v24, v25 = Signals.createSignal(nil)
			local v26 = v17.getItem(s2).data(false)

			if FFlagSduiFavoritesHydrationStructured then
				v17.updateItem(s2, {
					isFavorited = b1
				})
			else
				v17.updateItem(s2, b1)
			end

			requestFavoriteUpdate(s2, b1):andThen(function(_) -- line: 72
				-- upvalues: v25 (copy), b1 (copy)
				v25({
					type = "success",
					isFavorited = b1
				})
			end):catch(function(p5) -- line: 78
				-- upvalues: v17 (copy), s2 (copy), v26 (copy), DiscoveryEventErrorLogger (copy), logResponseError (copy), FavoritesUrlBuilder (copy), v25 (copy)
				v17.updateItem(s2, v26)

				local v31 = if type(p5) ~= "table" or not p5.StatusCode then nil else p5.StatusCode
				local v32 = if type(p5) ~= "table" or not p5.StatusMessage then nil else p5.StatusMessage

				DiscoveryEventErrorLogger.reportError("updateFavorite", "Error updating favorite", {
					universeId = s2,
					statusCode = v31,
					statusMessage = v32
				})
				logResponseError(FavoritesUrlBuilder.FAVORITE_UPDATE_URL, {
					StatusCode = v31
				})
				v25({
					type = "error",
					error = tostring(p5)
				})
			end)

			return v24
		end,
		updateItem = if not FFlagLuaAppDataHydrationUpdateItem then nil else v17.updateItem,
		updateItems = if not FFlagSduiFavoritesHydrationStructured then nil else v17.updateItems,
		clear = function() -- line: 101
			-- upvalues: v17 (copy), v18 (copy)
			v17.clear()
			v18.clear()
		end,
		dispose = function() -- line: 106
			-- upvalues: v18 (copy)
			v18.dispose()
		end
	}
end

return createFavoritesStore
