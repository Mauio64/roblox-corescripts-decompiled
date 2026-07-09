local DataHydration = script:FindFirstAncestor("DataHydration")
local DataHydrationParent = DataHydration.Parent
local DiscoveryUtils = require(DataHydrationParent.DiscoveryUtils)
local logResponseError = DiscoveryUtils.logResponseError
local DiscoveryEventErrorLogger = DiscoveryUtils.DiscoveryEventErrorLogger
local createDataCache = require(DataHydration.createDataCache)
local createDataResolver = require(DataHydration.createDataResolver)

require(DataHydration.DataHydrationTypes)

local fetchAgeRecommendation = require(script.Parent.fetchAgeRecommendation)
local AgeRecommendationStoreTypes = require(script.Parent.AgeRecommendationStoreTypes)
local FFlagSduiExperienceDetailsSupport = require(DataHydrationParent.SharedFlags).FFlagSduiExperienceDetailsSupport

local function createAgeRecommendationStore() -- line: 18
	-- upvalues: createDataCache (copy), createDataResolver (copy), logResponseError (copy), DiscoveryEventErrorLogger (copy), fetchAgeRecommendation (copy), AgeRecommendationStoreTypes (copy), FFlagSduiExperienceDetailsSupport (copy)
	local v12 = createDataCache()
	local v13 = createDataResolver({
		requestBatchSize = 1,
		cache = v12,
		logError = function(p1) -- line: 25
			-- upvalues: logResponseError (copy), DiscoveryEventErrorLogger (copy)
			if type(p1) == "table" then
				if p1.responseCode then
					logResponseError("experience-guidelines-api/get-age-recommendation", {
						StatusCode = tonumber(p1.responseCode)
					})
				end

				if p1.errorType and p1.errorMessage then
					DiscoveryEventErrorLogger.reportError(p1.errorType, p1.errorMessage, p1.customFields)

					return
				end
			else
				DiscoveryEventErrorLogger.reportError("FetchAgeRecommendationError", (tostring(p1)))
			end
		end,
		fetchFn = function(t1: {[any]: any}) -- line: 45
			-- upvalues: fetchAgeRecommendation (copy), AgeRecommendationStoreTypes (copy), FFlagSduiExperienceDetailsSupport (copy)
			local v16 = next(t1)

			if not v16 then
				error({
					errorType = "CreateAgeRecommendationStoreMissingUniverseId",
					errorMessage = "CreateAgeRecommendationStore requires universeId",
					customFields = {
						universeId = v16
					}
				})
			end

			return fetchAgeRecommendation(v16):andThen(function(p2) -- line: 57
				-- upvalues: v16 (copy), AgeRecommendationStoreTypes (copy), FFlagSduiExperienceDetailsSupport (copy)
				if not p2 or not p2.responseBody then
					error({
						errorType = "FetchAgeRecommendationResponseError",
						responseCode = p2 and p2.responseCode,
						errorMessage = not p2 and "No response" or "Missing response body",
						customFields = {
							universeId = v16
						}
					})
				end

				local v18, v19 = AgeRecommendationStoreTypes.ageRecommendationResponseValidator(p2.responseBody)

				if not v18 then
					error({
						errorType = "FetchAgeRecommendationResponseInvalidInterface",
						responseCode = p2.responseCode,
						errorMessage = v19,
						customFields = {
							universeId = v16
						}
					})
				end

				local t2 = {}
				local ageRecommendation = p2.responseBody.ageRecommendationDetails.summary.ageRecommendation

				t2[v16] = {
					displayName = ageRecommendation.displayName,
					displayNameWithHeaderShort = ageRecommendation.displayNameWithHeaderShort,
					igrsRating = if not FFlagSduiExperienceDetailsSupport then nil else ageRecommendation.igrsRating,
					igrsRatingDisplayMessage = if not FFlagSduiExperienceDetailsSupport then nil else ageRecommendation.igrsRatingDisplayMessage
				}

				return t2
			end):catch(function(p3) -- line: 94
				error(p3)
			end)
		end
	})

	return {
		fetchAgeRecommendation = v13.fetchItem,
		getAgeRecommendation = v13.getCachedItem,
		getAndFetchAgeRecommendation = v13.getAndFetchItem,
		updateAgeRecommendations = if not FFlagSduiExperienceDetailsSupport then nil else v12.updateItems,
		clear = v13.clear,
		dispose = v13.dispose
	}
end

return createAgeRecommendationStore
