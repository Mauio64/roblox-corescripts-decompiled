local HttpService = game:GetService("HttpService")

local parent = script:FindFirstAncestor("DataHydration").Parent

local SharedFlags = require(parent.SharedFlags)
local FFlagBuildExperienceRemoveDevProductPriceCap = SharedFlags.FFlagBuildExperienceRemoveDevProductPriceCap
require(script.Parent.types)
local FFlagCreatorAgentChatMonetizationToolHelpers = require(script.Parent.FFlagCreatorAgentChatMonetizationToolHelpers)
local monetizationClientTool

if FFlagCreatorAgentChatMonetizationToolHelpers then
	monetizationClientTool = require(script.Parent.monetizationClientTool)
else
	monetizationClientTool = nil
end

local v = {
	create = true,
	list = true,
	update = true,
	activate = true,
	deactivate = true
}

local function valueLooksLikeToolName(value): boolean -- 4 equivalent calls inferred from this helper
	return typeof(value) == "string" and string.lower(value) == "manage_developer_product"
end

local function toolCallLooksLikeRequest(toolCall)
	if FFlagCreatorAgentChatMonetizationToolHelpers then
		return monetizationClientTool.toolCallLooksLikeRequest(toolCall, "manage_developer_product")
	end

	if valueLooksLikeToolName(toolCall.kind) then -- inferred equivalent call
		return true
	end

	if valueLooksLikeToolName(toolCall.title) then -- inferred equivalent call
		return true
	end

	local rawInput = toolCall.rawInput

	if typeof(rawInput) ~= "table" then
		return false
	end

	return valueLooksLikeToolName(rawInput.name) or valueLooksLikeToolName(rawInput.toolName) -- inferred equivalent call
end

local function parseInteger(p) -- 3 equivalent calls inferred from this helper
	local v2 = tonumber(p)
	return if not (v2 == nil or v2 % 1 ~= 0) then v2 else nil
end

local function hasPersistedToolResult(toolCall): boolean
	if toolCall.content == nil then
		return false
	end

	for _, v2 in toolCall.content do
		if not (v2.type == "content" and v2.content ~= nil) then
			continue
		end

		local content = v2.content

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

local StudioManageDevProductTool = {}
StudioManageDevProductTool.TOOL_NAME = "manage_developer_product"
StudioManageDevProductTool.LOCAL_TOOL_DEFINITION = {
	name = "manage_developer_product",
	inputSchema = {
		type = "object",
		additionalProperties = false,
		required = { "action" },
		properties = {
			action = {
				type = "string",
				enum = { "create", "list", "update", "activate", "deactivate" }
			},
			name = { type = "string" },
			description = { type = "string" },
			priceInRobux = {
				type = "integer",
				minimum = 1,
				maximum = not FFlagBuildExperienceRemoveDevProductPriceCap and 100 or nil
			},
			productId = { type = "integer" },
			imageAssetId = { type = "integer", minimum = 1 }
		}
	}
}
StudioManageDevProductTool.toolCallLooksLikeRequest = toolCallLooksLikeRequest

function StudioManageDevProductTool.findManageDevProductRequestInTurnState(p, p2)
	if FFlagCreatorAgentChatMonetizationToolHelpers then
		return monetizationClientTool.findRequestInTurnState(p, "manage_developer_product", p2)
	end

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

		if
			(toolCall.status == nil or toolCall.status == "pending" or toolCall.status == "in_progress")
			and not hasPersistedToolResult(toolCall)
			and toolCallLooksLikeRequest(toolCall)
		then
			return v3, toolCall.rawInput, toolCall.turnId, toolCall.referenceId
		end
	end

	return nil, nil, nil, nil
end

function StudioManageDevProductTool.parseManageDevProductInput(data)
	if typeof(data) ~= "table" then
		return nil
	end

	local action = data.action

	if typeof(action) ~= "string" then
		return nil
	end

	local action2 = string.lower(action)

	if not v[action2] then
		return nil
	end

	local v2 = { action = action2 }

	if typeof(data.name) == "string" then
		v2.name = data.name
	end

	if typeof(data.description) == "string" then
		v2.description = data.description
	end

	if data.priceInRobux ~= nil then
		local priceInRobux = parseInteger(data.priceInRobux) -- inferred equivalent call

		if
			priceInRobux == nil
			or priceInRobux < 1
			or not FFlagBuildExperienceRemoveDevProductPriceCap and priceInRobux > 100
		then
			return nil
		end

		v2.priceInRobux = priceInRobux
	end

	local productId = parseInteger(data.productId) -- inferred equivalent call

	if productId ~= nil then
		v2.productId = productId
	end

	if data.imageAssetId ~= nil then
		local imageAssetId = parseInteger(data.imageAssetId) -- inferred equivalent call

		if imageAssetId == nil or imageAssetId < 1 or action2 ~= "create" then
			return nil
		end

		v2.imageAssetId = imageAssetId
	end

	if action2 == "create" then
		if v2.name == nil or v2.name == "" or v2.priceInRobux == nil then
			return nil
		end
	elseif action2 == "update" then
		if v2.productId == nil or v2.name == nil and v2.description == nil and v2.priceInRobux == nil then
			return nil
		end
	elseif (action2 == "activate" or action2 == "deactivate") and v2.productId == nil then
		return nil
	end

	return v2
end

function StudioManageDevProductTool.getActionKind(p: string)
	if FFlagCreatorAgentChatMonetizationToolHelpers then
		return monetizationClientTool.getActionKind(p)
	end

	return if p == "list" then "read" else "mutation"
end

function StudioManageDevProductTool.formatResultContent(p)
	if FFlagCreatorAgentChatMonetizationToolHelpers then
		return monetizationClientTool.formatResultContent(p)
	end

	local action = (typeof(p) ~= "table" or typeof(p.action) ~= "string") and "unknown" or p.action

	local success, result = pcall(HttpService.JSONEncode, HttpService, p)

	if not success then
		return {
			text = HttpService:JSONEncode({
				status = "error",
				action = action,
				detailCode = "result_serialization_failed",
				message = "The client tool result could not be serialized."
			})
		}, true
	end

	if #result > 524288 then
		return {
			text = HttpService:JSONEncode({
				status = "error",
				action = action,
				detailCode = "result_too_large",
				message = "The client tool result exceeded the response size limit."
			})
		}, true
	end

	return { text = result }, false
end

function StudioManageDevProductTool.formatRejectionContent(action: string, feedbackText: string?)
	if FFlagCreatorAgentChatMonetizationToolHelpers then
		return monetizationClientTool.formatRejectionContent(action, feedbackText)
	end

	return {
		text = HttpService:JSONEncode({
			status = "cancelled",
			action = action,
			accepted = false,
			message = "The creator declined the change.",
			feedbackText = feedbackText
		})
	}
end

return StudioManageDevProductTool
