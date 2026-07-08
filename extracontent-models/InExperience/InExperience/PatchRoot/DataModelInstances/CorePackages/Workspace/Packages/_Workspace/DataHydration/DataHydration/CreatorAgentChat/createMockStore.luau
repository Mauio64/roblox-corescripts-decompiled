local HttpService = game:GetService("HttpService")
local AcpProtocol = require(script.Parent.Acp.AcpProtocol)

require(script.Parent.types)

local createCreatorAgentChatStore = require(script.Parent.createCreatorAgentChatStore)

local function isoNow() -- line: 76
	return DateTime.now():ToIsoDate()
end
local function jsonError(p1, n1: number, s1: string, n2: number) -- line: 80
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
local function jsonOk(p2, p3) -- line: 91
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
local function streamWords(s2: string) -- line: 98
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
local function httpStatusForCode(n3: number) -- line: 113
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
local function createMockStore(t2: {[any]: any}?) -- line: 132
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

	local function newSessionId() -- line: 154
		-- upvalues: n4 (ref)
		n4 += 1

		return ("mock_%08d"):format(n4)
	end

	local u31 = nil

	local function emitNotification(s3: string, p4, n5: number) -- line: 161
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
	local function emitResponse(p5, t4: {[any]: any}) -- line: 173
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
	local function defaultResponder(t5: {[any]: any}) -- line: 185
		-- upvalues: streamWords (copy), v23 (copy)
		t5.emitThought("Let me think about that...")
		t5.sleep(0.15)

		local v49 = ("Sure! I'll work on \"%s\" for you."):format(t5.promptText:sub(1, 60))

		for _, v51 in streamWords(v49) do
			t5.emitText(v51)
			t5.sleep(v23)
		end

		t5.finish("end_turn")
	end
	local function stringResponder(s4: string) -- line: 196
		-- upvalues: streamWords (copy), v23 (copy)
		return function(p6) -- line: 197
			-- upvalues: streamWords (copy), s4 (copy), v23 (copy)
			for _, v114 in streamWords(s4) do
				p6.emitText(v114)
				p6.sleep(v23)
			end

			p6.finish("end_turn")
		end
	end
	local function pickResponder() -- line: 206
		-- upvalues: v22 (copy), defaultResponder (copy), streamWords (copy), v23 (copy)
		local respond = v22.respond

		if respond == nil then
			return defaultResponder
		end

		if typeof(respond) == "string" then
			return function(p7) -- line: 197
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
	local function runResponder(p8, s5: string, t6: {[any]: any}) -- line: 216
		-- upvalues: v22 (copy), emitNotification (copy), emitResponse (copy), t3 (copy), defaultResponder (copy), streamWords (copy), v23 (copy), AcpProtocol (copy)
		local str = tostring(p8)
		local v58 = `{ str }:user`
		local v59 = `{ str }:assistant`
		local v60 = `{ str }:thought`
		local s6 = ""

		for _, v63 in t6 do
			if v63.type == "text" and typeof(v63.text) == "string" then
				s6 = if s6 ~= "" then s6 .. "\n" .. v63.text else v63.text
			end
		end

		local n6 = 0

		local function emitSessionUpdate(p9) -- line: 229
			-- upvalues: v22 (copy), n6 (ref), emitNotification (copy), s5 (copy)
			if v22.onSessionUpdate then
				v22.onSessionUpdate(p9, n6)
			end

			emitNotification(s5, p9, n6)
			n6 += 1
		end

		local u66 = false

		local function finishTurn(p10) -- line: 238
			-- upvalues: u66 (ref), v22 (copy), n6 (ref), emitNotification (copy), s5 (copy)
			if u66 then
				return
			end

			u66 = true

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
		local function failTurn(n7: number, s7: string) -- line: 250
			-- upvalues: u66 (ref), emitResponse (copy), p8 (copy)
			if u66 then
				return
			end

			u66 = true
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

		local t16 = {
			sessionId = s5,
			promptText = s6,
			promptBlocks = t6,
			sleep = task.wait,
			emitText = function(p11) -- line: 273
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
			emitThought = function(p12) -- line: 280
				-- upvalues: v60 (copy), v22 (copy), n6 (ref), emitNotification (copy), s5 (copy)
				local t11 = {
					sessionUpdate = "agent_thought_chunk",
					messageId = v60,
					content = {
						type = "text",
						text = p12
					}
				}

				if v22.onSessionUpdate then
					v22.onSessionUpdate(t11, n6)
				end

				emitNotification(s5, t11, n6)
				n6 += 1
			end,
			emitToolCall = function(p13) -- line: 287
				-- upvalues: v22 (copy), n6 (ref), emitNotification (copy), s5 (copy)
				local t12 = {
					sessionUpdate = "tool_call_update",
					toolCallId = p13.toolCallId,
					title = p13.title,
					kind = p13.kind,
					status = p13.status,
					rawInput = p13.rawInput
				}

				if v22.onSessionUpdate then
					v22.onSessionUpdate(t12, n6)
				end

				emitNotification(s5, t12, n6)
				n6 += 1
			end,
			updateToolCall = function(p14, p15) -- line: 297
				-- upvalues: v22 (copy), n6 (ref), emitNotification (copy), s5 (copy)
				local t13 = {
					sessionUpdate = "tool_call_update",
					toolCallId = p14,
					status = p15.status,
					rawOutput = p15.rawOutput,
					content = p15.content
				}

				if v22.onSessionUpdate then
					v22.onSessionUpdate(t13, n6)
				end

				emitNotification(s5, t13, n6)
				n6 += 1
			end,
			setTitle = function(p16) -- line: 306
				-- upvalues: t3 (copy), s5 (copy), v22 (copy), n6 (ref), emitNotification (copy)
				local v133 = t3[s5]

				if v133 then
					v133.title = p16
					v133.updatedUtc = DateTime.now():ToIsoDate()
				end

				local t14 = {
					sessionUpdate = "session_info_update",
					title = p16
				}

				if v22.onSessionUpdate then
					v22.onSessionUpdate(t14, n6)
				end

				emitNotification(s5, t14, n6)
				n6 += 1
			end,
			finish = function(p17) -- line: 314
				-- upvalues: u66 (ref), v22 (copy), n6 (ref), emitNotification (copy), s5 (copy)
				if u66 then
					return
				end

				u66 = true

				local t15 = {
					sessionUpdate = "state_change",
					state = "idle",
					stop_reason = p17 or "end_turn"
				}

				if v22.onSessionUpdate then
					v22.onSessionUpdate(t15, n6)
				end

				emitNotification(s5, t15, n6)
				n6 += 1
			end,
			fail = function(p18, p19) -- line: 317
				-- upvalues: failTurn (copy)
				failTurn(p18, p19)
			end
		}

		task.spawn(function() -- line: 322
			-- upvalues: v22 (copy), defaultResponder (copy), streamWords (copy), v23 (copy), t16 (copy), failTurn (copy), AcpProtocol (copy), u66 (ref), n6 (ref), emitNotification (copy), s5 (copy)
			local function callResponder() -- line: 324
				-- upvalues: v22 (copy), defaultResponder (copy), streamWords (copy), v23 (copy), t16 (copy)
				local respond = v22.respond;

				((if respond ~= nil then (if typeof(respond) ~= "string" then respond else function(p20) -- line: 197
					-- upvalues: streamWords (copy), respond (copy), v23 (copy)
					for _, v150 in streamWords(respond) do
						p20.emitText(v150)
						p20.sleep(v23)
					end

					p20.finish("end_turn")
				end) else defaultResponder))(t16)

				return nil
			end

			local ok, result = pcall(callResponder)

			if not ok then
				failTurn(AcpProtocol.ErrorCodes.InternalError, "Mock responder errored: " .. tostring(result))

				return
			end

			if not u66 then
				if u66 then
					return
				end

				u66 = true

				local t17 = {
					sessionUpdate = "state_change",
					state = "idle",
					stop_reason = "end_turn"
				}

				if v22.onSessionUpdate then
					v22.onSessionUpdate(t17, n6)
				end

				emitNotification(s5, t17, n6)
				n6 += 1
			end
		end)
	end
	local function findSession(s8: string) -- line: 337
		-- upvalues: t3 (copy), AcpProtocol (copy)
		local v73 = t3[s8]

		if v73 == nil or v73.closedUtc ~= nil then
			return nil, {
				message = "session not found",
				code = AcpProtocol.ErrorCodes.NotFound
			}
		end

		return v73, nil
	end
	local function sessionListEntry(t18: {[any]: any}) -- line: 345
		local t19 = {
			sessionId = t18.sessionId,
			title = t18.title,
			updatedAt = t18.updatedUtc
		}

		if t18.project ~= nil then
			t19._meta = {
				_roblox = {
					universeId = t18.project.universeId
				}
			}
		end

		return t19
	end

	local t24 = {
		[AcpProtocol.Methods.Initialize] = function() -- line: 364
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
		[AcpProtocol.Methods.SessionNew] = function(p21) -- line: 379
			-- upvalues: AcpProtocol (copy), n4 (ref), t3 (copy)
			local v77 = AcpProtocol.extractSessionNewProject(p21)

			if v77 == nil then
				return nil, {
					message = "_meta._roblox universeId/placeId is required on session/new",
					code = AcpProtocol.ErrorCodes.InvalidParams
				}
			end

			n4 += 1

			local v78 = ("mock_%08d"):format(n4)
			local v79 = DateTime.now():ToIsoDate()

			t3[v78] = {
				title = nil,
				closedUtc = nil,
				sessionId = v78,
				createdUtc = v79,
				updatedUtc = v79,
				project = v77
			}

			return {
				sessionId = v78
			}, nil
		end,
		[AcpProtocol.Methods.SessionList] = function(_) -- line: 400
			-- upvalues: t3 (copy), sessionListEntry (copy)
			local t20 = {}

			for _, v83 in t3 do
				if v83.closedUtc == nil then
					table.insert(t20, (sessionListEntry(v83)))
				end
			end

			table.sort(t20, function(p23, p24) -- line: 407
				return (p23.updatedAt or "") > (p24.updatedAt or "")
			end)

			return {
				sessions = t20
			}, nil
		end,
		[AcpProtocol.Methods.SessionFindByUniverse] = function(p25) -- line: 412
			-- upvalues: AcpProtocol (copy), t3 (copy), sessionListEntry (copy)
			if typeof(p25.universeId) ~= "number" or p25.universeId == 0 then
				return nil, {
					message = "universeId is required",
					code = AcpProtocol.ErrorCodes.InvalidParams
				}
			end

			local t21 = {}

			for _, v87 in t3 do
				if v87.closedUtc == nil and v87.project ~= nil and v87.project.universeId == p25.universeId then
					table.insert(t21, (sessionListEntry(v87)))
				end
			end

			table.sort(t21, function(p26, p27) -- line: 430
				return (p26.updatedAt or "") > (p27.updatedAt or "")
			end)

			return {
				sessions = t21
			}, nil
		end,
		[AcpProtocol.Methods.SessionLoad] = function(p28) -- line: 435
			-- upvalues: t3 (copy), AcpProtocol (copy)
			local v89 = t3[p28.sessionId]
			local t22

			if v89 == nil or v89.closedUtc ~= nil then
				v89 = nil
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

			return {
				_meta = {
					_roblox = {
						universeId = if v89.project == nil then nil else v89.project.universeId
					}
				}
			}, nil
		end,
		[AcpProtocol.Methods.SessionReadTasks] = function(p29) -- line: 451
			-- upvalues: t3 (copy), AcpProtocol (copy)
			local v92 = t3[p29.sessionId]
			local v93 = if v92 ~= nil and v92.closedUtc == nil then nil else {
				message = "session not found",
				code = AcpProtocol.ErrorCodes.NotFound
			}

			if v93 then
				return nil, v93
			end

			return {
				tasks = {}
			}, nil
		end,
		[AcpProtocol.Methods.SessionCancel] = function(p30) -- line: 458
			-- upvalues: t3 (copy), AcpProtocol (copy)
			local v95 = t3[p30.sessionId]
			local v96 = if v95 ~= nil and v95.closedUtc == nil then nil else {
				message = "session not found",
				code = AcpProtocol.ErrorCodes.NotFound
			}

			if v96 then
				return nil, v96
			end

			return {}, nil
		end,
		[AcpProtocol.Methods.SessionDelete] = function(p31) -- line: 466
			-- upvalues: t3 (copy), AcpProtocol (copy)
			local v98 = t3[p31.sessionId]

			if v98 == nil then
				return nil, {
					message = "session not found",
					code = AcpProtocol.ErrorCodes.NotFound
				}
			end

			v98.closedUtc = DateTime.now():ToIsoDate()

			return {}, nil
		end,
		[AcpProtocol.Methods.SessionUpdateInfo] = function(p32) -- line: 474
			-- upvalues: t3 (copy), AcpProtocol (copy)
			local v100 = t3[p32.sessionId]
			local t23

			if v100 == nil or v100.closedUtc ~= nil then
				v100 = nil
				t23 = {
					message = "session not found",
					code = AcpProtocol.ErrorCodes.NotFound
				}
			else
				t23 = nil
			end

			if t23 then
				return nil, t23
			end

			if p32.title ~= nil then
				v100.title = p32.title
				v100.updatedUtc = DateTime.now():ToIsoDate()
			end

			return {}, nil
		end
	}

	local function dispatch(t25: {[any]: any}) -- line: 488
		-- upvalues: AcpProtocol (copy), t3 (copy), jsonError (copy), httpStatusForCode (copy), runResponder (copy), jsonOk (copy), t24 (copy)
		if t25.method == AcpProtocol.Methods.SessionPrompt then
			local v103 = t3[t25.params.sessionId]
			local t26

			if v103 == nil or v103.closedUtc ~= nil then
				v103 = nil
				t26 = {
					message = "session not found",
					code = AcpProtocol.ErrorCodes.NotFound
				}
			else
				t26 = nil
			end

			if t26 then
				return (jsonError(t25.id, t26.code, t26.message, (httpStatusForCode(t26.code))))
			end

			v103.updatedUtc = DateTime.now():ToIsoDate()
			runResponder(t25.id, t25.params.sessionId, t25.params.prompt or {})

			return (jsonOk(t25.id, {}))
		end

		local v105 = t24[t25.method]

		if v105 == nil then
			return (jsonError(t25.id, AcpProtocol.ErrorCodes.MethodNotFound, "Method not found: " .. t25.method, 404))
		end

		local ok, result, v108 = pcall(v105, t25.params or {})

		if not ok then
			return (jsonError(t25.id, AcpProtocol.ErrorCodes.InternalError, tostring(result), 500))
		end

		if v108 then
			return (jsonError(t25.id, v108.code, v108.message, (httpStatusForCode(v108.code))))
		end

		return (jsonOk(t25.id, result))
	end

	local t27 = {
		request = function(p33, p34) -- line: 517
			-- upvalues: HttpService (copy), dispatch (copy)
			local data = HttpService:JSONDecode(p33.body or "{}")

			if typeof(data) == "table" and (typeof(data.result) == "table" and data.result.tool_name == "ask_tool") then
				p34(true, {
					statusCode = 200,
					responseBody = "{\"jsonrpc\":\"2.0\",\"id\":1,\"result\":{}}"
				})

				return function() -- line: 525
				end
			end

			p34(true, (dispatch(data)))

			return function() -- line: 528
			end
		end
	}

	u31 = createCreatorAgentChatStore({
		baseUrl = "mock://my-stats/v2",
		network = t27
	})

	return u31
end

return createMockStore
