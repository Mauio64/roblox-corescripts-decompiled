local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent
local FFlagBuildExperienceModelPicker = require(BuildExperience.Flags.FFlagBuildExperienceModelPicker)
local FFlagBuildExperienceChatOpenId = require(BuildExperience.Flags.FFlagBuildExperienceChatOpenId)
local engineFeature = game:GetEngineFeature("BuildAppStorageKey")

local FFlagBuildExperiencePrefillSkipsDraftPersist = require(BuildExperience.Flags.FFlagBuildExperiencePrefillSkipsDraftPersist)

local MessageBusService = game:GetService("MessageBusService")
local AppLifecycleObserverService = game:GetService("AppLifecycleObserverService")

local CreatorAgentChat = require(parent.DataHydration.CreatorAgentChat)
local UniverseConfiguration = require(parent.DataHydration.UniverseConfiguration)
local UniverseCreate = require(parent.DataHydration.UniverseCreate)
local React = require(parent.React)
local ReactUtils = require(parent.ReactUtils)
local SharedFlags = require(parent.SharedFlags)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)
local Localization = require(parent.Localization)
local LocalizationRoactContext = Localization.LocalizationRoactContext
local LocalizationStrings = require(BuildExperience.LocalizationStrings)

local FFlagBuildExperienceChatAccordionScrollAnchor = require(BuildExperience.Flags.FFlagBuildExperienceChatAccordionScrollAnchor)
local FFlagBuildExperienceManageDevProduct = require(BuildExperience.Flags.FFlagBuildExperienceManageDevProduct)
local FFlagBuildAdUpsell = require(BuildExperience.Flags.FFlagBuildAdUpsell)
local FFlagBuildExperienceLibrary = SharedFlags.FFlagBuildExperienceLibrary
local FFlagBuildExperiencePromptFailureTelemetry = SharedFlags.FFlagBuildExperiencePromptFailureTelemetry
local FFlagBuildExperienceNewGameChatDraft = require(BuildExperience.Flags.FFlagBuildExperienceNewGameChatDraft)
local FFlagBuildExperienceRestoreStoppedPrompt = require(BuildExperience.Flags.FFlagBuildExperienceRestoreStoppedPrompt)

local chatConstants = require(script.Parent.chatConstants)
local chatTypes = require(script.Parent.chatTypes)
local creatorAgentChat = require(script.Parent.creatorAgentChat)
local getNewGameChatDraftKey = require(script.Parent.getNewGameChatDraftKey)
local parseSessionStream = require(script.Parent.parseSessionStream)
local FFlagBuildExperienceAnswerForm = require(BuildExperience.Flags.FFlagBuildExperienceAnswerForm)
local getActiveAnswerForm

if FFlagBuildExperienceAnswerForm then
	getActiveAnswerForm = require(script.Parent.getActiveAnswerForm)
else
	getActiveAnswerForm = nil
end

local sessionPromptMessageFilter = require(script.Parent.sessionPromptMessageFilter)
local useAgentRollbackRequest = require(script.Parent.useAgentRollbackRequest)
local useChatScroll = require(script.Parent.useChatScroll)
local buildAgentRollbackPrompt = require(BuildExperience.utils.buildAgentRollbackPrompt)
local beginBuildModelSend = require(script.Parent.beginBuildModelSend)
local useBuildModelSession = require(script.Parent.useBuildModelSession)
require(BuildExperience.Components.ModelPicker.ModelPickerTypes)
local GetBuildCreatorCreditRefreshStore = require(BuildExperience.Stores.GetBuildCreatorCreditRefreshStore)
local LocalUserIdStore = require(parent.LocalUserIdStore)
local localUserIdStore = LocalUserIdStore.LocalUserIdStore
local CreatorCredit = require(parent.DataHydration.CreatorCredit)
local GetBuildModelSelectionStore = require(BuildExperience.Stores.GetBuildModelSelectionStore)
local GetAgentRollbackRequestStore = require(BuildExperience.Stores.GetAgentRollbackRequestStore)
local GetPlaytestLoadingStore = require(parent.BuildExperiencePlaytestLaunch.GetPlaytestLoadingStore)
require(parent.BuildExperiencePlaytestLaunch.createPlaytestLoadingStore)
local getDefaultTemplatePlaceId = require(BuildExperience.utils.getDefaultTemplatePlaceId)
local launchPlaytestWithLoadingState = require(parent.BuildExperiencePlaytestLaunch.launchPlaytestWithLoadingState)
local enabled = CreatorAgentChat.experimentOverride.isEnabled()
local useBuildInternalTesting

if FFlagBuildExperienceModelPicker and enabled then
	useBuildInternalTesting = require(script.Parent.useBuildInternalTesting)
else
	useBuildInternalTesting = nil
end

local BuildAppStorage

if engineFeature then
	BuildAppStorage = require(BuildExperience.Storage.BuildAppStorage)
else
	BuildAppStorage = nil
end

local uploadCaptureAsync = require(BuildExperience.utils.uploadCaptureAsync)

local Debug = CreatorAgentChat.debug
local RequestFailureKind = CreatorAgentChat.RequestFailureKind
local sendBuildExperienceEvent = require(BuildExperience.Telemetry.sendBuildExperienceEvent)
local signal = Signals.createSignal(false)
local function noopSetAgentSpecVersion(_: string?) end

local _ = { CreateUniverse = "create_universe", ConfigureUniverse = "configure_universe" }

local messageId = MessageBusService:GetMessageId("Game", "onGameLeave")
local signal2 = Signals.createSignal({
	submittedToolCallIds = {},
	askUserByToolCallId = {},
	planByToolCallId = {},
	devProductByToolCallId = {}
})
local signal3 = Signals.createSignal({
	onAnswerSelectedByToolCallId = {},
	onAnswerConfirmedByToolCallId = {},
	onPlanAcceptedByToolCallId = {},
	onDevProductApprovedByToolCallId = {},
	onDevProductRejectedByToolCallId = {}
})
local signal4 = Signals.createSignal(nil)
local signal5 = Signals.createSignal({ session = nil, sessionId = nil, events = {} })

local function sessionOwnerMatches(p, p2, p3: string?): boolean
	if p == nil or p.session ~= p2 then
		return false
	end

	if p3 == nil or p3 == "" then
		return true
	end

	if p.sessionId == p3 then
		return true
	elseif p.sessionId == nil then
		return p.session.getCasSessionId() == p3
	else
		return false
	end
end

local function isEvolvingAdUpsellScope(p, p2: number?, p3: string?) -- 1 equivalent call inferred from this helper
	local v = p.universeId == nil or p2 == nil or p.universeId == p2
	local v2 = p.sessionId == nil or p3 == nil or p.sessionId == p3
	return v and v2
end

local function getCompletedTurnSequenceId(message) -- 1 equivalent call inferred from this helper
	if
		message.kind == "assistant_turn"
		and message.isDone
		and message.isOptimisticallyCancelled ~= true
		and message.turnState ~= nil
	then
		return message.endSequenceId or message.startSequenceId
	end

	return nil
end

local function getTurnId(item) -- 1 equivalent call inferred from this helper
	local turnFeedbackIds = item.turnFeedbackIds

	if turnFeedbackIds == nil or typeof(turnFeedbackIds) == "function" then
		return nil
	end

	return turnFeedbackIds.turnId
end

local function noteLiveAdUpsellTurns(data, messages)
	for _, item in messages do
		if not (item.kind == "assistant_turn" and item.startSequenceId ~= nil) then
			continue
		end

		local turnId = getTurnId(item) -- inferred equivalent call
		local v

		if turnId == nil then
			v = false
		else
			v = data.liveTurnIds[turnId] == true
		end

		local historyWatermarkSequenceId = data.historyWatermarkSequenceId
		local v2 = not item.isDone

		if v2 then
			if historyWatermarkSequenceId == nil then
				v2 = false
			else
				v2 = historyWatermarkSequenceId < item.startSequenceId
			end
		end

		if v or v2 then
			data.liveTurnStartSequenceIds[item.startSequenceId] = true
		end
	end
end

local function hasPendingLocalToolResponse(data): boolean
	for k in data.askUserByToolCallId do
		if not data.submittedToolCallIds[k] then
			return true
		end
	end

	for k in data.planByToolCallId do
		if not data.submittedToolCallIds[k] then
			return true
		end
	end

	if FFlagBuildExperienceManageDevProduct then
		for k in data.devProductByToolCallId do
			if not data.submittedToolCallIds[k] then
				return true
			end
		end
	end

	return false
end

local function trimMessage(current: string) -- 1 equivalent call inferred from this helper
	return string.gsub(current, "^%s*(.-)%s*$", "%1")
end

local function scheduleComposerAutoFocus(ref, fn) -- 1 equivalent call inferred from this helper
	local v = 8
	local function tryFocus()
		if fn() then
			return
		end

		local current = ref.current

		if current then
			current.focus()
			return
		end

		v -= 1

		if v > 0 then
			task.delay(0, tryFocus)
		end
	end
	task.defer(tryFocus)
end

local function getResumeSessionKey(data) -- 1 equivalent call inferred from this helper
	local casSessionId = data.getCasSessionId()

	if typeof(casSessionId) == "string" and casSessionId ~= "" then
		return casSessionId
	end

	local universeId = data.universeId
	local placeId = data.placeId

	if universeId == nil or placeId == nil then
		return nil
	end

	return `{universeId}:{placeId}`
end

local function getLiveAssistantMessage(p, createUniverseOnFirstPrompt: boolean?, p2, state, setupErrorText: string?) -- 1 equivalent call inferred from this helper
	local v

	if createUniverseOnFirstPrompt == true and p2 == nil then
		v = state ~= nil
	else
		v = false
	end

	if p == nil and not v then
		return nil
	end

	return { setupErrorText = setupErrorText }
end

local function useChatSessionCore(data)
	if FFlagBuildExperienceModelPicker then
		React.useEffect(function()
			return GetBuildCreatorCreditRefreshStore(false).acquire()
		end, {})
	end

	local v = React.useContext(LocalizationRoactContext)
	local formatted = v:Format(LocalizationStrings.CHAT_CREATE_UNIVERSE_ERROR)
	local formatted2 = v:Format(LocalizationStrings.CHAT_CAPTURE_UPLOAD_ERROR)
	local accountId

	if FFlagBuildExperienceModelPicker then
		accountId = SignalsReact.useSignalState(localUserIdStore.getCurrentUserId)
	else
		accountId = nil
	end

	local state, setState = React.useState(nil)
	local state2, setState2 = React.useState(nil)

	if FFlagBuildExperienceModelPicker and state ~= nil and state.accountId ~= accountId then
		state = nil
	end

	if FFlagBuildExperienceModelPicker and state2 ~= nil and state2.accountId ~= accountId then
		state2 = nil
	end

	local ref = React.useRef(true)
	local v2 = React.useCallback(function()
		return ref.current
	end, { ref })
	local placeId = data.placeId
	local universeId = data.universeId
	local sessionId = data.sessionId

	if state ~= nil then
		placeId = state.placeId
		universeId = state.universeId
		sessionId = state.sessionId
	end

	if
		(sessionId == nil or sessionId == "")
		and state2 ~= nil
		and state2.universeId == universeId
		and state2.placeId == placeId
	then
		sessionId = state2.sessionId
	end

	local v3 = data.hydrateHistoryWhen == nil or data.hydrateHistoryWhen
	local v4 = data.sendMessageWhen == nil or data.sendMessageWhen
	local v5 = FFlagBuildExperienceLibrary and data.isLibraryChat == true
	local v6

	if FFlagBuildAdUpsell then
		v6 = React.useRef(data.trackAdUpsellTurns == true).current
	else
		v6 = false
	end

	local creatorAgentChatStore = CreatorAgentChat.getCreatorAgentChatStore()
	local agentRollbackRequestStore = GetAgentRollbackRequestStore()

	local v7 = React.useMemo(function()
		if universeId == nil then
			return nil
		end

		return creatorAgentChatStore.getSessionForProject(universeId, placeId, sessionId)
	end, { universeId, placeId, sessionId, creatorAgentChatStore, accountId })

	React.useLayoutEffect(function()
		if v7 == nil or sessionId == nil or sessionId == "" then
			return
		end

		v7.setCasSessionId(sessionId)
	end, { v7, sessionId })
	local v8, state3, setState3, v9

	if FFlagBuildExperienceModelPicker then
		local ref2 = React.useRef(true)

		React.useLayoutEffect(function()
			ref2.current = true
			return function()
				ref2.current = false
			end
		end, { ref2 })

		v8 = React.useMemo(function()
			return { pending = false, mounted = true }
		end, {
			accountId,
			data.modelSelectionDraftId,
			data.universeId,
			data.placeId,
			data.sessionId
		})

		state3, setState3 = React.useState(false)
		local v10 = v8
		local v11 = setState3

		React.useLayoutEffect(function()
			v10.mounted = true
			v11(false)
			return function()
				v10.mounted = false
			end
		end, { v10, v11 })
		v9 = ref2
	else
		v9 = nil
		v8 = nil
		setState3 = nil
		state3 = false
	end

	local v10

	if FFlagBuildExperienceModelPicker then
		v10 = useBuildModelSession(universeId, data.modelSelectionDraftId, v7)
	else
		v10 = nil
	end

	local v11 = React.useMemo(function()
		if v7 == nil then
			return signal5
		end

		return (Signals.createComputed(function(p)
			return {
				session = v7,
				sessionId = v7.getCasSessionId(),
				events = v7.getMergedHistory(p)
			}
		end))
	end, { v7 })
	local v12 = SignalsReact.useSignalState(v11)
	local v13

	if v7 == nil then
		v13 = nil
	else
		v13 = v7.getCasSessionId()
	end

	local agentSpecVersion = nil
	local setAgentSpecVersion = noopSetAgentSpecVersion
	local v14 = nil
	local v15 = nil
	local internalTesting = nil

	if FFlagBuildExperienceModelPicker and enabled then
		local entry

		if v10 ~= nil then
			entry = v10.entry
		end

		local v16
		v16, v14 = useBuildInternalTesting(entry, v7, data.sessionId)
		internalTesting = v16

		if internalTesting ~= nil then
			agentSpecVersion = internalTesting.previewHash
		end

		setAgentSpecVersion = function(p: string?)
			if internalTesting ~= nil then
				internalTesting.onSelect()
				internalTesting.onSaveSpec(p, internalTesting.previewSpecName)
			end
		end
	elseif enabled then
		local ref2 = React.useRef(nil)

		if ref2.current == nil then
			ref2.current = CreatorAgentChat.experimentOverride.createPendingKey()
		end

		local current = ref2.current

		local ref3 = React.useRef(false)

		local v16 = CreatorAgentChat.experimentOverride.getKey(v13) or current

		local v17 = React.useMemo(function()
			return CreatorAgentChat.experimentOverride.getStateSignal(v16)
		end, { v16 })

		agentSpecVersion = SignalsReact.useSignalState(v17).specVersion

		setAgentSpecVersion = React.useCallback(function(p: string?)
			local v18

			if v7 ~= nil then
				v18 = v7.getCasSessionId()
			end

			local v19 = CreatorAgentChat.experimentOverride.getKey(v18)

			if v19 == nil then
				v19 = current
				ref3.current = true

				if v7 ~= nil then
					v7.setPendingExperimentKey(current)
				end
			end

			CreatorAgentChat.experimentOverride.set(v19, p)
		end, { v7, current })

		React.useEffect(function()
			if v7 == nil or not ref3.current then
				return
			end

			v7.setPendingExperimentKey(current)
		end, { v7, current })

		React.useEffect(function()
			return function()
				CreatorAgentChat.experimentOverride.clear(current)
			end
		end, { current })
		v15 = ref3
		v14 = current
	end

	local v16 = (v12.session ~= v7 or v12.sessionId ~= v13) and {} or v12.events
	local v17

	if sessionId == nil then
		v17 = false
	else
		v17 = sessionId ~= ""
	end

	if not v17 then
		if universeId == nil then
			v17 = false
		else
			v17 = universeId ~= 0
		end
	end

	local isLoading

	if v3 then
		if v7 == nil then
			isLoading = false
		elseif v17 then
			isLoading = not (v7.hasLoadedHistory() and #v16 > 0)
		else
			isLoading = v17
		end
	else
		isLoading = v3
	end

	local state4, setState4 = React.useState(function()
		return {
			session = v7,
			sessionId = sessionId,
			universeId = universeId,
			hydrateHistoryWhen = v3,
			isLoading = isLoading
		}
	end)
	local v18

	if state4 == nil or state4.session ~= v7 or state4.sessionId ~= sessionId or state4.universeId ~= universeId then
		v18 = false
	else
		v18 = state4.hydrateHistoryWhen == v3
	end

	local isHistoryHydrationComplete

	if v18 then
		isHistoryHydrationComplete = not state4.isLoading
	else
		isHistoryHydrationComplete = not isLoading
	end

	local isHistoryLoading = not isHistoryHydrationComplete

	if not isHistoryLoading then
		if v7 == nil then
			isHistoryLoading = false
		else
			isHistoryLoading = v7.getNextHistoryPageToken() ~= nil
		end
	end

	local state5, setState5 = React.useState(nil)

	local state6, setState6 = React.useState(nil)

	React.useEffect(function()
		setState6(nil)
	end, { v7, sessionId })
	local v19 = sessionId
	local v20

	if state6 == nil or state6.session ~= v7 then
		v20 = false
	elseif v19 == nil or v19 == "" or state6.sessionId == v19 then
		v20 = true
	elseif state6.sessionId == nil then
		v20 = state6.session.getCasSessionId() == v19
	else
		v20 = false
	end

	if not v20 then
		state6 = nil
	end

	local state7, setState7 = React.useState(nil)
	local ref2 = React.useRef(nil)
	local ref3 = React.useRef(nil)
	local ref4 = React.useRef(0)
	local ref5, state8, setState8

	if FFlagBuildExperienceModelPicker then
		ref5 = React.useRef(nil)

		state8, setState8 = React.useState(false)
		local v21 = ref5
		local v22 = setState8

		local useLayoutEffect = React.useLayoutEffect
		local function fn()
			if
				enabled
				and v21.current ~= nil
				and not v21.current.started
				and ref3.current ~= nil
				and data.sessionId ~= nil
				and data.sessionId ~= ""
				and ref3.current.sessionId ~= data.sessionId
			then
				v21.current.attempt.release()
				v21.current = nil
			end

			if v21.current == nil then
				v22(false)
				setState5(nil)
			end

			return function()
				local current = v21.current

				if current ~= nil and not (current.started and current.attempt.isCurrent()) then
					current.attempt.release()
					v21.current = nil

					if current.onTerminal ~= nil then
						current.onTerminal()
					end
				end
			end
		end

		local v23

		if v10 ~= nil then
			v23 = v10.entry
		end

		useLayoutEffect(fn, { v23, data.sessionId, v22, setState5 })
	else
		ref5 = nil
		setState8 = nil
		state8 = false
	end

	local ref6 = React.useRef(nil)

	local v21 = React.useCallback(function(current, session)
		assert(current == nil or session ~= nil, "Active turns require an owning session")
		ref2.current = current
		ref3.current = current ~= nil and {
			session = session,
			sessionId = session.getCasSessionId()
		} or nil

		setState7(current)
	end, { setState7 })

	local current = ref3.current
	local v22 = sessionId
	local v23

	if current == nil or current.session ~= v7 then
		v23 = false
	elseif v22 == nil or v22 == "" or current.sessionId == v22 then
		v23 = true
	elseif current.sessionId == nil then
		v23 = current.session.getCasSessionId() == v22
	else
		v23 = false
	end

	local v24

	if v23 then
		v24 = state7
	else
		v24 = nil
	end

	local v25

	if v24 == nil then
		v25 = signal2
	else
		v25 = v24.getOptimisticLocalTools
	end

	local v26 = if v24 == nil then signal3 else v24.getLocalToolActions

	local v27 = if v24 == nil then signal4 else v24.getSetupErrorText

	local optimisticLocalTools = SignalsReact.useSignalState(v25)
	local v28 = SignalsReact.useSignalState(v26)
	local v29 = SignalsReact.useSignalState(v27)

	if v29 ~= nil then
		v29 = v:Format(v29)
	end

	local liveAssistantMessage = React.useMemo(function()
		return getLiveAssistantMessage(v24, data.createUniverseOnFirstPrompt, v7, state5, v29) -- inferred equivalent call
	end, { v24, data.createUniverseOnFirstPrompt, state5, v7, v29 })

	local v30 = React.useMemo(function()
		local sessionId2

		if v7 == nil then
			sessionId2 = sessionId
		else
			sessionId2 = v7.getCasSessionId() or sessionId
		end

		local universeId2

		if v7 == nil then
			universeId2 = universeId
		else
			universeId2 = v7.universeId
		end

		local placeId2 = if v7 == nil then placeId else v7.placeId
		local v30 = {
			sessionId = sessionId2,
			universeId = universeId2,
			placeId = placeId2,
			optimisticLocalTools = optimisticLocalTools,
			pendingUserMessage = 0,
			pendingUserImages = 0,
			pendingUserResourceAttachments = 0,
			pendingUserMessageAfterSequenceId = 0,
			liveAssistantMessage = 0,
			optimisticCancelledStartSequenceId = 0
		}
		local pendingUserMessage

		if not (state5 == nil or not sessionPromptMessageFilter.shouldOptimisticallyDisplay(state5.text)) then
			pendingUserMessage = state5.text
		end

		v30.pendingUserMessage = pendingUserMessage
		local pendingUserImages

		if not (state5 == nil or not sessionPromptMessageFilter.shouldOptimisticallyDisplay(state5.text)) then
			pendingUserImages = state5.images
		end

		v30.pendingUserImages = pendingUserImages
		local pendingUserResourceAttachments

		if not (state5 == nil or not sessionPromptMessageFilter.shouldOptimisticallyDisplay(state5.text)) then
			pendingUserResourceAttachments = state5.resourceAttachments
		end

		v30.pendingUserResourceAttachments = pendingUserResourceAttachments
		local pendingUserMessageAfterSequenceId

		if state5 ~= nil then
			pendingUserMessageAfterSequenceId = state5.afterSequenceId
		end

		v30.pendingUserMessageAfterSequenceId = pendingUserMessageAfterSequenceId

		v30.liveAssistantMessage = liveAssistantMessage
		local optimisticCancelledStartSequenceId

		if state6 ~= nil then
			optimisticCancelledStartSequenceId = state6.startSequenceId
		end

		v30.optimisticCancelledStartSequenceId = optimisticCancelledStartSequenceId
		return parseSessionStream(v16, v30)
	end, {
		v16,
		v7,
		sessionId,
		universeId,
		placeId,
		optimisticLocalTools,
		state5,
		liveAssistantMessage,
		state6
	})
	local v31

	if v6 then
		local useRef = React.useRef
		local v32 = {
			isInitialized = false,
			universeId = universeId,
			sessionId = 0,
			historyWatermarkSequenceId = 0,
			lastProcessedSequenceId = nil,
			liveTurnIds = 0,
			liveTurnStartSequenceIds = 0
		}
		local sessionId2

		if v7 == nil then
			sessionId2 = sessionId
		else
			sessionId2 = v7.getCasSessionId() or sessionId
		end

		v32.sessionId = sessionId2
		v32.historyWatermarkSequenceId = v30.latestSequenceId

		v32.liveTurnIds = {}
		v32.liveTurnStartSequenceIds = {}
		v31 = useRef(v32)
	else
		v31 = nil
	end

	local v32

	if v31 == nil then
		v32 = nil
	else
		v32 = React.useCallback(function(p: number?)
			if p ~= nil then
				v31.current.liveTurnIds[p] = true
			end
		end, { v31 })
	end

	local messages = v30.messages
	local v43

	if v7 == nil then
		v43 = false
	else
		v43 = v7.getNextHistoryPageToken() ~= nil
	end

	local v44 = v7 == nil or (not v17 or v7.hasLoadedHistory())

	local v45 = isHistoryHydrationComplete and v44 and (v7 == nil or #messages > 0 or not v43)

	local subagentTaskState = v30.subagentTaskState
	local includesPublishTool = v30.includesPublishTool
	local message = messages[#messages]
	local v47 = React.useMemo(function()
		if placeId == nil then
			return signal
		end

		return agentRollbackRequestStore.getIsPendingForPlaceId(placeId)
	end, { placeId, agentRollbackRequestStore })

	local v48 = SignalsReact.useSignalState(v47)
	local isAssistantResponding

	if v24 == nil then
		if message == nil or message.kind ~= "assistant_turn" then
			isAssistantResponding = v48
		else
			isAssistantResponding = not message.isDone or v48
		end
	else
		isAssistantResponding = true
	end

	local canSendWhileResponding = isAssistantResponding
		and not v48
		and hasPendingLocalToolResponse(optimisticLocalTools)

	local activeTurnState = v30.activeTurnState
	React.useEffect(function()
		if v24 == nil or activeTurnState == nil then
			return
		end

		v24.syncFromTurnState(activeTurnState)
	end, { v24, activeTurnState })

	if v6 then
		React.useEffect(function()
			local onAssistantTurnCompleted = data.onAssistantTurnCompleted

			local v51 = v31
			local universeId2

			if v7 == nil then
				universeId2 = universeId
			else
				universeId2 = v7.universeId or universeId
			end

			local sessionId2

			if v7 == nil then
				sessionId2 = sessionId
			else
				sessionId2 = v7.getCasSessionId() or sessionId
			end

			local current2 = v51.current

			if isEvolvingAdUpsellScope(current2, universeId2, sessionId2) then -- inferred equivalent call
				current2.universeId = universeId2 or current2.universeId
				current2.sessionId = sessionId2 or current2.sessionId
			else
				current2 = {
					isInitialized = false,
					universeId = universeId2,
					sessionId = sessionId2,
					historyWatermarkSequenceId = v30.latestSequenceId,
					lastProcessedSequenceId = nil,
					liveTurnIds = {},
					liveTurnStartSequenceIds = {}
				}

				v51.current = current2
			end

			if v45 then
				if not current2.isInitialized then
					current2.isInitialized = true
					noteLiveAdUpsellTurns(current2, messages)
					local v55 = nil

					for k in current2.liveTurnStartSequenceIds do
						if v55 == nil or k < v55 then
							v55 = k
						end
					end

					if v55 == nil then
						current2.lastProcessedSequenceId = current2.historyWatermarkSequenceId or v30.latestSequenceId
					else
						current2.lastProcessedSequenceId = v55 - 1
					end

					current2.liveTurnIds = {}
					current2.liveTurnStartSequenceIds = {}
				end

				if universeId2 == nil or universeId2 == 0 then
					return
				end

				local v55 = current2.lastProcessedSequenceId or -1

				for _, message2 in messages do
					local completedTurnSequenceId = getCompletedTurnSequenceId(message2) -- inferred equivalent call

					if completedTurnSequenceId == nil or completedTurnSequenceId <= v55 then
						continue
					end

					if onAssistantTurnCompleted ~= nil then
						onAssistantTurnCompleted({
							universeId = universeId2,
							sessionId = message2.sessionId or sessionId2,
							turnState = message2.turnState,
							latestSequenceId = completedTurnSequenceId
						})
					end

					current2.lastProcessedSequenceId = completedTurnSequenceId
					v55 = completedTurnSequenceId
				end
			else
				current2.historyWatermarkSequenceId = current2.historyWatermarkSequenceId or v30.latestSequenceId
				noteLiveAdUpsellTurns(current2, messages)
			end
		end, {
			data.onAssistantTurnCompleted,
			v7,
			universeId,
			sessionId,
			v45,
			messages,
			v30.latestSequenceId
		})
	end

	local composerText, v52 = React.useBinding("")
	local state9, setState9 = React.useState(nil)

	local state10, setState10 = React.useState(false)
	local v53 = React.useCallback(function(p: string?)
		setState9(p)
		setState10(false)
	end, {})
	local v54 = React.useCallback(function(p: string)
		setState9(p)
		setState10(true)
	end, {})
	local ref7 = React.useRef("")
	local ref8 = React.useRef("")
	local ref9

	if FFlagBuildExperiencePrefillSkipsDraftPersist and engineFeature then
		ref9 = React.useRef(nil)
	else
		ref9 = nil
	end

	local ref10 = React.useRef(nil)
	local ref11 = React.useRef(v13)
	local ref12 = React.useRef(nil)
	ref11.current = v13
	local v55

	if data.createUniverseOnFirstPrompt == true then
		v55 = universeId == nil
	else
		v55 = false
	end

	local createUniverseOnFirstPrompt = data.createUniverseOnFirstPrompt == true
	local v56 = not FFlagBuildExperienceNewGameChatDraft and {
			current = createUniverseOnFirstPrompt
		}
		or React.useRef(createUniverseOnFirstPrompt)

	v56.current = createUniverseOnFirstPrompt
	local ref13

	if FFlagBuildExperienceRestoreStoppedPrompt then
		ref13 = React.useRef(nil)
	else
		ref13 = nil
	end

	local ref14 = React.useRef({})
	local ref15 = React.useRef(0)
	local state11, setState11 = React.useState({})
	local ref16 = React.useRef({})

	local state12, setState12 = React.useState({})

	local ref17 = React.useRef({})
	local ref18 = React.useRef({ universeId = data.universeId, placeId = data.placeId })

	local ref19 = React.useRef(nil)
	local clockBinding = ReactUtils.useClock()

	local v58 = useChatScroll(v5)

	local v59 = React.useCallback(function(p: number, p2)
		GetPlaytestLoadingStore().setAgentStatusForPlaceId(p, p2)
	end, {})

	local v60 = React.useCallback(function(callback)
		local function fn()
			if callback == nil then
				return false
			end

			return callback()
		end

		v58.captureDistanceFromBottom()

		if v7 == nil then
			return
		end

		v7.requestOlderHistoryWhile(fn, function()
			return v58.isNearTopRef.current
		end)
	end, { v7, v58 })

	local v61 = React.useCallback(function(callback)
		task.delay(0.1, function()
			if callback() or v7 == nil or v7.getNextHistoryPageToken() == nil or not v58.isNearTopRef.current then
				return
			end

			v60(callback)
		end)
	end, { v60, v58, v7 })

	local current7 = React.useCallback(function(callback)
		if not (v7 ~= nil and v7.getNextHistoryPageToken() ~= nil) then
			return
		end

		v61(callback)
	end, { v61, v7 })
	local ref20 = React.useRef(current7)
	ref20.current = current7

	React.useEffect(function()
		v58.setOnScrolledToTop(function()
			v60(nil)
		end)
		return function()
			v58.setOnScrolledToTop(nil)
		end
	end, { v58.setOnScrolledToTop, v60 })

	React.useEffect(function()
		if v3 and v7 ~= nil then
			local flag = false
			local function setHistoryLoading(isLoading2: boolean) -- 1 equivalent call inferred from this helper
				if setState4 == nil or flag then
					return
				end

				setState4({
					session = v7,
					sessionId = sessionId,
					universeId = universeId,
					hydrateHistoryWhen = v3,
					isLoading = isLoading2
				})
			end
			setHistoryLoading(not (v7.hasLoadedHistory() and #v7.getMergedHistory(false) > 0)) -- inferred equivalent call

			local v63 = sessionId
			local function isHydrateCancelled(): boolean -- 5 equivalent calls inferred from this helper
				if flag then
					return true
				end

				return v63 ~= nil and v63 ~= "" and v7.getCasSessionId() ~= v63
			end

			local function continueAfterSessionReady() -- 2 equivalent calls inferred from this helper
				if isHydrateCancelled() then -- inferred equivalent call
					return
				end

				ref20.current(isHydrateCancelled)
			end

			local function hydrateKnownSession(p: string)
				v7.setCasSessionId(p)

				if not v5 or ref2.current == nil then
					if
						v5
						or not v7.hasLoadedHistory()
						or not (#v7.getMergedHistory(false) > 0)
						or FFlagBuildExperienceModelPicker and not v7.hasObservedModels(false)
					then
						if v7.refreshSession(isHydrateCancelled, true) and not isHydrateCancelled() then -- inferred equivalent call
							continueAfterSessionReady() -- inferred equivalent call
						end
					else
						continueAfterSessionReady() -- inferred equivalent call
					end
				end

				if setState4 ~= nil then
					if flag then
						return
					end

					setState4({
						session = v7,
						sessionId = sessionId,
						universeId = universeId,
						hydrateHistoryWhen = v3,
						isLoading = false
					})
				end
			end

			task.spawn(function()
				-- [DEDUP] synthesized from 3 duplicated terminal regions
				local function deduplicatedTail()
					if setState4 ~= nil then
						if flag then
							return
						end

						setState4({
							session = v7,
							sessionId = sessionId,
							universeId = universeId,
							hydrateHistoryWhen = v3,
							isLoading = false
						})
					end
				end

				local v64 = sessionId

				if v5 and (v64 == nil or v64 == "") then
					v64 = v7.getCasSessionId()
				end

				if v64 ~= nil and v64 ~= "" then
					hydrateKnownSession(v64)
					return
				end

				if FFlagBuildExperienceModelPicker then
					local casSessionId = v7.getCasSessionId()

					if
						casSessionId ~= nil
						and v7.hasLoadedHistory()
						and #v7.getMergedHistory(false) > 0
						and not v7.hasObservedModels(false)
					then
						hydrateKnownSession(casSessionId)
						return
					end
				end

				if
					universeId == nil
					or universeId == 0
					or v7.hasLoadedHistory() and #v7.getMergedHistory(false) > 0
				then
					return deduplicatedTail()
				else
					local sessionFindByUniverse = creatorAgentChatStore.sessionFindByUniverse({
						universeId = universeId,
						sort = "desc",
						application = "build",
						filterByPinForBuild = true
					})

					while sessionFindByUniverse.state(false).status == "pending" do
						if isHydrateCancelled() then -- inferred equivalent call
							break
						end

						task.wait()
					end

					if v5 then
						if isHydrateCancelled() then -- inferred equivalent call
							return
						end

						local casSessionId = v7.getCasSessionId()

						if casSessionId ~= nil and casSessionId ~= "" then
							hydrateKnownSession(casSessionId)
							return
						end
					end

					if isHydrateCancelled() or sessionFindByUniverse.state(false).status ~= "succeeded" then -- inferred equivalent call
						return deduplicatedTail()
					else
						local result = sessionFindByUniverse.state(false).result
						local sessions

						if result ~= nil then
							sessions = result.sessions
						end

						local v65

						if typeof(sessions) == "table" then
							v65 = sessions[1]
						end

						local sessionId2

						if typeof(v65) == "table" then
							sessionId2 = v65.sessionId
						end

						if typeof(sessionId2) == "string" and sessionId2 ~= "" then
							local v66 = {
								universeId = universeId,
								placeId = placeId,
								sessionId = sessionId2,
								accountId = nil
							}
							local accountId2

							if FFlagBuildExperienceModelPicker then
								accountId2 = accountId
							end

							v66.accountId = accountId2
							setState2(v66)
						else
							v7.markHistoryLoaded()
							return deduplicatedTail()
						end
					end
				end
			end)

			return function()
				flag = true
			end
		elseif setState4 ~= nil then
			setState4({
				session = v7,
				sessionId = sessionId,
				universeId = universeId,
				hydrateHistoryWhen = v3,
				isLoading = false
			})
		end
	end, { v7, sessionId, universeId, placeId, creatorAgentChatStore, v3, v5, accountId })

	React.useEffect(function()
		if v7 == nil then
			return
		end

		local v63 = false
		local function refreshKnownSession()
			local v64 = v7.getCasSessionId()

			if (v64 == nil or v64 == "") and sessionId ~= nil and sessionId ~= "" then
				v64 = sessionId
			end

			if v64 == nil or v64 == "" then
				return
			end

			task.spawn(function()
				local function isRefreshCancelled()
					return v63
				end

				if v7.refreshSession(isRefreshCancelled, true) and not v63 then
					ref20.current(function()
						return v63
					end)
				end
			end)
		end

		local connection = MessageBusService:Subscribe(messageId, function(_)
			ref.current = true

			if engineFeature then
				local v64 = v7.getCasSessionId()

				if (v64 == nil or v64 == "") and sessionId ~= nil and sessionId ~= "" then
					v64 = sessionId
				end

				local v65 = FFlagBuildExperiencePrefillSkipsDraftPersist

				if v65 then
					if ref7.current == "" then
						v65 = false
					else
						v65 = ref7.current == ref9.current
					end
				end

				if v64 ~= nil and v64 ~= "" and not v65 then
					local current2 = BuildAppStorage.getChatDraft(v64) or ""
					ref8.current = current2
					ref7.current = current2
					v52(current2)
					v53(nil)
				end
			end

			refreshKnownSession()
		end, false, true)
		local onUnhideConnection = AppLifecycleObserverService.OnUnhide:Connect(refreshKnownSession)

		return function()
			v63 = true
			connection:Disconnect()
			onUnhideConnection:Disconnect()
		end
	end, { v7, sessionId, ref })

	React.useEffect(function()
		if not v3 then
			return
		end

		v58.lockToBottom()
	end, { v3, v5, v7, sessionId, v58 })

	local v63 = React.useCallback(function(current2: string)
		ref7.current = current2
		v52(current2)
		v53(nil)
	end, { v52, v53 })
	local v64

	if engineFeature then
		v64 = React.useCallback(function()
			if ref10.current ~= nil then
				task.cancel(ref10.current)
				ref10.current = nil
			end
		end, {})
	else
		v64 = nil
	end

	local v65

	if FFlagBuildExperienceNewGameChatDraft then
		v65 = React.useCallback(function()
			local current2 = ref11.current

			if current2 ~= nil and current2 ~= "" then
				return current2
			end

			if v56.current then
				return getNewGameChatDraftKey()
			end

			return nil
		end, {})
	else
		v65 = nil
	end

	local v66

	if engineFeature then
		v66 = React.useCallback(function(current2: string)
			ref8.current = current2
			v64()
			local v67

			if FFlagBuildExperienceNewGameChatDraft then
				v67 = v65()
			else
				v67 = ref11.current
			end

			if v67 == nil or v67 == "" then
				return
			end

			ref10.current = task.delay(0.5, function()
				ref10.current = nil
				BuildAppStorage.setChatDraft(v67, current2)
			end)
		end, { v64, v65 })
	else
		v66 = nil
	end

	local v67

	if engineFeature then
		v67 = React.useCallback(function(current2: string)
			local v68

			if FFlagBuildExperienceNewGameChatDraft then
				v68 = v65()
			else
				v68 = ref11.current
			end

			if v68 == nil or v68 == "" then
				return
			end

			ref8.current = current2
			v64()
			BuildAppStorage.setChatDraft(v68, current2)
		end, { v64, v65 })
	else
		v67 = nil
	end

	local v68

	if engineFeature then
		v68 = React.useCallback(function(p: string, p2: string?)
			local v69

			if FFlagBuildExperienceNewGameChatDraft and v56.current then
				v69 = getNewGameChatDraftKey()
			end

			if v69 ~= nil then
				BuildAppStorage.setChatDraft(v69, "")
			end

			if p2 == nil or p2 == "" or ref8.current ~= p then
				return
			end

			ref8.current = ""
			v64()
			BuildAppStorage.setChatDraft(p2, "")
		end, { v64 })
	else
		v68 = nil
	end

	local setComposerText = React.useCallback(function(p: string)
		v63(p)

		if engineFeature then
			if FFlagBuildExperiencePrefillSkipsDraftPersist then
				local current2 = ref9.current

				if current2 ~= nil and p == current2 then
					return
				end

				ref9.current = nil
			end

			v66(p)
		end
	end, { v63, v66 })
	local setPrefilledComposerText

	if FFlagBuildExperiencePrefillSkipsDraftPersist and engineFeature then
		setPrefilledComposerText = React.useCallback(function(current2: string)
			ref9.current = current2
			v63(current2)
		end, { v63 })
	else
		setPrefilledComposerText = setComposerText
	end

	if FFlagBuildExperienceNewGameChatDraft and engineFeature then
		React.useEffect(function()
			if not v55 or v13 ~= nil and v13 ~= "" then
				return
			end

			local newGameChatDraftKey = getNewGameChatDraftKey()

			if newGameChatDraftKey == nil then
				return
			end

			local current2 = BuildAppStorage.getChatDraft(newGameChatDraftKey) or ""

			if current2 ~= "" and ref7.current == "" then
				ref8.current = current2
				v63(current2)
			end
		end, { v55, v13, v63 })
	end

	local useEffect = React.useEffect
	local function fn()
		if not engineFeature or (v13 == nil or v13 == "") then
			return
		end

		local current2 = ref12.current
		ref12.current = v13
		v64()

		if
			FFlagBuildExperiencePrefillSkipsDraftPersist
			and current2 == nil
			and ref7.current ~= ""
			and ref7.current == ref9.current
		then
			ref8.current = BuildAppStorage.getChatDraft(v13) or ""
		elseif current2 == nil and ref7.current ~= "" then
			ref8.current = ref7.current
			BuildAppStorage.setChatDraft(v13, ref7.current)
		else
			local current3 = BuildAppStorage.getChatDraft(v13) or ""
			ref8.current = current3
			v63(current3)
		end

		return function()
			local v71 = ref10.current ~= nil
			v64()

			if v71 then
				BuildAppStorage.setChatDraft(v13, ref8.current)
			end
		end
	end

	local v72

	if FFlagBuildExperienceModelPicker then
		v72 = v7
	end

	useEffect(fn, { v13, v64, v63, v72 })

	local function commitComposerResourceAttachments(current2) -- 3 equivalent calls inferred from this helper
		ref17.current = current2
		setState12(current2)
		v53(nil)
	end

	local function findComposerResourceAttachmentIndexByUri(p: string)
		for k, v73 in ref17.current do
			if chatTypes.getResourceAttachmentUri(v73) == p then
				return k
			end
		end

		return nil
	end

	local function addComposerResourceAttachment(p)
		local clone = table.clone(ref17.current)
		table.insert(clone, p)
		commitComposerResourceAttachments(clone) -- inferred equivalent call
	end

	local function removeComposerResourceAttachmentAtIndex(p: number)
		local clone = table.clone(ref17.current)
		table.remove(clone, p)
		commitComposerResourceAttachments(clone) -- inferred equivalent call
	end

	local function clearComposerResourceAttachments()
		commitComposerResourceAttachments({}) -- inferred equivalent call
	end
	local ref21 = React.useRef(commitComposerResourceAttachments)
	ref21.current = commitComposerResourceAttachments
	React.useLayoutEffect(function()
		local current2 = ref18.current

		if current2.universeId ~= data.universeId or current2.placeId ~= data.placeId then
			ref21.current({})
		end

		ref18.current = { universeId = data.universeId, placeId = data.placeId }
	end, { data.universeId, data.placeId })

	local function commitComposerImages(current2) -- 2 equivalent calls inferred from this helper
		ref16.current = current2
		setState11(current2)
	end

	local function hasFailedComposerImage(items): boolean -- 3 equivalent calls inferred from this helper
		for _, item in items do
			if item.uploadStatus == "failed" then
				return true
			end
		end

		return false
	end

	local function updateComposerImage(p, fn2)
		local current2 = ref16.current
		local clone = table.clone(current2)

		for k, v73 in current2 do
			if v73.capture == p then
				clone[k] = fn2(v73)
				commitComposerImages(clone) -- inferred equivalent call
				return clone
			end
		end

		return current2
	end

	local function beginComposerImageUpload(p)
		ref15.current += 1
		local current2 = ref15.current
		ref14.current[p] = current2

		if not hasFailedComposerImage(updateComposerImage(p, function(p2) -- inferred equivalent call
			local clone = table.clone(p2)
			clone.uri = nil
			clone.uploadStatus = "uploading"
			clone.uploadError = nil
			return clone
		end)) then
			v53(nil)
		end

		uploadCaptureAsync(p):andThen(function(p2)
			if ref14.current[p] ~= current2 then
				return
			end

			ref14.current[p] = nil

			if not hasFailedComposerImage(updateComposerImage(p, function(p3) -- inferred equivalent call
				local clone = table.clone(p3)
				clone.uri = `rbxassetid://{p2.assetId}`
				clone.uploadStatus = "uploaded"
				clone.uploadError = nil
				return clone
			end)) then
				v53(nil)
			end
		end):catch(function(uploadError)
			if ref14.current[p] ~= current2 then
				return
			end

			ref14.current[p] = nil
			updateComposerImage(p, function(p2)
				local clone = table.clone(p2)
				clone.uri = nil
				clone.uploadStatus = "failed"
				clone.uploadError = uploadError
				return clone
			end)

			v53(formatted2)
		end)
	end

	local function setComposerImages(list)
		local current2 = ref16.current

		local captures = {}
		local current3 = {}

		for i = 1, math.min(#list, 2) do
			local item = list[i]
			local v74

			if item.capture == nil or item.uri ~= nil or item.uploadStatus ~= nil then
				v74 = item
			else
				v74 = item

				for _, v76 in current2 do
					if v76.capture == item.capture then
						v74 = v76
						break
					end
				end
			end

			if v74.uri == nil or v74.uploadStatus ~= nil then
				if v74.capture ~= nil and v74.uri == nil and v74.uploadStatus == nil then
					v74 = table.clone(v74)
					v74.uploadStatus = "uploading"
					table.insert(captures, v74.capture)
				end
			else
				v74 = table.clone(v74)
				v74.uploadStatus = "uploaded"
			end

			table.insert(current3, v74)
		end

		for _, v74 in current2 do
			local v75 = false

			for _, v77 in current3 do
				if v77.capture == v74.capture then
					v75 = true
					break
				end
			end

			if v75 or v74.capture == nil then
				continue
			end

			ref14.current[v74.capture] = nil
		end

		commitComposerImages(current3) -- inferred equivalent call

		if not hasFailedComposerImage(current3) then -- inferred equivalent call
			v53(nil)
		end

		for _, v74 in captures do
			beginComposerImageUpload(v74)
		end
	end
	local ref22 = React.useRef(setComposerImages)
	ref22.current = setComposerImages

	local function retryComposerImage(p: number)
		local v73 = ref16.current[p]

		if v73 == nil or v73.capture == nil or v73.uploadStatus ~= "failed" then
			return
		end

		beginComposerImageUpload(v73.capture)
	end

	local isComposerSendBlocked = false

	for _, v75 in state11 do
		if v75.uri == nil or v75.uploadStatus == "uploading" or v75.uploadStatus == "failed" then
			isComposerSendBlocked = true
			break
		end
	end

	local v75 = React.useCallback(function(p: number)
		return function(p2: string?, p3: number?)
			if ref4.current == p then
				local current2 = ref3.current
				local v76 = sessionId
				local v77

				if current2 == nil or current2.session ~= v7 then
					v77 = false
				elseif v76 == nil or v76 == "" or current2.sessionId == v76 then
					v77 = true
				elseif current2.sessionId == nil then
					v77 = current2.session.getCasSessionId() == v76
				else
					v77 = false
				end

				if v77 then
					local v78 = false

					if FFlagBuildExperienceAnswerForm then
						local current3 = ref2.current

						if current3 ~= nil then
							local getLocalToolActions = current3.getLocalToolActions
							v78 = next(getLocalToolActions(false).onAnswerSelectedByToolCallId) ~= nil
						end
					end

					if p2 ~= nil and ref7.current == "" and not v78 then
						setComposerText(p2)
					end

					v53((v:Format((creatorAgentChat.getToolResultFailureComposerError(p3)))))
				end
			end
		end
	end, { v7, sessionId, setComposerText, v53, v })

	local v76 = data.onPromptFailure
	local state13

	if FFlagBuildExperienceModelPicker then
		local setState13
		state13, setState13 = React.useState(nil)

		if state13 == nil or state13.owner ~= v7 then
			state13 = nil
		end

		v76 = React.useCallback(function(p: number?, reason)
			if p == CreatorAgentChat.ErrorCodes.OutOfCredits then
				setState13(function(p2)
					return {
						count = not p2 and 1 or p2.count + 1,
						reason = reason,
						owner = v7
					}
				end)
			end

			if data.onPromptFailure ~= nil then
				data.onPromptFailure(p, reason)
			end
		end, { v7, data.onPromptFailure })
	end

	local v77 = React.useCallback(function(p: number, p2, p3: string?, p4, p5, data2)
		if ref4.current ~= p then
			return
		end

		if FFlagBuildExperienceModelPicker and v9 ~= nil and not v9.current then
			GetBuildCreatorCreditRefreshStore(false).settled()
			return
		end

		v21(nil)
		ref6.current = nil
		setState5(nil)

		if FFlagBuildExperienceModelPicker then
			GetBuildCreatorCreditRefreshStore(false).settled()
		end

		if p2 == nil then
			if data2.placeId ~= nil then
				v59(data2.placeId, "Completed")
			end

			v58.scrollToBottomAfterSend()

			local casSessionId = data2.getCasSessionId()

			if casSessionId ~= nil and casSessionId ~= "" then
				if data.createUniverseOnFirstPrompt and sessionId == nil and data2.universeId ~= nil then
					local v78 = {
						universeId = data2.universeId,
						placeId = data2.placeId,
						sessionId = casSessionId
					}

					if FFlagBuildExperienceModelPicker then
						local clone = table.clone(v78)
						clone.accountId = accountId
						setState(clone)
					else
						setState(v78)
					end

					if data.onProjectResolved ~= nil then
						data.onProjectResolved(v78)
					end
				end

				task.spawn(function()
					data2.refreshSession(function(): boolean
						return ref4.current ~= p
					end)
				end)
			end
		else
			if v76 ~= nil then
				v76(p2.errorCode, p2.outOfCreditsReason)
			end

			if data2.placeId ~= nil then
				v59(data2.placeId, "Idle")
			end

			if p4 ~= nil then
				ref22.current(p4)
			end

			if p5 ~= nil then
				ref21.current(p5)
			end

			if p3 ~= nil then
				setComposerText(p3)
				v53((v:Format((creatorAgentChat.getPromptFailureComposerError(p2)))))
			end

			task.spawn(function()
				data2.refreshSession(function(): boolean
					return ref4.current ~= p
				end)
			end)
		end
	end, {
		v9,
		data.createUniverseOnFirstPrompt,
		v76,
		data.onProjectResolved,
		sessionId,
		v59,
		setState,
		accountId,
		v58,
		setComposerText,
		v53,
		v21,
		setState5,
		v
	})

	local ref23 = React.useRef(v3)
	React.useEffect(function()
		local v78 = v3 and not ref23.current
		ref23.current = v3

		if v5 or not v3 or not v78 and not isAssistantResponding and v24 == nil then
			return
		end

		v58.scrollToBottomUnconditionally()
		task.defer(v58.scrollToBottomUnconditionally)
		task.delay(0.15, v58.scrollToBottomUnconditionally)
	end, {
		v3,
		v5,
		isAssistantResponding,
		v24,
		#messages,
		v58
	})

	React.useEffect(function()
		if ref2.current ~= nil then
			local current2 = ref3.current
			local v78 = sessionId
			local v79

			if current2 == nil or current2.session ~= v7 then
				v79 = false
			elseif v78 == nil or v78 == "" or current2.sessionId == v78 then
				v79 = true
			elseif current2.sessionId == nil then
				v79 = current2.session.getCasSessionId() == v78
			else
				v79 = false
			end

			if v79 then
				return
			end
		end

		if not (state6 == nil and v7 ~= nil) then
			return
		end

		local resumeSessionKey = getResumeSessionKey(v7) -- inferred equivalent call

		if resumeSessionKey == nil then
			return
		end

		local function attachResumedTurn(p, current2: number?)
			ref4.current += 1
			local current3 = ref4.current
			ref6.current = current2

			if placeId ~= nil then
				v59(placeId, "Loading")
			end

			local createResumedAssistantTurn = creatorAgentChat.createResumedAssistantTurn

			local function fn2(p2)
				v77(current3, p2, nil, nil, nil, v7)
			end

			local v79

			if current2 ~= nil then
				v79 = current2 - 1
			end

			local resumedAssistantTurn = createResumedAssistantTurn(v7, p, fn2, v79, v75(current3), v2)

			v21(resumedAssistantTurn, v7)
			resumedAssistantTurn.start()
			v58.scrollToBottomUnconditionally()
		end

		if v30.activeTurnState == nil or v30.activeTurnItemIndex == nil or v30.activeTurnState.isDone then
			ref6.current = nil

			local activeTurnHandle = creatorAgentChatStore.getActiveTurnHandle(resumeSessionKey)
			local v78

			if activeTurnHandle ~= nil then
				v78 = activeTurnHandle.state(false)
			end

			local v79

			if activeTurnHandle == nil or v78 == nil then
				v79 = false
			else
				v79 = not v78.isDone
			end

			if (isAssistantResponding or v79) and v79 then
				attachResumedTurn(activeTurnHandle, nil)
			end
		else
			local activeTurnStartSequenceId = v30.activeTurnStartSequenceId

			if ref6.current == activeTurnStartSequenceId and v24 ~= nil then
				return
			end

			local v78 = creatorAgentChatStore.resumeTurnFromHistory(
				resumeSessionKey,
				v30.activeTurnState,
				v30.activeTurnSequenceIds
			)

			if v78 ~= nil then
				attachResumedTurn(v78, activeTurnStartSequenceId)
			end
		end
	end, {
		v30,
		v7,
		sessionId,
		creatorAgentChatStore,
		isAssistantResponding,
		v24,
		placeId,
		v59,
		v77,
		v58,
		v21,
		state6,
		v75,
		v2
	})

	local v78 = React.useCallback(
		function(p, text: string, p2, images, resourceAttachments, current2: number, afterSequenceId: number?, p3: string?, callback, onTerminal, callback2, p4, callback3)
			local function startAdmitted(p5)
				setState5({
					text = text,
					images = images,
					resourceAttachments = resourceAttachments,
					afterSequenceId = afterSequenceId
				})

				local v79 = v32

				local fn2 = engineFeature and p3 ~= nil and function(p6: number?)
					if v79 ~= nil then
						v79(p6)
					end

					v68(p3, p.getCasSessionId() or sessionId)
				end or v79
				local v80

				if FFlagBuildExperienceRestoreStoppedPrompt and ref13 ~= nil then
					local v81 = ref13
					v80 = function(p6: number?)
						v81.current = current2

						if fn2 ~= nil then
							fn2(p6)
						end
					end
				else
					v80 = fn2
				end

				local fn3 = callback ~= nil and function(p6: number?)
					if v80 ~= nil then
						v80(p6)
					end

					callback(p.getCasSessionId())
				end or v80

				local fn4 = FFlagBuildExperienceLibrary and callback2 ~= nil and function()
					if engineFeature and p3 ~= nil then
						v68(p3, p.getCasSessionId() or sessionId)
					end

					callback2(p.getCasSessionId())
				end or nil
				local v81, v82

				if FFlagBuildExperienceModelPicker and p4 ~= nil then
					local v83 = p4

					v81 = fn3 ~= nil and function(p6: number?)
						if v83.isCurrent() then
							fn3(p6)
						end
					end or fn3

					if fn4 == nil then
						v82 = fn4
					else
						v82 = function()
							if v83.isCurrent() then
								fn4()
							end
						end
					end
				else
					v82 = fn4
					v81 = fn3
				end

				local v83 = nil
				local createLiveAssistantTurn = creatorAgentChat.createLiveAssistantTurn

				local function fn5(p6)
					if FFlagBuildExperienceModelPicker and p4 ~= nil then
						local current3 = p4.isCurrent()
						p4.release()

						if not current3 then
							if ref2.current == v83 and ref4.current == current2 then
								v21(nil)
								ref6.current = nil
								setState5(nil)

								if p.placeId ~= nil then
									v59(p.placeId, "Idle")
								end
							end

							if onTerminal ~= nil then
								onTerminal()
							end

							return
						end
					end

					v77(current2, p6, p3, images, resourceAttachments, p)

					if onTerminal ~= nil then
						onTerminal()
					end
				end
				local v84 = v75(current2)
				local v85

				if FFlagBuildExperienceModelPicker then
					v85 = p5
				end

				local v86

				if FFlagBuildExperienceModelPicker and p5 ~= nil then
					v86 = p5.sessionId
				end

				v83 = createLiveAssistantTurn(
					p,
					p2,
					fn5,
					v84,
					v2,
					v81,
					v82,
					v85,
					v86,
					FFlagBuildExperienceModelPicker and p4 ~= nil and function(): boolean
						return not p4.isCurrent()
					end or nil
				)

				if p.placeId ~= nil then
					v59(p.placeId, "Loading")
				end

				v21(v83, p)
				v58.scrollToBottomAfterSend()
				v83.start()
			end

			if not FFlagBuildExperienceModelPicker then
				startAdmitted(nil)
				return
			end

			local v79 = ref5
			local v80 = setState8
			local v81 = p4

			if not v81 then
				local entry

				if v10 ~= nil then
					entry = v10.entry
				end

				local creatorCreditStore = CreatorCredit.getCreatorCreditStore(false)
				local promptExperiment = CreatorAgentChat.experimentOverride.getPromptExperiment(CreatorAgentChat.experimentOverride.getKey(p.getCasSessionId()) or v14)
				local v82

				if enabled and v14 ~= nil then
					v82 = CreatorAgentChat.experimentOverride.getInternalSelection(
						CreatorAgentChat.experimentOverride.getKey(p.getCasSessionId()) or v14,
						false
					)
				end

				v81 = beginBuildModelSend(entry, creatorCreditStore, promptExperiment, v82)
			end

			p4 = v81

			if p4 == nil then
				if onTerminal ~= nil then
					onTerminal()
				end
			else
				local attempt = p4

				local current3 = {
					attempt = attempt,
					started = false,
					onTerminal = onTerminal,
					restoreDraft = callback3
				}
				v79.current = current3
				v80(true)
				task.spawn(function()
					local success, result, v84 = pcall(attempt.prepare, p)
					local v85 = not attempt.isCurrent() or ref4.current ~= current2

					if v85 or not success or result == nil then
						attempt.release()

						if v79.current == current3 then
							v79.current = nil
							v80(false)
							setState5(nil)
						end

						if v85 then
							if ref4.current == current2 and callback3 ~= nil then
								callback3(true)
							end
						else
							local v86 = LocalizationStrings.CHAT_DEFAULT_FAILURE

							if success and v84 ~= nil then
								if v84.kind == "setup" then
									local getPromptFailureComposerError = creatorAgentChat.getPromptFailureComposerError
									local v87 = {
										errorCode = v84.errorCode,
										isContentPolicy = false,
										setupStage = 0
									}
									local setupStage

									if v84.setupError and v84.setupError.stage ~= "session_load" then
										setupStage = v84.setupError.stage
									end

									v87.setupStage = setupStage
									v86 = getPromptFailureComposerError(v87)
								elseif v84.kind == "unavailable" then
									v86 = LocalizationStrings.MODEL_PICKER_UNAVAILABLE
								elseif v84.kind == "denied" then
									v86 = LocalizationStrings.CHAT_ERROR_OUT_OF_CREDITS
									GetBuildCreatorCreditRefreshStore(false).refresh()
								end

								if v76 ~= nil then
									v76(v84.errorCode, v84.reason)
								end
							end

							if callback3 ~= nil then
								callback3(false)
							end

							v54(v:Format(v86))
						end

						if onTerminal ~= nil then
							onTerminal()
						end
					else
						v80(false)
						current3.started = true
						startAdmitted(result)
					end
				end)
			end
		end,
		{
			v10,
			v14,
			ref5,
			v8,
			setState8,
			v54,
			v,
			v76,
			v77,
			v59,
			v58,
			v21,
			setState5,
			v75,
			v2,
			v32,
			v68,
			sessionId
		}
	)

	local ref24 = React.useRef(v30.latestSequenceId)
	ref24.current = v30.latestSequenceId
	local v80 = useAgentRollbackRequest({
		universeId = universeId,
		placeId = placeId,
		session = v7,
		activeTurnHandleRef = ref2,
		startRollbackTurn = React.useCallback(function(data2, callback, callback2)
			local v80 = v7

			if v80 == nil then
				callback2()
				return
			end

			if FFlagBuildExperienceModelPicker then
				local current2 = ref5.current

				if current2 ~= nil and not current2.started and current2.attempt.isCurrent() then
					callback2()
					return
				end
			end

			v58.captureStickToBottomForSend()
			ref4.current += 1
			local current2 = ref4.current
			setState6(nil)
			local agentRollbackPrompt = buildAgentRollbackPrompt(
				data2.versionNumber,
				data2.noteTitle,
				data2.noteDescription
			)

			v78(v80, agentRollbackPrompt, agentRollbackPrompt, nil, nil, current2, ref24.current, nil, function()
				v58.scrollToBottomUnconditionally()
				callback()
			end, callback2)
		end, { v7, ref5, v58, setState6, v78 })
	})

	React.useLayoutEffect(function()
		if state7 ~= nil then
			local current2 = ref3.current
			local v81 = sessionId
			local v82

			if current2 == nil or current2.session ~= v7 then
				v82 = false
			elseif v81 == nil or v81 == "" or current2.sessionId == v81 then
				v82 = true
			elseif current2.sessionId == nil then
				v82 = current2.session.getCasSessionId() == v81
			else
				v82 = false
			end

			if not v82 then
				local current3 = ref3.current
				ref4.current += 1
				ref6.current = nil

				if v80.stopRequestBeforeReceipt(state7) then
					if current3 ~= nil and current3.session.placeId ~= nil then
						v59(current3.session.placeId, "Idle")
					end
				else
					state7.detach()

					if FFlagBuildExperienceModelPicker then
						local v84 = ref5
						local current4 = v84.current

						if current4 ~= nil and current4.started then
							current4.attempt.unlockSelection()
							v84.current = nil
						end
					end
				end

				v21(nil, nil)
				setState5(nil)
				setState6(nil)
			end
		end
	end, { v7, sessionId, state7, v21, v80, v59, ref5 })

	local v81 = React.useCallback(
		function(text: string, p, images, resourceAttachments, p2: number, afterSequenceId: number?, p3, callback)
			setState5({
				text = text,
				images = images,
				resourceAttachments = resourceAttachments,
				afterSequenceId = afterSequenceId
			})

			local v82 = nil
			local universeId2 = nil

			if FFlagBuildExperienceModelPicker and data.modelSelectionDraftId ~= nil then
				v82 = GetBuildModelSelectionStore(false).retainDraftForCreation(data.modelSelectionDraftId)
			end

			local v83 = setState3
			local v84 = v8
			local entry

			if v10 == nil then
				entry = nil
			else
				entry = v10.entry
			end

			local function canConfigure(): boolean -- 3 equivalent calls inferred from this helper
				return entry ~= nil and entry.getSelection(false) ~= nil
			end

			if v84 ~= nil then
				v84.pending = true
				v83(true)
			end

			local lastTime = os.clock()
			local v85 = nil
			local chatOpenId

			if FFlagBuildExperienceChatOpenId then
				chatOpenId = CreatorAgentChat.chatOpenTelemetry.getChatOpenIdForUniverse(nil)
			else
				chatOpenId = nil
			end

			local v87 = UniverseCreate.getUniverseCreateStore().createUniverse({
				templatePlaceId = getDefaultTemplatePlaceId(),
				isPublish = true
			}):andThen(function(p4)
				if FFlagBuildExperienceModelPicker then
					universeId2 = p4.universeId
				end

				Debug.log("info", "build_experience create_universe succeeded", {
					durationMs = math.floor((os.clock() - lastTime) * 1000 + 0.5),
					universeId = p4.universeId,
					rootPlaceId = p4.rootPlaceId
				})

				if FFlagBuildExperiencePromptFailureTelemetry then
					v85 = { universeId = p4.universeId, placeId = p4.rootPlaceId }
				end

				local v88

				if FFlagBuildExperienceModelPicker then
					v88 = not canConfigure() -- inferred equivalent call
				else
					v88 = ref4.current ~= p2
				end

				if v88 then
					return nil
				end

				local universeConfigurationStore = UniverseConfiguration.getUniverseConfigurationStore()

				return universeConfigurationStore.patchConfiguration(p4.universeId, {
					audiences = { 1 }
				}):andThen(function()
					if FFlagBuildExperienceModelPicker and not canConfigure() then -- inferred equivalent call
						return nil
					end

					return universeConfigurationStore.setTeamCreate(p4.universeId, true)
				end):andThen(function(): nil
					local v89

					if FFlagBuildExperienceModelPicker then
						v89 = not canConfigure() or v84 == nil or not v84.mounted -- inferred equivalent call
					else
						v89 = ref4.current ~= p2
					end

					if v89 then
						return nil
					end

					local v90 = { universeId = p4.universeId, placeId = p4.rootPlaceId }

					if FFlagBuildExperienceModelPicker then
						local clone = table.clone(v90)
						clone.accountId = accountId
						setState(clone)
					else
						setState(v90)
					end

					if data.onProjectResolved ~= nil then
						data.onProjectResolved(v90)
					end

					if p3 ~= nil and not p3.isCurrent() then
						return nil
					end

					local sessionForProject = creatorAgentChatStore.getSessionForProject(
						p4.universeId,
						p4.rootPlaceId,
						sessionId
					)

					if
						enabled
						and (FFlagBuildExperienceModelPicker and CreatorAgentChat.experimentOverride.has(v14) or v15 ~= nil and v15.current)
					then
						sessionForProject.setPendingExperimentKey(v14)
					end

					v78(
						sessionForProject,
						text,
						p,
						images,
						resourceAttachments,
						p2,
						afterSequenceId,
						text,
						nil,
						nil,
						nil,
						p3,
						callback
					)

					return nil
				end)
			end):catch(function(err)
				Debug.log("warn", "build_experience create_or_configure_universe failed", {
					durationMs = math.floor((os.clock() - lastTime) * 1000 + 0.5),
					error = err
				})

				if ref4.current ~= p2 or p3 ~= nil and not p3.isCurrent() then
					return
				end

				if FFlagBuildExperiencePromptFailureTelemetry then
					local v88 = math.round((os.clock() - lastTime) * 1000)
					local v89 = v85 == nil and {} or {
						universeId = v85.universeId,
						placeId = v85.placeId
					}

					local v90 = FFlagBuildExperienceChatOpenId
						and {
							universeId = v89.universeId,
							placeId = v89.placeId,
							chatOpenId = chatOpenId
						}
						or v89

					local v91 = {
						isContentPolicy = "false",
						setupStage = v85 == nil and "create_universe" or "configure_universe",
						errorCopyKey = LocalizationStrings.CHAT_CREATE_UNIVERSE_ERROR,
						elapsedMs = tostring(v88),
						receivedResponse = "false",
						stalled = tostring(chatConstants.PROMPT_STALL_SECONDS * 1000 <= v88)
					}

					v91.failureKind = RequestFailureKind.Unknown

					if typeof(err) == "table" and typeof(err.responseCode) == "number" then
						v91.failureKind = RequestFailureKind.Http
						v91.httpStatusCode = tostring(err.responseCode)
					end

					sendBuildExperienceEvent("SEND_PROMPT_START", v90)
					sendBuildExperienceEvent("SEND_PROMPT_FAILED", v90, v91)
				end

				v21(nil)
				setState5(nil)
				setComposerText(text)

				if images ~= nil then
					ref22.current(images)
				end

				if resourceAttachments ~= nil then
					ref21.current(resourceAttachments)
				end

				if p3 ~= nil then
					p3.release()

					setState8(false)
				end

				v53(formatted)
			end)

			if FFlagBuildExperienceModelPicker then
				v87:finally(function()
					if v82 ~= nil then
						v82(universeId2)
					end

					if v84 ~= nil then
						v84.pending = false

						if v84.mounted then
							v83(false)
						end
					end
				end)
			end
		end,
		{
			v8,
			v10,
			setState3,
			setState8,
			sessionId,
			creatorAgentChatStore,
			data.onProjectResolved,
			data.modelSelectionDraftId,
			v21,
			setComposerText,
			v53,
			setState,
			accountId,
			setState5,
			v78,
			formatted,
			v14,
			v15
		}
	)

	local sendMessage = React.useCallback(function(callback): boolean
		if not v4 or v8 ~= nil and v8.pending then
			return false
		end

		local text = trimMessage(ref7.current) -- inferred equivalent call

		local current2 = ref16.current
		local current3 = ref17.current

		if text == "" and #current2 == 0 then
			setComposerText("")
			return false
		end

		for _, v84 in current2 do
			if v84.uri == nil or v84.uploadStatus == "uploading" or v84.uploadStatus == "failed" then
				return false
			end
		end

		local current4 = ref3.current
		local v84 = sessionId
		local v85

		if current4 == nil or current4.session ~= v7 then
			v85 = false
		elseif v84 == nil or v84 == "" or current4.sessionId == v84 then
			v85 = true
		elseif current4.sessionId == nil then
			v85 = current4.session.getCasSessionId() == v84
		else
			v85 = false
		end

		local current5

		if v85 then
			current5 = ref2.current
		end

		if isAssistantResponding or v5 and current5 ~= nil then
			if #current2 > 0 or #current3 > 0 or (current5 == nil or not current5.trySubmitComposerText(text)) then
				return false
			end

			setComposerText("")

			if ref19.current then
				ref19.current.releaseFocus()
			end

			v58.scrollToBottomAfterSend()
			return true
		else
			local v86

			if data.createUniverseOnFirstPrompt == true then
				v86 = universeId == nil
			else
				v86 = false
			end

			if
				not v86 and v7 == nil
				or placeId ~= nil and agentRollbackRequestStore.getIsPendingForPlaceId(placeId)(false)
			then
				return false
			end

			local function restoreDraft(flag: boolean)
				if flag and (ref7.current ~= "" or #ref16.current > 0 or #ref17.current > 0) then
					return
				end

				setComposerText(text)
				ref22.current(current2)
				ref21.current(current3)
			end

			local attempt

			if FFlagBuildExperienceModelPicker then
				v53(nil)
				local entry

				if v10 ~= nil then
					entry = v10.entry
				end

				local creatorCreditStore = CreatorCredit.getCreatorCreditStore(false)
				local getPromptExperiment = CreatorAgentChat.experimentOverride.getPromptExperiment
				local getKey = CreatorAgentChat.experimentOverride.getKey
				local v88

				if v7 ~= nil then
					v88 = v7.getCasSessionId()
				end

				local promptExperiment = getPromptExperiment(getKey(v88) or v14)
				local v89

				if enabled and v14 ~= nil then
					local getInternalSelection = CreatorAgentChat.experimentOverride.getInternalSelection
					local getKey2 = CreatorAgentChat.experimentOverride.getKey
					local v90

					if v7 ~= nil then
						v90 = v7.getCasSessionId()
					end

					v89 = getInternalSelection(getKey2(v90) or v14, false)
				end

				attempt = beginBuildModelSend(entry, creatorCreditStore, promptExperiment, v89)

				if attempt == nil then
					return false
				end

				ref5.current = { attempt = attempt, started = false, restoreDraft = restoreDraft }

				setState8(true)
			else
				attempt = nil
			end

			v58.captureStickToBottomForSend()
			ref4.current += 1
			local current6 = ref4.current
			setState6(nil)

			if engineFeature then
				v67(text)
			end

			v63("")
			ref22.current({})
			ref21.current({})

			if ref19.current then
				ref19.current.releaseFocus()
			end

			local function startPrompt(p, p2)
				if v86 then
					local latestSequenceId = v30.latestSequenceId
					local v90

					if FFlagBuildExperienceModelPicker then
						v90 = restoreDraft
					end

					v81(text, p, p2, current3, current6, latestSequenceId, attempt, v90)
				else
					local latestSequenceId = v30.latestSequenceId
					local v91

					if FFlagBuildExperienceLibrary then
						v91 = callback
					end

					local v93

					if FFlagBuildExperienceModelPicker then
						v93 = restoreDraft
					end

					v78(v7, text, p, p2, current3, current6, latestSequenceId, text, nil, nil, v91, attempt, v93)
				end
			end

			if #current2 == 0 and #current3 == 0 then
				startPrompt(text, nil)
				return true
			end

			local v89 = {}

			if text ~= "" then
				table.insert(v89, { type = "text", text = text })
			end

			for _, v90 in current3 do
				if v90.type == "resource_link" then
					table.insert(v89, {
						type = v90.type,
						uri = v90.uri,
						name = v90.name,
						mimeType = v90.mimeType
					})
				else
					table.insert(v89, {
						type = v90.type,
						resource = {
							uri = v90.resource.uri,
							text = v90.resource.text,
							blob = nil,
							mimeType = v90.resource.mimeType
						}
					})
				end
			end

			local v90 = {}

			for _, v91 in current2 do
				local uri = v91.uri
				table.insert(v89, { type = "image", uri = uri })
				table.insert(v90, { capture = v91.capture, uri = uri, uploadStatus = "uploaded" })
			end

			startPrompt(v89, v90)
			return true
		end
	end, {
		v4,
		v8,
		v10,
		v14,
		ref5,
		setState8,
		v53,
		v7,
		sessionId,
		universeId,
		placeId,
		isAssistantResponding,
		v5,
		v58,
		setComposerText,
		v63,
		v67,
		v81,
		v78,
		data.createUniverseOnFirstPrompt,
		setState6,
		v30,
		agentRollbackRequestStore
	})

	local useCallback = React.useCallback
	local function fn2()
		if FFlagBuildExperienceModelPicker then
			local v83 = ref5
			local current2 = v83.current

			if current2 ~= nil and not current2.started then
				current2.attempt.release()
				v83.current = nil

				setState8(false)

				if not current2.started then
					ref4.current += 1
					setState5(nil)

					if current2.restoreDraft ~= nil then
						current2.restoreDraft(true)
					end

					if current2.onTerminal ~= nil then
						current2.onTerminal()
					end

					return
				end
			end
		end

		local current2 = ref3.current
		local v83 = sessionId
		local v84

		if current2 == nil or current2.session ~= v7 then
			v84 = false
		elseif v83 == nil or v83 == "" or current2.sessionId == v83 then
			v84 = true
		elseif current2.sessionId == nil then
			v84 = current2.session.getCasSessionId() == v83
		else
			v84 = false
		end

		local current3

		if v84 then
			current3 = ref2.current
		end

		if current3 == nil then
			v80.cancelRequestBeforeTurnStarts()
		elseif FFlagBuildExperienceModelPicker then
			if FFlagBuildExperiencePromptFailureTelemetry and current3.reportUserStop ~= nil then
				current3.reportUserStop()
			end

			current3.stop()
		else
			local current4 = ref4.current
			ref4.current += 1

			if FFlagBuildExperiencePromptFailureTelemetry and current3.reportUserStop ~= nil then
				current3.reportUserStop()
			end

			if not v80.stopRequestBeforeReceipt(current3) then
				current3.stop()
			end

			v21(nil)
			ref6.current = nil

			if
				FFlagBuildExperienceRestoreStoppedPrompt
				and ref13 ~= nil
				and ref13.current ~= current4
				and state5 ~= nil
				and ref7.current == ""
				and v30.isAwaitingUserMessageEcho
			then
				setComposerText(state5.text)

				if state5.images ~= nil and #ref16.current == 0 then
					ref22.current(state5.images)
				end

				if state5.resourceAttachments ~= nil and #ref17.current == 0 then
					ref21.current(state5.resourceAttachments)
				end
			end

			setState5(nil)
			setState6({
				session = v7,
				sessionId = v7.getCasSessionId(),
				startSequenceId = v30.activeTurnStartSequenceId
			})

			if placeId ~= nil then
				v59(placeId, "Idle")
			end
		end
	end

	local v88

	if FFlagBuildExperienceRestoreStoppedPrompt then
		v88 = state5
	end

	local v89

	if FFlagBuildExperienceRestoreStoppedPrompt then
		v89 = setComposerText
	end

	local stopAssistantResponse = useCallback(fn2, {
		ref5,
		setState8,
		v7,
		sessionId,
		placeId,
		v59,
		v21,
		setState5,
		setState6,
		v30,
		v80,
		v88,
		v89
	})

	local v91 = data.autoFocusComposer == nil or data.autoFocusComposer
	local v92

	if data.focusComposerWhen == nil then
		v92 = v91
	else
		v92 = data.focusComposerWhen
	end

	React.useEffect(function()
		if not (v91 and v92) then
			return function() end
		end

		local v93 = false
		local function fn3()
			return v93
		end

		scheduleComposerAutoFocus(ref19, fn3) -- inferred equivalent call
		return function()
			v93 = true
		end
	end, { v91, v92 })

	local launchPlaytest = React.useCallback(function(p: string)
		if placeId == nil then
			return
		end

		local fn3 = game.GameId == 0 and function()
			ref.current = true
		end or nil

		if launchPlaytestWithLoadingState(placeId, p, true, fn3) and fn3 ~= nil then
			ref.current = false
		end
	end, { placeId, ref })
	local localToolActions

	if FFlagBuildExperienceAnswerForm then
		localToolActions = React.useMemo(function()
			local onAnswerSelectedByToolCallId = {}

			for k, v96 in v28.onAnswerSelectedByToolCallId do
				onAnswerSelectedByToolCallId[k] = function(p, p2, flag: boolean?)
					v53(nil)
					v96(p, p2, flag)
				end
			end

			local onAnswerConfirmedByToolCallId = {}

			for k, v97 in v28.onAnswerConfirmedByToolCallId do
				onAnswerConfirmedByToolCallId[k] = function()
					v53(nil)
					v97()
				end
			end

			return {
				onAnswerSelectedByToolCallId = onAnswerSelectedByToolCallId,
				onAnswerConfirmedByToolCallId = onAnswerConfirmedByToolCallId,
				onPlanAcceptedByToolCallId = v28.onPlanAcceptedByToolCallId,
				onDevProductApprovedByToolCallId = v28.onDevProductApprovedByToolCallId,
				onDevProductRejectedByToolCallId = v28.onDevProductRejectedByToolCallId
			}
		end, { v28, v53 })
	else
		localToolActions = v28
	end

	local answerForm

	if FFlagBuildExperienceAnswerForm then
		answerForm = React.useMemo(function()
			return getActiveAnswerForm(activeTurnState, optimisticLocalTools, localToolActions)
		end, { activeTurnState, optimisticLocalTools, localToolActions })
	end

	local submitAnswerText

	if FFlagBuildExperienceAnswerForm then
		submitAnswerText = React.useCallback(function(p: string, p2: string, p3: string)
			local current2 = ref2.current

			if current2 == nil then
				return false
			end

			local current3 = ref3.current
			local v97 = sessionId
			local v98

			if current3 == nil or current3.session ~= v7 then
				v98 = false
			elseif v97 == nil or v97 == "" or current3.sessionId == v97 then
				v98 = true
			elseif current3.sessionId == nil then
				v98 = current3.session.getCasSessionId() == v97
			else
				v98 = false
			end

			if v98 then
				v53(nil)
				return current2.trySubmitAnswerText(p, p2, p3)
			end

			return false
		end, { v7, sessionId, v53 })
	end

	local v97 = {}
	v97.currentSessionId = v13
	v97.internalTesting = internalTesting
	v97.agentSpecVersion = agentSpecVersion
	v97.setAgentSpecVersion = setAgentSpecVersion
	v97.messages = messages
	v97.localToolActions = localToolActions
	v97.answerForm = answerForm
	v97.submitAnswerText = submitAnswerText
	v97.composerText = composerText
	v97.composerErrorText = state9
	v97.fundingFailure = state13
	v97.setComposerText = setComposerText
	v97.setPrefilledComposerText = setPrefilledComposerText
	v97.composerImages = state11
	v97.setComposerImages = setComposerImages
	v97.retryComposerImage = retryComposerImage
	v97.composerResourceAttachments = state12
	v97.findComposerResourceAttachmentIndexByUri = findComposerResourceAttachmentIndexByUri
	v97.addComposerResourceAttachment = addComposerResourceAttachment
	v97.removeComposerResourceAttachmentAtIndex = removeComposerResourceAttachmentAtIndex
	v97.clearComposerResourceAttachments = clearComposerResourceAttachments
	local hasPreparedModelSession

	if FFlagBuildExperienceModelPicker then
		if v10 == nil then
			hasPreparedModelSession = false
		else
			hasPreparedModelSession = v10.hasObservedModels
		end
	end

	v97.hasPreparedModelSession = hasPreparedModelSession
	local modelSessionModels

	if FFlagBuildExperienceModelPicker and v10 ~= nil then
		modelSessionModels = v10.models
	end

	v97.modelSessionModels = modelSessionModels

	if not isComposerSendBlocked then
		isComposerSendBlocked = FFlagBuildExperienceModelPicker

		if isComposerSendBlocked then
			isComposerSendBlocked = state3
				or state8
				or (v10 ~= nil and v10.isBusy and true or false) and not isAssistantResponding

			if not isComposerSendBlocked then
				if state9 == nil then
					isComposerSendBlocked = false
				else
					isComposerSendBlocked = not state10
				end
			end
		end
	end

	v97.isComposerSendBlocked = isComposerSendBlocked

	v97.isAssistantResponding = isAssistantResponding
	v97.canStopAssistantResponse = v24 ~= nil or (v48 or FFlagBuildExperienceModelPicker and state8)

	v97.canSendWhileResponding = canSendWhileResponding
	v97.sendMessage = sendMessage
	v97.stopAssistantResponse = stopAssistantResponse
	v97.setScrollingFrame = v58.setScrollingFrame
	local anchorScrollToInstance

	if FFlagBuildExperienceChatAccordionScrollAnchor then
		anchorScrollToInstance = v58.anchorToInstance
	end

	v97.anchorScrollToInstance = anchorScrollToInstance

	v97.textBoxRef = ref19
	v97.clockBinding = clockBinding
	v97.playtestPlaceId = placeId

	if placeId == nil then
		launchPlaytest = nil
	end

	v97.launchPlaytest = launchPlaytest
	v97.hasPublishedTurn = includesPublishTool
	v97.subagentTaskState = subagentTaskState
	v97.isHistoryHydrationComplete = isHistoryHydrationComplete
	v97.isHistoryLoading = isHistoryLoading
	v97.isHistoryExhausted = v45 and not v43
	return v97
end

return useChatSessionCore
