local OnPlatformSurveys = script:FindFirstAncestor("OnPlatformSurveys")
local parent = OnPlatformSurveys.Parent

local Promise = require(parent.Promise)

local InlineQuestionType = require(OnPlatformSurveys.Enums.InlineQuestionType)
require(OnPlatformSurveys.Types.InlineSurveyTypes)

local questions = {
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

local v = {
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

local function isResponseUrl(value: string): boolean -- 1 equivalent call inferred from this helper
	return string.sub(value, -16) == "/survey/response"
end

local function makeRequestImplFor(surveyId: string, questions2) -- 2 equivalent calls inferred from this helper
	return function(value: string, _: string, _)
		return Promise.new(function(callback)
			task.delay(0.4, function()
				if isResponseUrl(value) then -- inferred equivalent call
					callback({
						responseBody = { responseId = "dev-response" },
						responseCode = 200
					})
				else
					callback({
						responseBody = {
							surveyId = surveyId,
							shouldPromptSurvey = true,
							questions = questions2
						},
						responseCode = 200
					})
				end
			end)
		end)
	end
end

local MakeDevSurveyRequestImpl = {}

function MakeDevSurveyRequestImpl.makeRequestImpl()
	return makeRequestImplFor("dev-survey", questions) -- inferred equivalent call
end

function MakeDevSurveyRequestImpl.makeBranchingRequestImpl()
	return makeRequestImplFor("dev-branching-survey", v) -- inferred equivalent call
end

MakeDevSurveyRequestImpl.QUESTIONS = questions
MakeDevSurveyRequestImpl.BRANCHING_QUESTIONS = v
MakeDevSurveyRequestImpl.SURVEY_ID = "dev-survey"
MakeDevSurveyRequestImpl.BRANCHING_SURVEY_ID = "dev-branching-survey"
MakeDevSurveyRequestImpl.RESPONSE_DELAY_SECONDS = 0.4
return MakeDevSurveyRequestImpl
