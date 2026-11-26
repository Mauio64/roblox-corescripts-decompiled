local CreatorAgentChat = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/CreatorAgentChat")
local LocalizationStrings = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/LocalizationStrings")

local studioAskUserTool = CreatorAgentChat.StudioAskUserTool
local studioProposePlanTool = CreatorAgentChat.StudioProposePlanTool

local function parseEmittedTimeMillis(value)
	if typeof(value) ~= "string" or value == "" then
		return nil
	end

	local dateTime = DateTime.fromIsoDate(value)

	if dateTime == nil then
		return nil
	end

	return dateTime.UnixTimestampMillis
end

local function toolCallIsLocalPrompt(p2): boolean
	return studioProposePlanTool.extractPlanFromToolCall(p2) ~= nil
		or studioAskUserTool.extractQuestionsFromToolCall(p2) ~= nil
end

local function isActiveToolActivity(p2): boolean
	if p2.kind == "tool_call" then
		return p2.status == "pending" or p2.status == "in_progress" or p2.status == nil
	end

	return false
end

return {
	ASSISTANT_STOPPED_TEXT = LocalizationStrings.CHAT_ASSISTANT_STOPPED,
	countToolCalls = function(items)
		local count = 0

		for k, item in items do
			if item.kind == "tool_call" then
				count += 1
			end
		end

		return count
	end,
	getAskUserActivityLabel = function(p2, p3)
		if p3 == 0 then
			return LocalizationStrings.CHAT_QUESTION_COMPOSER_ANSWER
		end

		if p2 == 1 then
			return LocalizationStrings.CHAT_QUESTION_SINGLE
		end

		return LocalizationStrings.CHAT_QUESTION_MULTIPLE
	end,
	getLocalToolWaitSeconds = function(data)
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

			if not (toolCall ~= nil and (studioProposePlanTool.extractPlanFromToolCall(toolCall) ~= nil or studioAskUserTool.extractQuestionsFromToolCall(toolCall) ~= nil)) then
				continue
			end

			local v5 = k - 1
			local v6 = eventMetaBySequenceId[v5]
			local v7 = eventMetaBySequenceId[v5 + 1]
			local emittedTime = if v6 then v6.emittedTime else nil
			local unixTimestampMillis

			if typeof(emittedTime) == "string" and emittedTime ~= "" then
				local dateTime = DateTime.fromIsoDate(emittedTime)

				if dateTime ~= nil then
					unixTimestampMillis = dateTime.UnixTimestampMillis
				end
			end

			local emittedTime2 = if v7 then v7.emittedTime else nil
			local unixTimestampMillis2

			if typeof(emittedTime2) == "string" and emittedTime2 ~= "" then
				local dateTime = DateTime.fromIsoDate(emittedTime2)

				if dateTime ~= nil then
					unixTimestampMillis2 = dateTime.UnixTimestampMillis
				end
			end

			if
				unixTimestampMillis ~= nil
				and unixTimestampMillis2 ~= nil
				and unixTimestampMillis < unixTimestampMillis2
			then
				total += unixTimestampMillis2 - unixTimestampMillis
			end
		end

		return total / 1000
	end,
	getSummaryToolActivity = function(list, p2)
		if p2 == "active" then
			for i = #list, 1, -1 do
				local item = list[i]
				local v5

				if item.kind == "tool_call" then
					v5 = item.status == "pending" or item.status == "in_progress" or item.status == nil
				else
					v5 = false
				end

				if v5 then
					return item
				end
			end
		else
			local count = 0

			for k, item in list do
				if item.kind == "tool_call" then
					count += 1
				end
			end

			if count == 1 then
				for k, item in list do
					if item.kind == "tool_call" then
						return item
					end
				end
			end
		end

		return nil
	end
}
