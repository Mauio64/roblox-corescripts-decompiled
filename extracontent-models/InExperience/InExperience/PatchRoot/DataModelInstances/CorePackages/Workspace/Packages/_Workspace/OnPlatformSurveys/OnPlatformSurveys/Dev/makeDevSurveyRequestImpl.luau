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
local t2 = {
	{
		questionId = "rating",
		title = "How would you rate your experience today?",
		required = true,
		type = InlineQuestionType.MultipleChoiceSingle,
		choices = {
			{
				id = "great",
				label = "Great",
				next = "details"
			},
			{
				id = "ok",
				label = "Okay",
				next = "details"
			},
			{
				id = "bad",
				label = "Not great",
				next = "issues"
			}
		}
	},
	{
		questionId = "issues",
		title = "What went wrong?",
		required = true,
		type = InlineQuestionType.MultipleChoiceMulti,
		choices = {
			{
				id = "performance",
				label = "Performance"
			},
			{
				id = "bugs",
				label = "Bugs"
			},
			{
				id = "confusing",
				label = "Confusing to use"
			}
		}
	},
	{
		questionId = "details",
		title = "Anything else you'd like to share?",
		type = InlineQuestionType.Text
	}
}

local function isResponseUrl(s1: string) -- line: 77
	return string.sub(s1, -16) == "/survey/response"
end
local function makeRequestImplFor(s2: string, t3: {[any]: any}) -- line: 82
	-- upvalues: Promise (copy)
	return function(s3: string, _: string, _) -- line: 83
		-- upvalues: Promise (copy), s2 (copy), t3 (copy)
		return Promise.new(function(resolve) -- line: 84
			-- upvalues: s3 (copy), s2 (copy), t3 (copy)
			task.delay(0.4, function() -- line: 85
				-- upvalues: s3 (copy), resolve (copy), s2 (copy), t3 (copy)
				if string.sub(s3, -16) == "/survey/response" then
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
						shouldPromptSurvey = true,
						surveyId = s2,
						questions = t3
					}
				})
			end)
		end)
	end
end

return {
	SURVEY_ID = "dev-survey",
	BRANCHING_SURVEY_ID = "dev-branching-survey",
	RESPONSE_DELAY_SECONDS = 0.4,
	makeRequestImpl = function() -- line: 108
		-- upvalues: t1 (copy), Promise (copy)
		local v12 = t1
		local s5 = "dev-survey"

		return function(s6: string, _: string, _) -- line: 83
			-- upvalues: Promise (copy), s5 (copy), v12 (copy)
			return Promise.new(function(resolve) -- line: 84
				-- upvalues: s6 (copy), s5 (copy), v12 (copy)
				task.delay(0.4, function() -- line: 85
					-- upvalues: s6 (copy), resolve (copy), s5 (copy), v12 (copy)
					if string.sub(s6, -16) == "/survey/response" then
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
							shouldPromptSurvey = true,
							surveyId = s5,
							questions = v12
						}
					})
				end)
			end)
		end
	end,
	makeBranchingRequestImpl = function() -- line: 112
		-- upvalues: t2 (copy), Promise (copy)
		local v14 = t2
		local s8 = "dev-branching-survey"

		return function(s9: string, _: string, _) -- line: 83
			-- upvalues: Promise (copy), s8 (copy), v14 (copy)
			return Promise.new(function(resolve) -- line: 84
				-- upvalues: s9 (copy), s8 (copy), v14 (copy)
				task.delay(0.4, function() -- line: 85
					-- upvalues: s9 (copy), resolve (copy), s8 (copy), v14 (copy)
					if string.sub(s9, -16) == "/survey/response" then
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
							shouldPromptSurvey = true,
							surveyId = s8,
							questions = v14
						}
					})
				end)
			end)
		end
	end,
	QUESTIONS = t1,
	BRANCHING_QUESTIONS = t2
}
