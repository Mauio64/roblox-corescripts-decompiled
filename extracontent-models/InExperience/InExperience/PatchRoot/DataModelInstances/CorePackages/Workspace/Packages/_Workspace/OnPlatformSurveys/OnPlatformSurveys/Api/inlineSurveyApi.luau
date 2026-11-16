local OnPlatformSurveys = script:FindFirstAncestor("OnPlatformSurveys")
local parent = OnPlatformSurveys.Parent
local HttpService = game:GetService("HttpService")

local Http = require(parent.Http)
local Url = Http.Url

require(OnPlatformSurveys.Types.InlineSurveyTypes)
local InlineSurveyApi = {}

function InlineSurveyApi.fetchInlineSurvey(callback, p)
	return callback(
		string.format("%s%s?eventType=%s&surveyType=inline", Url.APIS_URL, "v1/survey", HttpService:UrlEncode(p)),
		"GET"
	):andThen(function(p2)
		return p2.responseBody
	end)
end

function InlineSurveyApi.submitSurveyResponse(callback, p)
	return callback(Url.APIS_URL .. "v1/survey/response", "POST", {
		postBody = HttpService:JSONEncode(p)
	}):andThen(function(p2)
		return p2.responseBody
	end)
end

return InlineSurveyApi
