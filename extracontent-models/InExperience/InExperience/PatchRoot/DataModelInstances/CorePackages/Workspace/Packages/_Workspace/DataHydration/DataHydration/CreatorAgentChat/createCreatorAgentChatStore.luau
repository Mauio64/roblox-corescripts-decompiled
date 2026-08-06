local DataHydration = script:FindFirstAncestor("DataHydration")
local DataHydrationParent = DataHydration.Parent
local HttpClient = require(DataHydrationParent.HttpClient)
local Signals = require(DataHydrationParent.Signals)
local AcpProtocol = require(script.Parent.Acp.AcpProtocol)
local historyIngest = require(script.Parent.CasStore.historyIngest)
local ingestFrameHandler = require(script.Parent.CasStore.ingestFrameHandler)
local sessionRegistry = require(script.Parent.CasStore.sessionRegistry)
local constants = require(script.Parent.ChatSession.constants)
local createTurnHandle = require(script.Parent.createTurnHandle)
local onTerminal = require(script.Parent.onTerminal)
local rpcDecoder = require(script.Parent.rpcDecoder)

require(script.Parent.types)

local withCsrfRetry = require(DataHydration.withCsrfRetry)

local function normalizeNextPageToken(p1) -- line: 39
	if typeof(p1) == "string" and p1 ~= "" then
		return p1
	end

	return nil
end
local function appendSessionListEntries(t1: {[any]: any}, t2: {[any]: any}) -- line: 46
	local t3 = {}
	local t4 = {}

	for _, v25 in t1 do
		local sessionId = v25.sessionId

		if typeof(sessionId) == "string" and sessionId ~= "" then
			t3[sessionId] = true
		end

		table.insert(t4, v25)
	end

	for _, v28 in t2 do
		local sessionId = v28.sessionId

		if typeof(sessionId) == "string" and sessionId ~= "" and not t3[sessionId] then
			t3[sessionId] = true
			table.insert(t4, v28)
		end
	end

	return t4
end
local function normalizePrompt(p2) -- line: 71
	if typeof(p2) == "string" then
		return {{
			type = "text",
			text = p2
		}}
	end

	return p2
end

local t5 = {
	debug = function() -- line: 79
	end,
	info = function() -- line: 80
	end,
	warning = function() -- line: 81
	end,
	error = function() -- line: 82
	end
}

local function createCreatorAgentChatStore(p3) -- line: 85
	-- upvalues: withCsrfRetry (copy), HttpClient (copy), AcpProtocol (copy), t5 (copy), rpcDecoder (copy), Signals (copy), onTerminal (copy), appendSessionListEntries (copy), createTurnHandle (copy), historyIngest (copy), sessionRegistry (copy), constants (copy), ingestFrameHandler (copy)
	local v32 = p3 or {}
	local v33 = v32.network or withCsrfRetry(HttpClient.createRequestInternalNetwork())
	local v34 = v32.baseUrl or AcpProtocol.acpUrl()
	local v35 = v32.logger or t5

	local function authHeaders() -- line: 92
		-- upvalues: v32 (copy)
		if v32.getAuthHeaders then
			return (v32.getAuthHeaders())
		end

		return {}
	end

	local n1 = 0

	local function nextId() -- line: 97
		-- upvalues: v32 (copy), n1 (ref)
		if v32.generateRequestId then
			return v32.generateRequestId()
		end

		n1 += 1

		return n1
	end

	local t6 = {}
	local t7 = {}
	local t8 = {}

	local function requestIdKey(p4) -- line: 109
		if p4 == nil then
			return nil
		end

		return (tostring(p4))
	end
	local function unregisterHandle(p5) -- line: 113
		-- upvalues: t6 (copy), t8 (copy), t7 (copy)
		for v72, v73 in t6 do
			if v73 == p5 then
				t6[v72] = nil
				t8[v72] = nil

				break
			end
		end

		local requestId = p5.requestId
		local v75 = if requestId ~= nil then tostring(requestId) else nil

		if v75 and p5 == t7[v75] then
			t7[v75] = nil
		end
	end
	local function rpcCall(p6, s1: string, p7) -- line: 127
		-- upvalues: v35 (copy), HttpClient (copy), v33 (copy), v34 (copy), v32 (copy), rpcDecoder (copy)
		v35:debug(`[CAS] -> { s1 } id={ tostring(p6) }`)

		return HttpClient.createRequest({
			method = "POST",
			networkImpl = v33,
			url = v34,
			headers = if not v32.getAuthHeaders then {} else v32.getAuthHeaders(),
			body = {
				jsonrpc = "2.0",
				id = p6,
				method = s1,
				params = p7 or {}
			},
			analyticsKey = "cas." .. s1:gsub("/", "-"):lower(),
			decode = rpcDecoder()
		})
	end
	local function rpcCallSync(s2: string, p8) -- line: 145
		-- upvalues: rpcCall (copy), v32 (copy), n1 (ref)
		local v81 = rpcCall
		local v82

		if v32.generateRequestId then
			v82 = v32.generateRequestId()
		else
			n1 += 1
			v82 = n1
		end

		return v81(v82, s2, p8)
	end
	local function submitToolResult(p9) -- line: 149
		-- upvalues: v32 (copy), n1 (ref), AcpProtocol (copy), HttpClient (copy), v33 (copy), v34 (copy), rpcDecoder (copy)
		assert(typeof(p9.sessionId) == "string" and p9.sessionId ~= "", "sessionId is required")
		assert(typeof(p9.content) == "table" and typeof(p9.content.text) == "string", "content.text is required")

		if p9.turnId ~= nil then
			assert(typeof(p9.turnId) == "number" and p9.turnId > 0, "turnId must be a positive number")
		end

		if p9.referenceId ~= nil then
			assert(typeof(p9.referenceId) == "string" and p9.referenceId ~= "", "referenceId must be a string")
		end

		local v84

		if v32.generateRequestId then
			v84 = v32.generateRequestId()
		else
			n1 += 1
			v84 = n1
		end

		local t9 = {
			sessionId = p9.sessionId,
			tool_name = AcpProtocol.AskTool.Name,
			content = p9.content,
			isError = p9.isError ~= nil and p9.isError
		}

		if p9.turnId ~= nil then
			t9.turnId = p9.turnId
		end

		if p9.referenceId ~= nil then
			t9.referenceId = p9.referenceId
		end

		return HttpClient.createRequest({
			method = "POST",
			analyticsKey = "cas.ask-tool-result",
			networkImpl = v33,
			url = v34,
			headers = if not v32.getAuthHeaders then {} else v32.getAuthHeaders(),
			body = {
				jsonrpc = "2.0",
				id = v84,
				result = t9
			},
			decode = rpcDecoder()
		})
	end
	local function initialize(p10) -- line: 189
		-- upvalues: rpcCallSync (copy), AcpProtocol (copy)
		return rpcCallSync(AcpProtocol.Methods.Initialize, p10 or {
			protocolVersion = AcpProtocol.ProtocolVersion
		})
	end
	local function sessionNew(p11) -- line: 193
		-- upvalues: rpcCallSync (copy), AcpProtocol (copy)
		assert(p11 ~= nil, "sessionNew requires params")
		assert(typeof(p11.project) == "table", "sessionNew requires params.project")
		assert(typeof(p11.project.universeId) == "number", "sessionNew requires params.project.universeId")
		assert(typeof(p11.project.placeId) == "number", "sessionNew requires params.project.placeId")

		return rpcCallSync(AcpProtocol.Methods.SessionNew, AcpProtocol.buildSessionNewWireParams({
			cwd = p11.cwd or "/",
			mcpServers = p11.mcpServers,
			project = p11.project,
			experiment = p11.experiment
		}))
	end

	local v49, v50 = Signals.createSignal({})
	local v51, v52 = Signals.createSignal(nil)
	local v53, v54 = Signals.createSignal("pending")
	local v55, v56 = Signals.createSignal(nil)
	local u57 = nil
	local u58 = nil
	local n2 = 0

	local function refreshSessionList() -- line: 221
		-- upvalues: u57 (ref), n2 (ref), u58 (ref), v54 (copy), v56 (copy), AcpProtocol (copy), rpcCall (copy), v32 (copy), n1 (ref), onTerminal (copy), v50 (copy), v52 (copy)
		if u57 ~= nil then
			if u57.state(false).status == "pending" then
				return u57
			end

			u57 = nil
		end

		n2 += 1

		local v89 = n2

		u58 = nil
		v54("pending")
		v56(nil)

		local SessionList = AcpProtocol.Methods.SessionList
		local v91 = rpcCall
		local v92

		if v32.generateRequestId then
			v92 = v32.generateRequestId()
		else
			n1 += 1
			v92 = n1
		end

		local v93 = v91(v92, SessionList, {})

		u57 = v93
		onTerminal(v93.state, function(p12) -- line: 238
			-- upvalues: v89 (copy), n2 (ref), u57 (ref), v50 (copy), v52 (copy), v54 (copy)
			if v89 ~= n2 then
				return
			end

			u57 = nil

			local v151 = p12.sessions or {}
			local nextPageToken = p12.nextPageToken
			local v153 = if typeof(nextPageToken) ~= "string" or nextPageToken == "" then nil else nextPageToken

			v50(v151)
			v52(v153)
			v54("succeeded")
		end, function(_) -- line: 248
			-- upvalues: v89 (copy), n2 (ref), u57 (ref), v54 (copy)
			if v89 ~= n2 then
				return
			end

			u57 = nil
			v54("failed")
		end)

		return v93
	end
	local function loadMoreSessionList() -- line: 258
		-- upvalues: v51 (copy), u57 (ref), u58 (ref), v53 (copy), n2 (ref), v56 (copy), AcpProtocol (copy), rpcCall (copy), v32 (copy), n1 (ref), onTerminal (copy), appendSessionListEntries (copy), v49 (copy), v50 (copy), v52 (copy)
		local v94 = v51(false)

		if v94 == nil then
			return nil
		end

		if u57 ~= nil then
			return nil
		end

		if u58 ~= nil then
			return nil
		end

		if v53(false) ~= "succeeded" then
			return nil
		end

		local v95 = n2

		v56("pending")

		local t10 = {
			pageToken = v94
		}
		local SessionList = AcpProtocol.Methods.SessionList
		local v98 = t10 or {}
		local v99 = rpcCall
		local v100

		if v32.generateRequestId then
			v100 = v32.generateRequestId()
		else
			n1 += 1
			v100 = n1
		end

		local v101 = v99(v100, SessionList, v98)

		u58 = v101
		onTerminal(v101.state, function(p14) -- line: 280
			-- upvalues: v95 (copy), n2 (ref), u58 (ref), appendSessionListEntries (copy), v49 (copy), v50 (copy), v52 (copy), v56 (copy)
			if v95 ~= n2 then
				return
			end

			u58 = nil

			local v156 = p14.sessions or {}
			local nextPageToken = p14.nextPageToken
			local v158 = if typeof(nextPageToken) ~= "string" or nextPageToken == "" then nil else nextPageToken
			local v159 = appendSessionListEntries(v49(false), v156)

			v50(v159)
			v52(v158)
			v56("succeeded")
		end, function(_) -- line: 291
			-- upvalues: v95 (copy), n2 (ref), u58 (ref), v56 (copy)
			if v95 ~= n2 then
				return
			end

			u58 = nil
			v56("failed")
		end)

		return v101
	end

	local t11 = {
		getSessions = v49,
		getNextPageToken = v51,
		getStatus = v53,
		getLoadMoreStatus = v55,
		refresh = refreshSessionList,
		loadMore = loadMoreSessionList
	}

	local function sessionLoad(s3: string, t12: {[any]: any}?) -- line: 318
		-- upvalues: rpcCallSync (copy), AcpProtocol (copy)
		assert(typeof(s3) == "string" and s3 ~= "", "sessionId is required")

		return rpcCallSync(AcpProtocol.Methods.SessionLoad, {
			sessionId = s3,
			cwd = t12 and t12.cwd or "/",
			mcpServers = t12 and t12.mcpServers,
			historyPageToken = t12 and t12.historyPageToken
		})
	end
	local function postSessionCancel(s4: string) -- line: 336
		-- upvalues: rpcCallSync (copy), AcpProtocol (copy)
		return rpcCallSync(AcpProtocol.Methods.SessionCancel, {
			sessionId = s4
		})
	end
	local function registerTurnHandle(s5: string, p16, p17, t13: {[any]: any}?) -- line: 381
		-- upvalues: createTurnHandle (copy), AcpProtocol (copy), rpcCall (copy), v32 (copy), n1 (ref), onTerminal (copy), t6 (copy), t8 (copy), t7 (copy)
		local v126, v127 = createTurnHandle(s5, p16, function() -- line: 387
			-- upvalues: s5 (copy), AcpProtocol (copy), rpcCall (copy), v32 (copy), n1 (ref), onTerminal (copy), t6 (copy), t8 (copy), t7 (copy)
			local v171 = s5

			assert(typeof(v171) == "string" and v171 ~= "", "sessionId is required")

			local SessionCancel = AcpProtocol.Methods.SessionCancel
			local t14 = {
				sessionId = v171
			}
			local v174 = rpcCall
			local v175

			if v32.generateRequestId then
				v175 = v32.generateRequestId()
			else
				n1 += 1
				v175 = n1
			end

			local v176 = v174(v175, SessionCancel, t14)

			onTerminal(v176.state, function() -- line: 343
				-- upvalues: t6 (copy), v171 (copy), t8 (copy), t7 (copy)
				local v194 = t6[v171]

				if v194 then
					v194.markCancelled()

					for v195, v196 in t6 do
						if v196 == v194 then
							t6[v195] = nil
							t8[v195] = nil

							break
						end
					end

					local requestId = v194.requestId
					local v198 = if requestId ~= nil then tostring(requestId) else nil

					if v198 and v194 == t7[v198] then
						t7[v198] = nil
					end
				end
			end)
		end, p17, t13)

		t6[s5] = v127
		t8[s5] = v126

		if p16 ~= nil then
			t7[tostring(p16)] = v127
		end

		return v126
	end
	local function sessionPrompt(p18) -- line: 398
		-- upvalues: v32 (copy), n1 (ref), createTurnHandle (copy), AcpProtocol (copy), rpcCall (copy), onTerminal (copy), t6 (copy), t8 (copy), t7 (copy)
		assert(p18 and (typeof(p18.sessionId) == "string" and p18.sessionId ~= ""), "sessionId is required")
		assert(p18.prompt, "prompt is required")

		local sessionId = p18.sessionId
		local v130

		if v32.generateRequestId then
			v130 = v32.generateRequestId()
		else
			n1 += 1
			v130 = n1
		end

		local v131, v132 = createTurnHandle(sessionId, v130, function() -- line: 387
			-- upvalues: sessionId (copy), AcpProtocol (copy), rpcCall (copy), v32 (copy), n1 (ref), onTerminal (copy), t6 (copy), t8 (copy), t7 (copy)
			local v177 = sessionId

			assert(typeof(v177) == "string" and v177 ~= "", "sessionId is required")

			local SessionCancel = AcpProtocol.Methods.SessionCancel
			local t15 = {
				sessionId = v177
			}
			local v180 = rpcCall
			local v181

			if v32.generateRequestId then
				v181 = v32.generateRequestId()
			else
				n1 += 1
				v181 = n1
			end

			local v182 = v180(v181, SessionCancel, t15)

			onTerminal(v182.state, function() -- line: 343
				-- upvalues: t6 (copy), v177 (copy), t8 (copy), t7 (copy)
				local v199 = t6[v177]

				if v199 then
					v199.markCancelled()

					for v200, v201 in t6 do
						if v201 == v199 then
							t6[v200] = nil
							t8[v200] = nil

							break
						end
					end

					local requestId = v199.requestId
					local v203 = if requestId ~= nil then tostring(requestId) else nil

					if v203 and v199 == t7[v203] then
						t7[v203] = nil
					end
				end
			end)
		end, nil, nil)

		t6[sessionId] = v132
		t8[sessionId] = v131

		if v130 ~= nil then
			t7[tostring(v130)] = v132
		end

		local v133 = t6[sessionId]
		local t16 = {
			sessionId = sessionId
		}
		local prompt = p18.prompt

		t16.prompt = if typeof(prompt) ~= "string" then prompt else {{
			type = "text",
			text = prompt
		}}

		if p18._meta then
			t16._meta = p18._meta
		end

		local v136 = rpcCall(v130, AcpProtocol.Methods.SessionPrompt, t16)

		onTerminal(v136.state, nil, function(p19, p20) -- line: 417
			-- upvalues: v133 (copy), t6 (copy), t8 (copy), t7 (copy)
			task.defer(function() -- line: 418
				-- upvalues: v133 (copy), p19 (copy), p20 (copy), t6 (copy), t8 (copy), t7 (copy)
				if v133.isDone() then
					return
				end

				v133.fail(p19, p20)

				local v204 = v133

				for v205, v206 in t6 do
					if v206 == v204 then
						t6[v205] = nil
						t8[v205] = nil

						break
					end
				end

				local requestId = v204.requestId
				local v208 = if requestId ~= nil then tostring(requestId) else nil

				if v208 and v204 == t7[v208] then
					t7[v208] = nil
				end
			end)
		end)

		return v131
	end
	local function getActiveTurnHandle(s6: string) -- line: 446
		-- upvalues: t8 (copy)
		return t8[s6]
	end
	local function ingestSessionHistory(s7: string, t17: {[any]: any}, n3: number?) -- line: 450
		-- upvalues: historyIngest (copy), t6 (copy), unregisterHandle (copy)
		return historyIngest.ingestSessionHistory({
			getActiveTurnInternals = function(s8: string) -- line: 456
				-- upvalues: t6 (copy)
				return t6[s8]
			end,
			onTurnDone = unregisterHandle
		}, s7, t17, n3)
	end

	local v69 = sessionRegistry.createSessionRegistry({
		initialize = initialize,
		sessionNew = sessionNew,
		sessionLoad = sessionLoad,
		sessionPrompt = sessionPrompt,
		ingestSessionHistory = ingestSessionHistory,
		submitToolResult = submitToolResult,
		getActiveTurnHandle = getActiveTurnHandle,
		onCasSessionIdChanged = function(_: string?) -- line: 471
		end,
		rpcTimeoutSeconds = constants.getRpcTimeoutSeconds()
	})

	return {
		initialize = initialize,
		sessionNew = sessionNew,
		sessionList = function(p21) -- line: 209
			-- upvalues: rpcCallSync (copy), AcpProtocol (copy)
			return rpcCallSync(AcpProtocol.Methods.SessionList, p21 or {})
		end,
		getSessionListStore = function() -- line: 494
			-- upvalues: t11 (copy)
			return t11
		end,
		sessionFindByUniverse = function(p22) -- line: 310
			-- upvalues: rpcCallSync (copy), AcpProtocol (copy)
			assert(typeof(p22) == "table", "sessionFindByUniverse requires params")
			assert(typeof(p22.universeId) == "number" and p22.universeId ~= 0, "universeId is required")

			return rpcCallSync(AcpProtocol.Methods.SessionFindByUniverse, p22)
		end,
		sessionLoad = sessionLoad,
		sessionReadTasks = function(s10: string) -- line: 331
			-- upvalues: rpcCallSync (copy), AcpProtocol (copy)
			assert(typeof(s10) == "string" and s10 ~= "", "sessionId is required")

			return rpcCallSync(AcpProtocol.Methods.SessionReadTasks, {
				sessionId = s10
			})
		end,
		sessionPrompt = sessionPrompt,
		submitToolResult = submitToolResult,
		sessionCancel = function(s11: string) -- line: 340
			-- upvalues: AcpProtocol (copy), rpcCall (copy), v32 (copy), n1 (ref), onTerminal (copy), t6 (copy), t8 (copy), t7 (copy)
			assert(typeof(s11) == "string" and s11 ~= "", "sessionId is required")

			local SessionCancel = AcpProtocol.Methods.SessionCancel
			local t18 = {
				sessionId = s11
			}
			local v110 = rpcCall
			local v111

			if v32.generateRequestId then
				v111 = v32.generateRequestId()
			else
				n1 += 1
				v111 = n1
			end

			local v112 = v110(v111, SessionCancel, t18)

			onTerminal(v112.state, function() -- line: 343
				-- upvalues: t6 (copy), s11 (copy), t8 (copy), t7 (copy)
				local v161 = t6[s11]

				if v161 then
					v161.markCancelled()

					for v162, v163 in t6 do
						if v163 == v161 then
							t6[v162] = nil
							t8[v162] = nil

							break
						end
					end

					local requestId = v161.requestId
					local v165 = if requestId ~= nil then tostring(requestId) else nil

					if v165 and v161 == t7[v165] then
						t7[v165] = nil
					end
				end
			end)

			return v112
		end,
		sessionDelete = function(s12: string) -- line: 353
			-- upvalues: AcpProtocol (copy), rpcCall (copy), v32 (copy), n1 (ref), onTerminal (copy), t6 (copy), t8 (copy), t7 (copy)
			assert(typeof(s12) == "string" and s12 ~= "", "sessionId is required")

			local SessionDelete = AcpProtocol.Methods.SessionDelete
			local t19 = {
				sessionId = s12
			}
			local v116 = rpcCall
			local v117

			if v32.generateRequestId then
				v117 = v32.generateRequestId()
			else
				n1 += 1
				v117 = n1
			end

			local v118 = v116(v117, SessionDelete, t19)

			onTerminal(v118.state, function() -- line: 356
				-- upvalues: t6 (copy), s12 (copy), AcpProtocol (copy), t8 (copy), t7 (copy)
				local v166 = t6[s12]

				if v166 then
					v166.fail("Session deleted before prompt response", AcpProtocol.ErrorCodes.Gone)

					for v167, v168 in t6 do
						if v168 == v166 then
							t6[v167] = nil
							t8[v167] = nil

							break
						end
					end

					local requestId = v166.requestId
					local v170 = if requestId ~= nil then tostring(requestId) else nil

					if v170 and v166 == t7[v170] then
						t7[v170] = nil
					end
				end
			end)

			return v118
		end,
		sessionUpdateInfo = function(s13: string, s14: string?) -- line: 366
			-- upvalues: rpcCallSync (copy), AcpProtocol (copy)
			assert(typeof(s13) == "string" and s13 ~= "", "sessionId is required")

			return rpcCallSync(AcpProtocol.Methods.SessionUpdateInfo, {
				sessionId = s13,
				title = s14
			})
		end,
		sessionSaveAndPublish = function(p23) -- line: 371
			-- upvalues: rpcCallSync (copy), AcpProtocol (copy)
			assert(typeof(p23) == "table", "sessionSaveAndPublish requires params")
			assert(typeof(p23.placeId) == "number" and p23.placeId > 0, "placeId must be a positive number")
			assert(p23.title == nil or typeof(p23.title) == "string", "title must be a string")
			assert(p23.description == nil or typeof(p23.description) == "string", "description must be a string")

			return rpcCallSync(AcpProtocol.Methods.SessionSaveAndPublish, p23)
		end,
		ingestSessionHistory = ingestSessionHistory,
		ingestFrame = function(p24, p25) -- line: 475
			-- upvalues: ingestFrameHandler (copy), v35 (copy), v69 (copy), t6 (copy), t7 (copy), unregisterHandle (copy)
			ingestFrameHandler.ingestFrame({
				logger = v35,
				getSessionByCasSessionId = v69.getSessionByCasSessionId,
				getSessionForProject = v69.getSessionForProject,
				getActiveTurnBySession = function(s15: string) -- line: 480
					-- upvalues: t6 (copy)
					return t6[s15]
				end,
				getActiveTurnByRequestId = function(s16: string) -- line: 483
					-- upvalues: t7 (copy)
					return t7[s16]
				end,
				onTurnDone = unregisterHandle
			}, p24, p25)
		end,
		resumeTurnFromHistory = function(s17: string, p26, t20: {[any]: any}?) -- line: 430
			-- upvalues: t8 (copy), createTurnHandle (copy), AcpProtocol (copy), rpcCall (copy), v32 (copy), n1 (ref), onTerminal (copy), t6 (copy), t7 (copy)
			assert(typeof(s17) == "string" and s17 ~= "", "sessionId is required")

			if p26.isDone then
				return nil
			end

			local v140 = t8[s17]

			if v140 ~= nil then
				return v140
			end

			local v141, v142 = createTurnHandle(s17, nil, function() -- line: 387
				-- upvalues: s17 (copy), AcpProtocol (copy), rpcCall (copy), v32 (copy), n1 (ref), onTerminal (copy), t6 (copy), t8 (copy), t7 (copy)
				local v185 = s17

				assert(typeof(v185) == "string" and v185 ~= "", "sessionId is required")

				local SessionCancel = AcpProtocol.Methods.SessionCancel
				local t21 = {
					sessionId = v185
				}
				local v188 = rpcCall
				local v189

				if v32.generateRequestId then
					v189 = v32.generateRequestId()
				else
					n1 += 1
					v189 = n1
				end

				local v190 = v188(v189, SessionCancel, t21)

				onTerminal(v190.state, function() -- line: 343
					-- upvalues: t6 (copy), v185 (copy), t8 (copy), t7 (copy)
					local v209 = t6[v185]

					if v209 then
						v209.markCancelled()

						for v210, v211 in t6 do
							if v211 == v209 then
								t6[v210] = nil
								t8[v210] = nil

								break
							end
						end

						local requestId = v209.requestId
						local v213 = if requestId ~= nil then tostring(requestId) else nil

						if v213 and v209 == t7[v213] then
							t7[v213] = nil
						end
					end
				end)
			end, p26, t20)

			t6[s17] = v142
			t8[s17] = v141

			return v141
		end,
		getActiveTurnHandle = getActiveTurnHandle,
		getSessionForProject = v69.getSessionForProject
	}
end

return createCreatorAgentChatStore
