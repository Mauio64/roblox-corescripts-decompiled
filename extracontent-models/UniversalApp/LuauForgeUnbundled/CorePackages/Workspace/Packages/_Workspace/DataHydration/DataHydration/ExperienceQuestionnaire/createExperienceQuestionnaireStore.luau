require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/HttpClient")

local createDataCache = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataCache")
local createDataResolver = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataResolver")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/DataHydrationTypes")
local createSingleEntityResolver = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createSingleEntityResolver")

local fetchExperienceQuestionnaire = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/ExperienceQuestionnaire/fetchExperienceQuestionnaire")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/ExperienceQuestionnaire/ExperienceQuestionnaireStoreTypes")

local function createExperienceQuestionnaireStore(options)
	local v5 = options or {}
	local v6 = { network = v5.network, baseUrl = v5.baseUrl }

	local v7 = createSingleEntityResolver(function(p2)
		return fetchExperienceQuestionnaire.fetchEligibility(p2, v6)
	end)

	local v8 = createSingleEntityResolver(function(p2)
		return fetchExperienceQuestionnaire.fetchMetadataStatus(p2, v6)
	end)

	local v9 = createSingleEntityResolver(function(p2)
		return fetchExperienceQuestionnaire.fetchActiveResponse(p2, v6)
	end)

	local v10 = createSingleEntityResolver(function(p2)
		return fetchExperienceQuestionnaire.fetchLatestQuestionnaire(p2, v6)
	end)

	local v11 = createSingleEntityResolver(function(p2)
		return fetchExperienceQuestionnaire.fetchLatestSubmission(p2, v6)
	end)

	local v13 = createDataResolver({
		cache = createDataCache(),
		supportsMultiGet = false,
		fetchFn = function(p2, p3)
			return fetchExperienceQuestionnaire.fetchQuestionnaireById(p2, v6)
		end
	})

	return {
		getEligibility = v7.get,
		fetchEligibility = v7.fetch,
		getAndFetchEligibility = v7.getAndFetch,
		getMetadataStatus = v8.get,
		fetchMetadataStatus = v8.fetch,
		getAndFetchMetadataStatus = v8.getAndFetch,
		getActiveResponse = v9.get,
		fetchActiveResponse = v9.fetch,
		getAndFetchActiveResponse = v9.getAndFetch,
		getLatestQuestionnaire = v10.get,
		fetchLatestQuestionnaire = v10.fetch,
		getAndFetchLatestQuestionnaire = v10.getAndFetch,
		getQuestionnaireById = function(p2)
			return v13.getCachedItem(p2)
		end,
		fetchQuestionnaireById = function(p2)
			return v13.fetchItem(p2)
		end,
		getAndFetchQuestionnaireById = function(p2)
			return v13.getAndFetchItem(p2)
		end,
		getLatestSubmission = v11.get,
		fetchLatestSubmission = v11.fetch,
		getAndFetchLatestSubmission = v11.getAndFetch,
		saveSubmission = function(p2, p3)
			return fetchExperienceQuestionnaire.saveSubmission(p2, p3, v6):andThen(function(p4)
				v9.fetch(p2)
				v11.fetch(p2)
				return p4
			end)
		end,
		validateResponses = function(p2)
			return fetchExperienceQuestionnaire.validateResponses(p2, v6)
		end,
		previewSubmission = function(p2)
			return fetchExperienceQuestionnaire.previewSubmission(p2, v6)
		end,
		clear = function()
			v7.clear()
			v8.clear()
			v9.clear()
			v10.clear()
			v13.clear()
			v11.clear()
		end,
		dispose = function()
			v7.dispose()
			v8.dispose()
			v9.dispose()
			v10.dispose()
			v13.dispose()
			v11.dispose()
		end
	}
end

return createExperienceQuestionnaireStore
