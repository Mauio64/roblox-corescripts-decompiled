local Parent = script:FindFirstAncestor("BuildExperience").Parent
local CreatorAgentChat = require(Parent.DataHydration.CreatorAgentChat)

require(script.Parent.chatTypes)

local chatConstants = require(script.Parent.chatConstants)

require(script.Parent.localToolOverlay)

local toolControllerUtils = require(script.Parent.toolControllerUtils)
local StudioAskUserTool = CreatorAgentChat.StudioAskUserTool
local debug = CreatorAgentChat.debug
local awaitRequestState = toolControllerUtils.awaitRequestState
local getToolCallOrder = toolControllerUtils.getToolCallOrder

local function getSelectedOptionId(t1: {[any]: any}?) -- line: 57
	if t1 == nil then
		return nil
	end

	if t1.options ~= nil then
		local t2 = {}

		for _, v18 in t1.options do
			table.insert(t2, v18.id)
		end

		return t2
	end

	if t1.option ~= nil then
		return t1.option.id
	end

	return nil
end
local function makeAnswerStackPrompt(t3: {[any]: any}, t4: {[any]: any}?) -- line: 74
	-- upvalues: getSelectedOptionId (copy)
	return {
		question = t3.questions[t3.currentIndex],
		selectedOptionId = getSelectedOptionId(t4),
		customResponseText = if t4 == nil then nil else t4.customResponseText,
		toolCallId = t3.toolCallId,
		callOrder = t3.callOrder,
		isLastQuestion = t3.currentIndex >= #t3.questions
	}
end
local function buildOptimisticAskUserTool(t5: {[any]: any}) -- line: 85
	-- upvalues: getSelectedOptionId (copy)
	local t6 = {}

	for v23, v24 in t5.selections do
		t6[v23] = {
			selectedOptionId = getSelectedOptionId(v24),
			customResponseText = v24.customResponseText
		}
	end

	return {
		toolCallId = t5.toolCallId,
		callOrder = t5.callOrder,
		currentIndex = t5.currentIndex,
		selections = t6
	}
end
local function toggleOptionInSelection(t7: {[any]: any}?, p1) -- line: 101
	local t8 = {}
	local v28 = false

	for _, v30 in if t7 == nil or t7.options == nil then {} else t7.options do
		if v30.id == p1.id then
			v28 = true
		else
			table.insert(t8, v30)
		end
	end

	if not v28 then
		table.insert(t8, p1)
	end

	return {
		option = nil,
		customResponseText = nil,
		options = t8
	}
end
local function createAnswerStackSync(p2: ((...any) -> ...any), p3: ((...any) -> ...any), p4: ((...any) -> ...any)) -- line: 124
	-- upvalues: StudioAskUserTool (copy), debug (copy), getToolCallOrder (copy)
	local u34 = nil
	local u35 = nil
	local u36 = false

	return function(p5) -- line: 133
		-- upvalues: StudioAskUserTool (copy), p4 (copy), u36 (ref), debug (copy), u34 (ref), u35 (ref), p2 (copy), p3 (copy), getToolCallOrder (copy)
		local v58, v59, _, v61, v62 = StudioAskUserTool.findQuestionsInTurnState(p5, p4())

		if v58 == nil or v59 == nil then
			if u36 then
				debug.log("info", "studio_ask_user answer stack cleared", {
					turn = debug.formatTurnState(p5)
				})
				u36 = false
				u34 = nil
				u35 = nil
				p2(nil)
				p3(nil)
			end

			return false
		end

		u36 = true

		if p5.sessionId ~= u34 or v59 ~= u35 then
			u34 = p5.sessionId
			u35 = v59

			local t9 = {
				currentIndex = 1,
				submitted = false,
				sessionId = p5.sessionId,
				toolCallId = v59,
				callOrder = getToolCallOrder(p5, v59),
				turnId = v61,
				referenceId = v62,
				questions = v58,
				selections = {}
			}

			p3(t9)
			p2({
				customResponseText = nil,
				question = t9.questions[t9.currentIndex],
				selectedOptionId = nil,
				toolCallId = t9.toolCallId,
				callOrder = t9.callOrder,
				isLastQuestion = t9.currentIndex >= #t9.questions
			})
			debug.log("info", "studio_ask_user answer stack displayed", {
				toolCallId = v59,
				turnId = v61,
				referenceId = v62,
				questions = debug.formatStudioAskUserQuestions(v58),
				turn = debug.formatTurnState(p5)
			})
		end

		return true
	end
end
local function createAskUserController(p6, t10: {[any]: any}, p7) -- line: 179
	-- upvalues: buildOptimisticAskUserTool (copy), StudioAskUserTool (copy), debug (copy), getToolCallOrder (copy), awaitRequestState (copy), chatConstants (copy), toggleOptionInSelection (copy)
	local u40 = nil
	local u41 = nil
	local u42 = nil

	local function setAnswerFlow(t11: {[any]: any}?) -- line: 188
		-- upvalues: u40 (ref)
		u40 = t11
	end
	local function setCurrentAnswerStackPrompt(p8) -- line: 192
		-- upvalues: u40 (ref), p7 (copy), buildOptimisticAskUserTool (copy), u41 (ref), u42 (ref)
		local v66 = u40

		if p8 == nil then
			if v66 ~= nil then
				p7.removeAskUserTool(v66.toolCallId)
				p7.removeAnswerAction(v66.toolCallId)
			end

			return
		end

		if v66 ~= nil then
			p7.setAskUserTool((buildOptimisticAskUserTool(v66)))
			p7.setAnswerAction(v66.toolCallId, u41, u42)
		end
	end
	local function getSubmittedToolCallIds() -- line: 207
		-- upvalues: t10 (copy)
		return t10
	end

	local u46 = nil
	local u47 = nil
	local u48 = false

	local function v49(p9) -- line: 133
		-- upvalues: StudioAskUserTool (copy), getSubmittedToolCallIds (copy), u48 (ref), debug (copy), u46 (ref), u47 (ref), setCurrentAnswerStackPrompt (copy), setAnswerFlow (copy), getToolCallOrder (copy)
		local v68, v69, _, v71, v72 = StudioAskUserTool.findQuestionsInTurnState(p9, getSubmittedToolCallIds())

		if v68 == nil or v69 == nil then
			if u48 then
				debug.log("info", "studio_ask_user answer stack cleared", {
					turn = debug.formatTurnState(p9)
				})
				u48 = false
				u46 = nil
				u47 = nil
				setCurrentAnswerStackPrompt(nil)
				setAnswerFlow(nil)
			end

			return false
		end

		u48 = true

		if p9.sessionId ~= u46 or v69 ~= u47 then
			u46 = p9.sessionId
			u47 = v69

			local t12 = {
				currentIndex = 1,
				submitted = false,
				sessionId = p9.sessionId,
				toolCallId = v69,
				callOrder = getToolCallOrder(p9, v69),
				turnId = v71,
				referenceId = v72,
				questions = v68,
				selections = {}
			}

			setAnswerFlow(t12)
			setCurrentAnswerStackPrompt({
				customResponseText = nil,
				question = t12.questions[t12.currentIndex],
				selectedOptionId = nil,
				toolCallId = t12.toolCallId,
				callOrder = t12.callOrder,
				isLastQuestion = t12.currentIndex >= #t12.questions
			})
			debug.log("info", "studio_ask_user answer stack displayed", {
				toolCallId = v69,
				turnId = v71,
				referenceId = v72,
				questions = debug.formatStudioAskUserQuestions(v68),
				turn = debug.formatTurnState(p9)
			})
		end

		return true
	end

	local u50 = false

	local function submitAskUserResponses(t13: {[any]: any}) -- line: 214
		-- upvalues: StudioAskUserTool (copy), debug (copy), p6 (copy), awaitRequestState (copy), chatConstants (copy), t10 (copy), p7 (copy), u40 (ref)
		local t14 = {}

		for v76, v77 in t13.questions do
			local v78 = t13.selections[v76]

			if v78 == nil then
				return
			end

			table.insert(t14, {
				question = v77,
				option = v78.option,
				options = v78.options,
				customResponseText = v78.customResponseText
			})
		end

		local v79 = StudioAskUserTool.formatToolResultContent(t14)

		debug.log("info", "studio_ask_user tool_result submitting", {
			sessionId = t13.sessionId,
			toolCallId = t13.toolCallId,
			turnId = t13.turnId,
			referenceId = t13.referenceId,
			questionCount = #t13.questions
		})

		local elapsed = os.clock()
		local v81 = p6.submitActiveToolResult(v79, false, t13.turnId, t13.referenceId)

		if v81 == nil then
			debug.log("warn", "studio_ask_user tool_result submit aborted (no active session)", {
				toolCallId = t13.toolCallId
			})
			t13.submitted = false

			return
		end

		local v82 = awaitRequestState(v81.state, os.clock() + chatConstants.CAS_RPC_TIMEOUT_SECONDS)
		local v83 = math.floor((os.clock() - elapsed) * 1000 + 0.5)

		if v82.status ~= "succeeded" then
			t13.submitted = false
			debug.log("warn", "studio_ask_user tool_result submit failed", {
				sessionId = t13.sessionId,
				toolCallId = t13.toolCallId,
				turnId = t13.turnId,
				referenceId = t13.referenceId,
				durationMs = v83,
				state = debug.formatRequestState(v82)
			})

			return
		end

		debug.log("info", "studio_ask_user tool_result submitted", {
			sessionId = t13.sessionId,
			toolCallId = t13.toolCallId,
			turnId = t13.turnId,
			referenceId = t13.referenceId,
			questionCount = #t13.questions,
			durationMs = v83
		})
		t10[t13.toolCallId] = true
		p7.markSubmitted(t13.toolCallId)
		p7.removeAnswerAction(t13.toolCallId)
		u40 = nil
	end
	local function submitAskUserCancellation(t15: {[any]: any}) -- line: 277
		-- upvalues: StudioAskUserTool (copy), t10 (copy), p7 (copy), u40 (ref), p6 (copy), debug (copy), awaitRequestState (copy), chatConstants (copy)
		local v85 = StudioAskUserTool.formatCancellationContent()

		t10[t15.toolCallId] = true
		p7.markSubmitted(t15.toolCallId)
		p7.removeAnswerAction(t15.toolCallId)

		local v86 = u40

		if v86 ~= nil then
			p7.removeAskUserTool(v86.toolCallId)
			p7.removeAnswerAction(v86.toolCallId)
		end

		u40 = nil

		local v87 = p6.submitActiveToolResult(v85, false, t15.turnId, t15.referenceId)

		if v87 == nil then
			debug.log("warn", "studio_ask_user cancel aborted (no active session)", {
				toolCallId = t15.toolCallId
			})

			return
		end

		awaitRequestState(v87.state, os.clock() + chatConstants.CAS_RPC_TIMEOUT_SECONDS)
	end
	local function advanceToNextQuestion(t16: {[any]: any}) -- line: 296
		-- upvalues: p7 (copy), buildOptimisticAskUserTool (copy)
		if t16.currentIndex >= #t16.questions then
			return false
		end

		t16.currentIndex = t16.currentIndex + 1
		p7.setAskUserTool((buildOptimisticAskUserTool(t16)))

		return true
	end
	local function commitCurrentSelectionAndAdvance(t17: {[any]: any}) -- line: 306
		-- upvalues: p7 (copy), buildOptimisticAskUserTool (copy), submitAskUserResponses (copy)
		local v90

		if t17.currentIndex >= #t17.questions then
			v90 = false
		else
			t17.currentIndex = t17.currentIndex + 1
			p7.setAskUserTool((buildOptimisticAskUserTool(t17)))
			v90 = true
		end

		if v90 then
			return
		end

		t17.submitted = true
		task.spawn(function() -- line: 312
			-- upvalues: submitAskUserResponses (copy), t17 (copy)
			submitAskUserResponses(t17)
		end)
	end
	local function onAnswerSelectedImpl(p10, p11) -- line: 317
		-- upvalues: u40 (ref), toggleOptionInSelection (copy), p7 (copy), buildOptimisticAskUserTool (copy), debug (copy), submitAskUserResponses (copy)
		local v93 = u40

		if v93 == nil or v93.submitted then
			return
		end

		local v94 = v93.questions[v93.currentIndex]

		if v94 == nil or v94.id ~= p10.id then
			return
		end

		if v94.responseType == "multi_select" then
			v93.selections[v93.currentIndex] = toggleOptionInSelection(v93.selections[v93.currentIndex], p11)
			p7.setAskUserTool((buildOptimisticAskUserTool(v93)))
			debug.log("info", "studio_ask_user multi-select toggled", {
				toolCallId = v93.toolCallId,
				questionId = p10.id,
				questionIndex = v93.currentIndex,
				optionId = p11.id,
				optionTitle = p11.title
			})

			return
		end

		debug.log("info", "studio_ask_user answer selected", {
			toolCallId = v93.toolCallId,
			questionId = p10.id,
			questionIndex = v93.currentIndex,
			optionId = p11.id,
			optionTitle = p11.title
		})
		v93.selections[v93.currentIndex] = {
			options = nil,
			customResponseText = nil,
			option = p11
		}
		p7.setAskUserTool((buildOptimisticAskUserTool(v93)))

		local v95

		if v93.currentIndex >= #v93.questions then
			v95 = false
		else
			v93.currentIndex = v93.currentIndex + 1
			p7.setAskUserTool((buildOptimisticAskUserTool(v93)))
			v95 = true
		end

		if v95 then
			return
		end

		v93.submitted = true
		task.spawn(function() -- line: 312
			-- upvalues: submitAskUserResponses (copy), v93 (copy)
			submitAskUserResponses(v93)
		end)
	end

	u41 = onAnswerSelectedImpl

	local function onAnswerConfirmedImpl() -- line: 360
		-- upvalues: u40 (ref), debug (copy), p7 (copy), buildOptimisticAskUserTool (copy), submitAskUserResponses (copy)
		local v96 = u40

		if v96 == nil or v96.submitted then
			return
		end

		local v97 = v96.questions[v96.currentIndex]

		if v97 == nil or v97.responseType ~= "multi_select" then
			return
		end

		local v98 = v96.selections[v96.currentIndex]
		local v99 = if v98 == nil then nil else v98.options

		if v99 == nil or #v99 == 0 then
			return
		end

		debug.log("info", "studio_ask_user multi-select confirmed", {
			toolCallId = v96.toolCallId,
			questionId = v97.id,
			questionIndex = v96.currentIndex,
			selectedCount = #v99
		})

		local v100

		if v96.currentIndex >= #v96.questions then
			v100 = false
		else
			v96.currentIndex = v96.currentIndex + 1
			p7.setAskUserTool((buildOptimisticAskUserTool(v96)))
			v100 = true
		end

		if v100 then
			return
		end

		v96.submitted = true
		task.spawn(function() -- line: 312
			-- upvalues: submitAskUserResponses (copy), v96 (copy)
			submitAskUserResponses(v96)
		end)
	end

	u42 = onAnswerConfirmedImpl

	return {
		syncAnswerStack = function(p12) -- line: 423
			-- upvalues: v49 (copy), u50 (ref)
			if v49(p12) then
				u50 = true

				return true
			end

			return false
		end,
		getSubmittedToolCallIds = getSubmittedToolCallIds,
		hasDisplayedAnswerStack = function() -- line: 446
			-- upvalues: u50 (ref)
			return u50
		end,
		stopPendingAnswer = function() -- line: 431
			-- upvalues: u40 (ref), submitAskUserCancellation (copy)
			local v106 = u40

			if v106 == nil or v106.submitted then
				return false
			end

			v106.submitted = true
			task.spawn(function() -- line: 437
				-- upvalues: submitAskUserCancellation (copy), v106 (copy)
				submitAskUserCancellation(v106)
			end)

			return true
		end,
		trySubmitComposerText = function(s1: string) -- line: 387
			-- upvalues: u40 (ref), debug (copy), p7 (copy), buildOptimisticAskUserTool (copy), submitAskUserResponses (copy)
			local v102 = u40

			if v102 == nil or v102.submitted then
				return false
			end

			local v103 = v102.questions[v102.currentIndex]

			if v103 == nil then
				return false
			end

			if v103.responseType == "multi_select" then
				return false
			end

			debug.log("info", "studio_ask_user custom answer submitted", {
				toolCallId = v102.toolCallId,
				questionId = v103.id,
				questionIndex = v102.currentIndex
			})
			v102.selections[v102.currentIndex] = {
				option = nil,
				options = nil,
				customResponseText = s1
			}
			p7.setAskUserTool((buildOptimisticAskUserTool(v102)))

			local v104

			if v102.currentIndex >= #v102.questions then
				v104 = false
			else
				v102.currentIndex = v102.currentIndex + 1
				p7.setAskUserTool((buildOptimisticAskUserTool(v102)))
				v104 = true
			end

			if v104 then
				return true
			end

			v102.submitted = true
			task.spawn(function() -- line: 417
				-- upvalues: submitAskUserResponses (copy), v102 (copy)
				submitAskUserResponses(v102)
			end)

			return true
		end
	}
end

return createAskUserController
