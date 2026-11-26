require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/types")
local HttpService = game:GetService("HttpService")

local v5 = {
	single_select = "single_select",
	multi_select = "multi_select",
	free_text = "free_text"
}

local function valueLooksLikeToolName(value): boolean
	return typeof(value) == "string" and string.lower(value) == "ask_user"
end

local function getQuestionsPayload(p2)
	if typeof(p2) ~= "table" then
		return nil
	end

	if typeof(p2[1]) == "table" then
		return p2
	end

	if typeof(p2.questions) == "table" then
		return p2.questions
	end

	if typeof(p2.data) == "table" then
		return p2.data
	end

	return nil
end

local function resolveResponseType(value, p2)
	local v6 = if typeof(value) == "string" then v5[value] else nil

	if v6 ~= nil then
		return v6
	end

	if p2 > 0 then
		return "single_select"
	end

	return "free_text"
end

local function toAnswerQuestions(rawInput)
	if typeof(rawInput) == "table" then
		if typeof(rawInput[1]) ~= "table" then
			if typeof(rawInput.questions) == "table" then
				rawInput = rawInput.questions
			else
				rawInput = if typeof(rawInput.data) == "table" then rawInput.data else nil
			end
		end
	else
		rawInput = nil
	end

	if typeof(rawInput) ~= "table" then
		return nil
	end

	local result = {}

	for k, v6 in rawInput do
		if not (typeof(v6) == "table" and typeof(v6.question) == "string") then
			continue
		end

		local v7 = {}
		local options = v6.options

		if typeof(options) == "table" then
			for k2, option in options do
				if not (typeof(option) == "table" and typeof(option.optionText) == "string") then
					continue
				end

				table.insert(v7, {
					id = `q{k}-o{k2}`,
					title = option.optionText,
					description = typeof(option.clarificationText) ~= "string" and "" or option.clarificationText
				})
			end
		end

		local v8 = {
			id = `q{k}`,
			question = v6.question,
			options = v7,
			responseType = 0
		}

		local responseType = v6.responseType
		local v9 = #v7
		local v10 = if typeof(responseType) == "string" then v5[responseType] else nil

		v8.responseType = v10 == nil and (v9 > 0 and "single_select" or "free_text") or v10
		table.insert(result, v8)
	end

	if #result > 0 then
		return result
	end

	return nil
end

local function extractQuestionsFromToolCall(toolCall)
	local v6 = toAnswerQuestions(toolCall.rawInput)

	if v6 == nil then
		return nil
	end

	local kind = toolCall.kind
	local v7 = typeof(kind) == "string" and string.lower(kind) == "ask_user"

	if v7 then
		return v6
	end

	local title = toolCall.title
	local v8 = typeof(title) == "string" and string.lower(title) == "ask_user"

	if v8 then
		return v6
	end

	local rawInput = toolCall.rawInput

	if typeof(rawInput) ~= "table" then
		return nil
	end

	local name = rawInput.name
	local v9 = typeof(name) == "string" and string.lower(name) == "ask_user"

	if v9 then
		return v6
	end

	local toolName = rawInput.toolName
	local v10 = typeof(toolName) == "string" and string.lower(toolName) == "ask_user"

	if not v10 then
		return nil
	end

	return v6
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

	for k, v6 in toolCall.content do
		if not (v6.type == "content" and v6.content ~= nil) then
			continue
		end

		local content = v6.content

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

local function formatToolResultText(items)
	local v6 = {}

	for k, item in items do
		local options = item.options

		if options == nil or not (#options > 0) then
			if item.option == nil then
				if item.customResponseText ~= nil then
					table.insert(v6, {
						questionId = item.question.id,
						content = item.customResponseText
					})
				end
			else
				local option = item.option
				table.insert(v6, {
					questionId = item.question.id,
					selectedOptionId = option.id,
					content = option.title
				})
			end
		else
			local ids = {}
			local titles = {}

			for k2, option in options do
				table.insert(ids, option.id)
				table.insert(titles, option.title)
			end

			table.insert(v6, {
				questionId = item.question.id,
				selectedOptionId = ids,
				content = table.concat(titles, ", ")
			})
		end
	end

	return HttpService:JSONEncode({ answers = v6 })
end

local function findSelectedOptionById(p2, p3)
	if p3 == nil then
		return nil
	end

	for k, option in p2.options do
		if option.id == p3 then
			return option
		end
	end

	return nil
end

local function findSelectedOptionsByIds(p2, selectedOptionId)
	local optionsById = {}

	for k, option in p2.options do
		optionsById[option.id] = option
	end

	local result = {}

	for k, item in selectedOptionId do
		local v6 = optionsById[item]

		if v6 == nil then
			return nil
		end

		table.insert(result, v6)
	end

	return result
end

local function normalizeSelectedOptionId(selectedOptionId)
	if typeof(selectedOptionId) == "string" then
		return selectedOptionId
	end

	if typeof(selectedOptionId) ~= "table" then
		return nil
	end

	local result = {}

	for k, item in selectedOptionId do
		if typeof(item) ~= "string" then
			return nil
		end

		table.insert(result, item)
	end

	if #result > 0 then
		return result
	end

	return nil
end

local function getAnswersByQuestionId(persistedToolResultText)
	local answers = {}
	local success, result = pcall(HttpService.JSONDecode, HttpService, persistedToolResultText)

	if not success or typeof(result) ~= "table" then
		return answers
	end

	local answers2 = result.answers

	if typeof(answers2) ~= "table" then
		return answers
	end

	for k, answer in answers2 do
		if not (typeof(answer) == "table" and typeof(answer.questionId) == "string" and typeof(answer.content) == "string") then
			continue
		end

		answers[answer.questionId] = {
			questionId = answer.questionId,
			selectedOptionId = normalizeSelectedOptionId(answer.selectedOptionId),
			content = answer.content
		}
	end

	return answers
end

local function getPromptFromToolResult(p2, p3, toolCallId, callOrder)
	if p3 == nil then
		return nil
	end

	local selectedOptionId = p3.selectedOptionId

	if typeof(selectedOptionId) == "table" then
		if findSelectedOptionsByIds(p2, selectedOptionId) == nil then
			return nil
		end

		return {
			question = p2,
			selectedOptionId = selectedOptionId,
			toolCallId = toolCallId,
			callOrder = callOrder
		}
	else
		local v6

		if selectedOptionId ~= nil then
			for k, option in p2.options do
				if option.id == selectedOptionId then
					v6 = option
					break
				end
			end
		end

		if selectedOptionId ~= nil and v6 == nil then
			return nil
		end

		local content = if v6 == nil then p3.content else nil

		local v8 = if v6 ~= nil then v6.id else nil
		return {
			question = p2,
			selectedOptionId = v8,
			customResponseText = content,
			toolCallId = toolCallId,
			callOrder = callOrder
		}
	end
end

local function getToolCallOrder(p2, p3)
	if p2.activityItems ~= nil then
		for k, activityItem in p2.activityItems do
			if activityItem.kind == "tool_call" and activityItem.toolCallId == p3 then
				return k
			end
		end
	end

	local v6 = {}

	for k in p2.toolCalls do
		table.insert(v6, k)
	end

	table.sort(v6)

	for k, v7 in v6 do
		if v7 == p3 then
			return k
		end
	end

	return 0
end

return {
	TOOL_NAME = "ask_user",
	LOCAL_TOOL_DEFINITION = {
		name = "ask_user",
		inputSchema = {
			type = "array",
			items = {
				type = "object",
				required = { "question", "options" },
				properties = {
					question = { type = "string" },
					responseType = {
						type = "string",
						enum = { "single_select", "multi_select", "free_text" }
					},
					options = {
						type = "array",
						items = {
							type = "object",
							required = { "optionText" },
							properties = {
								optionText = { type = "string" },
								clarificationText = { type = "string" }
							}
						}
					}
				}
			}
		}
	},
	CANCELLATION_TEXT = "User cancelled answering the question",
	extractQuestionsFromToolCall = extractQuestionsFromToolCall,
	findQuestionsInTurnState = function(p2, p3)
		local v6 = {}

		for k in p2.toolCalls do
			table.insert(v6, k)
		end

		table.sort(v6)

		for k, v7 in v6 do
			if p3 and p3[v7] then
				continue
			end

			local toolCall = p2.toolCalls[v7]

			if not (toolCall.status ~= "completed" and toolCall.status ~= "failed" and toolCall.status ~= "cancelled" and getPersistedToolResultText(toolCall) == nil) then
				continue
			end

			local v8 = extractQuestionsFromToolCall(toolCall)

			if v8 ~= nil then
				return v8, v7, toolCall.rawInput, toolCall.turnId, toolCall.referenceId
			end
		end

		return nil, nil, nil, nil, nil
	end,
	formatToolResultText = formatToolResultText,
	formatToolResultContent = function(p2)
		return { text = formatToolResultText(p2) }
	end,
	getAnsweredPromptsFromTurnState = function(p2)
		local v6 = {}
		local promptFromToolResults = {}

		for k in p2.toolCalls do
			table.insert(v6, k)
		end

		table.sort(v6)

		for k, v7 in v6 do
			local toolCall = p2.toolCalls[v7]
			local v8 = extractQuestionsFromToolCall(toolCall)
			local persistedToolResultText = getPersistedToolResultText(toolCall)

			if not (v8 ~= nil and persistedToolResultText ~= nil) then
				continue
			end

			local answersByQuestionId = getAnswersByQuestionId(persistedToolResultText)

			for k2, v9 in v8 do
				local promptFromToolResult = getPromptFromToolResult(
					v9,
					answersByQuestionId[v9.id],
					v7,
					getToolCallOrder(p2, v7)
				)

				if promptFromToolResult ~= nil then
					table.insert(promptFromToolResults, promptFromToolResult)
				end
			end
		end

		return promptFromToolResults
	end,
	formatCancellationContent = function()
		return { text = "User cancelled answering the question" }
	end
}
