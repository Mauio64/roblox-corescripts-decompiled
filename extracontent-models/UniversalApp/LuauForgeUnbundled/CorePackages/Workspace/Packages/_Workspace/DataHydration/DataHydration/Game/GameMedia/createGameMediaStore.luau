local discoveryEventErrorLogger = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DiscoveryUtils").DiscoveryEventErrorLogger

local createDataCache = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataCache")
local createDataResolver = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataResolver")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/DataHydrationTypes")
local module3 = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Game/GameMedia/fetchGameMedia")
local GameMediaStoreTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Game/GameMedia/GameMediaStoreTypes")
local fFlagMyStatsMediaSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/SharedFlags").FFlagMyStatsMediaSelector

local function createGameMediaStore()
	local v6 = createDataResolver({
		cache = createDataCache(),
		supportsMultiGet = false,
		replaceItems = fFlagMyStatsMediaSelector,
		logError = function(p2)
			if type(p2) == "table" and p2.errorType then
				discoveryEventErrorLogger.reportError(p2.errorType, p2.errorMessage)
			else
				discoveryEventErrorLogger.reportError("FetchGameMediaError", (tostring(p2)))
			end
		end,
		fetchFn = function(p2, p3)
			return module3(p2):andThen(function(p4)
				if not (p4 and p4.responseBody) then
					error({
						errorType = "FetchGameMediaResponseError",
						errorMessage = p4 and "Missing response body" or "No response"
					})
				end

				local gameMediaResponseValidator, v7 = GameMediaStoreTypes.gameMediaResponseValidator(p4.responseBody)

				if not gameMediaResponseValidator then
					error({
						errorType = "FetchGameMediaResponseInvalidInterface",
						errorMessage = v7
					})
				end

				local result = {}
				local data = p4.responseBody.data

				if data then
					for k, v8 in data do
						if v8.imageId then
							table.insert(result, {
								imageId = v8.imageId,
								assetTypeId = v8.assetTypeId,
								videoId = v8.videoId,
								videoHash = v8.videoHash,
								videoTitle = v8.videoTitle
							})
						end
					end
				end

				return result
			end)
		end
	})

	return {
		getAndFetchGameMedia = v6.getAndFetchItem,
		getGameMedia = v6.getCachedItem,
		fetchGameMedia = v6.fetchItem,
		clear = v6.clear,
		dispose = v6.dispose
	}
end

return createGameMediaStore
