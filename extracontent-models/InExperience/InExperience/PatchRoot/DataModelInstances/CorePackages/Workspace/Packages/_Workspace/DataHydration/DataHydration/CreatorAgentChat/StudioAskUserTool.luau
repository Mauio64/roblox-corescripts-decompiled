require(script.Parent.types)

local HttpService = game:GetService("HttpService")
local t1 = {
	single_select = "single_select",
	multi_select = "multi_select",
	free_text = "free_text"
}
local t2 = {
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
				responseType = {
					type = "string",
					enum = {
						"single_select",
						"multi_select",
						"free_text"
					}
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

local function valueLooksLikeToolName(p1) -- line: 74
	return typeof(p1) == "string" and string.lower(p1) == "studio_ask_user"
end
local function getQuestionsPayload(p2) -- line: 78
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
local function resolveResponseType(p3, n1: number) -- line: 98
	-- upvalues: t1 (copy)
	local v22 = if typeof(p3) ~= "string" then nil else t1[p3]

	if v22 == nil then
		if n1 > 0 then
			return "single_select"
		end

		return "free_text"
	end

	return v22
end
local function toAnswerQuestions(p4) -- line: 109
	-- upvalues: t1 (copy)
	local v24 = if typeof(p4) == "table" then if typeof(p4[1]) ~= "table" then if typeof(p4.questions) ~= "table" then if typeof(p4.data) ~= "table" then nil else p4.data else p4.questions else p4 else nil

	if typeof(v24) ~= "table" then
		return nil
	end

	local t3 = {}

	for v26, v27 in v24 do
		if typeof(v27) == "table" and typeof(v27.question) == "string" then
			local t4 = {}
			local options = v27.options

			if typeof(options) == "table" then
				for v30, v31 in options do
					if typeof(v31) == "table" and typeof(v31.optionText) == "string" then
						table.insert(t4, {
							id = `q{ v26 }-o{ v30 }`,
							title = v31.optionText,
							description = typeof(v31.clarificationText) ~= "string" and "" or v31.clarificationText
						})
					end
				end
			end

			local t5 = {
				id = `q{ v26 }`,
				question = v27.question,
				options = t4
			}
			local responseType = v27.responseType
			local v34 = #t4
			local v35 = if typeof(responseType) ~= "string" then nil else t1[responseType]

			t5.responseType = if v35 ~= nil then v35 else not (v34 > 0) and "free_text" or "single_select"
			table.insert(t3, t5)
		end
	end

	if #t3 > 0 then
		return t3
	end

	return nil
end
local function extractQuestionsFromToolCall(p5) -- line: 146
	-- upvalues: toAnswerQuestions (copy)
	local v37 = toAnswerQuestions(p5.rawInput)

	if v37 == nil then
		return nil
	end

	local kind = p5.kind

	if typeof(kind) == "string" and string.lower(kind) == "studio_ask_user" then
		return v37
	end

	local title = p5.title

	if typeof(title) == "string" and string.lower(title) == "studio_ask_user" then
		return v37
	end

	local rawInput = p5.rawInput

	if typeof(rawInput) == "table" then
		local name = rawInput.name

		if typeof(name) == "string" and string.lower(name) == "studio_ask_user" then
			return v37
		end

		local toolName = rawInput.toolName

		if typeof(toolName) == "string" and string.lower(toolName) == "studio_ask_user" then
			return v37
		end
	end

	return v37
end
local function decodePersistedToolResultText(s1: string) -- line: 170
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
local function getPersistedToolResultText(p6) -- line: 180
	-- upvalues: HttpService (copy)
	if p6.content == nil then
		return nil
	end

	local t6 = {}

	for _, v49 in p6.content do
		if v49.type == "content" and v49.content ~= nil then
			local content = v49.content

			if content.type == "text" and typeof(content.text) == "string" then
				local text = content.text
				local ok, result = pcall(HttpService.JSONDecode, HttpService, text)
				local v54 = if not not ok and typeof(result) == "table" then if typeof(result.text) ~= "string" then nil else result.text else nil

				if v54 ~= nil and v54 ~= "" then
					table.insert(t6, v54)
				end
			end
		end
	end

	if #t6 > 0 then
		return (table.concat(t6))
	end

	return nil
end
local function formatToolResultText(t7: {[any]: any}) -- line: 235
	-- upvalues: HttpService (copy)
	local t8 = {}

	for _, v66 in t7 do
		local options = v66.options

		if options ~= nil and #options > 0 then
			local t9 = {}
			local t10 = {}

			for _, v71 in options do
				table.insert(t9, v71.id)
				table.insert(t10, v71.title)
			end

			table.insert(t8, {
				questionId = v66.question.id,
				selectedOptionId = t9,
				content = table.concat(t10, ", ")
			})
		elseif v66.option ~= nil then
			local option = v66.option

			table.insert(t8, {
				questionId = v66.question.id,
				selectedOptionId = option.id,
				content = option.title
			})
		elseif v66.customResponseText ~= nil then
			table.insert(t8, {
				questionId = v66.question.id,
				content = v66.customResponseText
			})
		end
	end

	return HttpService:JSONEncode({
		answers = t8
	})
end
local function findSelectedOptionById(p7, s2: string?) -- line: 276
	if s2 == nil then
		return nil
	end

	for _, v77 in p7.options do
		if s2 == v77.id then
			return v77
		end
	end

	return nil
end
local function findSelectedOptionsByIds(p8, t11: {[any]: any}) -- line: 288
	local t12 = {}

	for _, v82 in p8.options do
		t12[v82.id] = v82
	end

	local t13 = {}

	for _, v85 in t11 do
		local v86 = t12[v85]

		if v86 == nil then
			return nil
		end

		table.insert(t13, v86)
	end

	return t13
end
local function normalizeSelectedOptionId(p9) -- line: 305
	if typeof(p9) == "string" then
		return p9
	end

	if typeof(p9) ~= "table" then
		return nil
	end

	local t14 = {}

	for _, v90 in p9 do
		if typeof(v90) ~= "string" then
			return nil
		end

		table.insert(t14, v90)
	end

	if #t14 > 0 then
		return t14
	end

	return nil
end
local function getAnswersByQuestionId(s3: string) -- line: 323
	-- upvalues: HttpService (copy), normalizeSelectedOptionId (copy)
	local t15 = {}
	local ok, result = pcall(HttpService.JSONDecode, HttpService, s3)

	if not ok or typeof(result) ~= "table" then
		return t15
	end

	local answers = result.answers

	if typeof(answers) ~= "table" then
		return t15
	end

	for _, v97 in answers do
		if typeof(v97) == "table" and typeof(v97.questionId) == "string" and typeof(v97.content) == "string" then
			t15[v97.questionId] = {
				questionId = v97.questionId,
				selectedOptionId = normalizeSelectedOptionId(v97.selectedOptionId),
				content = v97.content
			}
		end
	end

	return t15
end
local function getPromptFromToolResult(p10, t16: {[any]: any}?, s4: string, n2: number) -- line: 350
	-- upvalues: findSelectedOptionsByIds (copy)
	if t16 == nil then
		return nil
	end

	local selectedOptionId = t16.selectedOptionId

	if typeof(selectedOptionId) == "table" then
		if findSelectedOptionsByIds(p10, selectedOptionId) == nil then
			return nil
		end

		return {
			question = p10,
			selectedOptionId = selectedOptionId,
			toolCallId = s4,
			callOrder = n2
		}
	end

	local v103, g106

	if selectedOptionId == nil then
		v103 = nil
	else
		g106 = nil
		v103 = nil

		for _, v105 in p10.options do
			if selectedOptionId == v105.id then
				v103 = v105
				g106 = true
			end

			if g106 then
				break
			end
		end

		if not g106 then
			v103 = nil
		end
	end

	g106 = false

	if selectedOptionId ~= nil and v103 == nil then
		return nil
	end

	local v107 = if v103 ~= nil then nil else t16.content

	return {
		question = p10,
		selectedOptionId = if v103 == nil then nil else v103.id,
		customResponseText = v107,
		toolCallId = s4,
		callOrder = n2
	}
end
local function getToolCallOrder(p11, s5: string) -- line: 389
	if p11.activityItems ~= nil then
		for v110, v111 in p11.activityItems do
			if v111.kind == "tool_call" and s5 == v111.toolCallId then
				return v110
			end
		end
	end

	local t17 = {}

	for v113 in p11.toolCalls do
		table.insert(t17, v113)
	end

	table.sort(t17)

	for v114, v115 in t17 do
		if v115 == s5 then
			return v114
		end
	end

	return 0
end

return {
	TOOL_NAME = "studio_ask_user",
	CANCELLATION_TEXT = "User cancelled answering the question",
	LOCAL_TOOL_DEFINITION = t2,
	extractQuestionsFromToolCall = extractQuestionsFromToolCall,
	findQuestionsInTurnState = function(p12, t18: {[any]: any}?) -- line: 208
		-- upvalues: getPersistedToolResultText (copy), extractQuestionsFromToolCall (copy)
		local t19 = {}

		for v58 in p12.toolCalls do
			table.insert(t19, v58)
		end

		table.sort(t19)

		for _, v60 in t19 do
			if t18 and t18[v60] then
				continue
			end

			local v61 = p12.toolCalls[v60]

			if getPersistedToolResultText(v61) == nil then
				local v62 = extractQuestionsFromToolCall(v61)

				if v62 == nil then
					continue
				end

				return v62, v60, v61.rawInput, v61.turnId, v61.referenceId
			end
		end

		return nil, nil, nil, nil, nil
	end,
	formatToolResultText = formatToolResultText,
	formatToolResultContent = function(t20: {[any]: any}) -- line: 270
		-- upvalues: formatToolResultText (copy)
		return {
			text = formatToolResultText(t20)
		}
	end,
	getAnsweredPromptsFromTurnState = function(p13) -- line: 412
		-- upvalues: extractQuestionsFromToolCall (copy), getPersistedToolResultText (copy), getAnswersByQuestionId (copy), getPromptFromToolResult (copy), getToolCallOrder (copy)
		local t21 = {}
		local t22 = {}

		for v119 in p13.toolCalls do
			table.insert(t22, v119)
		end

		table.sort(t22)

		for _, v121 in t22 do
			local v122 = p13.toolCalls[v121]
			local v123 = extractQuestionsFromToolCall(v122)
			local v124 = getPersistedToolResultText(v122)

			if v123 ~= nil and v124 ~= nil then
				local v125 = getAnswersByQuestionId(v124)

				for _, v127 in v123 do
					local v128 = getPromptFromToolResult(v127, v125[v127.id], v121, (getToolCallOrder(p13, v121)))

					if v128 ~= nil then
						table.insert(t21, v128)
					end
				end
			end
		end

		return t21
	end,
	formatCancellationContent = function() -- line: 448
		return {
			text = "User cancelled answering the question"
		}
	end
}
