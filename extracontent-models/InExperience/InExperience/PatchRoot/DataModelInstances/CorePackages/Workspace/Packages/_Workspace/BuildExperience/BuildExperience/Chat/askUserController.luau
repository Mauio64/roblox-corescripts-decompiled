local Parent = script:FindFirstAncestor("BuildExperience").Parent
local CreatorAgentChat = require(Parent.DataHydration.CreatorAgentChat)

require(script.Parent.chatTypes)

local chatConstants = require(script.Parent.chatConstants)
local composerLockSignal = require(script.Parent.composerLockSignal)

require(script.Parent.localToolOverlay)

local toolControllerUtils = require(script.Parent.toolControllerUtils)
local StudioAskUserTool = CreatorAgentChat.StudioAskUserTool
local debug = CreatorAgentChat.debug
local awaitRequestState = toolControllerUtils.awaitRequestState
local getToolCallOrder = toolControllerUtils.getToolCallOrder

local function getSelectedOptionId(t1: {[any]: any}?) -- line: 58
	if t1 == nil then
		return nil
	end

	if t1.options ~= nil then
		local t2 = {}

		for _, v19 in t1.options do
			table.insert(t2, v19.id)
		end

		return t2
	end

	if t1.option ~= nil then
		return t1.option.id
	end

	return nil
end
local function makeAnswerStackPrompt(t3: {[any]: any}, t4: {[any]: any}?) -- line: 75
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
local function buildOptimisticAskUserTool(t5: {[any]: any}) -- line: 86
	-- upvalues: getSelectedOptionId (copy)
	local t6 = {}

	for v24, v25 in t5.selections do
		t6[v24] = {
			selectedOptionId = getSelectedOptionId(v25),
			customResponseText = v25.customResponseText
		}
	end

	return {
		toolCallId = t5.toolCallId,
		callOrder = t5.callOrder,
		currentIndex = t5.currentIndex,
		selections = t6
	}
end
local function toggleOptionInSelection(t7: {[any]: any}?, p1) -- line: 102
	local t8 = {}
	local v29 = false

	for _, v31 in if t7 == nil or t7.options == nil then {} else t7.options do
		if v31.id == p1.id then
			v29 = true
		else
			table.insert(t8, v31)
		end
	end

	if not v29 then
		table.insert(t8, p1)
	end

	return {
		option = nil,
		customResponseText = nil,
		options = t8
	}
end
local function createAnswerStackSync(p2: ((...any) -> ...any), p3: ((...any) -> ...any), p4: ((...any) -> ...any)) -- line: 125
	-- upvalues: StudioAskUserTool (copy), debug (copy), composerLockSignal (copy), getToolCallOrder (copy)
	local u35 = nil
	local u36 = nil
	local u37 = false

	return function(p5) -- line: 134
		-- upvalues: StudioAskUserTool (copy), p4 (copy), u37 (ref), debug (copy), u35 (ref), u36 (ref), p3 (copy), composerLockSignal (copy), getToolCallOrder (copy), p2 (copy)
		local v59, v60, v61, v62, v63 = StudioAskUserTool.findQuestionsInTurnState(p5, p4())

		if v59 == nil or v60 == nil then
			if u37 then
				debug.log("info", "studio_ask_user answer stack cleared", {
					turn = debug.formatTurnState(p5)
				})
				u37 = false
				u35 = nil
				u36 = nil
				p3(nil)
				composerLockSignal.setComposerMode("normal")
			end

			return false
		end

		u37 = true

		if v60 ~= u35 or v61 ~= u36 then
			u35 = v60
			u36 = v61

			local t9 = {
				currentIndex = 1,
				submitted = false,
				sessionId = p5.sessionId,
				toolCallId = v60,
				callOrder = getToolCallOrder(p5, v60),
				turnId = v62,
				referenceId = v63,
				questions = v59,
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
			composerLockSignal.setComposerMode("tool_response")
			debug.log("info", "studio_ask_user answer stack displayed", {
				toolCallId = v60,
				turnId = v62,
				referenceId = v63,
				questions = debug.formatStudioAskUserQuestions(v59),
				turn = debug.formatTurnState(p5)
			})
		end

		return true
	end
end
local function createAskUserController(p6, t10: {[any]: any}, p7) -- line: 181
	-- upvalues: buildOptimisticAskUserTool (copy), StudioAskUserTool (copy), debug (copy), composerLockSignal (copy), getToolCallOrder (copy), awaitRequestState (copy), chatConstants (copy), toggleOptionInSelection (copy)
	local u41 = nil
	local u42 = nil
	local u43 = nil

	local function setAnswerFlow(t11: {[any]: any}?) -- line: 190
		-- upvalues: u41 (ref)
		u41 = t11
	end
	local function setCurrentAnswerStackPrompt(p8) -- line: 194
		-- upvalues: u41 (ref), p7 (copy), buildOptimisticAskUserTool (copy), u42 (ref), u43 (ref)
		local v67 = u41

		if p8 == nil then
			if v67 ~= nil then
				p7.removeAskUserTool(v67.toolCallId)
				p7.removeAnswerAction(v67.toolCallId)
			end

			return
		end

		if v67 ~= nil then
			p7.setAskUserTool((buildOptimisticAskUserTool(v67)))
			p7.setAnswerAction(v67.toolCallId, u42, u43)
		end
	end
	local function getSubmittedToolCallIds() -- line: 209
		-- upvalues: t10 (copy)
		return t10
	end

	local u47 = nil
	local u48 = nil
	local u49 = false

	local function v50(p9) -- line: 134
		-- upvalues: StudioAskUserTool (copy), getSubmittedToolCallIds (copy), u49 (ref), debug (copy), u47 (ref), u48 (ref), setAnswerFlow (copy), composerLockSignal (copy), getToolCallOrder (copy), setCurrentAnswerStackPrompt (copy)
		local v69, v70, v71, v72, v73 = StudioAskUserTool.findQuestionsInTurnState(p9, getSubmittedToolCallIds())

		if v69 == nil or v70 == nil then
			if u49 then
				debug.log("info", "studio_ask_user answer stack cleared", {
					turn = debug.formatTurnState(p9)
				})
				u49 = false
				u47 = nil
				u48 = nil
				setAnswerFlow(nil)
				composerLockSignal.setComposerMode("normal")
			end

			return false
		end

		u49 = true

		if v70 ~= u47 or v71 ~= u48 then
			u47 = v70
			u48 = v71

			local t12 = {
				currentIndex = 1,
				submitted = false,
				sessionId = p9.sessionId,
				toolCallId = v70,
				callOrder = getToolCallOrder(p9, v70),
				turnId = v72,
				referenceId = v73,
				questions = v69,
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
			composerLockSignal.setComposerMode("tool_response")
			debug.log("info", "studio_ask_user answer stack displayed", {
				toolCallId = v70,
				turnId = v72,
				referenceId = v73,
				questions = debug.formatStudioAskUserQuestions(v69),
				turn = debug.formatTurnState(p9)
			})
		end

		return true
	end

	local u51 = false

	local function submitAskUserResponses(t13: {[any]: any}) -- line: 216
		-- upvalues: StudioAskUserTool (copy), debug (copy), p6 (copy), awaitRequestState (copy), chatConstants (copy), t10 (copy), p7 (copy), u41 (ref), composerLockSignal (copy)
		local t14 = {}

		for v77, v78 in t13.questions do
			local v79 = t13.selections[v77]

			if v79 == nil then
				return
			end

			table.insert(t14, {
				question = v78,
				option = v79.option,
				options = v79.options,
				customResponseText = v79.customResponseText
			})
		end

		local v80 = StudioAskUserTool.formatToolResultContent(t14)

		debug.log("info", "studio_ask_user tool_result submitting", {
			sessionId = t13.sessionId,
			toolCallId = t13.toolCallId,
			turnId = t13.turnId,
			referenceId = t13.referenceId,
			questionCount = #t13.questions
		})

		local elapsed = os.clock()
		local v82 = p6.submitActiveToolResult(v80, false, t13.turnId, t13.referenceId)

		if v82 == nil then
			debug.log("warn", "studio_ask_user tool_result submit aborted (no active session)", {
				toolCallId = t13.toolCallId
			})
			t13.submitted = false

			return
		end

		local v83 = awaitRequestState(v82.state, os.clock() + chatConstants.CAS_RPC_TIMEOUT_SECONDS)
		local v84 = math.floor((os.clock() - elapsed) * 1000 + 0.5)

		if v83.status ~= "succeeded" then
			t13.submitted = false
			debug.log("warn", "studio_ask_user tool_result submit failed", {
				sessionId = t13.sessionId,
				toolCallId = t13.toolCallId,
				turnId = t13.turnId,
				referenceId = t13.referenceId,
				durationMs = v84,
				state = debug.formatRequestState(v83)
			})

			return
		end

		debug.log("info", "studio_ask_user tool_result submitted", {
			sessionId = t13.sessionId,
			toolCallId = t13.toolCallId,
			turnId = t13.turnId,
			referenceId = t13.referenceId,
			questionCount = #t13.questions,
			durationMs = v84
		})
		t10[t13.toolCallId] = true
		p7.markSubmitted(t13.toolCallId)
		p7.removeAnswerAction(t13.toolCallId)
		u41 = nil
		composerLockSignal.setComposerMode("normal")
	end
	local function submitAskUserCancellation(t15: {[any]: any}) -- line: 280
		-- upvalues: StudioAskUserTool (copy), t10 (copy), p7 (copy), u41 (ref), composerLockSignal (copy), p6 (copy), debug (copy), awaitRequestState (copy), chatConstants (copy)
		local v86 = StudioAskUserTool.formatCancellationContent()

		t10[t15.toolCallId] = true
		p7.markSubmitted(t15.toolCallId)
		p7.removeAnswerAction(t15.toolCallId)

		local v87 = u41

		if v87 ~= nil then
			p7.removeAskUserTool(v87.toolCallId)
			p7.removeAnswerAction(v87.toolCallId)
		end

		u41 = nil
		composerLockSignal.setComposerMode("normal")

		local v88 = p6.submitActiveToolResult(v86, false, t15.turnId, t15.referenceId)

		if v88 == nil then
			debug.log("warn", "studio_ask_user cancel aborted (no active session)", {
				toolCallId = t15.toolCallId
			})

			return
		end

		awaitRequestState(v88.state, os.clock() + chatConstants.CAS_RPC_TIMEOUT_SECONDS)
	end
	local function advanceToNextQuestion(t16: {[any]: any}) -- line: 300
		-- upvalues: p7 (copy), buildOptimisticAskUserTool (copy)
		if t16.currentIndex >= #t16.questions then
			return false
		end

		t16.currentIndex = t16.currentIndex + 1
		p7.setAskUserTool((buildOptimisticAskUserTool(t16)))

		return true
	end
	local function commitCurrentSelectionAndAdvance(t17: {[any]: any}) -- line: 310
		-- upvalues: p7 (copy), buildOptimisticAskUserTool (copy), submitAskUserResponses (copy)
		local v91

		if t17.currentIndex >= #t17.questions then
			v91 = false
		else
			t17.currentIndex = t17.currentIndex + 1
			p7.setAskUserTool((buildOptimisticAskUserTool(t17)))
			v91 = true
		end

		if v91 then
			return
		end

		t17.submitted = true
		task.spawn(function() -- line: 316
			-- upvalues: submitAskUserResponses (copy), t17 (copy)
			submitAskUserResponses(t17)
		end)
	end
	local function onAnswerSelectedImpl(p10, p11) -- line: 321
		-- upvalues: u41 (ref), toggleOptionInSelection (copy), p7 (copy), buildOptimisticAskUserTool (copy), debug (copy), submitAskUserResponses (copy)
		local v94 = u41

		if v94 == nil or v94.submitted then
			return
		end

		local v95 = v94.questions[v94.currentIndex]

		if v95 == nil or v95.id ~= p10.id then
			return
		end

		if v95.responseType == "multi_select" then
			v94.selections[v94.currentIndex] = toggleOptionInSelection(v94.selections[v94.currentIndex], p11)
			p7.setAskUserTool((buildOptimisticAskUserTool(v94)))
			debug.log("info", "studio_ask_user multi-select toggled", {
				toolCallId = v94.toolCallId,
				questionId = p10.id,
				questionIndex = v94.currentIndex,
				optionId = p11.id,
				optionTitle = p11.title
			})

			return
		end

		debug.log("info", "studio_ask_user answer selected", {
			toolCallId = v94.toolCallId,
			questionId = p10.id,
			questionIndex = v94.currentIndex,
			optionId = p11.id,
			optionTitle = p11.title
		})
		v94.selections[v94.currentIndex] = {
			options = nil,
			customResponseText = nil,
			option = p11
		}
		p7.setAskUserTool((buildOptimisticAskUserTool(v94)))

		local v96

		if v94.currentIndex >= #v94.questions then
			v96 = false
		else
			v94.currentIndex = v94.currentIndex + 1
			p7.setAskUserTool((buildOptimisticAskUserTool(v94)))
			v96 = true
		end

		if v96 then
			return
		end

		v94.submitted = true
		task.spawn(function() -- line: 316
			-- upvalues: submitAskUserResponses (copy), v94 (copy)
			submitAskUserResponses(v94)
		end)
	end

	u42 = onAnswerSelectedImpl

	local function onAnswerConfirmedImpl() -- line: 364
		-- upvalues: u41 (ref), debug (copy), p7 (copy), buildOptimisticAskUserTool (copy), submitAskUserResponses (copy)
		local v97 = u41

		if v97 == nil or v97.submitted then
			return
		end

		local v98 = v97.questions[v97.currentIndex]

		if v98 == nil or v98.responseType ~= "multi_select" then
			return
		end

		local v99 = v97.selections[v97.currentIndex]
		local v100 = if v99 == nil then nil else v99.options

		if v100 == nil or #v100 == 0 then
			return
		end

		debug.log("info", "studio_ask_user multi-select confirmed", {
			toolCallId = v97.toolCallId,
			questionId = v98.id,
			questionIndex = v97.currentIndex,
			selectedCount = #v100
		})

		local v101

		if v97.currentIndex >= #v97.questions then
			v101 = false
		else
			v97.currentIndex = v97.currentIndex + 1
			p7.setAskUserTool((buildOptimisticAskUserTool(v97)))
			v101 = true
		end

		if v101 then
			return
		end

		v97.submitted = true
		task.spawn(function() -- line: 316
			-- upvalues: submitAskUserResponses (copy), v97 (copy)
			submitAskUserResponses(v97)
		end)
	end

	u43 = onAnswerConfirmedImpl

	return {
		syncAnswerStack = function(p12) -- line: 427
			-- upvalues: v50 (copy), u51 (ref)
			if v50(p12) then
				u51 = true

				return true
			end

			return false
		end,
		getSubmittedToolCallIds = getSubmittedToolCallIds,
		hasDisplayedAnswerStack = function() -- line: 450
			-- upvalues: u51 (ref)
			return u51
		end,
		stopPendingAnswer = function() -- line: 435
			-- upvalues: u41 (ref), submitAskUserCancellation (copy)
			local v107 = u41

			if v107 == nil or v107.submitted then
				return false
			end

			v107.submitted = true
			task.spawn(function() -- line: 441
				-- upvalues: submitAskUserCancellation (copy), v107 (copy)
				submitAskUserCancellation(v107)
			end)

			return true
		end,
		trySubmitComposerText = function(s1: string) -- line: 391
			-- upvalues: u41 (ref), debug (copy), p7 (copy), buildOptimisticAskUserTool (copy), submitAskUserResponses (copy)
			local v103 = u41

			if v103 == nil or v103.submitted then
				return false
			end

			local v104 = v103.questions[v103.currentIndex]

			if v104 == nil then
				return false
			end

			if v104.responseType == "multi_select" then
				return false
			end

			debug.log("info", "studio_ask_user custom answer submitted", {
				toolCallId = v103.toolCallId,
				questionId = v104.id,
				questionIndex = v103.currentIndex
			})
			v103.selections[v103.currentIndex] = {
				option = nil,
				options = nil,
				customResponseText = s1
			}
			p7.setAskUserTool((buildOptimisticAskUserTool(v103)))

			local v105

			if v103.currentIndex >= #v103.questions then
				v105 = false
			else
				v103.currentIndex = v103.currentIndex + 1
				p7.setAskUserTool((buildOptimisticAskUserTool(v103)))
				v105 = true
			end

			if v105 then
				return true
			end

			v103.submitted = true
			task.spawn(function() -- line: 421
				-- upvalues: submitAskUserResponses (copy), v103 (copy)
				submitAskUserResponses(v103)
			end)

			return true
		end
	}
end

return createAskUserController
