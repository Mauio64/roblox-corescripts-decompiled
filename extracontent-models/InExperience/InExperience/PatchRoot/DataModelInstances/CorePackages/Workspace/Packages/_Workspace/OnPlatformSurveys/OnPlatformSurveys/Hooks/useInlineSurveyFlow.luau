local OnPlatformSurveys = script:FindFirstAncestor("OnPlatformSurveys")
local OnPlatformSurveysParent = OnPlatformSurveys.Parent
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local React = require(OnPlatformSurveysParent.React)
local SharedFlags = require(OnPlatformSurveysParent.SharedFlags)
local FFlagInlineSurveyEnhancements = SharedFlags.FFlagInlineSurveyEnhancements
local FFlagInlineSurveyBranching = SharedFlags.FFlagInlineSurveyBranching
local FFlagInlineSurveyPartialResponse = SharedFlags.FFlagInlineSurveyPartialResponse
local inlineSurveyHelpers = require(OnPlatformSurveys.Utils.inlineSurveyHelpers)
local inlineSurveyApi = require(OnPlatformSurveys.Api.inlineSurveyApi)
local Phase = require(OnPlatformSurveys.Enums.Phase)
local inlineSurveyReducer = require(OnPlatformSurveys.Hooks.inlineSurveyReducer)

require(OnPlatformSurveys.Types.InlineSurveyTypes)

local function releaseKeyboardFocus() -- line: 46
	-- upvalues: UserInputService (copy)
	local FocusedTextBox = UserInputService:GetFocusedTextBox()

	if FocusedTextBox ~= nil then
		FocusedTextBox:ReleaseFocus()
	end
end
local function useInlineSurveyFlow(t1: {[any]: any}) -- line: 53
	-- upvalues: React (copy), inlineSurveyReducer (copy), inlineSurveyApi (copy), inlineSurveyHelpers (copy), FFlagInlineSurveyBranching (copy), HttpService (copy), FFlagInlineSurveyEnhancements (copy), UserInputService (copy), Phase (copy), FFlagInlineSurveyPartialResponse (copy)
	local networkImpl = t1.networkImpl
	local eventType = t1.eventType
	local v20, v21 = React.useReducer(inlineSurveyReducer.reducer, t1.hasInvite == true, inlineSurveyReducer.getInitialState)
	local v22 = React.useRef(0)
	local v23 = React.useRef(false)
	local v24 = React.useRef(v20)

	v24.current = v20

	local v25 = React.useRef(t1.onClose)

	v25.current = t1.onClose

	local v26 = React.useRef(t1.onComplete)

	v26.current = t1.onComplete

	local v27 = React.useRef(t1.onEligible)

	v27.current = t1.onEligible

	local v28 = React.useRef(false)
	local v29 = React.useCallback(function() -- line: 75
		-- upvalues: v22 (copy), v23 (copy), v28 (copy), v21 (copy), inlineSurveyApi (copy), networkImpl (copy), eventType (copy)
		local v38 = v22.current + 1

		v22.current = v38
		v23.current = false
		v28.current = false
		v21({
			type = "fetchRequested"
		})
		inlineSurveyApi.fetchInlineSurvey(networkImpl, eventType):andThen(function(p1) -- line: 82
			-- upvalues: v22 (copy), v38 (copy), v21 (copy)
			if v22.current ~= v38 then
				return
			end

			v21({
				type = "questionsReceived",
				response = p1
			})
		end):catch(function(p2) -- line: 88
			-- upvalues: v22 (copy), v38 (copy), v21 (copy)
			if v22.current ~= v38 then
				return
			end

			warn("Inline survey fetch failed:", p2)
			v21({
				type = "fetchFailed"
			})
		end)
	end, {
		networkImpl,
		eventType
	})
	local v30 = React.useCallback(function() -- line: 97
		-- upvalues: v24 (copy), v23 (copy), inlineSurveyHelpers (copy), FFlagInlineSurveyBranching (copy), HttpService (copy), v21 (copy), v22 (copy), inlineSurveyApi (copy), networkImpl (copy)
		local current = v24.current

		if v23.current then
			return
		end

		local v40 = current.questions[current.index]
		local surveyId = current.surveyId

		if v40 == nil or surveyId == nil then
			return
		end

		local v42 = inlineSurveyHelpers.mergeCurrentAnswerIntoBatch(current.answersByQuestionId, v40, current.answer)
		local v43 = if not FFlagInlineSurveyBranching then current.questions else inlineSurveyHelpers.getVisitedQuestions(current.questions, v42)

		if not inlineSurveyHelpers.canSubmitAll(v43, v42) then
			return
		end

		local v44 = current.idempotencyKey or HttpService:GenerateGUID(false)
		local v45 = inlineSurveyHelpers.buildSubmitPayload(surveyId, v43, v42, v44)

		if #v45.answers == 0 then
			v21({
				type = "submitSucceeded"
			})

			return
		end

		local v46 = v22.current + 1

		v22.current = v46
		v23.current = true
		v21({
			type = "submitStarted",
			idempotencyKey = v44
		})
		inlineSurveyApi.submitSurveyResponse(networkImpl, v45):andThen(function(_) -- line: 131
			-- upvalues: v22 (copy), v46 (copy), v23 (copy), v21 (copy)
			if v22.current ~= v46 then
				return
			end

			v23.current = false
			v21({
				type = "submitSucceeded"
			})
		end):catch(function(p4) -- line: 138
			-- upvalues: v22 (copy), v46 (copy), v23 (copy), v21 (copy)
			if v22.current ~= v46 then
				return
			end

			v23.current = false
			warn("Inline survey submit failed:", p4)
			v21({
				type = "submitFailed"
			})
		end)
	end, { networkImpl })
	local v31 = React.useCallback(function() -- line: 149
		-- upvalues: v24 (copy), v23 (copy), FFlagInlineSurveyEnhancements (copy), v30 (copy), inlineSurveyHelpers (copy), UserInputService (copy), v21 (copy)
		local current = v24.current

		if current.questions[current.index] == nil or v23.current then
			return
		end

		if not FFlagInlineSurveyEnhancements then
			v30()

			return
		end

		if not inlineSurveyHelpers.canAdvance(current.questions, current.index, current.answersByQuestionId, current.answer) then
			return
		end

		local FocusedTextBox = UserInputService:GetFocusedTextBox()

		if FocusedTextBox ~= nil then
			FocusedTextBox:ReleaseFocus()
		end

		if inlineSurveyHelpers.isLastQuestion(current.questions, current.index, current.answer) then
			v30()

			return
		end

		v21({
			type = "next"
		})
	end, { v30 })
	local v32 = React.useCallback(function() -- line: 174
		-- upvalues: v24 (copy), v30 (copy), v29 (copy)
		if v24.current.errorType == "submit" then
			v30()

			return
		end

		v29()
	end, {
		v30,
		v29
	})
	local v33 = React.useCallback(function(p5) -- line: 182
		-- upvalues: v21 (copy)
		v21({
			type = "setAnswer",
			answer = p5
		})
	end, {})
	local v34 = React.useCallback(function() -- line: 187
		-- upvalues: v23 (copy), v24 (copy), Phase (copy), HttpService (copy), inlineSurveyHelpers (copy), inlineSurveyApi (copy), networkImpl (copy)
		if v23.current then
			return
		end

		local current = v24.current
		local surveyId = current.surveyId

		if surveyId == nil or current.phase == Phase.Completed then
			return
		end

		local v52 = current.idempotencyKey or HttpService:GenerateGUID(false)
		local v53 = inlineSurveyHelpers.buildSubmitPayload(surveyId, current.questions, current.answersByQuestionId, v52, {
			finished = false
		})

		if #v53.answers == 0 then
			return
		end

		inlineSurveyApi.submitSurveyResponse(networkImpl, v53):catch(function(p6) -- line: 207
			warn("Inline survey partial submit failed:", p6)
		end)
	end, { networkImpl })
	local v35 = React.useCallback(function() -- line: 212
		-- upvalues: FFlagInlineSurveyEnhancements (copy), UserInputService (copy), FFlagInlineSurveyPartialResponse (copy), v34 (copy), v22 (copy), v23 (copy), v21 (copy)
		if FFlagInlineSurveyEnhancements then
			local FocusedTextBox = UserInputService:GetFocusedTextBox()

			if FocusedTextBox ~= nil then
				FocusedTextBox:ReleaseFocus()
			end
		end

		if FFlagInlineSurveyPartialResponse then
			v34()
		end

		local v55 = v22

		v55.current = v55.current + 1
		v23.current = false
		v21({
			type = "dismissed"
		})
	end, if not FFlagInlineSurveyPartialResponse then {} else { v34 })
	local v36 = React.useCallback(function() -- line: 224
		-- upvalues: v21 (copy)
		v21({
			type = "inviteAccepted"
		})
	end, {})
	local v37 = React.useCallback(function() -- line: 228
		-- upvalues: v22 (copy), v23 (copy), v21 (copy)
		local v56 = v22

		v56.current = v56.current + 1
		v23.current = false
		v21({
			type = "inviteDeclined"
		})
	end, {})

	React.useEffect(function() -- line: 235
		-- upvalues: v29 (copy), v22 (copy)
		v29()

		return function() -- line: 237
			-- upvalues: v22 (copy)
			local v62 = v22

			v62.current = v62.current + 1
		end
	end, { v29 })
	React.useEffect(function() -- line: 242
		-- upvalues: v20 (copy), Phase (copy), v26 (copy), v25 (copy), v28 (copy), v27 (copy)
		if v20.phase == Phase.Completed and v26.current then
			v26.current()

			return
		end

		if v20.phase == Phase.Closed and v25.current then
			v25.current()

			return
		end

		if (v20.phase == Phase.Started or v20.phase == Phase.Invite) and not v28.current and v27.current then
			v28.current = true
			v27.current()
		end
	end, { v20.phase })

	return {
		state = v20,
		setAnswer = v33,
		submit = v31,
		retry = v32,
		dismiss = v35,
		acceptInvite = v36,
		declineInvite = v37
	}
end

return useInlineSurveyFlow
