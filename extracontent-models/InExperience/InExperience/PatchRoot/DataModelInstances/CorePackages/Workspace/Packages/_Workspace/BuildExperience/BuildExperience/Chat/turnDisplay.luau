local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local CreatorAgentChat = require(parent.DataHydration.CreatorAgentChat)
local LocalizationStrings = require(BuildExperience.LocalizationStrings)

local StudioAskUserTool = CreatorAgentChat.StudioAskUserTool
local StudioProposePlanTool = CreatorAgentChat.StudioProposePlanTool

local function parseEmittedTimeMillis(value: string?) -- 2 equivalent calls inferred from this helper
	if typeof(value) ~= "string" or value == "" then
		return nil
	end

	local dateTime = DateTime.fromIsoDate(value)
	return if dateTime ~= nil then dateTime.UnixTimestampMillis else nil
end

local function toolCallIsLocalPrompt(p): boolean
	return StudioProposePlanTool.extractPlanFromToolCall(p) ~= nil
		or StudioAskUserTool.extractQuestionsFromToolCall(p) ~= nil
end

local function isActiveToolActivity(item): boolean -- 1 equivalent call inferred from this helper
	if item.kind == "tool_call" then
		return item.status == "pending" or item.status == "in_progress" or item.status == nil
	end

	return false
end

local function countToolCalls(items) -- 1 equivalent call inferred from this helper
	local count = 0

	for _, item in items do
		if item.kind == "tool_call" then
			count += 1
		end
	end

	return count
end

local TurnDisplay = {}
TurnDisplay.ASSISTANT_STOPPED_TEXT = LocalizationStrings.CHAT_ASSISTANT_STOPPED
TurnDisplay.countToolCalls = countToolCalls

function TurnDisplay.getAskUserActivityLabel(p: number, p2: number?)
	if p2 == 0 then
		return LocalizationStrings.CHAT_QUESTION_COMPOSER_ANSWER
	end

	if p == 1 then
		return LocalizationStrings.CHAT_QUESTION_SINGLE
	end

	return LocalizationStrings.CHAT_QUESTION_MULTIPLE
end

function TurnDisplay.getLocalToolWaitSeconds(data)
	local eventMetaBySequenceId = data.eventMetaBySequenceId

	if eventMetaBySequenceId == nil then
		return 0
	end

	local total = 0

	for k, activitySlot in data.activitySlots do
		if activitySlot.kind ~= "tool_call" then
			continue
		end

		local toolCall = data.toolCalls[activitySlot.toolCallId]

		if not (toolCall ~= nil and (StudioProposePlanTool.extractPlanFromToolCall(toolCall) ~= nil or StudioAskUserTool.extractQuestionsFromToolCall(toolCall) ~= nil)) then
			continue
		end

		local v = k - 1
		local v2 = eventMetaBySequenceId[v]
		local v3 = eventMetaBySequenceId[v + 1]
		local v4

		if v2 then
			v4 = v2.emittedTime
		end

		local emittedTimeMillis = parseEmittedTimeMillis(v4) -- inferred equivalent call
		local v5

		if v3 then
			v5 = v3.emittedTime
		end

		local emittedTimeMillis2 = parseEmittedTimeMillis(v5) -- inferred equivalent call

		if emittedTimeMillis ~= nil and emittedTimeMillis2 ~= nil and emittedTimeMillis < emittedTimeMillis2 then
			total += emittedTimeMillis2 - emittedTimeMillis
		end
	end

	return total / 1000
end

function TurnDisplay.getSummaryToolActivity(list, p: string)
	if p == "active" then
		for i = #list, 1, -1 do
			local item = list[i]

			if isActiveToolActivity(item) then -- inferred equivalent call
				return item
			end
		end
	elseif countToolCalls(list) == 1 then -- inferred equivalent call
		for _, item in list do
			if item.kind == "tool_call" then
				return item
			end
		end
	end

	return nil
end

return TurnDisplay
