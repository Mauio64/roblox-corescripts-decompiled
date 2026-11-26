local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/OnPlatformSurveys/React")

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/OnPlatformSurveys/SharedFlags")
local fFlagInlineSurveyEnhancements = SharedFlags.FFlagInlineSurveyEnhancements
local fFlagInlineSurveyBranching = SharedFlags.FFlagInlineSurveyBranching
local fFlagInlineSurveyPartialResponse = SharedFlags.FFlagInlineSurveyPartialResponse

local inlineSurveyHelpers = require("@game/CorePackages/Workspace/Packages/_Workspace/OnPlatformSurveys/OnPlatformSurveys/Utils/inlineSurveyHelpers")
local inlineSurveyApi = require("@game/CorePackages/Workspace/Packages/_Workspace/OnPlatformSurveys/OnPlatformSurveys/Api/inlineSurveyApi")
local Phase = require("@game/CorePackages/Workspace/Packages/_Workspace/OnPlatformSurveys/OnPlatformSurveys/Enums/Phase")
local inlineSurveyReducer = require("@game/CorePackages/Workspace/Packages/_Workspace/OnPlatformSurveys/OnPlatformSurveys/Hooks/inlineSurveyReducer")
require("@game/CorePackages/Workspace/Packages/_Workspace/OnPlatformSurveys/OnPlatformSurveys/Types/InlineSurveyTypes")

local function releaseKeyboardFocus()
	local focusedTextBox = UserInputService:GetFocusedTextBox()

	if focusedTextBox ~= nil then
		focusedTextBox:ReleaseFocus()
	end
end

local function useInlineSurveyFlow(data)
	local networkImpl = data.networkImpl
	local eventType = data.eventType

	local v5, v6 = React.useReducer(inlineSurveyReducer.reducer, data.hasInvite == true, inlineSurveyReducer.getInitialState)

	local ref = React.useRef(0)

	local ref2 = React.useRef(false)

	local ref3 = React.useRef(v5)
	ref3.current = v5
	local ref4 = React.useRef(data.onClose)
	ref4.current = data.onClose
	local ref5 = React.useRef(data.onComplete)
	ref5.current = data.onComplete
	local ref6 = React.useRef(data.onEligible)
	ref6.current = data.onEligible
	local ref7 = React.useRef(false)

	local v7 = React.useCallback(function()
		local v8 = ref.current + 1
		ref.current = v8
		ref2.current = false
		ref7.current = false
		v6({ type = "fetchRequested" })
		inlineSurveyApi.fetchInlineSurvey(networkImpl, eventType):andThen(function(p2)
			if ref.current ~= v8 then
				return
			end

			v6({ type = "questionsReceived", response = p2 })
		end):catch(function(p2)
			if ref.current ~= v8 then
				return
			end

			warn("Inline survey fetch failed:", p2)
			v6({ type = "fetchFailed" })
		end)
	end, { networkImpl, eventType })

	local v8 = React.useCallback(function()
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
		local v9

		if fFlagInlineSurveyBranching then
			v9 = inlineSurveyHelpers.getVisitedQuestions(current.questions, mergeCurrentAnswerIntoBatch)
		else
			v9 = current.questions
		end

		if not inlineSurveyHelpers.canSubmitAll(v9, mergeCurrentAnswerIntoBatch) then
			return
		end

		local idempotencyKey = current.idempotencyKey or HttpService:GenerateGUID(false)
		local submitPayload = inlineSurveyHelpers.buildSubmitPayload(
			surveyId,
			v9,
			mergeCurrentAnswerIntoBatch,
			idempotencyKey
		)

		if #submitPayload.answers == 0 then
			v6({ type = "submitSucceeded" })
			return
		end

		local v10 = ref.current + 1
		ref.current = v10
		ref2.current = true
		v6({ type = "submitStarted", idempotencyKey = idempotencyKey })
		inlineSurveyApi.submitSurveyResponse(networkImpl, submitPayload):andThen(function(p2)
			if ref.current ~= v10 then
				return
			end

			ref2.current = false
			v6({ type = "submitSucceeded" })
		end):catch(function(p2)
			if ref.current ~= v10 then
				return
			end

			ref2.current = false
			warn("Inline survey submit failed:", p2)
			v6({ type = "submitFailed" })
		end)
	end, { networkImpl })

	local v9 = React.useCallback(function()
		local current = ref3.current

		if current.questions[current.index] == nil or ref2.current then
			return
		end

		if not fFlagInlineSurveyEnhancements then
			v8()
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

		local focusedTextBox = UserInputService:GetFocusedTextBox()

		if focusedTextBox ~= nil then
			focusedTextBox:ReleaseFocus()
		end

		if inlineSurveyHelpers.isLastQuestion(current.questions, current.index, current.answer) then
			v8()
		else
			v6({ type = "next" })
		end
	end, { v8 })

	local v10 = React.useCallback(function()
		if ref3.current.errorType == "submit" then
			v8()
		else
			v7()
		end
	end, { v8, v7 })

	local v11 = React.useCallback(function(p2)
		v6({ type = "setAnswer", answer = p2 })
	end, {})

	local v12 = React.useCallback(function()
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

		inlineSurveyApi.submitSurveyResponse(networkImpl, submitPayload):catch(function(p2)
			warn("Inline survey partial submit failed:", p2)
		end)
	end, { networkImpl })

	local v13 = React.useCallback(function()
		if fFlagInlineSurveyEnhancements then
			local focusedTextBox = UserInputService:GetFocusedTextBox()

			if focusedTextBox ~= nil then
				focusedTextBox:ReleaseFocus()
			end
		end

		if fFlagInlineSurveyPartialResponse then
			v12()
		end

		ref.current += 1
		ref2.current = false
		v6({ type = "dismissed" })
	end, fFlagInlineSurveyPartialResponse and { v12 } or {})

	local v14 = React.useCallback(function()
		v6({ type = "inviteAccepted" })
	end, {})

	local v15 = React.useCallback(function()
		ref.current += 1
		ref2.current = false
		v6({ type = "inviteDeclined" })
	end, {})

	React.useEffect(function()
		v7()
		return function()
			ref.current += 1
		end
	end, { v7 })

	React.useEffect(function()
		if v5.phase == Phase.Completed and ref5.current then
			ref5.current()
		elseif v5.phase == Phase.Closed and ref4.current then
			ref4.current()
		elseif
			(v5.phase == Phase.Started or v5.phase == Phase.Invite)
			and not ref7.current
			and ref6.current
		then
			ref7.current = true
			ref6.current()
		end
	end, { v5.phase })

	return {
		state = v5,
		setAnswer = v11,
		submit = v9,
		retry = v10,
		dismiss = v13,
		acceptInvite = v14,
		declineInvite = v15
	}
end

return useInlineSurveyFlow
