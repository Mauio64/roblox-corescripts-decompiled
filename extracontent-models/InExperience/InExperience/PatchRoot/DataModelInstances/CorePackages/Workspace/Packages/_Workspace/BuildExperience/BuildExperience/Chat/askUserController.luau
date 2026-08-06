local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local CreatorAgentChat = require(BuildExperienceParent.DataHydration.CreatorAgentChat)
local FFlagBuildExperienceToolResultFailureRecovery = require(BuildExperience.Flags.FFlagBuildExperienceToolResultFailureRecovery)

require(script.Parent.chatTypes)

local chatConstants = require(script.Parent.chatConstants)

require(script.Parent.localToolOverlay)

local toolControllerUtils = require(script.Parent.toolControllerUtils)
local StudioAskUserTool = CreatorAgentChat.StudioAskUserTool
local debug = CreatorAgentChat.debug
local awaitRequestState = toolControllerUtils.awaitRequestState
local getToolCallOrder = toolControllerUtils.getToolCallOrder

local function getSelectedOptionId(t1: {[any]: any}?) -- line: 59
	if t1 == nil then
		return nil
	end

	if t1.options ~= nil then
		local t2 = {}

		for _, v20 in t1.options do
			table.insert(t2, v20.id)
		end

		return t2
	end

	if t1.option ~= nil then
		return t1.option.id
	end

	return nil
end
local function makeAnswerStackPrompt(t3: {[any]: any}, t4: {[any]: any}?) -- line: 76
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
local function buildOptimisticAskUserTool(t5: {[any]: any}) -- line: 87
	-- upvalues: getSelectedOptionId (copy)
	local t6 = {}

	for v25, v26 in t5.selections do
		t6[v25] = {
			selectedOptionId = getSelectedOptionId(v26),
			customResponseText = v26.customResponseText
		}
	end

	return {
		toolCallId = t5.toolCallId,
		callOrder = t5.callOrder,
		currentIndex = t5.currentIndex,
		selections = t6
	}
end
local function toggleOptionInSelection(t7: {[any]: any}?, p1) -- line: 103
	local t8 = {}
	local v30 = false

	for _, v32 in if t7 == nil or t7.options == nil then {} else t7.options do
		if v32.id == p1.id then
			v30 = true
		else
			table.insert(t8, v32)
		end
	end

	if not v30 then
		table.insert(t8, p1)
	end

	return {
		option = nil,
		customResponseText = nil,
		options = t8
	}
end
local function createAnswerStackSync(p2: ((...any) -> ...any), p3: ((...any) -> ...any), p4: ((...any) -> ...any)) -- line: 126
	-- upvalues: StudioAskUserTool (copy), debug (copy), getToolCallOrder (copy)
	local u36 = nil
	local u37 = nil
	local u38 = false

	return function(p5) -- line: 135
		-- upvalues: StudioAskUserTool (copy), p4 (copy), u38 (ref), debug (copy), u36 (ref), u37 (ref), p2 (copy), p3 (copy), getToolCallOrder (copy)
		local v62, v63, _, v65, v66 = StudioAskUserTool.findQuestionsInTurnState(p5, p4())

		if v62 == nil or v63 == nil then
			if u38 then
				debug.log("info", "studio_ask_user answer stack cleared", {
					turn = debug.formatTurnState(p5)
				})
				u38 = false
				u36 = nil
				u37 = nil
				p2(nil)
				p3(nil)
			end

			return false
		end

		u38 = true

		if p5.sessionId ~= u36 or v63 ~= u37 then
			u36 = p5.sessionId
			u37 = v63

			local t9 = {
				currentIndex = 1,
				submitted = false,
				sessionId = p5.sessionId,
				toolCallId = v63,
				callOrder = getToolCallOrder(p5, v63),
				turnId = v65,
				referenceId = v66,
				questions = v62,
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
				toolCallId = v63,
				turnId = v65,
				referenceId = v66,
				questions = debug.formatStudioAskUserQuestions(v62),
				turn = debug.formatTurnState(p5)
			})
		end

		return true
	end
end
local function createAskUserController(p6, t10: {[any]: any}, p7, p8) -- line: 181
	-- upvalues: buildOptimisticAskUserTool (copy), StudioAskUserTool (copy), debug (copy), getToolCallOrder (copy), FFlagBuildExperienceToolResultFailureRecovery (copy), awaitRequestState (copy), chatConstants (copy), toggleOptionInSelection (copy)
	local u43 = nil
	local u44 = nil
	local u45 = nil

	local function setAnswerFlow(t11: {[any]: any}?) -- line: 191
		-- upvalues: u43 (ref)
		u43 = t11
	end
	local function setCurrentAnswerStackPrompt(p9) -- line: 195
		-- upvalues: u43 (ref), p7 (copy), buildOptimisticAskUserTool (copy), u44 (ref), u45 (ref)
		local v70 = u43

		if p9 == nil then
			if v70 ~= nil then
				p7.removeAskUserTool(v70.toolCallId)
				p7.removeAnswerAction(v70.toolCallId)
			end

			return
		end

		if v70 ~= nil then
			p7.setAskUserTool((buildOptimisticAskUserTool(v70)))
			p7.setAnswerAction(v70.toolCallId, u44, u45)
		end
	end
	local function getSubmittedToolCallIds() -- line: 210
		-- upvalues: t10 (copy)
		return t10
	end
	local function recoverFailedSubmission(t12: {[any]: any}, n1: number?) -- line: 214
		-- upvalues: p8 (copy), p7 (copy), buildOptimisticAskUserTool (copy)
		t12.submitted = false

		if p8 == nil then
			return
		end

		local v73 = t12.selections[t12.currentIndex]
		local v74 = if v73 == nil then nil else v73.customResponseText

		t12.selections[t12.currentIndex] = nil
		p7.setAskUserTool((buildOptimisticAskUserTool(t12)))
		p8(v74, n1)
	end

	local u50 = nil
	local u51 = nil
	local u52 = false

	local function v53(p10) -- line: 135
		-- upvalues: StudioAskUserTool (copy), getSubmittedToolCallIds (copy), u52 (ref), debug (copy), u50 (ref), u51 (ref), setCurrentAnswerStackPrompt (copy), setAnswerFlow (copy), getToolCallOrder (copy)
		local v76, v77, _, v79, v80 = StudioAskUserTool.findQuestionsInTurnState(p10, getSubmittedToolCallIds())

		if v76 == nil or v77 == nil then
			if u52 then
				debug.log("info", "studio_ask_user answer stack cleared", {
					turn = debug.formatTurnState(p10)
				})
				u52 = false
				u50 = nil
				u51 = nil
				setCurrentAnswerStackPrompt(nil)
				setAnswerFlow(nil)
			end

			return false
		end

		u52 = true

		if p10.sessionId ~= u50 or v77 ~= u51 then
			u50 = p10.sessionId
			u51 = v77

			local t13 = {
				currentIndex = 1,
				submitted = false,
				sessionId = p10.sessionId,
				toolCallId = v77,
				callOrder = getToolCallOrder(p10, v77),
				turnId = v79,
				referenceId = v80,
				questions = v76,
				selections = {}
			}

			setAnswerFlow(t13)
			setCurrentAnswerStackPrompt({
				customResponseText = nil,
				question = t13.questions[t13.currentIndex],
				selectedOptionId = nil,
				toolCallId = t13.toolCallId,
				callOrder = t13.callOrder,
				isLastQuestion = t13.currentIndex >= #t13.questions
			})
			debug.log("info", "studio_ask_user answer stack displayed", {
				toolCallId = v77,
				turnId = v79,
				referenceId = v80,
				questions = debug.formatStudioAskUserQuestions(v76),
				turn = debug.formatTurnState(p10)
			})
		end

		return true
	end

	local u54 = false

	local function submitAskUserResponses(t14: {[any]: any}) -- line: 231
		-- upvalues: StudioAskUserTool (copy), debug (copy), p6 (copy), FFlagBuildExperienceToolResultFailureRecovery (copy), p8 (copy), p7 (copy), buildOptimisticAskUserTool (copy), awaitRequestState (copy), chatConstants (copy), t10 (copy), u43 (ref)
		local t15 = {}

		for v84, v85 in t14.questions do
			local v86 = t14.selections[v84]

			if v86 == nil then
				return
			end

			table.insert(t15, {
				question = v85,
				option = v86.option,
				options = v86.options,
				customResponseText = v86.customResponseText
			})
		end

		local v87 = StudioAskUserTool.formatToolResultContent(t15)

		debug.log("info", "studio_ask_user tool_result submitting", {
			sessionId = t14.sessionId,
			toolCallId = t14.toolCallId,
			turnId = t14.turnId,
			referenceId = t14.referenceId,
			questionCount = #t14.questions
		})

		local elapsed = os.clock()
		local v89 = p6.submitActiveToolResult(v87, false, t14.turnId, t14.referenceId)

		if v89 == nil then
			debug.log("warn", "studio_ask_user tool_result submit aborted (no active session)", {
				toolCallId = t14.toolCallId
			})

			if FFlagBuildExperienceToolResultFailureRecovery then
				t14.submitted = false

				if p8 == nil then
					return
				end

				local v90 = t14.selections[t14.currentIndex]
				local v91 = if v90 == nil then nil else v90.customResponseText

				t14.selections[t14.currentIndex] = nil
				p7.setAskUserTool((buildOptimisticAskUserTool(t14)))
				p8(v91, nil)

				return
			end

			t14.submitted = false

			return
		end

		local v92 = awaitRequestState(v89.state, os.clock() + chatConstants.CAS_RPC_TIMEOUT_SECONDS)
		local v93 = math.floor((os.clock() - elapsed) * 1000 + 0.5)

		if v92.status ~= "succeeded" then
			if FFlagBuildExperienceToolResultFailureRecovery then
				local errorCode = v92.errorCode

				t14.submitted = false

				if p8 ~= nil then
					local v95 = t14.selections[t14.currentIndex]
					local v96 = if v95 == nil then nil else v95.customResponseText

					t14.selections[t14.currentIndex] = nil
					p7.setAskUserTool((buildOptimisticAskUserTool(t14)))
					p8(v96, errorCode)
				end
			else
				t14.submitted = false
			end

			debug.log("warn", "studio_ask_user tool_result submit failed", {
				sessionId = t14.sessionId,
				toolCallId = t14.toolCallId,
				turnId = t14.turnId,
				referenceId = t14.referenceId,
				durationMs = v93,
				state = debug.formatRequestState(v92)
			})

			return
		end

		debug.log("info", "studio_ask_user tool_result submitted", {
			sessionId = t14.sessionId,
			toolCallId = t14.toolCallId,
			turnId = t14.turnId,
			referenceId = t14.referenceId,
			questionCount = #t14.questions,
			durationMs = v93
		})
		t10[t14.toolCallId] = true
		p7.markSubmitted(t14.toolCallId)
		p7.removeAnswerAction(t14.toolCallId)
		u43 = nil
	end
	local function submitAskUserCancellation(t16: {[any]: any}) -- line: 302
		-- upvalues: StudioAskUserTool (copy), t10 (copy), p7 (copy), u43 (ref), p6 (copy), debug (copy), awaitRequestState (copy), chatConstants (copy)
		local v98 = StudioAskUserTool.formatCancellationContent()

		t10[t16.toolCallId] = true
		p7.markSubmitted(t16.toolCallId)
		p7.removeAnswerAction(t16.toolCallId)

		local v99 = u43

		if v99 ~= nil then
			p7.removeAskUserTool(v99.toolCallId)
			p7.removeAnswerAction(v99.toolCallId)
		end

		u43 = nil

		local v100 = p6.submitActiveToolResult(v98, false, t16.turnId, t16.referenceId)

		if v100 == nil then
			debug.log("warn", "studio_ask_user cancel aborted (no active session)", {
				toolCallId = t16.toolCallId
			})

			return
		end

		awaitRequestState(v100.state, os.clock() + chatConstants.CAS_RPC_TIMEOUT_SECONDS)
	end
	local function advanceToNextQuestion(t17: {[any]: any}) -- line: 321
		-- upvalues: p7 (copy), buildOptimisticAskUserTool (copy)
		if t17.currentIndex >= #t17.questions then
			return false
		end

		t17.currentIndex = t17.currentIndex + 1
		p7.setAskUserTool((buildOptimisticAskUserTool(t17)))

		return true
	end
	local function commitCurrentSelectionAndAdvance(t18: {[any]: any}) -- line: 331
		-- upvalues: p7 (copy), buildOptimisticAskUserTool (copy), submitAskUserResponses (copy)
		local v103

		if t18.currentIndex >= #t18.questions then
			v103 = false
		else
			t18.currentIndex = t18.currentIndex + 1
			p7.setAskUserTool((buildOptimisticAskUserTool(t18)))
			v103 = true
		end

		if v103 then
			return
		end

		t18.submitted = true
		task.spawn(function() -- line: 337
			-- upvalues: submitAskUserResponses (copy), t18 (copy)
			submitAskUserResponses(t18)
		end)
	end
	local function onAnswerSelectedImpl(p11, p12) -- line: 342
		-- upvalues: u43 (ref), toggleOptionInSelection (copy), p7 (copy), buildOptimisticAskUserTool (copy), debug (copy), submitAskUserResponses (copy)
		local v106 = u43

		if v106 == nil or v106.submitted then
			return
		end

		local v107 = v106.questions[v106.currentIndex]

		if v107 == nil or v107.id ~= p11.id then
			return
		end

		if v107.responseType == "multi_select" then
			v106.selections[v106.currentIndex] = toggleOptionInSelection(v106.selections[v106.currentIndex], p12)
			p7.setAskUserTool((buildOptimisticAskUserTool(v106)))
			debug.log("info", "studio_ask_user multi-select toggled", {
				toolCallId = v106.toolCallId,
				questionId = p11.id,
				questionIndex = v106.currentIndex,
				optionId = p12.id,
				optionTitle = p12.title
			})

			return
		end

		debug.log("info", "studio_ask_user answer selected", {
			toolCallId = v106.toolCallId,
			questionId = p11.id,
			questionIndex = v106.currentIndex,
			optionId = p12.id,
			optionTitle = p12.title
		})
		v106.selections[v106.currentIndex] = {
			options = nil,
			customResponseText = nil,
			option = p12
		}
		p7.setAskUserTool((buildOptimisticAskUserTool(v106)))

		local v108

		if v106.currentIndex >= #v106.questions then
			v108 = false
		else
			v106.currentIndex = v106.currentIndex + 1
			p7.setAskUserTool((buildOptimisticAskUserTool(v106)))
			v108 = true
		end

		if v108 then
			return
		end

		v106.submitted = true
		task.spawn(function() -- line: 337
			-- upvalues: submitAskUserResponses (copy), v106 (copy)
			submitAskUserResponses(v106)
		end)
	end

	u44 = onAnswerSelectedImpl

	local function onAnswerConfirmedImpl() -- line: 385
		-- upvalues: u43 (ref), debug (copy), p7 (copy), buildOptimisticAskUserTool (copy), submitAskUserResponses (copy)
		local v109 = u43

		if v109 == nil or v109.submitted then
			return
		end

		local v110 = v109.questions[v109.currentIndex]

		if v110 == nil or v110.responseType ~= "multi_select" then
			return
		end

		local v111 = v109.selections[v109.currentIndex]
		local v112 = if v111 == nil then nil else v111.options

		if v112 == nil or #v112 == 0 then
			return
		end

		debug.log("info", "studio_ask_user multi-select confirmed", {
			toolCallId = v109.toolCallId,
			questionId = v110.id,
			questionIndex = v109.currentIndex,
			selectedCount = #v112
		})

		local v113

		if v109.currentIndex >= #v109.questions then
			v113 = false
		else
			v109.currentIndex = v109.currentIndex + 1
			p7.setAskUserTool((buildOptimisticAskUserTool(v109)))
			v113 = true
		end

		if v113 then
			return
		end

		v109.submitted = true
		task.spawn(function() -- line: 337
			-- upvalues: submitAskUserResponses (copy), v109 (copy)
			submitAskUserResponses(v109)
		end)
	end

	u45 = onAnswerConfirmedImpl

	return {
		syncAnswerStack = function(p13) -- line: 448
			-- upvalues: v53 (copy), u54 (ref)
			if v53(p13) then
				u54 = true

				return true
			end

			return false
		end,
		getSubmittedToolCallIds = getSubmittedToolCallIds,
		hasDisplayedAnswerStack = function() -- line: 471
			-- upvalues: u54 (ref)
			return u54
		end,
		stopPendingAnswer = function() -- line: 456
			-- upvalues: u43 (ref), submitAskUserCancellation (copy)
			local v119 = u43

			if v119 == nil or v119.submitted then
				return false
			end

			v119.submitted = true
			task.spawn(function() -- line: 462
				-- upvalues: submitAskUserCancellation (copy), v119 (copy)
				submitAskUserCancellation(v119)
			end)

			return true
		end,
		trySubmitComposerText = function(s1: string) -- line: 412
			-- upvalues: u43 (ref), debug (copy), p7 (copy), buildOptimisticAskUserTool (copy), submitAskUserResponses (copy)
			local v115 = u43

			if v115 == nil or v115.submitted then
				return false
			end

			local v116 = v115.questions[v115.currentIndex]

			if v116 == nil then
				return false
			end

			if v116.responseType == "multi_select" then
				return false
			end

			debug.log("info", "studio_ask_user custom answer submitted", {
				toolCallId = v115.toolCallId,
				questionId = v116.id,
				questionIndex = v115.currentIndex
			})
			v115.selections[v115.currentIndex] = {
				option = nil,
				options = nil,
				customResponseText = s1
			}
			p7.setAskUserTool((buildOptimisticAskUserTool(v115)))

			local v117

			if v115.currentIndex >= #v115.questions then
				v117 = false
			else
				v115.currentIndex = v115.currentIndex + 1
				p7.setAskUserTool((buildOptimisticAskUserTool(v115)))
				v117 = true
			end

			if v117 then
				return true
			end

			v115.submitted = true
			task.spawn(function() -- line: 442
				-- upvalues: submitAskUserResponses (copy), v115 (copy)
				submitAskUserResponses(v115)
			end)

			return true
		end
	}
end

return createAskUserController
