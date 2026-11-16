local HttpService = game:GetService("HttpService")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/types")

local v5 = { present_plan = true, propose_plan = true }

local function valueLooksLikeToolName(value): boolean
	return typeof(value) == "string" and v5[string.lower(value)] == true
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
	local kind = data.kind
	local v6 = typeof(kind) == "string" and v5[string.lower(kind)] == true

	if v6 then
		return true
	end

	local title = data.title
	local v7 = typeof(title) == "string" and v5[string.lower(title)] == true

	if v7 then
		return true
	end

	local rawInput = data.rawInput

	if typeof(rawInput) ~= "table" then
		return false
	end

	local name = rawInput.name
	local v8 = typeof(name) == "string" and v5[string.lower(name)] == true

	if v8 then
		return v8
	end

	local toolName = rawInput.toolName
	v8 = typeof(toolName) == "string" and v5[string.lower(toolName)] == true
	return v8
end

local function decodePersistedToolResultText(p2)
	local success, result = pcall(HttpService.JSONDecode, HttpService, p2)

	if not success or typeof(result) ~= "table" then
		return nil
	end

	if typeof(result.text) == "string" then
		return result.text
	end

	return nil
end

local function getPersistedToolResultText(toolCall)
	if toolCall.content == nil then
		return nil
	end

	local texts = {}

	for k, v6 in toolCall.content do
		if not (v6.type == "content" and v6.content ~= nil) then
			continue
		end

		local content = v6.content

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

local function getToolCallOrder(p2, p3)
	if p2.activityItems ~= nil then
		for k, activityItem in p2.activityItems do
			if activityItem.kind == "tool_call" and activityItem.toolCallId == p3 then
				return k
			end
		end
	end

	local v6 = {}

	for k in p2.toolCalls do
		table.insert(v6, k)
	end

	table.sort(v6)

	for k, v7 in v6 do
		if v7 == p3 then
			return k
		end
	end

	return 0
end

local function decodePlanResult(p2)
	local success, result = pcall(HttpService.JSONDecode, HttpService, p2)

	if not success or typeof(result) ~= "table" or typeof(result.accepted) ~= "boolean" then
		return nil
	end

	if result.feedbackText == nil or typeof(result.feedbackText) == "string" then
		return result
	end

	return nil
end

return {
	TOOL_NAME = "present_plan",
	LOCAL_TOOL_DEFINITION = {
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
	},
	extractPlanFromToolCall = function(data)
		local kind = data.kind
		local v6 = typeof(kind) == "string" and v5[string.lower(kind)] == true
		local v7

		if v6 then
			v7 = true
		else
			local title = data.title
			local v8 = typeof(title) == "string" and v5[string.lower(title)] == true

			if v8 then
				v7 = true
			else
				local rawInput = data.rawInput

				if typeof(rawInput) == "table" then
					local name = rawInput.name
					v7 = typeof(name) == "string" and v5[string.lower(name)] == true

					if not v7 then
						local toolName = rawInput.toolName
						v7 = typeof(toolName) == "string" and v5[string.lower(toolName)] == true
					end
				else
					v7 = false
				end
			end
		end

		if not v7 then
			return nil
		end

		local rawInputContent, v8, v9 = getRawInputContent(data.rawInput)

		if rawInputContent == nil then
			return nil
		end

		return {
			title = v8 or "Proposed Plan",
			textContent = rawInputContent,
			summary = v9
		}
	end,
	findPlanInTurnState = function(p2, p3)
		local v6 = {}

		for k in p2.toolCalls do
			table.insert(v6, k)
		end

		table.sort(v6)

		for k, v7 in v6 do
			if p3 and p3[v7] then
				continue
			end

			local toolCall = p2.toolCalls[v7]

			if not (toolCall.status ~= "completed" and toolCall.status ~= "failed" and toolCall.status ~= "cancelled" and getPersistedToolResultText(toolCall) == nil) then
				continue
			end

			local kind = toolCall.kind
			local v8 = typeof(kind) == "string" and v5[string.lower(kind)] == true
			local v9

			if v8 then
				v9 = true
			else
				local title = toolCall.title
				local v10 = typeof(title) == "string" and v5[string.lower(title)] == true

				if v10 then
					v9 = true
				else
					local rawInput = toolCall.rawInput

					if typeof(rawInput) == "table" then
						local name = rawInput.name
						v9 = typeof(name) == "string" and v5[string.lower(name)] == true

						if not v9 then
							local toolName = rawInput.toolName
							v9 = typeof(toolName) == "string" and v5[string.lower(toolName)] == true
						end
					else
						v9 = false
					end
				end
			end

			local v10

			if v9 then
				local rawInputContent, v11, v12 = getRawInputContent(toolCall.rawInput)

				v10 = rawInputContent ~= nil and {
					title = v11 or "Proposed Plan",
					textContent = rawInputContent,
					summary = v12
				} or nil
			end

			if v10 ~= nil then
				return v10, v7, toolCall.rawInput, toolCall.turnId, toolCall.referenceId
			end
		end

		return nil, nil, nil, nil, nil
	end,
	getCompletedPlansFromTurnState = function(p2)
		local v6 = {}
		local completedPlans = {}

		for k in p2.toolCalls do
			table.insert(v6, k)
		end

		table.sort(v6)

		for k, v7 in v6 do
			local toolCall = p2.toolCalls[v7]
			local kind = toolCall.kind
			local v8 = typeof(kind) == "string" and v5[string.lower(kind)] == true
			local v9

			if v8 then
				v9 = true
			else
				local title = toolCall.title
				local v10 = typeof(title) == "string" and v5[string.lower(title)] == true

				if v10 then
					v9 = true
				else
					local rawInput = toolCall.rawInput

					if typeof(rawInput) == "table" then
						local name = rawInput.name
						v9 = typeof(name) == "string" and v5[string.lower(name)] == true

						if not v9 then
							local toolName = rawInput.toolName
							v9 = typeof(toolName) == "string" and v5[string.lower(toolName)] == true
						end
					else
						v9 = false
					end
				end
			end

			local v10

			if v9 then
				local rawInputContent, v11, v12 = getRawInputContent(toolCall.rawInput)

				v10 = rawInputContent ~= nil and {
					title = v11 or "Proposed Plan",
					textContent = rawInputContent,
					summary = v12
				} or nil
			end

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

			if v10 ~= nil and result ~= nil then
				table.insert(completedPlans, {
					title = v10.title,
					textContent = v10.textContent,
					summary = v10.summary,
					toolCallId = v7,
					callOrder = getToolCallOrder(p2, v7),
					isAccepted = result.accepted,
					feedbackText = result.feedbackText
				})
			end
		end

		return completedPlans
	end,
	formatAcceptedContent = function()
		return {
			text = HttpService:JSONEncode({ accepted = true })
		}
	end,
	formatFeedbackContent = function(p2)
		return {
			text = HttpService:JSONEncode({ accepted = false, feedbackText = p2 })
		}
	end
}
