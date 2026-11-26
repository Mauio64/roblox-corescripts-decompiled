local HttpClient = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/HttpClient")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Signals")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/SharedFlags")
local SignalsUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/SignalsUtils")
local FFlagBuildAgentAdCampaignCard = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/FFlagBuildAgentAdCampaignCard")

local fFlagBuildAgentAdCampaignToolCallStatusFallback = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/SharedFlags").FFlagBuildAgentAdCampaignToolCallStatusFallback

local v5 = if fFlagBuildAgentAdCampaignToolCallStatusFallback then require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/decodeAdCampaignToolCallStatusResult") else nil

local AcpProtocol = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/Acp/AcpProtocol")
local classifyRequestFailure = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/classifyRequestFailure")
local historyIngest = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/CasStore/historyIngest")
local ingestFrameHandler = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/CasStore/ingestFrameHandler")
local module10 = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/CasStore/sessionRegistry")
local constants = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/ChatSession/constants")
local createTurnHandle = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/createTurnHandle")
local experimentOverride = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/experimentOverride")
local onTerminal = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/onTerminal")
local rpcDecoder = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/rpcDecoder")
local getFundingError = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/getFundingError")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/types")
local withCsrfRetry = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/withCsrfRetry")

local fFlagBuildExperienceModelPickerData = SharedFlags.FFlagBuildExperienceModelPickerData
local fFlagBuildExperienceChatOpenId = SharedFlags.FFlagBuildExperienceChatOpenId
local fFlagBuildExperiencePromptFailureTelemetry = SharedFlags.FFlagBuildExperiencePromptFailureTelemetry
local fFlagBuildExperienceLibrary = SharedFlags.FFlagBuildExperienceLibrary

local function validateModelTier(p2)
	assert(p2 == nil or p2 == "default" or p2 == "advanced", "invalid model tier")
end

local function normalizeNextPageToken(value)
	if typeof(value) == "string" and value ~= "" then
		return value
	end

	return nil
end

local function appendSessionListEntries(items, sessions)
	local result = {}
	local sessionIdSet = {}

	for k, item in items do
		local sessionId = item.sessionId

		if typeof(sessionId) == "string" and sessionId ~= "" then
			sessionIdSet[sessionId] = true
		end

		table.insert(result, item)
	end

	for k, item in sessions do
		local sessionId = item.sessionId

		if typeof(sessionId) ~= "string" or sessionId == "" or sessionIdSet[sessionId] then
			continue
		end

		sessionIdSet[sessionId] = true
		table.insert(result, item)
	end

	return result
end

local function normalizePrompt(value)
	if typeof(value) == "string" then
		return {
			{ type = "text", text = value }
		}
	end

	return value
end

local v6 = {
	debug = function() end,
	info = function() end,
	warning = function() end,
	error = function() end
}

local function createCreatorAgentChatStore(options)
	local v7 = options or {}
	local network = v7.network or withCsrfRetry(HttpClient.createRequestInternalNetwork())
	local baseUrl = v7.baseUrl or AcpProtocol.acpUrl()
	local logger = v7.logger or v6

	local function authHeaders()
		if v7.getAuthHeaders then
			return (v7.getAuthHeaders())
		end

		return {}
	end

	local count = 0
	local function nextId()
		if v7.generateRequestId then
			return v7.generateRequestId()
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

	local fn = not fFlagBuildExperienceModelPickerData and function(p2)
		return activeTurns
	end or SignalsUtils.createSessionScopedSignal(createActiveTurns)

	local function requestIdKey(p2)
		if p2 == nil then
			return nil
		end

		return (tostring(p2))
	end

	local function unregisterHandle(p2)
		for k, v8 in fn(false).activeBySession do
			if v8 == p2 then
				local fn_2 = fn(false)
				fn_2.activeBySession[k] = nil
				local fn_3 = fn(false)
				fn_3.publicBySession[k] = nil
				break
			end
		end

		local requestId = p2.requestId
		local v8 = if requestId ~= nil then tostring(requestId) else nil

		if v8 and fn(false).activeByRequestId[v8] == p2 then
			local fn_4 = fn(false)
			fn_4.activeByRequestId[v8] = nil
		end
	end

	local function rpcCall(p2, sessionPrompt, sessionPromptWireParams, p3)
		logger:debug(`[CAS] -> {sessionPrompt} id={tostring(p2)}`)
		return HttpClient.createRequest({
			networkImpl = network,
			method = "POST",
			url = baseUrl,
			headers = not v7.getAuthHeaders and {} or v7.getAuthHeaders(),
			body = {
				jsonrpc = "2.0",
				id = p2,
				method = sessionPrompt,
				params = sessionPromptWireParams or {}
			},
			analyticsKey = "cas." .. sessionPrompt:gsub("/", "-"):lower(),
			decode = rpcDecoder(p3)
		})
	end

	local function rpcCallSync(p2, p3, p4)
		local v9

		if v7.generateRequestId then
			v9 = v7.generateRequestId()
		else
			count += 1
			v9 = count
		end

		return rpcCall(v9, p2, p3, p4)
	end

	local function submitToolResult(data)
		local v8 = typeof(data.sessionId) == "string" and data.sessionId ~= ""
		assert(v8, "sessionId is required")

		local v9 = typeof(data.content) == "table" and typeof(data.content.text) == "string"
		assert(v9, "content.text is required")

		if data.turnId ~= nil then
			local v10 = typeof(data.turnId) == "number" and data.turnId > 0
			assert(v10, "turnId must be a positive number")
		end

		if data.referenceId ~= nil then
			local v10 = typeof(data.referenceId) == "string" and data.referenceId ~= ""
			assert(v10, "referenceId must be a string")
		end

		local v10

		if v7.generateRequestId then
			v10 = v7.generateRequestId()
		else
			count += 1
			v10 = count
		end

		local v11 = {
			sessionId = data.sessionId,
			tool_name = AcpProtocol.AskTool.Name,
			content = data.content,
			isError = data.isError ~= nil and data.isError
		}

		if data.turnId ~= nil then
			v11.turnId = data.turnId
		end

		if data.referenceId ~= nil then
			v11.referenceId = data.referenceId
		end

		return HttpClient.createRequest({
			networkImpl = network,
			method = "POST",
			url = baseUrl,
			headers = not v7.getAuthHeaders and {} or v7.getAuthHeaders(),
			body = { jsonrpc = "2.0", id = v10, result = v11 },
			analyticsKey = "cas.ask-tool-result",
			decode = rpcDecoder()
		})
	end

	local function initialize(p2)
		return rpcCallSync(AcpProtocol.Methods.Initialize, p2 or {
			protocolVersion = AcpProtocol.ProtocolVersion
		})
	end

	local function sessionNew(data)
		assert(data ~= nil, "sessionNew requires params")
		assert(typeof(data.project) == "table", "sessionNew requires params.project")
		assert(typeof(data.project.universeId) == "number", "sessionNew requires params.project.universeId")
		assert(typeof(data.project.placeId) == "number", "sessionNew requires params.project.placeId")

		if fFlagBuildExperienceModelPickerData then
			local model = data.model
			assert(model == nil or model == "default" or model == "advanced", "invalid model tier")
		end

		local sessionNew2 = AcpProtocol.Methods.SessionNew
		local buildSessionNewWireParams = AcpProtocol.buildSessionNewWireParams
		local v9 = {
			cwd = data.cwd or "/",
			mcpServers = data.mcpServers,
			project = data.project,
			model = 0,
			experiment = 0,
			application = 0,
			chatOpenId = 0
		}
		local v10 = if fFlagBuildExperienceModelPickerData then data.model else nil
		v9.model = v10
		v9.experiment = data.experiment
		v9.application = data.application
		local v11 = if fFlagBuildExperienceChatOpenId then data.chatOpenId else nil
		v9.chatOpenId = v11
		return rpcCallSync(sessionNew2, buildSessionNewWireParams(v9))
	end

	local signal, v8 = Signals.createSignal({})
	local signal2, v9 = Signals.createSignal(nil)
	local signal3, v10 = Signals.createSignal("pending")
	local signal4, v11 = Signals.createSignal(nil)
	local v12 = nil
	local v13 = nil
	local count2 = 0

	local function refreshSessionList()
		if v12 ~= nil then
			if v12.state(false).status == "pending" then
				return v12
			end

			v12 = nil
		end

		count2 += 1
		local v14 = count2
		v13 = nil
		v10("pending")
		v11(nil)
		local sessionList2 = AcpProtocol.Methods.SessionList
		local v17

		if v7.generateRequestId then
			v17 = v7.generateRequestId()
		else
			count += 1
			v17 = count
		end

		local v18 = rpcCall(v17, sessionList2, {}, nil)

		v12 = v18
		onTerminal(v18.state, function(p2)
			if v14 ~= count2 then
				return
			end

			v12 = nil
			local sessions = p2.sessions or {}
			local nextPageToken = p2.nextPageToken

			if typeof(nextPageToken) ~= "string" or nextPageToken == "" then
				nextPageToken = nil
			end

			v8(sessions)
			v9(nextPageToken)
			v10("succeeded")
		end, function(p2)
			if v14 ~= count2 then
				return
			end

			v12 = nil
			v10("failed")
		end)
		return v18
	end

	local function loadMoreSessionList()
		local v14 = signal2(false)

		if not (v14 ~= nil and v12 == nil and v13 == nil and signal3(false) == "succeeded") then
			return nil
		end

		local v15 = count2

		v11("pending")
		local sessionList2 = AcpProtocol.Methods.SessionList
		local v18

		if v7.generateRequestId then
			v18 = v7.generateRequestId()
		else
			count += 1
			v18 = count
		end

		local v19 = rpcCall(v18, sessionList2, { pageToken = v14 } or {}, nil)

		v13 = v19
		onTerminal(v19.state, function(p2)
			if v15 ~= count2 then
				return
			end

			v13 = nil
			local sessions = p2.sessions or {}
			local nextPageToken = p2.nextPageToken

			if typeof(nextPageToken) ~= "string" or nextPageToken == "" then
				nextPageToken = nil
			end

			v8(appendSessionListEntries(signal(false), sessions))
			v9(nextPageToken)
			v11("succeeded")
		end, function(p2)
			if v15 ~= count2 then
				return
			end

			v13 = nil
			v11("failed")
		end)
		return v19
	end

	local sessionListStore = {
		getSessions = signal,
		getNextPageToken = signal2,
		getStatus = signal3,
		getLoadMoreStatus = signal4,
		refresh = refreshSessionList,
		loadMore = loadMoreSessionList
	}

	local function sessionLoad(value, data)
		local v14 = typeof(value) == "string" and value ~= ""
		assert(v14, "sessionId is required")
		return rpcCallSync(AcpProtocol.Methods.SessionLoad, {
			sessionId = value,
			cwd = data and data.cwd or "/",
			mcpServers = data and data.mcpServers,
			historyPageToken = data and data.historyPageToken
		})
	end

	local function postSessionCancel(p2)
		return rpcCallSync(AcpProtocol.Methods.SessionCancel, { sessionId = p2 })
	end

	local function sessionCancel(value)
		local v14 = typeof(value) == "string" and value ~= ""
		assert(v14, "sessionId is required")
		local v15 = fn(false)
		local v16 = v15.activeBySession[value]

		local pendingCancel = v15.pendingCancels[value]

		if fFlagBuildExperienceModelPickerData and pendingCancel ~= nil and pendingCancel.turn == v16 then
			return pendingCancel.handle
		end

		local sessionCancel2 = AcpProtocol.Methods.SessionCancel
		local v19

		if v7.generateRequestId then
			v19 = v7.generateRequestId()
		else
			count += 1
			v19 = count
		end

		local v20 = rpcCall(v19, sessionCancel2, { sessionId = value }, nil)

		local v21 = { handle = v20, turn = v16 }

		if fFlagBuildExperienceModelPickerData then
			v15.pendingCancels[value] = v21
		end

		local function clearPending()
			if v15.pendingCancels[value] == v21 then
				v15.pendingCancels[value] = nil
			end
		end
		onTerminal(v20.state, function()
			if v15.pendingCancels[value] == v21 then
				v15.pendingCancels[value] = nil
			end

			local v22 = if fFlagBuildExperienceModelPickerData then v16 else fn(false).activeBySession[value]

			if v22 then
				v22.markCancelled()
				unregisterHandle(v22)
			end
		end, clearPending)
		return v20
	end

	local function sessionDelete(value)
		local v14 = typeof(value) == "string" and value ~= ""
		assert(v14, "sessionId is required")
		local sessionDelete2 = AcpProtocol.Methods.SessionDelete
		local v17

		if v7.generateRequestId then
			v17 = v7.generateRequestId()
		else
			count += 1
			v17 = count
		end

		local v18 = rpcCall(v17, sessionDelete2, { sessionId = value }, nil)
		onTerminal(v18.state, function()
			local v19 = fn(false).activeBySession[value]

			if v19 then
				v19.fail("Session deleted before prompt response", AcpProtocol.ErrorCodes.Gone)
				unregisterHandle(v19)
			end
		end)
		return v18
	end

	local function adCampaignEligibility(p2)
		assert(typeof(p2) == "table", "adCampaignEligibility requires params")
		local v14 = typeof(p2.universeId) == "number" and p2.universeId > 0
		assert(v14, "universeId must be a positive number")
		local module18 = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/decodeAdCampaignEligibilityResult")
		return rpcCallSync(AcpProtocol.Methods.AdCampaignEligibility, p2, module18)
	end

	local function adCampaignCreate(data)
		assert(typeof(data) == "table", "adCampaignCreate requires params")
		local v14 = typeof(data.universeId) == "number" and data.universeId > 0
		assert(v14, "universeId must be a positive number")
		local v15 = typeof(data.idempotencyKey) == "string" and data.idempotencyKey ~= ""
		assert(v15, "idempotencyKey is required")
		local module18 = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/decodeAdCampaignCreateResult")

		if not FFlagBuildAgentAdCampaignCard or data.toolCallId == nil then
			return rpcCallSync(AcpProtocol.Methods.AdCampaignCreate, data, module18)
		end

		local v16 = typeof(data.toolCallId) == "string" and data.toolCallId ~= ""
		assert(v16, "toolCallId is required")
		return rpcCallSync(AcpProtocol.Methods.AdCampaignCreate, data, function(p2)
			local v17, v18 = module18(p2)

			if v17 == nil or v17.toolCallId == nil or v17.toolCallId == data.toolCallId then
				return v17, v18
			end

			return nil, "Ad campaign create response does not match the requested tool call"
		end)
	end

	local function adCampaignToolCallStatus(p2)
		assert(typeof(p2) == "table", "adCampaignToolCallStatus requires params")
		local v14 = typeof(p2.toolCallId) == "string" and p2.toolCallId ~= ""
		assert(v14, "toolCallId is required")
		return rpcCallSync(AcpProtocol.Methods.AdCampaignToolCallStatus, p2, v5)
	end

	local function adCampaignCheckFunds(p2)
		assert(typeof(p2) == "table", "adCampaignCheckFunds requires params")
		assert(
			p2.campaignOption == "feedback" or p2.campaignOption == "plays",
			"campaignOption must be feedback or plays"
		)

		local module18 = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/decodeAdCampaignCheckFundsResult")
		return rpcCallSync(AcpProtocol.Methods.AdCampaignCheckFunds, p2, module18)
	end

	local function registerTurnHandle(p2, p3, p4, p5)
		local v14 = fn(false)
		local turnHandle, v15 = createTurnHandle(p2, p3, function()
			if not fFlagBuildExperienceModelPickerData or fn(false) == v14 then
				sessionCancel(p2)
			end
		end, p4, p5)
		local fn_2 = fn(false)
		fn_2.activeBySession[p2] = v15
		local fn_3 = fn(false)
		fn_3.publicBySession[p2] = turnHandle

		if p3 ~= nil then
			local fn_4 = fn(false)
			fn_4.activeByRequestId[tostring(p3)] = v15
		end

		if fFlagBuildExperienceModelPickerData then
			function turnHandle.isCurrentOwner(): boolean
				return fn(false) == v14
			end
		end

		return turnHandle
	end

	local function sessionPrompt(data)
		local v14 = if data then typeof(data.sessionId) == "string" and data.sessionId ~= "" else data
		assert(v14, "sessionId is required")
		assert(data.prompt, "prompt is required")

		if fFlagBuildExperienceModelPickerData then
			local model = data.model
			assert(model == nil or model == "default" or model == "advanced", "invalid model tier")

			local model2 = data._meta and data._meta._roblox and data._meta._roblox.model
			assert(data.model == nil or model2 == nil or model2 == data.model, "conflicting model tiers")
		end

		local sessionId = data.sessionId
		local v15

		if v7.generateRequestId then
			v15 = v7.generateRequestId()
		else
			count += 1
			v15 = count
		end

		local v16 = registerTurnHandle(sessionId, v15, nil, nil)
		local v17 = fn(false).activeBySession[sessionId]

		local buildSessionPromptWireParams = AcpProtocol.buildSessionPromptWireParams

		local prompt = data.prompt
		local v18 = {
			sessionId = sessionId,
			prompt = typeof(prompt) == "string" and {
				{ type = "text", text = prompt }
			} or prompt,
			meta = data._meta,
			model = 0,
			experiment = 0
		}
		local v19 = if fFlagBuildExperienceModelPickerData then data.model else nil
		v18.model = v19
		local v20 = if fFlagBuildExperienceModelPickerData or experimentOverride.isEnabled() then data.experiment else nil
		v18.experiment = v20
		local sessionPromptWireParams = buildSessionPromptWireParams(v18)

		local v21 = rpcCall(v15, AcpProtocol.Methods.SessionPrompt, sessionPromptWireParams)
		local v22 = if fFlagBuildExperienceLibrary then v17.markAccepted else nil
		onTerminal(v21.state, v22, function(p2, p3)
			local v23 = if fFlagBuildExperiencePromptFailureTelemetry then classifyRequestFailure(v21.state(false)) else nil

			task.defer(function()
				if v17.isDone() then
					return
				end

				local v24, v25

				if fFlagBuildExperienceModelPickerData then
					v24, v25 = getFundingError(v21.state(false))
				end

				v17.fail(p2, p3, v23, v24, v25)

				if v17.isDone() then
					unregisterHandle(v17)
				end
			end)
		end)

		return v16
	end

	local function getActiveTurnHandle(p2)
		return fn(false).publicBySession[p2]
	end

	local function ingestSessionHistory(p2, p3, p4)
		return historyIngest.ingestSessionHistory({
			getActiveTurnInternals = function(p5)
				return fn(false).activeBySession[p5]
			end,
			onTurnDone = unregisterHandle
		}, p2, p3, p4)
	end

	local sessionRegistry = module10.createSessionRegistry({
		initialize = initialize,
		sessionNew = sessionNew,
		sessionLoad = sessionLoad,
		sessionPrompt = sessionPrompt,
		ingestSessionHistory = ingestSessionHistory,
		submitToolResult = submitToolResult,
		getActiveTurnHandle = getActiveTurnHandle,
		onCasSessionIdChanged = function(p2) end,
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
		sessionFindByUniverse = function(p2)
			assert(typeof(p2) == "table", "sessionFindByUniverse requires params")
			local v14 = typeof(p2.universeId) == "number" and p2.universeId ~= 0
			assert(v14, "universeId is required")
			return rpcCallSync(AcpProtocol.Methods.SessionFindByUniverse, p2)
		end,
		sessionLoad = sessionLoad,
		sessionReadTasks = function(value)
			local v14 = typeof(value) == "string" and value ~= ""
			assert(v14, "sessionId is required")
			return rpcCallSync(AcpProtocol.Methods.SessionReadTasks, { sessionId = value })
		end,
		sessionPrompt = sessionPrompt,
		submitToolResult = submitToolResult,
		sessionCancel = sessionCancel,
		sessionDelete = sessionDelete,
		sessionUpdateInfo = function(value, p2)
			local v14 = typeof(value) == "string" and value ~= ""
			assert(v14, "sessionId is required")
			return rpcCallSync(AcpProtocol.Methods.SessionUpdateInfo, {
				sessionId = value,
				title = p2
			})
		end,
		sessionSaveAndPublish = function(data)
			assert(typeof(data) == "table", "sessionSaveAndPublish requires params")
			local v14 = typeof(data.placeId) == "number" and data.placeId > 0
			assert(v14, "placeId must be a positive number")
			assert(data.title == nil or typeof(data.title) == "string", "title must be a string")
			assert(
				data.description == nil or typeof(data.description) == "string",
				"description must be a string"
			)
			return rpcCallSync(AcpProtocol.Methods.SessionSaveAndPublish, data)
		end,
		adCampaignEligibility = adCampaignEligibility,
		adCampaignCheckFunds = adCampaignCheckFunds,
		adCampaignCreate = adCampaignCreate,
		adCampaignToolCallStatus = 0,
		ingestSessionHistory = 0,
		ingestFrame = 0,
		resumeTurnFromHistory = 0,
		getActiveTurnHandle = 0,
		getSessionForProject = 0
	}

	if not fFlagBuildAgentAdCampaignToolCallStatusFallback then
		adCampaignToolCallStatus = nil
	end

	creatorAgentChatStore.adCampaignToolCallStatus = adCampaignToolCallStatus

	creatorAgentChatStore.ingestSessionHistory = ingestSessionHistory

	function creatorAgentChatStore.ingestFrame(p2, p3)
		ingestFrameHandler.ingestFrame({
			logger = logger,
			getSessionByCasSessionId = sessionRegistry.getSessionByCasSessionId,
			getSessionForProject = sessionRegistry.getSessionForProject,
			getActiveTurnBySession = function(p4)
				return fn(false).activeBySession[p4]
			end,
			getActiveTurnByRequestId = function(p4)
				return fn(false).activeByRequestId[p4]
			end,
			onTurnDone = unregisterHandle
		}, p2, p3)
	end

	function creatorAgentChatStore.resumeTurnFromHistory(value, p2, p3)
		local v14 = typeof(value) == "string" and value ~= ""
		assert(v14, "sessionId is required")

		if p2.isDone then
			return nil
		end

		local v15 = fn(false).publicBySession[value]

		if v15 == nil then
			return registerTurnHandle(value, nil, p2, p3)
		end

		return v15
	end
	creatorAgentChatStore.getActiveTurnHandle = getActiveTurnHandle
	creatorAgentChatStore.getSessionForProject = sessionRegistry.getSessionForProject
	return creatorAgentChatStore
end

return createCreatorAgentChatStore
