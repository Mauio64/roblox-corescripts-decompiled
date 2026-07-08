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

local function makeAnswerStackPrompt(t1: {[any]: any}, t2: {[any]: any}?) -- line: 57
	local v16 = if t2 == nil or t2.option == nil then nil else t2.option.id
	local v17 = if t2 == nil then nil else t2.customResponseText

	return {
		question = t1.questions[t1.currentIndex],
		selectedOptionId = v16,
		customResponseText = v17,
		toolCallId = t1.toolCallId,
		callOrder = t1.callOrder
	}
end
local function buildOptimisticAskUserTool(t3: {[any]: any}) -- line: 71
	local t4 = {}

	for v20, v21 in t3.selections do
		t4[v20] = {
			selectedOptionId = if v21.option == nil then nil else v21.option.id,
			customResponseText = v21.customResponseText
		}
	end

	return {
		toolCallId = t3.toolCallId,
		callOrder = t3.callOrder,
		currentIndex = t3.currentIndex,
		selections = t4
	}
end
local function createAnswerStackSync(p1: ((...any) -> ...any), p2: ((...any) -> ...any), p3: ((...any) -> ...any)) -- line: 87
	-- upvalues: StudioAskUserTool (copy), debug (copy), composerLockSignal (copy), getToolCallOrder (copy)
	local u25 = nil
	local u26 = nil
	local u27 = false

	return function(p4) -- line: 96
		-- upvalues: StudioAskUserTool (copy), p3 (copy), u27 (ref), debug (copy), u25 (ref), u26 (ref), p2 (copy), composerLockSignal (copy), getToolCallOrder (copy), p1 (copy)
		local v46, v47, v48, v49, v50 = StudioAskUserTool.findQuestionsInTurnState(p4, p3())

		if v46 == nil or v47 == nil then
			if u27 then
				debug.log("info", "studio_ask_user answer stack cleared", {
					turn = debug.formatTurnState(p4)
				})
				u27 = false
				u25 = nil
				u26 = nil
				p2(nil)
				composerLockSignal.setComposerMode("normal")
			end

			return false
		end

		u27 = true

		if v47 ~= u25 or v48 ~= u26 then
			u25 = v47
			u26 = v48

			local t5 = {
				currentIndex = 1,
				submitted = false,
				sessionId = p4.sessionId,
				toolCallId = v47,
				callOrder = getToolCallOrder(p4, v47),
				turnId = v49,
				referenceId = v50,
				questions = v46,
				selections = {}
			}

			p2(t5)
			p1({
				selectedOptionId = nil,
				customResponseText = nil,
				question = t5.questions[t5.currentIndex],
				toolCallId = t5.toolCallId,
				callOrder = t5.callOrder
			})
			composerLockSignal.setComposerMode("tool_response")
			debug.log("info", "studio_ask_user answer stack displayed", {
				toolCallId = v47,
				turnId = v49,
				referenceId = v50,
				questions = debug.formatStudioAskUserQuestions(v46),
				turn = debug.formatTurnState(p4)
			})
		end

		return true
	end
end
local function createAskUserController(p5, t6: {[any]: any}, p6) -- line: 143
	-- upvalues: buildOptimisticAskUserTool (copy), StudioAskUserTool (copy), debug (copy), composerLockSignal (copy), getToolCallOrder (copy), awaitRequestState (copy), chatConstants (copy)
	local u31 = nil
	local u32 = nil

	local function setAnswerFlow(t7: {[any]: any}?) -- line: 151
		-- upvalues: u31 (ref)
		u31 = t7
	end
	local function setCurrentAnswerStackPrompt(p7) -- line: 155
		-- upvalues: u31 (ref), p6 (copy), buildOptimisticAskUserTool (copy), u32 (ref)
		local v54 = u31

		if p7 == nil then
			if v54 ~= nil then
				p6.removeAskUserTool(v54.toolCallId)
				p6.removeAnswerAction(v54.toolCallId)
			end

			return
		end

		if v54 ~= nil then
			p6.setAskUserTool((buildOptimisticAskUserTool(v54)))
			p6.setAnswerAction(v54.toolCallId, u32)
		end
	end
	local function getSubmittedToolCallIds() -- line: 170
		-- upvalues: t6 (copy)
		return t6
	end

	local u36 = nil
	local u37 = nil
	local u38 = false

	local function v39(p8) -- line: 96
		-- upvalues: StudioAskUserTool (copy), getSubmittedToolCallIds (copy), u38 (ref), debug (copy), u36 (ref), u37 (ref), setAnswerFlow (copy), composerLockSignal (copy), getToolCallOrder (copy), setCurrentAnswerStackPrompt (copy)
		local v56, v57, v58, v59, v60 = StudioAskUserTool.findQuestionsInTurnState(p8, getSubmittedToolCallIds())

		if v56 == nil or v57 == nil then
			if u38 then
				debug.log("info", "studio_ask_user answer stack cleared", {
					turn = debug.formatTurnState(p8)
				})
				u38 = false
				u36 = nil
				u37 = nil
				setAnswerFlow(nil)
				composerLockSignal.setComposerMode("normal")
			end

			return false
		end

		u38 = true

		if v57 ~= u36 or v58 ~= u37 then
			u36 = v57
			u37 = v58

			local t8 = {
				currentIndex = 1,
				submitted = false,
				sessionId = p8.sessionId,
				toolCallId = v57,
				callOrder = getToolCallOrder(p8, v57),
				turnId = v59,
				referenceId = v60,
				questions = v56,
				selections = {}
			}

			setAnswerFlow(t8)
			setCurrentAnswerStackPrompt({
				selectedOptionId = nil,
				customResponseText = nil,
				question = t8.questions[t8.currentIndex],
				toolCallId = t8.toolCallId,
				callOrder = t8.callOrder
			})
			composerLockSignal.setComposerMode("tool_response")
			debug.log("info", "studio_ask_user answer stack displayed", {
				toolCallId = v57,
				turnId = v59,
				referenceId = v60,
				questions = debug.formatStudioAskUserQuestions(v56),
				turn = debug.formatTurnState(p8)
			})
		end

		return true
	end

	local u40 = false

	local function submitAskUserResponses(t9: {[any]: any}) -- line: 177
		-- upvalues: StudioAskUserTool (copy), debug (copy), p5 (copy), awaitRequestState (copy), chatConstants (copy), t6 (copy), p6 (copy), u31 (ref), composerLockSignal (copy)
		local t10 = {}

		for v64, v65 in t9.questions do
			local v66 = t9.selections[v64]

			if v66 == nil then
				return
			end

			table.insert(t10, {
				question = v65,
				option = v66.option,
				customResponseText = v66.customResponseText
			})
		end

		local v67 = StudioAskUserTool.formatToolResultContent(t10)

		debug.log("info", "studio_ask_user tool_result submitting", {
			sessionId = t9.sessionId,
			toolCallId = t9.toolCallId,
			turnId = t9.turnId,
			referenceId = t9.referenceId,
			questionCount = #t9.questions
		})

		local elapsed = os.clock()
		local v69 = p5.submitActiveToolResult(v67, false, t9.turnId, t9.referenceId)

		if v69 == nil then
			debug.log("warn", "studio_ask_user tool_result submit aborted (no active session)", {
				toolCallId = t9.toolCallId
			})
			t9.submitted = false

			return
		end

		local v70 = awaitRequestState(v69.state, os.clock() + chatConstants.CAS_RPC_TIMEOUT_SECONDS)
		local v71 = math.floor((os.clock() - elapsed) * 1000 + 0.5)

		if v70.status ~= "succeeded" then
			t9.submitted = false
			debug.log("warn", "studio_ask_user tool_result submit failed", {
				sessionId = t9.sessionId,
				toolCallId = t9.toolCallId,
				turnId = t9.turnId,
				referenceId = t9.referenceId,
				durationMs = v71,
				state = debug.formatRequestState(v70)
			})

			return
		end

		debug.log("info", "studio_ask_user tool_result submitted", {
			sessionId = t9.sessionId,
			toolCallId = t9.toolCallId,
			turnId = t9.turnId,
			referenceId = t9.referenceId,
			questionCount = #t9.questions,
			durationMs = v71
		})
		t6[t9.toolCallId] = true
		p6.markSubmitted(t9.toolCallId)
		p6.removeAnswerAction(t9.toolCallId)
		u31 = nil
		composerLockSignal.setComposerMode("normal")
	end
	local function submitAskUserCancellation(t11: {[any]: any}) -- line: 240
		-- upvalues: StudioAskUserTool (copy), t6 (copy), p6 (copy), u31 (ref), composerLockSignal (copy), p5 (copy), debug (copy), awaitRequestState (copy), chatConstants (copy)
		local v73 = StudioAskUserTool.formatCancellationContent()

		t6[t11.toolCallId] = true
		p6.markSubmitted(t11.toolCallId)
		p6.removeAnswerAction(t11.toolCallId)

		local v74 = u31

		if v74 ~= nil then
			p6.removeAskUserTool(v74.toolCallId)
			p6.removeAnswerAction(v74.toolCallId)
		end

		u31 = nil
		composerLockSignal.setComposerMode("normal")

		local v75 = p5.submitActiveToolResult(v73, false, t11.turnId, t11.referenceId)

		if v75 == nil then
			debug.log("warn", "studio_ask_user cancel aborted (no active session)", {
				toolCallId = t11.toolCallId
			})

			return
		end

		awaitRequestState(v75.state, os.clock() + chatConstants.CAS_RPC_TIMEOUT_SECONDS)
	end
	local function advanceToNextQuestion(t12: {[any]: any}) -- line: 260
		-- upvalues: p6 (copy), buildOptimisticAskUserTool (copy)
		if t12.currentIndex >= #t12.questions then
			return false
		end

		t12.currentIndex = t12.currentIndex + 1
		p6.setAskUserTool((buildOptimisticAskUserTool(t12)))

		return true
	end
	local function onAnswerSelectedImpl(p9, p10) -- line: 270
		-- upvalues: u31 (ref), debug (copy), p6 (copy), buildOptimisticAskUserTool (copy), submitAskUserResponses (copy)
		local v79 = u31

		if v79 == nil or v79.submitted then
			return
		end

		local v80 = v79.questions[v79.currentIndex]

		if v80 == nil or v80.id ~= p9.id then
			return
		end

		debug.log("info", "studio_ask_user answer selected", {
			toolCallId = v79.toolCallId,
			questionId = p9.id,
			questionIndex = v79.currentIndex,
			optionId = p10.id,
			optionTitle = p10.title
		})
		v79.selections[v79.currentIndex] = {
			customResponseText = nil,
			option = p10
		}
		p6.setAskUserTool((buildOptimisticAskUserTool(v79)))

		local v81

		if v79.currentIndex >= #v79.questions then
			v81 = false
		else
			v79.currentIndex = v79.currentIndex + 1
			p6.setAskUserTool((buildOptimisticAskUserTool(v79)))
			v81 = true
		end

		if v81 then
			return
		end

		v79.submitted = true
		task.spawn(function() -- line: 299
			-- upvalues: submitAskUserResponses (copy), v79 (copy)
			submitAskUserResponses(v79)
		end)
	end

	u32 = onAnswerSelectedImpl

	return {
		syncAnswerStack = function(p11) -- line: 337
			-- upvalues: v39 (copy), u40 (ref)
			if v39(p11) then
				u40 = true

				return true
			end

			return false
		end,
		getSubmittedToolCallIds = getSubmittedToolCallIds,
		hasDisplayedAnswerStack = function() -- line: 360
			-- upvalues: u40 (ref)
			return u40
		end,
		stopPendingAnswer = function() -- line: 345
			-- upvalues: u31 (ref), submitAskUserCancellation (copy)
			local v87 = u31

			if v87 == nil or v87.submitted then
				return false
			end

			v87.submitted = true
			task.spawn(function() -- line: 351
				-- upvalues: submitAskUserCancellation (copy), v87 (copy)
				submitAskUserCancellation(v87)
			end)

			return true
		end,
		trySubmitComposerText = function(s1: string) -- line: 305
			-- upvalues: u31 (ref), debug (copy), p6 (copy), buildOptimisticAskUserTool (copy), submitAskUserResponses (copy)
			local v83 = u31

			if v83 == nil or v83.submitted then
				return false
			end

			local v84 = v83.questions[v83.currentIndex]

			if v84 == nil then
				return false
			end

			debug.log("info", "studio_ask_user custom answer submitted", {
				toolCallId = v83.toolCallId,
				questionId = v84.id,
				questionIndex = v83.currentIndex
			})
			v83.selections[v83.currentIndex] = {
				option = nil,
				customResponseText = s1
			}
			p6.setAskUserTool((buildOptimisticAskUserTool(v83)))

			local v85

			if v83.currentIndex >= #v83.questions then
				v85 = false
			else
				v83.currentIndex = v83.currentIndex + 1
				p6.setAskUserTool((buildOptimisticAskUserTool(v83)))
				v85 = true
			end

			if v85 then
				return true
			end

			v83.submitted = true
			task.spawn(function() -- line: 331
				-- upvalues: submitAskUserResponses (copy), v83 (copy)
				submitAskUserResponses(v83)
			end)

			return true
		end
	}
end

return createAskUserController
