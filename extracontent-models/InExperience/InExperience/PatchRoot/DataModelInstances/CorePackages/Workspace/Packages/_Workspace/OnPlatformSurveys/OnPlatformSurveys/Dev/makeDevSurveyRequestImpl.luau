local OnPlatformSurveys = script:FindFirstAncestor("OnPlatformSurveys")
local OnPlatformSurveysParent = OnPlatformSurveys.Parent
local Promise = require(OnPlatformSurveysParent.Promise)
local InlineQuestionType = require(OnPlatformSurveys.Enums.InlineQuestionType)

require(OnPlatformSurveys.Types.InlineSurveyTypes)

local t1 = {{
	questionId = "q1",
	title = "How would you rate your experience today?",
	required = true,
	type = InlineQuestionType.MultipleChoiceSingle,
	choices = {
		{
			id = "great",
			label = "Great"
		},
		{
			id = "ok",
			label = "Okay"
		},
		{
			id = "bad",
			label = "Not great"
		}
	}
}}

local function isResponseUrl(s1: string) -- line: 43
	return string.sub(s1, -16) == "/survey/response"
end

return {
	SURVEY_ID = "dev-survey",
	RESPONSE_DELAY_SECONDS = 0.4,
	makeRequestImpl = function() -- line: 48
		-- upvalues: Promise (copy), t1 (copy)
		return function(s2: string, _: string, _) -- line: 49
			-- upvalues: Promise (copy), t1 (copy)
			return Promise.new(function(resolve) -- line: 50
				-- upvalues: s2 (copy), t1 (copy)
				task.delay(0.4, function() -- line: 51
					-- upvalues: s2 (copy), resolve (copy), t1 (copy)
					if string.sub(s2, -16) == "/survey/response" then
						resolve({
							responseCode = 200,
							responseBody = {
								responseId = "dev-response"
							}
						})

						return
					end

					resolve({
						responseCode = 200,
						responseBody = {
							surveyId = "dev-survey",
							shouldPromptSurvey = true,
							questions = t1
						}
					})
				end)
			end)
		end
	end,
	QUESTIONS = t1
}
