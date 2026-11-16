local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

local HttpClient = require(parent.HttpClient)
local Signals = require(parent.Signals)
local SharedFlags = require(parent.SharedFlags)
local SignalsUtils = require(parent.SignalsUtils)
local FFlagBuildAgentAdCampaignCard = require(script.Parent.FFlagBuildAgentAdCampaignCard)

local SharedFlags2 = require(parent.SharedFlags)
local FFlagBuildAgentAdCampaignToolCallStatusFallback = SharedFlags2.FFlagBuildAgentAdCampaignToolCallStatusFallback
local decodeAdCampaignToolCallStatusResult

if FFlagBuildAgentAdCampaignToolCallStatusFallback then
	decodeAdCampaignToolCallStatusResult = require(script.Parent.decodeAdCampaignToolCallStatusResult)
else
	decodeAdCampaignToolCallStatusResult = nil
end

local AcpProtocol = require(script.Parent.Acp.AcpProtocol)
local classifyRequestFailure = require(script.Parent.classifyRequestFailure)
local historyIngest = require(script.Parent.CasStore.historyIngest)
local ingestFrameHandler = require(script.Parent.CasStore.ingestFrameHandler)
local sessionRegistry = require(script.Parent.CasStore.sessionRegistry)
local constants = require(script.Parent.ChatSession.constants)
local createTurnHandle = require(script.Parent.createTurnHandle)
local experimentOverride = require(script.Parent.experimentOverride)
local onTerminal = require(script.Parent.onTerminal)
local rpcDecoder = require(script.Parent.rpcDecoder)
local getFundingError = require(script.Parent.getFundingError)
require(script.Parent.types)
local withCsrfRetry = require(DataHydration.withCsrfRetry)

local FFlagBuildExperienceModelPickerData = SharedFlags.FFlagBuildExperienceModelPickerData
local FFlagBuildExperiencePromptFailureTelemetry = SharedFlags.FFlagBuildExperiencePromptFailureTelemetry
local FFlagBuildExperienceLibrary = SharedFlags.FFlagBuildExperienceLibrary

local function validateModelTier(model) -- 2 equivalent calls inferred from this helper
	assert(model == nil or model == "default" or model == "advanced", "invalid model tier")
end

local function normalizeNextPageToken(nextPageToken) -- 2 equivalent calls inferred from this helper
	if typeof(nextPageToken) == "string" and nextPageToken ~= "" then
		return nextPageToken
	end

	return nil
end

local function appendSessionListEntries(items, sessions)
	local result = {}
	local sessionIdSet = {}

	for _, item in items do
		local sessionId = item.sessionId

		if typeof(sessionId) == "string" and sessionId ~= "" then
			sessionIdSet[sessionId] = true
		end

		table.insert(result, item)
	end

	for _, item in sessions do
		local sessionId = item.sessionId

		if typeof(sessionId) ~= "string" or sessionId == "" or sessionIdSet[sessionId] then
			continue
		end

		sessionIdSet[sessionId] = true
		table.insert(result, item)
	end

	return result
end

local function normalizePrompt(prompt) -- 1 equivalent call inferred from this helper
	if typeof(prompt) == "string" then
		return {
			{ type = "text", text = prompt }
		}
	end

	return prompt
end

local v = {
	debug = function() end,
	info = function() end,
	warning = function() end,
	error = function() end
}

local function createCreatorAgentChatStore(options)
	local v2 = options or {}
	local network = v2.network or withCsrfRetry(HttpClient.createRequestInternalNetwork())
	local baseUrl = v2.baseUrl or AcpProtocol.acpUrl()
	local logger = v2.logger or v

	local function authHeaders() -- 2 equivalent calls inferred from this helper
		if v2.getAuthHeaders then
			return (v2.getAuthHeaders())
		end

		return {}
	end

	local count = 0
	local function nextId() -- 3 equivalent calls inferred from this helper
		if v2.generateRequestId then
			return v2.generateRequestId()
		end

		count += 1
		return count
	end

	local function createActiveTurns()
		return {
			activeBySession = {},
			activeByRequestId = {},
			publicBySession = {},
			pendingCancels = {}
		}
	end

	local activeTurns = createActiveTurns()

	local fn = not FFlagBuildExperienceModelPickerData and function(_)
		return activeTurns
	end or SignalsUtils.createSessionScopedSignal(createActiveTurns)

	local function requestIdKey(requestId) -- 1 equivalent call inferred from this helper
		if requestId == nil then
			return nil
		end

		return (tostring(requestId))
	end

	local function unregisterHandle(p)
		for k, v3 in fn(false).activeBySession do
			if v3 == p then
				local fn_2 = fn(false)
				fn_2.activeBySession[k] = nil
				local fn_3 = fn(false)
				fn_3.publicBySession[k] = nil
				break
			end
		end

		local idKey = requestIdKey(p.requestId) -- inferred equivalent call

		if idKey and fn(false).activeByRequestId[idKey] == p then
			local fn_2 = fn(false)
			fn_2.activeByRequestId[idKey] = nil
		end
	end

	local function rpcCall(id, method: string, options2, callback)
		logger:debug(`[CAS] -> {method} id={tostring(id)}`)
		return HttpClient.createRequest({
			networkImpl = network,
			method = "POST",
			url = baseUrl,
			headers = authHeaders(), -- inferred equivalent call
			body = {
				jsonrpc = "2.0",
				id = id,
				method = method,
				params = options2 or {}
			},
			analyticsKey = "cas." .. method:gsub("/", "-"):lower(),
			decode = rpcDecoder(callback)
		})
	end

	local function rpcCallSync(method: string, p, callback) -- 4 equivalent calls inferred from this helper
		return rpcCall(nextId(), method, p, callback) -- inferred equivalent call
	end

	local function submitToolResult(data)
		local v3 = typeof(data.sessionId) == "string" and data.sessionId ~= ""
		assert(v3, "sessionId is required")

		local v4 = typeof(data.content) == "table" and typeof(data.content.text) == "string"
		assert(v4, "content.text is required")

		if data.turnId ~= nil then
			local v5 = typeof(data.turnId) == "number" and data.turnId > 0
			assert(v5, "turnId must be a positive number")
		end

		if data.referenceId ~= nil then
			local v5 = typeof(data.referenceId) == "string" and data.referenceId ~= ""
			assert(v5, "referenceId must be a string")
		end

		local id = nextId() -- inferred equivalent call
		local v5 = {
			sessionId = data.sessionId,
			tool_name = AcpProtocol.AskTool.Name,
			content = data.content,
			isError = data.isError ~= nil and data.isError
		}

		if data.turnId ~= nil then
			v5.turnId = data.turnId
		end

		if data.referenceId ~= nil then
			v5.referenceId = data.referenceId
		end

		return (HttpClient.createRequest({
			networkImpl = network,
			method = "POST",
			url = baseUrl,
			headers = authHeaders(), -- inferred equivalent call
			body = { jsonrpc = "2.0", id = id, result = v5 },
			analyticsKey = "cas.ask-tool-result",
			decode = rpcDecoder()
		}))
	end

	local function initialize(p)
		return rpcCallSync(AcpProtocol.Methods.Initialize, p or {
			protocolVersion = AcpProtocol.ProtocolVersion
		})
	end

	local function sessionNew(data)
		assert(data ~= nil, "sessionNew requires params")
		assert(typeof(data.project) == "table", "sessionNew requires params.project")
		assert(typeof(data.project.universeId) == "number", "sessionNew requires params.project.universeId")
		assert(typeof(data.project.placeId) == "number", "sessionNew requires params.project.placeId")

		if FFlagBuildExperienceModelPickerData then
			validateModelTier(data.model) -- inferred equivalent call
		end

		local sessionNew2 = AcpProtocol.Methods.SessionNew
		local buildSessionNewWireParams = AcpProtocol.buildSessionNewWireParams
		local v3 = {
			cwd = data.cwd or "/",
			mcpServers = data.mcpServers,
			project = data.project,
			model = 0,
			experiment = 0,
			application = 0
		}
		local model

		if FFlagBuildExperienceModelPickerData then
			model = data.model
		end

		v3.model = model
		v3.experiment = data.experiment
		v3.application = data.application
		return rpcCallSync(sessionNew2, buildSessionNewWireParams(v3))
	end

	local signal, v3 = Signals.createSignal({})
	local signal2, v4 = Signals.createSignal(nil)
	local signal3, v5 = Signals.createSignal("pending")
	local signal4, v6 = Signals.createSignal(nil)
	local v7 = nil
	local v8 = nil
	local count2 = 0

	local function refreshSessionList()
		if v7 ~= nil then
			if v7.state(false).status == "pending" then
				return v7
			end

			v7 = nil
		end

		count2 += 1
		local v9 = count2
		v8 = nil
		v5("pending")
		v6(nil)
		local v10 = rpcCallSync(AcpProtocol.Methods.SessionList, {}) -- inferred equivalent call

		v7 = v10
		onTerminal(v10.state, function(p)
			if v9 ~= count2 then
				return
			end

			v7 = nil
			local sessions = p.sessions or {}
			local nextPageToken = normalizeNextPageToken(p.nextPageToken) -- inferred equivalent call
			v3(sessions)
			v4(nextPageToken)
			v5("succeeded")
		end, function(_)
			if v9 ~= count2 then
				return
			end

			v7 = nil
			v5("failed")
		end)
		return v10
	end

	local function loadMoreSessionList()
		local pageToken = signal2(false)

		if not (pageToken ~= nil and v7 == nil and v8 == nil and signal3(false) == "succeeded") then
			return nil
		end

		local v9 = count2

		v6("pending")
		local v10 = rpcCallSync(AcpProtocol.Methods.SessionList, { pageToken = pageToken } or {}) -- inferred equivalent call

		v8 = v10
		onTerminal(v10.state, function(p)
			if v9 ~= count2 then
				return
			end

			v8 = nil
			local sessions = p.sessions or {}
			local nextPageToken = normalizeNextPageToken(p.nextPageToken) -- inferred equivalent call
			v3(appendSessionListEntries(signal(false), sessions))
			v4(nextPageToken)
			v6("succeeded")
		end, function(_)
			if v9 ~= count2 then
				return
			end

			v8 = nil
			v6("failed")
		end)
		return v10
	end

	local sessionListStore = {
		getSessions = signal,
		getNextPageToken = signal2,
		getStatus = signal3,
		getLoadMoreStatus = signal4,
		refresh = refreshSessionList,
		loadMore = loadMoreSessionList
	}

	local function sessionLoad(sessionId: string, data)
		local v9 = typeof(sessionId) == "string" and sessionId ~= ""
		assert(v9, "sessionId is required")
		return rpcCallSync(AcpProtocol.Methods.SessionLoad, {
			sessionId = sessionId,
			cwd = data and data.cwd or "/",
			mcpServers = data and data.mcpServers,
			historyPageToken = data and data.historyPageToken
		})
	end

	local function postSessionCancel(sessionId: string)
		return rpcCallSync(AcpProtocol.Methods.SessionCancel, { sessionId = sessionId })
	end

	local function sessionCancel(sessionId: string)
		local v9 = typeof(sessionId) == "string" and sessionId ~= ""
		assert(v9, "sessionId is required")
		local v10 = fn(false)
		local turn = v10.activeBySession[sessionId]

		local pendingCancel = v10.pendingCancels[sessionId]

		if FFlagBuildExperienceModelPickerData and pendingCancel ~= nil and pendingCancel.turn == turn then
			return pendingCancel.handle
		end

		local handle = rpcCallSync(AcpProtocol.Methods.SessionCancel, { sessionId = sessionId }) -- inferred equivalent call

		local v11 = { handle = handle, turn = turn }

		if FFlagBuildExperienceModelPickerData then
			v10.pendingCancels[sessionId] = v11
		end

		local function clearPending() -- 1 equivalent call inferred from this helper
			if v10.pendingCancels[sessionId] == v11 then
				v10.pendingCancels[sessionId] = nil
			end
		end
		onTerminal(handle.state, function()
			clearPending() -- inferred equivalent call
			local v12

			if FFlagBuildExperienceModelPickerData then
				v12 = turn
			else
				v12 = fn(false).activeBySession[sessionId]
			end

			if v12 then
				v12.markCancelled()
				unregisterHandle(v12)
			end
		end, clearPending)
		return handle
	end

	local function sessionDelete(sessionId: string)
		local v9 = typeof(sessionId) == "string" and sessionId ~= ""
		assert(v9, "sessionId is required")
		local v10 = rpcCallSync(AcpProtocol.Methods.SessionDelete, { sessionId = sessionId }) -- inferred equivalent call
		onTerminal(v10.state, function()
			local v11 = fn(false).activeBySession[sessionId]

			if v11 then
				v11.fail("Session deleted before prompt response", AcpProtocol.ErrorCodes.Gone)
				unregisterHandle(v11)
			end
		end)
		return v10
	end

	local function adCampaignToolCallStatus(p)
		assert(typeof(p) == "table", "adCampaignToolCallStatus requires params")
		local v9 = typeof(p.toolCallId) == "string" and p.toolCallId ~= ""
		assert(v9, "toolCallId is required")
		return rpcCallSync(AcpProtocol.Methods.AdCampaignToolCallStatus, p, decodeAdCampaignToolCallStatusResult)
	end

	local function registerTurnHandle(sessionId: string, p, p2, p3)
		local v9 = fn(false)
		local turnHandle, v10 = createTurnHandle(sessionId, p, function()
			if not FFlagBuildExperienceModelPickerData or fn(false) == v9 then
				sessionCancel(sessionId)
			end
		end, p2, p3)
		local fn_2 = fn(false)
		fn_2.activeBySession[sessionId] = v10
		local fn_3 = fn(false)
		fn_3.publicBySession[sessionId] = turnHandle

		if p ~= nil then
			local fn_4 = fn(false)
			fn_4.activeByRequestId[tostring(p)] = v10
		end

		if FFlagBuildExperienceModelPickerData then
			function turnHandle.isCurrentOwner(): boolean
				return fn(false) == v9
			end
		end

		return turnHandle
	end

	local function sessionPrompt(data)
		local v9

		if data then
			if typeof(data.sessionId) == "string" then
				v9 = data.sessionId ~= ""
			else
				v9 = false
			end
		else
			v9 = data
		end

		assert(v9, "sessionId is required")
		assert(data.prompt, "prompt is required")

		if FFlagBuildExperienceModelPickerData then
			validateModelTier(data.model) -- inferred equivalent call
			local model = data._meta and data._meta._roblox and data._meta._roblox.model
			assert(data.model == nil or model == nil or model == data.model, "conflicting model tiers")
		end

		local sessionId = data.sessionId
		local id = nextId() -- inferred equivalent call
		local v10 = registerTurnHandle(sessionId, id, nil, nil)
		local v11 = fn(false).activeBySession[sessionId]

		local buildSessionPromptWireParams = AcpProtocol.buildSessionPromptWireParams
		local v12 = {
			sessionId = sessionId,
			prompt = normalizePrompt(data.prompt), -- inferred equivalent call
			meta = data._meta,
			model = 0,
			experiment = 0
		}
		local model

		if FFlagBuildExperienceModelPickerData then
			model = data.model
		end

		v12.model = model
		local experiment

		if FFlagBuildExperienceModelPickerData or experimentOverride.isEnabled() then
			experiment = data.experiment
		end

		v12.experiment = experiment
		local sessionPromptWireParams = buildSessionPromptWireParams(v12)

		local v13 = rpcCall(id, AcpProtocol.Methods.SessionPrompt, sessionPromptWireParams)
		local v14

		if FFlagBuildExperienceLibrary then
			v14 = v11.markAccepted
		end

		onTerminal(v13.state, v14, function(p, p2)
			local v15

			if FFlagBuildExperiencePromptFailureTelemetry then
				v15 = classifyRequestFailure(v13.state(false))
			else
				v15 = nil
			end

			task.defer(function()
				if v11.isDone() then
					return
				end

				local v16, v17

				if FFlagBuildExperienceModelPickerData then
					v16, v17 = getFundingError(v13.state(false))
				end

				v11.fail(p, p2, v15, v16, v17)

				if v11.isDone() then
					unregisterHandle(v11)
				end
			end)
		end)

		return v10
	end

	local function getActiveTurnHandle(p: string)
		return fn(false).publicBySession[p]
	end

	local function ingestSessionHistory(p: string, p2, p3: number?)
		return historyIngest.ingestSessionHistory({
			getActiveTurnInternals = function(p4: string)
				return fn(false).activeBySession[p4]
			end,
			onTurnDone = unregisterHandle
		}, p, p2, p3)
	end

	local sessionRegistry2 = sessionRegistry.createSessionRegistry({
		initialize = initialize,
		sessionNew = sessionNew,
		sessionLoad = sessionLoad,
		sessionPrompt = sessionPrompt,
		ingestSessionHistory = ingestSessionHistory,
		submitToolResult = submitToolResult,
		getActiveTurnHandle = getActiveTurnHandle,
		onCasSessionIdChanged = function(_: string?) end,
		rpcTimeoutSeconds = constants.getRpcTimeoutSeconds()
	})
	local creatorAgentChatStore = {
		initialize = initialize,
		sessionNew = sessionNew,
		sessionList = function(options2)
			return rpcCallSync(AcpProtocol.Methods.SessionList, options2 or {})
		end,
		getSessionListStore = function()
			return sessionListStore
		end,
		sessionFindByUniverse = function(p)
			assert(typeof(p) == "table", "sessionFindByUniverse requires params")
			local v9 = typeof(p.universeId) == "number" and p.universeId ~= 0
			assert(v9, "universeId is required")
			return rpcCallSync(AcpProtocol.Methods.SessionFindByUniverse, p)
		end,
		sessionLoad = sessionLoad,
		sessionReadTasks = function(sessionId: string)
			local v9 = typeof(sessionId) == "string" and sessionId ~= ""
			assert(v9, "sessionId is required")
			return rpcCallSync(AcpProtocol.Methods.SessionReadTasks, { sessionId = sessionId })
		end,
		sessionPrompt = sessionPrompt,
		submitToolResult = submitToolResult,
		sessionCancel = sessionCancel,
		sessionDelete = sessionDelete,
		sessionUpdateInfo = function(sessionId: string, title: string?)
			local v9 = typeof(sessionId) == "string" and sessionId ~= ""
			assert(v9, "sessionId is required")
			return rpcCallSync(AcpProtocol.Methods.SessionUpdateInfo, {
				sessionId = sessionId,
				title = title
			})
		end,
		sessionSaveAndPublish = function(data)
			assert(typeof(data) == "table", "sessionSaveAndPublish requires params")
			local v9 = typeof(data.placeId) == "number" and data.placeId > 0
			assert(v9, "placeId must be a positive number")
			assert(data.title == nil or typeof(data.title) == "string", "title must be a string")
			assert(data.description == nil or typeof(data.description) == "string", "description must be a string")
			return rpcCallSync(AcpProtocol.Methods.SessionSaveAndPublish, data)
		end,
		adCampaignEligibility = function(p)
			assert(typeof(p) == "table", "adCampaignEligibility requires params")
			local v9 = typeof(p.universeId) == "number" and p.universeId > 0
			assert(v9, "universeId must be a positive number")
			local decodeAdCampaignEligibilityResult = require(script.Parent.decodeAdCampaignEligibilityResult)
			return rpcCallSync(AcpProtocol.Methods.AdCampaignEligibility, p, decodeAdCampaignEligibilityResult)
		end,
		adCampaignCheckFunds = function(p)
			assert(typeof(p) == "table", "adCampaignCheckFunds requires params")
			assert(
				p.campaignOption == "feedback" or p.campaignOption == "plays",
				"campaignOption must be feedback or plays"
			)

			local decodeAdCampaignCheckFundsResult = require(script.Parent.decodeAdCampaignCheckFundsResult)
			return rpcCallSync(AcpProtocol.Methods.AdCampaignCheckFunds, p, decodeAdCampaignCheckFundsResult)
		end,
		adCampaignCreate = function(data)
			assert(typeof(data) == "table", "adCampaignCreate requires params")
			local v9 = typeof(data.universeId) == "number" and data.universeId > 0
			assert(v9, "universeId must be a positive number")
			local v10 = typeof(data.idempotencyKey) == "string" and data.idempotencyKey ~= ""
			assert(v10, "idempotencyKey is required")
			local decodeAdCampaignCreateResult = require(script.Parent.decodeAdCampaignCreateResult)

			if not FFlagBuildAgentAdCampaignCard or data.toolCallId == nil then
				return rpcCallSync(AcpProtocol.Methods.AdCampaignCreate, data, decodeAdCampaignCreateResult)
			end

			local v11 = typeof(data.toolCallId) == "string" and data.toolCallId ~= ""
			assert(v11, "toolCallId is required")
			return rpcCallSync(AcpProtocol.Methods.AdCampaignCreate, data, function(p)
				local v12, v13 = decodeAdCampaignCreateResult(p)

				if v12 == nil or v12.toolCallId == nil or v12.toolCallId == data.toolCallId then
					return v12, v13
				end

				return nil, "Ad campaign create response does not match the requested tool call"
			end)
		end,
		adCampaignToolCallStatus = 0,
		ingestSessionHistory = 0,
		ingestFrame = 0,
		resumeTurnFromHistory = 0,
		getActiveTurnHandle = 0,
		getSessionForProject = 0
	}

	if not FFlagBuildAgentAdCampaignToolCallStatusFallback then
		adCampaignToolCallStatus = nil
	end

	creatorAgentChatStore.adCampaignToolCallStatus = adCampaignToolCallStatus

	creatorAgentChatStore.ingestSessionHistory = ingestSessionHistory

	function creatorAgentChatStore.ingestFrame(p, p2)
		ingestFrameHandler.ingestFrame({
			logger = logger,
			getSessionByCasSessionId = sessionRegistry2.getSessionByCasSessionId,
			getSessionForProject = sessionRegistry2.getSessionForProject,
			getActiveTurnBySession = function(p3: string)
				return fn(false).activeBySession[p3]
			end,
			getActiveTurnByRequestId = function(p3: string)
				return fn(false).activeByRequestId[p3]
			end,
			onTurnDone = unregisterHandle
		}, p, p2)
	end

	function creatorAgentChatStore.resumeTurnFromHistory(sessionId: string, p, p2)
		local v9 = typeof(sessionId) == "string" and sessionId ~= ""
		assert(v9, "sessionId is required")

		if p.isDone then
			return nil
		end

		local v10 = fn(false).publicBySession[sessionId]

		if v10 == nil then
			return registerTurnHandle(sessionId, nil, p, p2)
		end

		return v10
	end
	creatorAgentChatStore.getActiveTurnHandle = getActiveTurnHandle
	creatorAgentChatStore.getSessionForProject = sessionRegistry2.getSessionForProject
	return creatorAgentChatStore
end

return createCreatorAgentChatStore
