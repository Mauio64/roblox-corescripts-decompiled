local DataHydration = script:FindFirstAncestor("DataHydration")
local DataHydrationParent = DataHydration.Parent
local HttpClient = require(DataHydrationParent.HttpClient)
local UrlBase = require(DataHydrationParent.UrlBuilder).UrlBase
local withCsrfRetry = require(DataHydration.withCsrfRetry)

require(script.Parent.ExperienceQuestionnaireStoreTypes)

local fetch = HttpClient.fetch
local asPromise = HttpClient.asPromise

local function resolveBase(t1: {[any]: any}?) -- line: 21
	-- upvalues: UrlBase (copy)
	local v13 = t1 or {}

	return v13.network, v13.baseUrl or UrlBase.APIS
end
local function resolveMutatingNetwork(t2: {[any]: any}?) -- line: 26
	-- upvalues: withCsrfRetry (copy), HttpClient (copy)
	return (t2 or {}).network or withCsrfRetry(HttpClient.createRequestInternalNetwork())
end
local function get(t3: {[any]: any}?, s1: string, s2: string) -- line: 31
	-- upvalues: UrlBase (copy), fetch (copy), asPromise (copy)
	local v18 = t3 or {}
	local network = v18.network
	local v20 = v18.baseUrl or UrlBase.APIS
	local v21 = fetch({
		method = "GET",
		network = network,
		url = v20 .. "/experience-questionnaire/v1" .. s1,
		analyticsKey = s2,
		decode = function(p1) -- line: 42
			return p1
		end
	})

	return asPromise(v21)
end
local function post(t4: {[any]: any}?, s3: string, p2, s4: string) -- line: 49
	-- upvalues: UrlBase (copy), fetch (copy), withCsrfRetry (copy), HttpClient (copy), asPromise (copy)
	local v26 = t4 or {}
	local _ = v26.network
	local v28 = v26.baseUrl or UrlBase.APIS
	local v29 = fetch({
		method = "POST",
		network = (t4 or {}).network or withCsrfRetry(HttpClient.createRequestInternalNetwork()),
		url = v28 .. "/experience-questionnaire/v1" .. s3,
		body = p2,
		analyticsKey = s4,
		decode = function(p3) -- line: 62
			return p3
		end
	})

	return asPromise(v29)
end

return {
	fetchEligibility = function(n1: number, t5: {[any]: any}?) -- line: 71
		-- upvalues: get (copy)
		return get(t5, ("/eligibility/%d"):format(n1), "experience-questionnaire.get-eligibility")
	end,
	fetchMetadataStatus = function(n2: number, t6: {[any]: any}?) -- line: 78
		-- upvalues: get (copy)
		return get(t6, ("/metadata/%d/status"):format(n2), "experience-questionnaire.get-metadata-status")
	end,
	fetchActiveResponse = function(n3: number, t7: {[any]: any}?) -- line: 85
		-- upvalues: get (copy)
		return get(t7, ("/responses/%d"):format(n3), "experience-questionnaire.get-active-response")
	end,
	fetchLatestQuestionnaire = function(n4: number, t8: {[any]: any}?) -- line: 92
		-- upvalues: get (copy)
		return get(t8, ("/questionnaires/%d/latest"):format(n4), "experience-questionnaire.get-latest-questionnaire")
	end,
	fetchQuestionnaireById = function(s5: string, t9: {[any]: any}?) -- line: 103
		-- upvalues: get (copy)
		return get(t9, "/questionnaires/" .. s5, "experience-questionnaire.get-questionnaire-by-id")
	end,
	fetchLatestSubmission = function(n5: number, t10: {[any]: any}?) -- line: 110
		-- upvalues: get (copy)
		return get(t10, ("/responses/%d/submissions/latest"):format(n5), "experience-questionnaire.get-latest-submission")
	end,
	saveSubmission = function(n6: number, p4, t11: {[any]: any}?) -- line: 121
		-- upvalues: post (copy)
		return post(t11, ("/responses/%d/submissions"):format(n6), p4, "experience-questionnaire.save-submission")
	end,
	validateResponses = function(p5, t12: {[any]: any}?) -- line: 134
		-- upvalues: post (copy)
		return post(t12, "/responses/validate", p5, "experience-questionnaire.validate-responses")
	end,
	previewSubmission = function(p6, t13: {[any]: any}?) -- line: 141
		-- upvalues: post (copy)
		return post(t13, "/responses/preview", p6, "experience-questionnaire.preview-submission")
	end
}
