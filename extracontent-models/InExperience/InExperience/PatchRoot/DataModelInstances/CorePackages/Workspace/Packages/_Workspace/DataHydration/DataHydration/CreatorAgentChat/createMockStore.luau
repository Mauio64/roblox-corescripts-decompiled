local HttpService = game:GetService("HttpService")

local AcpProtocol = require(script.Parent.Acp.AcpProtocol)
require(script.Parent.types)
local parent = script:FindFirstAncestor("DataHydration").Parent
local SharedFlags = require(parent.SharedFlags)
local FFlagBuildExperienceModelPickerData = SharedFlags.FFlagBuildExperienceModelPickerData
local createCreatorAgentChatStore = require(script.Parent.createCreatorAgentChatStore)

local function isoNow() -- 6 equivalent calls inferred from this helper
	return DateTime.now():ToIsoDate()
end

local function jsonError(id, code: number, message: string, statusCode: number)
	return {
		statusCode = statusCode,
		responseBody = HttpService:JSONEncode({
			jsonrpc = "2.0",
			id = id,
			error = { code = code, message = message }
		})
	}
end

local function jsonOk(id, p)
	return {
		statusCode = 200,
		responseBody = HttpService:JSONEncode({ jsonrpc = "2.0", id = id, result = p })
	}
end

local function streamWords(value: string)
	local flag = true
	local result = {}

	for k in value:gmatch("%S+") do
		if flag then
			table.insert(result, k)
			flag = false
		else
			table.insert(result, " " .. k)
		end
	end

	return result
end

local function httpStatusForCode(code: number): number
	if code == AcpProtocol.ErrorCodes.NotFound then
		return 404
	end

	if code == AcpProtocol.ErrorCodes.Gone then
		return 410
	end

	if code == AcpProtocol.ErrorCodes.Conflict then
		return 409
	end

	if code == AcpProtocol.ErrorCodes.UpstreamUnavailable then
		return 502
	end

	if code == AcpProtocol.ErrorCodes.Unauthorized then
		return 401
	end

	if code == AcpProtocol.ErrorCodes.Forbidden then
		return 403
	end

	if code == AcpProtocol.ErrorCodes.InternalError then
		return 500
	end

	return 400
end

local function createMockStore(options)
	local v = options or {}
	local chunkDelay = v.chunkDelay or 0.04

	local v2 = {}
	local count = 0

	if v.initialSessions then
		for _, initialSession in v.initialSessions do
			count += 1
			local sessionId = initialSession.sessionId or ("mock_seed_%08d"):format(count)
			local v3 = isoNow() -- inferred equivalent call
			v2[sessionId] = {
				sessionId = sessionId,
				title = initialSession.title,
				createdUtc = v3,
				updatedUtc = v3,
				closedUtc = nil
			}
		end
	end

	local function newSessionId() -- 1 equivalent call inferred from this helper
		count += 1
		return ("mock_%08d"):format(count)
	end

	local mockStore = nil

	local function emitNotification(sessionId: string, update, count2: number)
		mockStore.ingestFrame({
			kind = "notification",
			notification = {
				method = AcpProtocol.Notifications.SessionUpdate,
				params = { sessionId = sessionId, update = update }
			}
		}, { sequenceNumber = count2 })
	end

	local function emitResponse(id, p)
		mockStore.ingestFrame({
			kind = "response",
			response = { jsonrpc = "2.0", id = id, result = p.result, error = p.error }
		})
	end

	local function defaultResponder(data)
		for _, v3 in streamWords(("Sure! I'll work on \"%s\" for you."):format(data.promptText:sub(1, 60))) do
			data.emitText(v3)
			data.sleep(chunkDelay)
		end

		data.finish("end_turn")
	end

	local function stringResponder(respond: string) -- 2 equivalent calls inferred from this helper
		return function(data)
			for _, v3 in streamWords(respond) do
				data.emitText(v3)
				data.sleep(chunkDelay)
			end

			data.finish("end_turn")
		end
	end

	local function pickResponder()
		local respond = v.respond

		if respond == nil then
			return defaultResponder
		end

		if typeof(respond) == "string" then
			return stringResponder(respond) -- inferred equivalent call
		end

		return respond
	end

	local function runResponder(id, sessionId: string, prompt)
		local v3 = tostring(id)
		local formatted = `{v3}:user`
		local formatted2 = `{v3}:assistant`
		local promptText = ""

		for _, item in prompt do
			if not (item.type == "text" and typeof(item.text) == "string") then
				continue
			end

			if promptText == "" then
				promptText = item.text
			else
				promptText ..= "\n" .. item.text
			end
		end

		local count2 = 0
		local function emitSessionUpdate(update) -- 7 equivalent calls inferred from this helper
			if v.onSessionUpdate then
				v.onSessionUpdate(update, count2)
			end

			emitNotification(sessionId, update, count2)
			count2 += 1
		end

		local flag = false
		local function finishTurn(value) -- 2 equivalent calls inferred from this helper
			if flag then
				return
			end

			flag = true
			emitSessionUpdate({ -- inferred equivalent call
				sessionUpdate = "state_change",
				state = "idle",
				stop_reason = value or "end_turn"
			})
		end

		local function failTurn(code: number, message: string)
			if flag then
				return
			end

			flag = true
			emitResponse(id, {
				error = { code = code, message = message }
			})
		end

		emitSessionUpdate({ -- inferred equivalent call
			sessionUpdate = "user_message",
			messageId = formatted,
			content = prompt
		})

		emitSessionUpdate({ sessionUpdate = "state_change", state = "running" }) -- inferred equivalent call

		local v4 = {
			sessionId = sessionId,
			promptText = promptText,
			promptBlocks = prompt,
			sleep = task.wait,
			emitText = function(text)
				emitSessionUpdate({ -- inferred equivalent call
					sessionUpdate = "agent_message_chunk",
					messageId = formatted2,
					content = { type = "text", text = text }
				})
			end,
			emitToolCall = function(data)
				emitSessionUpdate({ -- inferred equivalent call
					sessionUpdate = "tool_call_update",
					toolCallId = data.toolCallId,
					title = data.title,
					kind = data.kind,
					status = data.status,
					rawInput = data.rawInput
				})
			end,
			updateToolCall = function(toolCallId, data)
				emitSessionUpdate({ -- inferred equivalent call
					sessionUpdate = "tool_call_update",
					toolCallId = toolCallId,
					status = data.status,
					rawOutput = data.rawOutput,
					content = data.content
				})
			end,
			setTitle = function(title)
				local v4 = v2[sessionId]

				if v4 then
					v4.title = title
					v4.updatedUtc = isoNow() -- inferred equivalent call
				end

				emitSessionUpdate({ sessionUpdate = "session_info_update", title = title }) -- inferred equivalent call
			end,
			finish = function(value)
				finishTurn(value) -- inferred equivalent call
			end,
			fail = function(code, message)
				failTurn(code, message)
			end
		}

		task.spawn(function()
			local function callResponder(): nil
				local respond = v.respond
				local v5

				if respond == nil then
					v5 = defaultResponder
				else
					v5 = typeof(respond) == "string" and stringResponder(respond) or respond -- inferred equivalent call
				end

				v5(v4)
				return nil
			end

			local success, result = pcall(callResponder)

			if not success then
				failTurn(AcpProtocol.ErrorCodes.InternalError, "Mock responder errored: " .. tostring(result))
			elseif not flag then
				finishTurn() -- inferred equivalent call
			end
		end)
	end

	local function findSession(p: string)
		local v3 = v2[p]

		if v3 == nil or v3.closedUtc ~= nil then
			return nil, { code = AcpProtocol.ErrorCodes.NotFound, message = "session not found" }
		end

		return v3, nil
	end

	local function sessionListEntry(data)
		local v3 = { sessionId = data.sessionId, title = data.title, updatedAt = data.updatedUtc }

		if data.project ~= nil then
			v3._meta = {
				_roblox = { universeId = data.project.universeId }
			}
		end

		return v3
	end

	local v3 = {
		[AcpProtocol.Methods.Initialize] = function()
			return {
				protocolVersion = AcpProtocol.ProtocolVersion,
				capabilities = {
					session = {
						load = {},
						prompt = { image = true, audio = false, embeddedContext = true },
						mcp = { http = {} }
					},
					_meta = {
						_roblox = { localToolExecution = true }
					}
				},
				agentInfo = { name = "mock-my-stats-service", version = "0.0.1-mock" }
			}, nil
		end,
		[AcpProtocol.Methods.SessionNew] = function(p)
			local sessionNewProject = AcpProtocol.extractSessionNewProject(p)

			if sessionNewProject == nil then
				return
					nil,
					{
						code = AcpProtocol.ErrorCodes.InvalidParams,
						message = "_meta._roblox universeId/placeId is required on session/new"
					}
			end

			local sessionId = newSessionId() -- inferred equivalent call
			local v3 = isoNow() -- inferred equivalent call
			v2[sessionId] = {
				sessionId = sessionId,
				title = nil,
				createdUtc = v3,
				updatedUtc = v3,
				closedUtc = nil,
				project = sessionNewProject
			}

			if FFlagBuildExperienceModelPickerData and v.models ~= nil then
				return {
					sessionId = sessionId,
					_meta = {
						_roblox = { models = v.models }
					}
				}, nil
			end

			return { sessionId = sessionId }, nil
		end,
		[AcpProtocol.Methods.SessionList] = function(_)
			local sessions = {}

			for _, v3 in v2 do
				if v3.closedUtc == nil then
					table.insert(sessions, sessionListEntry(v3))
				end
			end

			table.sort(sessions, function(a, b): boolean
				return (a.updatedAt or "") > (b.updatedAt or "")
			end)

			return { sessions = sessions }, nil
		end,
		[AcpProtocol.Methods.SessionFindByUniverse] = function(p)
			if typeof(p.universeId) ~= "number" or p.universeId == 0 then
				return nil, {
					code = AcpProtocol.ErrorCodes.InvalidParams,
					message = "universeId is required"
				}
			end

			local sessions = {}

			for _, v3 in v2 do
				if v3.closedUtc == nil and v3.project ~= nil and v3.project.universeId == p.universeId then
					table.insert(sessions, sessionListEntry(v3))
				end
			end

			table.sort(sessions, function(a, b): boolean
				return (a.updatedAt or "") > (b.updatedAt or "")
			end)

			return { sessions = sessions }, nil
		end,
		[AcpProtocol.Methods.SessionLoad] = function(p)
			local v3 = v2[p.sessionId]
			local v4

			if v3 == nil or v3.closedUtc ~= nil then
				v4 = { code = AcpProtocol.ErrorCodes.NotFound, message = "session not found" }
				v3 = nil
			end

			if v4 then
				return nil, v4
			end

			local models

			if FFlagBuildExperienceModelPickerData then
				models = v.models
			end

			local universeId

			if v3.project ~= nil then
				universeId = v3.project.universeId
			end

			return {
				_meta = {
					_roblox = { models = models, universeId = universeId }
				}
			}, nil
		end,
		[AcpProtocol.Methods.SessionReadTasks] = function(p)
			local v3 = v2[p.sessionId]
			local v4 = (v3 == nil or v3.closedUtc ~= nil)
				and { code = AcpProtocol.ErrorCodes.NotFound, message = "session not found" }
				or nil

			if v4 then
				return nil, v4
			end

			return { tasks = {} }, nil
		end,
		[AcpProtocol.Methods.SessionCancel] = function(p)
			local v3 = v2[p.sessionId]
			local v4 = (v3 == nil or v3.closedUtc ~= nil)
				and { code = AcpProtocol.ErrorCodes.NotFound, message = "session not found" }
				or nil

			if v4 then
				return nil, v4
			end

			return {}, nil
		end,
		[AcpProtocol.Methods.SessionDelete] = function(p)
			local v3 = v2[p.sessionId]

			if v3 == nil then
				return nil, {
					code = AcpProtocol.ErrorCodes.NotFound,
					message = "session not found"
				}
			end

			v3.closedUtc = isoNow() -- inferred equivalent call
			return {}, nil
		end,
		[AcpProtocol.Methods.SessionUpdateInfo] = function(p)
			local v3 = v2[p.sessionId]
			local v4

			if v3 == nil or v3.closedUtc ~= nil then
				v4 = { code = AcpProtocol.ErrorCodes.NotFound, message = "session not found" }
				v3 = nil
			end

			if v4 then
				return nil, v4
			end

			if p.title ~= nil then
				v3.title = p.title
				v3.updatedUtc = isoNow() -- inferred equivalent call
			end

			return {}, nil
		end,
		[AcpProtocol.Methods.SessionSaveAndPublish] = function(_)
			return { status = "success", version = "1" }, nil
		end,
		[AcpProtocol.Methods.AdCampaignEligibility] = function(p)
			if typeof(p.universeId) == "number" and not (p.universeId <= 0) then
				return {
					schemaVersion = 2,
					userEligible = true,
					universeEligible = true,
					freeCreditsRemaining = 1,
					cardType = "promote_free",
					ineligibleReasons = {},
					offer = { displayAmountRobux = 0, durationDays = 3 },
					offers = {
						{
							campaignOption = "feedback",
							fundingType = "free",
							durationDays = 3,
							priceRobux = 500
						},
						{
							campaignOption = "plays",
							fundingType = "paid",
							durationDays = 7,
							priceRobux = 2000
						}
					}
				}, nil
			end

			return nil, {
				code = AcpProtocol.ErrorCodes.InvalidParams,
				message = "universeId is required"
			}
		end,
		[AcpProtocol.Methods.AdCampaignCheckFunds] = function(p)
			if p.campaignOption == "feedback" or p.campaignOption == "plays" then
				return { canFund = true, fundingSource = "robux" }, nil
			end

			return nil, {
				code = AcpProtocol.ErrorCodes.InvalidParams,
				message = "campaignOption is required"
			}
		end,
		[AcpProtocol.Methods.AdCampaignCreate] = function(data)
			if typeof(data.universeId) ~= "number" or data.universeId <= 0 then
				return nil, {
					code = AcpProtocol.ErrorCodes.InvalidParams,
					message = "universeId is required"
				}
			end

			if typeof(data.idempotencyKey) == "string" and data.idempotencyKey ~= "" then
				return {
					campaignId = "mock_campaign_0001",
					status = "in_review",
					toolCallId = data.toolCallId
				}, nil
			end

			return nil, {
				code = AcpProtocol.ErrorCodes.InvalidParams,
				message = "idempotencyKey is required"
			}
		end
	}

	local function dispatch(data)
		if data.method == AcpProtocol.Methods.SessionPrompt then
			local v4 = v2[data.params.sessionId]
			local v5

			if v4 == nil or v4.closedUtc ~= nil then
				v5 = { code = AcpProtocol.ErrorCodes.NotFound, message = "session not found" }
				v4 = nil
			end

			if v5 then
				return jsonError(data.id, v5.code, v5.message, httpStatusForCode(v5.code))
			end

			v4.updatedUtc = isoNow() -- inferred equivalent call
			runResponder(data.id, data.params.sessionId, data.params.prompt or {})

			if FFlagBuildExperienceModelPickerData then
				return { statusCode = 202, responseBody = "" }
			end

			return jsonOk(data.id, {})
		else
			local v4 = v3[data.method]

			if v4 == nil then
				return jsonError(
					data.id,
					AcpProtocol.ErrorCodes.MethodNotFound,
					"Method not found: " .. data.method,
					404
				)
			end

			local success, result, v5 = pcall(v4, data.params or {})

			if not success then
				return jsonError(data.id, AcpProtocol.ErrorCodes.InternalError, tostring(result), 500)
			end

			if v5 then
				return jsonError(data.id, v5.code, v5.message, httpStatusForCode(v5.code))
			end

			return jsonOk(data.id, result)
		end
	end

	mockStore = createCreatorAgentChatStore({
		network = {
			request = function(p, callback)
				local jsonDecode = HttpService:JSONDecode(p.body or "{}")

				if
					typeof(jsonDecode) == "table"
					and typeof(jsonDecode.result) == "table"
					and jsonDecode.result.tool_name == "ask_tool"
				then
					callback(true, {
						statusCode = 200,
						responseBody = "{\"jsonrpc\":\"2.0\",\"id\":1,\"result\":{}}"
					})
					return function() end
				end

				callback(true, dispatch(jsonDecode))
				return function() end
			end
		},
		baseUrl = "mock://my-stats/v2"
	})

	return mockStore
end

return createMockStore
