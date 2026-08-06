local DataHydration = script:FindFirstAncestor("DataHydration")
local DataHydrationParent = DataHydration.Parent

require(DataHydrationParent.HttpClient)

local createDataCache = require(DataHydration.createDataCache)
local createDataResolver = require(DataHydration.createDataResolver)

require(DataHydration.DataHydrationTypes)

local createSingleEntityResolver = require(DataHydration.createSingleEntityResolver)
local fetchExperienceQuestionnaire = require(script.Parent.fetchExperienceQuestionnaire)

require(script.Parent.ExperienceQuestionnaireStoreTypes)

local function createExperienceQuestionnaireStore(t1: {[any]: any}?) -- line: 23
	-- upvalues: createSingleEntityResolver (copy), fetchExperienceQuestionnaire (copy), createDataCache (copy), createDataResolver (copy)
	local v9 = t1 or {}
	local t2 = {
		network = v9.network,
		baseUrl = v9.baseUrl
	}
	local v11 = createSingleEntityResolver(function(n1: number) -- line: 27
		-- upvalues: fetchExperienceQuestionnaire (copy), t2 (copy)
		return fetchExperienceQuestionnaire.fetchEligibility(n1, t2)
	end)
	local v12 = createSingleEntityResolver(function(n2: number) -- line: 30
		-- upvalues: fetchExperienceQuestionnaire (copy), t2 (copy)
		return fetchExperienceQuestionnaire.fetchMetadataStatus(n2, t2)
	end)
	local v13 = createSingleEntityResolver(function(n3: number) -- line: 33
		-- upvalues: fetchExperienceQuestionnaire (copy), t2 (copy)
		return fetchExperienceQuestionnaire.fetchActiveResponse(n3, t2)
	end)
	local v14 = createSingleEntityResolver(function(n4: number) -- line: 36
		-- upvalues: fetchExperienceQuestionnaire (copy), t2 (copy)
		return fetchExperienceQuestionnaire.fetchLatestQuestionnaire(n4, t2)
	end)
	local v15 = createSingleEntityResolver(function(n5: number) -- line: 39
		-- upvalues: fetchExperienceQuestionnaire (copy), t2 (copy)
		return fetchExperienceQuestionnaire.fetchLatestSubmission(n5, t2)
	end)
	local v16 = createDataCache()
	local v17 = createDataResolver({
		supportsMultiGet = false,
		cache = v16,
		fetchFn = function(s1: string, _) -- line: 49
			-- upvalues: fetchExperienceQuestionnaire (copy), t2 (copy)
			return fetchExperienceQuestionnaire.fetchQuestionnaireById(s1, t2)
		end
	})

	return {
		getEligibility = v11.get,
		fetchEligibility = v11.fetch,
		getAndFetchEligibility = v11.getAndFetch,
		getMetadataStatus = v12.get,
		fetchMetadataStatus = v12.fetch,
		getAndFetchMetadataStatus = v12.getAndFetch,
		getActiveResponse = v13.get,
		fetchActiveResponse = v13.fetch,
		getAndFetchActiveResponse = v13.getAndFetch,
		getLatestQuestionnaire = v14.get,
		fetchLatestQuestionnaire = v14.fetch,
		getAndFetchLatestQuestionnaire = v14.getAndFetch,
		getQuestionnaireById = function(p2) -- line: 104
			-- upvalues: v17 (copy)
			return v17.getCachedItem(p2)
		end,
		fetchQuestionnaireById = function(p3) -- line: 107
			-- upvalues: v17 (copy)
			return v17.fetchItem(p3)
		end,
		getAndFetchQuestionnaireById = function(p4) -- line: 110
			-- upvalues: v17 (copy)
			return v17.getAndFetchItem(p4)
		end,
		getLatestSubmission = v15.get,
		fetchLatestSubmission = v15.fetch,
		getAndFetchLatestSubmission = v15.getAndFetch,
		saveSubmission = function(n6: number, p5) -- line: 57
			-- upvalues: fetchExperienceQuestionnaire (copy), t2 (copy), v13 (copy), v15 (copy)
			return fetchExperienceQuestionnaire.saveSubmission(n6, p5, t2):andThen(function(p6) -- line: 61
				-- upvalues: v13 (copy), n6 (copy), v15 (copy)
				v13.fetch(n6)
				v15.fetch(n6)

				return p6
			end)
		end,
		validateResponses = function(p7) -- line: 119
			-- upvalues: fetchExperienceQuestionnaire (copy), t2 (copy)
			return fetchExperienceQuestionnaire.validateResponses(p7, t2)
		end,
		previewSubmission = function(p8) -- line: 122
			-- upvalues: fetchExperienceQuestionnaire (copy), t2 (copy)
			return fetchExperienceQuestionnaire.previewSubmission(p8, t2)
		end,
		clear = function() -- line: 69
			-- upvalues: v11 (copy), v12 (copy), v13 (copy), v14 (copy), v17 (copy), v15 (copy)
			v11.clear()
			v12.clear()
			v13.clear()
			v14.clear()
			v17.clear()
			v15.clear()
		end,
		dispose = function() -- line: 78
			-- upvalues: v11 (copy), v12 (copy), v13 (copy), v14 (copy), v17 (copy), v15 (copy)
			v11.dispose()
			v12.dispose()
			v13.dispose()
			v14.dispose()
			v17.dispose()
			v15.dispose()
		end
	}
end

return createExperienceQuestionnaireStore
