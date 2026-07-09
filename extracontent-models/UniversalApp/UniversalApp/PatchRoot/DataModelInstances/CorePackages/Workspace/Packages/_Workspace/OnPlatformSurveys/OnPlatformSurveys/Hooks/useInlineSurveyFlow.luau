local OnPlatformSurveys = script:FindFirstAncestor("OnPlatformSurveys")
local OnPlatformSurveysParent = OnPlatformSurveys.Parent
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local React = require(OnPlatformSurveysParent.React)
local FFlagInlineSurveyEnhancements = require(OnPlatformSurveysParent.SharedFlags).FFlagInlineSurveyEnhancements
local inlineSurveyHelpers = require(OnPlatformSurveys.Utils.inlineSurveyHelpers)
local inlineSurveyApi = require(OnPlatformSurveys.Api.inlineSurveyApi)
local Phase = require(OnPlatformSurveys.Enums.Phase)
local inlineSurveyReducer = require(OnPlatformSurveys.Hooks.inlineSurveyReducer)

require(OnPlatformSurveys.Types.InlineSurveyTypes)

local function releaseKeyboardFocus() -- line: 43
	-- upvalues: UserInputService (copy)
	local FocusedTextBox = UserInputService:GetFocusedTextBox()

	if FocusedTextBox ~= nil then
		FocusedTextBox:ReleaseFocus()
	end
end
local function useInlineSurveyFlow(t1: {[any]: any}) -- line: 50
	-- upvalues: React (copy), inlineSurveyReducer (copy), inlineSurveyApi (copy), inlineSurveyHelpers (copy), HttpService (copy), FFlagInlineSurveyEnhancements (copy), UserInputService (copy), Phase (copy)
	local networkImpl = t1.networkImpl
	local eventType = t1.eventType
	local v17, v18 = React.useReducer(inlineSurveyReducer.reducer, t1.hasInvite == true, inlineSurveyReducer.getInitialState)
	local v19 = React.useRef(0)
	local v20 = React.useRef(false)
	local v21 = React.useRef(v17)

	v21.current = v17

	local v22 = React.useRef(t1.onClose)

	v22.current = t1.onClose

	local v23 = React.useRef(t1.onComplete)

	v23.current = t1.onComplete

	local v24 = React.useRef(t1.onEligible)

	v24.current = t1.onEligible

	local v25 = React.useRef(false)
	local v26 = React.useCallback(function() -- line: 72
		-- upvalues: v19 (copy), v20 (copy), v25 (copy), v18 (copy), inlineSurveyApi (copy), networkImpl (copy), eventType (copy)
		local v34 = v19.current + 1

		v19.current = v34
		v20.current = false
		v25.current = false
		v18({
			type = "fetchRequested"
		})
		inlineSurveyApi.fetchInlineSurvey(networkImpl, eventType):andThen(function(p1) -- line: 79
			-- upvalues: v19 (copy), v34 (copy), v18 (copy)
			if v19.current ~= v34 then
				return
			end

			v18({
				type = "questionsReceived",
				response = p1
			})
		end):catch(function(p2) -- line: 85
			-- upvalues: v19 (copy), v34 (copy), v18 (copy)
			if v19.current ~= v34 then
				return
			end

			warn("Inline survey fetch failed:", p2)
			v18({
				type = "fetchFailed"
			})
		end)
	end, {
		networkImpl,
		eventType
	})
	local v27 = React.useCallback(function() -- line: 94
		-- upvalues: v21 (copy), v20 (copy), inlineSurveyHelpers (copy), HttpService (copy), v18 (copy), v19 (copy), inlineSurveyApi (copy), networkImpl (copy)
		local current = v21.current

		if v20.current then
			return
		end

		local v36 = current.questions[current.index]
		local surveyId = current.surveyId

		if v36 == nil or surveyId == nil then
			return
		end

		local v38 = inlineSurveyHelpers.mergeCurrentAnswerIntoBatch(current.answersByQuestionId, v36, current.answer)

		if not inlineSurveyHelpers.canSubmitAll(current.questions, v38) then
			return
		end

		local v39 = current.idempotencyKey or HttpService:GenerateGUID(false)
		local v40 = inlineSurveyHelpers.buildSubmitPayload(surveyId, current.questions, v38, v39)

		if #v40.answers == 0 then
			v18({
				type = "submitSucceeded"
			})

			return
		end

		local v41 = v19.current + 1

		v19.current = v41
		v20.current = true
		v18({
			type = "submitStarted",
			idempotencyKey = v39
		})
		inlineSurveyApi.submitSurveyResponse(networkImpl, v40):andThen(function(_) -- line: 124
			-- upvalues: v19 (copy), v41 (copy), v20 (copy), v18 (copy)
			if v19.current ~= v41 then
				return
			end

			v20.current = false
			v18({
				type = "submitSucceeded"
			})
		end):catch(function(p4) -- line: 131
			-- upvalues: v19 (copy), v41 (copy), v20 (copy), v18 (copy)
			if v19.current ~= v41 then
				return
			end

			v20.current = false
			warn("Inline survey submit failed:", p4)
			v18({
				type = "submitFailed"
			})
		end)
	end, { networkImpl })
	local v28 = React.useCallback(function() -- line: 142
		-- upvalues: v21 (copy), v20 (copy), FFlagInlineSurveyEnhancements (copy), v27 (copy), inlineSurveyHelpers (copy), UserInputService (copy), v18 (copy)
		local current = v21.current

		if current.questions[current.index] == nil or v20.current then
			return
		end

		if not FFlagInlineSurveyEnhancements then
			v27()

			return
		end

		if not inlineSurveyHelpers.canAdvance(current.questions, current.index, current.answersByQuestionId, current.answer) then
			return
		end

		local FocusedTextBox = UserInputService:GetFocusedTextBox()

		if FocusedTextBox ~= nil then
			FocusedTextBox:ReleaseFocus()
		end

		if current.index >= #current.questions then
			v27()

			return
		end

		v18({
			type = "next"
		})
	end, { v27 })
	local v29 = React.useCallback(function() -- line: 167
		-- upvalues: v21 (copy), v27 (copy), v26 (copy)
		if v21.current.errorType == "submit" then
			v27()

			return
		end

		v26()
	end, {
		v27,
		v26
	})
	local v30 = React.useCallback(function(p5) -- line: 175
		-- upvalues: v18 (copy)
		v18({
			type = "setAnswer",
			answer = p5
		})
	end, {})
	local v31 = React.useCallback(function() -- line: 179
		-- upvalues: FFlagInlineSurveyEnhancements (copy), UserInputService (copy), v19 (copy), v20 (copy), v18 (copy)
		if FFlagInlineSurveyEnhancements then
			local FocusedTextBox = UserInputService:GetFocusedTextBox()

			if FocusedTextBox ~= nil then
				FocusedTextBox:ReleaseFocus()
			end
		end

		local v46 = v19

		v46.current = v46.current + 1
		v20.current = false
		v18({
			type = "dismissed"
		})
	end, {})
	local v32 = React.useCallback(function() -- line: 188
		-- upvalues: v18 (copy)
		v18({
			type = "inviteAccepted"
		})
	end, {})
	local v33 = React.useCallback(function() -- line: 192
		-- upvalues: v19 (copy), v20 (copy), v18 (copy)
		local v47 = v19

		v47.current = v47.current + 1
		v20.current = false
		v18({
			type = "inviteDeclined"
		})
	end, {})

	React.useEffect(function() -- line: 199
		-- upvalues: v26 (copy), v19 (copy)
		v26()

		return function() -- line: 201
			-- upvalues: v19 (copy)
			local v52 = v19

			v52.current = v52.current + 1
		end
	end, { v26 })
	React.useEffect(function() -- line: 206
		-- upvalues: v17 (copy), Phase (copy), v23 (copy), v22 (copy), v25 (copy), v24 (copy)
		if v17.phase == Phase.Completed and v23.current then
			v23.current()

			return
		end

		if v17.phase == Phase.Closed and v22.current then
			v22.current()

			return
		end

		if (v17.phase == Phase.Started or v17.phase == Phase.Invite) and not v25.current and v24.current then
			v25.current = true
			v24.current()
		end
	end, { v17.phase })

	return {
		state = v17,
		setAnswer = v30,
		submit = v28,
		retry = v29,
		dismiss = v31,
		acceptInvite = v32,
		declineInvite = v33
	}
end

return useInlineSurveyFlow
