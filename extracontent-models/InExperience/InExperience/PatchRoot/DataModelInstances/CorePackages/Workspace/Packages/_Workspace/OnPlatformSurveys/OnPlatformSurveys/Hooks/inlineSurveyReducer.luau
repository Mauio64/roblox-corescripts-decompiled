local OnPlatformSurveys = script:FindFirstAncestor("OnPlatformSurveys")
local parent = OnPlatformSurveys.Parent

local Dash = require(parent.Dash)

local SharedFlags = require(parent.SharedFlags)
local FFlagInlineSurveyBranching = SharedFlags.FFlagInlineSurveyBranching

local inlineSurveyHelpers = require(OnPlatformSurveys.Utils.inlineSurveyHelpers)
local Phase = require(OnPlatformSurveys.Enums.Phase)
require(OnPlatformSurveys.Types.InlineSurveyTypes)

local answer = {}

local function getInitialState(flag: boolean?)
	return {
		phase = Phase.Loading,
		hasInvite = flag == true,
		questions = {},
		index = 1,
		answersByQuestionId = {},
		answer = answer,
		surveyId = nil,
		idempotencyKey = nil,
		errorType = nil
	}
end

local function closedState(hasInvite: boolean)
	return Dash.join(getInitialState(hasInvite), { phase = Phase.Closed })
end

return {
	getInitialState = getInitialState,
	reducer = function(data, data2)
		if data2.type == "fetchRequested" then
			return getInitialState(data.hasInvite)
		end

		if data2.type == "questionsReceived" then
			local response = data2.response

			if response == nil or response.shouldPromptSurvey ~= true then
				return closedState(data.hasInvite)
			end

			local questions = response.questions

			if questions == nil or #questions == 0 then
				return closedState(data.hasInvite)
			end

			local join = Dash.join
			local initialState = getInitialState(data.hasInvite)
			local phase

			if data.hasInvite then
				phase = Phase.Invite
			else
				phase = Phase.Started
			end

			return join(initialState, {
				phase = phase,
				questions = questions,
				surveyId = response.surveyId
			})
		end

		if data2.type == "fetchFailed" then
			return Dash.join(data, { phase = Phase.Error, errorType = "fetch" })
		end

		if data2.type == "setAnswer" then
			return Dash.join(data, { answer = data2.answer })
		end

		if data2.type == "next" then
			local mergeCurrentAnswerIntoBatch = inlineSurveyHelpers.mergeCurrentAnswerIntoBatch(
				data.answersByQuestionId,
				data.questions[data.index],
				data.answer
			)
			local v

			if FFlagInlineSurveyBranching then
				v = inlineSurveyHelpers.resolveNextIndex(data.questions, data.index, data.answer) or data.index + 1
			else
				v = data.index + 1
			end

			return Dash.join(data, {
				index = v,
				answersByQuestionId = mergeCurrentAnswerIntoBatch,
				answer = answer,
				errorType = Dash.None
			})
		end

		if data2.type == "submitStarted" then
			return Dash.join(data, {
				phase = Phase.Submitting,
				answersByQuestionId = inlineSurveyHelpers.mergeCurrentAnswerIntoBatch(
					data.answersByQuestionId,
					data.questions[data.index],
					data.answer
				),
				idempotencyKey = data2.idempotencyKey,
				errorType = Dash.None
			})
		end

		if data2.type == "submitSucceeded" then
			return Dash.join(data, { phase = Phase.Completed, errorType = Dash.None })
		end

		if data2.type == "submitFailed" then
			return Dash.join(data, { phase = Phase.Error, errorType = "submit" })
		end

		if data2.type == "inviteAccepted" then
			return Dash.join(data, { phase = Phase.Started })
		end

		if not (data2.type ~= "inviteDeclined" and data2.type ~= "dismissed") then
			return closedState(data.hasInvite)
		end

		return data
	end
}
