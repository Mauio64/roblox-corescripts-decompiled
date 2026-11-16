local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Signals")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/SharedFlags")

local AcpProtocol = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/Acp/AcpProtocol")
local classifyRequestFailure = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/classifyRequestFailure")
local experimentOverride = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/experimentOverride")
local getFundingError = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/getFundingError")
local sendConfiguration = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/sendConfiguration")
local fFlagBuildExperienceModelPickerData = SharedFlags.FFlagBuildExperienceModelPickerData
local sessionHistoryMerge = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/sessionHistoryMerge")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/types")

local constants = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/ChatSession/constants")
local module10 = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/ChatSession/historyLoader")
local historyPageUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/ChatSession/historyPageUtils")
local module12 = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/ChatSession/historyPolling")
local module13 = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/ChatSession/sendPrompt")
local module14 = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/ChatSession/sessionHistoryCache")
local module15 = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/ChatSession/sessionScalarState")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/ChatSession/sessionDeps")
local fFlagBuildExperiencePromptFailureTelemetry = SharedFlags.FFlagBuildExperiencePromptFailureTelemetry

local function createChatSession(data, universeId, placeId, p2)
	local loaded = {}
	local overlay = {}

	local sessionScalarState = module15.createSessionScalarState(p2)
	local v5 = nil
	local rpcTimeoutSeconds = data.rpcTimeoutSeconds or constants.getRpcTimeoutSeconds()
	local sessionHistoryCache = module14.createSessionHistoryCache()
	local count = 0
	local count2 = 0
	local v6 = 0

	local v7 = nil

	local v8 = nil

	local function getExperimentKey()
		return experimentOverride.getKey(sessionScalarState.getCasSessionId(false)) or v7
	end

	local function captureSessionNewExperiment()
		v8 = if experimentOverride.isEnabled() then experimentOverride.getExperiment(experimentOverride.getKey(sessionScalarState.getCasSessionId(false)) or v7) else nil
	end

	local function buildMergedHistory()
		return sessionHistoryMerge.orderMergedHistoryItems(loaded, overlay)
	end

	local signal, v9 = Signals.createSignal(buildMergedHistory())

	local function notifySessionStateChanged()
		v9(buildMergedHistory())
	end

	local function noteTurnSequenceIds(p3)
		local getLatestProcessedSequenceNumber = p3.getLatestProcessedSequenceNumber

		if getLatestProcessedSequenceNumber ~= nil then
			sessionScalarState.noteHistorySequenceId(getLatestProcessedSequenceNumber())
		end
	end

	local function snapshotActiveSession()
		local casSessionId = sessionScalarState.getCasSessionId(false)

		if casSessionId == nil or casSessionId == "" then
			return nil
		end

		return {
			loadedBySequenceId = loaded,
			overlayBySequenceId = overlay,
			hasLoadedHistory = sessionScalarState.getHasLoadedHistory(false),
			nextHistoryPageToken = sessionScalarState.getNextHistoryPageToken(false),
			latestObservedHistorySequenceId = sessionScalarState.getLatestObservedHistorySequenceId(false)
		}
	end

	local function saveActiveSessionToCache()
		local casSessionId = sessionScalarState.getCasSessionId(false)

		if
			casSessionId == nil
			or casSessionId == ""
			or not sessionScalarState.getHasLoadedHistory(false)
		then
			return
		end

		local v10 = snapshotActiveSession()

		if v10 ~= nil then
			sessionHistoryCache.save(casSessionId, v10)
		end
	end

	local function restoreSessionFromCache(p3): boolean
		local v10 = sessionHistoryCache.restore(p3)

		if v10 == nil then
			return false
		end

		loaded = v10.loadedBySequenceId
		overlay = v10.overlayBySequenceId
		sessionScalarState.setHasLoadedHistory(v10.hasLoadedHistory)
		sessionScalarState.setNextHistoryPageToken(v10.nextHistoryPageToken)
		sessionScalarState.setLatestObservedHistorySequenceId(v10.latestObservedHistorySequenceId)
		v9(buildMergedHistory())

		return true
	end

	local function clearActiveSessionState()
		loaded = {}
		overlay = {}
		sessionScalarState.setHasLoadedHistory(false)
		sessionScalarState.setNextHistoryPageToken(nil)
		sessionScalarState.setHistoryLoadInFlight(false)
		sessionScalarState.setLatestObservedHistorySequenceId(nil)
		v9(buildMergedHistory())
	end

	local function setCasSessionIdInternal(sessionId)
		if not (sessionId ~= "" and sessionScalarState.getCasSessionId(false) ~= sessionId) then
			return
		end

		count += 1

		if fFlagBuildExperienceModelPickerData then
			sessionScalarState.setModels(nil)
			sessionScalarState.setHasObservedModels(false)
		end

		local casSessionId = sessionScalarState.getCasSessionId(false)

		if casSessionId ~= nil and casSessionId ~= "" and sessionScalarState.getHasLoadedHistory(false) then
			local v10 = snapshotActiveSession()

			if v10 ~= nil then
				sessionHistoryCache.save(casSessionId, v10)
			end
		end

		sessionScalarState.setCasSessionId(sessionId)

		if fFlagBuildExperienceModelPickerData and experimentOverride.isEnabled() then
			experimentOverride.move(v7, experimentOverride.getKey(sessionId))
		end

		sessionScalarState.setHistoryLoadInFlight(false)
		local v10 = sessionHistoryCache.restore(sessionId)
		local flag

		if v10 == nil then
			flag = false
		else
			loaded = v10.loadedBySequenceId
			overlay = v10.overlayBySequenceId
			sessionScalarState.setHasLoadedHistory(v10.hasLoadedHistory)
			sessionScalarState.setNextHistoryPageToken(v10.nextHistoryPageToken)
			sessionScalarState.setLatestObservedHistorySequenceId(v10.latestObservedHistorySequenceId)
			v9(buildMergedHistory())
			flag = true
		end

		if flag then
			data.onCasSessionIdChanged(sessionId)
			return
		end

		clearActiveSessionState()
		data.onCasSessionIdChanged(sessionId)
	end

	local function mergeHistoryPage(p3, p4)
		sessionHistoryMerge.mergeHistoryIntoMap(loaded, p3, overlay)
		sessionScalarState.setNextHistoryPageToken(p4)
		sessionScalarState.noteHistorySequenceId(historyPageUtils.getMaxHistorySequenceId(p3))
		v9(buildMergedHistory())
	end

	local function ingestRealtimeUpdate(p3, p4)
		if sessionHistoryMerge.ingestOverlayUpdate(overlay, loaded, p3, p4) then
			sessionScalarState.noteHistorySequenceId(p4)
			v9(buildMergedHistory())
		end
	end

	local function awaitRequest(p3, p4, p5)
		local v10 = historyPageUtils.awaitRequestState(p3.state, p5 or os.clock() + rpcTimeoutSeconds, p4)

		if p4 ~= nil then
			p3.dispose()
		end

		return v10
	end

	local function publishModels(p3)
		local roblox = if p3 and p3._meta then p3._meta._roblox else nil
		local setModels = sessionScalarState.setModels
		local v10 = if roblox then roblox.models else nil
		setModels(v10)
		sessionScalarState.setHasObservedModels(true)
	end

	local function publishExperiment(p3, result)
		if not experimentOverride.isEnabled() then
			return
		end

		local key = experimentOverride.getKey(p3)

		if
			experimentOverride.isPending(key)
			or fFlagBuildExperienceModelPickerData and experimentOverride.hasInternalEdit(key)
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

		if not fFlagBuildExperienceModelPickerData then
			experiment = nil
		end

		hydrate(key, specVersion, experiment)
	end

	local function loadSession(casSessionId, p3, isCancelled, p4)
		local v10 = count
		count2 += 1
		local v11 = count2
		local function isStale()
			return isCancelled()
				or v10 ~= count
				or sessionScalarState.getCasSessionId(false) ~= casSessionId
		end

		if isCancelled() or v10 ~= count or sessionScalarState.getCasSessionId(false) ~= casSessionId then
			return { status = "pending" }
		end

		local sessionLoad = data.sessionLoad(casSessionId, { historyPageToken = p3 })
		local v12 = historyPageUtils.awaitRequestState(
			sessionLoad.state,
			p4 or os.clock() + rpcTimeoutSeconds,
			isStale
		)

		if isStale ~= nil then
			sessionLoad.dispose()
		end

		if isCancelled() or v10 ~= count or sessionScalarState.getCasSessionId(false) ~= casSessionId then
			return { status = "pending" }
		end

		if v12.status ~= "succeeded" or not (v6 < v11) then
			return v12
		end

		v6 = v11
		local result = v12.result
		local roblox = if result and result._meta then result._meta._roblox else nil
		local setModels = sessionScalarState.setModels
		local v13 = if roblox then roblox.models else nil
		setModels(v13)
		sessionScalarState.setHasObservedModels(true)

		publishExperiment(casSessionId, v12.result)

		return v12
	end

	local v10 = {
		deps = data,
		rpcTimeoutSeconds = rpcTimeoutSeconds,
		getCasSessionId = function()
			return sessionScalarState.getCasSessionId(false)
		end,
		getHistoryLoadInFlight = function()
			return sessionScalarState.getHistoryLoadInFlight(false)
		end,
		setHistoryLoadInFlight = sessionScalarState.setHistoryLoadInFlight,
		getNextHistoryPageToken = function()
			return sessionScalarState.getNextHistoryPageToken(false)
		end,
		setNextHistoryPageToken = sessionScalarState.setNextHistoryPageToken,
		getLoadedBySequenceId = function()
			return loaded
		end,
		setLoadedBySequenceId = function(p3)
			loaded = p3
		end,
		getOverlayBySequenceId = function()
			return overlay
		end,
		setOverlayBySequenceId = function(p3)
			overlay = p3
		end,
		buildMergedHistory = buildMergedHistory,
		mergeHistoryPage = mergeHistoryPage,
		noteHistorySequenceIds = function(p3)
			sessionScalarState.noteHistorySequenceId(historyPageUtils.getMaxHistorySequenceId(p3))
		end,
		notifyMergedHistoryChanged = notifySessionStateChanged,
		markHistoryLoaded = sessionScalarState.markHistoryLoaded,
		getRefreshGeneration = function()
			return count
		end,
		onInitialSessionLoad = publishExperiment
	}

	local createHistoryLoader = module10.createHistoryLoader
	local v11 = if fFlagBuildExperienceModelPickerData then loadSession else nil
	local historyLoader = createHistoryLoader(v10, v11)

	local createHistoryPolling = module12.createHistoryPolling
	local v13 = if fFlagBuildExperienceModelPickerData then loadSession else nil
	local historyPolling = createHistoryPolling({
		deps = data,
		rpcTimeoutSeconds = rpcTimeoutSeconds,
		getCasSessionId = function()
			return sessionScalarState.getCasSessionId(false)
		end,
		getNextHistoryPageToken = function()
			return sessionScalarState.getNextHistoryPageToken(false)
		end,
		mergeHistoryPage = mergeHistoryPage
	}, v13)

	local function ensureInitialized(callback)
		if sessionScalarState.getInitialized(false) then
			return true, nil, nil
		end

		local v14 = data.initialize({ protocolVersion = AcpProtocol.ProtocolVersion })
		local v15 = historyPageUtils.awaitRequestState(v14.state, os.clock() + rpcTimeoutSeconds, callback)

		if callback ~= nil then
			v14.dispose()
		end

		if callback ~= nil and callback() then
			return false, nil, nil
		end

		if v15.status == "succeeded" then
			sessionScalarState.setInitialized(true)
			return true, nil, nil
		end

		local v16 = false
		local errorCode = v15.errorCode

		if fFlagBuildExperiencePromptFailureTelemetry then
			return false, errorCode, (classifyRequestFailure(v15))
		end

		return v16, errorCode, nil
	end

	local function createCasSession(model, callback, p3, callback2)
		local v14 = count
		local function isStale()
			local v15 = not (v14 == count) or not (callback == nil) and callback()
			return v15
		end

		local v15 = if fFlagBuildExperienceModelPickerData and p3 ~= nil then p3.experiment else v8

		local casSessionId = sessionScalarState.getCasSessionId(false)

		if casSessionId ~= nil and not fFlagBuildExperienceModelPickerData then
			return casSessionId, nil
		end

		if casSessionId == nil and (universeId == nil or placeId == nil) then
			return nil, { stage = "missing_project" }
		end

		local v17 = if fFlagBuildExperienceModelPickerData then isStale else callback
		local v18, v19, v20 = ensureInitialized(v17)

		if fFlagBuildExperienceModelPickerData then
			local v21 = not (v14 == count) or not (callback == nil) and callback()

			if v21 then
				return nil, nil
			end
		end

		if v18 then
			if casSessionId ~= nil then
				return casSessionId, nil
			end

			if callback2 ~= nil and callback2() then
				return nil, nil
			end

			local sessionNew = data.sessionNew
			local v21 = {
				project = { universeId = universeId, placeId = placeId },
				experiment = if fFlagBuildExperienceModelPickerData then v15 else v8,
				model = 0,
				application = "build"
			}

			if not fFlagBuildExperienceModelPickerData then
				model = nil
			end

			v21.model = model
			local v23 = sessionNew(v21)

			if not fFlagBuildExperienceModelPickerData then
				isStale = callback
			end

			local v24 = historyPageUtils.awaitRequestState(v23.state, os.clock() + rpcTimeoutSeconds, isStale)

			if isStale ~= nil then
				v23.dispose()
			end

			if fFlagBuildExperienceModelPickerData then
				local v25 = not (v14 == count) or not (callback == nil) and callback()

				if v25 then
					return nil, nil
				end
			end

			if v24.status == "succeeded" then
				local result = v24.result
				local sessionId = if typeof(result) == "table" then result.sessionId else nil

				if typeof(sessionId) ~= "string" or sessionId == "" then
					return nil, { stage = "session_new" }
				end

				if experimentOverride.isEnabled() then
					local key = experimentOverride.getKey(sessionId)

					if not fFlagBuildExperienceModelPickerData then
						v15 = v8
					end

					if experimentOverride.has(v7) then
						experimentOverride.move(v7, key)
					elseif v15 ~= nil then
						experimentOverride.hydrate(key, v15.specVersion)
					end

					if
						not fFlagBuildExperienceModelPickerData
						or p3 == nil
						or sendConfiguration.sameExperiment(experimentOverride.getPromptExperiment(key), v15)
					then
						experimentOverride.consumePending(key)
					end
				end

				setCasSessionIdInternal(sessionId)

				if not fFlagBuildExperienceModelPickerData then
					return sessionId, nil
				end

				if sessionScalarState.getCasSessionId(false) ~= sessionId then
					return nil, nil
				end

				local roblox = if result and result._meta then result._meta._roblox else nil
				local setModels = sessionScalarState.setModels
				local v25 = if roblox then roblox.models else nil
				setModels(v25)
				sessionScalarState.setHasObservedModels(true)

				return sessionId, nil
			else
				local v25, v26

				if fFlagBuildExperienceModelPickerData then
					v25, v26 = getFundingError(v24)
				end

				local v29 = if fFlagBuildExperienceModelPickerData then v24.error else nil
				local v28 = {
					stage = "session_new",
					message = v29,
					errorCode = v24.errorCode,
					fundingReason = v25,
					fundingDetails = v26,
					requestFailure = 0
				}

				local v30 = if fFlagBuildExperiencePromptFailureTelemetry then classifyRequestFailure(v24) else nil
				v28.requestFailure = v30
				return nil, v28
			end
		else
			if not fFlagBuildExperiencePromptFailureTelemetry then
				v20 = nil
			end

			return nil, { stage = "initialize", errorCode = v19, requestFailure = v20 }
		end
	end

	local v14 = nil

	local function newSetup(p3, p4)
		local setup = {
			generation = count,
			model = p3,
			experiment = 0,
			abandoners = 0,
			persistent = false,
			committed = false,
			done = false
		}

		local v15 = if p4 == nil then v8 else p4.experiment
		setup.experiment = v15
		setup.abandoners = {}
		return setup
	end

	local function canAbandon(p3): boolean
		if p3.persistent then
			return false
		end

		for k in p3.abandoners do
			if not k() then
				return false
			end
		end

		return true
	end

	local function isReplaceable(data2)
		local v15 = not (data2.committed or data2.done)

		if not v15 then
			return v15
		end

		if data2.persistent then
			return false
		end

		for k in data2.abandoners do
			if not k() then
				return false
			end
		end

		v15 = true
		return true
	end

	local function ensureCasSession(p3, isCancelled, p4, p5)
		if
			not fFlagBuildExperienceModelPickerData
			or sessionScalarState.getCasSessionId(false) ~= nil and sessionScalarState.getInitialized(false)
		then
			return createCasSession(p3, isCancelled, p4)
		end

		local function callerCancelled()
			return isCancelled ~= nil and isCancelled()
		end
		local v15 = not (isCancelled == nil) and isCancelled()

		if v15 then
			return nil, nil
		end

		local v16 = v14
		local v17 = v16 == nil or v16.generation ~= count

		if v17 then
			v16 = newSetup(p3, p4)
			v14 = v16
		end

		local v18

		if sessionScalarState.getCasSessionId(false) == nil and v16.model ~= nil and p3 ~= nil then
			v18 = p3 ~= v16.model
		else
			v18 = false
		end

		local v19

		if sessionScalarState.getCasSessionId(false) == nil and p4 ~= nil then
			v19 = v16.model ~= p4.tier or not sendConfiguration.sameExperiment(v16.experiment, p4.experiment)
		else
			v19 = false
		end

		local v20, v21

		if v17 or not (v18 or v19) then
			if v18 then
				return
					nil,
					{
						stage = "session_new",
						message = "session creation already started with a different model"
					}
			end

			if v19 then
				return
					nil,
					{
						stage = "session_new",
						message = "session creation already started with a different send configuration"
					}
			end

			if p5 and isCancelled ~= nil then
				v16.abandoners[callerCancelled] = true
			else
				v16.persistent = true
			end

			if v17 then
				task.spawn(function()
					local success, result, v23 = pcall(createCasSession, p3, nil, p4, function(): boolean
						local v24 = v16
						local flag

						if v24.persistent then
							flag = false
						else
							local flag2 = true

							for k in v24.abandoners do
								if not k() then
									flag = false
									flag2 = false
									break
								end
							end

							if flag2 then
								flag = true
							end
						end

						if flag then
							return true
						end

						v16.committed = true
						return false
					end)

					v16.sessionId = if success then result else nil
					v16.error = not success and {
						stage = "session_new",
						message = tostring(result)
					} or v23
					v16.done = true

					if v14 == v16 then
						v14 = nil
					end
				end)
			end

			while not v16.done do
				v20 = not (isCancelled == nil) and isCancelled()

				if v20 then
					break
				end

				task.wait()
			end

			v21 = not (isCancelled == nil) and isCancelled()

			if
				v21
				or v16.sessionId ~= nil and v16.sessionId ~= sessionScalarState.getCasSessionId(false)
			then
				return nil, nil
			end

			return v16.sessionId, v16.error
		else
			local v22 = not v16.committed

			if v22 then
				v22 = not v16.done

				if v22 then
					if v16.persistent then
						v22 = false
					else
						local flag = true

						for k in v16.abandoners do
							if not k() then
								v22 = false
								flag = false
								break
							end
						end

						if flag then
							v22 = true
						end
					end
				end
			end

			if v22 then
				v17 = true
				v16 = newSetup(p3, p4)
				v14 = v16
			else
				if v18 then
					return
						nil,
						{
							stage = "session_new",
							message = "session creation already started with a different model"
						}
				end

				if v19 then
					return
						nil,
						{
							stage = "session_new",
							message = "session creation already started with a different send configuration"
						}
				end
			end

			if p5 and isCancelled ~= nil then
				v16.abandoners[callerCancelled] = true
			else
				v16.persistent = true
			end

			if v17 then
				task.spawn(function()
					local success, result, v23 = pcall(createCasSession, p3, nil, p4, function(): boolean
						local v24 = v16
						local flag

						if v24.persistent then
							flag = false
						else
							local flag2 = true

							for k in v24.abandoners do
								if not k() then
									flag = false
									flag2 = false
									break
								end
							end

							if flag2 then
								flag = true
							end
						end

						if flag then
							return true
						end

						v16.committed = true
						return false
					end)

					v16.sessionId = if success then result else nil
					v16.error = not success and {
						stage = "session_new",
						message = tostring(result)
					} or v23
					v16.done = true

					if v14 == v16 then
						v14 = nil
					end
				end)
			end

			while not v16.done do
				v20 = not (isCancelled == nil) and isCancelled()

				if v20 then
					break
				end

				task.wait()
			end

			v21 = not (isCancelled == nil) and isCancelled()

			if
				v21
				or v16.sessionId ~= nil and v16.sessionId ~= sessionScalarState.getCasSessionId(false)
			then
				return nil, nil
			end

			return v16.sessionId, v16.error
		end
	end

	local function prepareSession(data2)
		local v15

		if not (data2 == nil or data2.sendConfiguration == nil) then
			v15 = sendConfiguration.capture(data2.sendConfiguration.tier, data2.sendConfiguration.experiment)
		end

		local v16

		if v15 == nil then
			if data2 ~= nil then
				v16 = data2.model
			end
		else
			v16 = v15.tier
		end

		assert(
			v15 == nil or data2 == nil or data2.model == nil or data2.model == v16,
			"conflicting model tiers"
		)

		local v17 = count
		local function isCancelled()
			local v18

			if v17 == count then
				v18 = not (data2 == nil or data2.isCancelled == nil) and data2.isCancelled()
			else
				v18 = true
			end

			return v18
		end

		local v18

		if v17 == count then
			v18 = not (data2 == nil or data2.isCancelled == nil) and data2.isCancelled()
		else
			v18 = true
		end

		if v18 then
			return nil, nil
		end

		if v15 == nil then
			v8 = if experimentOverride.isEnabled() then experimentOverride.getExperiment(experimentOverride.getKey(sessionScalarState.getCasSessionId(false)) or v7) else nil
		end

		local casSessionId = sessionScalarState.getCasSessionId(false)

		if casSessionId == nil then
			if v14 ~= nil and v14.generation == v17 and v16 ~= nil and v16 ~= v14.model then
				local v19 = v14
				local v20 = not v19.committed

				if v20 then
					v20 = not v19.done

					if v20 then
						if v19.persistent then
							v20 = false
						else
							local flag = true

							for k in v19.abandoners do
								if not k() then
									v20 = false
									flag = false
									break
								end
							end

							if flag then
								v20 = true
							end
						end
					end
				end

				if not v20 then
					return
						nil,
						{
							stage = "session_new",
							message = "session creation already started with a different model"
						}
				end
			end

			local v20 = if data2 ~= nil then data2.isCancelled else nil
			return ensureCasSession(v16, v20, v15, v15 ~= nil)
		else
			local casSession, v19 = ensureCasSession(nil, isCancelled, v15)
			local v20

			if v17 == count then
				v20 = not (data2 == nil or data2.isCancelled == nil) and data2.isCancelled()
			else
				v20 = true
			end

			if v20 then
				return nil, nil
			end

			if casSession == nil then
				return nil, v19
			end

			local v21 = loadSession(casSessionId, nil, isCancelled)
			local v22

			if v17 == count then
				v22 = not (data2 == nil or data2.isCancelled == nil) and data2.isCancelled()
			else
				v22 = true
			end

			if v22 then
				return nil, nil
			end

			if v21.status == "succeeded" then
				local sessionLoadHistory = historyPageUtils.getSessionLoadHistory(v21.result)
				sessionScalarState.noteHistorySequenceId(historyPageUtils.getMaxHistorySequenceId(sessionLoadHistory))

				return casSessionId, nil
			else
				local v23, v24

				if fFlagBuildExperienceModelPickerData then
					v23, v24 = getFundingError(v21)
				end

				local v26 = {
					stage = "session_load",
					message = v21.error,
					errorCode = v21.errorCode,
					fundingReason = v23,
					fundingDetails = v24,
					requestFailure = 0
				}

				local v27 = if fFlagBuildExperiencePromptFailureTelemetry then classifyRequestFailure(v21) else nil
				v26.requestFailure = v27
				return nil, v26
			end
		end
	end

	local sendPrompt = module13.createSendPrompt({
		ensureInitialized = ensureInitialized,
		ensureCasSession = ensureCasSession,
		getLatestObservedHistorySequenceId = function()
			return sessionScalarState.getLatestObservedHistorySequenceId(false)
		end,
		noteTurnSequenceIds = noteTurnSequenceIds,
		startPollingTurnFromHistory = historyPolling.startPollingTurnFromHistory,
		getAssistantTurnSequence = function()
			return sessionScalarState.getAssistantTurnSequence(false)
		end,
		incrementAssistantTurnSequence = sessionScalarState.incrementAssistantTurnSequence,
		sessionPrompt = function(data2, p3)
			local v15

			if fFlagBuildExperienceModelPickerData and p3 ~= nil then
				v15 = p3.experiment
			elseif experimentOverride.isEnabled() then
				v15 = experimentOverride.getPromptExperiment(experimentOverride.getKey(sessionScalarState.getCasSessionId(false)) or v7)
			else
				v15 = nil
			end

			local sessionPrompt = data.sessionPrompt
			local v16 = {
				sessionId = data2.sessionId,
				prompt = data2.prompt,
				model = 0,
				_meta = 0,
				experiment = 0
			}
			local v17 = if fFlagBuildExperienceModelPickerData then data2.model else nil
			v16.model = v17
			v16._meta = data2._meta
			v16.experiment = v15
			local v18 = sessionPrompt(v16)

			if fFlagBuildExperienceModelPickerData then
				local key = experimentOverride.getKey(data2.sessionId)

				if v15 == nil then
					return v18, nil
				end

				return v18, function()
					if
						(v18.isCurrentOwner == nil or v18.isCurrentOwner())
						and sendConfiguration.sameExperiment(experimentOverride.getPromptExperiment(key), v15)
					then
						experimentOverride.consumePending(key)
					end
				end
			end

			if v15 ~= nil then
				experimentOverride.consumePending(experimentOverride.getKey(sessionScalarState.getCasSessionId(false)) or v7)
			end

			return v18, nil
		end,
		setActiveStop = function(p3)
			v5 = p3
		end
	})

	local function stopActiveTurn()
		if v5 ~= nil then
			v5()
		end
	end

	local chatSession = {
		getModels = sessionScalarState.getModels,
		hasObservedModels = sessionScalarState.hasObservedModels,
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

	if not fFlagBuildExperienceModelPickerData then
		prepareSession = nil
	end

	chatSession.prepareSession = prepareSession
	chatSession.universeId = universeId
	chatSession.placeId = placeId
	function chatSession.getCasSessionId()
		return sessionScalarState.getCasSessionId(false)
	end

	chatSession.setCasSessionId = setCasSessionIdInternal
	function chatSession.setPendingExperimentKey(p3)
		v7 = p3

		if fFlagBuildExperienceModelPickerData and experimentOverride.isEnabled() then
			experimentOverride.move(p3, experimentOverride.getKey(sessionScalarState.getCasSessionId(false)))
		end
	end
	function chatSession.hasLoadedHistory()
		return sessionScalarState.getHasLoadedHistory(false)
	end

	chatSession.markHistoryLoaded = sessionScalarState.markHistoryLoaded
	function chatSession.getNextHistoryPageToken()
		return sessionScalarState.getNextHistoryPageToken(false)
	end

	chatSession.getMergedHistory = signal
	chatSession.ingestRealtimeUpdate = ingestRealtimeUpdate
	chatSession.mergeHistoryPage = mergeHistoryPage
	chatSession.refreshSession = historyLoader.refreshSession
	chatSession.loadOlderHistory = historyLoader.loadOlderHistory
	chatSession.requestOlderHistoryWhile = historyLoader.requestOlderHistoryWhile
	function chatSession.sendPrompt(p3)
		if not fFlagBuildExperienceModelPickerData or p3.sendConfiguration == nil then
			v8 = if experimentOverride.isEnabled() then experimentOverride.getExperiment(experimentOverride.getKey(sessionScalarState.getCasSessionId(false)) or v7) else nil
		end

		return sendPrompt.sendPrompt(p3)
	end

	chatSession.stopActiveTurn = stopActiveTurn

	function chatSession.submitActiveToolResult(p3, isError, p4, p5)
		local casSessionId = sessionScalarState.getCasSessionId(false)

		if casSessionId == nil then
			return nil
		end

		local submitToolResult = data.submitToolResult

		if isError == nil then
			isError = false
		end

		return submitToolResult({
			sessionId = casSessionId,
			turnId = p4,
			referenceId = p5,
			content = p3,
			isError = isError
		})
	end

	function chatSession.getActiveTurnHandle()
		local casSessionId = sessionScalarState.getCasSessionId(false)

		if casSessionId == nil then
			return nil
		end

		return data.getActiveTurnHandle(casSessionId)
	end
	function chatSession.startPollingActiveTurn(p3)
		local casSessionId = sessionScalarState.getCasSessionId(false)

		if casSessionId == nil then
			return function() end
		end

		return historyPolling.startPollingActiveTurn(casSessionId, p3)
	end

	return chatSession
end

return createChatSession
