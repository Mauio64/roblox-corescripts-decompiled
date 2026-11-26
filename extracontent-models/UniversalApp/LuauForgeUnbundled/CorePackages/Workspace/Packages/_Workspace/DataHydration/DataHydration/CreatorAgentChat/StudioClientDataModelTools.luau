local HttpService = game:GetService("HttpService")

require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/types")

local function valueLooksLikeToolName(value, p2): boolean
	return typeof(value) == "string" and string.lower(value) == p2
end

local function toolCallLooksLikeRequest(toolCall, p2)
	local kind = toolCall.kind
	local v5 = typeof(kind) == "string" and string.lower(kind) == p2

	if v5 then
		return true
	end

	local title = toolCall.title
	local v6 = typeof(title) == "string" and string.lower(title) == p2

	if v6 then
		return true
	end

	local rawInput = toolCall.rawInput

	if typeof(rawInput) ~= "table" then
		return false
	end

	local name = rawInput.name
	local v7 = typeof(name) == "string" and string.lower(name) == p2

	if v7 then
		return v7
	end

	local toolName = rawInput.toolName
	v7 = typeof(toolName) == "string" and string.lower(toolName) == p2
	return v7
end

local function hasPersistedToolResult(toolCall): boolean
	if toolCall.content == nil then
		return false
	end

	for k, v5 in toolCall.content do
		if not (v5.type == "content" and v5.content ~= nil) then
			continue
		end

		local content = v5.content

		if not (content.type == "text" and typeof(content.text) == "string") then
			continue
		end

		local success, result = pcall(HttpService.JSONDecode, HttpService, content.text)

		if
			success
			and typeof(result) == "table"
			and typeof(result.text) == "string"
			and result.text ~= ""
		then
			return true
		end
	end

	return false
end

local function findRequestInTurnState(p2, p3, p4)
	local v5 = {}

	for k in p2.toolCalls do
		table.insert(v5, k)
	end

	table.sort(v5)

	for k, v6 in v5 do
		if p4 and p4[v6] then
			continue
		end

		local toolCall = p2.toolCalls[v6]

		if
			(toolCall.status == nil or toolCall.status == "pending" or toolCall.status == "in_progress")
			and not hasPersistedToolResult(toolCall)
			and toolCallLooksLikeRequest(toolCall, p3)
		then
			return v6, toolCall.rawInput, toolCall.turnId, toolCall.referenceId
		end
	end

	return nil, nil, nil, nil
end

return {
	SEARCH_TOOL_NAME = "search_client_datamodel",
	INSPECT_TOOL_NAME = "inspect_client_instance",
	SEARCH_LOCAL_TOOL_DEFINITION = {
		name = "search_client_datamodel",
		inputSchema = {
			type = "object",
			properties = {
				path = { type = "string" },
				instance_type = { type = "string" },
				keywords = { type = "string" },
				max_depth = { type = "integer" },
				head_limit = { type = "integer" }
			}
		}
	},
	INSPECT_LOCAL_TOOL_DEFINITION = {
		name = "inspect_client_instance",
		inputSchema = {
			type = "object",
			properties = {
				path = { type = "string" }
			},
			required = { "path" }
		}
	},
	toolCallLooksLikeRequest = toolCallLooksLikeRequest,
	findSearchRequestInTurnState = function(p2, p3)
		return findRequestInTurnState(p2, "search_client_datamodel", p3)
	end,
	findInspectRequestInTurnState = function(p2, p3)
		return findRequestInTurnState(p2, "inspect_client_instance", p3)
	end,
	formatResultContent = function(p2)
		local success, result = pcall(HttpService.JSONEncode, HttpService, p2)

		if not success then
			return {
				text = HttpService:JSONEncode({
					status = "serialization_failed",
					message = "The client tool result could not be serialized."
				})
			}
		end

		if #result > 524288 then
			return {
				text = HttpService:JSONEncode({
					status = "result_too_large",
					message = "The client tool result exceeded the response size limit."
				})
			}
		end

		return { text = result }
	end
}
