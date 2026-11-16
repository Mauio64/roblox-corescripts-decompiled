require(script.Parent.types)
local HttpService = game:GetService("HttpService")

local v = {
	single_select = "single_select",
	multi_select = "multi_select",
	free_text = "free_text"
}

local function valueLooksLikeToolName(value): boolean -- 4 equivalent calls inferred from this helper
	return typeof(value) == "string" and string.lower(value) == "ask_user"
end

local function getQuestionsPayload(items) -- 1 equivalent call inferred from this helper
	if typeof(items) ~= "table" then
		return nil
	end

	if typeof(items[1]) == "table" then
		return items
	end

	if typeof(items.questions) == "table" then
		return items.questions
	end

	return if typeof(items.data) == "table" then items.data else nil
end

local function resolveResponseType(responseType, p: number) -- 1 equivalent call inferred from this helper
	local selected

	if typeof(responseType) == "string" then
		selected = v[responseType]
	end

	if selected ~= nil then
		return selected
	end

	return if p > 0 then "single_select" else "free_text"
end

local function toAnswerQuestions(rawInput)
	rawInput = getQuestionsPayload(rawInput) -- inferred equivalent call

	if typeof(rawInput) ~= "table" then
		return nil
	end

	local result = {}

	for k, item in rawInput do
		if not (typeof(item) == "table" and typeof(item.question) == "string") then
			continue
		end

		local options2 = {}
		local options = item.options

		if typeof(options) == "table" then
			for k2, option in options do
				if not (typeof(option) == "table" and typeof(option.optionText) == "string") then
					continue
				end

				table.insert(options2, {
					id = `q{k}-o{k2}`,
					title = option.optionText,
					description = typeof(option.clarificationText) ~= "string" and "" or option.clarificationText
				})
			end
		end

		local v2 = {
			id = `q{k}`,
			question = item.question,
			options = options2,
			responseType = resolveResponseType(item.responseType, #options2) -- inferred equivalent call
		}
		table.insert(result, v2)
	end

	return if #result > 0 then result else nil
end

local function extractQuestionsFromToolCall(toolCall)
	local v2 = toAnswerQuestions(toolCall.rawInput)

	if v2 == nil then
		return nil
	end

	if valueLooksLikeToolName(toolCall.kind) then -- inferred equivalent call
		return v2
	end

	if valueLooksLikeToolName(toolCall.title) then -- inferred equivalent call
		return v2
	end

	local rawInput = toolCall.rawInput

	if
		typeof(rawInput) ~= "table"
		or not valueLooksLikeToolName(rawInput.name) and not valueLooksLikeToolName(rawInput.toolName) -- inferred equivalent call
	then
		return nil
	end

	return v2
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

	for _, v2 in toolCall.content do
		if not (v2.type == "content" and v2.content ~= nil) then
			continue
		end

		local content = v2.content

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
	local answers = {}

	for _, item in items do
		local options = item.options

		if options == nil or not (#options > 0) then
			if item.option == nil then
				if item.customResponseText ~= nil then
					table.insert(answers, {
						questionId = item.question.id,
						content = item.customResponseText
					})
				end
			else
				local option = item.option
				table.insert(answers, {
					questionId = item.question.id,
					selectedOptionId = option.id,
					content = option.title
				})
			end
		else
			local ids = {}
			local titles = {}

			for _, option in options do
				table.insert(ids, option.id)
				table.insert(titles, option.title)
			end

			table.insert(answers, {
				questionId = item.question.id,
				selectedOptionId = ids,
				content = table.concat(titles, ", ")
			})
		end
	end

	return HttpService:JSONEncode({ answers = answers })
end

local function findSelectedOptionById(p, selectedOptionId: string?) -- 1 equivalent call inferred from this helper
	if selectedOptionId == nil then
		return nil
	end

	for _, option in p.options do
		if option.id == selectedOptionId then
			return option
		end
	end

	return nil
end

local function findSelectedOptionsByIds(p, selectedOptionId)
	local optionsById = {}

	for _, option in p.options do
		optionsById[option.id] = option
	end

	local result = {}

	for _, item in selectedOptionId do
		local v2 = optionsById[item]

		if v2 == nil then
			return nil
		end

		table.insert(result, v2)
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

	for _, item in selectedOptionId do
		if typeof(item) ~= "string" then
			return nil
		end

		table.insert(result, item)
	end

	return if #result > 0 then result else nil
end

local function getAnswersByQuestionId(persistedToolResultText: string)
	local answers = {}
	local success, result = pcall(HttpService.JSONDecode, HttpService, persistedToolResultText)

	if not success or typeof(result) ~= "table" then
		return answers
	end

	local answers2 = result.answers

	if typeof(answers2) ~= "table" then
		return answers
	end

	for _, answer in answers2 do
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

local function getPromptFromToolResult(question, p, toolCallId: string, callOrder: number)
	if p == nil then
		return nil
	end

	local selectedOptionId = p.selectedOptionId

	if typeof(selectedOptionId) == "table" then
		if findSelectedOptionsByIds(question, selectedOptionId) == nil then
			return nil
		end

		return {
			question = question,
			selectedOptionId = selectedOptionId,
			toolCallId = toolCallId,
			callOrder = callOrder
		}
	else
		local selectedOptionById = findSelectedOptionById(question, selectedOptionId) -- inferred equivalent call

		if selectedOptionId ~= nil and selectedOptionById == nil then
			return nil
		end

		local content

		if selectedOptionById == nil then
			content = p.content
		end

		local selectedOptionId2

		if selectedOptionById ~= nil then
			selectedOptionId2 = selectedOptionById.id
		end

		return {
			question = question,
			selectedOptionId = selectedOptionId2,
			customResponseText = content,
			toolCallId = toolCallId,
			callOrder = callOrder
		}
	end
end

local function getToolCallOrder(p, p2: string)
	if p.activityItems ~= nil then
		for k, activityItem in p.activityItems do
			if activityItem.kind == "tool_call" and activityItem.toolCallId == p2 then
				return k
			end
		end
	end

	local v2 = {}

	for k in p.toolCalls do
		table.insert(v2, k)
	end

	table.sort(v2)

	for k, v3 in v2 do
		if v3 == p2 then
			return k
		end
	end

	return 0
end

local StudioAskUserTool = {}
StudioAskUserTool.TOOL_NAME = "ask_user"
StudioAskUserTool.LOCAL_TOOL_DEFINITION = {
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
}
StudioAskUserTool.CANCELLATION_TEXT = "User cancelled answering the question"
StudioAskUserTool.extractQuestionsFromToolCall = extractQuestionsFromToolCall

function StudioAskUserTool.findQuestionsInTurnState(p, p2)
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

		if not (toolCall.status ~= "completed" and toolCall.status ~= "failed" and toolCall.status ~= "cancelled" and getPersistedToolResultText(toolCall) == nil) then
			continue
		end

		local v4 = extractQuestionsFromToolCall(toolCall)

		if v4 ~= nil then
			return v4, v3, toolCall.rawInput, toolCall.turnId, toolCall.referenceId
		end
	end

	return nil, nil, nil, nil, nil
end

StudioAskUserTool.formatToolResultText = formatToolResultText

function StudioAskUserTool.formatToolResultContent(p)
	return { text = formatToolResultText(p) }
end

function StudioAskUserTool.getAnsweredPromptsFromTurnState(p)
	local v2 = {}
	local promptFromToolResults = {}

	for k in p.toolCalls do
		table.insert(v2, k)
	end

	table.sort(v2)

	for _, v3 in v2 do
		local toolCall = p.toolCalls[v3]
		local v4 = extractQuestionsFromToolCall(toolCall)
		local persistedToolResultText = getPersistedToolResultText(toolCall)

		if not (v4 ~= nil and persistedToolResultText ~= nil) then
			continue
		end

		local answersByQuestionId = getAnswersByQuestionId(persistedToolResultText)

		for _, v5 in v4 do
			local promptFromToolResult = getPromptFromToolResult(
				v5,
				answersByQuestionId[v5.id],
				v3,
				getToolCallOrder(p, v3)
			)

			if promptFromToolResult ~= nil then
				table.insert(promptFromToolResults, promptFromToolResult)
			end
		end
	end

	return promptFromToolResults
end

function StudioAskUserTool.formatCancellationContent()
	return { text = "User cancelled answering the question" }
end

return StudioAskUserTool
