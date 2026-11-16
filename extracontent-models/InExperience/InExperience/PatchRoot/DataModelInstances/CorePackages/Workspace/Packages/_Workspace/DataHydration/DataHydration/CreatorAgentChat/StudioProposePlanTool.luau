local HttpService = game:GetService("HttpService")
require(script.Parent.types)

local v = { present_plan = true, propose_plan = true }

local function valueLooksLikeToolName(value): boolean -- 8 equivalent calls inferred from this helper
	return typeof(value) == "string" and v[string.lower(value)] == true
end

local function getRawInputContent(rawInput)
	if typeof(rawInput) == "string" then
		return rawInput, nil, nil
	end

	if typeof(rawInput) ~= "table" then
		return nil, nil, nil
	end

	local content = rawInput.content

	if typeof(content) ~= "string" or content == "" then
		return nil, nil, nil
	end

	local title

	if typeof(rawInput.title) == "string" and rawInput.title ~= "" then
		title = rawInput.title
	end

	if typeof(rawInput.summary) == "string" and rawInput.summary ~= "" then
		return content, title, rawInput.summary
	end

	return content, title, nil
end

local function toolCallLooksLikeProposePlan(data)
	if valueLooksLikeToolName(data.kind) then -- inferred equivalent call
		return true
	end

	if valueLooksLikeToolName(data.title) then -- inferred equivalent call
		return true
	end

	local rawInput = data.rawInput

	if typeof(rawInput) ~= "table" then
		return false
	end

	return valueLooksLikeToolName(rawInput.name) or valueLooksLikeToolName(rawInput.toolName) -- inferred equivalent call
end

local function extractPlanFromToolCall(toolCall) -- 2 equivalent calls inferred from this helper
	local v2 = valueLooksLikeToolName(toolCall.kind) -- inferred equivalent call
	local v3

	if v2 then
		v3 = true
	elseif valueLooksLikeToolName(toolCall.title) then -- inferred equivalent call
		v3 = true
	else
		local rawInput = toolCall.rawInput

		if typeof(rawInput) == "table" then
			v3 = valueLooksLikeToolName(rawInput.name) or valueLooksLikeToolName(rawInput.toolName) -- inferred equivalent call
		else
			v3 = false
		end
	end

	if not v3 then
		return nil
	end

	local rawInputContent, v4, summary = getRawInputContent(toolCall.rawInput)

	if rawInputContent == nil then
		return nil
	end

	return {
		title = v4 or "Proposed Plan",
		textContent = rawInputContent,
		summary = summary
	}
end

local function decodePersistedToolResultText(p: string)
	local success, result = pcall(HttpService.JSONDecode, HttpService, p)

	if not success or typeof(result) ~= "table" then
		return nil
	end

	return if typeof(result.text) == "string" then result.text else nil
end

local function getPersistedToolResultText(toolCall)
	if toolCall.content == nil then
		return nil
	end

	local texts = {}

	for _, v2 in toolCall.content do
		if not (v2.type == "content" and v2.content ~= nil) then
			continue
		end

		local content = v2.content

		if not (content.type == "text" and typeof(content.text) == "string") then
			continue
		end

		local text = content.text
		local success, result = pcall(HttpService.JSONDecode, HttpService, text)
		local text2

		if success and typeof(result) == "table" and typeof(result.text) == "string" then
			text2 = result.text
		end

		if text2 ~= nil and text2 ~= "" then
			table.insert(texts, text2)
		end
	end

	if #texts > 0 then
		return (table.concat(texts))
	end

	return nil
end

local function getToolCallOrder(p, p2: string)
	if p.activityItems ~= nil then
		for k, activityItem in p.activityItems do
			if activityItem.kind == "tool_call" and activityItem.toolCallId == p2 then
				return k
			end
		end
	end

	local v2 = {}

	for k in p.toolCalls do
		table.insert(v2, k)
	end

	table.sort(v2)

	for k, v3 in v2 do
		if v3 == p2 then
			return k
		end
	end

	return 0
end

local function decodePlanResult(p: string)
	local success, result = pcall(HttpService.JSONDecode, HttpService, p)

	if not success or typeof(result) ~= "table" or typeof(result.accepted) ~= "boolean" then
		return nil
	end

	if result.feedbackText == nil or typeof(result.feedbackText) == "string" then
		return result
	end

	return nil
end

local StudioProposePlanTool = {}
StudioProposePlanTool.TOOL_NAME = "present_plan"
StudioProposePlanTool.LOCAL_TOOL_DEFINITION = {
	name = "present_plan",
	inputSchema = {
		type = "object",
		required = { "content" },
		properties = {
			content = { type = "string" },
			summary = { type = "string" },
			title = { type = "string" }
		}
	}
}
StudioProposePlanTool.extractPlanFromToolCall = extractPlanFromToolCall

function StudioProposePlanTool.findPlanInTurnState(p, p2)
	local v2 = {}

	for k in p.toolCalls do
		table.insert(v2, k)
	end

	table.sort(v2)

	for _, v3 in v2 do
		if p2 and p2[v3] then
			continue
		end

		local toolCall = p.toolCalls[v3]

		if not (toolCall.status ~= "completed" and toolCall.status ~= "failed" and toolCall.status ~= "cancelled" and getPersistedToolResultText(toolCall) == nil) then
			continue
		end

		local planFromToolCall = extractPlanFromToolCall(toolCall) -- inferred equivalent call

		if planFromToolCall ~= nil then
			return planFromToolCall, v3, toolCall.rawInput, toolCall.turnId, toolCall.referenceId
		end
	end

	return nil, nil, nil, nil, nil
end

function StudioProposePlanTool.getCompletedPlansFromTurnState(p)
	local v2 = {}
	local completedPlans = {}

	for k in p.toolCalls do
		table.insert(v2, k)
	end

	table.sort(v2)

	for _, toolCallId in v2 do
		local toolCall = p.toolCalls[toolCallId]
		local planFromToolCall = extractPlanFromToolCall(toolCall) -- inferred equivalent call
		local persistedToolResultText = getPersistedToolResultText(toolCall)
		local result

		if persistedToolResultText ~= nil then
			local success
			success, result = pcall(HttpService.JSONDecode, HttpService, persistedToolResultText)

			if success and typeof(result) == "table" and typeof(result.accepted) == "boolean" then
				if result.feedbackText ~= nil and typeof(result.feedbackText) ~= "string" then
					result = nil
				end
			else
				result = nil
			end
		end

		if planFromToolCall ~= nil and result ~= nil then
			table.insert(completedPlans, {
				title = planFromToolCall.title,
				textContent = planFromToolCall.textContent,
				summary = planFromToolCall.summary,
				toolCallId = toolCallId,
				callOrder = getToolCallOrder(p, toolCallId),
				isAccepted = result.accepted,
				feedbackText = result.feedbackText
			})
		end
	end

	return completedPlans
end

function StudioProposePlanTool.formatAcceptedContent()
	return {
		text = HttpService:JSONEncode({ accepted = true })
	}
end

function StudioProposePlanTool.formatFeedbackContent(feedbackText: string)
	return {
		text = HttpService:JSONEncode({ accepted = false, feedbackText = feedbackText })
	}
end

return StudioProposePlanTool
