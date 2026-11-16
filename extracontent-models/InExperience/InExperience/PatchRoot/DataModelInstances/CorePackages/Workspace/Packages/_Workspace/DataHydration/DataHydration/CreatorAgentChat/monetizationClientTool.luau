local HttpService = game:GetService("HttpService")

require(script.Parent.types)

local function valueIs(value, p: string): boolean -- 4 equivalent calls inferred from this helper
	return typeof(value) == "string" and string.lower(value) == p
end

local function toolCallLooksLikeRequest(toolCall, p: string)
	if valueIs(toolCall.kind, p) then -- inferred equivalent call
		return true
	end

	if not valueIs(toolCall.title, p) then -- inferred equivalent call
		local rawInput = toolCall.rawInput
		return typeof(rawInput) == "table" and (valueIs(rawInput.name, p) or valueIs(rawInput.toolName, p)) -- inferred equivalent call
	end

	return true
end

local function hasPersistedToolResult(toolCall): boolean
	if toolCall.content == nil then
		return false
	end

	for _, v in toolCall.content do
		local content = v.content

		if not (v.type == "content" and content ~= nil and content.type == "text" and typeof(content.text) == "string") then
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

local function parseInteger(p) -- 2 equivalent calls inferred from this helper
	local v = tonumber(p)
	return if not (v == nil or v % 1 ~= 0) then v else nil
end

local MonetizationClientTool = {}
MonetizationClientTool.MAXIMUM_SAFE_INTEGER = 9007199254740991
MonetizationClientTool.toolCallLooksLikeRequest = toolCallLooksLikeRequest
MonetizationClientTool.findRequestInTurnState = findRequestInTurnState

function MonetizationClientTool.parsePositiveSafeInteger(p)
	local integer = parseInteger(p) -- inferred equivalent call

	if integer == nil or integer < 1 or integer > 9007199254740991 then
		return nil
	end

	return integer
end

function MonetizationClientTool.parsePrice(p, p2: number, p3: number)
	if p == nil then
		return nil, nil
	end

	local integer = parseInteger(p) -- inferred equivalent call

	if integer == nil or integer < p2 or p3 < integer then
		return nil, ("priceInRobux must be a whole number from %.0f through %.0f."):format(p2, p3)
	end

	return integer, nil
end

function MonetizationClientTool.parseCreateAndGoLive(p, p2: string)
	if p == nil then
		return nil, nil
	end

	if p2 == "create" and typeof(p) == "boolean" then
		return p and true or nil, nil
	end

	return nil, "createAndGoLive must be a boolean on create."
end

function MonetizationClientTool.parseAction(p, list)
	if typeof(p) ~= "table" or typeof(p.action) ~= "string" then
		return nil, "An action is required."
	end

	local action = string.lower(p.action)

	if table.find(list, action) then
		return action, nil
	end

	return nil, ("Unsupported action '%s'."):format(p.action)
end

function MonetizationClientTool.checkStringFields(p, items)
	for _, item in items do
		if p[item] ~= nil and typeof(p[item]) ~= "string" then
			return ("%s must be a string."):format(item)
		end
	end

	return nil
end

function MonetizationClientTool.createRequestFinder(p: string)
	return function(p2, p3)
		return findRequestInTurnState(p2, p, p3)
	end
end

function MonetizationClientTool.formatResultContent(p)
	local action = (typeof(p) ~= "table" or typeof(p.action) ~= "string") and "unknown" or p.action
	local kind

	if typeof(p) == "table" and typeof(p.kind) == "string" then
		kind = p.kind
	end

	local success, result = pcall(HttpService.JSONEncode, HttpService, p)

	if success and not (#result > 524288) then
		return { text = result }, false
	end

	return {
		text = HttpService:JSONEncode({
			status = "error",
			kind = kind,
			action = action,
			detailCode = success and "result_too_large" or "result_serialization_failed",
			message = success and "The client tool result exceeded the response size limit." or "The client tool result could not be serialized."
		})
	}, true
end

function MonetizationClientTool.formatRejectionContent(action: string, feedbackText: string?, kind: string?)
	return {
		text = HttpService:JSONEncode({
			status = "cancelled",
			kind = kind,
			action = action,
			accepted = false,
			message = "The creator declined the change.",
			feedbackText = feedbackText
		})
	}
end

function MonetizationClientTool.getActionKind(p: string): string
	return if p == "list" then "read" else "mutation"
end

return MonetizationClientTool
