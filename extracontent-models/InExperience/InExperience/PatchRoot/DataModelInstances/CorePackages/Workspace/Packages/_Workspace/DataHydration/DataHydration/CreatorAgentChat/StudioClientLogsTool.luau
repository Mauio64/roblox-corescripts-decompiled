local HttpService = game:GetService("HttpService")

require(script.Parent.types)

local t1 = {
	name = "ask_for_logs",
	inputSchema = {
		type = "object",
		properties = {
			reason = {
				type = "string"
			}
		}
	}
}

local function valueLooksLikeToolName(p1) -- line: 34
	return typeof(p1) == "string" and string.lower(p1) == "ask_for_logs"
end
local function decodePersistedToolResultText(s1: string) -- line: 55
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
local function getPersistedToolResultText(p2) -- line: 65
	-- upvalues: HttpService (copy)
	if p2.content == nil then
		return nil
	end

	local t2 = {}

	for _, v20 in p2.content do
		if v20.type == "content" and v20.content ~= nil then
			local content = v20.content

			if content.type == "text" and typeof(content.text) == "string" then
				local text = content.text
				local ok, result = pcall(HttpService.JSONDecode, HttpService, text)
				local v25 = if not not ok and typeof(result) == "table" then if typeof(result.text) ~= "string" then nil else result.text else nil

				if v25 ~= nil and v25 ~= "" then
					table.insert(t2, v25)
				end
			end
		end
	end

	if #t2 > 0 then
		return (table.concat(t2))
	end

	return nil
end

return {
	TOOL_NAME = "ask_for_logs",
	NOT_IN_GAME_MESSAGE = "The user is not in the game.",
	LOCAL_TOOL_DEFINITION = t1,
	toolCallLooksLikeClientLogsRequest = function(p3) -- line: 38
		local kind = p3.kind

		if typeof(kind) ~= "string" or string.lower(kind) ~= "ask_for_logs" then
			local title = p3.title

			if not (typeof(title) == "string" and string.lower(title) == "ask_for_logs") then
				local rawInput = p3.rawInput

				if typeof(rawInput) == "table" then
					local name = rawInput.name
					local v12 = typeof(name) == "string" and string.lower(name) == "ask_for_logs"

					if not v12 then
						local toolName = rawInput.toolName

						v12 = typeof(toolName) == "string" and string.lower(toolName) == "ask_for_logs"
					end

					return v12
				end

				return false
			end
		end

		return true
	end,
	findClientLogsRequestInTurnState = function(p4, t3: {[any]: any}?) -- line: 88
		-- upvalues: getPersistedToolResultText (copy)
		local t4 = {}
		local g34 = nil
		local v38 = nil

		for v29 in p4.toolCalls do
			table.insert(t4, v29)
		end

		table.sort(t4)

		for _, v31 in t4 do
			if t3 and t3[v31] then
				continue
			end

			local v32 = p4.toolCalls[v31]

			if getPersistedToolResultText(v32) == nil then
				local kind = v32.kind

				repeat
					if not g34 and (typeof(kind) ~= "string" or string.lower(kind) ~= "ask_for_logs") then
						local title = v32.title

						if typeof(title) == "string" and string.lower(title) == "ask_for_logs" then
							g34 = true
						end

						if not g34 then
							local rawInput = v32.rawInput

							if typeof(rawInput) == "table" then
								local name = rawInput.name

								v38 = typeof(name) == "string" and string.lower(name) == "ask_for_logs"

								if not v38 then
									local toolName = rawInput.toolName

									v38 = typeof(toolName) == "string" and string.lower(toolName) == "ask_for_logs"
								end
							else
								v38 = false
							end
						end
					else
						g34 = false
						v38 = true
					end
				until not g34

				if not v38 then
					continue
				end

				return v31, v32.rawInput, v32.turnId, v32.referenceId
			end
		end

		return nil, nil, nil, nil
	end,
	formatLogsContent = function(t5: {[any]: any}, t6: {[any]: any}) -- line: 114
		-- upvalues: HttpService (copy)
		return {
			text = HttpService:JSONEncode({
				status = "ok",
				clientLogs = t5,
				serverLogs = t6
			})
		}
	end,
	formatNotInGameContent = function() -- line: 124
		-- upvalues: HttpService (copy)
		return {
			text = HttpService:JSONEncode({
				status = "not_in_game",
				message = "The user is not in the game."
			})
		}
	end
}
