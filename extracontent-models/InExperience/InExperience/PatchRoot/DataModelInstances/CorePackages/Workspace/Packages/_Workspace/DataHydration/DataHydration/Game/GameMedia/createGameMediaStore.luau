local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

local DiscoveryUtils = require(parent.DiscoveryUtils)
local DiscoveryEventErrorLogger = DiscoveryUtils.DiscoveryEventErrorLogger

local createDataCache = require(DataHydration.createDataCache)
local createDataResolver = require(DataHydration.createDataResolver)
require(DataHydration.DataHydrationTypes)
local fetchGameMedia = require(script.Parent.fetchGameMedia)
local GameMediaStoreTypes = require(script.Parent.GameMediaStoreTypes)
local SharedFlags = require(parent.SharedFlags)
local FFlagMyStatsMediaSelector = SharedFlags.FFlagMyStatsMediaSelector

local function createGameMediaStore()
	local dataResolver = createDataResolver({
		cache = createDataCache(),
		supportsMultiGet = false,
		replaceItems = FFlagMyStatsMediaSelector,
		logError = function(p)
			if type(p) == "table" and p.errorType then
				DiscoveryEventErrorLogger.reportError(p.errorType, p.errorMessage)
			else
				DiscoveryEventErrorLogger.reportError("FetchGameMediaError", (tostring(p)))
			end
		end,
		fetchFn = function(p: string, _)
			return fetchGameMedia(p):andThen(function(p2)
				if not (p2 and p2.responseBody) then
					error({
						errorType = "FetchGameMediaResponseError",
						errorMessage = p2 and "Missing response body" or "No response"
					})
				end

				local gameMediaResponseValidator, errorMessage = GameMediaStoreTypes.gameMediaResponseValidator(p2.responseBody)

				if not gameMediaResponseValidator then
					error({
						errorType = "FetchGameMediaResponseInvalidInterface",
						errorMessage = errorMessage
					})
				end

				local result = {}
				local data = p2.responseBody.data

				if data then
					for _, v in data do
						if v.imageId then
							table.insert(result, {
								imageId = v.imageId,
								assetTypeId = v.assetTypeId,
								videoId = v.videoId,
								videoHash = v.videoHash,
								videoTitle = v.videoTitle
							})
						end
					end
				end

				return result
			end)
		end
	})

	return {
		getAndFetchGameMedia = dataResolver.getAndFetchItem,
		getGameMedia = dataResolver.getCachedItem,
		fetchGameMedia = dataResolver.fetchItem,
		clear = dataResolver.clear,
		dispose = dataResolver.dispose
	}
end

return createGameMediaStore
