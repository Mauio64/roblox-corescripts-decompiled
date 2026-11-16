local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local CreatorAgentChat = require(parent.DataHydration.CreatorAgentChat)

local FFlagBuildExperienceAnswerForm = require(BuildExperience.Flags.FFlagBuildExperienceAnswerForm)
local Signals

if FFlagBuildExperienceAnswerForm then
	Signals = require(parent.Signals)
else
	Signals = nil
end

require(script.Parent.chatTypes)
local chatConstants = require(script.Parent.chatConstants)
require(script.Parent.localToolOverlay)
local toolControllerUtils = require(script.Parent.toolControllerUtils)

local StudioAskUserTool = CreatorAgentChat.StudioAskUserTool
local Debug = CreatorAgentChat.debug
local awaitRequestState = toolControllerUtils.awaitRequestState
local getToolCallOrder = toolControllerUtils.getToolCallOrder

local function getSelectedOptionId(p)
	if p == nil then
		return nil
	end

	if p.options == nil then
		return if p.option ~= nil then p.option.id else nil
	else
		local ids = {}

		for _, option in p.options do
			table.insert(ids, option.id)
		end

		return ids
	end
end

local function makeAnswerStackPrompt(data, p)
	local answerStackPrompt = {
		question = data.questions[data.currentIndex],
		selectedOptionId = getSelectedOptionId(p),
		customResponseText = 0,
		toolCallId = 0,
		callOrder = 0,
		isLastQuestion = 0
	}
	local customResponseText

	if p ~= nil then
		customResponseText = p.customResponseText
	end

	answerStackPrompt.customResponseText = customResponseText
	answerStackPrompt.toolCallId = data.toolCallId
	answerStackPrompt.callOrder = data.callOrder
	answerStackPrompt.isLastQuestion = data.currentIndex >= #data.questions
	return answerStackPrompt
end

local function buildOptimisticAskUserTool(data, isSubmitting: boolean?)
	local selections = {}

	for k, selection in data.selections do
		selections[k] = {
			selectedOptionId = getSelectedOptionId(selection),
			customResponseText = selection.customResponseText
		}
	end

	if FFlagBuildExperienceAnswerForm then
		if isSubmitting == nil then
			isSubmitting = data.submitted
		end
	else
		isSubmitting = nil
	end

	return {
		toolCallId = data.toolCallId,
		callOrder = data.callOrder,
		currentIndex = data.currentIndex,
		isSubmitting = isSubmitting,
		selections = selections,
		drafts = data.drafts
	}
end

local function toggleOptionInSelection(p, p2)
	local options = {}
	local v = false

	for _, v2 in (p == nil or p.options == nil) and {} or p.options do
		if v2.id == p2.id then
			v = true
		else
			table.insert(options, v2)
		end
	end

	if not v then
		table.insert(options, p2)
	end

	return { options = options, option = nil, customResponseText = nil }
end

local function createAnswerStackSync(setCurrentAnswerStackPrompt, setAnswerFlow, getSubmittedToolCallIds) -- 1 equivalent call inferred from this helper
	local sessionId = nil
	local v = nil
	local v2 = false

	return function(p): boolean
		local questionsInTurnState, toolCallId, _, turnId, referenceId = StudioAskUserTool.findQuestionsInTurnState(
			p,
			getSubmittedToolCallIds()
		)

		if questionsInTurnState == nil or toolCallId == nil then
			if not v2 then
				return false
			end

			Debug.log("info", "ask_user answer stack cleared", { turn = Debug.formatTurnState(p) })

			v2 = false
			sessionId = nil
			v = nil
			setCurrentAnswerStackPrompt(nil)
			setAnswerFlow(nil)

			return false
		else
			v2 = true

			if p.sessionId == sessionId and toolCallId == v then
				return true
			end

			sessionId = p.sessionId
			v = toolCallId
			local v3 = {
				sessionId = p.sessionId,
				toolCallId = toolCallId,
				callOrder = getToolCallOrder(p, toolCallId),
				turnId = turnId,
				referenceId = referenceId,
				questions = questionsInTurnState,
				selections = {},
				currentIndex = 1,
				submitted = false
			}

			if FFlagBuildExperienceAnswerForm then
				local drafts = {}

				for _, question in v3.questions do
					local signal, setText = Signals.createSignal(nil)
					drafts[question.id] = { getText = signal, setText = setText }
				end

				v3.drafts = drafts
			end

			setAnswerFlow(v3)
			setCurrentAnswerStackPrompt({
				question = v3.questions[v3.currentIndex],
				selectedOptionId = nil,
				customResponseText = nil,
				toolCallId = v3.toolCallId,
				callOrder = v3.callOrder,
				isLastQuestion = v3.currentIndex >= #v3.questions
			})
			Debug.log("info", "ask_user answer stack displayed", {
				toolCallId = toolCallId,
				turnId = turnId,
				referenceId = referenceId,
				questions = Debug.formatStudioAskUserQuestions(questionsInTurnState),
				turn = Debug.formatTurnState(p)
			})

			return true
		end
	end
end

local function createAskUserController(p, submittedToolCallIds, data, callback)
	local v = nil
	local v2 = nil
	local v3 = nil

	local function setAnswerFlow(p2) -- 2 equivalent calls inferred from this helper
		if FFlagBuildExperienceAnswerForm and p2 == nil and v ~= nil then
			local drafts = v.drafts

			if drafts ~= nil then
				for _, draft in drafts do
					draft.setText(nil)
				end
			end
		end

		v = p2
	end

	local function setCurrentAnswerStackPrompt(p2)
		local v4 = v

		if p2 == nil then
			if v4 ~= nil then
				data.removeAskUserTool(v4.toolCallId)
				data.removeAnswerAction(v4.toolCallId)
			end
		elseif v4 ~= nil then
			data.setAskUserTool(buildOptimisticAskUserTool(v4))
			data.setAnswerAction(v4.toolCallId, v2, v3)
		end
	end

	local function getSubmittedToolCallIds()
		return submittedToolCallIds
	end

	local function resetFailedSubmission(p2) -- 1 equivalent call inferred from this helper
		p2.submitted = false

		if FFlagBuildExperienceAnswerForm then
			data.setAskUserTool(buildOptimisticAskUserTool(p2))
		end

		data.clearSubmitted(p2.toolCallId)
	end

	local function recoverFailedSubmission(data2, p2: number?)
		resetFailedSubmission(data2) -- inferred equivalent call

		if callback == nil then
			return
		end

		local selection = data2.selections[data2.currentIndex]
		local customResponseText

		if selection ~= nil then
			customResponseText = selection.customResponseText
		end

		data2.selections[data2.currentIndex] = nil
		data.setAskUserTool(buildOptimisticAskUserTool(data2))
		callback(customResponseText, p2)
	end

	local answerStackSync = createAnswerStackSync(setCurrentAnswerStackPrompt, setAnswerFlow, getSubmittedToolCallIds) -- inferred equivalent call
	local v4 = false

	local function submitAskUserResponses(data2)
		local v5 = {}

		for k, question in data2.questions do
			local selection = data2.selections[k]

			if selection == nil then
				return
			end

			table.insert(v5, {
				question = question,
				option = selection.option,
				options = selection.options,
				customResponseText = selection.customResponseText
			})
		end

		local formatToolResultContent = StudioAskUserTool.formatToolResultContent(v5)
		Debug.log("info", "ask_user tool_result submitting", {
			sessionId = data2.sessionId,
			toolCallId = data2.toolCallId,
			turnId = data2.turnId,
			referenceId = data2.referenceId,
			questionCount = #data2.questions
		})

		local lastTime = os.clock()
		local submitActiveToolResult = p.submitActiveToolResult(
			formatToolResultContent,
			false,
			data2.turnId,
			data2.referenceId
		)

		if submitActiveToolResult == nil then
			Debug.log("warn", "ask_user tool_result submit aborted (no active session)", {
				toolCallId = data2.toolCallId
			})

			recoverFailedSubmission(data2, nil)
		else
			local v6 = awaitRequestState(
				submitActiveToolResult.state,
				os.clock() + chatConstants.CAS_RPC_TIMEOUT_SECONDS
			)
			local durationMs = math.floor((os.clock() - lastTime) * 1000 + 0.5)

			if v6.status == "succeeded" then
				Debug.log("info", "ask_user tool_result submitted", {
					sessionId = data2.sessionId,
					toolCallId = data2.toolCallId,
					turnId = data2.turnId,
					referenceId = data2.referenceId,
					questionCount = #data2.questions,
					durationMs = durationMs
				})

				submittedToolCallIds[data2.toolCallId] = true
				data.markSubmitted(data2.toolCallId)
				data.removeAnswerAction(data2.toolCallId)

				if FFlagBuildExperienceAnswerForm then
					data.setAskUserTool(buildOptimisticAskUserTool(data2, false))
				end

				setAnswerFlow(nil) -- inferred equivalent call
			else
				recoverFailedSubmission(data2, v6.errorCode)
				Debug.log("warn", "ask_user tool_result submit failed", {
					sessionId = data2.sessionId,
					toolCallId = data2.toolCallId,
					turnId = data2.turnId,
					referenceId = data2.referenceId,
					durationMs = durationMs,
					state = Debug.formatRequestState(v6)
				})
			end
		end
	end

	local function submitAskUserCancellation(data2)
		local formatCancellationContent = StudioAskUserTool.formatCancellationContent()

		submittedToolCallIds[data2.toolCallId] = true
		data.markSubmitted(data2.toolCallId)
		data.removeAnswerAction(data2.toolCallId)
		local v5 = v

		if v5 ~= nil then
			data.removeAskUserTool(v5.toolCallId)
			data.removeAnswerAction(v5.toolCallId)
		end

		setAnswerFlow(nil) -- inferred equivalent call
		local submitActiveToolResult = p.submitActiveToolResult(
			formatCancellationContent,
			false,
			data2.turnId,
			data2.referenceId
		)

		if submitActiveToolResult == nil then
			Debug.log("warn", "ask_user cancel aborted (no active session)", {
				toolCallId = data2.toolCallId
			})
		else
			awaitRequestState(submitActiveToolResult.state, os.clock() + chatConstants.CAS_RPC_TIMEOUT_SECONDS)
		end
	end

	local function advanceToNextQuestion(state): boolean -- 2 equivalent calls inferred from this helper
		if state.currentIndex >= #state.questions then
			return false
		end

		state.currentIndex += 1
		data.setAskUserTool(buildOptimisticAskUserTool(state))
		return true
	end

	local function commitCurrentSelectionAndAdvance(state)
		if advanceToNextQuestion(state) then -- inferred equivalent call
			return
		end

		state.submitted = true

		if FFlagBuildExperienceAnswerForm then
			data.setAskUserTool(buildOptimisticAskUserTool(state))
		end

		data.markSubmitted(state.toolCallId)
		task.spawn(function()
			submitAskUserResponses(state)
		end)
	end

	local function onAnswerSelectedImpl(p2, option, flag: boolean?)
		local v5 = v

		if v5 == nil or v5.submitted then
			return
		end

		local question = v5.questions[v5.currentIndex]

		if question == nil or question.id ~= p2.id then
			return
		end

		if question.responseType == "multi_select" then
			if FFlagBuildExperienceAnswerForm and flag then
				v5.selections[v5.currentIndex] = nil
			end

			v5.selections[v5.currentIndex] = toggleOptionInSelection(v5.selections[v5.currentIndex], option)
			data.setAskUserTool(buildOptimisticAskUserTool(v5))
			Debug.log("info", "ask_user multi-select toggled", {
				toolCallId = v5.toolCallId,
				questionId = p2.id,
				questionIndex = v5.currentIndex,
				optionId = option.id,
				optionTitle = option.title
			})
		else
			Debug.log("info", "ask_user answer selected", {
				toolCallId = v5.toolCallId,
				questionId = p2.id,
				questionIndex = v5.currentIndex,
				optionId = option.id,
				optionTitle = option.title
			})

			v5.selections[v5.currentIndex] = {
				option = option,
				options = nil,
				customResponseText = nil
			}

			data.setAskUserTool(buildOptimisticAskUserTool(v5))

			commitCurrentSelectionAndAdvance(v5)
		end
	end
	v2 = onAnswerSelectedImpl

	local function onAnswerConfirmedImpl()
		local v5 = v

		if v5 == nil or v5.submitted then
			return
		end

		local question = v5.questions[v5.currentIndex]

		if question == nil or question.responseType ~= "multi_select" then
			return
		end

		local selection = v5.selections[v5.currentIndex]
		local options

		if selection ~= nil then
			options = selection.options
		end

		if options == nil or #options == 0 then
			return
		end

		Debug.log("info", "ask_user multi-select confirmed", {
			toolCallId = v5.toolCallId,
			questionId = question.id,
			questionIndex = v5.currentIndex,
			selectedCount = #options
		})

		commitCurrentSelectionAndAdvance(v5)
	end
	v3 = onAnswerConfirmedImpl

	local function submitCustomAnswer(state, question, customResponseText: string): boolean
		if not FFlagBuildExperienceAnswerForm and question.responseType == "multi_select" then
			return false
		end

		if FFlagBuildExperienceAnswerForm then
			customResponseText = string.match(customResponseText, "^%s*(.-)%s*$") or ""

			if customResponseText == "" then
				return false
			end
		end

		Debug.log("info", "ask_user custom answer submitted", {
			toolCallId = state.toolCallId,
			questionId = question.id,
			questionIndex = state.currentIndex
		})

		state.selections[state.currentIndex] = {
			option = nil,
			options = nil,
			customResponseText = customResponseText
		}

		data.setAskUserTool(buildOptimisticAskUserTool(state))

		if advanceToNextQuestion(state) then -- inferred equivalent call
			return true
		end

		state.submitted = true

		if FFlagBuildExperienceAnswerForm then
			data.setAskUserTool(buildOptimisticAskUserTool(state))
		end

		data.markSubmitted(state.toolCallId)
		task.spawn(function()
			submitAskUserResponses(state)
		end)
		return true
	end

	return {
		syncAnswerStack = function(p2): boolean
			if not answerStackSync(p2) then
				return false
			end

			v4 = true
			return true
		end,
		getSubmittedToolCallIds = getSubmittedToolCallIds,
		hasDisplayedAnswerStack = function()
			return v4
		end,
		stopPendingAnswer = function(): boolean
			local v5 = v

			if v5 == nil or v5.submitted then
				return false
			end

			v5.submitted = true
			task.spawn(function()
				submitAskUserCancellation(v5)
			end)
			return true
		end,
		trySubmitComposerText = function(p2: string)
			local v5 = v

			if v5 == nil or v5.submitted then
				return false
			end

			local question = v5.questions[v5.currentIndex]

			return question ~= nil and submitCustomAnswer(v5, question, p2)
		end,
		trySubmitAnswerText = function(p2: string, p3: string, p4: string)
			local v5 = v

			if v5 == nil or v5.submitted or v5.toolCallId ~= p2 then
				return false
			end

			local question = v5.questions[v5.currentIndex]
			return question ~= nil and question.id == p3 and submitCustomAnswer(v5, question, p4)
		end
	}
end

return createAskUserController
