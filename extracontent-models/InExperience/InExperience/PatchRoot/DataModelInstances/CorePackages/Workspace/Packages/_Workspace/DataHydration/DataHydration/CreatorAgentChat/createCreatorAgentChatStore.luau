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

local function normalizeNextPageToken(p1) -- line: 40
	if typeof(p1) == "string" and p1 ~= "" then
		return p1
	end

	return nil
end
local function appendSessionListEntries(t1: {[any]: any}, t2: {[any]: any}) -- line: 47
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
local function normalizePrompt(p2) -- line: 72
	if typeof(p2) == "string" then
		return {{
			type = "text",
			text = p2
		}}
	end

	return p2
end

local t5 = {
	debug = function() -- line: 80
	end,
	info = function() -- line: 81
	end,
	warning = function() -- line: 82
	end,
	error = function() -- line: 83
	end
}

local function createCreatorAgentChatStore(p3) -- line: 86
	-- upvalues: withCsrfRetry (copy), HttpClient (copy), AcpProtocol (copy), t5 (copy), rpcDecoder (copy), Signals (copy), onTerminal (copy), appendSessionListEntries (copy), createTurnHandle (copy), historyIngest (copy), sessionRegistry (copy), constants (copy), ingestFrameHandler (copy)
	local v32 = p3 or {}
	local v33 = v32.network or withCsrfRetry(HttpClient.createRequestInternalNetwork())
	local v34 = v32.baseUrl or AcpProtocol.acpUrl()
	local v35 = v32.logger or t5

	local function authHeaders() -- line: 93
		-- upvalues: v32 (copy)
		if v32.getAuthHeaders then
			return (v32.getAuthHeaders())
		end

		return {}
	end

	local n1 = 0

	local function nextId() -- line: 98
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

	local function requestIdKey(p4) -- line: 110
		if p4 == nil then
			return nil
		end

		return (tostring(p4))
	end
	local function unregisterHandle(p5) -- line: 114
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
	local function rpcCall(p6, s1: string, p7) -- line: 128
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
	local function rpcCallSync(s2: string, p8) -- line: 146
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
	local function submitToolResult(p9) -- line: 150
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
	local function initialize(p10) -- line: 190
		-- upvalues: rpcCallSync (copy), AcpProtocol (copy)
		return rpcCallSync(AcpProtocol.Methods.Initialize, p10 or {
			protocolVersion = AcpProtocol.ProtocolVersion
		})
	end
	local function sessionNew(p11) -- line: 194
		-- upvalues: rpcCallSync (copy), AcpProtocol (copy)
		assert(p11 ~= nil, "sessionNew requires params")
		assert(typeof(p11.project) == "table", "sessionNew requires params.project")
		assert(typeof(p11.project.universeId) == "number", "sessionNew requires params.project.universeId")
		assert(typeof(p11.project.placeId) == "number", "sessionNew requires params.project.placeId")

		return rpcCallSync(AcpProtocol.Methods.SessionNew, AcpProtocol.buildSessionNewWireParams({
			cwd = p11.cwd or "/",
			mcpServers = p11.mcpServers,
			project = p11.project
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

			local v150 = p12.sessions or {}
			local nextPageToken = p12.nextPageToken
			local v152 = if typeof(nextPageToken) ~= "string" or nextPageToken == "" then nil else nextPageToken

			v50(v150)
			v52(v152)
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

			local v155 = p14.sessions or {}
			local nextPageToken = p14.nextPageToken
			local v157 = if typeof(nextPageToken) ~= "string" or nextPageToken == "" then nil else nextPageToken
			local v158 = appendSessionListEntries(v49(false), v155)

			v50(v158)
			v52(v157)
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
	local function registerTurnHandle(s5: string, p16, p17, t13: {[any]: any}?) -- line: 371
		-- upvalues: createTurnHandle (copy), AcpProtocol (copy), rpcCall (copy), v32 (copy), n1 (ref), onTerminal (copy), t6 (copy), t8 (copy), t7 (copy)
		local v125, v126 = createTurnHandle(s5, p16, function() -- line: 377
			-- upvalues: s5 (copy), AcpProtocol (copy), rpcCall (copy), v32 (copy), n1 (ref), onTerminal (copy), t6 (copy), t8 (copy), t7 (copy)
			local v170 = s5

			assert(typeof(v170) == "string" and v170 ~= "", "sessionId is required")

			local SessionCancel = AcpProtocol.Methods.SessionCancel
			local t14 = {
				sessionId = v170
			}
			local v173 = rpcCall
			local v174

			if v32.generateRequestId then
				v174 = v32.generateRequestId()
			else
				n1 += 1
				v174 = n1
			end

			local v175 = v173(v174, SessionCancel, t14)

			onTerminal(v175.state, function() -- line: 343
				-- upvalues: t6 (copy), v170 (copy), t8 (copy), t7 (copy)
				local v193 = t6[v170]

				if v193 then
					v193.markCancelled()

					for v194, v195 in t6 do
						if v195 == v193 then
							t6[v194] = nil
							t8[v194] = nil

							break
						end
					end

					local requestId = v193.requestId
					local v197 = if requestId ~= nil then tostring(requestId) else nil

					if v197 and v193 == t7[v197] then
						t7[v197] = nil
					end
				end
			end)
		end, p17, t13)

		t6[s5] = v126
		t8[s5] = v125

		if p16 ~= nil then
			t7[tostring(p16)] = v126
		end

		return v125
	end
	local function sessionPrompt(p18) -- line: 388
		-- upvalues: v32 (copy), n1 (ref), createTurnHandle (copy), AcpProtocol (copy), rpcCall (copy), onTerminal (copy), t6 (copy), t8 (copy), t7 (copy)
		assert(p18 and (typeof(p18.sessionId) == "string" and p18.sessionId ~= ""), "sessionId is required")
		assert(p18.prompt, "prompt is required")

		local sessionId = p18.sessionId
		local v129

		if v32.generateRequestId then
			v129 = v32.generateRequestId()
		else
			n1 += 1
			v129 = n1
		end

		local v130, v131 = createTurnHandle(sessionId, v129, function() -- line: 377
			-- upvalues: sessionId (copy), AcpProtocol (copy), rpcCall (copy), v32 (copy), n1 (ref), onTerminal (copy), t6 (copy), t8 (copy), t7 (copy)
			local v176 = sessionId

			assert(typeof(v176) == "string" and v176 ~= "", "sessionId is required")

			local SessionCancel = AcpProtocol.Methods.SessionCancel
			local t15 = {
				sessionId = v176
			}
			local v179 = rpcCall
			local v180

			if v32.generateRequestId then
				v180 = v32.generateRequestId()
			else
				n1 += 1
				v180 = n1
			end

			local v181 = v179(v180, SessionCancel, t15)

			onTerminal(v181.state, function() -- line: 343
				-- upvalues: t6 (copy), v176 (copy), t8 (copy), t7 (copy)
				local v198 = t6[v176]

				if v198 then
					v198.markCancelled()

					for v199, v200 in t6 do
						if v200 == v198 then
							t6[v199] = nil
							t8[v199] = nil

							break
						end
					end

					local requestId = v198.requestId
					local v202 = if requestId ~= nil then tostring(requestId) else nil

					if v202 and v198 == t7[v202] then
						t7[v202] = nil
					end
				end
			end)
		end, nil, nil)

		t6[sessionId] = v131
		t8[sessionId] = v130

		if v129 ~= nil then
			t7[tostring(v129)] = v131
		end

		local v132 = t6[sessionId]
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

		local v135 = rpcCall(v129, AcpProtocol.Methods.SessionPrompt, t16)

		onTerminal(v135.state, nil, function(p19, p20) -- line: 407
			-- upvalues: v132 (copy), t6 (copy), t8 (copy), t7 (copy)
			task.defer(function() -- line: 408
				-- upvalues: v132 (copy), p19 (copy), p20 (copy), t6 (copy), t8 (copy), t7 (copy)
				if v132.isDone() then
					return
				end

				v132.fail(("CAS session/prompt failed: %s"):format(p19), p20)

				local v203 = v132

				for v204, v205 in t6 do
					if v205 == v203 then
						t6[v204] = nil
						t8[v204] = nil

						break
					end
				end

				local requestId = v203.requestId
				local v207 = if requestId ~= nil then tostring(requestId) else nil

				if v207 and v203 == t7[v207] then
					t7[v207] = nil
				end
			end)
		end)

		return v130
	end
	local function getActiveTurnHandle(s6: string) -- line: 436
		-- upvalues: t8 (copy)
		return t8[s6]
	end
	local function ingestSessionHistory(s7: string, t17: {[any]: any}, n3: number?) -- line: 440
		-- upvalues: historyIngest (copy), t6 (copy), unregisterHandle (copy)
		return historyIngest.ingestSessionHistory({
			getActiveTurnInternals = function(s8: string) -- line: 446
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
		onCasSessionIdChanged = function(_: string?) -- line: 461
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
		getSessionListStore = function() -- line: 484
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
				local v160 = t6[s11]

				if v160 then
					v160.markCancelled()

					for v161, v162 in t6 do
						if v162 == v160 then
							t6[v161] = nil
							t8[v161] = nil

							break
						end
					end

					local requestId = v160.requestId
					local v164 = if requestId ~= nil then tostring(requestId) else nil

					if v164 and v160 == t7[v164] then
						t7[v164] = nil
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
				local v165 = t6[s12]

				if v165 then
					v165.fail("Session deleted before prompt response", AcpProtocol.ErrorCodes.Gone)

					for v166, v167 in t6 do
						if v167 == v165 then
							t6[v166] = nil
							t8[v166] = nil

							break
						end
					end

					local requestId = v165.requestId
					local v169 = if requestId ~= nil then tostring(requestId) else nil

					if v169 and v165 == t7[v169] then
						t7[v169] = nil
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
		ingestSessionHistory = ingestSessionHistory,
		ingestFrame = function(p23, p24) -- line: 465
			-- upvalues: ingestFrameHandler (copy), v35 (copy), v69 (copy), t6 (copy), t7 (copy), unregisterHandle (copy)
			ingestFrameHandler.ingestFrame({
				logger = v35,
				getSessionByCasSessionId = v69.getSessionByCasSessionId,
				getSessionForProject = v69.getSessionForProject,
				getActiveTurnBySession = function(s15: string) -- line: 470
					-- upvalues: t6 (copy)
					return t6[s15]
				end,
				getActiveTurnByRequestId = function(s16: string) -- line: 473
					-- upvalues: t7 (copy)
					return t7[s16]
				end,
				onTurnDone = unregisterHandle
			}, p23, p24)
		end,
		resumeTurnFromHistory = function(s17: string, p25, t20: {[any]: any}?) -- line: 420
			-- upvalues: t8 (copy), createTurnHandle (copy), AcpProtocol (copy), rpcCall (copy), v32 (copy), n1 (ref), onTerminal (copy), t6 (copy), t7 (copy)
			assert(typeof(s17) == "string" and s17 ~= "", "sessionId is required")

			if p25.isDone then
				return nil
			end

			local v139 = t8[s17]

			if v139 ~= nil then
				return v139
			end

			local v140, v141 = createTurnHandle(s17, nil, function() -- line: 377
				-- upvalues: s17 (copy), AcpProtocol (copy), rpcCall (copy), v32 (copy), n1 (ref), onTerminal (copy), t6 (copy), t8 (copy), t7 (copy)
				local v184 = s17

				assert(typeof(v184) == "string" and v184 ~= "", "sessionId is required")

				local SessionCancel = AcpProtocol.Methods.SessionCancel
				local t21 = {
					sessionId = v184
				}
				local v187 = rpcCall
				local v188

				if v32.generateRequestId then
					v188 = v32.generateRequestId()
				else
					n1 += 1
					v188 = n1
				end

				local v189 = v187(v188, SessionCancel, t21)

				onTerminal(v189.state, function() -- line: 343
					-- upvalues: t6 (copy), v184 (copy), t8 (copy), t7 (copy)
					local v208 = t6[v184]

					if v208 then
						v208.markCancelled()

						for v209, v210 in t6 do
							if v210 == v208 then
								t6[v209] = nil
								t8[v209] = nil

								break
							end
						end

						local requestId = v208.requestId
						local v212 = if requestId ~= nil then tostring(requestId) else nil

						if v212 and v208 == t7[v212] then
							t7[v212] = nil
						end
					end
				end)
			end, p25, t20)

			t6[s17] = v141
			t8[s17] = v140

			return v140
		end,
		getActiveTurnHandle = getActiveTurnHandle,
		getSessionForProject = v69.getSessionForProject
	}
end

return createCreatorAgentChatStore
