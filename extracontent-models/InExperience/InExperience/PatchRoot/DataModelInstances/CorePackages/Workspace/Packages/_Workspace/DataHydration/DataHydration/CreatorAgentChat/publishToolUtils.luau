local HttpService = game:GetService("HttpService")

local Debug = require(script.Parent.debug)
require(script.Parent.types)

local v = { "studio_save_and_publish", "cas_save_and_publish", "save_and_publish" }

local set = {}

for _, v2 in v do
	local v3 = string.gsub(v2, "[_%-%s]", "")
	set[string.lower(v3)] = true
end

local v2 = { save_and_publish = true, cas_save_and_publish = true, studio_save_and_publish = true }

local function normalizeToolIdentifier(value: string) -- 2 equivalent calls inferred from this helper
	local v3 = string.gsub(value, "[_%-%s]", "")
	return string.lower(v3)
end

local function identifierMatchesPublish(value: string): boolean -- 3 equivalent calls inferred from this helper
	local toolIdentifier = normalizeToolIdentifier(value) -- inferred equivalent call

	if set[toolIdentifier] then
		return true
	end

	return string.find(toolIdentifier, "publishplace", 1, true) ~= nil
end

local function valueLooksLikePublishTool(value): boolean
	local _

	if typeof(value) ~= "string" or value == "" then
		_ = false
		return false
	end

	local toolIdentifier = normalizeToolIdentifier(value) -- inferred equivalent call

	if set[toolIdentifier] then
		return true
	end

	return string.find(toolIdentifier, "publishplace", 1, true) ~= nil
end

local function isSaveAndPublishValue(value): boolean -- 3 equivalent calls inferred from this helper
	return typeof(value) == "string" and v2[string.lower(value)] == true
end

local function toolCallMatchesPublishPlace(toolCall): boolean
	local kind = toolCall.kind
	local v3

	if typeof(kind) == "string" and kind ~= "" then
		v3 = identifierMatchesPublish(kind) -- inferred equivalent call
	else
		v3 = false
	end

	if v3 then
		return true
	end

	local title = toolCall.title
	local v4

	if typeof(title) == "string" and title ~= "" then
		v4 = identifierMatchesPublish(title) -- inferred equivalent call
	else
		v4 = false
	end

	if v4 then
		return true
	end

	local rawInput = toolCall.rawInput

	if typeof(rawInput) ~= "table" then
		return false
	end

	for _, v5 in { "tool", "name", "action", "command", "toolName" } do
		local v6 = rawInput[v5]
		local v7

		if typeof(v6) == "string" and v6 ~= "" then
			v7 = identifierMatchesPublish(v6) -- inferred equivalent call
		else
			v7 = false
		end

		if v7 then
			return true
		end
	end

	return false
end

local function isSaveAndPublishToolCall(toolCall): boolean
	if isSaveAndPublishValue(toolCall.title) then -- inferred equivalent call
		return true
	end

	if isSaveAndPublishValue(toolCall.kind) then -- inferred equivalent call
		return true
	end

	local rawInput = toolCall.rawInput

	if typeof(rawInput) ~= "table" then
		return false
	end

	for _, v3 in { "tool", "name", "action", "command", "toolName" } do
		if isSaveAndPublishValue(rawInput[v3]) then -- inferred equivalent call
			return true
		end
	end

	return false
end

local function parsePublishedVersionNumber(text: string) -- 1 equivalent call inferred from this helper
	local v3 = string.match(text, "^%s*Saved as version%s+(%d+)%s*%.?%s*$")

	if v3 == nil then
		return nil
	end

	return (tonumber(v3))
end

local function parseTextResult(text: string) -- 1 equivalent call inferred from this helper
	local success, result = pcall(HttpService.JSONDecode, HttpService, text)

	if not success or typeof(result) ~= "table" then
		return nil
	end

	if result.type == "text" and typeof(result.text) == "string" then
		return result
	end

	return nil
end

local function getToolCallPublishedVersionNumber(toolCall, flag: boolean)
	local content = toolCall.content

	if typeof(content) ~= "table" then
		return nil
	end

	for _, v3 in content do
		local text

		if typeof(v3.content) == "table" then
			text = v3.content.text
		else
			text = v3.text
		end

		if typeof(text) ~= "string" then
			continue
		end

		local result = parseTextResult(text) -- inferred equivalent call

		if result == nil then
			if not flag then
				text = nil
			end
		else
			text = result.text
		end

		if text == nil then
			continue
		end

		local v4 = parsePublishedVersionNumber(text) -- inferred equivalent call

		if v4 ~= nil then
			return v4
		end
	end

	return nil
end

local PublishToolUtils = {}
PublishToolUtils.PUBLISH_PLACE_TOOL_IDENTIFIERS = v

function PublishToolUtils.includesPublishPlaceTool(p): boolean
	for _, toolCall in p.toolCalls do
		if toolCall.status ~= "failed" and toolCallMatchesPublishPlace(toolCall) then
			return true
		end
	end

	return false
end

PublishToolUtils.toolCallMatchesPublishPlace = toolCallMatchesPublishPlace

function PublishToolUtils.getLatestSuccessfulResult(p, _)
	if p == nil then
		return nil
	end

	local result = nil

	for k, toolCall in p.toolCalls do
		if not (toolCall.status == "completed" and isSaveAndPublishToolCall(toolCall)) then
			continue
		end

		local toolCallPublishedVersionNumber = getToolCallPublishedVersionNumber(toolCall, true)

		if toolCallPublishedVersionNumber == nil then
			Debug.log("warn", "completed save_and_publish result is not parseable", {
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
			local rollbackTargetVersionNumber

			if toolCallPublishedVersionNumber > 1 then
				rollbackTargetVersionNumber = toolCallPublishedVersionNumber - 1
			end

			result.rollbackTargetVersionNumber = rollbackTargetVersionNumber
		end
	end

	return result
end

return PublishToolUtils
