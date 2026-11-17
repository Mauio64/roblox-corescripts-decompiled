local parent = script:FindFirstAncestor("DataHydration").Parent

local Signals = require(parent.Signals)
local SharedFlags = require(parent.SharedFlags)

local AcpProtocol = require(script.Parent.Acp.AcpProtocol)
local classifyRequestFailure = require(script.Parent.classifyRequestFailure)
local chatOpenTelemetry = require(script.Parent.chatOpenTelemetry)
local experimentOverride = require(script.Parent.experimentOverride)
local getFundingError = require(script.Parent.getFundingError)
local sendConfiguration = require(script.Parent.sendConfiguration)
local FFlagBuildExperienceModelPickerData = SharedFlags.FFlagBuildExperienceModelPickerData
local FFlagBuildExperienceChatOpenId = SharedFlags.FFlagBuildExperienceChatOpenId
local FFlagBuildExperienceAdvancedPreviewSpecs = SharedFlags.FFlagBuildExperienceAdvancedPreviewSpecs
local sessionHistoryMerge = require(script.Parent.sessionHistoryMerge)
require(script.Parent.types)

local constants = require(script.Parent.ChatSession.constants)
local historyLoader = require(script.Parent.ChatSession.historyLoader)
local historyPageUtils = require(script.Parent.ChatSession.historyPageUtils)
local historyPolling = require(script.Parent.ChatSession.historyPolling)
local sendPrompt = require(script.Parent.ChatSession.sendPrompt)
local sessionHistoryCache = require(script.Parent.ChatSession.sessionHistoryCache)
local sessionScalarState = require(script.Parent.ChatSession.sessionScalarState)
require(script.Parent.ChatSession.sessionDeps)
local FFlagBuildExperiencePromptFailureTelemetry = SharedFlags.FFlagBuildExperiencePromptFailureTelemetry

local function createChatSession(deps, universeId: number?, placeId: number?, p: string?)
	local loaded = {}
	local overlay = {}

	local sessionScalarState2 = sessionScalarState.createSessionScalarState(p)
	local v = nil
	local rpcTimeoutSeconds = deps.rpcTimeoutSeconds or constants.getRpcTimeoutSeconds()
	local sessionHistoryCache2 = sessionHistoryCache.createSessionHistoryCache()
	local count = 0
	local count2 = 0
	local v2 = 0

	local v3 = nil

	local v4 = nil

	local function getExperimentKey() -- 3 equivalent calls inferred from this helper
		return experimentOverride.getKey(sessionScalarState2.getCasSessionId(false)) or v3
	end

	local function captureSessionNewExperiment() -- 2 equivalent calls inferred from this helper
		local v5

		if experimentOverride.isEnabled() then
			v5 = experimentOverride.getExperiment(getExperimentKey()) -- inferred equivalent call
		end

		v4 = v5
	end

	local function getSendChatOpenId() -- 1 equivalent call inferred from this helper
		return chatOpenTelemetry.getChatOpenIdForUniverse(universeId)
	end

	local function buildMergedHistory()
		return sessionHistoryMerge.orderMergedHistoryItems(loaded, overlay)
	end

	local signal, v5 = Signals.createSignal(buildMergedHistory())

	local function notifySessionStateChanged() -- 4 equivalent calls inferred from this helper
		v5(buildMergedHistory())
	end

	local function noteHistorySequenceIds(p2) -- 2 equivalent calls inferred from this helper
		sessionScalarState2.noteHistorySequenceId(historyPageUtils.getMaxHistorySequenceId(p2))
	end

	local function noteTurnSequenceIds(p2)
		local getLatestProcessedSequenceNumber = p2.getLatestProcessedSequenceNumber

		if getLatestProcessedSequenceNumber ~= nil then
			sessionScalarState2.noteHistorySequenceId(getLatestProcessedSequenceNumber())
		end
	end

	local function snapshotActiveSession()
		local casSessionId = sessionScalarState2.getCasSessionId(false)

		if casSessionId == nil or casSessionId == "" then
			return nil
		end

		return {
			loadedBySequenceId = loaded,
			overlayBySequenceId = overlay,
			hasLoadedHistory = sessionScalarState2.getHasLoadedHistory(false),
			nextHistoryPageToken = sessionScalarState2.getNextHistoryPageToken(false),
			latestObservedHistorySequenceId = sessionScalarState2.getLatestObservedHistorySequenceId(false)
		}
	end

	local function saveActiveSessionToCache() -- 1 equivalent call inferred from this helper
		local casSessionId = sessionScalarState2.getCasSessionId(false)

		if casSessionId == nil or casSessionId == "" or not sessionScalarState2.getHasLoadedHistory(false) then
			return
		end

		local v6 = snapshotActiveSession()

		if v6 ~= nil then
			sessionHistoryCache2.save(casSessionId, v6)
		end
	end

	local function restoreSessionFromCache(p2: string): boolean -- 1 equivalent call inferred from this helper
		local v6 = sessionHistoryCache2.restore(p2)

		if v6 == nil then
			return false
		end

		loaded = v6.loadedBySequenceId
		overlay = v6.overlayBySequenceId
		sessionScalarState2.setHasLoadedHistory(v6.hasLoadedHistory)
		sessionScalarState2.setNextHistoryPageToken(v6.nextHistoryPageToken)
		sessionScalarState2.setLatestObservedHistorySequenceId(v6.latestObservedHistorySequenceId)
		notifySessionStateChanged() -- inferred equivalent call
		return true
	end

	local function clearActiveSessionState()
		loaded = {}
		overlay = {}
		sessionScalarState2.setHasLoadedHistory(false)
		sessionScalarState2.setNextHistoryPageToken(nil)
		sessionScalarState2.setHistoryLoadInFlight(false)
		sessionScalarState2.setLatestObservedHistorySequenceId(nil)
		notifySessionStateChanged() -- inferred equivalent call
	end

	local function setCasSessionIdInternal(sessionId: string)
		if not (sessionId ~= "" and sessionScalarState2.getCasSessionId(false) ~= sessionId) then
			return
		end

		count += 1

		if FFlagBuildExperienceModelPickerData then
			sessionScalarState2.setModels(nil)
			sessionScalarState2.setHasObservedModels(false)
		end

		saveActiveSessionToCache() -- inferred equivalent call
		sessionScalarState2.setCasSessionId(sessionId)

		if FFlagBuildExperienceModelPickerData and experimentOverride.isEnabled() then
			experimentOverride.move(v3, experimentOverride.getKey(sessionId))
		end

		sessionScalarState2.setHistoryLoadInFlight(false)

		if restoreSessionFromCache(sessionId) then -- inferred equivalent call
			deps.onCasSessionIdChanged(sessionId)
			return
		end

		clearActiveSessionState()
		deps.onCasSessionIdChanged(sessionId)
	end

	local function mergeHistoryPage(p2, p3: string?)
		sessionHistoryMerge.mergeHistoryIntoMap(loaded, p2, overlay)
		sessionScalarState2.setNextHistoryPageToken(p3)
		noteHistorySequenceIds(p2) -- inferred equivalent call
		notifySessionStateChanged() -- inferred equivalent call
	end

	local function ingestRealtimeUpdate(p2, p3: number)
		if sessionHistoryMerge.ingestOverlayUpdate(overlay, loaded, p2, p3) then
			sessionScalarState2.noteHistorySequenceId(p3)
			notifySessionStateChanged() -- inferred equivalent call
		end
	end

	local function awaitRequest(p2, callback, p3: number?) -- 3 equivalent calls inferred from this helper
		local v6 = historyPageUtils.awaitRequestState(p2.state, p3 or os.clock() + rpcTimeoutSeconds, callback)

		if callback ~= nil then
			p2.dispose()
		end

		return v6
	end

	local function publishModels(result) -- 2 equivalent calls inferred from this helper
		local roblox

		if result and result._meta then
			roblox = result._meta._roblox
		end

		local setModels = sessionScalarState2.setModels
		local v6

		if roblox then
			v6 = roblox.models
		end

		setModels(v6)
		sessionScalarState2.setHasObservedModels(true)
	end

	local function publishExperiment(p2: string, result)
		if not experimentOverride.isEnabled() then
			return
		end

		local key = experimentOverride.getKey(p2)

		if
			experimentOverride.isPending(key)
			or FFlagBuildExperienceModelPickerData and experimentOverride.hasInternalEdit(key)
		then
			return
		end

		local experiment

		if not (result == nil or result._meta == nil or result._meta._roblox == nil) then
			experiment = result._meta._roblox.experiment
		end

		if experiment == nil then
			experimentOverride.clear(key)

			return
		end

		local hydrate = experimentOverride.hydrate

		local specVersion = experiment.specVersion

		if not FFlagBuildExperienceModelPickerData then
			experiment = nil
		end

		hydrate(key, specVersion, experiment)
	end

	local function loadSession(casSessionId: string, historyPageToken: string?, isCancelled, p2: number?)
		local v6 = count
		count2 += 1
		local v7 = count2
		local function isStale() -- 2 equivalent calls inferred from this helper
			return isCancelled() or v6 ~= count or sessionScalarState2.getCasSessionId(false) ~= casSessionId
		end

		if isStale() then -- inferred equivalent call
			return { status = "pending" }
		end

		local v8 = awaitRequest(deps.sessionLoad(casSessionId, { -- inferred equivalent call
			historyPageToken = historyPageToken
		}), isStale, p2)

		if isStale() then -- inferred equivalent call
			return { status = "pending" }
		end

		if v8.status == "succeeded" and v2 < v7 then
			v2 = v7
			publishModels(v8.result) -- inferred equivalent call
			publishExperiment(casSessionId, v8.result)
		end

		return v8
	end

	local v6 = {
		deps = deps,
		rpcTimeoutSeconds = rpcTimeoutSeconds,
		getCasSessionId = function()
			return sessionScalarState2.getCasSessionId(false)
		end,
		getHistoryLoadInFlight = function()
			return sessionScalarState2.getHistoryLoadInFlight(false)
		end,
		setHistoryLoadInFlight = sessionScalarState2.setHistoryLoadInFlight,
		getNextHistoryPageToken = function()
			return sessionScalarState2.getNextHistoryPageToken(false)
		end,
		setNextHistoryPageToken = sessionScalarState2.setNextHistoryPageToken,
		getLoadedBySequenceId = function()
			return loaded
		end,
		setLoadedBySequenceId = function(p2)
			loaded = p2
		end,
		getOverlayBySequenceId = function()
			return overlay
		end,
		setOverlayBySequenceId = function(p2)
			overlay = p2
		end,
		buildMergedHistory = buildMergedHistory,
		mergeHistoryPage = mergeHistoryPage,
		noteHistorySequenceIds = noteHistorySequenceIds,
		notifyMergedHistoryChanged = notifySessionStateChanged,
		markHistoryLoaded = sessionScalarState2.markHistoryLoaded,
		getRefreshGeneration = function()
			return count
		end,
		onInitialSessionLoad = publishExperiment
	}

	local createHistoryLoader = historyLoader.createHistoryLoader
	local v7

	if FFlagBuildExperienceModelPickerData then
		v7 = loadSession
	end

	local historyLoader2 = createHistoryLoader(v6, v7)

	local createHistoryPolling = historyPolling.createHistoryPolling
	local v8

	if FFlagBuildExperienceModelPickerData then
		v8 = loadSession
	end

	local historyPolling2 = createHistoryPolling({
		deps = deps,
		rpcTimeoutSeconds = rpcTimeoutSeconds,
		getCasSessionId = function()
			return sessionScalarState2.getCasSessionId(false)
		end,
		getNextHistoryPageToken = function()
			return sessionScalarState2.getNextHistoryPageToken(false)
		end,
		mergeHistoryPage = mergeHistoryPage
	}, v8)

	local function ensureInitialized(callback)
		if sessionScalarState2.getInitialized(false) then
			return true, nil, nil
		end

		local v9 = awaitRequest(deps.initialize({ protocolVersion = AcpProtocol.ProtocolVersion }), callback) -- inferred equivalent call

		if callback ~= nil and callback() then
			return false, nil, nil
		end

		if v9.status == "succeeded" then
			sessionScalarState2.setInitialized(true)
			return true, nil, nil
		end

		local v10 = false
		local errorCode = v9.errorCode

		if FFlagBuildExperiencePromptFailureTelemetry then
			return false, errorCode, (classifyRequestFailure(v9))
		end

		return v10, errorCode, nil
	end

	local function createCasSession(model, callback, p2, callback2, chatOpenId: string?)
		local v9 = count
		local function isStale()
			if v9 == count then
				if callback == nil then
					return false
				end

				return (callback())
			end

			return true
		end

		local v10

		if FFlagBuildExperienceModelPickerData and p2 ~= nil then
			v10 = p2.experiment
		else
			v10 = v4
		end

		local casSessionId = sessionScalarState2.getCasSessionId(false)

		if casSessionId ~= nil and not FFlagBuildExperienceModelPickerData then
			return casSessionId, nil
		end

		if casSessionId == nil and (universeId == nil or placeId == nil) then
			return nil, { stage = "missing_project" }
		end

		local v11

		if FFlagBuildExperienceModelPickerData then
			v11 = isStale
		else
			v11 = callback
		end

		local v12, errorCode, requestFailure = ensureInitialized(v11)

		if FFlagBuildExperienceModelPickerData then
			local v13

			if v9 == count then
				if callback == nil then
					v13 = false
				else
					v13 = callback()
				end
			else
				v13 = true
			end

			if v13 then
				return nil, nil
			end
		end

		if v12 then
			if casSessionId ~= nil then
				return casSessionId, nil
			end

			if callback2 ~= nil and callback2() then
				return nil, nil
			end

			local sessionNew = deps.sessionNew
			local v13 = {
				project = { universeId = universeId, placeId = placeId },
				experiment = 0,
				model = 0,
				application = "build",
				chatOpenId = 0
			}
			local experiment

			if FFlagBuildExperienceModelPickerData then
				experiment = v10
			else
				experiment = v4
			end

			v13.experiment = experiment

			if not FFlagBuildExperienceModelPickerData then
				model = nil
			end

			v13.model = model

			if not FFlagBuildExperienceChatOpenId then
				chatOpenId = nil
			end

			v13.chatOpenId = chatOpenId
			local v14 = sessionNew(v13)

			if not FFlagBuildExperienceModelPickerData then
				isStale = callback
			end

			local v15 = awaitRequest(v14, isStale) -- inferred equivalent call

			if FFlagBuildExperienceModelPickerData then
				local v16

				if v9 == count then
					if callback == nil then
						v16 = false
					else
						v16 = callback()
					end
				else
					v16 = true
				end

				if v16 then
					return nil, nil
				end
			end

			if v15.status == "succeeded" then
				local result = v15.result
				local sessionId

				if typeof(result) == "table" then
					sessionId = result.sessionId
				end

				if typeof(sessionId) ~= "string" or sessionId == "" then
					return nil, { stage = "session_new" }
				end

				if experimentOverride.isEnabled() then
					local key = experimentOverride.getKey(sessionId)

					if not FFlagBuildExperienceModelPickerData then
						v10 = v4
					end

					if experimentOverride.has(v3) then
						experimentOverride.move(v3, key)
					elseif v10 ~= nil then
						local hydrate = experimentOverride.hydrate

						local specVersion = v10.specVersion
						local v16

						if FFlagBuildExperienceAdvancedPreviewSpecs then
							v16 = v10
						end

						hydrate(key, specVersion, v16)
					end

					if
						not FFlagBuildExperienceModelPickerData
						or p2 == nil
						or sendConfiguration.sameExperiment(experimentOverride.getPromptExperiment(key), v10)
					then
						experimentOverride.consumePending(key)
					end
				end

				setCasSessionIdInternal(sessionId)

				if FFlagBuildExperienceModelPickerData then
					if sessionScalarState2.getCasSessionId(false) ~= sessionId then
						return nil, nil
					end

					publishModels(result) -- inferred equivalent call
				end

				return sessionId, nil
			else
				local fundingReason, fundingDetails

				if FFlagBuildExperienceModelPickerData then
					fundingReason, fundingDetails = getFundingError(v15)
				end

				local message

				if FFlagBuildExperienceModelPickerData then
					message = v15.error
				end

				local v16 = {
					stage = "session_new",
					message = message,
					errorCode = v15.errorCode,
					fundingReason = fundingReason,
					fundingDetails = fundingDetails,
					requestFailure = 0
				}
				local requestFailure2

				if FFlagBuildExperiencePromptFailureTelemetry then
					requestFailure2 = classifyRequestFailure(v15)
				end

				v16.requestFailure = requestFailure2
				return nil, v16
			end
		else
			if not FFlagBuildExperiencePromptFailureTelemetry then
				requestFailure = nil
			end

			return nil, {
				stage = "initialize",
				errorCode = errorCode,
				requestFailure = requestFailure
			}
		end
	end

	local v9 = nil

	local function newSetup(model, p2, chatOpenId: string?)
		local setup = {
			generation = count,
			model = model,
			experiment = 0,
			abandoners = 0,
			persistent = false,
			committed = false,
			done = false,
			chatOpenId = 0
		}

		local experiment = if p2 == nil then v4 else p2.experiment
		setup.experiment = experiment
		setup.abandoners = {}

		if not FFlagBuildExperienceChatOpenId then
			chatOpenId = nil
		end

		setup.chatOpenId = chatOpenId
		return setup
	end

	local function canAbandon(p2): boolean -- 4 equivalent calls inferred from this helper
		if p2.persistent then
			return false
		end

		for k in p2.abandoners do
			if not k() then
				return false
			end
		end

		return true
	end

	local function isReplaceable(data)
		local v10 = not (data.committed or data.done)

		if not v10 then
			return v10
		end

		if data.persistent then
			return false
		end

		for k in data.abandoners do
			if not k() then
				return false
			end
		end

		v10 = true
		return true
	end

	local function ensureCasSession(model, isCancelled, p2, flag: boolean?, p3: string?)
		if
			FFlagBuildExperienceModelPickerData
			and (sessionScalarState2.getCasSessionId(false) == nil or not sessionScalarState2.getInitialized(false))
		then
			local function callerCancelled()
				return isCancelled ~= nil and isCancelled()
			end

			local v10

			if isCancelled == nil then
				v10 = false
			else
				v10 = isCancelled()
			end

			if v10 then
				return nil, nil
			end

			local v11 = v9
			local v12 = v11 == nil or v11.generation ~= count

			if v12 then
				v11 = newSetup(model, p2, p3)
				v9 = v11
			end

			local v13

			if sessionScalarState2.getCasSessionId(false) == nil and v11.model ~= nil and model ~= nil then
				v13 = model ~= v11.model
			else
				v13 = false
			end

			local v14

			if sessionScalarState2.getCasSessionId(false) == nil and p2 ~= nil then
				v14 = v11.model ~= p2.tier or not sendConfiguration.sameExperiment(v11.experiment, p2.experiment)
			else
				v14 = false
			end

			local v15, v16

			if v12 or not (v13 or v14) then
				if v13 then
					return
						nil,
						{
							stage = "session_new",
							message = "session creation already started with a different model"
						}
				end

				if v14 then
					return
						nil,
						{
							stage = "session_new",
							message = "session creation already started with a different send configuration"
						}
				end

				if flag and isCancelled ~= nil then
					v11.abandoners[callerCancelled] = true
				else
					v11.persistent = true
				end

				if v12 then
					task.spawn(function()
						local success, result, v19 = pcall(createCasSession, model, nil, p2, function(): boolean
							if canAbandon(v11) then -- inferred equivalent call
								return true
							end

							v11.committed = true
							return false
						end, v11.chatOpenId)
						local v20 = v11
						local v21

						if success then
							v21 = result
						end

						v20.sessionId = v21
						v11.error = not success and {
							stage = "session_new",
							message = tostring(result)
						} or v19
						v11.done = true

						if v9 == v11 then
							v9 = nil
						end
					end)
				end

				while not v11.done do
					if isCancelled == nil then
						v15 = false
					else
						v15 = isCancelled()
					end

					if v15 then
						break
					end

					task.wait()
				end

				if isCancelled == nil then
					v16 = false
				else
					v16 = isCancelled()
				end

				if v16 or v11.sessionId ~= nil and v11.sessionId ~= sessionScalarState2.getCasSessionId(false) then
					return nil, nil
				end

				return v11.sessionId, v11.error
			else
				local v17 = not v11.committed

				if v17 then
					v17 = not v11.done and canAbandon(v11) -- inferred equivalent call
				end

				if v17 then
					v12 = true
					v11 = newSetup(model, p2, p3)
					v9 = v11
				else
					if v13 then
						return
							nil,
							{
								stage = "session_new",
								message = "session creation already started with a different model"
							}
					end

					if v14 then
						return
							nil,
							{
								stage = "session_new",
								message = "session creation already started with a different send configuration"
							}
					end
				end

				if flag and isCancelled ~= nil then
					v11.abandoners[callerCancelled] = true
				else
					v11.persistent = true
				end

				if v12 then
					task.spawn(function()
						local success, result, v19 = pcall(createCasSession, model, nil, p2, function(): boolean
							if canAbandon(v11) then -- inferred equivalent call
								return true
							end

							v11.committed = true
							return false
						end, v11.chatOpenId)
						local v20 = v11
						local v21

						if success then
							v21 = result
						end

						v20.sessionId = v21
						v11.error = not success and {
							stage = "session_new",
							message = tostring(result)
						} or v19
						v11.done = true

						if v9 == v11 then
							v9 = nil
						end
					end)
				end

				while not v11.done do
					if isCancelled == nil then
						v15 = false
					else
						v15 = isCancelled()
					end

					if v15 then
						break
					end

					task.wait()
				end

				if isCancelled == nil then
					v16 = false
				else
					v16 = isCancelled()
				end

				if v16 or v11.sessionId ~= nil and v11.sessionId ~= sessionScalarState2.getCasSessionId(false) then
					return nil, nil
				end

				return v11.sessionId, v11.error
			end
		else
			if not FFlagBuildExperienceChatOpenId then
				p3 = nil
			end

			return createCasSession(model, isCancelled, p2, nil, p3)
		end
	end

	local function prepareSession(data)
		local v10

		if FFlagBuildExperienceChatOpenId then
			v10 = getSendChatOpenId() -- inferred equivalent call
		end

		local v11

		if not (data == nil or data.sendConfiguration == nil) then
			v11 = sendConfiguration.capture(data.sendConfiguration.tier, data.sendConfiguration.experiment)
		end

		local v12

		if v11 == nil then
			if data ~= nil then
				v12 = data.model
			end
		else
			v12 = v11.tier
		end

		assert(v11 == nil or data == nil or data.model == nil or data.model == v12, "conflicting model tiers")

		local v13 = count
		local function isCancelled() -- 3 equivalent calls inferred from this helper
			if v13 == count then
				if data == nil or data.isCancelled == nil then
					return false
				end

				return (data.isCancelled())
			end

			return true
		end

		if isCancelled() then -- inferred equivalent call
			return nil, nil
		end

		if v11 == nil then
			captureSessionNewExperiment() -- inferred equivalent call
		end

		local casSessionId = sessionScalarState2.getCasSessionId(false)

		if casSessionId == nil then
			if v9 ~= nil and v9.generation == v13 and v12 ~= nil and v12 ~= v9.model then
				local v14 = v9
				local v15 = not v14.committed

				if v15 then
					v15 = not v14.done and canAbandon(v14) -- inferred equivalent call
				end

				if not v15 then
					return
						nil,
						{
							stage = "session_new",
							message = "session creation already started with a different model"
						}
				end
			end

			local v14

			if data ~= nil then
				v14 = data.isCancelled
			end

			return ensureCasSession(v12, v14, v11, v11 ~= nil, v10)
		else
			local casSession, v14 = ensureCasSession(nil, isCancelled, v11, nil, v10)

			if isCancelled() then -- inferred equivalent call
				return nil, nil
			end

			if casSession == nil then
				return nil, v14
			end

			local v15 = loadSession(casSessionId, nil, isCancelled)

			if isCancelled() then -- inferred equivalent call
				return nil, nil
			end

			if v15.status == "succeeded" then
				noteHistorySequenceIds(historyPageUtils.getSessionLoadHistory(v15.result)) -- inferred equivalent call
				return casSessionId, nil
			else
				local fundingReason, fundingDetails

				if FFlagBuildExperienceModelPickerData then
					fundingReason, fundingDetails = getFundingError(v15)
				end

				local v16 = {
					stage = "session_load",
					message = v15.error,
					errorCode = v15.errorCode,
					fundingReason = fundingReason,
					fundingDetails = fundingDetails,
					requestFailure = 0
				}
				local requestFailure

				if FFlagBuildExperiencePromptFailureTelemetry then
					requestFailure = classifyRequestFailure(v15)
				end

				v16.requestFailure = requestFailure
				return nil, v16
			end
		end
	end

	local sendPrompt2 = sendPrompt.createSendPrompt({
		ensureInitialized = ensureInitialized,
		ensureCasSession = ensureCasSession,
		getSendChatOpenId = getSendChatOpenId,
		getLatestObservedHistorySequenceId = function()
			return sessionScalarState2.getLatestObservedHistorySequenceId(false)
		end,
		noteTurnSequenceIds = noteTurnSequenceIds,
		startPollingTurnFromHistory = historyPolling2.startPollingTurnFromHistory,
		getAssistantTurnSequence = function()
			return sessionScalarState2.getAssistantTurnSequence(false)
		end,
		incrementAssistantTurnSequence = sessionScalarState2.incrementAssistantTurnSequence,
		sessionPrompt = function(data, p2)
			local experiment

			if FFlagBuildExperienceModelPickerData and p2 ~= nil then
				experiment = p2.experiment
			elseif experimentOverride.isEnabled() then
				experiment = experimentOverride.getPromptExperiment(getExperimentKey()) -- inferred equivalent call
			else
				experiment = nil
			end

			local sessionPrompt = deps.sessionPrompt
			local v10 = {
				sessionId = data.sessionId,
				prompt = data.prompt,
				model = 0,
				_meta = 0,
				experiment = 0
			}
			local model

			if FFlagBuildExperienceModelPickerData then
				model = data.model
			end

			v10.model = model
			v10._meta = data._meta
			v10.experiment = experiment
			local v11 = sessionPrompt(v10)

			if FFlagBuildExperienceModelPickerData then
				local key = experimentOverride.getKey(data.sessionId)

				if experiment == nil then
					return v11, nil
				end

				return v11, function()
					if
						(v11.isCurrentOwner == nil or v11.isCurrentOwner())
						and sendConfiguration.sameExperiment(experimentOverride.getPromptExperiment(key), experiment)
					then
						experimentOverride.consumePending(key)
					end
				end
			end

			if experiment ~= nil then
				experimentOverride.consumePending(getExperimentKey()) -- inferred equivalent call
			end

			return v11, nil
		end,
		setActiveStop = function(callback)
			v = callback
		end
	})

	local function stopActiveTurn()
		if v ~= nil then
			v()
		end
	end

	local chatSession = {
		getModels = sessionScalarState2.getModels,
		hasObservedModels = sessionScalarState2.hasObservedModels,
		prepareSession = 0,
		universeId = 0,
		placeId = 0,
		getCasSessionId = 0,
		setCasSessionId = 0,
		setPendingExperimentKey = 0,
		hasLoadedHistory = 0,
		markHistoryLoaded = 0,
		getNextHistoryPageToken = 0,
		getMergedHistory = 0,
		ingestRealtimeUpdate = 0,
		mergeHistoryPage = 0,
		refreshSession = 0,
		loadOlderHistory = 0,
		requestOlderHistoryWhile = 0,
		sendPrompt = 0,
		stopActiveTurn = 0,
		submitActiveToolResult = 0,
		getActiveTurnHandle = 0,
		startPollingActiveTurn = 0
	}

	if not FFlagBuildExperienceModelPickerData then
		prepareSession = nil
	end

	chatSession.prepareSession = prepareSession
	chatSession.universeId = universeId
	chatSession.placeId = placeId
	function chatSession.getCasSessionId()
		return sessionScalarState2.getCasSessionId(false)
	end

	chatSession.setCasSessionId = setCasSessionIdInternal
	function chatSession.setPendingExperimentKey(p2: string?)
		v3 = p2

		if FFlagBuildExperienceModelPickerData and experimentOverride.isEnabled() then
			experimentOverride.move(p2, experimentOverride.getKey(sessionScalarState2.getCasSessionId(false)))
		end
	end
	function chatSession.hasLoadedHistory()
		return sessionScalarState2.getHasLoadedHistory(false)
	end

	chatSession.markHistoryLoaded = sessionScalarState2.markHistoryLoaded
	function chatSession.getNextHistoryPageToken()
		return sessionScalarState2.getNextHistoryPageToken(false)
	end

	chatSession.getMergedHistory = signal
	chatSession.ingestRealtimeUpdate = ingestRealtimeUpdate
	chatSession.mergeHistoryPage = mergeHistoryPage
	chatSession.refreshSession = historyLoader2.refreshSession
	chatSession.loadOlderHistory = historyLoader2.loadOlderHistory
	chatSession.requestOlderHistoryWhile = historyLoader2.requestOlderHistoryWhile
	function chatSession.sendPrompt(p2)
		if not FFlagBuildExperienceModelPickerData or p2.sendConfiguration == nil then
			captureSessionNewExperiment() -- inferred equivalent call
		end

		return sendPrompt2.sendPrompt(p2)
	end

	chatSession.stopActiveTurn = stopActiveTurn

	function chatSession.submitActiveToolResult(content, isError: boolean?, turnId: number?, referenceId: string?)
		local casSessionId = sessionScalarState2.getCasSessionId(false)

		if casSessionId == nil then
			return nil
		end

		local submitToolResult = deps.submitToolResult

		if isError == nil then
			isError = false
		end

		return submitToolResult({
			sessionId = casSessionId,
			turnId = turnId,
			referenceId = referenceId,
			content = content,
			isError = isError
		})
	end

	function chatSession.getActiveTurnHandle()
		local casSessionId = sessionScalarState2.getCasSessionId(false)

		if casSessionId == nil then
			return nil
		end

		return deps.getActiveTurnHandle(casSessionId)
	end
	function chatSession.startPollingActiveTurn(p2)
		local casSessionId = sessionScalarState2.getCasSessionId(false)

		if casSessionId == nil then
			return function() end
		end

		return historyPolling2.startPollingActiveTurn(casSessionId, p2)
	end

	return chatSession
end

return createChatSession
