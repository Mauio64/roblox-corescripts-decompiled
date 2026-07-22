local HttpService = game:GetService("HttpService")
local AcpProtocol = require(script.Parent.Acp.AcpProtocol)

require(script.Parent.types)

local createCreatorAgentChatStore = require(script.Parent.createCreatorAgentChatStore)

local function isoNow() -- line: 75
	return DateTime.now():ToIsoDate()
end
local function jsonError(p1, n1: number, s1: string, n2: number) -- line: 79
	-- upvalues: HttpService (copy)
	return {
		statusCode = n2,
		responseBody = HttpService:JSONEncode({
			jsonrpc = "2.0",
			id = p1,
			error = {
				code = n1,
				message = s1
			}
		})
	}
end
local function jsonOk(p2, p3) -- line: 90
	-- upvalues: HttpService (copy)
	return {
		statusCode = 200,
		responseBody = HttpService:JSONEncode({
			jsonrpc = "2.0",
			id = p2,
			result = p3
		})
	}
end
local function streamWords(s2: string) -- line: 97
	local t1 = {}
	local v18 = true

	for match in s2:gmatch("%S+") do
		if v18 then
			table.insert(t1, match)
			v18 = false
		else
			table.insert(t1, " " .. match)
		end
	end

	return t1
end
local function httpStatusForCode(n3: number) -- line: 112
	-- upvalues: AcpProtocol (copy)
	if n3 == AcpProtocol.ErrorCodes.NotFound then
		return 404
	end

	if n3 == AcpProtocol.ErrorCodes.Gone then
		return 410
	end

	if n3 == AcpProtocol.ErrorCodes.Conflict then
		return 409
	end

	if n3 == AcpProtocol.ErrorCodes.UpstreamUnavailable then
		return 502
	end

	if n3 == AcpProtocol.ErrorCodes.Unauthorized then
		return 401
	end

	if n3 == AcpProtocol.ErrorCodes.Forbidden then
		return 403
	end

	if n3 == AcpProtocol.ErrorCodes.InternalError then
		return 500
	end

	return 400
end
local function createMockStore(t2: {[any]: any}?) -- line: 131
	-- upvalues: AcpProtocol (copy), streamWords (copy), jsonError (copy), httpStatusForCode (copy), jsonOk (copy), HttpService (copy), createCreatorAgentChatStore (copy)
	local v22 = t2 or {}
	local v23 = v22.chunkDelay or 0.04
	local t3 = {}
	local n4 = 0

	if v22.initialSessions then
		for _, v27 in v22.initialSessions do
			n4 += 1

			local v28 = v27.sessionId or ("mock_seed_%08d"):format(n4)
			local v29 = DateTime.now():ToIsoDate()

			t3[v28] = {
				closedUtc = nil,
				sessionId = v28,
				title = v27.title,
				createdUtc = v29,
				updatedUtc = v29
			}
		end
	end

	local function newSessionId() -- line: 153
		-- upvalues: n4 (ref)
		n4 += 1

		return ("mock_%08d"):format(n4)
	end

	local u31 = nil

	local function emitNotification(s3: string, p4, n5: number) -- line: 160
		-- upvalues: u31 (ref), AcpProtocol (copy)
		u31.ingestFrame({
			kind = "notification",
			notification = {
				method = AcpProtocol.Notifications.SessionUpdate,
				params = {
					sessionId = s3,
					update = p4
				}
			}
		}, {
			sequenceNumber = n5
		})
	end
	local function emitResponse(p5, t4: {[any]: any}) -- line: 172
		-- upvalues: u31 (ref)
		u31.ingestFrame({
			kind = "response",
			response = {
				jsonrpc = "2.0",
				id = p5,
				result = t4.result,
				error = t4.error
			}
		})
	end
	local function defaultResponder(t5: {[any]: any}) -- line: 184
		-- upvalues: streamWords (copy), v23 (copy)
		local v49 = ("Sure! I'll work on \"%s\" for you."):format(t5.promptText:sub(1, 60))

		for _, v51 in streamWords(v49) do
			t5.emitText(v51)
			t5.sleep(v23)
		end

		t5.finish("end_turn")
	end
	local function stringResponder(s4: string) -- line: 193
		-- upvalues: streamWords (copy), v23 (copy)
		return function(p6) -- line: 194
			-- upvalues: streamWords (copy), s4 (copy), v23 (copy)
			for _, v114 in streamWords(s4) do
				p6.emitText(v114)
				p6.sleep(v23)
			end

			p6.finish("end_turn")
		end
	end
	local function pickResponder() -- line: 203
		-- upvalues: v22 (copy), defaultResponder (copy), streamWords (copy), v23 (copy)
		local respond = v22.respond

		if respond == nil then
			return defaultResponder
		end

		if typeof(respond) == "string" then
			return function(p7) -- line: 194
				-- upvalues: streamWords (copy), respond (copy), v23 (copy)
				for _, v117 in streamWords(respond) do
					p7.emitText(v117)
					p7.sleep(v23)
				end

				p7.finish("end_turn")
			end
		end

		return respond
	end
	local function runResponder(p8, s5: string, t6: {[any]: any}) -- line: 213
		-- upvalues: v22 (copy), emitNotification (copy), emitResponse (copy), t3 (copy), defaultResponder (copy), streamWords (copy), v23 (copy), AcpProtocol (copy)
		local str = tostring(p8)
		local v58 = `{ str }:user`
		local v59 = `{ str }:assistant`
		local s6 = ""

		for _, v62 in t6 do
			if v62.type == "text" and typeof(v62.text) == "string" then
				s6 = if s6 ~= "" then s6 .. "\n" .. v62.text else v62.text
			end
		end

		local n6 = 0

		local function emitSessionUpdate(p9) -- line: 225
			-- upvalues: v22 (copy), n6 (ref), emitNotification (copy), s5 (copy)
			if v22.onSessionUpdate then
				v22.onSessionUpdate(p9, n6)
			end

			emitNotification(s5, p9, n6)
			n6 += 1
		end

		local u65 = false

		local function finishTurn(p10) -- line: 234
			-- upvalues: u65 (ref), v22 (copy), n6 (ref), emitNotification (copy), s5 (copy)
			if u65 then
				return
			end

			u65 = true

			local t7 = {
				sessionUpdate = "state_change",
				state = "idle",
				stop_reason = p10 or "end_turn"
			}

			if v22.onSessionUpdate then
				v22.onSessionUpdate(t7, n6)
			end

			emitNotification(s5, t7, n6)
			n6 += 1
		end
		local function failTurn(n7: number, s7: string) -- line: 246
			-- upvalues: u65 (ref), emitResponse (copy), p8 (copy)
			if u65 then
				return
			end

			u65 = true
			emitResponse(p8, {
				error = {
					code = n7,
					message = s7
				}
			})
		end

		local t8 = {
			sessionUpdate = "user_message",
			messageId = v58,
			content = t6
		}

		if v22.onSessionUpdate then
			v22.onSessionUpdate(t8, n6)
		end

		emitNotification(s5, t8, n6)
		n6 += 1

		local t9 = {
			sessionUpdate = "state_change",
			state = "running"
		}

		if v22.onSessionUpdate then
			v22.onSessionUpdate(t9, n6)
		end

		emitNotification(s5, t9, n6)
		n6 += 1

		local t15 = {
			sessionId = s5,
			promptText = s6,
			promptBlocks = t6,
			sleep = task.wait,
			emitText = function(p11) -- line: 269
				-- upvalues: v59 (copy), v22 (copy), n6 (ref), emitNotification (copy), s5 (copy)
				local t10 = {
					sessionUpdate = "agent_message_chunk",
					messageId = v59,
					content = {
						type = "text",
						text = p11
					}
				}

				if v22.onSessionUpdate then
					v22.onSessionUpdate(t10, n6)
				end

				emitNotification(s5, t10, n6)
				n6 += 1
			end,
			emitToolCall = function(p12) -- line: 276
				-- upvalues: v22 (copy), n6 (ref), emitNotification (copy), s5 (copy)
				local t11 = {
					sessionUpdate = "tool_call_update",
					toolCallId = p12.toolCallId,
					title = p12.title,
					kind = p12.kind,
					status = p12.status,
					rawInput = p12.rawInput
				}

				if v22.onSessionUpdate then
					v22.onSessionUpdate(t11, n6)
				end

				emitNotification(s5, t11, n6)
				n6 += 1
			end,
			updateToolCall = function(p13, p14) -- line: 286
				-- upvalues: v22 (copy), n6 (ref), emitNotification (copy), s5 (copy)
				local t12 = {
					sessionUpdate = "tool_call_update",
					toolCallId = p13,
					status = p14.status,
					rawOutput = p14.rawOutput,
					content = p14.content
				}

				if v22.onSessionUpdate then
					v22.onSessionUpdate(t12, n6)
				end

				emitNotification(s5, t12, n6)
				n6 += 1
			end,
			setTitle = function(p15) -- line: 295
				-- upvalues: t3 (copy), s5 (copy), v22 (copy), n6 (ref), emitNotification (copy)
				local v131 = t3[s5]

				if v131 then
					v131.title = p15
					v131.updatedUtc = DateTime.now():ToIsoDate()
				end

				local t13 = {
					sessionUpdate = "session_info_update",
					title = p15
				}

				if v22.onSessionUpdate then
					v22.onSessionUpdate(t13, n6)
				end

				emitNotification(s5, t13, n6)
				n6 += 1
			end,
			finish = function(p16) -- line: 303
				-- upvalues: u65 (ref), v22 (copy), n6 (ref), emitNotification (copy), s5 (copy)
				if u65 then
					return
				end

				u65 = true

				local t14 = {
					sessionUpdate = "state_change",
					state = "idle",
					stop_reason = p16 or "end_turn"
				}

				if v22.onSessionUpdate then
					v22.onSessionUpdate(t14, n6)
				end

				emitNotification(s5, t14, n6)
				n6 += 1
			end,
			fail = function(p17, p18) -- line: 306
				-- upvalues: failTurn (copy)
				failTurn(p17, p18)
			end
		}

		task.spawn(function() -- line: 311
			-- upvalues: v22 (copy), defaultResponder (copy), streamWords (copy), v23 (copy), t15 (copy), failTurn (copy), AcpProtocol (copy), u65 (ref), n6 (ref), emitNotification (copy), s5 (copy)
			local function callResponder() -- line: 313
				-- upvalues: v22 (copy), defaultResponder (copy), streamWords (copy), v23 (copy), t15 (copy)
				local respond = v22.respond;

				((if respond ~= nil then (if typeof(respond) ~= "string" then respond else function(p19) -- line: 194
					-- upvalues: streamWords (copy), respond (copy), v23 (copy)
					for _, v148 in streamWords(respond) do
						p19.emitText(v148)
						p19.sleep(v23)
					end

					p19.finish("end_turn")
				end) else defaultResponder))(t15)

				return nil
			end

			local ok, result = pcall(callResponder)

			if not ok then
				failTurn(AcpProtocol.ErrorCodes.InternalError, "Mock responder errored: " .. tostring(result))

				return
			end

			if not u65 then
				if u65 then
					return
				end

				u65 = true

				local t16 = {
					sessionUpdate = "state_change",
					state = "idle",
					stop_reason = "end_turn"
				}

				if v22.onSessionUpdate then
					v22.onSessionUpdate(t16, n6)
				end

				emitNotification(s5, t16, n6)
				n6 += 1
			end
		end)
	end
	local function findSession(s8: string) -- line: 326
		-- upvalues: t3 (copy), AcpProtocol (copy)
		local v72 = t3[s8]

		if v72 == nil or v72.closedUtc ~= nil then
			return nil, {
				message = "session not found",
				code = AcpProtocol.ErrorCodes.NotFound
			}
		end

		return v72, nil
	end
	local function sessionListEntry(t17: {[any]: any}) -- line: 334
		local t18 = {
			sessionId = t17.sessionId,
			title = t17.title,
			updatedAt = t17.updatedUtc
		}

		if t17.project ~= nil then
			t18._meta = {
				_roblox = {
					universeId = t17.project.universeId
				}
			}
		end

		return t18
	end

	local t23 = {
		[AcpProtocol.Methods.Initialize] = function() -- line: 353
			-- upvalues: AcpProtocol (copy)
			return {
				protocolVersion = AcpProtocol.ProtocolVersion,
				capabilities = {
					session = {
						load = {},
						prompt = {
							image = true,
							audio = false,
							embeddedContext = true
						},
						mcp = {
							http = {}
						}
					},
					_meta = {
						_roblox = {
							localToolExecution = true
						}
					}
				},
				agentInfo = {
					name = "mock-my-stats-service",
					version = "0.0.1-mock"
				}
			}, nil
		end,
		[AcpProtocol.Methods.SessionNew] = function(p20) -- line: 368
			-- upvalues: AcpProtocol (copy), n4 (ref), t3 (copy)
			local v76 = AcpProtocol.extractSessionNewProject(p20)

			if v76 == nil then
				return nil, {
					message = "_meta._roblox universeId/placeId is required on session/new",
					code = AcpProtocol.ErrorCodes.InvalidParams
				}
			end

			n4 += 1

			local v77 = ("mock_%08d"):format(n4)
			local v78 = DateTime.now():ToIsoDate()

			t3[v77] = {
				title = nil,
				closedUtc = nil,
				sessionId = v77,
				createdUtc = v78,
				updatedUtc = v78,
				project = v76
			}

			return {
				sessionId = v77
			}, nil
		end,
		[AcpProtocol.Methods.SessionList] = function(_) -- line: 389
			-- upvalues: t3 (copy), sessionListEntry (copy)
			local t19 = {}

			for _, v82 in t3 do
				if v82.closedUtc == nil then
					table.insert(t19, (sessionListEntry(v82)))
				end
			end

			table.sort(t19, function(p22, p23) -- line: 396
				return (p22.updatedAt or "") > (p23.updatedAt or "")
			end)

			return {
				sessions = t19
			}, nil
		end,
		[AcpProtocol.Methods.SessionFindByUniverse] = function(p24) -- line: 401
			-- upvalues: AcpProtocol (copy), t3 (copy), sessionListEntry (copy)
			if typeof(p24.universeId) ~= "number" or p24.universeId == 0 then
				return nil, {
					message = "universeId is required",
					code = AcpProtocol.ErrorCodes.InvalidParams
				}
			end

			local t20 = {}

			for _, v86 in t3 do
				if v86.closedUtc == nil and v86.project ~= nil and v86.project.universeId == p24.universeId then
					table.insert(t20, (sessionListEntry(v86)))
				end
			end

			table.sort(t20, function(p25, p26) -- line: 419
				return (p25.updatedAt or "") > (p26.updatedAt or "")
			end)

			return {
				sessions = t20
			}, nil
		end,
		[AcpProtocol.Methods.SessionLoad] = function(p27) -- line: 424
			-- upvalues: t3 (copy), AcpProtocol (copy)
			local v88 = t3[p27.sessionId]
			local t21

			if v88 == nil or v88.closedUtc ~= nil then
				v88 = nil
				t21 = {
					message = "session not found",
					code = AcpProtocol.ErrorCodes.NotFound
				}
			else
				t21 = nil
			end

			if t21 then
				return nil, t21
			end

			return {
				_meta = {
					_roblox = {
						universeId = if v88.project == nil then nil else v88.project.universeId
					}
				}
			}, nil
		end,
		[AcpProtocol.Methods.SessionReadTasks] = function(p28) -- line: 440
			-- upvalues: t3 (copy), AcpProtocol (copy)
			local v91 = t3[p28.sessionId]
			local v92 = if v91 ~= nil and v91.closedUtc == nil then nil else {
				message = "session not found",
				code = AcpProtocol.ErrorCodes.NotFound
			}

			if v92 then
				return nil, v92
			end

			return {
				tasks = {}
			}, nil
		end,
		[AcpProtocol.Methods.SessionCancel] = function(p29) -- line: 447
			-- upvalues: t3 (copy), AcpProtocol (copy)
			local v94 = t3[p29.sessionId]
			local v95 = if v94 ~= nil and v94.closedUtc == nil then nil else {
				message = "session not found",
				code = AcpProtocol.ErrorCodes.NotFound
			}

			if v95 then
				return nil, v95
			end

			return {}, nil
		end,
		[AcpProtocol.Methods.SessionDelete] = function(p30) -- line: 455
			-- upvalues: t3 (copy), AcpProtocol (copy)
			local v97 = t3[p30.sessionId]

			if v97 == nil then
				return nil, {
					message = "session not found",
					code = AcpProtocol.ErrorCodes.NotFound
				}
			end

			v97.closedUtc = DateTime.now():ToIsoDate()

			return {}, nil
		end,
		[AcpProtocol.Methods.SessionUpdateInfo] = function(p31) -- line: 463
			-- upvalues: t3 (copy), AcpProtocol (copy)
			local v99 = t3[p31.sessionId]
			local t22

			if v99 == nil or v99.closedUtc ~= nil then
				v99 = nil
				t22 = {
					message = "session not found",
					code = AcpProtocol.ErrorCodes.NotFound
				}
			else
				t22 = nil
			end

			if t22 then
				return nil, t22
			end

			if p31.title ~= nil then
				v99.title = p31.title
				v99.updatedUtc = DateTime.now():ToIsoDate()
			end

			return {}, nil
		end,
		[AcpProtocol.Methods.SessionSaveAndPublish] = function(_) -- line: 475
			return {
				status = "success",
				version = "1"
			}, nil
		end
	}

	local function dispatch(t24: {[any]: any}) -- line: 480
		-- upvalues: AcpProtocol (copy), t3 (copy), jsonError (copy), httpStatusForCode (copy), runResponder (copy), jsonOk (copy), t23 (copy)
		if t24.method == AcpProtocol.Methods.SessionPrompt then
			local v103 = t3[t24.params.sessionId]
			local t25

			if v103 == nil or v103.closedUtc ~= nil then
				v103 = nil
				t25 = {
					message = "session not found",
					code = AcpProtocol.ErrorCodes.NotFound
				}
			else
				t25 = nil
			end

			if t25 then
				return (jsonError(t24.id, t25.code, t25.message, (httpStatusForCode(t25.code))))
			end

			v103.updatedUtc = DateTime.now():ToIsoDate()
			runResponder(t24.id, t24.params.sessionId, t24.params.prompt or {})

			return (jsonOk(t24.id, {}))
		end

		local v105 = t23[t24.method]

		if v105 == nil then
			return (jsonError(t24.id, AcpProtocol.ErrorCodes.MethodNotFound, "Method not found: " .. t24.method, 404))
		end

		local ok, result, v108 = pcall(v105, t24.params or {})

		if not ok then
			return (jsonError(t24.id, AcpProtocol.ErrorCodes.InternalError, tostring(result), 500))
		end

		if v108 then
			return (jsonError(t24.id, v108.code, v108.message, (httpStatusForCode(v108.code))))
		end

		return (jsonOk(t24.id, result))
	end

	local t26 = {
		request = function(p33, p34) -- line: 509
			-- upvalues: HttpService (copy), dispatch (copy)
			local data = HttpService:JSONDecode(p33.body or "{}")

			if typeof(data) == "table" and (typeof(data.result) == "table" and data.result.tool_name == "ask_tool") then
				p34(true, {
					statusCode = 200,
					responseBody = "{\"jsonrpc\":\"2.0\",\"id\":1,\"result\":{}}"
				})

				return function() -- line: 517
				end
			end

			p34(true, (dispatch(data)))

			return function() -- line: 520
			end
		end
	}

	u31 = createCreatorAgentChatStore({
		baseUrl = "mock://my-stats/v2",
		network = t26
	})

	return u31
end

return createMockStore
