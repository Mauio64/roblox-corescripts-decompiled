local HttpService = game:GetService("HttpService")
require(script.Parent.types)

local function valueLooksLikeToolName(value): boolean -- 8 equivalent calls inferred from this helper
	return typeof(value) == "string" and string.lower(value) == "ask_for_logs"
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

	for _, v in toolCall.content do
		if not (v.type == "content" and v.content ~= nil) then
			continue
		end

		local content = v.content

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

local StudioClientLogsTool = {}
StudioClientLogsTool.TOOL_NAME = "ask_for_logs"
StudioClientLogsTool.LOCAL_TOOL_DEFINITION = {
	name = "ask_for_logs",
	inputSchema = {
		type = "object",
		properties = {
			reason = { type = "string" }
		}
	}
}
StudioClientLogsTool.NOT_IN_GAME_MESSAGE = "The user is not in the game."
StudioClientLogsTool.STALE_LOGS_MESSAGE = "The available logs are from an older saved version. Playtest the latest version first."

function StudioClientLogsTool.toolCallLooksLikeClientLogsRequest(data)
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

function StudioClientLogsTool.findClientLogsRequestInTurnState(p, p2)
	local v = {}

	for k in p.toolCalls do
		table.insert(v, k)
	end

	table.sort(v)

	for _, v2 in v do
		if p2 and p2[v2] then
			continue
		end

		local toolCall = p.toolCalls[v2]

		if not (toolCall.status ~= "completed" and toolCall.status ~= "failed" and toolCall.status ~= "cancelled" and getPersistedToolResultText(toolCall) == nil) then
			continue
		end

		local v3 = valueLooksLikeToolName(toolCall.kind) -- inferred equivalent call
		local v4

		if v3 then
			v4 = true
		elseif valueLooksLikeToolName(toolCall.title) then -- inferred equivalent call
			v4 = true
		else
			local rawInput = toolCall.rawInput

			if typeof(rawInput) == "table" then
				v4 = valueLooksLikeToolName(rawInput.name) or valueLooksLikeToolName(rawInput.toolName) -- inferred equivalent call
			else
				v4 = false
			end
		end

		if v4 then
			return v2, toolCall.rawInput, toolCall.turnId, toolCall.referenceId
		end
	end

	return nil, nil, nil, nil
end

function StudioClientLogsTool.formatLogsContent(clientLogs, serverLogs)
	return {
		text = HttpService:JSONEncode({
			status = "ok",
			clientLogs = clientLogs,
			serverLogs = serverLogs
		})
	}
end

function StudioClientLogsTool.formatNotInGameContent()
	return {
		text = HttpService:JSONEncode({
			status = "not_in_game",
			message = "The user is not in the game."
		})
	}
end

function StudioClientLogsTool.formatStaleLogsContent()
	return {
		text = HttpService:JSONEncode({
			status = "stale",
			message = "The available logs are from an older saved version. Playtest the latest version first."
		})
	}
end

return StudioClientLogsTool
