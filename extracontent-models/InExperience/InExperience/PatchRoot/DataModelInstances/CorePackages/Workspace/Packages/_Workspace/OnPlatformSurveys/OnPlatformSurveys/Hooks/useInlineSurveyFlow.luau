local OnPlatformSurveys = script:FindFirstAncestor("OnPlatformSurveys")
local parent = OnPlatformSurveys.Parent
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")

local React = require(parent.React)

local SharedFlags = require(parent.SharedFlags)
local FFlagInlineSurveyEnhancements = SharedFlags.FFlagInlineSurveyEnhancements
local FFlagInlineSurveyBranching = SharedFlags.FFlagInlineSurveyBranching
local FFlagInlineSurveyPartialResponse = SharedFlags.FFlagInlineSurveyPartialResponse

local inlineSurveyHelpers = require(OnPlatformSurveys.Utils.inlineSurveyHelpers)
local inlineSurveyApi = require(OnPlatformSurveys.Api.inlineSurveyApi)
local Phase = require(OnPlatformSurveys.Enums.Phase)
local inlineSurveyReducer = require(OnPlatformSurveys.Hooks.inlineSurveyReducer)
require(OnPlatformSurveys.Types.InlineSurveyTypes)

local function releaseKeyboardFocus() -- 2 equivalent calls inferred from this helper
	local focusedTextBox = UserInputService:GetFocusedTextBox()

	if focusedTextBox ~= nil then
		focusedTextBox:ReleaseFocus()
	end
end

local function useInlineSurveyFlow(data)
	local networkImpl = data.networkImpl
	local eventType = data.eventType

	local v, v2 = React.useReducer(
		inlineSurveyReducer.reducer,
		data.hasInvite == true,
		inlineSurveyReducer.getInitialState
	)

	local ref = React.useRef(0)

	local ref2 = React.useRef(false)

	local ref3 = React.useRef(v)
	ref3.current = v
	local ref4 = React.useRef(data.onClose)
	ref4.current = data.onClose
	local ref5 = React.useRef(data.onComplete)
	ref5.current = data.onComplete
	local ref6 = React.useRef(data.onEligible)
	ref6.current = data.onEligible
	local ref7 = React.useRef(false)

	local v3 = React.useCallback(function()
		local current = ref.current + 1
		ref.current = current
		ref2.current = false
		ref7.current = false
		v2({ type = "fetchRequested" })
		inlineSurveyApi.fetchInlineSurvey(networkImpl, eventType):andThen(function(response)
			if ref.current ~= current then
				return
			end

			v2({ type = "questionsReceived", response = response })
		end):catch(function(p)
			if ref.current ~= current then
				return
			end

			warn("Inline survey fetch failed:", p)
			v2({ type = "fetchFailed" })
		end)
	end, { networkImpl, eventType })

	local v4 = React.useCallback(function()
		local current = ref3.current

		if ref2.current then
			return
		end

		local question = current.questions[current.index]
		local surveyId = current.surveyId

		if question == nil or surveyId == nil then
			return
		end

		local mergeCurrentAnswerIntoBatch = inlineSurveyHelpers.mergeCurrentAnswerIntoBatch(
			current.answersByQuestionId,
			question,
			current.answer
		)
		local v4

		if FFlagInlineSurveyBranching then
			v4 = inlineSurveyHelpers.getVisitedQuestions(current.questions, mergeCurrentAnswerIntoBatch)
		else
			v4 = current.questions
		end

		if not inlineSurveyHelpers.canSubmitAll(v4, mergeCurrentAnswerIntoBatch) then
			return
		end

		local idempotencyKey = current.idempotencyKey or HttpService:GenerateGUID(false)
		local submitPayload = inlineSurveyHelpers.buildSubmitPayload(
			surveyId,
			v4,
			mergeCurrentAnswerIntoBatch,
			idempotencyKey
		)

		if #submitPayload.answers == 0 then
			v2({ type = "submitSucceeded" })
			return
		end

		local current2 = ref.current + 1
		ref.current = current2
		ref2.current = true
		v2({ type = "submitStarted", idempotencyKey = idempotencyKey })
		inlineSurveyApi.submitSurveyResponse(networkImpl, submitPayload):andThen(function(_)
			if ref.current ~= current2 then
				return
			end

			ref2.current = false
			v2({ type = "submitSucceeded" })
		end):catch(function(p)
			if ref.current ~= current2 then
				return
			end

			ref2.current = false
			warn("Inline survey submit failed:", p)
			v2({ type = "submitFailed" })
		end)
	end, { networkImpl })

	local submit = React.useCallback(function()
		local current = ref3.current

		if current.questions[current.index] == nil or ref2.current then
			return
		end

		if not FFlagInlineSurveyEnhancements then
			v4()
			return
		end

		if not inlineSurveyHelpers.canAdvance(
			current.questions,
			current.index,
			current.answersByQuestionId,
			current.answer
		) then
			return
		end

		releaseKeyboardFocus() -- inferred equivalent call

		if inlineSurveyHelpers.isLastQuestion(current.questions, current.index, current.answer) then
			v4()
		else
			v2({ type = "next" })
		end
	end, { v4 })

	local retry = React.useCallback(function()
		if ref3.current.errorType == "submit" then
			v4()
		else
			v3()
		end
	end, { v4, v3 })

	local setAnswer = React.useCallback(function(answer)
		v2({ type = "setAnswer", answer = answer })
	end, {})

	local v5 = React.useCallback(function()
		if ref2.current then
			return
		end

		local current = ref3.current
		local surveyId = current.surveyId

		if surveyId == nil or current.phase == Phase.Completed then
			return
		end

		local idempotencyKey = current.idempotencyKey or HttpService:GenerateGUID(false)
		local submitPayload = inlineSurveyHelpers.buildSubmitPayload(
			surveyId,
			current.questions,
			current.answersByQuestionId,
			idempotencyKey,
			{ finished = false }
		)

		if #submitPayload.answers == 0 then
			return
		end

		inlineSurveyApi.submitSurveyResponse(networkImpl, submitPayload):catch(function(p)
			warn("Inline survey partial submit failed:", p)
		end)
	end, { networkImpl })

	local dismiss = React.useCallback(function()
		if FFlagInlineSurveyEnhancements then
			releaseKeyboardFocus() -- inferred equivalent call
		end

		if FFlagInlineSurveyPartialResponse then
			v5()
		end

		ref.current += 1
		ref2.current = false
		v2({ type = "dismissed" })
	end, FFlagInlineSurveyPartialResponse and { v5 } or {})

	local acceptInvite = React.useCallback(function()
		v2({ type = "inviteAccepted" })
	end, {})

	local declineInvite = React.useCallback(function()
		ref.current += 1
		ref2.current = false
		v2({ type = "inviteDeclined" })
	end, {})

	React.useEffect(function()
		v3()
		return function()
			ref.current += 1
		end
	end, { v3 })

	React.useEffect(function()
		if v.phase == Phase.Completed and ref5.current then
			ref5.current()
		elseif v.phase == Phase.Closed and ref4.current then
			ref4.current()
		elseif (v.phase == Phase.Started or v.phase == Phase.Invite) and not ref7.current and ref6.current then
			ref7.current = true
			ref6.current()
		end
	end, { v.phase })

	return {
		state = v,
		setAnswer = setAnswer,
		submit = submit,
		retry = retry,
		dismiss = dismiss,
		acceptInvite = acceptInvite,
		declineInvite = declineInvite
	}
end

return useInlineSurveyFlow
