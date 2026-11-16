local HttpService = game:GetService("HttpService")

local fFlagBuildExperienceRemoveDevProductPriceCap = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/SharedFlags").FFlagBuildExperienceRemoveDevProductPriceCap
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/types")
local FFlagCreatorAgentChatMonetizationToolHelpers = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/FFlagCreatorAgentChatMonetizationToolHelpers")

local v5 = if FFlagCreatorAgentChatMonetizationToolHelpers then require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/monetizationClientTool") else nil

local v6 = {
	create = true,
	list = true,
	update = true,
	activate = true,
	deactivate = true
}

local function valueLooksLikeToolName(value): boolean
	return typeof(value) == "string" and string.lower(value) == "manage_developer_product"
end

local function toolCallLooksLikeRequest(toolCall)
	if FFlagCreatorAgentChatMonetizationToolHelpers then
		return v5.toolCallLooksLikeRequest(toolCall, "manage_developer_product")
	end

	local kind = toolCall.kind
	local v7 = typeof(kind) == "string" and string.lower(kind) == "manage_developer_product"

	if v7 then
		return true
	end

	local title = toolCall.title
	local v8 = typeof(title) == "string" and string.lower(title) == "manage_developer_product"

	if v8 then
		return true
	end

	local rawInput = toolCall.rawInput

	if typeof(rawInput) ~= "table" then
		return false
	end

	local name = rawInput.name
	local v9 = typeof(name) == "string" and string.lower(name) == "manage_developer_product"

	if v9 then
		return v9
	end

	local toolName = rawInput.toolName
	v9 = typeof(toolName) == "string" and string.lower(toolName) == "manage_developer_product"
	return v9
end

local function parseInteger(p2)
	local v7 = tonumber(p2)

	if v7 == nil or v7 % 1 ~= 0 then
		return nil
	end

	return v7
end

local function hasPersistedToolResult(toolCall): boolean
	if toolCall.content == nil then
		return false
	end

	for k, v7 in toolCall.content do
		if not (v7.type == "content" and v7.content ~= nil) then
			continue
		end

		local content = v7.content

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

return {
	TOOL_NAME = "manage_developer_product",
	LOCAL_TOOL_DEFINITION = {
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
					maximum = not fFlagBuildExperienceRemoveDevProductPriceCap and 100 or nil
				},
				productId = { type = "integer" },
				imageAssetId = { type = "integer", minimum = 1 }
			}
		}
	},
	toolCallLooksLikeRequest = toolCallLooksLikeRequest,
	findManageDevProductRequestInTurnState = function(p2, p3)
		if FFlagCreatorAgentChatMonetizationToolHelpers then
			return v5.findRequestInTurnState(p2, "manage_developer_product", p3)
		end

		local v7 = {}

		for k in p2.toolCalls do
			table.insert(v7, k)
		end

		table.sort(v7)

		for k, v8 in v7 do
			if p3 and p3[v8] then
				continue
			end

			local toolCall = p2.toolCalls[v8]

			if
				(toolCall.status == nil or toolCall.status == "pending" or toolCall.status == "in_progress")
				and not hasPersistedToolResult(toolCall)
				and toolCallLooksLikeRequest(toolCall)
			then
				return v8, toolCall.rawInput, toolCall.turnId, toolCall.referenceId
			end
		end

		return nil, nil, nil, nil
	end,
	parseManageDevProductInput = function(data)
		if typeof(data) ~= "table" then
			return nil
		end

		local action = data.action

		if typeof(action) ~= "string" then
			return nil
		end

		local v7 = string.lower(action)

		if not v6[v7] then
			return nil
		end

		local v8 = { action = v7 }

		if typeof(data.name) == "string" then
			v8.name = data.name
		end

		if typeof(data.description) == "string" then
			v8.description = data.description
		end

		if data.priceInRobux ~= nil then
			local priceInRobux = tonumber(data.priceInRobux)

			if priceInRobux == nil or priceInRobux % 1 ~= 0 then
				priceInRobux = nil
			end

			if
				priceInRobux == nil
				or priceInRobux < 1
				or not fFlagBuildExperienceRemoveDevProductPriceCap and priceInRobux > 100
			then
				return nil
			end

			v8.priceInRobux = priceInRobux
		end

		local productId = tonumber(data.productId)

		if productId == nil or productId % 1 ~= 0 then
			productId = nil
		end

		if productId ~= nil then
			v8.productId = productId
		end

		if data.imageAssetId ~= nil then
			local imageAssetId = tonumber(data.imageAssetId)

			if imageAssetId == nil or imageAssetId % 1 ~= 0 then
				imageAssetId = nil
			end

			if imageAssetId == nil or imageAssetId < 1 or v7 ~= "create" then
				return nil
			end

			v8.imageAssetId = imageAssetId
		end

		if v7 == "create" then
			if v8.name == nil or v8.name == "" or v8.priceInRobux == nil then
				return nil
			end
		elseif v7 == "update" then
			if
				v8.productId == nil
				or v8.name == nil and v8.description == nil and v8.priceInRobux == nil
			then
				return nil
			end
		elseif (v7 == "activate" or v7 == "deactivate") and v8.productId == nil then
			return nil
		end

		return v8
	end,
	getActionKind = function(p2)
		if FFlagCreatorAgentChatMonetizationToolHelpers then
			return v5.getActionKind(p2)
		end

		if p2 == "list" then
			return "read"
		end

		return "mutation"
	end,
	formatResultContent = function(p2)
		if FFlagCreatorAgentChatMonetizationToolHelpers then
			return v5.formatResultContent(p2)
		end

		local v7 = (typeof(p2) ~= "table" or typeof(p2.action) ~= "string") and "unknown" or p2.action

		local success, result = pcall(HttpService.JSONEncode, HttpService, p2)

		if not success then
			return {
				text = HttpService:JSONEncode({
					status = "error",
					action = v7,
					detailCode = "result_serialization_failed",
					message = "The client tool result could not be serialized."
				})
			}, true
		end

		if #result > 524288 then
			return {
				text = HttpService:JSONEncode({
					status = "error",
					action = v7,
					detailCode = "result_too_large",
					message = "The client tool result exceeded the response size limit."
				})
			}, true
		end

		return { text = result }, false
	end,
	formatRejectionContent = function(p2, p3)
		if FFlagCreatorAgentChatMonetizationToolHelpers then
			return v5.formatRejectionContent(p2, p3)
		end

		return {
			text = HttpService:JSONEncode({
				status = "cancelled",
				action = p2,
				accepted = false,
				message = "The creator declined the change.",
				feedbackText = p3
			})
		}
	end
}
