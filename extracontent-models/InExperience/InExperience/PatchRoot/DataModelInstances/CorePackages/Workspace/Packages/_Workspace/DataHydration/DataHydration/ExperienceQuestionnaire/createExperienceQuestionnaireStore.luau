local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

require(parent.HttpClient)

local createDataCache = require(DataHydration.createDataCache)
local createDataResolver = require(DataHydration.createDataResolver)
require(DataHydration.DataHydrationTypes)
local createSingleEntityResolver = require(DataHydration.createSingleEntityResolver)

local fetchExperienceQuestionnaire = require(script.Parent.fetchExperienceQuestionnaire)
require(script.Parent.ExperienceQuestionnaireStoreTypes)

local function createExperienceQuestionnaireStore(options)
	local v = options or {}
	local v2 = { network = v.network, baseUrl = v.baseUrl }

	local singleEntityResolver = createSingleEntityResolver(function(p: number)
		return fetchExperienceQuestionnaire.fetchEligibility(p, v2)
	end)

	local singleEntityResolver2 = createSingleEntityResolver(function(p: number)
		return fetchExperienceQuestionnaire.fetchMetadataStatus(p, v2)
	end)

	local singleEntityResolver3 = createSingleEntityResolver(function(p: number)
		return fetchExperienceQuestionnaire.fetchActiveResponse(p, v2)
	end)

	local singleEntityResolver4 = createSingleEntityResolver(function(p: number)
		return fetchExperienceQuestionnaire.fetchLatestQuestionnaire(p, v2)
	end)

	local singleEntityResolver5 = createSingleEntityResolver(function(p: number)
		return fetchExperienceQuestionnaire.fetchLatestSubmission(p, v2)
	end)

	local dataResolver = createDataResolver({
		cache = createDataCache(),
		supportsMultiGet = false,
		fetchFn = function(p: string, _)
			return fetchExperienceQuestionnaire.fetchQuestionnaireById(p, v2)
		end
	})

	return {
		getEligibility = singleEntityResolver.get,
		fetchEligibility = singleEntityResolver.fetch,
		getAndFetchEligibility = singleEntityResolver.getAndFetch,
		getMetadataStatus = singleEntityResolver2.get,
		fetchMetadataStatus = singleEntityResolver2.fetch,
		getAndFetchMetadataStatus = singleEntityResolver2.getAndFetch,
		getActiveResponse = singleEntityResolver3.get,
		fetchActiveResponse = singleEntityResolver3.fetch,
		getAndFetchActiveResponse = singleEntityResolver3.getAndFetch,
		getLatestQuestionnaire = singleEntityResolver4.get,
		fetchLatestQuestionnaire = singleEntityResolver4.fetch,
		getAndFetchLatestQuestionnaire = singleEntityResolver4.getAndFetch,
		getQuestionnaireById = function(p)
			return dataResolver.getCachedItem(p)
		end,
		fetchQuestionnaireById = function(p)
			return dataResolver.fetchItem(p)
		end,
		getAndFetchQuestionnaireById = function(p)
			return dataResolver.getAndFetchItem(p)
		end,
		getLatestSubmission = singleEntityResolver5.get,
		fetchLatestSubmission = singleEntityResolver5.fetch,
		getAndFetchLatestSubmission = singleEntityResolver5.getAndFetch,
		saveSubmission = function(p: number, p2)
			return fetchExperienceQuestionnaire.saveSubmission(p, p2, v2):andThen(function(p3)
				singleEntityResolver3.fetch(p)
				singleEntityResolver5.fetch(p)
				return p3
			end)
		end,
		validateResponses = function(p)
			return fetchExperienceQuestionnaire.validateResponses(p, v2)
		end,
		previewSubmission = function(p)
			return fetchExperienceQuestionnaire.previewSubmission(p, v2)
		end,
		clear = function()
			singleEntityResolver.clear()
			singleEntityResolver2.clear()
			singleEntityResolver3.clear()
			singleEntityResolver4.clear()
			dataResolver.clear()
			singleEntityResolver5.clear()
		end,
		dispose = function()
			singleEntityResolver.dispose()
			singleEntityResolver2.dispose()
			singleEntityResolver3.dispose()
			singleEntityResolver4.dispose()
			dataResolver.dispose()
			singleEntityResolver5.dispose()
		end
	}
end

return createExperienceQuestionnaireStore
