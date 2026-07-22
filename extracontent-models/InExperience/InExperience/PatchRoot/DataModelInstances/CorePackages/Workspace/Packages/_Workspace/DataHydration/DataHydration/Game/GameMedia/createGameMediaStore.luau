local DataHydration = script:FindFirstAncestor("DataHydration")
local DataHydrationParent = DataHydration.Parent
local DiscoveryEventErrorLogger = require(DataHydrationParent.DiscoveryUtils).DiscoveryEventErrorLogger
local createDataCache = require(DataHydration.createDataCache)
local createDataResolver = require(DataHydration.createDataResolver)

require(DataHydration.DataHydrationTypes)

local fetchGameMedia = require(script.Parent.fetchGameMedia)
local GameMediaStoreTypes = require(script.Parent.GameMediaStoreTypes)

local function createGameMediaStore() -- line: 16
	-- upvalues: createDataCache (copy), createDataResolver (copy), DiscoveryEventErrorLogger (copy), fetchGameMedia (copy), GameMediaStoreTypes (copy)
	local v9 = createDataCache()
	local v10 = createDataResolver({
		supportsMultiGet = false,
		cache = v9,
		logError = function(p1) -- line: 21
			-- upvalues: DiscoveryEventErrorLogger (copy)
			if type(p1) == "table" and p1.errorType then
				DiscoveryEventErrorLogger.reportError(p1.errorType, p1.errorMessage)

				return
			end

			DiscoveryEventErrorLogger.reportError("FetchGameMediaError", (tostring(p1)))
		end,
		fetchFn = function(s1: string, _) -- line: 28
			-- upvalues: fetchGameMedia (copy), GameMediaStoreTypes (copy)
			return fetchGameMedia(s1):andThen(function(p3) -- line: 29
				-- upvalues: GameMediaStoreTypes (copy)
				if not p3 or not p3.responseBody then
					error({
						errorType = "FetchGameMediaResponseError",
						errorMessage = not p3 and "No response" or "Missing response body"
					})
				end

				local v15, v16 = GameMediaStoreTypes.gameMediaResponseValidator(p3.responseBody)

				if not v15 then
					error({
						errorType = "FetchGameMediaResponseInvalidInterface",
						errorMessage = v16
					})
				end

				local t1 = {}
				local data = p3.responseBody.data

				if data then
					for _, v20 in data do
						if v20.imageId then
							table.insert(t1, {
								imageId = v20.imageId,
								assetTypeId = v20.assetTypeId,
								videoId = v20.videoId,
								videoHash = v20.videoHash,
								videoTitle = v20.videoTitle
							})
						end
					end
				end

				return t1
			end)
		end
	})

	return {
		getAndFetchGameMedia = v10.getAndFetchItem,
		getGameMedia = v10.getCachedItem,
		fetchGameMedia = v10.fetchItem,
		clear = v10.clear,
		dispose = v10.dispose
	}
end

return createGameMediaStore
