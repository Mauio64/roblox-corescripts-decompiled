local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local CreatorAgentChat = require(BuildExperienceParent.DataHydration.CreatorAgentChat)
local LocalizationStrings = require(BuildExperience.LocalizationStrings)
local SubagentTasks = CreatorAgentChat.SubagentTasks

local function normalizeToolTitle(s1: string) -- line: 23
	return string.lower((string.gsub(s1, "[_%-%s]", "")))
end
local function isManageTasksToolTitle(s2: string?) -- line: 27
	-- upvalues: SubagentTasks (copy)
	local v18 = false

	if typeof(s2) == "string" then
		local v19 = string.lower((string.gsub(s2, "[_%-%s]", "")))
		local TOOL_NAME = SubagentTasks.TOOL_NAME

		v18 = v19 == string.lower((string.gsub(TOOL_NAME, "[_%-%s]", "")))
	end

	return v18
end
local function formatStepCount(n1: number) -- line: 32
	-- upvalues: LocalizationStrings (copy)
	return LocalizationStrings.formatChatTaskCount(n1)
end
local function formatWorkedDuration(n2: number) -- line: 38
	-- upvalues: LocalizationStrings (copy)
	return LocalizationStrings.formatChatWorkedDuration(n2)
end
local function parseEmittedTimeMillis(s3: string?) -- line: 42
	if typeof(s3) ~= "string" or s3 == "" then
		return nil
	end

	local dateTime = DateTime.fromIsoDate(s3)

	if dateTime ~= nil then
		return dateTime.UnixTimestampMillis
	end

	return nil
end
local function isActiveToolActivity(p1) -- line: 70
	if p1.kind ~= "tool_call" then
		return false
	end

	return p1.status == "pending" or (p1.status == "in_progress" or p1.status == nil)
end
local function getToolActivityLabel(p2) -- line: 77
	-- upvalues: LocalizationStrings (copy), SubagentTasks (copy)
	if p2.kind ~= "tool_call" then
		return LocalizationStrings.CHAT_TOOL
	end

	local v39 = if typeof(p2.title) ~= "string" or p2.title == "" then LocalizationStrings.CHAT_TOOL else p2.title
	local v40 = LocalizationStrings.getChatToolActivityLabel(v39, p2.status)

	if v40 ~= nil then
		return v40
	end

	local v41 = false

	if typeof(v39) == "string" then
		local v42 = string.lower((string.gsub(v39, "[_%-%s]", "")))
		local TOOL_NAME = SubagentTasks.TOOL_NAME

		v41 = v42 == string.lower((string.gsub(TOOL_NAME, "[_%-%s]", "")))
	end

	if v41 then
		return LocalizationStrings.CHAT_ASSIGNING_TASKS
	end

	if p2.status == "completed" then
		return LocalizationStrings.formatChatFinishedTool(v39)
	end

	if p2.status == "failed" then
		return LocalizationStrings.formatChatFailedTool(v39)
	end

	return LocalizationStrings.formatChatRunningTool(v39)
end
local function getActiveActivityLabel(t1: {[any]: any}, _: boolean) -- line: 111
	-- upvalues: getToolActivityLabel (copy), LocalizationStrings (copy)
	for i = #t1, 1, -1 do
		local v51 = t1[i]

		if v51.kind == "tool_call" and (v51.kind == "tool_call" and (v51.status == "pending" or (v51.status == "in_progress" or v51.status == nil))) then
			return getToolActivityLabel(v51)
		end
	end

	return LocalizationStrings.CHAT_ASSISTANT_LOADING
end

return {
	ASSISTANT_STOPPED_TEXT = LocalizationStrings.CHAT_ASSISTANT_STOPPED,
	countToolCalls = function(t2: {[any]: any}) -- line: 101
		local n3 = 0

		for _, v47 in t2 do
			if v47.kind == "tool_call" then
				n3 += 1
			end
		end

		return n3
	end,
	formatTurnFailureMessage = function(p3) -- line: 18
		-- upvalues: LocalizationStrings (copy)
		local v15 = p3.error or LocalizationStrings.CHAT_ASSISTANT_RESPONSE_FAILED

		return LocalizationStrings.formatChatTurnFailureMessage(v15, p3.errorCode)
	end,
	formatStepCount = formatStepCount,
	formatWorkedDuration = formatWorkedDuration,
	getActiveActivityLabel = getActiveActivityLabel,
	getAskUserActivityLabel = function(n4: number, n5: number?) -- line: 136
		-- upvalues: LocalizationStrings (copy)
		if n5 == 0 then
			return LocalizationStrings.CHAT_QUESTION_COMPOSER_ANSWER
		end

		if n4 == 1 then
			return LocalizationStrings.CHAT_QUESTION_SINGLE
		end

		return LocalizationStrings.CHAT_QUESTION_MULTIPLE
	end,
	getCompletedActivityLabel = function(t3: {[any]: any}) -- line: 121
		-- upvalues: getToolActivityLabel (copy), formatStepCount (copy), getActiveActivityLabel (copy)
		local n6 = 0

		for _, v55 in t3 do
			if v55.kind == "tool_call" then
				n6 += 1
			end
		end

		if n6 == 1 then
			for _, v57 in t3 do
				if v57.kind == "tool_call" then
					return getToolActivityLabel(v57)
				end
			end
		end

		if n6 > 0 then
			return formatStepCount(n6)
		end

		return getActiveActivityLabel(t3, false)
	end,
	getToolActivityLabel = getToolActivityLabel,
	getTurnWorkedDurationLabel = function(t4: {[any]: any}?, n7: number?, n8: number?, n9: number) -- line: 50
		-- upvalues: formatWorkedDuration (copy), LocalizationStrings (copy)
		if t4 ~= nil and (n7 ~= nil and n8 ~= nil) then
			local v29 = t4[n7]
			local v30 = t4[n8]
			local v32

			if v29 ~= nil then
				local emittedTime = v29.emittedTime

				if typeof(emittedTime) ~= "string" or emittedTime == "" then
					v32 = nil
				else
					local dateTime = DateTime.fromIsoDate(emittedTime)

					v32 = if dateTime == nil then nil else dateTime.UnixTimestampMillis
				end
			else
				v32 = nil
			end

			local v35

			if v30 ~= nil then
				local emittedTime = v30.emittedTime

				if typeof(emittedTime) ~= "string" or emittedTime == "" then
					v35 = nil
				else
					local dateTime = DateTime.fromIsoDate(emittedTime)

					v35 = if dateTime == nil then nil else dateTime.UnixTimestampMillis
				end
			else
				v35 = nil
			end

			if v32 ~= nil and v35 ~= nil then
				return formatWorkedDuration((v35 - v32) / 1000)
			end
		end

		if n9 > 0 then
			return (LocalizationStrings.formatChatTaskCount(n9))
		end

		return LocalizationStrings.CHAT_TURN_ACTIVITY
	end
}
