local HttpClient = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/HttpClient")
local urlBase = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/UrlBuilder").UrlBase

local withCsrfRetry = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/withCsrfRetry")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/ExperienceQuestionnaire/ExperienceQuestionnaireStoreTypes")

local fetch = HttpClient.fetch
local asPromise = HttpClient.asPromise

local function resolveBase(options)
	local v5 = options or {}
	return v5.network, v5.baseUrl or urlBase.APIS
end

local function resolveMutatingNetwork(options)
	return (options or {}).network or withCsrfRetry(HttpClient.createRequestInternalNetwork())
end

local function get(options, p2, p3)
	local v5 = options or {}
	local network = v5.network
	local baseUrl = v5.baseUrl or urlBase.APIS

	return asPromise((fetch({
		network = network,
		method = "GET",
		url = baseUrl .. "/experience-questionnaire/v1" .. p2,
		analyticsKey = p3,
		decode = function(p4)
			return p4
		end
	})))
end

local function post(options, p2, p3, p4)
	local v5 = options or {}
	local network = v5.network
	local baseUrl = v5.baseUrl or urlBase.APIS

	return asPromise((fetch({
		network = (options or {}).network or withCsrfRetry(HttpClient.createRequestInternalNetwork()),
		method = "POST",
		url = baseUrl .. "/experience-questionnaire/v1" .. p2,
		body = p3,
		analyticsKey = p4,
		decode = function(p5)
			return p5
		end
	})))
end

return {
	fetchEligibility = function(p2, p3)
		return get(p3, ("/eligibility/%d"):format(p2), "experience-questionnaire.get-eligibility")
	end,
	fetchMetadataStatus = function(p2, p3)
		return get(p3, ("/metadata/%d/status"):format(p2), "experience-questionnaire.get-metadata-status")
	end,
	fetchActiveResponse = function(p2, p3)
		return get(p3, ("/responses/%d"):format(p2), "experience-questionnaire.get-active-response")
	end,
	fetchLatestQuestionnaire = function(p2, p3)
		return get(
			p3,
			("/questionnaires/%d/latest"):format(p2),
			"experience-questionnaire.get-latest-questionnaire"
		)
	end,
	fetchQuestionnaireById = function(p2, p3)
		return get(p3, "/questionnaires/" .. p2, "experience-questionnaire.get-questionnaire-by-id")
	end,
	fetchLatestSubmission = function(p2, p3)
		return get(
			p3,
			("/responses/%d/submissions/latest"):format(p2),
			"experience-questionnaire.get-latest-submission"
		)
	end,
	saveSubmission = function(p2, p3, p4)
		return post(
			p4,
			("/responses/%d/submissions"):format(p2),
			p3,
			"experience-questionnaire.save-submission"
		)
	end,
	validateResponses = function(p2, p3)
		return post(p3, "/responses/validate", p2, "experience-questionnaire.validate-responses")
	end,
	previewSubmission = function(p2, p3)
		return post(p3, "/responses/preview", p2, "experience-questionnaire.preview-submission")
	end
}
