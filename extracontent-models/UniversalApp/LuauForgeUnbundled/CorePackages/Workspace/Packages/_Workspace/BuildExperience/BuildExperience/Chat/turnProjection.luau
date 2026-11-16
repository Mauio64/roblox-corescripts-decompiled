local CreatorAgentChat = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/CreatorAgentChat")
local LocalizationStrings = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/LocalizationStrings")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/chatTypes")
local FFlagBuildExperienceAnswerForm = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceAnswerForm")
local turnDisplay = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/turnDisplay")
local FFlagBuildExperienceManageDevProduct = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceManageDevProduct")
local FFlagBuildAgentAdCampaignCard = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildAgentAdCampaignCard")

local publishToolUtils = CreatorAgentChat.PublishToolUtils

local v5 = if FFlagBuildAgentAdCampaignCard then require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/adCampaignEligibilityTool") else nil

local studioAskUserTool = CreatorAgentChat.StudioAskUserTool
local studioProposePlanTool = CreatorAgentChat.StudioProposePlanTool

local ASSISTANT_STOPPED_TEXT = turnDisplay.ASSISTANT_STOPPED_TEXT
local countToolCalls = turnDisplay.countToolCalls
local getAskUserActivityLabel = turnDisplay.getAskUserActivityLabel
local getLocalToolWaitSeconds = turnDisplay.getLocalToolWaitSeconds
local getSummaryToolActivity = turnDisplay.getSummaryToolActivity

local v6 = {
	submittedToolCallIds = {},
	askUserByToolCallId = {},
	planByToolCallId = {},
	devProductByToolCallId = {}
}

local function contentBlocksToText(items)
	local texts = {}

	for k, item in items do
		if item.type == "text" and typeof(item.text) == "string" then
			table.insert(texts, item.text)
		end
	end

	return table.concat(texts)
end

local function getAssistantMessageTexts(p2)
	local assistantMessageTexts = {}

	for k, v7 in p2.assistantMessageOrder do
		local assistantMessage = p2.assistantMessages[v7]

		if assistantMessage == nil then
			continue
		end

		local v8 = contentBlocksToText(assistantMessage)

		if v8 ~= "" then
			table.insert(assistantMessageTexts, v8)
		end
	end

	return assistantMessageTexts
end

local function makeTurnKey(p2, data)
	if data.turnKey ~= nil then
		return data.turnKey
	end

	local sessionId = data.sessionId or p2 == nil and "pending-session" or p2.sessionId
	local sequenceId

	if not (data.turnFeedbackIds == nil or typeof(data.turnFeedbackIds) == "function") then
		sequenceId = data.turnFeedbackIds.sequenceId
	end

	if sequenceId == nil then
		return sessionId
	end

	return `{sessionId}:{sequenceId}`
end

local function makeSegmentKey(p2, ...)
	local v7 = { p2 }

	for k, v8 in { ... } do
		table.insert(v7, (tostring(v8)))
	end

	return table.concat(v7, ":")
end

local function getSortedActivitySlotIndexes(p2)
	local sortedActivitySlotIndexes = {}

	for k in p2.activitySlots do
		table.insert(sortedActivitySlotIndexes, k)
	end

	table.sort(sortedActivitySlotIndexes)
	return sortedActivitySlotIndexes
end

local function makeTurnActivityItem(p2, p3)
	if p3.kind ~= "tool_call" then
		return nil
	end

	local toolCall = p2.toolCalls[p3.toolCallId]
	local v7 = { kind = "tool_call", toolCallId = p3.toolCallId, title = 0, status = 0 }
	local v8 = if toolCall then toolCall.title else nil
	v7.title = v8
	local v9 = if toolCall then toolCall.status else nil
	v7.status = v9
	return v7
end

local function makeAgentMessageSegment(p2, p3, p4, p5)
	if p3 == "" then
		return nil
	end

	return {
		kind = "agent_message",
		key = p2,
		text = p3,
		isError = p4,
		errorCode = p5
	}
end

local function makeCompletedActivitySummary(list, segmentKey)
	if #list == 0 then
		return nil
	end

	return {
		kind = "activity_summary",
		key = segmentKey,
		summaryKind = "completed",
		summaryToolActivity = getSummaryToolActivity(list, "completed"),
		activityItems = list,
		actionCount = countToolCalls(list),
		isLoading = false
	}
end

local function makeActiveActivitySummary(list, p2, p3, p4, p5)
	if #list == 0 and not p2 then
		return nil
	end

	local v7 = if p4 == nil then getSummaryToolActivity(list, "active") else nil

	if p4 == nil and v7 == nil then
		p4 = LocalizationStrings.CHAT_ASSISTANT_LOADING
	end

	return {
		kind = "activity_summary",
		key = p3,
		summaryKind = "active",
		label = p4,
		summaryToolActivity = v7,
		activityItems = list,
		isLoading = p2,
		isWaitingForLocalTool = p5
	}
end

local function countActionsInSegments(items)
	local total = 0

	for k, item in items do
		if item.kind == "activity_summary" then
			total += item.actionCount or countToolCalls(item.activityItems)
		end
	end

	return total
end

local function getAnsweredPromptsByToolCallId(data)
	local answeredPrompts = {}

	for k, v7 in studioAskUserTool.getAnsweredPromptsFromTurnState(data) do
		if v7.toolCallId == nil then
			continue
		end

		local toolCallId = v7.toolCallId

		if answeredPrompts[toolCallId] == nil then
			answeredPrompts[toolCallId] = {}
		end

		table.insert(answeredPrompts[toolCallId], v7)
	end

	return answeredPrompts
end

local function getCompletedPlansByToolCallId(data)
	local completedPlans = {}

	for k, v7 in studioProposePlanTool.getCompletedPlansFromTurnState(data) do
		if v7.toolCallId ~= nil then
			completedPlans[v7.toolCallId] = v7
		end
	end

	return completedPlans
end

local function makeClientToolSegment(p2, p3, p4, p5, p6, p7, p8, p9)
	return {
		kind = "client_tool",
		key = makeSegmentKey(p2, "client-tool", p3, p5),
		toolCallId = p3,
		callOrder = p4,
		isActive = p6,
		answerStackPrompt = p7,
		planProposal = p8,
		devProductProposal = p9
	}
end

local function makeAnswersSegment(p2, p3, answeredPrompts)
	local callOrder = answeredPrompts[1].callOrder or 0
	local answersSegment = {
		kind = "client_tool",
		key = makeSegmentKey(p2, "client-tool", p3, 1),
		toolCallId = p3,
		callOrder = callOrder,
		isActive = false,
		answerStackPrompt = nil,
		planProposal = nil,
		devProductProposal = nil
	}

	answersSegment.answeredPrompts = answeredPrompts
	return answersSegment
end

local function projectAskUserSegments(p2, p3, toolCallId, p4, p5)
	local toolCall = p2.toolCalls[toolCallId]

	if toolCall == nil then
		return {}
	end

	local result = {}
	local v7 = p4[toolCallId]

	if v7 == nil or not (#v7 > 0) then
		local questionsFromToolCall = studioAskUserTool.extractQuestionsFromToolCall(toolCall)
		local v8 = p5.askUserByToolCallId[toolCallId]

		if questionsFromToolCall == nil or v8 == nil then
			return result
		end

		for k, v9 in questionsFromToolCall do
			local selection = v8.selections[k]
			local v10 = k == v8.currentIndex and not p5.submittedToolCallIds[toolCallId]

			if v10 then
				local callOrder = v8.callOrder

				local v12 = if selection ~= nil then selection.selectedOptionId else nil
				local v13 = if selection ~= nil then selection.customResponseText else nil
				local v11 = {
					question = v9,
					selectedOptionId = v12,
					customResponseText = v13,
					toolCallId = toolCallId,
					callOrder = v8.callOrder,
					isLastQuestion = #questionsFromToolCall <= k
				}
				table.insert(result, {
					kind = "client_tool",
					key = makeSegmentKey(p3, "client-tool", toolCallId, k),
					toolCallId = toolCallId,
					callOrder = callOrder,
					isActive = true,
					answerStackPrompt = v11,
					planProposal = nil,
					devProductProposal = nil
				})
				break
			else
				if selection == nil then
					break
				end

				local callOrder = v8.callOrder
				local v11 = {
					question = v9,
					selectedOptionId = selection.selectedOptionId,
					customResponseText = selection.customResponseText,
					toolCallId = toolCallId,
					callOrder = v8.callOrder,
					isLastQuestion = #questionsFromToolCall <= k
				}
				table.insert(result, {
					kind = "client_tool",
					key = makeSegmentKey(p3, "client-tool", toolCallId, k),
					toolCallId = toolCallId,
					callOrder = callOrder,
					isActive = false,
					answerStackPrompt = v11,
					planProposal = nil,
					devProductProposal = nil
				})
			end
		end

		if
			not FFlagBuildExperienceAnswerForm
			or not p5.submittedToolCallIds[toolCallId]
			or v8.isSubmitting
			or not (#result > 0)
		then
			return result
		end

		local answerStackPrompts = {}

		for k, v9 in result do
			table.insert(answerStackPrompts, v9.answerStackPrompt)
		end

		local callOrder = answerStackPrompts[1].callOrder or 0
		local v9 = {
			kind = "client_tool",
			key = makeSegmentKey(p3, "client-tool", toolCallId, 1),
			toolCallId = toolCallId,
			callOrder = callOrder,
			isActive = false,
			answerStackPrompt = nil,
			planProposal = nil,
			devProductProposal = nil
		}

		v9.answeredPrompts = answerStackPrompts
		return { v9 }
	elseif FFlagBuildExperienceAnswerForm then
		local callOrder = v7[1].callOrder or 0
		local v8 = {
			kind = "client_tool",
			key = makeSegmentKey(p3, "client-tool", toolCallId, 1),
			toolCallId = toolCallId,
			callOrder = callOrder,
			isActive = false,
			answerStackPrompt = nil,
			planProposal = nil,
			devProductProposal = nil
		}

		v8.answeredPrompts = v7
		return { v8 }
	else
		for k, v8 in v7 do
			local callOrder = v8.callOrder or k
			table.insert(result, {
				kind = "client_tool",
				key = makeSegmentKey(p3, "client-tool", toolCallId, k),
				toolCallId = toolCallId,
				callOrder = callOrder,
				isActive = false,
				answerStackPrompt = v8,
				planProposal = nil,
				devProductProposal = nil
			})
		end

		return result
	end
end

local function projectPlanSegments(p2, p3, p4, p5, p6)
	local toolCall = p2.toolCalls[p4]

	if toolCall == nil then
		return {}
	end

	local v7 = p5[p4]

	if v7 ~= nil then
		local callOrder = v7.callOrder or 0
		return {
			{
				kind = "client_tool",
				key = makeSegmentKey(p3, "client-tool", p4, 1),
				toolCallId = p4,
				callOrder = callOrder,
				isActive = false,
				answerStackPrompt = nil,
				planProposal = v7,
				devProductProposal = nil
			}
		}
	end

	local v8 = p6.planByToolCallId[p4]
	local planFromToolCall = studioProposePlanTool.extractPlanFromToolCall(toolCall)

	if planFromToolCall == nil or v8 == nil then
		return {}
	end

	local v9 = {
		title = planFromToolCall.title,
		textContent = planFromToolCall.textContent,
		summary = planFromToolCall.summary,
		toolCallId = p4,
		callOrder = v8.callOrder,
		isAccepted = v8.isAccepted,
		feedbackText = v8.feedbackText
	}

	local v10 = not (v8.isAccepted == true or v8.feedbackText ~= nil) and not p6.submittedToolCallIds[p4]

	local callOrder = v8.callOrder
	return {
		{
			kind = "client_tool",
			key = makeSegmentKey(p3, "client-tool", p4, 1),
			toolCallId = p4,
			callOrder = callOrder,
			isActive = v10,
			answerStackPrompt = nil,
			planProposal = v9,
			devProductProposal = nil
		}
	}
end

local function projectDevProductSegments(p2, p3, p4, p5)
	if p2.toolCalls[p4] == nil then
		return {}
	end

	local v7 = p5.devProductByToolCallId[p4]

	if v7 == nil then
		return {}
	end

	local v8 = not (v7.isApproved == true or v7.isRejected == true) and not p5.submittedToolCallIds[p4]

	local callOrder = v7.callOrder
	return {
		{
			kind = "client_tool",
			key = makeSegmentKey(p3, "client-tool", p4, 1),
			toolCallId = p4,
			callOrder = callOrder,
			isActive = v8,
			answerStackPrompt = nil,
			planProposal = nil,
			devProductProposal = v7
		}
	}
end

local function projectLocalToolSegments(data, p2, toolCallId, answeredPromptsByToolCallId, completedPlansByToolCallId, p3)
	local v7 = projectAskUserSegments(data, p2, toolCallId, answeredPromptsByToolCallId, p3)

	if #v7 > 0 then
		return v7
	end

	local v8 = projectPlanSegments(data, p2, toolCallId, completedPlansByToolCallId, p3)

	if #v8 > 0 then
		return v8
	end

	if FFlagBuildExperienceManageDevProduct then
		return projectDevProductSegments(data, p2, toolCallId, p3)
	end

	return {}
end

local function getActiveAskUserActivityLabel(data, toolCallId, p2)
	local v7 = p2.askUserByToolCallId[toolCallId]
	local toolCall = data.toolCalls[toolCallId]

	if v7 == nil or toolCall == nil then
		return nil
	end

	if p2.submittedToolCallIds[toolCallId] then
		return LocalizationStrings.CHAT_ASSISTANT_LOADING
	end

	local questionsFromToolCall = studioAskUserTool.extractQuestionsFromToolCall(toolCall)

	if questionsFromToolCall == nil then
		return nil
	end

	local v8 = questionsFromToolCall[v7.currentIndex]
	local v9 = v8 ~= nil and #v8.options or nil
	return getAskUserActivityLabel(#questionsFromToolCall, v9)
end

local function projectWorkSegments(data, p2, p3, p4)
	local result = {}
	local v7 = {}
	local v8 = nil
	local v9 = false
	local answeredPromptsByToolCallId = getAnsweredPromptsByToolCallId(data)
	local completedPlansByToolCallId = getCompletedPlansByToolCallId(data)

	local function flushActivity(p5, p6)
		local segmentKey = makeSegmentKey(p2, p5 and "activity-trailing" or "activity", p6 or #result + 1)
		local v10

		if p4 and p5 then
			v10 = makeActiveActivitySummary(v7, true, segmentKey, v8, v9)
		else
			v10 = makeCompletedActivitySummary(v7, segmentKey)
		end

		if v10 ~= nil then
			table.insert(result, v10)
		end

		v7 = {}
		v8 = nil
		v9 = false
	end

	local v10 = {}

	for k in data.activitySlots do
		table.insert(v10, k)
	end

	table.sort(v10)

	for k, v11 in v10 do
		local activitySlot = data.activitySlots[v11]

		if activitySlot.kind == "agent_message" then
			flushActivity(false, v11)

			local segmentKey = makeSegmentKey(p2, "agent-message", v11)
			local text = activitySlot.text
			local v12 = text ~= "" and {
				kind = "agent_message",
				key = segmentKey,
				text = text,
				isError = nil,
				errorCode = nil
			} or nil

			if v12 ~= nil then
				table.insert(result, v12)
			end
		elseif activitySlot.kind == "tool_call" then
			local v12 = projectLocalToolSegments(
				data,
				p2,
				activitySlot.toolCallId,
				answeredPromptsByToolCallId,
				completedPlansByToolCallId,
				p3
			)

			if #v12 > 0 then
				flushActivity(false, v11)

				for k2, v13 in v12 do
					table.insert(result, v13)

					if v13.isActive then
						v9 = true
					end
				end

				if p4 then
					local v13

					if activitySlot.kind == "tool_call" then
						local toolCall = data.toolCalls[activitySlot.toolCallId]
						v13 = {
							kind = "tool_call",
							toolCallId = activitySlot.toolCallId,
							title = 0,
							status = 0
						}
						local v14 = if toolCall then toolCall.title else nil
						v13.title = v14
						local v15 = if toolCall then toolCall.status else nil
						v13.status = v15
					end

					if v13 ~= nil then
						table.insert(v7, v13)
					end

					v8 = getActiveAskUserActivityLabel(data, activitySlot.toolCallId, p3)
				end
			else
				local v13

				if activitySlot.kind == "tool_call" then
					local toolCall = data.toolCalls[activitySlot.toolCallId]
					v13 = {
						kind = "tool_call",
						toolCallId = activitySlot.toolCallId,
						title = 0,
						status = 0
					}
					local v14 = if toolCall then toolCall.title else nil
					v13.title = v14
					local v15 = if toolCall then toolCall.status else nil
					v13.status = v15
				end

				if v13 ~= nil then
					table.insert(v7, v13)
				end
			end
		end
	end

	local v11 = contentBlocksToText(data.pendingAgentMessageContent)

	if v11 ~= "" then
		flushActivity(false, data.pendingAgentMessageSequenceIndex)
		local v12 = if data.pendingAgentMessageSequenceIndex == nil then makeSegmentKey(p2, "pending-agent-message") else makeSegmentKey(
			p2,
			"agent-message",
			data.pendingAgentMessageSequenceIndex
		)
		local v13 = v11 ~= "" and {
			kind = "agent_message",
			key = v12,
			text = v11,
			isError = nil,
			errorCode = nil
		} or nil

		if v13 ~= nil then
			table.insert(result, v13)
		end
	end

	flushActivity(true, nil)
	return result
end

local function makeTurnWorkSegment(p2, list, eventMetaBySequenceId, startSequenceId, endSequenceId, localToolWaitSeconds)
	if #list == 0 then
		return nil
	end

	local v7 = countActionsInSegments(list)
	local CHAT_TURN_ACTIVITY = nil
	local v8 = nil

	if eventMetaBySequenceId ~= nil and startSequenceId ~= nil and endSequenceId ~= nil then
		local v9 = eventMetaBySequenceId[startSequenceId]
		local v10 = eventMetaBySequenceId[endSequenceId]
		local emittedTime = if v9 ~= nil then v9.emittedTime else nil
		local emittedTime2 = if v10 ~= nil then v10.emittedTime else nil
		local dateTime

		if not (emittedTime == nil or emittedTime == "") then
			dateTime = DateTime.fromIsoDate(emittedTime)
		end

		local dateTime2

		if not (emittedTime2 == nil or emittedTime2 == "") then
			dateTime2 = DateTime.fromIsoDate(emittedTime2)
		end

		if dateTime ~= nil and dateTime2 ~= nil then
			v8 = (dateTime2.UnixTimestampMillis - dateTime.UnixTimestampMillis) / 1000

			if localToolWaitSeconds ~= nil then
				v8 = math.max(0, v8 - localToolWaitSeconds)
			end
		end
	end

	if v8 == nil and v7 == 0 then
		CHAT_TURN_ACTIVITY = LocalizationStrings.CHAT_TURN_ACTIVITY
	end

	return {
		kind = "turn_work",
		key = makeSegmentKey(p2, "work"),
		label = CHAT_TURN_ACTIVITY,
		segments = list,
		actionCount = v7,
		workedDurationSeconds = v8
	}
end

local function addTerminalAssistantMessageSegments(list, data, p2)
	for k, v7 in getAssistantMessageTexts(data) do
		local segmentKey = makeSegmentKey(p2, "terminal-agent-message", k)
		local v8 = v7 ~= "" and {
			kind = "agent_message",
			key = segmentKey,
			text = v7,
			isError = nil,
			errorCode = nil
		} or nil

		if v8 ~= nil then
			table.insert(list, v8)
		end
	end
end

local function addAgentAdCampaignCardSegments(list, data, p2)
	local v7 = {}

	local toolCallIdSet = {}

	for k in data.activitySlots do
		table.insert(v7, k)
	end

	table.sort(v7)

	for k, v8 in v7 do
		local activitySlot = data.activitySlots[v8]

		if activitySlot.kind ~= "tool_call" then
			continue
		end

		local toolCall = data.toolCalls[activitySlot.toolCallId]

		if not v5.isCompletedEligibilityToolCall(toolCall) or toolCallIdSet[toolCall.toolCallId] then
			continue
		end

		toolCallIdSet[toolCall.toolCallId] = true
		local decodeCompletedEligibility = v5.decodeCompletedEligibility(toolCall)
		local cardOffers = v5.getCardOffers(decodeCompletedEligibility)

		table.insert(list, {
			kind = "agent_ad_campaign_card",
			key = makeSegmentKey(p2, "ad-campaign", toolCall.toolCallId),
			toolCallId = toolCall.toolCallId,
			availableCreditsSnapshot = decodeCompletedEligibility == nil and 0 or decodeCompletedEligibility.freeCreditsRemaining,
			offers = cardOffers,
			shouldCheckCampaignStatus = decodeCompletedEligibility == nil or cardOffers ~= nil
		})
	end
end

local function projectTurnSegments(data, data2, p2)
	local v7

	if data2.turnKey == nil then
		v7 = data2.sessionId or data == nil and "pending-session" or data.sessionId
		local sequenceId

		if not (data2.turnFeedbackIds == nil or typeof(data2.turnFeedbackIds) == "function") then
			sequenceId = data2.turnFeedbackIds.sequenceId
		end

		if sequenceId ~= nil then
			v7 = `{v7}:{sequenceId}`
		end
	else
		v7 = data2.turnKey
	end

	local v8 = {}
	local v9 = projectWorkSegments(data, v7, p2, not data.isDone)
	local localToolWaitSeconds = getLocalToolWaitSeconds(data)
	local turnWorkSegment = makeTurnWorkSegment(
		v7,
		v9,
		data.eventMetaBySequenceId,
		data2.startSequenceId,
		data2.endSequenceId,
		localToolWaitSeconds
	)

	if turnWorkSegment ~= nil then
		table.insert(v8, turnWorkSegment)
	end

	addTerminalAssistantMessageSegments(v8, data, v7)

	if FFlagBuildAgentAdCampaignCard then
		addAgentAdCampaignCardSegments(v8, data, v7)
	end

	if data.status == "failed" or data.stopReason == "error" then
		local CHAT_ASSISTANT_RESPONSE_FAILED = LocalizationStrings.CHAT_ASSISTANT_RESPONSE_FAILED
		local errorCode = data.errorCode
		local segmentKey = makeSegmentKey(v7, "failure")
		local v10 = CHAT_ASSISTANT_RESPONSE_FAILED ~= "" and {
			kind = "agent_message",
			key = segmentKey,
			text = CHAT_ASSISTANT_RESPONSE_FAILED,
			isError = true,
			errorCode = errorCode
		} or nil

		if v10 ~= nil then
			table.insert(v8, v10)
		end
	elseif data.status == "cancelled" or data.stopReason == "cancelled" then
		local segmentKey = makeSegmentKey(v7, "cancelled")
		local v11 = ASSISTANT_STOPPED_TEXT ~= "" and {
			kind = "agent_message",
			key = segmentKey,
			text = ASSISTANT_STOPPED_TEXT,
			isError = nil,
			errorCode = nil
		} or nil

		if v11 ~= nil then
			table.insert(v8, v11)
		end
	end

	if
		data.isDone
		and publishToolUtils.includesPublishPlaceTool(data)
		and data2.showPlaytestCta == true
	then
		table.insert(v8, {
			kind = "playtest_cta",
			key = makeSegmentKey(v7, "playtest-cta")
		})
	end

	return v8
end

return {
	getFinalAssistantMessageText = function(p2)
		local assistantMessageTexts = getAssistantMessageTexts(p2)
		return assistantMessageTexts[#assistantMessageTexts]
	end,
	projectActiveTurnSegments = function(p2, options)
		local v9 = if options and options.optimisticLocalTools then options.optimisticLocalTools else v6
		return projectTurnSegments(p2, options or {}, v9)
	end,
	projectLoadingTurnSegments = function(data)
		local v7

		if data == nil then
			v7 = "loading"
		elseif data.turnKey == nil then
			v7 = data.sessionId or "pending-session"
			local sequenceId

			if not (data.turnFeedbackIds == nil or typeof(data.turnFeedbackIds) == "function") then
				sequenceId = data.turnFeedbackIds.sequenceId
			end

			if sequenceId ~= nil then
				v7 = `{v7}:{sequenceId}`
			end
		else
			v7 = data.turnKey
		end

		local activeActivitySummary = makeActiveActivitySummary(
			{},
			true,
			makeSegmentKey(v7, "activity-trailing"),
			nil
		)
		local activeActivitySummaries = {}

		if activeActivitySummary ~= nil then
			table.insert(activeActivitySummaries, activeActivitySummary)
		end

		local v8

		if #activeActivitySummaries ~= 0 then
			local v9 = countActionsInSegments(activeActivitySummaries)

			local v10 = nil

			local v11 = if v10 == nil and v9 == 0 then LocalizationStrings.CHAT_TURN_ACTIVITY else nil

			v8 = {
				kind = "turn_work",
				key = makeSegmentKey(v7, "work"),
				label = v11,
				segments = activeActivitySummaries,
				actionCount = v9,
				workedDurationSeconds = v10
			}
		end

		if v8 == nil then
			return {}
		end

		return { v8 }
	end,
	projectSetupErrorSegments = function(p2, data)
		local v7

		if data == nil then
			v7 = "setup-error"
		elseif data.turnKey == nil then
			v7 = data.sessionId or "pending-session"
			local sequenceId

			if not (data.turnFeedbackIds == nil or typeof(data.turnFeedbackIds) == "function") then
				sequenceId = data.turnFeedbackIds.sequenceId
			end

			if sequenceId ~= nil then
				v7 = `{v7}:{sequenceId}`
			end
		else
			v7 = data.turnKey
		end

		return {
			{
				kind = "agent_message",
				key = makeSegmentKey(v7, "setup-error"),
				text = p2
			}
		}
	end
}
