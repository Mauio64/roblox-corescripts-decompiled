local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/OnPlatformSurveys/Promise")

local InlineQuestionType = require("@game/CorePackages/Workspace/Packages/_Workspace/OnPlatformSurveys/OnPlatformSurveys/Enums/InlineQuestionType")
require("@game/CorePackages/Workspace/Packages/_Workspace/OnPlatformSurveys/OnPlatformSurveys/Types/InlineSurveyTypes")

local v5 = {
	{
		questionId = "q1",
		type = InlineQuestionType.MultipleChoiceSingle,
		title = "How would you rate your experience today?",
		required = true,
		choices = {
			{ id = "great", label = "Great" },
			{ id = "ok", label = "Okay" },
			{ id = "bad", label = "Not great" }
		}
	}
}

local v6 = {
	{
		questionId = "rating",
		type = InlineQuestionType.MultipleChoiceSingle,
		title = "How would you rate your experience today?",
		required = true,
		choices = {
			{ id = "great", label = "Great", next = "details" },
			{ id = "ok", label = "Okay", next = "details" },
			{ id = "bad", label = "Not great", next = "issues" }
		}
	},
	{
		questionId = "issues",
		type = InlineQuestionType.MultipleChoiceMulti,
		title = "What went wrong?",
		required = true,
		choices = {
			{ id = "performance", label = "Performance" },
			{ id = "bugs", label = "Bugs" },
			{ id = "confusing", label = "Confusing to use" }
		}
	},
	{
		questionId = "details",
		type = InlineQuestionType.Text,
		title = "Anything else you'd like to share?"
	}
}

local function isResponseUrl(value): boolean
	return string.sub(value, -16) == "/survey/response"
end

local function makeRequestImplFor(p2, p3)
	return function(value, p4, p5)
		return Promise.new(function(callback)
			task.delay(0.4, function()
				if string.sub(value, -16) == "/survey/response" then
					callback({
						responseBody = { responseId = "dev-response" },
						responseCode = 200
					})
				else
					callback({
						responseBody = {
							surveyId = p2,
							shouldPromptSurvey = true,
							questions = p3
						},
						responseCode = 200
					})
				end
			end)
		end)
	end
end

return {
	makeRequestImpl = function()
		local v7 = v5
		local v8 = "dev-survey"
		return function(value, p2, p3)
			return Promise.new(function(callback)
				task.delay(0.4, function()
					if string.sub(value, -16) == "/survey/response" then
						callback({
							responseBody = { responseId = "dev-response" },
							responseCode = 200
						})
					else
						callback({
							responseBody = {
								surveyId = v8,
								shouldPromptSurvey = true,
								questions = v7
							},
							responseCode = 200
						})
					end
				end)
			end)
		end
	end,
	makeBranchingRequestImpl = function()
		local v7 = v6
		local v8 = "dev-branching-survey"
		return function(value, p2, p3)
			return Promise.new(function(callback)
				task.delay(0.4, function()
					if string.sub(value, -16) == "/survey/response" then
						callback({
							responseBody = { responseId = "dev-response" },
							responseCode = 200
						})
					else
						callback({
							responseBody = {
								surveyId = v8,
								shouldPromptSurvey = true,
								questions = v7
							},
							responseCode = 200
						})
					end
				end)
			end)
		end
	end,
	QUESTIONS = v5,
	BRANCHING_QUESTIONS = v6,
	SURVEY_ID = "dev-survey",
	BRANCHING_SURVEY_ID = "dev-branching-survey",
	RESPONSE_DELAY_SECONDS = 0.4
}
