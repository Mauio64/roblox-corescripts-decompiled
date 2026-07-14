local OnPlatformSurveys = script:FindFirstAncestor("OnPlatformSurveys")
local OnPlatformSurveysParent = OnPlatformSurveys.Parent
local HttpService = game:GetService("HttpService")
local Url = require(OnPlatformSurveysParent.Http).Url

require(OnPlatformSurveys.Types.InlineSurveyTypes)

return {
	fetchInlineSurvey = function(p1, p2) -- line: 43
		-- upvalues: Url (copy), HttpService (copy)
		return p1(string.format("%s%s?eventType=%s&surveyType=inline", Url.APIS_URL, "v1/survey", HttpService:UrlEncode(p2)), "GET"):andThen(function(p3) -- line: 50
			return p3.responseBody
		end)
	end,
	submitSurveyResponse = function(p4, p5) -- line: 81
		-- upvalues: Url (copy), HttpService (copy)
		return p4(Url.APIS_URL .. "v1/survey/response", "POST", {
			postBody = HttpService:JSONEncode(p5)
		}):andThen(function(p6) -- line: 84
			return p6.responseBody
		end)
	end
}
