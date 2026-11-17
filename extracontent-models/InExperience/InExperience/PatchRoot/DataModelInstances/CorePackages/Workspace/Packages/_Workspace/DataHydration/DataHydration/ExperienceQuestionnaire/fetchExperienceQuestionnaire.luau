local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

local HttpClient = require(parent.HttpClient)
local UrlBuilder = require(parent.UrlBuilder)
local UrlBase = UrlBuilder.UrlBase

local withCsrfRetry = require(DataHydration.withCsrfRetry)
require(script.Parent.ExperienceQuestionnaireStoreTypes)

local fetch = HttpClient.fetch
local asPromise = HttpClient.asPromise

local function resolveBase(options) -- 2 equivalent calls inferred from this helper
	local v = options or {}
	return v.network, v.baseUrl or UrlBase.APIS
end

local function resolveMutatingNetwork(options) -- 1 equivalent call inferred from this helper
	return (options or {}).network or withCsrfRetry(HttpClient.createRequestInternalNetwork())
end

local function get(options, p: string, analyticsKey: string)
	local base, v = resolveBase(options) -- inferred equivalent call
	return asPromise((fetch({
		network = base,
		method = "GET",
		url = v .. "/experience-questionnaire/v1" .. p,
		analyticsKey = analyticsKey,
		decode = function(p2)
			return p2
		end
	})))
end

local function post(options, p: string, body, analyticsKey: string)
	local _, v = resolveBase(options) -- inferred equivalent call
	return asPromise((fetch({
		network = resolveMutatingNetwork(options), -- inferred equivalent call
		method = "POST",
		url = v .. "/experience-questionnaire/v1" .. p,
		body = body,
		analyticsKey = analyticsKey,
		decode = function(p2)
			return p2
		end
	})))
end

local FetchExperienceQuestionnaire = {}

function FetchExperienceQuestionnaire.fetchEligibility(p: number, p2)
	return get(p2, ("/eligibility/%d"):format(p), "experience-questionnaire.get-eligibility")
end

function FetchExperienceQuestionnaire.fetchMetadataStatus(p: number, p2)
	return get(p2, ("/metadata/%d/status"):format(p), "experience-questionnaire.get-metadata-status")
end

function FetchExperienceQuestionnaire.fetchActiveResponse(p: number, p2)
	return get(p2, ("/responses/%d"):format(p), "experience-questionnaire.get-active-response")
end

function FetchExperienceQuestionnaire.fetchLatestQuestionnaire(p: number, p2)
	return get(p2, ("/questionnaires/%d/latest"):format(p), "experience-questionnaire.get-latest-questionnaire")
end

function FetchExperienceQuestionnaire.fetchQuestionnaireById(p: string, p2)
	return get(p2, "/questionnaires/" .. p, "experience-questionnaire.get-questionnaire-by-id")
end

function FetchExperienceQuestionnaire.fetchLatestSubmission(p: number, p2)
	return get(p2, ("/responses/%d/submissions/latest"):format(p), "experience-questionnaire.get-latest-submission")
end

function FetchExperienceQuestionnaire.saveSubmission(p: number, body, p2)
	return post(p2, ("/responses/%d/submissions"):format(p), body, "experience-questionnaire.save-submission")
end

function FetchExperienceQuestionnaire.validateResponses(body, p)
	return post(p, "/responses/validate", body, "experience-questionnaire.validate-responses")
end

function FetchExperienceQuestionnaire.previewSubmission(body, p)
	return post(p, "/responses/preview", body, "experience-questionnaire.preview-submission")
end

return FetchExperienceQuestionnaire
