local HttpService = game:GetService("HttpService")

require(script.Parent.types)

local t1 = {
	present_plan = true,
	propose_plan = true
}
local t2 = {
	name = "present_plan",
	inputSchema = {
		type = "object",
		required = { "content" },
		properties = {
			content = {
				type = "string"
			},
			summary = {
				type = "string"
			},
			title = {
				type = "string"
			}
		}
	}
}

local function valueLooksLikeToolName(p1) -- line: 36
	-- upvalues: t1 (copy)
	return typeof(p1) == "string" and t1[string.lower(p1)] == true
end
local function getRawInputContent(p2) -- line: 40
	if typeof(p2) == "string" then
		return p2, nil, nil
	end

	if typeof(p2) ~= "table" then
		return nil, nil, nil
	end

	local content = p2.content

	if typeof(content) ~= "string" or content == "" then
		return nil, nil, nil
	end

	local v14 = if typeof(p2.title) ~= "string" or p2.title == "" then nil else p2.title

	if typeof(p2.summary) == "string" and p2.summary ~= "" then
		return content, v14, p2.summary
	end

	return content, v14, nil
end
local function toolCallLooksLikeProposePlan(p3) -- line: 59
	-- upvalues: t1 (copy)
	local kind = p3.kind

	if typeof(kind) ~= "string" or t1[string.lower(kind)] ~= true then
		local title = p3.title

		if not (typeof(title) == "string" and t1[string.lower(title)] == true) then
			local rawInput = p3.rawInput

			if typeof(rawInput) == "table" then
				local name = rawInput.name
				local v20 = typeof(name) == "string" and t1[string.lower(name)] == true

				if not v20 then
					local toolName = rawInput.toolName

					v20 = typeof(toolName) == "string" and t1[string.lower(toolName)] == true
				end

				return v20
			end

			return false
		end
	end

	return true
end
local function decodePersistedToolResultText(s1: string) -- line: 93
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
local function getPersistedToolResultText(p4) -- line: 103
	-- upvalues: HttpService (copy)
	if p4.content == nil then
		return nil
	end

	local t3 = {}

	for _, v39 in p4.content do
		if v39.type == "content" and v39.content ~= nil then
			local content = v39.content

			if content.type == "text" and typeof(content.text) == "string" then
				local text = content.text
				local ok, result = pcall(HttpService.JSONDecode, HttpService, text)
				local v44 = if not not ok and typeof(result) == "table" then if typeof(result.text) ~= "string" then nil else result.text else nil

				if v44 ~= nil and v44 ~= "" then
					table.insert(t3, v44)
				end
			end
		end
	end

	if #t3 > 0 then
		return (table.concat(t3))
	end

	return nil
end
local function getToolCallOrder(p5, s2: string) -- line: 153
	if p5.activityItems ~= nil then
		for v65, v66 in p5.activityItems do
			if v66.kind == "tool_call" and s2 == v66.toolCallId then
				return v65
			end
		end
	end

	local t4 = {}

	for v68 in p5.toolCalls do
		table.insert(t4, v68)
	end

	table.sort(t4)

	for v69, v70 in t4 do
		if v70 == s2 then
			return v69
		end
	end

	return 0
end
local function decodePlanResult(s3: string) -- line: 176
	-- upvalues: HttpService (copy)
	local ok, result = pcall(HttpService.JSONDecode, HttpService, s3)

	if not ok or typeof(result) ~= "table" then
		return nil
	end

	if typeof(result.accepted) ~= "boolean" then
		return nil
	end

	if result.feedbackText ~= nil and typeof(result.feedbackText) ~= "string" then
		return nil
	end

	return result
end

return {
	TOOL_NAME = "present_plan",
	LOCAL_TOOL_DEFINITION = t2,
	extractPlanFromToolCall = function(p6) -- line: 72
		-- upvalues: t1 (copy), getRawInputContent (copy)
		local kind = p6.kind
		local g24 = nil
		local title = nil
		local v28 = nil

		repeat
			if g24 or (typeof(kind) ~= "string" or t1[string.lower(kind)] ~= true) then
				if not g24 then
					title = p6.title
				end

				if g24 or not (typeof(title) == "string" and t1[string.lower(title)] == true) then
					if not g24 then
						local rawInput = p6.rawInput

						if typeof(rawInput) == "table" then
							local name = rawInput.name

							v28 = typeof(name) == "string" and t1[string.lower(name)] == true

							if not v28 then
								local toolName = rawInput.toolName

								v28 = typeof(toolName) == "string" and t1[string.lower(toolName)] == true
							end
						else
							v28 = false
						end
					end

					g24 = false

					if not v28 then
						return nil
					end

					local v30, v31, v32 = getRawInputContent(p6.rawInput)

					if v30 == nil then
						return nil
					end

					return {
						title = v31 or "Proposed Plan",
						textContent = v30,
						summary = v32
					}
				end
			end

			v28 = true
			g24 = true
		until not g24
	end,
	findPlanInTurnState = function(p7, t5: {[any]: any}?) -- line: 126
		-- upvalues: getPersistedToolResultText (copy), t1 (copy), getRawInputContent (copy)
		local t6 = {}
		local g53 = nil
		local v57 = nil

		for v48 in p7.toolCalls do
			table.insert(t6, v48)
		end

		table.sort(t6)

		for _, v50 in t6 do
			if t5 and t5[v50] then
				continue
			end

			local v51 = p7.toolCalls[v50]

			if getPersistedToolResultText(v51) == nil then
				local kind = v51.kind

				repeat
					if not g53 and (typeof(kind) ~= "string" or t1[string.lower(kind)] ~= true) then
						local title = v51.title

						if typeof(title) == "string" and t1[string.lower(title)] == true then
							g53 = true
						end

						if not g53 then
							local rawInput = v51.rawInput

							if typeof(rawInput) == "table" then
								local name = rawInput.name

								v57 = typeof(name) == "string" and t1[string.lower(name)] == true

								if not v57 then
									local toolName = rawInput.toolName

									v57 = typeof(toolName) == "string" and t1[string.lower(toolName)] == true
								end
							else
								v57 = false
							end
						end
					else
						g53 = false
						v57 = true
					end
				until not g53

				local v59

				if not v57 then
					v59 = nil
				else
					local v60, v61, v62 = getRawInputContent(v51.rawInput)

					v59 = if v60 ~= nil then {
						title = v61 or "Proposed Plan",
						textContent = v60,
						summary = v62
					} else nil
				end

				if v59 == nil then
					continue
				end

				return v59, v50, v51.rawInput, v51.turnId, v51.referenceId
			end
		end

		return nil, nil, nil, nil, nil
	end,
	getCompletedPlansFromTurnState = function(p8) -- line: 192
		-- upvalues: t1 (copy), getRawInputContent (copy), getPersistedToolResultText (copy), HttpService (copy), getToolCallOrder (copy)
		local t7 = {}
		local t8 = {}
		local g82 = nil
		local v86 = nil

		for v77 in p8.toolCalls do
			table.insert(t8, v77)
		end

		table.sort(t8)

		for _, v79 in t8 do
			local v80 = p8.toolCalls[v79]
			local kind = v80.kind

			repeat
				if not g82 and (typeof(kind) ~= "string" or t1[string.lower(kind)] ~= true) then
					local title = v80.title

					if typeof(title) == "string" and t1[string.lower(title)] == true then
						g82 = true
					end

					if not g82 then
						local rawInput = v80.rawInput

						if typeof(rawInput) == "table" then
							local name = rawInput.name

							v86 = typeof(name) == "string" and t1[string.lower(name)] == true

							if not v86 then
								local toolName = rawInput.toolName

								v86 = typeof(toolName) == "string" and t1[string.lower(toolName)] == true
							end
						else
							v86 = false
						end
					end
				else
					g82 = false
					v86 = true
				end
			until not g82

			local v88

			if not v86 then
				v88 = nil
			else
				local v89, v90, v91 = getRawInputContent(v80.rawInput)

				v88 = if v89 ~= nil then {
					title = v90 or "Proposed Plan",
					textContent = v89,
					summary = v91
				} else nil
			end

			local v92 = getPersistedToolResultText(v80)
			local v95

			if v92 ~= nil then
				local ok, result = pcall(HttpService.JSONDecode, HttpService, v92)

				v95 = if not not ok and typeof(result) == "table" then if typeof(result.accepted) == "boolean" then if result.feedbackText == nil or typeof(result.feedbackText) == "string" then result else nil else nil else nil
			else
				v95 = nil
			end

			if v88 ~= nil and v95 ~= nil then
				table.insert(t7, {
					title = v88.title,
					textContent = v88.textContent,
					summary = v88.summary,
					toolCallId = v79,
					callOrder = getToolCallOrder(p8, v79),
					isAccepted = v95.accepted,
					feedbackText = v95.feedbackText
				})
			end
		end

		return t7
	end,
	formatAcceptedContent = function() -- line: 221
		-- upvalues: HttpService (copy)
		return {
			text = HttpService:JSONEncode({
				accepted = true
			})
		}
	end,
	formatFeedbackContent = function(s4: string) -- line: 229
		-- upvalues: HttpService (copy)
		return {
			text = HttpService:JSONEncode({
				accepted = false,
				feedbackText = s4
			})
		}
	end
}
