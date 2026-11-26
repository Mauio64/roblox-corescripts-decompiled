local Dash = require("@game/CorePackages/Workspace/Packages/_Workspace/OnPlatformSurveys/Dash")

local fFlagInlineSurveyBranching = require("@game/CorePackages/Workspace/Packages/_Workspace/OnPlatformSurveys/SharedFlags").FFlagInlineSurveyBranching

local inlineSurveyHelpers = require("@game/CorePackages/Workspace/Packages/_Workspace/OnPlatformSurveys/OnPlatformSurveys/Utils/inlineSurveyHelpers")
local Phase = require("@game/CorePackages/Workspace/Packages/_Workspace/OnPlatformSurveys/OnPlatformSurveys/Enums/Phase")
require("@game/CorePackages/Workspace/Packages/_Workspace/OnPlatformSurveys/OnPlatformSurveys/Types/InlineSurveyTypes")

local v5 = {}

local function getInitialState(p2)
	return {
		phase = Phase.Loading,
		hasInvite = p2 == true,
		questions = {},
		index = 1,
		answersByQuestionId = {},
		answer = v5,
		surveyId = nil,
		idempotencyKey = nil,
		errorType = nil
	}
end

local function closedState(hasInvite)
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

			local v7 = if data.hasInvite then Phase.Invite else Phase.Started
			return join(initialState, {
				phase = v7,
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

			local v6 = if fFlagInlineSurveyBranching then inlineSurveyHelpers.resolveNextIndex(
				data.questions,
				data.index,
				data.answer
			) or data.index + 1 else data.index + 1
			return Dash.join(data, {
				index = v6,
				answersByQuestionId = mergeCurrentAnswerIntoBatch,
				answer = v5,
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
			return Dash.join(data, {
				phase = Phase.Completed,
				errorType = Dash.None
			})
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
