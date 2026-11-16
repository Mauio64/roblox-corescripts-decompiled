local HttpService = game:GetService("HttpService")

require(script.Parent.types)

local function valueLooksLikeToolName(value, p: string): boolean -- 4 equivalent calls inferred from this helper
	return typeof(value) == "string" and string.lower(value) == p
end

local function toolCallLooksLikeRequest(toolCall, p: string)
	if valueLooksLikeToolName(toolCall.kind, p) then -- inferred equivalent call
		return true
	end

	if valueLooksLikeToolName(toolCall.title, p) then -- inferred equivalent call
		return true
	end

	local rawInput = toolCall.rawInput

	if typeof(rawInput) ~= "table" then
		return false
	end

	return valueLooksLikeToolName(rawInput.name, p) or valueLooksLikeToolName(rawInput.toolName, p) -- inferred equivalent call
end

local function hasPersistedToolResult(toolCall): boolean
	if toolCall.content == nil then
		return false
	end

	for _, v in toolCall.content do
		if not (v.type == "content" and v.content ~= nil) then
			continue
		end

		local content = v.content

		if not (content.type == "text" and typeof(content.text) == "string") then
			continue
		end

		local success, result = pcall(HttpService.JSONDecode, HttpService, content.text)

		if success and typeof(result) == "table" and typeof(result.text) == "string" and result.text ~= "" then
			return true
		end
	end

	return false
end

local function findRequestInTurnState(p, p2: string, p3)
	local v = {}

	for k in p.toolCalls do
		table.insert(v, k)
	end

	table.sort(v)

	for _, v2 in v do
		if p3 and p3[v2] then
			continue
		end

		local toolCall = p.toolCalls[v2]

		if
			(toolCall.status == nil or toolCall.status == "pending" or toolCall.status == "in_progress")
			and not hasPersistedToolResult(toolCall)
			and toolCallLooksLikeRequest(toolCall, p2)
		then
			return v2, toolCall.rawInput, toolCall.turnId, toolCall.referenceId
		end
	end

	return nil, nil, nil, nil
end

local StudioClientDataModelTools = {}
StudioClientDataModelTools.SEARCH_TOOL_NAME = "search_client_datamodel"
StudioClientDataModelTools.INSPECT_TOOL_NAME = "inspect_client_instance"
StudioClientDataModelTools.SEARCH_LOCAL_TOOL_DEFINITION = {
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
}

StudioClientDataModelTools.INSPECT_LOCAL_TOOL_DEFINITION = {
	name = "inspect_client_instance",
	inputSchema = {
		type = "object",
		properties = {
			path = { type = "string" }
		},
		required = { "path" }
	}
}
StudioClientDataModelTools.toolCallLooksLikeRequest = toolCallLooksLikeRequest

function StudioClientDataModelTools.findSearchRequestInTurnState(p, p2)
	return findRequestInTurnState(p, "search_client_datamodel", p2)
end

function StudioClientDataModelTools.findInspectRequestInTurnState(p, p2)
	return findRequestInTurnState(p, "inspect_client_instance", p2)
end

function StudioClientDataModelTools.formatResultContent(p)
	local success, result = pcall(HttpService.JSONEncode, HttpService, p)

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

return StudioClientDataModelTools
