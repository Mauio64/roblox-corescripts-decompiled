local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

local DiscoveryUtils = require(parent.DiscoveryUtils)
local logResponseError = DiscoveryUtils.logResponseError
local DiscoveryEventErrorLogger = DiscoveryUtils.DiscoveryEventErrorLogger

local createDataCache = require(DataHydration.createDataCache)
local createDataResolver = require(DataHydration.createDataResolver)
require(DataHydration.DataHydrationTypes)
local fetchAgeRecommendation = require(script.Parent.fetchAgeRecommendation)
local AgeRecommendationStoreTypes = require(script.Parent.AgeRecommendationStoreTypes)

local SharedFlags = require(parent.SharedFlags)
local FFlagShowGameAgeRating = SharedFlags.FFlagShowGameAgeRating

local function createAgeRecommendationStore()
	local dataCache = createDataCache()

	local dataResolver = createDataResolver({
		cache = dataCache,
		requestBatchSize = 1,
		logError = function(data)
			if type(data) == "table" then
				if data.responseCode then
					logResponseError("experience-guidelines-api/get-age-recommendation", {
						StatusCode = tonumber(data.responseCode)
					})
				end

				if data.errorType and data.errorMessage then
					DiscoveryEventErrorLogger.reportError(data.errorType, data.errorMessage, data.customFields)
				end
			else
				DiscoveryEventErrorLogger.reportError("FetchAgeRecommendationError", (tostring(data)))
			end
		end,
		fetchFn = function(items)
			local universeId = next(items)

			if not universeId then
				error({
					errorType = "CreateAgeRecommendationStoreMissingUniverseId",
					errorMessage = "CreateAgeRecommendationStore requires universeId",
					customFields = { universeId = universeId }
				})
			end

			return fetchAgeRecommendation(universeId):andThen(function(p)
				if not (p and p.responseBody) then
					error({
						responseCode = p and p.responseCode,
						errorType = "FetchAgeRecommendationResponseError",
						errorMessage = p and "Missing response body" or "No response",
						customFields = { universeId = universeId }
					})
				end

				local ageRecommendationResponseValidator, errorMessage = AgeRecommendationStoreTypes.ageRecommendationResponseValidator(p.responseBody)

				if not ageRecommendationResponseValidator then
					error({
						responseCode = p.responseCode,
						errorType = "FetchAgeRecommendationResponseInvalidInterface",
						errorMessage = errorMessage,
						customFields = { universeId = universeId }
					})
				end

				local v = {}

				local ageRecommendation = p.responseBody.ageRecommendationDetails.summary.ageRecommendation

				if FFlagShowGameAgeRating and not ageRecommendation then
					v[universeId] = {}
					return v
				end

				local v2 = {
					displayName = ageRecommendation.displayName,
					displayNameWithHeaderShort = ageRecommendation.displayNameWithHeaderShort,
					minimumAgeDisplay = 0,
					igrsRating = 0,
					igrsRatingDisplayMessage = 0
				}
				local minimumAgeDisplay

				if FFlagShowGameAgeRating then
					minimumAgeDisplay = ageRecommendation.minimumAgeDisplay
				end

				v2.minimumAgeDisplay = minimumAgeDisplay

				v2.igrsRating = ageRecommendation.igrsRating
				v2.igrsRatingDisplayMessage = ageRecommendation.igrsRatingDisplayMessage
				v[universeId] = v2

				return v
			end):catch(function(message)
				error(message)
			end)
		end
	})

	return {
		fetchAgeRecommendation = dataResolver.fetchItem,
		getAgeRecommendation = dataResolver.getCachedItem,
		getAndFetchAgeRecommendation = dataResolver.getAndFetchItem,
		updateAgeRecommendations = dataCache.updateItems,
		clear = dataResolver.clear,
		dispose = dataResolver.dispose
	}
end

return createAgeRecommendationStore
