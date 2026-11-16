local HttpService = game:GetService("HttpService")

require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/types")

local function valueIs(value, p2): boolean
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
		local content = v5.content

		if not (v5.type == "content" and content ~= nil and content.type == "text" and typeof(content.text) == "string") then
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

local function parseInteger(p2)
	local v5 = tonumber(p2)

	if v5 == nil or v5 % 1 ~= 0 then
		return nil
	end

	return v5
end

return {
	MAXIMUM_SAFE_INTEGER = 9007199254740991,
	toolCallLooksLikeRequest = toolCallLooksLikeRequest,
	findRequestInTurnState = findRequestInTurnState,
	parsePositiveSafeInteger = function(p2)
		local v5 = tonumber(p2)

		if v5 == nil or v5 % 1 ~= 0 then
			v5 = nil
		end

		if v5 == nil or v5 < 1 or v5 > 9007199254740991 then
			return nil
		end

		return v5
	end,
	parsePrice = function(p2, p3, p4)
		if p2 == nil then
			return nil, nil
		end

		local v5 = tonumber(p2)

		if v5 == nil or v5 % 1 ~= 0 then
			v5 = nil
		end

		if v5 == nil or v5 < p3 or p4 < v5 then
			return nil, ("priceInRobux must be a whole number from %.0f through %.0f."):format(p3, p4)
		end

		return v5, nil
	end,
	parseCreateAndGoLive = function(p2, p3)
		if p2 == nil then
			return nil, nil
		end

		if p3 == "create" and typeof(p2) == "boolean" then
			return p2 and true or nil, nil
		end

		return nil, "createAndGoLive must be a boolean on create."
	end,
	parseAction = function(p2, list)
		if typeof(p2) ~= "table" or typeof(p2.action) ~= "string" then
			return nil, "An action is required."
		end

		local action = string.lower(p2.action)

		if table.find(list, action) then
			return action, nil
		end

		return nil, ("Unsupported action '%s'."):format(p2.action)
	end,
	checkStringFields = function(p2, items)
		for k, item in items do
			if p2[item] ~= nil and typeof(p2[item]) ~= "string" then
				return ("%s must be a string."):format(item)
			end
		end

		return nil
	end,
	createRequestFinder = function(p2)
		return function(p3, p4)
			return findRequestInTurnState(p3, p2, p4)
		end
	end,
	formatResultContent = function(p2)
		local v5 = (typeof(p2) ~= "table" or typeof(p2.action) ~= "string") and "unknown" or p2.action

		local kind = if typeof(p2) == "table" and typeof(p2.kind) == "string" then p2.kind else nil
		local success, result = pcall(HttpService.JSONEncode, HttpService, p2)

		if success and not (#result > 524288) then
			return { text = result }, false
		end

		return {
			text = HttpService:JSONEncode({
				status = "error",
				kind = kind,
				action = v5,
				detailCode = success and "result_too_large" or "result_serialization_failed",
				message = success and "The client tool result exceeded the response size limit." or "The client tool result could not be serialized."
			})
		}, true
	end,
	formatRejectionContent = function(p2, p3, p4)
		return {
			text = HttpService:JSONEncode({
				status = "cancelled",
				kind = p4,
				action = p2,
				accepted = false,
				message = "The creator declined the change.",
				feedbackText = p3
			})
		}
	end,
	getActionKind = function(p2): string
		if p2 == "list" then
			return "read"
		end

		return "mutation"
	end
}
