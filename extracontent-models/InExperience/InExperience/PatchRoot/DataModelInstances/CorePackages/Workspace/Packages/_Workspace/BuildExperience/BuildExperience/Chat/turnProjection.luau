local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local CreatorAgentChat = require(parent.DataHydration.CreatorAgentChat)
local LocalizationStrings = require(BuildExperience.LocalizationStrings)
require(script.Parent.chatTypes)
local FFlagBuildExperienceAnswerForm = require(BuildExperience.Flags.FFlagBuildExperienceAnswerForm)
local turnDisplay = require(script.Parent.turnDisplay)
local FFlagBuildExperienceManageDevProduct = require(BuildExperience.Flags.FFlagBuildExperienceManageDevProduct)
local FFlagBuildAgentAdCampaignCard = require(BuildExperience.Flags.FFlagBuildAgentAdCampaignCard)

local PublishToolUtils = CreatorAgentChat.PublishToolUtils
local adCampaignEligibilityTool

if FFlagBuildAgentAdCampaignCard then
	adCampaignEligibilityTool = require(BuildExperience.Chat.adCampaignEligibilityTool)
else
	adCampaignEligibilityTool = nil
end

local StudioAskUserTool = CreatorAgentChat.StudioAskUserTool
local StudioProposePlanTool = CreatorAgentChat.StudioProposePlanTool

local ASSISTANT_STOPPED_TEXT = turnDisplay.ASSISTANT_STOPPED_TEXT
local countToolCalls = turnDisplay.countToolCalls
local getAskUserActivityLabel = turnDisplay.getAskUserActivityLabel
local getLocalToolWaitSeconds = turnDisplay.getLocalToolWaitSeconds
local getSummaryToolActivity = turnDisplay.getSummaryToolActivity

local v = {
	submittedToolCallIds = {},
	askUserByToolCallId = {},
	planByToolCallId = {},
	devProductByToolCallId = {}
}

local function contentBlocksToText(items)
	local texts = {}

	for _, item in items do
		if item.type == "text" and typeof(item.text) == "string" then
			table.insert(texts, item.text)
		end
	end

	return table.concat(texts)
end

local function getAssistantMessageTexts(p)
	local assistantMessageTexts = {}

	for _, v2 in p.assistantMessageOrder do
		local assistantMessage = p.assistantMessages[v2]

		if assistantMessage == nil then
			continue
		end

		local v3 = contentBlocksToText(assistantMessage)

		if v3 ~= "" then
			table.insert(assistantMessageTexts, v3)
		end
	end

	return assistantMessageTexts
end

local function makeTurnKey(data, data2) -- 1 equivalent call inferred from this helper
	if data2.turnKey ~= nil then
		return data2.turnKey
	end

	local sessionId = data2.sessionId or data == nil and "pending-session" or data.sessionId
	local sequenceId

	if not (data2.turnFeedbackIds == nil or typeof(data2.turnFeedbackIds) == "function") then
		sequenceId = data2.turnFeedbackIds.sequenceId
	end

	if sequenceId == nil then
		return sessionId
	end

	return `{sessionId}:{sequenceId}`
end

local function makeSegmentKey(p: string, ...)
	local v2 = { p }

	for _, v3 in { ... } do
		table.insert(v2, (tostring(v3)))
	end

	return table.concat(v2, ":")
end

local function getSortedActivitySlotIndexes(data) -- 1 equivalent call inferred from this helper
	local sortedActivitySlotIndexes = {}

	for k in data.activitySlots do
		table.insert(sortedActivitySlotIndexes, k)
	end

	table.sort(sortedActivitySlotIndexes)
	return sortedActivitySlotIndexes
end

local function makeTurnActivityItem(data, activitySlot) -- 2 equivalent calls inferred from this helper
	if activitySlot.kind ~= "tool_call" then
		return nil
	end

	local toolCall = data.toolCalls[activitySlot.toolCallId]
	local v2 = { kind = "tool_call", toolCallId = activitySlot.toolCallId, title = 0, status = 0 }
	local title

	if toolCall then
		title = toolCall.title
	end

	v2.title = title
	local status

	if toolCall then
		status = toolCall.status
	end

	v2.status = status
	return v2
end

local function makeAgentMessageSegment(p: string, text: string, isError: boolean?, errorCode: number?) -- 5 equivalent calls inferred from this helper
	if text == "" then
		return nil
	end

	return {
		kind = "agent_message",
		key = p,
		text = text,
		isError = isError,
		errorCode = errorCode
	}
end

local function makeCompletedActivitySummary(turnActivityItems, segmentKey: string)
	if #turnActivityItems == 0 then
		return nil
	end

	return {
		kind = "activity_summary",
		key = segmentKey,
		summaryKind = "completed",
		summaryToolActivity = getSummaryToolActivity(turnActivityItems, "completed"),
		activityItems = turnActivityItems,
		actionCount = countToolCalls(turnActivityItems),
		isLoading = false
	}
end

local function makeActiveActivitySummary(activityItems, isLoading: boolean, p: string, label: string?, isWaitingForLocalTool: boolean?)
	if #activityItems == 0 and not isLoading then
		return nil
	end

	local summaryToolActivity

	if label == nil then
		summaryToolActivity = getSummaryToolActivity(activityItems, "active")
	end

	if label == nil and summaryToolActivity == nil then
		label = LocalizationStrings.CHAT_ASSISTANT_LOADING
	end

	return {
		kind = "activity_summary",
		key = p,
		summaryKind = "active",
		label = label,
		summaryToolActivity = summaryToolActivity,
		activityItems = activityItems,
		isLoading = isLoading,
		isWaitingForLocalTool = isWaitingForLocalTool
	}
end

local function countActionsInSegments(items)
	local total = 0

	for _, item in items do
		if item.kind == "activity_summary" then
			total += item.actionCount or countToolCalls(item.activityItems)
		end
	end

	return total
end

local function getAnsweredPromptsByToolCallId(data)
	local answeredPrompts = {}

	for _, v2 in StudioAskUserTool.getAnsweredPromptsFromTurnState(data) do
		if v2.toolCallId == nil then
			continue
		end

		local toolCallId = v2.toolCallId

		if answeredPrompts[toolCallId] == nil then
			answeredPrompts[toolCallId] = {}
		end

		table.insert(answeredPrompts[toolCallId], v2)
	end

	return answeredPrompts
end

local function getCompletedPlansByToolCallId(data)
	local completedPlans = {}

	for _, v2 in StudioProposePlanTool.getCompletedPlansFromTurnState(data) do
		if v2.toolCallId ~= nil then
			completedPlans[v2.toolCallId] = v2
		end
	end

	return completedPlans
end

local function makeClientToolSegment(p: string, toolCallId: string, callOrder: number, k: number, isActive: boolean, answerStackPrompt, planProposal, devProductProposal) -- 7 equivalent calls inferred from this helper
	return {
		kind = "client_tool",
		key = makeSegmentKey(p, "client-tool", toolCallId, k),
		toolCallId = toolCallId,
		callOrder = callOrder,
		isActive = isActive,
		answerStackPrompt = answerStackPrompt,
		planProposal = planProposal,
		devProductProposal = devProductProposal
	}
end

local function makeAnswersSegment(p: string, toolCallId: string, answeredPrompts) -- 2 equivalent calls inferred from this helper
	local clientToolSegment = makeClientToolSegment(p, toolCallId, answeredPrompts[1].callOrder or 0, 1, false) -- inferred equivalent call
	clientToolSegment.answeredPrompts = answeredPrompts
	return clientToolSegment
end

local function projectAskUserSegments(p, p2: string, toolCallId: string, p3, p4)
	local toolCall = p.toolCalls[toolCallId]

	if toolCall == nil then
		return {}
	end

	local result = {}
	local answeredPrompts = p3[toolCallId]

	if answeredPrompts == nil or not (#answeredPrompts > 0) then
		local questionsFromToolCall = StudioAskUserTool.extractQuestionsFromToolCall(toolCall)
		local v2 = p4.askUserByToolCallId[toolCallId]

		if questionsFromToolCall == nil or v2 == nil then
			return result
		end

		for k, question in questionsFromToolCall do
			local selection = v2.selections[k]
			local v3

			if k == v2.currentIndex then
				v3 = not p4.submittedToolCallIds[toolCallId]
			else
				v3 = false
			end

			if v3 then
				local callOrder = v2.callOrder
				local selectedOptionId

				if selection ~= nil then
					selectedOptionId = selection.selectedOptionId
				end

				local customResponseText

				if selection ~= nil then
					customResponseText = selection.customResponseText
				end

				local v4 = {
					question = question,
					selectedOptionId = selectedOptionId,
					customResponseText = customResponseText,
					toolCallId = toolCallId,
					callOrder = v2.callOrder,
					isLastQuestion = #questionsFromToolCall <= k
				}
				table.insert(result, makeClientToolSegment(p2, toolCallId, callOrder, k, true, v4)) -- inferred equivalent call
				break
			end

			if selection == nil then
				break
			end

			table.insert(result, makeClientToolSegment(p2, toolCallId, v2.callOrder, k, false, { -- inferred equivalent call
				question = question,
				selectedOptionId = selection.selectedOptionId,
				customResponseText = selection.customResponseText,
				toolCallId = toolCallId,
				callOrder = v2.callOrder,
				isLastQuestion = #questionsFromToolCall <= k
			}))
		end

		if
			not FFlagBuildExperienceAnswerForm
			or not p4.submittedToolCallIds[toolCallId]
			or v2.isSubmitting
			or not (#result > 0)
		then
			return result
		end

		local answerStackPrompts = {}

		for _, v3 in result do
			table.insert(answerStackPrompts, v3.answerStackPrompt)
		end

		local answersSegment = makeAnswersSegment(p2, toolCallId, answerStackPrompts) -- inferred equivalent call
		return { answersSegment }
	elseif FFlagBuildExperienceAnswerForm then
		local answersSegment = makeAnswersSegment(p2, toolCallId, answeredPrompts) -- inferred equivalent call
		return { answersSegment }
	else
		for k, v2 in answeredPrompts do
			table.insert(result, makeClientToolSegment(p2, toolCallId, v2.callOrder or k, k, false, v2)) -- inferred equivalent call
		end

		return result
	end
end

local function projectPlanSegments(p, p2: string, toolCallId: string, p3, p4)
	local toolCall = p.toolCalls[toolCallId]

	if toolCall == nil then
		return {}
	end

	local v2 = p3[toolCallId]

	if v2 ~= nil then
		local callOrder = v2.callOrder or 0
		return { makeClientToolSegment(p2, toolCallId, callOrder, 1, false, nil, v2) } -- inferred equivalent call
	end

	local v3 = p4.planByToolCallId[toolCallId]
	local planFromToolCall = StudioProposePlanTool.extractPlanFromToolCall(toolCall)

	if planFromToolCall == nil or v3 == nil then
		return {}
	end

	local v4 = {
		title = planFromToolCall.title,
		textContent = planFromToolCall.textContent,
		summary = planFromToolCall.summary,
		toolCallId = toolCallId,
		callOrder = v3.callOrder,
		isAccepted = v3.isAccepted,
		feedbackText = v3.feedbackText
	}
	local v5

	if v3.isAccepted == true or v3.feedbackText ~= nil then
		v5 = false
	else
		v5 = not p4.submittedToolCallIds[toolCallId]
	end

	return { makeClientToolSegment(p2, toolCallId, v3.callOrder, 1, v5, nil, v4) } -- inferred equivalent call
end

local function projectDevProductSegments(p, p2: string, toolCallId: string, p3)
	if p.toolCalls[toolCallId] == nil then
		return {}
	end

	local devProductProposal = p3.devProductByToolCallId[toolCallId]

	if devProductProposal == nil then
		return {}
	end

	local v2

	if devProductProposal.isApproved == true or devProductProposal.isRejected == true then
		v2 = false
	else
		v2 = not p3.submittedToolCallIds[toolCallId]
	end

	return { makeClientToolSegment(p2, toolCallId, devProductProposal.callOrder, 1, v2, nil, nil, devProductProposal) } -- inferred equivalent call
end

local function projectLocalToolSegments(data, p: string, toolCallId: string, answeredPromptsByToolCallId, completedPlansByToolCallId, p2)
	local v2 = projectAskUserSegments(data, p, toolCallId, answeredPromptsByToolCallId, p2)

	if #v2 > 0 then
		return v2
	end

	local v3 = projectPlanSegments(data, p, toolCallId, completedPlansByToolCallId, p2)

	if #v3 > 0 then
		return v3
	end

	if FFlagBuildExperienceManageDevProduct then
		return projectDevProductSegments(data, p, toolCallId, p2)
	end

	return {}
end

local function getActiveAskUserActivityLabel(data, toolCallId: string, p)
	local v2 = p.askUserByToolCallId[toolCallId]
	local toolCall = data.toolCalls[toolCallId]

	if v2 == nil or toolCall == nil then
		return nil
	end

	if p.submittedToolCallIds[toolCallId] then
		return LocalizationStrings.CHAT_ASSISTANT_LOADING
	end

	local questionsFromToolCall = StudioAskUserTool.extractQuestionsFromToolCall(toolCall)

	if questionsFromToolCall == nil then
		return nil
	end

	local v3 = questionsFromToolCall[v2.currentIndex]
	local v4 = v3 ~= nil and #v3.options or nil
	return getAskUserActivityLabel(#questionsFromToolCall, v4)
end

local function projectWorkSegments(data, turnKey: string, p, flag: boolean)
	local result = {}
	local turnActivityItems = {}
	local v2 = nil
	local v3 = false
	local answeredPromptsByToolCallId = getAnsweredPromptsByToolCallId(data)
	local completedPlansByToolCallId = getCompletedPlansByToolCallId(data)

	local function flushActivity(flag2: boolean, p2: number?)
		local segmentKey = makeSegmentKey(turnKey, flag2 and "activity-trailing" or "activity", p2 or #result + 1)
		local v4

		if flag and flag2 then
			v4 = makeActiveActivitySummary(turnActivityItems, true, segmentKey, v2, v3)
		else
			v4 = makeCompletedActivitySummary(turnActivityItems, segmentKey)
		end

		if v4 ~= nil then
			table.insert(result, v4)
		end

		turnActivityItems = {}
		v2 = nil
		v3 = false
	end

	local sortedActivitySlotIndexes = getSortedActivitySlotIndexes(data) -- inferred equivalent call

	for _, sortedActivitySlotIndex in sortedActivitySlotIndexes do
		local activitySlot = data.activitySlots[sortedActivitySlotIndex]

		if activitySlot.kind == "agent_message" then
			flushActivity(false, sortedActivitySlotIndex)

			local agentMessageSegment = makeAgentMessageSegment( -- inferred equivalent call
				makeSegmentKey(turnKey, "agent-message", sortedActivitySlotIndex),
				activitySlot.text
			)

			if agentMessageSegment ~= nil then
				table.insert(result, agentMessageSegment)
			end
		elseif activitySlot.kind == "tool_call" then
			local v4 = projectLocalToolSegments(
				data,
				turnKey,
				activitySlot.toolCallId,
				answeredPromptsByToolCallId,
				completedPlansByToolCallId,
				p
			)

			if #v4 > 0 then
				flushActivity(false, sortedActivitySlotIndex)

				for _, v5 in v4 do
					table.insert(result, v5)

					if v5.isActive then
						v3 = true
					end
				end

				if flag then
					local turnActivityItem = makeTurnActivityItem(data, activitySlot) -- inferred equivalent call

					if turnActivityItem ~= nil then
						table.insert(turnActivityItems, turnActivityItem)
					end

					v2 = getActiveAskUserActivityLabel(data, activitySlot.toolCallId, p)
				end
			else
				local turnActivityItem = makeTurnActivityItem(data, activitySlot) -- inferred equivalent call

				if turnActivityItem ~= nil then
					table.insert(turnActivityItems, turnActivityItem)
				end
			end
		end
	end

	local v4 = contentBlocksToText(data.pendingAgentMessageContent)

	if v4 ~= "" then
		flushActivity(false, data.pendingAgentMessageSequenceIndex)
		local v5

		if data.pendingAgentMessageSequenceIndex == nil then
			v5 = makeSegmentKey(turnKey, "pending-agent-message")
		else
			v5 = makeSegmentKey(turnKey, "agent-message", data.pendingAgentMessageSequenceIndex)
		end

		local agentMessageSegment = makeAgentMessageSegment(v5, v4) -- inferred equivalent call

		if agentMessageSegment ~= nil then
			table.insert(result, agentMessageSegment)
		end
	end

	flushActivity(true, nil)
	return result
end

local function makeTurnWorkSegment(turnKey: string, segments, eventMetaBySequenceId, startSequenceId: number?, endSequenceId: number?, localToolWaitSeconds: number?)
	if #segments == 0 then
		return nil
	end

	local actionCount = countActionsInSegments(segments)
	local CHAT_TURN_ACTIVITY = nil
	local workedDurationSeconds = nil

	if eventMetaBySequenceId ~= nil and startSequenceId ~= nil and endSequenceId ~= nil then
		local v2 = eventMetaBySequenceId[startSequenceId]
		local v3 = eventMetaBySequenceId[endSequenceId]
		local emittedTime

		if v2 ~= nil then
			emittedTime = v2.emittedTime
		end

		local emittedTime2

		if v3 ~= nil then
			emittedTime2 = v3.emittedTime
		end

		local dateTime

		if not (emittedTime == nil or emittedTime == "") then
			dateTime = DateTime.fromIsoDate(emittedTime)
		end

		local dateTime2

		if not (emittedTime2 == nil or emittedTime2 == "") then
			dateTime2 = DateTime.fromIsoDate(emittedTime2)
		end

		if dateTime ~= nil and dateTime2 ~= nil then
			workedDurationSeconds = (dateTime2.UnixTimestampMillis - dateTime.UnixTimestampMillis) / 1000

			if localToolWaitSeconds ~= nil then
				workedDurationSeconds = math.max(0, workedDurationSeconds - localToolWaitSeconds)
			end
		end
	end

	if workedDurationSeconds == nil and actionCount == 0 then
		CHAT_TURN_ACTIVITY = LocalizationStrings.CHAT_TURN_ACTIVITY
	end

	return {
		kind = "turn_work",
		key = makeSegmentKey(turnKey, "work"),
		label = CHAT_TURN_ACTIVITY,
		segments = segments,
		actionCount = actionCount,
		workedDurationSeconds = workedDurationSeconds
	}
end

local function addTerminalAssistantMessageSegments(agentMessageSegments, data, turnKey: string)
	for k, v2 in getAssistantMessageTexts(data) do
		local agentMessageSegment = makeAgentMessageSegment(makeSegmentKey(turnKey, "terminal-agent-message", k), v2) -- inferred equivalent call

		if agentMessageSegment ~= nil then
			table.insert(agentMessageSegments, agentMessageSegment)
		end
	end
end

local function addAgentAdCampaignCardSegments(list, data, turnKey: string)
	local v2 = {}

	local toolCallIdSet = {}

	for k in data.activitySlots do
		table.insert(v2, k)
	end

	table.sort(v2)

	for _, v3 in v2 do
		local activitySlot = data.activitySlots[v3]

		if activitySlot.kind ~= "tool_call" then
			continue
		end

		local toolCall = data.toolCalls[activitySlot.toolCallId]

		if
			not adCampaignEligibilityTool.isCompletedEligibilityToolCall(toolCall)
			or toolCallIdSet[toolCall.toolCallId]
		then
			continue
		end

		toolCallIdSet[toolCall.toolCallId] = true
		local decodeCompletedEligibility = adCampaignEligibilityTool.decodeCompletedEligibility(toolCall)
		local cardOffers = adCampaignEligibilityTool.getCardOffers(decodeCompletedEligibility)

		table.insert(list, {
			kind = "agent_ad_campaign_card",
			key = makeSegmentKey(turnKey, "ad-campaign", toolCall.toolCallId),
			toolCallId = toolCall.toolCallId,
			availableCreditsSnapshot = decodeCompletedEligibility == nil and 0 or decodeCompletedEligibility.freeCreditsRemaining,
			offers = cardOffers,
			shouldCheckCampaignStatus = decodeCompletedEligibility == nil or cardOffers ~= nil
		})
	end
end

local function projectTurnSegments(data, data2, p)
	local turnKey = makeTurnKey(data, data2) -- inferred equivalent call
	local v2 = {}
	local segments = projectWorkSegments(data, turnKey, p, not data.isDone)
	local localToolWaitSeconds = getLocalToolWaitSeconds(data)
	local turnWorkSegment = makeTurnWorkSegment(
		turnKey,
		segments,
		data.eventMetaBySequenceId,
		data2.startSequenceId,
		data2.endSequenceId,
		localToolWaitSeconds
	)

	if turnWorkSegment ~= nil then
		table.insert(v2, turnWorkSegment)
	end

	addTerminalAssistantMessageSegments(v2, data, turnKey)

	if FFlagBuildAgentAdCampaignCard then
		addAgentAdCampaignCardSegments(v2, data, turnKey)
	end

	if data.status == "failed" or data.stopReason == "error" then
		local CHAT_ASSISTANT_RESPONSE_FAILED = LocalizationStrings.CHAT_ASSISTANT_RESPONSE_FAILED
		local errorCode = data.errorCode
		local agentMessageSegment = makeAgentMessageSegment( -- inferred equivalent call
			makeSegmentKey(turnKey, "failure"),
			CHAT_ASSISTANT_RESPONSE_FAILED,
			true,
			errorCode
		)

		if agentMessageSegment ~= nil then
			table.insert(v2, agentMessageSegment)
		end
	elseif data.status == "cancelled" or data.stopReason == "cancelled" then
		local agentMessageSegment = makeAgentMessageSegment( -- inferred equivalent call
			makeSegmentKey(turnKey, "cancelled"),
			ASSISTANT_STOPPED_TEXT
		)

		if agentMessageSegment ~= nil then
			table.insert(v2, agentMessageSegment)
		end
	end

	if data.isDone and PublishToolUtils.includesPublishPlaceTool(data) and data2.showPlaytestCta == true then
		table.insert(v2, {
			kind = "playtest_cta",
			key = makeSegmentKey(turnKey, "playtest-cta")
		})
	end

	return v2
end

local TurnProjection = {}

function TurnProjection.getFinalAssistantMessageText(p)
	local assistantMessageTexts = getAssistantMessageTexts(p)
	return assistantMessageTexts[#assistantMessageTexts]
end

function TurnProjection.projectActiveTurnSegments(p, options)
	local v2

	if options and options.optimisticLocalTools then
		v2 = options.optimisticLocalTools
	else
		v2 = v
	end

	return projectTurnSegments(p, options or {}, v2)
end

function TurnProjection.projectLoadingTurnSegments(data)
	local v2

	if data == nil then
		v2 = "loading"
	elseif data.turnKey == nil then
		v2 = data.sessionId or "pending-session"
		local sequenceId

		if not (data.turnFeedbackIds == nil or typeof(data.turnFeedbackIds) == "function") then
			sequenceId = data.turnFeedbackIds.sequenceId
		end

		if sequenceId ~= nil then
			v2 = `{v2}:{sequenceId}`
		end
	else
		v2 = data.turnKey
	end

	local activeActivitySummary = makeActiveActivitySummary({}, true, makeSegmentKey(v2, "activity-trailing"), nil)
	local activeActivitySummaries = {}

	if activeActivitySummary ~= nil then
		table.insert(activeActivitySummaries, activeActivitySummary)
	end

	local v3

	if #activeActivitySummaries ~= 0 then
		local actionCount = countActionsInSegments(activeActivitySummaries)

		local workedDurationSeconds = nil
		local label

		if workedDurationSeconds == nil and actionCount == 0 then
			label = LocalizationStrings.CHAT_TURN_ACTIVITY
		end

		v3 = {
			kind = "turn_work",
			key = makeSegmentKey(v2, "work"),
			label = label,
			segments = activeActivitySummaries,
			actionCount = actionCount,
			workedDurationSeconds = workedDurationSeconds
		}
	end

	if v3 == nil then
		return {}
	end

	return { v3 }
end

function TurnProjection.projectSetupErrorSegments(text: string, data)
	local v2

	if data == nil then
		v2 = "setup-error"
	elseif data.turnKey == nil then
		v2 = data.sessionId or "pending-session"
		local sequenceId

		if not (data.turnFeedbackIds == nil or typeof(data.turnFeedbackIds) == "function") then
			sequenceId = data.turnFeedbackIds.sequenceId
		end

		if sequenceId ~= nil then
			v2 = `{v2}:{sequenceId}`
		end
	else
		v2 = data.turnKey
	end

	return {
		{
			kind = "agent_message",
			key = makeSegmentKey(v2, "setup-error"),
			text = text
		}
	}
end

return TurnProjection
