local OnPlatformSurveys = script:FindFirstAncestor("OnPlatformSurveys")
local OnPlatformSurveysParent = OnPlatformSurveys.Parent
local Dash = require(OnPlatformSurveysParent.Dash)
local FFlagInlineSurveyBranching = require(OnPlatformSurveysParent.SharedFlags).FFlagInlineSurveyBranching
local inlineSurveyHelpers = require(OnPlatformSurveys.Utils.inlineSurveyHelpers)
local Phase = require(OnPlatformSurveys.Enums.Phase)

require(OnPlatformSurveys.Types.InlineSurveyTypes)

local t1 = {}

local function getInitialState(b1: boolean?) -- line: 51
	-- upvalues: Phase (copy), t1 (copy)
	return {
		index = 1,
		surveyId = nil,
		idempotencyKey = nil,
		errorType = nil,
		phase = Phase.Loading,
		hasInvite = b1 == true,
		questions = {},
		answersByQuestionId = {},
		answer = t1
	}
end
local function closedState(b2: boolean) -- line: 65
	-- upvalues: Dash (copy), getInitialState (copy), Phase (copy)
	return Dash.join(getInitialState(b2), {
		phase = Phase.Closed
	})
end

return {
	getInitialState = getInitialState,
	reducer = function(t2: {[any]: any}, t3: {[any]: any}) -- line: 69
		-- upvalues: getInitialState (copy), closedState (copy), Dash (copy), Phase (copy), inlineSurveyHelpers (copy), FFlagInlineSurveyBranching (copy), t1 (copy)
		if t3.type == "fetchRequested" then
			return (getInitialState(t2.hasInvite))
		end

		if t3.type == "questionsReceived" then
			local response = t3.response

			if response == nil or response.shouldPromptSurvey ~= true then
				return closedState(t2.hasInvite)
			end

			local questions = response.questions

			if questions == nil or #questions == 0 then
				return closedState(t2.hasInvite)
			end

			return Dash.join(getInitialState(t2.hasInvite), {
				phase = if not t2.hasInvite then Phase.Started else Phase.Invite,
				questions = questions,
				surveyId = response.surveyId
			})
		end

		if t3.type == "fetchFailed" then
			return Dash.join(t2, {
				errorType = "fetch",
				phase = Phase.Error
			})
		end

		if t3.type == "setAnswer" then
			return Dash.join(t2, {
				answer = t3.answer
			})
		end

		if t3.type == "next" then
			local v16 = inlineSurveyHelpers.mergeCurrentAnswerIntoBatch(t2.answersByQuestionId, t2.questions[t2.index], t2.answer)
			local v17 = if not FFlagInlineSurveyBranching then t2.index + 1 else inlineSurveyHelpers.resolveNextIndex(t2.questions, t2.index, t2.answer) or t2.index + 1

			return Dash.join(t2, {
				index = v17,
				answersByQuestionId = v16,
				answer = t1,
				errorType = Dash.None
			})
		end

		if t3.type == "submitStarted" then
			return Dash.join(t2, {
				phase = Phase.Submitting,
				answersByQuestionId = inlineSurveyHelpers.mergeCurrentAnswerIntoBatch(t2.answersByQuestionId, t2.questions[t2.index], t2.answer),
				idempotencyKey = t3.idempotencyKey,
				errorType = Dash.None
			})
		end

		if t3.type == "submitSucceeded" then
			return Dash.join(t2, {
				phase = Phase.Completed,
				errorType = Dash.None
			})
		end

		if t3.type == "submitFailed" then
			return Dash.join(t2, {
				errorType = "submit",
				phase = Phase.Error
			})
		end

		if t3.type == "inviteAccepted" then
			return Dash.join(t2, {
				phase = Phase.Started
			})
		end

		if t3.type == "inviteDeclined" then
			return closedState(t2.hasInvite)
		end

		if t3.type == "dismissed" then
			return closedState(t2.hasInvite)
		end

		return t2
	end
}
