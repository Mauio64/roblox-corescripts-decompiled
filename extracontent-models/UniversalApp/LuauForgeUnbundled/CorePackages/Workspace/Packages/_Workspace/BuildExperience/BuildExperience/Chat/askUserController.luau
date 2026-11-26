local CreatorAgentChat = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/CreatorAgentChat")

local FFlagBuildExperienceAnswerForm = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceAnswerForm")
local v5 = if FFlagBuildExperienceAnswerForm then require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Signals") else nil
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/chatTypes")
local chatConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/chatConstants")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/localToolOverlay")
local toolControllerUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/toolControllerUtils")

local studioAskUserTool = CreatorAgentChat.StudioAskUserTool
local Debug = CreatorAgentChat.debug
local awaitRequestState = toolControllerUtils.awaitRequestState
local getToolCallOrder = toolControllerUtils.getToolCallOrder

local function getSelectedOptionId(p2)
	if p2 == nil then
		return nil
	end

	if p2.options == nil then
		if p2.option == nil then
			return nil
		end

		return p2.option.id
	else
		local ids = {}

		for k, option in p2.options do
			table.insert(ids, option.id)
		end

		return ids
	end
end

local function makeAnswerStackPrompt(data, p2)
	local answerStackPrompt = {
		question = data.questions[data.currentIndex],
		selectedOptionId = getSelectedOptionId(p2),
		customResponseText = 0,
		toolCallId = 0,
		callOrder = 0,
		isLastQuestion = 0
	}
	local v6 = if p2 ~= nil then p2.customResponseText else nil
	answerStackPrompt.customResponseText = v6
	answerStackPrompt.toolCallId = data.toolCallId
	answerStackPrompt.callOrder = data.callOrder
	answerStackPrompt.isLastQuestion = data.currentIndex >= #data.questions
	return answerStackPrompt
end

local function buildOptimisticAskUserTool(data, p2)
	local v6 = {}

	for k, selection in data.selections do
		v6[k] = {
			selectedOptionId = getSelectedOptionId(selection),
			customResponseText = selection.customResponseText
		}
	end

	if FFlagBuildExperienceAnswerForm then
		if p2 == nil then
			p2 = data.submitted
		end
	else
		p2 = nil
	end

	return {
		toolCallId = data.toolCallId,
		callOrder = data.callOrder,
		currentIndex = data.currentIndex,
		isSubmitting = p2,
		selections = v6,
		drafts = data.drafts
	}
end

local function toggleOptionInSelection(p2, p3)
	local v6 = {}
	local v7 = false

	for k, v8 in (p2 == nil or p2.options == nil) and {} or p2.options do
		if v8.id == p3.id then
			v7 = true
		else
			table.insert(v6, v8)
		end
	end

	if not v7 then
		table.insert(v6, p3)
	end

	return { options = v6, option = nil, customResponseText = nil }
end

local function createAnswerStackSync(callback, callback2, callback3)
	local sessionId = nil
	local v6 = nil
	local v7 = false

	return function(p2): boolean
		local questionsInTurnState, v8, v9, v10, v11 = studioAskUserTool.findQuestionsInTurnState(p2, callback3())

		if questionsInTurnState == nil or v8 == nil then
			if not v7 then
				return false
			end

			Debug.log("info", "ask_user answer stack cleared", {
				turn = Debug.formatTurnState(p2)
			})

			v7 = false
			sessionId = nil
			v6 = nil
			callback(nil)
			callback2(nil)

			return false
		else
			v7 = true

			if p2.sessionId == sessionId and v8 == v6 then
				return true
			end

			sessionId = p2.sessionId
			v6 = v8
			local v12 = {
				sessionId = p2.sessionId,
				toolCallId = v8,
				callOrder = getToolCallOrder(p2, v8),
				turnId = v10,
				referenceId = v11,
				questions = questionsInTurnState,
				selections = {},
				currentIndex = 1,
				submitted = false
			}

			if FFlagBuildExperienceAnswerForm then
				local v13 = {}

				for k, question in v12.questions do
					local signal, v14 = v5.createSignal(nil)
					v13[question.id] = { getText = signal, setText = v14 }
				end

				v12.drafts = v13
			end

			callback2(v12)
			callback({
				question = v12.questions[v12.currentIndex],
				selectedOptionId = nil,
				customResponseText = nil,
				toolCallId = v12.toolCallId,
				callOrder = v12.callOrder,
				isLastQuestion = v12.currentIndex >= #v12.questions
			})
			Debug.log("info", "ask_user answer stack displayed", {
				toolCallId = v8,
				turnId = v10,
				referenceId = v11,
				questions = Debug.formatStudioAskUserQuestions(questionsInTurnState),
				turn = Debug.formatTurnState(p2)
			})

			return true
		end
	end
end

local function createAskUserController(p2, submittedToolCallIds, data, callback)
	local v6 = nil
	local v7 = nil
	local v8 = nil

	local function setAnswerFlow(p3)
		if FFlagBuildExperienceAnswerForm and p3 == nil and v6 ~= nil then
			local drafts = v6.drafts

			if drafts ~= nil then
				for k, draft in drafts do
					draft.setText(nil)
				end
			end
		end

		v6 = p3
	end

	local function setCurrentAnswerStackPrompt(p3)
		local v9 = v6

		if p3 == nil then
			if v9 ~= nil then
				data.removeAskUserTool(v9.toolCallId)
				data.removeAnswerAction(v9.toolCallId)
			end
		elseif v9 ~= nil then
			data.setAskUserTool(buildOptimisticAskUserTool(v9))
			data.setAnswerAction(v9.toolCallId, v7, v8)
		end
	end

	local function getSubmittedToolCallIds()
		return submittedToolCallIds
	end

	local function resetFailedSubmission(p3)
		p3.submitted = false

		if FFlagBuildExperienceAnswerForm then
			data.setAskUserTool(buildOptimisticAskUserTool(p3))
		end

		data.clearSubmitted(p3.toolCallId)
	end

	local function recoverFailedSubmission(state, p3)
		state.submitted = false

		if FFlagBuildExperienceAnswerForm then
			data.setAskUserTool(buildOptimisticAskUserTool(state))
		end

		data.clearSubmitted(state.toolCallId)

		if callback == nil then
			return
		end

		local selection = state.selections[state.currentIndex]
		local customResponseText = if selection ~= nil then selection.customResponseText else nil
		state.selections[state.currentIndex] = nil
		data.setAskUserTool(buildOptimisticAskUserTool(state))
		callback(customResponseText, p3)
	end

	local sessionId = nil
	local v9 = nil
	local v10 = false

	local function fn(p3): boolean
		local questionsInTurnState, v11, v12, v13, v14 = studioAskUserTool.findQuestionsInTurnState(
			p3,
			getSubmittedToolCallIds()
		)

		if questionsInTurnState == nil or v11 == nil then
			if not v10 then
				return false
			end

			Debug.log("info", "ask_user answer stack cleared", {
				turn = Debug.formatTurnState(p3)
			})

			v10 = false
			sessionId = nil
			v9 = nil
			setCurrentAnswerStackPrompt(nil)
			setAnswerFlow(nil)

			return false
		else
			v10 = true

			if p3.sessionId == sessionId and v11 == v9 then
				return true
			end

			sessionId = p3.sessionId
			v9 = v11
			local v15 = {
				sessionId = p3.sessionId,
				toolCallId = v11,
				callOrder = getToolCallOrder(p3, v11),
				turnId = v13,
				referenceId = v14,
				questions = questionsInTurnState,
				selections = {},
				currentIndex = 1,
				submitted = false
			}

			if FFlagBuildExperienceAnswerForm then
				local v16 = {}

				for k, question in v15.questions do
					local signal, v17 = v5.createSignal(nil)
					v16[question.id] = { getText = signal, setText = v17 }
				end

				v15.drafts = v16
			end

			setAnswerFlow(v15)
			setCurrentAnswerStackPrompt({
				question = v15.questions[v15.currentIndex],
				selectedOptionId = nil,
				customResponseText = nil,
				toolCallId = v15.toolCallId,
				callOrder = v15.callOrder,
				isLastQuestion = v15.currentIndex >= #v15.questions
			})
			Debug.log("info", "ask_user answer stack displayed", {
				toolCallId = v11,
				turnId = v13,
				referenceId = v14,
				questions = Debug.formatStudioAskUserQuestions(questionsInTurnState),
				turn = Debug.formatTurnState(p3)
			})

			return true
		end
	end

	local v11 = false

	local function submitAskUserResponses(data2)
		local v12 = {}

		for k, question in data2.questions do
			local selection = data2.selections[k]

			if selection == nil then
				return
			end

			table.insert(v12, {
				question = question,
				option = selection.option,
				options = selection.options,
				customResponseText = selection.customResponseText
			})
		end

		local formatToolResultContent = studioAskUserTool.formatToolResultContent(v12)
		Debug.log("info", "ask_user tool_result submitting", {
			sessionId = data2.sessionId,
			toolCallId = data2.toolCallId,
			turnId = data2.turnId,
			referenceId = data2.referenceId,
			questionCount = #data2.questions
		})

		local lastTime = os.clock()
		local submitActiveToolResult = p2.submitActiveToolResult(
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
			local v13 = awaitRequestState(
				submitActiveToolResult.state,
				os.clock() + chatConstants.CAS_RPC_TIMEOUT_SECONDS
			)
			local v14 = math.floor((os.clock() - lastTime) * 1000 + 0.5)

			if v13.status == "succeeded" then
				Debug.log("info", "ask_user tool_result submitted", {
					sessionId = data2.sessionId,
					toolCallId = data2.toolCallId,
					turnId = data2.turnId,
					referenceId = data2.referenceId,
					questionCount = #data2.questions,
					durationMs = v14
				})

				submittedToolCallIds[data2.toolCallId] = true
				data.markSubmitted(data2.toolCallId)
				data.removeAnswerAction(data2.toolCallId)

				if FFlagBuildExperienceAnswerForm then
					data.setAskUserTool(buildOptimisticAskUserTool(data2, false))
				end

				if FFlagBuildExperienceAnswerForm and v6 ~= nil then
					local drafts = v6.drafts

					if drafts ~= nil then
						for k, draft in drafts do
							draft.setText(nil)
						end
					end
				end

				v6 = nil
			else
				recoverFailedSubmission(data2, v13.errorCode)
				Debug.log("warn", "ask_user tool_result submit failed", {
					sessionId = data2.sessionId,
					toolCallId = data2.toolCallId,
					turnId = data2.turnId,
					referenceId = data2.referenceId,
					durationMs = v14,
					state = Debug.formatRequestState(v13)
				})
			end
		end
	end

	local function submitAskUserCancellation(data2)
		local formatCancellationContent = studioAskUserTool.formatCancellationContent()

		submittedToolCallIds[data2.toolCallId] = true
		data.markSubmitted(data2.toolCallId)
		data.removeAnswerAction(data2.toolCallId)
		local v12 = v6

		if v12 ~= nil then
			data.removeAskUserTool(v12.toolCallId)
			data.removeAnswerAction(v12.toolCallId)
		end

		if FFlagBuildExperienceAnswerForm and v6 ~= nil then
			local drafts = v6.drafts

			if drafts ~= nil then
				for k, draft in drafts do
					draft.setText(nil)
				end
			end
		end

		v6 = nil

		local submitActiveToolResult = p2.submitActiveToolResult(
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

	local function advanceToNextQuestion(state): boolean
		if state.currentIndex >= #state.questions then
			return false
		end

		state.currentIndex += 1
		data.setAskUserTool(buildOptimisticAskUserTool(state))
		return true
	end

	local function commitCurrentSelectionAndAdvance(state)
		local flag

		if state.currentIndex >= #state.questions then
			flag = false
		else
			state.currentIndex += 1
			data.setAskUserTool(buildOptimisticAskUserTool(state))
			flag = true
		end

		if flag then
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

	local function onAnswerSelectedImpl(p3, p4, p5)
		local v12 = v6

		if v12 == nil or v12.submitted then
			return
		end

		local question = v12.questions[v12.currentIndex]

		if question == nil or question.id ~= p3.id then
			return
		end

		if question.responseType == "multi_select" then
			if FFlagBuildExperienceAnswerForm and p5 then
				v12.selections[v12.currentIndex] = nil
			end

			v12.selections[v12.currentIndex] = toggleOptionInSelection(v12.selections[v12.currentIndex], p4)
			data.setAskUserTool(buildOptimisticAskUserTool(v12))
			Debug.log("info", "ask_user multi-select toggled", {
				toolCallId = v12.toolCallId,
				questionId = p3.id,
				questionIndex = v12.currentIndex,
				optionId = p4.id,
				optionTitle = p4.title
			})
		else
			Debug.log("info", "ask_user answer selected", {
				toolCallId = v12.toolCallId,
				questionId = p3.id,
				questionIndex = v12.currentIndex,
				optionId = p4.id,
				optionTitle = p4.title
			})

			v12.selections[v12.currentIndex] = {
				option = p4,
				options = nil,
				customResponseText = nil
			}

			data.setAskUserTool(buildOptimisticAskUserTool(v12))

			commitCurrentSelectionAndAdvance(v12)
		end
	end
	v7 = onAnswerSelectedImpl

	local function onAnswerConfirmedImpl()
		local v12 = v6

		if v12 == nil or v12.submitted then
			return
		end

		local question = v12.questions[v12.currentIndex]

		if question == nil or question.responseType ~= "multi_select" then
			return
		end

		local selection = v12.selections[v12.currentIndex]
		local options = if selection ~= nil then selection.options else nil

		if options == nil or #options == 0 then
			return
		end

		Debug.log("info", "ask_user multi-select confirmed", {
			toolCallId = v12.toolCallId,
			questionId = question.id,
			questionIndex = v12.currentIndex,
			selectedCount = #options
		})

		commitCurrentSelectionAndAdvance(v12)
	end
	v8 = onAnswerConfirmedImpl

	local function submitCustomAnswer(state, question, value): boolean
		if not FFlagBuildExperienceAnswerForm and question.responseType == "multi_select" then
			return false
		end

		if FFlagBuildExperienceAnswerForm then
			value = string.match(value, "^%s*(.-)%s*$") or ""

			if value == "" then
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
			customResponseText = value
		}

		data.setAskUserTool(buildOptimisticAskUserTool(state))
		local flag

		if state.currentIndex >= #state.questions then
			flag = false
		else
			state.currentIndex += 1
			data.setAskUserTool(buildOptimisticAskUserTool(state))
			flag = true
		end

		if flag then
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
		syncAnswerStack = function(p3): boolean
			if not fn(p3) then
				return false
			end

			v11 = true
			return true
		end,
		getSubmittedToolCallIds = getSubmittedToolCallIds,
		hasDisplayedAnswerStack = function()
			return v11
		end,
		stopPendingAnswer = function(): boolean
			local v12 = v6

			if v12 == nil or v12.submitted then
				return false
			end

			v12.submitted = true
			task.spawn(function()
				submitAskUserCancellation(v12)
			end)
			return true
		end,
		trySubmitComposerText = function(p3)
			local v12 = v6

			if v12 == nil or v12.submitted then
				return false
			end

			local question = v12.questions[v12.currentIndex]

			if question == nil then
				return false
			end

			return submitCustomAnswer(v12, question, p3)
		end,
		trySubmitAnswerText = function(p3, p4, p5)
			local v12 = v6

			if v12 == nil or v12.submitted or v12.toolCallId ~= p3 then
				return false
			end

			local question = v12.questions[v12.currentIndex]

			if question == nil or question.id ~= p4 then
				return false
			end

			return submitCustomAnswer(v12, question, p5)
		end
	}
end

return createAskUserController
