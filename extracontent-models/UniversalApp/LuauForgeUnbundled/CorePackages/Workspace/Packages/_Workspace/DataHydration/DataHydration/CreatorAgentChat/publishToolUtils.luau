local HttpService = game:GetService("HttpService")

local debug = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/debug")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/types")

local v5 = { "studio_save_and_publish", "cas_save_and_publish", "save_and_publish" }

local set = {}

for k, v6 in v5 do
	local v7 = string.gsub(v6, "[_%-%s]", "")
	set[string.lower(v7)] = true
end

local v6 = {
	save_and_publish = true,
	cas_save_and_publish = true,
	studio_save_and_publish = true
}

local function normalizeToolIdentifier(value)
	local v7 = string.gsub(value, "[_%-%s]", "")
	return string.lower(v7)
end

local function identifierMatchesPublish(value): boolean
	local v7 = string.gsub(value, "[_%-%s]", "")
	local v8 = string.lower(v7)

	if set[v8] then
		return true
	end

	return string.find(v8, "publishplace", 1, true) ~= nil
end

local function valueLooksLikePublishTool(value)
	local v7

	if typeof(value) ~= "string" or value == "" then
		v7 = false
		return false
	end

	local v8 = string.gsub(value, "[_%-%s]", "")
	local v9 = string.lower(v8)

	if set[v9] then
		return true
	end

	v7 = string.find(v9, "publishplace", 1, true) ~= nil
	return v7
end

local function isSaveAndPublishValue(value): boolean
	if typeof(value) == "string" then
		return v6[string.lower(value)] == true
	end

	return false
end

local function toolCallMatchesPublishPlace(toolCall): boolean
	local kind = toolCall.kind
	local v7

	if typeof(kind) == "string" and kind ~= "" then
		local v8 = string.gsub(kind, "[_%-%s]", "")
		local v9 = string.lower(v8)

		v7 = set[v9] and true or string.find(v9, "publishplace", 1, true) ~= nil
	else
		v7 = false
	end

	if v7 then
		return true
	end

	local title = toolCall.title
	local v8

	if typeof(title) == "string" and title ~= "" then
		local v9 = string.gsub(title, "[_%-%s]", "")
		local v10 = string.lower(v9)

		v8 = set[v10] and true or string.find(v10, "publishplace", 1, true) ~= nil
	else
		v8 = false
	end

	if v8 then
		return true
	end

	local rawInput = toolCall.rawInput

	if typeof(rawInput) ~= "table" then
		return false
	end

	for k, v9 in { "tool", "name", "action", "command", "toolName" } do
		local v10 = rawInput[v9]
		local v11

		if typeof(v10) == "string" and v10 ~= "" then
			local v12 = string.gsub(v10, "[_%-%s]", "")
			local v13 = string.lower(v12)

			v11 = set[v13] and true or string.find(v13, "publishplace", 1, true) ~= nil
		else
			v11 = false
		end

		if v11 then
			return true
		end
	end

	return false
end

local function isSaveAndPublishToolCall(toolCall): boolean
	local title = toolCall.title
	local v7 = typeof(title) == "string" and v6[string.lower(title)] == true

	if v7 then
		return true
	end

	local kind = toolCall.kind
	local v8 = typeof(kind) == "string" and v6[string.lower(kind)] == true

	if v8 then
		return true
	end

	local rawInput = toolCall.rawInput

	if typeof(rawInput) ~= "table" then
		return false
	end

	for k, v9 in { "tool", "name", "action", "command", "toolName" } do
		local v10 = rawInput[v9]
		local v11 = typeof(v10) == "string" and v6[string.lower(v10)] == true

		if v11 then
			return true
		end
	end

	return false
end

local function parsePublishedVersionNumber(value)
	local v7 = string.match(value, "^%s*Saved as version%s+(%d+)%s*%.?%s*$")

	if v7 == nil then
		return nil
	end

	return (tonumber(v7))
end

local function parseTextResult(p2)
	local success, result = pcall(HttpService.JSONDecode, HttpService, p2)

	if not success or typeof(result) ~= "table" then
		return nil
	end

	if result.type == "text" and typeof(result.text) == "string" then
		return result
	end

	return nil
end

local function getToolCallPublishedVersionNumber(toolCall, p2)
	local content = toolCall.content

	if typeof(content) ~= "table" then
		return nil
	end

	for k, v7 in content do
		local text = if typeof(v7.content) == "table" then v7.content.text else v7.text

		if typeof(text) ~= "string" then
			continue
		end

		local success, result = pcall(HttpService.JSONDecode, HttpService, text)

		if success and typeof(result) == "table" then
			if result.type ~= "text" or typeof(result.text) ~= "string" then
				result = nil
			end
		else
			result = nil
		end

		if result == nil then
			if not p2 then
				text = nil
			end
		else
			text = result.text
		end

		if text == nil then
			continue
		end

		local v8 = string.match(text, "^%s*Saved as version%s+(%d+)%s*%.?%s*$")

		local v9 = if v8 ~= nil then tonumber(v8) else nil

		if v9 ~= nil then
			return v9
		end
	end

	return nil
end

return {
	PUBLISH_PLACE_TOOL_IDENTIFIERS = v5,
	includesPublishPlaceTool = function(p2): boolean
		for k, toolCall in p2.toolCalls do
			if toolCall.status ~= "failed" and toolCallMatchesPublishPlace(toolCall) then
				return true
			end
		end

		return false
	end,
	toolCallMatchesPublishPlace = toolCallMatchesPublishPlace,
	getLatestSuccessfulResult = function(p2, p3)
		if p2 == nil then
			return nil
		end

		local result = nil

		for k, toolCall in p2.toolCalls do
			if not (toolCall.status == "completed" and isSaveAndPublishToolCall(toolCall)) then
				continue
			end

			local toolCallPublishedVersionNumber = getToolCallPublishedVersionNumber(toolCall, true)

			if toolCallPublishedVersionNumber == nil then
				debug.log("warn", "completed save_and_publish result is not parseable", {
					toolCallId = toolCall.toolCallId,
					title = toolCall.title,
					status = toolCall.status,
					contentBlockCount = typeof(toolCall.content) == "table" and #toolCall.content or 0,
					hasRawOutput = toolCall.rawOutput ~= nil
				})
			else
				result = {
					toolCallId = k,
					publishedVersionNumber = toolCallPublishedVersionNumber,
					rollbackTargetVersionNumber = 0
				}

				local v7 = if toolCallPublishedVersionNumber > 1 then toolCallPublishedVersionNumber - 1 else nil
				result.rollbackTargetVersionNumber = v7
			end
		end

		return result
	end
}
