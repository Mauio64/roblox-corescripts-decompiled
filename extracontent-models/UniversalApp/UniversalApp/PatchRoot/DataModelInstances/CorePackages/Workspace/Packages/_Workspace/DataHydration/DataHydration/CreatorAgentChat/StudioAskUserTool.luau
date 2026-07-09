require(script.Parent.types)

local HttpService = game:GetService("HttpService")
local t1 = {
	name = "studio_ask_user",
	inputSchema = {
		type = "array",
		items = {
			type = "object",
			required = {
				"question",
				"options"
			},
			properties = {
				question = {
					type = "string"
				},
				options = {
					type = "array",
					items = {
						type = "object",
						required = { "optionText" },
						properties = {
							optionText = {
								type = "string"
							},
							clarificationText = {
								type = "string"
							}
						}
					}
				}
			}
		}
	}
}

local function valueLooksLikeToolName(p1) -- line: 63
	return typeof(p1) == "string" and string.lower(p1) == "studio_ask_user"
end
local function getQuestionsPayload(p2) -- line: 67
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
local function toAnswerQuestions(p3) -- line: 87
	local v17 = if typeof(p3) == "table" then if typeof(p3[1]) ~= "table" then if typeof(p3.questions) ~= "table" then if typeof(p3.data) ~= "table" then nil else p3.data else p3.questions else p3 else nil

	if typeof(v17) ~= "table" then
		return nil
	end

	local t2 = {}

	for v19, v20 in v17 do
		if typeof(v20) == "table" and typeof(v20.question) == "string" then
			local t3 = {}
			local options = v20.options

			if typeof(options) == "table" then
				for v23, v24 in options do
					if typeof(v24) == "table" and typeof(v24.optionText) == "string" then
						table.insert(t3, {
							id = `q{ v19 }-o{ v23 }`,
							title = v24.optionText,
							description = typeof(v24.clarificationText) ~= "string" and "" or v24.clarificationText
						})
					end
				end
			end

			table.insert(t2, {
				id = `q{ v19 }`,
				question = v20.question,
				options = t3
			})
		end
	end

	if #t2 > 0 then
		return t2
	end

	return nil
end
local function extractQuestionsFromToolCall(p4) -- line: 123
	-- upvalues: toAnswerQuestions (copy)
	local v26 = toAnswerQuestions(p4.rawInput)

	if v26 == nil then
		return nil
	end

	local kind = p4.kind

	if typeof(kind) == "string" and string.lower(kind) == "studio_ask_user" then
		return v26
	end

	local title = p4.title

	if typeof(title) == "string" and string.lower(title) == "studio_ask_user" then
		return v26
	end

	local rawInput = p4.rawInput

	if typeof(rawInput) == "table" then
		local name = rawInput.name

		if typeof(name) == "string" and string.lower(name) == "studio_ask_user" then
			return v26
		end

		local toolName = rawInput.toolName

		if typeof(toolName) == "string" and string.lower(toolName) == "studio_ask_user" then
			return v26
		end
	end

	return v26
end
local function decodePersistedToolResultText(s1: string) -- line: 147
	-- upvalues: HttpService (copy)
	local ok, result = pcall(HttpService.JSONDecode, HttpService, s1)

	if not ok or typeof(result) ~= "table" then
		return nil
	end

	if typeof(result.text) == "string" then
		return result.text
	end

	return nil
end
local function getPersistedToolResultText(p5) -- line: 157
	-- upvalues: HttpService (copy)
	if p5.content == nil then
		return nil
	end

	local t4 = {}

	for _, v38 in p5.content do
		if v38.type == "content" and v38.content ~= nil then
			local content = v38.content

			if content.type == "text" and typeof(content.text) == "string" then
				local text = content.text
				local ok, result = pcall(HttpService.JSONDecode, HttpService, text)
				local v43 = if not not ok and typeof(result) == "table" then if typeof(result.text) ~= "string" then nil else result.text else nil

				if v43 ~= nil and v43 ~= "" then
					table.insert(t4, v43)
				end
			end
		end
	end

	if #t4 > 0 then
		return (table.concat(t4))
	end

	return nil
end
local function formatToolResultText(t5: {[any]: any}) -- line: 212
	-- upvalues: HttpService (copy)
	local t6 = {}

	for _, v55 in t5 do
		local option = v55.option

		if option ~= nil then
			table.insert(t6, {
				questionId = v55.question.id,
				selectedOptionId = option.id,
				content = option.title
			})
		elseif v55.customResponseText ~= nil then
			table.insert(t6, {
				questionId = v55.question.id,
				content = v55.customResponseText
			})
		end
	end

	return HttpService:JSONEncode({
		answers = t6
	})
end
local function findSelectedOptionById(p6, s2: string?) -- line: 240
	if s2 == nil then
		return nil
	end

	for _, v61 in p6.options do
		if s2 == v61.id then
			return v61
		end
	end

	return nil
end
local function getAnswersByQuestionId(s3: string) -- line: 252
	-- upvalues: HttpService (copy)
	local t7 = {}
	local ok, result = pcall(HttpService.JSONDecode, HttpService, s3)

	if not ok or typeof(result) ~= "table" then
		return t7
	end

	local answers = result.answers

	if typeof(answers) ~= "table" then
		return t7
	end

	for _, v68 in answers do
		if typeof(v68) == "table" and typeof(v68.questionId) == "string" and typeof(v68.content) == "string" then
			t7[v68.questionId] = v68
		end
	end

	return t7
end
local function getPromptFromToolResult(p7, t8: {[any]: any}?, s4: string, n1: number) -- line: 275
	if t8 == nil then
		return nil
	end

	local selectedOptionId = t8.selectedOptionId
	local v74, g77

	if selectedOptionId == nil then
		v74 = nil
	else
		g77 = nil
		v74 = nil

		for _, v76 in p7.options do
			if selectedOptionId == v76.id then
				v74 = v76
				g77 = true
			end

			if g77 then
				break
			end
		end

		if not g77 then
			v74 = nil
		end
	end

	g77 = false

	if t8.selectedOptionId ~= nil and v74 == nil then
		return nil
	end

	local v78 = if v74 ~= nil then nil else t8.content

	return {
		question = p7,
		selectedOptionId = if v74 == nil then nil else v74.id,
		customResponseText = v78,
		toolCallId = s4,
		callOrder = n1
	}
end
local function getToolCallOrder(p8, s5: string) -- line: 299
	if p8.activityItems ~= nil then
		for v81, v82 in p8.activityItems do
			if v82.kind == "tool_call" and s5 == v82.toolCallId then
				return v81
			end
		end
	end

	local t9 = {}

	for v84 in p8.toolCalls do
		table.insert(t9, v84)
	end

	table.sort(t9)

	for v85, v86 in t9 do
		if v86 == s5 then
			return v85
		end
	end

	return 0
end

return {
	TOOL_NAME = "studio_ask_user",
	CANCELLATION_TEXT = "User cancelled answering the question",
	LOCAL_TOOL_DEFINITION = t1,
	extractQuestionsFromToolCall = extractQuestionsFromToolCall,
	findQuestionsInTurnState = function(p9, t10: {[any]: any}?) -- line: 185
		-- upvalues: getPersistedToolResultText (copy), extractQuestionsFromToolCall (copy)
		local t11 = {}

		for v47 in p9.toolCalls do
			table.insert(t11, v47)
		end

		table.sort(t11)

		for _, v49 in t11 do
			if t10 and t10[v49] then
				continue
			end

			local v50 = p9.toolCalls[v49]

			if getPersistedToolResultText(v50) == nil then
				local v51 = extractQuestionsFromToolCall(v50)

				if v51 == nil then
					continue
				end

				return v51, v49, v50.rawInput, v50.turnId, v50.referenceId
			end
		end

		return nil, nil, nil, nil, nil
	end,
	formatToolResultText = formatToolResultText,
	formatToolResultContent = function(t12: {[any]: any}) -- line: 234
		-- upvalues: formatToolResultText (copy)
		return {
			text = formatToolResultText(t12)
		}
	end,
	getAnsweredPromptsFromTurnState = function(p10) -- line: 322
		-- upvalues: extractQuestionsFromToolCall (copy), getPersistedToolResultText (copy), getAnswersByQuestionId (copy), getPromptFromToolResult (copy), getToolCallOrder (copy)
		local t13 = {}
		local t14 = {}

		for v90 in p10.toolCalls do
			table.insert(t14, v90)
		end

		table.sort(t14)

		for _, v92 in t14 do
			local v93 = p10.toolCalls[v92]
			local v94 = extractQuestionsFromToolCall(v93)
			local v95 = getPersistedToolResultText(v93)

			if v94 ~= nil and v95 ~= nil then
				local v96 = getAnswersByQuestionId(v95)

				for _, v98 in v94 do
					local v99 = getPromptFromToolResult(v98, v96[v98.id], v92, (getToolCallOrder(p10, v92)))

					if v99 ~= nil then
						table.insert(t13, v99)
					end
				end
			end
		end

		return t13
	end,
	formatCancellationContent = function() -- line: 358
		return {
			text = "User cancelled answering the question"
		}
	end
}
