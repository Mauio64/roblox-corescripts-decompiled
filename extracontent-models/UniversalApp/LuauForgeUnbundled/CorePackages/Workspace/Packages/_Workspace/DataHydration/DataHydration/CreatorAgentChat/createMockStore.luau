local HttpService = game:GetService("HttpService")

local AcpProtocol = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/Acp/AcpProtocol")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/types")

local fFlagBuildExperienceModelPickerData = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/SharedFlags").FFlagBuildExperienceModelPickerData
local createCreatorAgentChatStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/createCreatorAgentChatStore")

local function isoNow()
	return DateTime.now():ToIsoDate()
end

local function jsonError(id, p2, p3, p4)
	return {
		statusCode = p4,
		responseBody = HttpService:JSONEncode({
			jsonrpc = "2.0",
			id = id,
			error = { code = p2, message = p3 }
		})
	}
end

local function jsonOk(id, p2)
	return {
		statusCode = 200,
		responseBody = HttpService:JSONEncode({ jsonrpc = "2.0", id = id, result = p2 })
	}
end

local function streamWords(value)
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

local function httpStatusForCode(code): number
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
	local v5 = options or {}
	local chunkDelay = v5.chunkDelay or 0.04

	local v6 = {}
	local count = 0

	if v5.initialSessions then
		for k, initialSession in v5.initialSessions do
			count += 1
			local sessionId = initialSession.sessionId or ("mock_seed_%08d"):format(count)
			local isoDate = DateTime.now():ToIsoDate()

			v6[sessionId] = {
				sessionId = sessionId,
				title = initialSession.title,
				createdUtc = isoDate,
				updatedUtc = isoDate,
				closedUtc = nil
			}
		end
	end

	local function newSessionId()
		count += 1
		return ("mock_%08d"):format(count)
	end

	local mockStore = nil

	local function emitNotification(p2, p3, count2)
		mockStore.ingestFrame({
			kind = "notification",
			notification = {
				method = AcpProtocol.Notifications.SessionUpdate,
				params = { sessionId = p2, update = p3 }
			}
		}, { sequenceNumber = count2 })
	end

	local function emitResponse(p2, p3)
		mockStore.ingestFrame({
			kind = "response",
			response = {
				jsonrpc = "2.0",
				id = p2,
				result = p3.result,
				error = p3.error
			}
		})
	end

	local function defaultResponder(data)
		for k, v7 in streamWords(("Sure! I'll work on \"%s\" for you."):format(data.promptText:sub(1, 60))) do
			data.emitText(v7)
			data.sleep(chunkDelay)
		end

		data.finish("end_turn")
	end

	local function stringResponder(p2)
		return function(data)
			for k, v7 in streamWords(p2) do
				data.emitText(v7)
				data.sleep(chunkDelay)
			end

			data.finish("end_turn")
		end
	end

	local function pickResponder()
		local respond = v5.respond

		if respond == nil then
			return defaultResponder
		end

		if typeof(respond) == "string" then
			return function(data)
				for k, v7 in streamWords(respond) do
					data.emitText(v7)
					data.sleep(chunkDelay)
				end

				data.finish("end_turn")
			end
		end

		return respond
	end

	local function runResponder(id, sessionId, prompt)
		local v7 = tostring(id)
		local formatted = `{v7}:user`
		local formatted2 = `{v7}:assistant`
		local v8 = ""

		for k, item in prompt do
			if not (item.type == "text" and typeof(item.text) == "string") then
				continue
			end

			v8 = if v8 == "" then item.text else v8 .. "\n" .. item.text
		end

		local count2 = 0
		local function emitSessionUpdate(p2)
			if v5.onSessionUpdate then
				v5.onSessionUpdate(p2, count2)
			end

			emitNotification(sessionId, p2, count2)
			count2 += 1
		end

		local flag = false
		local function finishTurn(value)
			if flag then
				return
			end

			flag = true
			local v9 = {
				sessionUpdate = "state_change",
				state = "idle",
				stop_reason = value or "end_turn"
			}

			if v5.onSessionUpdate then
				v5.onSessionUpdate(v9, count2)
			end

			emitNotification(sessionId, v9, count2)
			count2 += 1
		end

		local function failTurn(p2, p3)
			if flag then
				return
			end

			flag = true
			emitResponse(id, {
				error = { code = p2, message = p3 }
			})
		end

		local v9 = {
			sessionUpdate = "user_message",
			messageId = formatted,
			content = prompt
		}

		if v5.onSessionUpdate then
			v5.onSessionUpdate(v9, count2)
		end

		emitNotification(sessionId, v9, count2)
		count2 += 1

		local v10 = { sessionUpdate = "state_change", state = "running" }

		if v5.onSessionUpdate then
			v5.onSessionUpdate(v10, count2)
		end

		emitNotification(sessionId, v10, count2)
		count2 += 1

		local v11 = {
			sessionId = sessionId,
			promptText = v8,
			promptBlocks = prompt,
			sleep = task.wait,
			emitText = function(p2)
				local v12 = {
					sessionUpdate = "agent_message_chunk",
					messageId = formatted2,
					content = { type = "text", text = p2 }
				}

				if v5.onSessionUpdate then
					v5.onSessionUpdate(v12, count2)
				end

				emitNotification(sessionId, v12, count2)
				count2 += 1
			end,
			emitToolCall = function(data)
				local v12 = {
					sessionUpdate = "tool_call_update",
					toolCallId = data.toolCallId,
					title = data.title,
					kind = data.kind,
					status = data.status,
					rawInput = data.rawInput
				}

				if v5.onSessionUpdate then
					v5.onSessionUpdate(v12, count2)
				end

				emitNotification(sessionId, v12, count2)
				count2 += 1
			end,
			updateToolCall = function(p2, data)
				local v12 = {
					sessionUpdate = "tool_call_update",
					toolCallId = p2,
					status = data.status,
					rawOutput = data.rawOutput,
					content = data.content
				}

				if v5.onSessionUpdate then
					v5.onSessionUpdate(v12, count2)
				end

				emitNotification(sessionId, v12, count2)
				count2 += 1
			end,
			setTitle = function(title)
				local v12 = v6[sessionId]

				if v12 then
					v12.title = title
					v12.updatedUtc = DateTime.now():ToIsoDate()
				end

				local v13 = { sessionUpdate = "session_info_update", title = title }

				if v5.onSessionUpdate then
					v5.onSessionUpdate(v13, count2)
				end

				emitNotification(sessionId, v13, count2)
				count2 += 1
			end,
			finish = function(value)
				if flag then
					return
				end

				flag = true
				local v12 = {
					sessionUpdate = "state_change",
					state = "idle",
					stop_reason = value or "end_turn"
				}

				if v5.onSessionUpdate then
					v5.onSessionUpdate(v12, count2)
				end

				emitNotification(sessionId, v12, count2)
				count2 += 1
			end,
			fail = function(p2, p3)
				failTurn(p2, p3)
			end
		}

		task.spawn(function()
			local function callResponder(): nil
				local respond = v5.respond
				local v12

				if respond == nil then
					v12 = defaultResponder
				else
					v12 = typeof(respond) == "string" and function(data)
						for k, v13 in streamWords(respond) do
							data.emitText(v13)
							data.sleep(chunkDelay)
						end

						data.finish("end_turn")
					end or respond
				end

				v12(v11)
				return nil
			end

			local success, result = pcall(callResponder)

			if not success then
				failTurn(AcpProtocol.ErrorCodes.InternalError, "Mock responder errored: " .. tostring(result))
			elseif not flag then
				if flag then
					return
				end

				flag = true
				local v12 = {
					sessionUpdate = "state_change",
					state = "idle",
					stop_reason = "end_turn"
				}

				if v5.onSessionUpdate then
					v5.onSessionUpdate(v12, count2)
				end

				emitNotification(sessionId, v12, count2)
				count2 += 1
			end
		end)
	end

	local function findSession(p2)
		local v7 = v6[p2]

		if v7 == nil or v7.closedUtc ~= nil then
			return nil, {
				code = AcpProtocol.ErrorCodes.NotFound,
				message = "session not found"
			}
		end

		return v7, nil
	end

	local function sessionListEntry(data)
		local v7 = {
			sessionId = data.sessionId,
			title = data.title,
			updatedAt = data.updatedUtc
		}

		if data.project ~= nil then
			v7._meta = {
				_roblox = { universeId = data.project.universeId }
			}
		end

		return v7
	end

	local v7 = {
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
		[AcpProtocol.Methods.SessionNew] = function(p2)
			local sessionNewProject = AcpProtocol.extractSessionNewProject(p2)

			if sessionNewProject == nil then
				return
					nil,
					{
						code = AcpProtocol.ErrorCodes.InvalidParams,
						message = "_meta._roblox universeId/placeId is required on session/new"
					}
			end

			count += 1
			local formatted = ("mock_%08d"):format(count)
			local isoDate = DateTime.now():ToIsoDate()

			v6[formatted] = {
				sessionId = formatted,
				title = nil,
				createdUtc = isoDate,
				updatedUtc = isoDate,
				closedUtc = nil,
				project = sessionNewProject
			}

			if fFlagBuildExperienceModelPickerData and v5.models ~= nil then
				return {
					sessionId = formatted,
					_meta = {
						_roblox = { models = v5.models }
					}
				}, nil
			end

			return { sessionId = formatted }, nil
		end,
		[AcpProtocol.Methods.SessionList] = function(p2)
			local v8 = {}

			for k, v9 in v6 do
				if v9.closedUtc == nil then
					table.insert(v8, sessionListEntry(v9))
				end
			end

			table.sort(v8, function(a, b): boolean
				return (a.updatedAt or "") > (b.updatedAt or "")
			end)

			return { sessions = v8 }, nil
		end,
		[AcpProtocol.Methods.SessionFindByUniverse] = function(p2)
			if typeof(p2.universeId) ~= "number" or p2.universeId == 0 then
				return nil, {
					code = AcpProtocol.ErrorCodes.InvalidParams,
					message = "universeId is required"
				}
			end

			local v8 = {}

			for k, v9 in v6 do
				if v9.closedUtc == nil and v9.project ~= nil and v9.project.universeId == p2.universeId then
					table.insert(v8, sessionListEntry(v9))
				end
			end

			table.sort(v8, function(a, b): boolean
				return (a.updatedAt or "") > (b.updatedAt or "")
			end)

			return { sessions = v8 }, nil
		end,
		[AcpProtocol.Methods.SessionLoad] = function(p2)
			local v8 = v6[p2.sessionId]
			local v9

			if v8 == nil or v8.closedUtc ~= nil then
				v9 = {
					code = AcpProtocol.ErrorCodes.NotFound,
					message = "session not found"
				}
				v8 = nil
			end

			if v9 then
				return nil, v9
			end

			local v13 = if fFlagBuildExperienceModelPickerData then v5.models else nil
			local v14 = if v8.project ~= nil then v8.project.universeId else nil
			return {
				_meta = {
					_roblox = { models = v13, universeId = v14 }
				}
			}, nil
		end,
		[AcpProtocol.Methods.SessionReadTasks] = function(p2)
			local v8 = v6[p2.sessionId]
			local v9 = (v8 == nil or v8.closedUtc ~= nil)
				and { code = AcpProtocol.ErrorCodes.NotFound, message = "session not found" }
				or nil

			if v9 then
				return nil, v9
			end

			return { tasks = {} }, nil
		end,
		[AcpProtocol.Methods.SessionCancel] = function(p2)
			local v8 = v6[p2.sessionId]
			local v9 = (v8 == nil or v8.closedUtc ~= nil)
				and { code = AcpProtocol.ErrorCodes.NotFound, message = "session not found" }
				or nil

			if v9 then
				return nil, v9
			end

			return {}, nil
		end,
		[AcpProtocol.Methods.SessionDelete] = function(p2)
			local v8 = v6[p2.sessionId]

			if v8 == nil then
				return nil, {
					code = AcpProtocol.ErrorCodes.NotFound,
					message = "session not found"
				}
			end

			v8.closedUtc = DateTime.now():ToIsoDate()
			return {}, nil
		end,
		[AcpProtocol.Methods.SessionUpdateInfo] = function(p2)
			local v8 = v6[p2.sessionId]
			local v9

			if v8 == nil or v8.closedUtc ~= nil then
				v9 = {
					code = AcpProtocol.ErrorCodes.NotFound,
					message = "session not found"
				}
				v8 = nil
			end

			if v9 then
				return nil, v9
			end

			if p2.title ~= nil then
				v8.title = p2.title
				v8.updatedUtc = DateTime.now():ToIsoDate()
			end

			return {}, nil
		end,
		[AcpProtocol.Methods.SessionSaveAndPublish] = function(p2)
			return { status = "success", version = "1" }, nil
		end,
		[AcpProtocol.Methods.AdCampaignEligibility] = function(p2)
			if typeof(p2.universeId) == "number" and not (p2.universeId <= 0) then
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
		[AcpProtocol.Methods.AdCampaignCheckFunds] = function(p2)
			if p2.campaignOption == "feedback" or p2.campaignOption == "plays" then
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
				return
					{
						campaignId = "mock_campaign_0001",
						status = "in_review",
						toolCallId = data.toolCallId
					},
					nil
			end

			return nil, {
				code = AcpProtocol.ErrorCodes.InvalidParams,
				message = "idempotencyKey is required"
			}
		end
	}

	local function dispatch(data)
		if data.method == AcpProtocol.Methods.SessionPrompt then
			local v8 = v6[data.params.sessionId]
			local v9

			if v8 == nil or v8.closedUtc ~= nil then
				v9 = {
					code = AcpProtocol.ErrorCodes.NotFound,
					message = "session not found"
				}
				v8 = nil
			end

			if v9 then
				return jsonError(data.id, v9.code, v9.message, httpStatusForCode(v9.code))
			end

			v8.updatedUtc = DateTime.now():ToIsoDate()
			runResponder(data.id, data.params.sessionId, data.params.prompt or {})

			if fFlagBuildExperienceModelPickerData then
				return { statusCode = 202, responseBody = "" }
			end

			return jsonOk(data.id, {})
		else
			local v8 = v7[data.method]

			if v8 == nil then
				return jsonError(
					data.id,
					AcpProtocol.ErrorCodes.MethodNotFound,
					"Method not found: " .. data.method,
					404
				)
			end

			local success, result, v9 = pcall(v8, data.params or {})

			if not success then
				return jsonError(data.id, AcpProtocol.ErrorCodes.InternalError, tostring(result), 500)
			end

			if v9 then
				return jsonError(data.id, v9.code, v9.message, httpStatusForCode(v9.code))
			end

			return jsonOk(data.id, result)
		end
	end

	mockStore = createCreatorAgentChatStore({
		network = {
			request = function(p2, callback)
				local jsonDecode = HttpService:JSONDecode(p2.body or "{}")

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
