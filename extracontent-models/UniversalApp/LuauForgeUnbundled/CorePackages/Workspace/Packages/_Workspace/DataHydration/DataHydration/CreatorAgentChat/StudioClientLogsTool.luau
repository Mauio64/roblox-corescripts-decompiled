local HttpService = game:GetService("HttpService")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/types")

local function valueLooksLikeToolName(value): boolean
	return typeof(value) == "string" and string.lower(value) == "ask_for_logs"
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

	for k, v5 in toolCall.content do
		if not (v5.type == "content" and v5.content ~= nil) then
			continue
		end

		local content = v5.content

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

return {
	TOOL_NAME = "ask_for_logs",
	LOCAL_TOOL_DEFINITION = {
		name = "ask_for_logs",
		inputSchema = {
			type = "object",
			properties = {
				reason = { type = "string" }
			}
		}
	},
	NOT_IN_GAME_MESSAGE = "The user is not in the game.",
	STALE_LOGS_MESSAGE = "The available logs are from an older saved version. Playtest the latest version first.",
	toolCallLooksLikeClientLogsRequest = function(data)
		local kind = data.kind
		local v5 = typeof(kind) == "string" and string.lower(kind) == "ask_for_logs"

		if v5 then
			return true
		end

		local title = data.title
		local v6 = typeof(title) == "string" and string.lower(title) == "ask_for_logs"

		if v6 then
			return true
		end

		local rawInput = data.rawInput

		if typeof(rawInput) ~= "table" then
			return false
		end

		local name = rawInput.name
		local v7 = typeof(name) == "string" and string.lower(name) == "ask_for_logs"

		if v7 then
			return v7
		end

		local toolName = rawInput.toolName
		v7 = typeof(toolName) == "string" and string.lower(toolName) == "ask_for_logs"
		return v7
	end,
	findClientLogsRequestInTurnState = function(p2, p3)
		local v5 = {}

		for k in p2.toolCalls do
			table.insert(v5, k)
		end

		table.sort(v5)

		for k, v6 in v5 do
			if p3 and p3[v6] then
				continue
			end

			local toolCall = p2.toolCalls[v6]

			if not (toolCall.status ~= "completed" and toolCall.status ~= "failed" and toolCall.status ~= "cancelled" and getPersistedToolResultText(toolCall) == nil) then
				continue
			end

			local kind = toolCall.kind
			local v7 = typeof(kind) == "string" and string.lower(kind) == "ask_for_logs"
			local v8

			if v7 then
				v8 = true
			else
				local title = toolCall.title
				local v9 = typeof(title) == "string" and string.lower(title) == "ask_for_logs"

				if v9 then
					v8 = true
				else
					local rawInput = toolCall.rawInput

					if typeof(rawInput) == "table" then
						local name = rawInput.name
						v8 = typeof(name) == "string" and string.lower(name) == "ask_for_logs"

						if not v8 then
							local toolName = rawInput.toolName
							v8 = typeof(toolName) == "string" and string.lower(toolName) == "ask_for_logs"
						end
					else
						v8 = false
					end
				end
			end

			if v8 then
				return v6, toolCall.rawInput, toolCall.turnId, toolCall.referenceId
			end
		end

		return nil, nil, nil, nil
	end,
	formatLogsContent = function(p2, p3)
		return {
			text = HttpService:JSONEncode({
				status = "ok",
				clientLogs = p2,
				serverLogs = p3
			})
		}
	end,
	formatNotInGameContent = function()
		return {
			text = HttpService:JSONEncode({
				status = "not_in_game",
				message = "The user is not in the game."
			})
		}
	end,
	formatStaleLogsContent = function()
		return {
			text = HttpService:JSONEncode({
				status = "stale",
				message = "The available logs are from an older saved version. Playtest the latest version first."
			})
		}
	end
}
