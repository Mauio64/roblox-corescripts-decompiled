local HttpService = game:GetService("HttpService")

local url = require("@game/CorePackages/Workspace/Packages/_Workspace/OnPlatformSurveys/Http").Url

require("@game/CorePackages/Workspace/Packages/_Workspace/OnPlatformSurveys/OnPlatformSurveys/Types/InlineSurveyTypes")

return {
	fetchInlineSurvey = function(callback, p2)
		return callback(
			string.format(
				"%s%s?eventType=%s&surveyType=inline",
				url.APIS_URL,
				"v1/survey",
				HttpService:UrlEncode(p2)
			),
			"GET"
		):andThen(function(p3)
			return p3.responseBody
		end)
	end,
	submitSurveyResponse = function(callback, p2)
		return callback(url.APIS_URL .. "v1/survey/response", "POST", {
			postBody = HttpService:JSONEncode(p2)
		}):andThen(function(p3)
			return p3.responseBody
		end)
	end
}
