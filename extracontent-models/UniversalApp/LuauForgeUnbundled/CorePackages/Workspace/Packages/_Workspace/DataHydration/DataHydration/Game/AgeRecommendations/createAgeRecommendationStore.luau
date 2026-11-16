local DiscoveryUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DiscoveryUtils")
local logResponseError = DiscoveryUtils.logResponseError
local discoveryEventErrorLogger = DiscoveryUtils.DiscoveryEventErrorLogger

local createDataCache = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataCache")
local createDataResolver = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataResolver")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/DataHydrationTypes")
local module4 = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Game/AgeRecommendations/fetchAgeRecommendation")
local AgeRecommendationStoreTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Game/AgeRecommendations/AgeRecommendationStoreTypes")

local fFlagShowGameAgeRating = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/SharedFlags").FFlagShowGameAgeRating

local function createAgeRecommendationStore()
	local v5 = createDataCache()

	local v6 = createDataResolver({
		cache = v5,
		requestBatchSize = 1,
		logError = function(data)
			if type(data) == "table" then
				if data.responseCode then
					logResponseError("experience-guidelines-api/get-age-recommendation", {
						StatusCode = tonumber(data.responseCode)
					})
				end

				if data.errorType and data.errorMessage then
					discoveryEventErrorLogger.reportError(
						data.errorType,
						data.errorMessage,
						data.customFields
					)
				end
			else
				discoveryEventErrorLogger.reportError("FetchAgeRecommendationError", (tostring(data)))
			end
		end,
		fetchFn = function(items)
			local v7 = next(items)

			if not v7 then
				error({
					errorType = "CreateAgeRecommendationStoreMissingUniverseId",
					errorMessage = "CreateAgeRecommendationStore requires universeId",
					customFields = { universeId = v7 }
				})
			end

			return module4(v7):andThen(function(p2)
				if not (p2 and p2.responseBody) then
					error({
						responseCode = p2 and p2.responseCode,
						errorType = "FetchAgeRecommendationResponseError",
						errorMessage = p2 and "Missing response body" or "No response",
						customFields = { universeId = v7 }
					})
				end

				local ageRecommendationResponseValidator, v8 = AgeRecommendationStoreTypes.ageRecommendationResponseValidator(p2.responseBody)

				if not ageRecommendationResponseValidator then
					error({
						responseCode = p2.responseCode,
						errorType = "FetchAgeRecommendationResponseInvalidInterface",
						errorMessage = v8,
						customFields = { universeId = v7 }
					})
				end

				local v9 = {}

				local ageRecommendation = p2.responseBody.ageRecommendationDetails.summary.ageRecommendation

				if fFlagShowGameAgeRating and not ageRecommendation then
					v9[v7] = {}
					return v9
				end

				local v11 = {
					displayName = ageRecommendation.displayName,
					displayNameWithHeaderShort = ageRecommendation.displayNameWithHeaderShort,
					minimumAgeDisplay = 0,
					igrsRating = 0,
					igrsRatingDisplayMessage = 0
				}

				local v12 = if fFlagShowGameAgeRating then ageRecommendation.minimumAgeDisplay else nil
				v11.minimumAgeDisplay = v12

				v11.igrsRating = ageRecommendation.igrsRating
				v11.igrsRatingDisplayMessage = ageRecommendation.igrsRatingDisplayMessage
				v9[v7] = v11

				return v9
			end):catch(function(message)
				error(message)
			end)
		end
	})

	return {
		fetchAgeRecommendation = v6.fetchItem,
		getAgeRecommendation = v6.getCachedItem,
		getAndFetchAgeRecommendation = v6.getAndFetchItem,
		updateAgeRecommendations = v5.updateItems,
		clear = v6.clear,
		dispose = v6.dispose
	}
end

return createAgeRecommendationStore
