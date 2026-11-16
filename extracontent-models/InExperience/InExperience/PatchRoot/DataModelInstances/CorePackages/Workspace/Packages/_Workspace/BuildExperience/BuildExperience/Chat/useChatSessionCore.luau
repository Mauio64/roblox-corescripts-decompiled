local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local FFlagBuildExperienceChatImageAttachments = require(BuildExperience.Flags.FFlagBuildExperienceChatImageAttachments)

local SharedFlags = require(parent.SharedFlags)
local FFlagBuildExperienceChatResourceAttachments = SharedFlags.FFlagBuildExperienceChatResourceAttachments
local FFlagBuildExperienceModelPicker = require(BuildExperience.Flags.FFlagBuildExperienceModelPicker)
local engineFeature = game:GetEngineFeature("BuildAppStorageKey")

local FFlagBuildExperienceRefreshChatDraftOnGameLeave = require(BuildExperience.Flags.FFlagBuildExperienceRefreshChatDraftOnGameLeave)

local FFlagBuildExperiencePrefillSkipsDraftPersist = require(BuildExperience.Flags.FFlagBuildExperiencePrefillSkipsDraftPersist)

local MessageBusService = game:GetService("MessageBusService")
local AppLifecycleObserverService = game:GetService("AppLifecycleObserverService")

local CreatorAgentChat = require(parent.DataHydration.CreatorAgentChat)
local UniverseConfiguration = require(parent.DataHydration.UniverseConfiguration)
local UniverseCreate = require(parent.DataHydration.UniverseCreate)
local React = require(parent.React)
local ReactUtils = require(parent.ReactUtils)
local SharedFlags2 = require(parent.SharedFlags)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)
local Localization = require(parent.Localization)
local LocalizationRoactContext = Localization.LocalizationRoactContext
local LocalizationStrings = require(BuildExperience.LocalizationStrings)

local FFlagBuildExperienceChatAccordionScrollAnchor = require(BuildExperience.Flags.FFlagBuildExperienceChatAccordionScrollAnchor)
local FFlagBuildExperienceChatHistoryPrefetch = require(BuildExperience.Flags.FFlagBuildExperienceChatHistoryPrefetch)
local FFlagBuildExperienceManageDevProduct = require(BuildExperience.Flags.FFlagBuildExperienceManageDevProduct)
local FFlagBuildAdUpsell = require(BuildExperience.Flags.FFlagBuildAdUpsell)
local FFlagBuildExperienceLibrary = SharedFlags2.FFlagBuildExperienceLibrary
local FFlagBuildExperiencePromptFailureTelemetry = SharedFlags2.FFlagBuildExperiencePromptFailureTelemetry
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

local uploadCaptureAsync

if FFlagBuildExperienceChatImageAttachments then
	uploadCaptureAsync = require(BuildExperience.utils.uploadCaptureAsync)
else
	uploadCaptureAsync = nil
end

local Debug = CreatorAgentChat.debug
local RequestFailureKind = CreatorAgentChat.RequestFailureKind
local sendBuildExperienceEvent = require(BuildExperience.Telemetry.sendBuildExperienceEvent)
local signal = Signals.createSignal(false)
local function noopSetAgentSpecVersion(_: string?) end

local frozen = table.freeze({})

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

local function scheduleComposerAutoFocus(p, fn) -- 1 equivalent call inferred from this helper
	local v = 8
	local function tryFocus()
		if fn() then
			return
		end

		local current = p.current

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
	local v2

	if FFlagBuildExperienceChatImageAttachments then
		v2 = v:Format(LocalizationStrings.CHAT_CAPTURE_UPLOAD_ERROR)
	else
		v2 = nil
	end

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
	local v3 = React.useCallback(function()
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

	local v4 = data.hydrateHistoryWhen == nil or data.hydrateHistoryWhen
	local v5 = data.sendMessageWhen == nil or data.sendMessageWhen
	local v6 = FFlagBuildExperienceLibrary and data.isLibraryChat == true
	local v7

	if FFlagBuildAdUpsell then
		v7 = React.useRef(data.trackAdUpsellTurns == true).current
	else
		v7 = false
	end

	local creatorAgentChatStore = CreatorAgentChat.getCreatorAgentChatStore()
	local agentRollbackRequestStore = GetAgentRollbackRequestStore()

	local v8 = React.useMemo(function()
		if universeId == nil then
			return nil
		end

		return creatorAgentChatStore.getSessionForProject(universeId, placeId, sessionId)
	end, { universeId, placeId, sessionId, creatorAgentChatStore, accountId })

	React.useLayoutEffect(function()
		if v8 == nil or sessionId == nil or sessionId == "" then
			return
		end

		v8.setCasSessionId(sessionId)
	end, { v8, sessionId })
	local ref2, v9, state3, setState3

	if FFlagBuildExperienceModelPicker then
		ref2 = React.useRef(true)

		React.useLayoutEffect(function()
			ref2.current = true
			return function()
				ref2.current = false
			end
		end, { ref2 })

		v9 = React.useMemo(function()
			return { pending = false, mounted = true }
		end, {
			accountId,
			data.modelSelectionDraftId,
			data.universeId,
			data.placeId,
			data.sessionId
		})

		state3, setState3 = React.useState(false)

		React.useLayoutEffect(function()
			v9.mounted = true
			setState3(false)
			return function()
				v9.mounted = false
			end
		end, { v9, setState3 })
	else
		ref2 = nil
		v9 = nil
		setState3 = nil
		state3 = false
	end

	local v10

	if FFlagBuildExperienceModelPicker then
		v10 = useBuildModelSession(universeId, data.modelSelectionDraftId, v8)
	else
		v10 = nil
	end

	local v11 = React.useMemo(function()
		if v8 == nil then
			return signal5
		end

		return (Signals.createComputed(function(p)
			return {
				session = v8,
				sessionId = v8.getCasSessionId(),
				events = v8.getMergedHistory(p)
			}
		end))
	end, { v8 })
	local v12 = SignalsReact.useSignalState(v11)
	local v13

	if v8 == nil then
		v13 = nil
	else
		v13 = v8.getCasSessionId()
	end

	local agentSpecVersion = nil
	local setAgentSpecVersion = noopSetAgentSpecVersion
	local v14 = nil
	local ref3 = nil
	local internalTesting = nil

	if FFlagBuildExperienceModelPicker and enabled then
		local entry

		if v10 ~= nil then
			entry = v10.entry
		end

		local v15
		v15, v14 = useBuildInternalTesting(entry, v8, data.sessionId)
		internalTesting = v15

		if internalTesting ~= nil then
			agentSpecVersion = internalTesting.previewHash
		end

		setAgentSpecVersion = function(p: string?)
			if internalTesting ~= nil then
				internalTesting.onSelect()
				internalTesting.onSaveSpec(p)
			end
		end
	elseif enabled then
		local ref4 = React.useRef(nil)

		if ref4.current == nil then
			ref4.current = CreatorAgentChat.experimentOverride.createPendingKey()
		end

		v14 = ref4.current

		ref3 = React.useRef(false)

		local v15 = CreatorAgentChat.experimentOverride.getKey(v13) or v14

		local v16 = React.useMemo(function()
			return CreatorAgentChat.experimentOverride.getStateSignal(v15)
		end, { v15 })

		agentSpecVersion = SignalsReact.useSignalState(v16).specVersion

		setAgentSpecVersion = React.useCallback(function(p: string?)
			local v17

			if v8 ~= nil then
				v17 = v8.getCasSessionId()
			end

			local v18 = CreatorAgentChat.experimentOverride.getKey(v17)

			if v18 == nil then
				v18 = v14
				ref3.current = true

				if v8 ~= nil then
					v8.setPendingExperimentKey(v14)
				end
			end

			CreatorAgentChat.experimentOverride.set(v18, p)
		end, { v8, v14 })

		React.useEffect(function()
			if v8 == nil or not ref3.current then
				return
			end

			v8.setPendingExperimentKey(v14)
		end, { v8, v14 })

		React.useEffect(function()
			return function()
				CreatorAgentChat.experimentOverride.clear(v14)
			end
		end, { v14 })
	end

	local v15 = (v12.session ~= v8 or v12.sessionId ~= v13) and {} or v12.events
	local v16

	if sessionId == nil then
		v16 = false
	else
		v16 = sessionId ~= ""
	end

	if not v16 then
		if universeId == nil then
			v16 = false
		else
			v16 = universeId ~= 0
		end
	end

	local isLoading

	if v4 then
		if v8 == nil then
			isLoading = false
		elseif v16 then
			isLoading = not (v8.hasLoadedHistory() and #v15 > 0)
		else
			isLoading = v16
		end
	else
		isLoading = v4
	end

	local state4, setState4 = React.useState(function()
		return {
			session = v8,
			sessionId = sessionId,
			universeId = universeId,
			hydrateHistoryWhen = v4,
			isLoading = isLoading
		}
	end)
	local v17

	if state4 == nil or state4.session ~= v8 or state4.sessionId ~= sessionId or state4.universeId ~= universeId then
		v17 = false
	else
		v17 = state4.hydrateHistoryWhen == v4
	end

	local isHistoryHydrationComplete

	if v17 then
		isHistoryHydrationComplete = not state4.isLoading
	else
		isHistoryHydrationComplete = not isLoading
	end

	local isHistoryLoading = not isHistoryHydrationComplete

	if not isHistoryLoading then
		if v8 == nil then
			isHistoryLoading = false
		else
			isHistoryLoading = v8.getNextHistoryPageToken() ~= nil
		end
	end

	local state5, setState5 = React.useState(nil)

	local state6, setState6 = React.useState(nil)

	React.useEffect(function()
		setState6(nil)
	end, { v8, sessionId })
	local v18

	if state6 == nil or state6.session ~= v8 then
		v18 = false
	elseif sessionId == nil or sessionId == "" or state6.sessionId == sessionId then
		v18 = true
	elseif state6.sessionId == nil then
		v18 = state6.session.getCasSessionId() == sessionId
	else
		v18 = false
	end

	if not v18 then
		state6 = nil
	end

	local state7, setState7 = React.useState(nil)
	local ref4 = React.useRef(nil)
	local ref5 = React.useRef(nil)
	local ref6 = React.useRef(0)
	local ref7, state8, setState8

	if FFlagBuildExperienceModelPicker then
		ref7 = React.useRef(nil)

		state8, setState8 = React.useState(false)

		local useLayoutEffect = React.useLayoutEffect
		local function fn()
			if
				enabled
				and ref7.current ~= nil
				and not ref7.current.started
				and ref5.current ~= nil
				and data.sessionId ~= nil
				and data.sessionId ~= ""
				and ref5.current.sessionId ~= data.sessionId
			then
				ref7.current.attempt.release()
				ref7.current = nil
			end

			if ref7.current == nil then
				setState8(false)
				setState5(nil)
			end

			return function()
				local current = ref7.current

				if current ~= nil and not (current.started and current.attempt.isCurrent()) then
					current.attempt.release()
					ref7.current = nil

					if current.onTerminal ~= nil then
						current.onTerminal()
					end
				end
			end
		end

		local v19

		if v10 ~= nil then
			v19 = v10.entry
		end

		useLayoutEffect(fn, { v19, data.sessionId, setState8, setState5 })
	else
		ref7 = nil
		setState8 = nil
		state8 = false
	end

	local ref8 = React.useRef(nil)

	local v19 = React.useCallback(function(current, session)
		assert(current == nil or session ~= nil, "Active turns require an owning session")
		ref4.current = current
		ref5.current = current ~= nil and {
			session = session,
			sessionId = session.getCasSessionId()
		} or nil

		setState7(current)
	end, { setState7 })

	local current = ref5.current
	local v20

	if current == nil or current.session ~= v8 then
		v20 = false
	elseif sessionId == nil or sessionId == "" or current.sessionId == sessionId then
		v20 = true
	elseif current.sessionId == nil then
		v20 = current.session.getCasSessionId() == sessionId
	else
		v20 = false
	end

	local v21

	if v20 then
		v21 = state7
	else
		v21 = nil
	end

	local v22

	if v21 == nil then
		v22 = signal2
	else
		v22 = v21.getOptimisticLocalTools
	end

	local v23 = if v21 == nil then signal3 else v21.getLocalToolActions

	local v24 = if v21 == nil then signal4 else v21.getSetupErrorText

	local optimisticLocalTools = SignalsReact.useSignalState(v22)
	local v25 = SignalsReact.useSignalState(v23)
	local v26 = SignalsReact.useSignalState(v24)

	if v26 ~= nil then
		v26 = v:Format(v26)
	end

	local liveAssistantMessage = React.useMemo(function()
		return getLiveAssistantMessage(v21, data.createUniverseOnFirstPrompt, v8, state5, v26) -- inferred equivalent call
	end, { v21, data.createUniverseOnFirstPrompt, state5, v8, v26 })

	local v27 = React.useMemo(function()
		local sessionId2

		if v8 == nil then
			sessionId2 = sessionId
		else
			sessionId2 = v8.getCasSessionId() or sessionId
		end

		local universeId2

		if v8 == nil then
			universeId2 = universeId
		else
			universeId2 = v8.universeId
		end

		local placeId2 = if v8 == nil then placeId else v8.placeId
		local v27 = {
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

		v27.pendingUserMessage = pendingUserMessage
		local pendingUserImages

		if
			FFlagBuildExperienceChatImageAttachments
			and state5 ~= nil
			and sessionPromptMessageFilter.shouldOptimisticallyDisplay(state5.text)
		then
			pendingUserImages = state5.images
		end

		v27.pendingUserImages = pendingUserImages
		local pendingUserResourceAttachments

		if
			FFlagBuildExperienceChatResourceAttachments
			and state5 ~= nil
			and sessionPromptMessageFilter.shouldOptimisticallyDisplay(state5.text)
		then
			pendingUserResourceAttachments = state5.resourceAttachments
		end

		v27.pendingUserResourceAttachments = pendingUserResourceAttachments
		local pendingUserMessageAfterSequenceId

		if state5 ~= nil then
			pendingUserMessageAfterSequenceId = state5.afterSequenceId
		end

		v27.pendingUserMessageAfterSequenceId = pendingUserMessageAfterSequenceId

		v27.liveAssistantMessage = liveAssistantMessage
		local optimisticCancelledStartSequenceId

		if state6 ~= nil then
			optimisticCancelledStartSequenceId = state6.startSequenceId
		end

		v27.optimisticCancelledStartSequenceId = optimisticCancelledStartSequenceId
		return parseSessionStream(v15, v27)
	end, {
		v15,
		v8,
		sessionId,
		universeId,
		placeId,
		optimisticLocalTools,
		state5,
		liveAssistantMessage,
		state6
	})
	local v28

	if v7 then
		local useRef = React.useRef
		local v29 = {
			isInitialized = false,
			universeId = universeId,
			sessionId = 0,
			historyWatermarkSequenceId = 0,
			lastProcessedSequenceId = nil,
			liveTurnIds = 0,
			liveTurnStartSequenceIds = 0
		}
		local sessionId2

		if v8 == nil then
			sessionId2 = sessionId
		else
			sessionId2 = v8.getCasSessionId() or sessionId
		end

		v29.sessionId = sessionId2
		v29.historyWatermarkSequenceId = v27.latestSequenceId

		v29.liveTurnIds = {}
		v29.liveTurnStartSequenceIds = {}
		v28 = useRef(v29)
	else
		v28 = nil
	end

	local v29

	if v28 == nil then
		v29 = nil
	else
		v29 = React.useCallback(function(p: number?)
			if p ~= nil then
				v28.current.liveTurnIds[p] = true
			end
		end, { v28 })
	end

	local messages = v27.messages
	local v30

	if v8 == nil then
		v30 = false
	else
		v30 = v8.getNextHistoryPageToken() ~= nil
	end

	local v31 = v8 == nil or (not v16 or v8.hasLoadedHistory())

	local v32 = isHistoryHydrationComplete and v31 and (v8 == nil or #messages > 0 or not v30)

	local subagentTaskState = v27.subagentTaskState
	local includesPublishTool = v27.includesPublishTool
	local message = messages[#messages]
	local v44 = React.useMemo(function()
		if placeId == nil then
			return signal
		end

		return agentRollbackRequestStore.getIsPendingForPlaceId(placeId)
	end, { placeId, agentRollbackRequestStore })

	local v45 = SignalsReact.useSignalState(v44)
	local isAssistantResponding

	if v21 == nil then
		if message == nil or message.kind ~= "assistant_turn" then
			isAssistantResponding = v45
		else
			isAssistantResponding = not message.isDone or v45
		end
	else
		isAssistantResponding = true
	end

	local canSendWhileResponding = isAssistantResponding
		and not v45
		and hasPendingLocalToolResponse(optimisticLocalTools)

	local activeTurnState = v27.activeTurnState
	React.useEffect(function()
		if v21 == nil or activeTurnState == nil then
			return
		end

		v21.syncFromTurnState(activeTurnState)
	end, { v21, activeTurnState })

	if v7 then
		React.useEffect(function()
			local onAssistantTurnCompleted = data.onAssistantTurnCompleted

			local v48 = v28
			local universeId2

			if v8 == nil then
				universeId2 = universeId
			else
				universeId2 = v8.universeId or universeId
			end

			local sessionId2

			if v8 == nil then
				sessionId2 = sessionId
			else
				sessionId2 = v8.getCasSessionId() or sessionId
			end

			local current2 = v48.current

			if isEvolvingAdUpsellScope(current2, universeId2, sessionId2) then -- inferred equivalent call
				current2.universeId = universeId2 or current2.universeId
				current2.sessionId = sessionId2 or current2.sessionId
			else
				current2 = {
					isInitialized = false,
					universeId = universeId2,
					sessionId = sessionId2,
					historyWatermarkSequenceId = v27.latestSequenceId,
					lastProcessedSequenceId = nil,
					liveTurnIds = {},
					liveTurnStartSequenceIds = {}
				}

				v48.current = current2
			end

			if v32 then
				if not current2.isInitialized then
					current2.isInitialized = true
					noteLiveAdUpsellTurns(current2, messages)
					local v52 = nil

					for k in current2.liveTurnStartSequenceIds do
						if v52 == nil or k < v52 then
							v52 = k
						end
					end

					if v52 == nil then
						current2.lastProcessedSequenceId = current2.historyWatermarkSequenceId or v27.latestSequenceId
					else
						current2.lastProcessedSequenceId = v52 - 1
					end

					current2.liveTurnIds = {}
					current2.liveTurnStartSequenceIds = {}
				end

				if universeId2 == nil or universeId2 == 0 then
					return
				end

				local v52 = current2.lastProcessedSequenceId or -1

				for _, message2 in messages do
					local completedTurnSequenceId = getCompletedTurnSequenceId(message2) -- inferred equivalent call

					if completedTurnSequenceId == nil or completedTurnSequenceId <= v52 then
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
					v52 = completedTurnSequenceId
				end
			else
				current2.historyWatermarkSequenceId = current2.historyWatermarkSequenceId or v27.latestSequenceId
				noteLiveAdUpsellTurns(current2, messages)
			end
		end, {
			data.onAssistantTurnCompleted,
			v8,
			universeId,
			sessionId,
			v32,
			messages,
			v27.latestSequenceId
		})
	end

	local composerText, v49 = React.useBinding("")
	local state9, setState9 = React.useState(nil)

	local state10, setState10 = React.useState(false)
	local v50 = React.useCallback(function(p: string?)
		setState9(p)
		setState10(false)
	end, {})
	local v51 = React.useCallback(function(p: string)
		setState9(p)
		setState10(true)
	end, {})
	local ref9 = React.useRef("")
	local ref10 = React.useRef("")
	local ref11

	if FFlagBuildExperiencePrefillSkipsDraftPersist and engineFeature then
		ref11 = React.useRef(nil)
	else
		ref11 = nil
	end

	local ref12 = React.useRef(nil)
	local ref13 = React.useRef(v13)
	local ref14 = React.useRef(nil)
	ref13.current = v13
	local v52

	if data.createUniverseOnFirstPrompt == true then
		v52 = universeId == nil
	else
		v52 = false
	end

	local createUniverseOnFirstPrompt = data.createUniverseOnFirstPrompt == true
	local v53 = not FFlagBuildExperienceNewGameChatDraft and {
			current = createUniverseOnFirstPrompt
		}
		or React.useRef(createUniverseOnFirstPrompt)

	v53.current = createUniverseOnFirstPrompt
	local ref15

	if FFlagBuildExperienceRestoreStoppedPrompt then
		ref15 = React.useRef(nil)
	else
		ref15 = nil
	end

	local state11 = not v6 and {} or frozen

	local ref16 = React.useRef({})
	local ref17 = React.useRef(0)
	local setState11, v54

	if FFlagBuildExperienceChatImageAttachments then
		state11, setState11 = React.useState({})

		v54 = React.useRef({})
	else
		v54 = { current = {} }
		setState11 = nil
	end

	local v55 = {
		current = { universeId = data.universeId, placeId = data.placeId }
	}
	local state12, setState12, v56

	if FFlagBuildExperienceChatResourceAttachments then
		state12, setState12 = React.useState({})

		v56 = React.useRef({})

		v55 = React.useRef({ universeId = data.universeId, placeId = data.placeId })
	else
		v56 = { current = {} }
		setState12 = nil
		state12 = {}
	end

	local ref18 = React.useRef(nil)
	local clockBinding = ReactUtils.useClock()

	local v58 = useChatScroll(v6)

	local v59 = React.useCallback(function(p: number, p2)
		GetPlaytestLoadingStore().setAgentStatusForPlaceId(p, p2)
	end, {})

	local v60 = React.useCallback(function(callback)
		local function fn() -- 1 equivalent call inferred from this helper
			if callback == nil then
				return false
			end

			return callback()
		end

		v58.captureDistanceFromBottom()

		if v8 == nil then
			return
		end

		if FFlagBuildExperienceChatHistoryPrefetch then
			v8.requestOlderHistoryWhile(fn, function()
				return v58.isNearTopRef.current
			end)
		else
			task.spawn(function()
				if v8.loadOlderHistory(fn) and v8.getNextHistoryPageToken() ~= nil and v58.isAtTopRef.current then
					task.delay(0.1, function()
						if fn() then -- inferred equivalent call
							return
						end

						if v58.isViewportUnderfilled() then
							v8.loadOlderHistory(fn)
						end
					end)
				end
			end)
		end
	end, { v8, v58 })

	local v61 = React.useCallback(function(callback)
		task.delay(0.1, function()
			if callback() or v8 == nil or v8.getNextHistoryPageToken() == nil then
				return
			end

			if FFlagBuildExperienceChatHistoryPrefetch then
				if not v58.isNearTopRef.current then
					return
				end
			elseif not v58.isViewportUnderfilled() then
				return
			end

			v60(callback)
		end)
	end, { v60, v58, v8 })

	local current5 = React.useCallback(function(callback)
		if not (v8 ~= nil and v8.getNextHistoryPageToken() ~= nil) then
			return
		end

		v61(callback)
	end, { v61, v8 })
	local ref19 = React.useRef(current5)
	ref19.current = current5

	React.useEffect(function()
		v58.setOnScrolledToTop(function()
			v60(nil)
		end)
		return function()
			v58.setOnScrolledToTop(nil)
		end
	end, { v58.setOnScrolledToTop, v60 })

	React.useEffect(function()
		if v4 and v8 ~= nil then
			local flag = false
			local function setHistoryLoading(isLoading2: boolean) -- 1 equivalent call inferred from this helper
				if setState4 == nil or flag then
					return
				end

				setState4({
					session = v8,
					sessionId = sessionId,
					universeId = universeId,
					hydrateHistoryWhen = v4,
					isLoading = isLoading2
				})
			end
			setHistoryLoading(not (v8.hasLoadedHistory() and #v8.getMergedHistory(false) > 0)) -- inferred equivalent call

			local v63 = sessionId
			local function isHydrateCancelled(): boolean -- 5 equivalent calls inferred from this helper
				if flag then
					return true
				end

				return v63 ~= nil and v63 ~= "" and v8.getCasSessionId() ~= v63
			end

			local function continueAfterSessionReady() -- 2 equivalent calls inferred from this helper
				if isHydrateCancelled() then -- inferred equivalent call
					return
				end

				ref19.current(isHydrateCancelled)
			end

			local function hydrateKnownSession(p: string)
				-- [DEDUP] synthesized from 3 duplicated terminal regions
				local function deduplicatedTail()
					if setState4 ~= nil then
						if flag then
							return
						end

						setState4({
							session = v8,
							sessionId = sessionId,
							universeId = universeId,
							hydrateHistoryWhen = v4,
							isLoading = false
						})
					end
				end

				v8.setCasSessionId(p)

				if v6 and ref4.current ~= nil then
					return deduplicatedTail()
				elseif
					v6
					or not v8.hasLoadedHistory()
					or not (#v8.getMergedHistory(false) > 0)
					or FFlagBuildExperienceModelPicker and not v8.hasObservedModels(false)
				then
					local v64

					if FFlagBuildExperienceChatHistoryPrefetch then
						v64 = v8.refreshSession(isHydrateCancelled, true)
					else
						v64 = v8.refreshSession(isHydrateCancelled)
					end

					if v64 and not isHydrateCancelled() then -- inferred equivalent call
						continueAfterSessionReady() -- inferred equivalent call
					end

					return deduplicatedTail()
				else
					continueAfterSessionReady() -- inferred equivalent call
					return deduplicatedTail()
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
							session = v8,
							sessionId = sessionId,
							universeId = universeId,
							hydrateHistoryWhen = v4,
							isLoading = false
						})
					end
				end

				local v64 = sessionId

				if v6 and (v64 == nil or v64 == "") then
					v64 = v8.getCasSessionId()
				end

				if v64 ~= nil and v64 ~= "" then
					hydrateKnownSession(v64)
					return
				end

				if FFlagBuildExperienceModelPicker then
					local casSessionId = v8.getCasSessionId()

					if
						casSessionId ~= nil
						and v8.hasLoadedHistory()
						and #v8.getMergedHistory(false) > 0
						and not v8.hasObservedModels(false)
					then
						hydrateKnownSession(casSessionId)
						return
					end
				end

				if
					universeId == nil
					or universeId == 0
					or v8.hasLoadedHistory() and #v8.getMergedHistory(false) > 0
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

					if v6 then
						if isHydrateCancelled() then -- inferred equivalent call
							return
						end

						local casSessionId = v8.getCasSessionId()

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
							v8.markHistoryLoaded()
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
				session = v8,
				sessionId = sessionId,
				universeId = universeId,
				hydrateHistoryWhen = v4,
				isLoading = false
			})
		end
	end, { v8, sessionId, universeId, placeId, creatorAgentChatStore, v4, v6, accountId })

	React.useEffect(function()
		if v8 == nil then
			return
		end

		local v63 = false
		local function refreshKnownSession()
			local v64 = v8.getCasSessionId()

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

				local v65

				if FFlagBuildExperienceChatHistoryPrefetch then
					v65 = v8.refreshSession(isRefreshCancelled, true)
				else
					v65 = v8.refreshSession(isRefreshCancelled)
				end

				if v65 and not v63 then
					ref19.current(function()
						return v63
					end)
				end
			end)
		end

		local connection = MessageBusService:Subscribe(messageId, function(_)
			ref.current = true

			if FFlagBuildExperienceRefreshChatDraftOnGameLeave and engineFeature then
				local v64 = v8.getCasSessionId()

				if (v64 == nil or v64 == "") and sessionId ~= nil and sessionId ~= "" then
					v64 = sessionId
				end

				local v65 = FFlagBuildExperiencePrefillSkipsDraftPersist

				if v65 then
					if ref9.current == "" then
						v65 = false
					else
						v65 = ref9.current == ref11.current
					end
				end

				if v64 ~= nil and v64 ~= "" and not v65 then
					local current2 = BuildAppStorage.getChatDraft(v64) or ""
					ref10.current = current2
					ref9.current = current2
					v49(current2)
					v50(nil)
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
	end, { v8, sessionId, ref })

	React.useEffect(function()
		if not v4 then
			return
		end

		v58.lockToBottom()
	end, { v4, v6, v8, sessionId, v58 })

	local v63 = React.useCallback(function(current2: string)
		ref9.current = current2
		v49(current2)
		v50(nil)
	end, { v49, v50 })
	local v64

	if engineFeature then
		v64 = React.useCallback(function()
			if ref12.current ~= nil then
				task.cancel(ref12.current)
				ref12.current = nil
			end
		end, {})
	else
		v64 = nil
	end

	local v65

	if FFlagBuildExperienceNewGameChatDraft then
		v65 = React.useCallback(function()
			local current2 = ref13.current

			if current2 ~= nil and current2 ~= "" then
				return current2
			end

			if v53.current then
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
			ref10.current = current2
			v64()
			local v67

			if FFlagBuildExperienceNewGameChatDraft then
				v67 = v65()
			else
				v67 = ref13.current
			end

			if v67 == nil or v67 == "" then
				return
			end

			ref12.current = task.delay(0.5, function()
				ref12.current = nil
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
				v68 = ref13.current
			end

			if v68 == nil or v68 == "" then
				return
			end

			ref10.current = current2
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

			if FFlagBuildExperienceNewGameChatDraft and v53.current then
				v69 = getNewGameChatDraftKey()
			end

			if v69 ~= nil then
				BuildAppStorage.setChatDraft(v69, "")
			end

			if p2 == nil or p2 == "" or ref10.current ~= p then
				return
			end

			ref10.current = ""
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
				local current2 = ref11.current

				if current2 ~= nil and p == current2 then
					return
				end

				ref11.current = nil
			end

			v66(p)
		end
	end, { v63, v66 })
	local setPrefilledComposerText

	if FFlagBuildExperiencePrefillSkipsDraftPersist and engineFeature then
		setPrefilledComposerText = React.useCallback(function(current2: string)
			ref11.current = current2
			v63(current2)
		end, { v63 })
	else
		setPrefilledComposerText = setComposerText
	end

	if FFlagBuildExperienceNewGameChatDraft and engineFeature then
		React.useEffect(function()
			if not v52 or v13 ~= nil and v13 ~= "" then
				return
			end

			local newGameChatDraftKey = getNewGameChatDraftKey()

			if newGameChatDraftKey == nil then
				return
			end

			local current2 = BuildAppStorage.getChatDraft(newGameChatDraftKey) or ""

			if current2 ~= "" and ref9.current == "" then
				ref10.current = current2
				v63(current2)
			end
		end, { v52, v13, v63 })
	end

	local useEffect = React.useEffect
	local function fn()
		if not engineFeature or (v13 == nil or v13 == "") then
			return
		end

		local current2 = ref14.current
		ref14.current = v13
		v64()

		if
			FFlagBuildExperiencePrefillSkipsDraftPersist
			and current2 == nil
			and ref9.current ~= ""
			and ref9.current == ref11.current
		then
			ref10.current = BuildAppStorage.getChatDraft(v13) or ""
		elseif current2 == nil and ref9.current ~= "" then
			ref10.current = ref9.current
			BuildAppStorage.setChatDraft(v13, ref9.current)
		else
			local current3 = BuildAppStorage.getChatDraft(v13) or ""
			ref10.current = current3
			v63(current3)
		end

		return function()
			local v71 = ref12.current ~= nil
			v64()

			if v71 then
				BuildAppStorage.setChatDraft(v13, ref10.current)
			end
		end
	end

	local v72

	if FFlagBuildExperienceModelPicker then
		v72 = v8
	end

	useEffect(fn, { v13, v64, v63, v72 })

	local function commitComposerResourceAttachments(current2) -- 3 equivalent calls inferred from this helper
		v56.current = current2

		if setState12 ~= nil then
			setState12(current2)
		end

		v50(nil)
	end

	local function findComposerResourceAttachmentIndexByUri(p: string)
		for k, v73 in v56.current do
			if chatTypes.getResourceAttachmentUri(v73) == p then
				return k
			end
		end

		return nil
	end

	local function addComposerResourceAttachment(p)
		local clone = table.clone(v56.current)
		table.insert(clone, p)
		commitComposerResourceAttachments(clone) -- inferred equivalent call
	end

	local function removeComposerResourceAttachmentAtIndex(p: number)
		local clone = table.clone(v56.current)
		table.remove(clone, p)
		commitComposerResourceAttachments(clone) -- inferred equivalent call
	end

	local function clearComposerResourceAttachments()
		commitComposerResourceAttachments({}) -- inferred equivalent call
	end
	local ref20 = React.useRef(commitComposerResourceAttachments)
	ref20.current = commitComposerResourceAttachments

	if FFlagBuildExperienceChatResourceAttachments then
		React.useLayoutEffect(function()
			local current2 = v55.current

			if current2.universeId ~= data.universeId or current2.placeId ~= data.placeId then
				ref20.current({})
			end

			v55.current = { universeId = data.universeId, placeId = data.placeId }
		end, { data.universeId, data.placeId })
	end

	local function commitComposerImages(current2) -- 2 equivalent calls inferred from this helper
		v54.current = current2

		if setState11 ~= nil then
			setState11(current2)
		end
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
		local current2 = v54.current
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
		ref17.current += 1
		local current2 = ref17.current
		ref16.current[p] = current2

		if not hasFailedComposerImage(updateComposerImage(p, function(p2) -- inferred equivalent call
			local clone = table.clone(p2)
			clone.uri = nil
			clone.uploadStatus = "uploading"
			clone.uploadError = nil
			return clone
		end)) then
			v50(nil)
		end

		uploadCaptureAsync(p):andThen(function(p2)
			if ref16.current[p] ~= current2 then
				return
			end

			ref16.current[p] = nil

			if not hasFailedComposerImage(updateComposerImage(p, function(p3) -- inferred equivalent call
				local clone = table.clone(p3)
				clone.uri = `rbxassetid://{p2.assetId}`
				clone.uploadStatus = "uploaded"
				clone.uploadError = nil
				return clone
			end)) then
				v50(nil)
			end
		end):catch(function(uploadError)
			if ref16.current[p] ~= current2 then
				return
			end

			ref16.current[p] = nil
			updateComposerImage(p, function(p2)
				local clone = table.clone(p2)
				clone.uri = nil
				clone.uploadStatus = "failed"
				clone.uploadError = uploadError
				return clone
			end)

			if FFlagBuildExperienceChatImageAttachments then
				v50(v2)
			end
		end)
	end

	local function setComposerImages(list)
		local current2 = v54.current

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

			ref16.current[v74.capture] = nil
		end

		commitComposerImages(current3) -- inferred equivalent call

		if not hasFailedComposerImage(current3) then -- inferred equivalent call
			v50(nil)
		end

		for _, v74 in captures do
			beginComposerImageUpload(v74)
		end
	end
	local ref21 = React.useRef(setComposerImages)
	ref21.current = setComposerImages

	local function retryComposerImage(p: number)
		local v73 = v54.current[p]

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
			if ref6.current == p then
				local current2 = ref5.current
				local v76 = sessionId
				local v77

				if current2 == nil or current2.session ~= v8 then
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
						local current3 = ref4.current

						if current3 ~= nil then
							local getLocalToolActions = current3.getLocalToolActions
							v78 = next(getLocalToolActions(false).onAnswerSelectedByToolCallId) ~= nil
						end
					end

					if p2 ~= nil and ref9.current == "" and not v78 then
						setComposerText(p2)
					end

					v50((v:Format((creatorAgentChat.getToolResultFailureComposerError(p3)))))
				end
			end
		end
	end, { v8, sessionId, setComposerText, v50, v })

	local v76 = data.onPromptFailure
	local state13

	if FFlagBuildExperienceModelPicker then
		local setState13
		state13, setState13 = React.useState(nil)

		if state13 == nil or state13.owner ~= v8 then
			state13 = nil
		end

		v76 = React.useCallback(function(p: number?, reason)
			if p == CreatorAgentChat.ErrorCodes.OutOfCredits then
				setState13(function(p2)
					return {
						count = not p2 and 1 or p2.count + 1,
						reason = reason,
						owner = v8
					}
				end)
			end

			if data.onPromptFailure ~= nil then
				data.onPromptFailure(p, reason)
			end
		end, { v8, data.onPromptFailure })
	end

	local v77 = React.useCallback(function(p: number, p2, p3: string?, p4, p5, data2)
		if ref6.current ~= p then
			return
		end

		if FFlagBuildExperienceModelPicker and ref2 ~= nil and not ref2.current then
			GetBuildCreatorCreditRefreshStore(false).settled()
			return
		end

		v19(nil)
		ref8.current = nil
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
						return ref6.current ~= p
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

			if FFlagBuildExperienceChatImageAttachments and p4 ~= nil then
				ref21.current(p4)
			end

			if FFlagBuildExperienceChatResourceAttachments and p5 ~= nil then
				ref20.current(p5)
			end

			if p3 ~= nil then
				setComposerText(p3)
				v50((v:Format((creatorAgentChat.getPromptFailureComposerError(p2)))))
			end

			task.spawn(function()
				data2.refreshSession(function(): boolean
					return ref6.current ~= p
				end)
			end)
		end
	end, {
		ref2,
		data.createUniverseOnFirstPrompt,
		v76,
		data.onProjectResolved,
		sessionId,
		v59,
		setState,
		accountId,
		v58,
		setComposerText,
		v50,
		v19,
		setState5,
		v
	})

	local ref22 = React.useRef(v4)
	React.useEffect(function()
		local v78 = v4 and not ref22.current
		ref22.current = v4

		if v6 or not v4 or not v78 and not isAssistantResponding and v21 == nil then
			return
		end

		v58.scrollToBottomUnconditionally()
		task.defer(v58.scrollToBottomUnconditionally)
		task.delay(0.15, v58.scrollToBottomUnconditionally)
	end, {
		v4,
		v6,
		isAssistantResponding,
		v21,
		#messages,
		v58
	})

	React.useEffect(function()
		if ref4.current ~= nil then
			local current2 = ref5.current
			local v78 = sessionId
			local v79

			if current2 == nil or current2.session ~= v8 then
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

		if not (state6 == nil and v8 ~= nil) then
			return
		end

		local resumeSessionKey = getResumeSessionKey(v8) -- inferred equivalent call

		if resumeSessionKey == nil then
			return
		end

		local function attachResumedTurn(p, current2: number?)
			ref6.current += 1
			local current3 = ref6.current
			ref8.current = current2

			if placeId ~= nil then
				v59(placeId, "Loading")
			end

			local createResumedAssistantTurn = creatorAgentChat.createResumedAssistantTurn

			local function fn2(p2)
				v77(current3, p2, nil, nil, nil, v8)
			end

			local v79

			if current2 ~= nil then
				v79 = current2 - 1
			end

			local resumedAssistantTurn = createResumedAssistantTurn(v8, p, fn2, v79, v75(current3), v3)

			v19(resumedAssistantTurn, v8)
			resumedAssistantTurn.start()
			v58.scrollToBottomUnconditionally()
		end

		if v27.activeTurnState == nil or v27.activeTurnItemIndex == nil or v27.activeTurnState.isDone then
			ref8.current = nil

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
			local activeTurnStartSequenceId = v27.activeTurnStartSequenceId

			if ref8.current == activeTurnStartSequenceId and v21 ~= nil then
				return
			end

			local v78 = creatorAgentChatStore.resumeTurnFromHistory(
				resumeSessionKey,
				v27.activeTurnState,
				v27.activeTurnSequenceIds
			)

			if v78 ~= nil then
				attachResumedTurn(v78, activeTurnStartSequenceId)
			end
		end
	end, {
		v27,
		v8,
		sessionId,
		creatorAgentChatStore,
		isAssistantResponding,
		v21,
		placeId,
		v59,
		v77,
		v58,
		v19,
		state6,
		v75,
		v3
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

				local v79 = v29

				local fn2 = engineFeature and p3 ~= nil and function(p6: number?)
					if v79 ~= nil then
						v79(p6)
					end

					v68(p3, p.getCasSessionId() or sessionId)
				end or v79
				local v80

				if FFlagBuildExperienceRestoreStoppedPrompt and ref15 ~= nil then
					local v81 = ref15
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
							if ref4.current == v83 and ref6.current == current2 then
								v19(nil)
								ref8.current = nil
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
					v3,
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

				v19(v83, p)
				v58.scrollToBottomAfterSend()
				v83.start()
			end

			if not FFlagBuildExperienceModelPicker then
				startAdmitted(nil)
				return
			end

			local v79 = ref7
			local v80 = setState8
			local v81 = p4

			if not v81 then
				local entry

				if v10 ~= nil then
					entry = v10.entry
				end

				local creatorCreditStore = CreatorCredit.getCreatorCreditStore(false)
				local promptExperiment = CreatorAgentChat.experimentOverride.getPromptExperiment(CreatorAgentChat.experimentOverride.getKey(p.getCasSessionId()) or v14)

				local v82 = enabled

				if v82 then
					if v14 == nil then
						v82 = false
					else
						v82 = CreatorAgentChat.experimentOverride.getInternalSelection(
							CreatorAgentChat.experimentOverride.getKey(p.getCasSessionId()) or v14,
							false
						).isSelected
					end
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
					local v85 = not attempt.isCurrent() or ref6.current ~= current2

					if v85 or not success or result == nil then
						attempt.release()

						if v79.current == current3 then
							v79.current = nil
							v80(false)
							setState5(nil)
						end

						if v85 then
							if ref6.current == current2 and callback3 ~= nil then
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

							v51(v:Format(v86))
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
			ref7,
			v9,
			setState8,
			v51,
			v,
			v76,
			v77,
			v59,
			v58,
			v19,
			setState5,
			v75,
			v3,
			v29,
			v68,
			sessionId
		}
	)

	local ref23 = React.useRef(v27.latestSequenceId)
	ref23.current = v27.latestSequenceId
	local v80 = useAgentRollbackRequest({
		universeId = universeId,
		placeId = placeId,
		session = v8,
		activeTurnHandleRef = ref4,
		startRollbackTurn = React.useCallback(function(data2, callback, callback2)
			local v80 = v8

			if v80 == nil then
				callback2()
				return
			end

			if FFlagBuildExperienceModelPicker then
				local current2 = ref7.current

				if current2 ~= nil and not current2.started and current2.attempt.isCurrent() then
					callback2()
					return
				end
			end

			v58.captureStickToBottomForSend()
			ref6.current += 1
			local current2 = ref6.current
			setState6(nil)
			local agentRollbackPrompt = buildAgentRollbackPrompt(
				data2.versionNumber,
				data2.noteTitle,
				data2.noteDescription
			)

			v78(v80, agentRollbackPrompt, agentRollbackPrompt, nil, nil, current2, ref23.current, nil, function()
				v58.scrollToBottomUnconditionally()
				callback()
			end, callback2)
		end, { v8, ref7, v58, setState6, v78 })
	})

	React.useLayoutEffect(function()
		if state7 ~= nil then
			local current2 = ref5.current
			local v81 = sessionId
			local v82

			if current2 == nil or current2.session ~= v8 then
				v82 = false
			elseif v81 == nil or v81 == "" or current2.sessionId == v81 then
				v82 = true
			elseif current2.sessionId == nil then
				v82 = current2.session.getCasSessionId() == v81
			else
				v82 = false
			end

			if not v82 then
				local current3 = ref5.current
				ref6.current += 1
				ref8.current = nil

				if v80.stopRequestBeforeReceipt(state7) then
					if current3 ~= nil and current3.session.placeId ~= nil then
						v59(current3.session.placeId, "Idle")
					end
				else
					state7.detach()

					if FFlagBuildExperienceModelPicker then
						local v84 = ref7
						local current4 = v84.current

						if current4 ~= nil and current4.started then
							current4.attempt.unlockSelection()
							v84.current = nil
						end
					end
				end

				v19(nil, nil)
				setState5(nil)
				setState6(nil)
			end
		end
	end, { v8, sessionId, state7, v19, v80, v59, ref7 })

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
			local v84 = v9
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
			local v86 = UniverseCreate.getUniverseCreateStore().createUniverse({
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

				local v87

				if FFlagBuildExperienceModelPicker then
					v87 = not canConfigure() -- inferred equivalent call
				else
					v87 = ref6.current ~= p2
				end

				if v87 then
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
					local v88

					if FFlagBuildExperienceModelPicker then
						v88 = not canConfigure() or v84 == nil or not v84.mounted -- inferred equivalent call
					else
						v88 = ref6.current ~= p2
					end

					if v88 then
						return nil
					end

					local v89 = { universeId = p4.universeId, placeId = p4.rootPlaceId }

					if FFlagBuildExperienceModelPicker then
						local clone = table.clone(v89)
						clone.accountId = accountId
						setState(clone)
					else
						setState(v89)
					end

					if data.onProjectResolved ~= nil then
						data.onProjectResolved(v89)
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
						and (FFlagBuildExperienceModelPicker and CreatorAgentChat.experimentOverride.has(v14) or ref3 ~= nil and ref3.current)
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

				if ref6.current ~= p2 or p3 ~= nil and not p3.isCurrent() then
					return
				end

				if FFlagBuildExperiencePromptFailureTelemetry then
					local v87 = math.round((os.clock() - lastTime) * 1000)
					local v88 = v85 == nil and {} or {
						universeId = v85.universeId,
						placeId = v85.placeId
					}
					local v89 = {
						isContentPolicy = "false",
						setupStage = v85 == nil and "create_universe" or "configure_universe",
						errorCopyKey = LocalizationStrings.CHAT_CREATE_UNIVERSE_ERROR,
						elapsedMs = tostring(v87),
						receivedResponse = "false",
						stalled = tostring(chatConstants.PROMPT_STALL_SECONDS * 1000 <= v87)
					}

					v89.failureKind = RequestFailureKind.Unknown

					if typeof(err) == "table" and typeof(err.responseCode) == "number" then
						v89.failureKind = RequestFailureKind.Http
						v89.httpStatusCode = tostring(err.responseCode)
					end

					sendBuildExperienceEvent("SEND_PROMPT_START", v88)
					sendBuildExperienceEvent("SEND_PROMPT_FAILED", v88, v89)
				end

				v19(nil)
				setState5(nil)
				setComposerText(text)

				if FFlagBuildExperienceChatImageAttachments and images ~= nil then
					ref21.current(images)
				end

				if FFlagBuildExperienceChatResourceAttachments and resourceAttachments ~= nil then
					ref20.current(resourceAttachments)
				end

				if p3 ~= nil then
					p3.release()

					setState8(false)
				end

				v50(formatted)
			end)

			if FFlagBuildExperienceModelPicker then
				v86:finally(function()
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
			v9,
			v10,
			setState3,
			setState8,
			sessionId,
			creatorAgentChatStore,
			data.onProjectResolved,
			data.modelSelectionDraftId,
			v19,
			setComposerText,
			v50,
			setState,
			accountId,
			setState5,
			v78,
			formatted,
			v14,
			ref3
		}
	)

	local sendMessage = React.useCallback(function(callback): boolean
		if not v5 or v9 ~= nil and v9.pending then
			return false
		end

		local text = trimMessage(ref9.current) -- inferred equivalent call

		local v84 = not FFlagBuildExperienceChatImageAttachments and {} or v54.current

		local v85 = not FFlagBuildExperienceChatResourceAttachments and {} or v56.current

		if text == "" and #v84 == 0 then
			setComposerText("")
			return false
		end

		if FFlagBuildExperienceChatImageAttachments then
			for _, v86 in v84 do
				if v86.uri == nil or v86.uploadStatus == "uploading" or v86.uploadStatus == "failed" then
					return false
				end
			end
		end

		local current2 = ref5.current
		local v86 = sessionId
		local v87

		if current2 == nil or current2.session ~= v8 then
			v87 = false
		elseif v86 == nil or v86 == "" or current2.sessionId == v86 then
			v87 = true
		elseif current2.sessionId == nil then
			v87 = current2.session.getCasSessionId() == v86
		else
			v87 = false
		end

		local current3

		if v87 then
			current3 = ref4.current
		end

		if isAssistantResponding or v6 and current3 ~= nil then
			if
				FFlagBuildExperienceChatImageAttachments and #v84 > 0
				or FFlagBuildExperienceChatResourceAttachments and #v85 > 0
				or (current3 == nil or not current3.trySubmitComposerText(text))
			then
				return false
			end

			setComposerText("")

			if ref18.current then
				ref18.current.releaseFocus()
			end

			v58.scrollToBottomAfterSend()
			return true
		else
			local v88

			if data.createUniverseOnFirstPrompt == true then
				v88 = universeId == nil
			else
				v88 = false
			end

			if
				not v88 and v8 == nil
				or placeId ~= nil and agentRollbackRequestStore.getIsPendingForPlaceId(placeId)(false)
			then
				return false
			end

			local function restoreDraft(flag: boolean)
				if
					flag
					and (ref9.current ~= "" or FFlagBuildExperienceChatImageAttachments and #v54.current > 0 or FFlagBuildExperienceChatResourceAttachments and #v56.current > 0)
				then
					return
				end

				setComposerText(text)

				if FFlagBuildExperienceChatImageAttachments then
					ref21.current(v84)
				end

				if FFlagBuildExperienceChatResourceAttachments then
					ref20.current(v85)
				end
			end

			local attempt

			if FFlagBuildExperienceModelPicker then
				v50(nil)
				local entry

				if v10 ~= nil then
					entry = v10.entry
				end

				local creatorCreditStore = CreatorCredit.getCreatorCreditStore(false)
				local getPromptExperiment = CreatorAgentChat.experimentOverride.getPromptExperiment
				local getKey = CreatorAgentChat.experimentOverride.getKey
				local v90

				if v8 ~= nil then
					v90 = v8.getCasSessionId()
				end

				local promptExperiment = getPromptExperiment(getKey(v90) or v14)

				local v91 = enabled

				if v91 then
					if v14 == nil then
						v91 = false
					else
						local getInternalSelection = CreatorAgentChat.experimentOverride.getInternalSelection
						local getKey2 = CreatorAgentChat.experimentOverride.getKey
						local v92

						if v8 ~= nil then
							v92 = v8.getCasSessionId()
						end

						v91 = getInternalSelection(getKey2(v92) or v14, false).isSelected
					end
				end

				attempt = beginBuildModelSend(entry, creatorCreditStore, promptExperiment, v91)

				if attempt == nil then
					return false
				end

				ref7.current = { attempt = attempt, started = false, restoreDraft = restoreDraft }

				setState8(true)
			else
				attempt = nil
			end

			v58.captureStickToBottomForSend()
			ref6.current += 1
			local current4 = ref6.current
			setState6(nil)

			if engineFeature then
				v67(text)
			end

			v63("")

			if FFlagBuildExperienceChatImageAttachments then
				ref21.current({})
			end

			if FFlagBuildExperienceChatResourceAttachments then
				ref20.current({})
			end

			if ref18.current then
				ref18.current.releaseFocus()
			end

			local function startPrompt(p, p2)
				if v88 then
					local latestSequenceId = v27.latestSequenceId
					local v92

					if FFlagBuildExperienceModelPicker then
						v92 = restoreDraft
					end

					v81(text, p, p2, v85, current4, latestSequenceId, attempt, v92)
				else
					local latestSequenceId = v27.latestSequenceId
					local v93

					if FFlagBuildExperienceLibrary then
						v93 = callback
					end

					local v95

					if FFlagBuildExperienceModelPicker then
						v95 = restoreDraft
					end

					v78(v8, text, p, p2, v85, current4, latestSequenceId, text, nil, nil, v93, attempt, v95)
				end
			end

			if #v84 == 0 and #v85 == 0 then
				startPrompt(text, nil)
				return true
			end

			local v91 = {}

			if text ~= "" then
				table.insert(v91, { type = "text", text = text })
			end

			for _, v92 in v85 do
				if v92.type == "resource_link" then
					table.insert(v91, {
						type = v92.type,
						uri = v92.uri,
						name = v92.name,
						mimeType = v92.mimeType
					})
				else
					table.insert(v91, {
						type = v92.type,
						resource = {
							uri = v92.resource.uri,
							text = v92.resource.text,
							blob = nil,
							mimeType = v92.resource.mimeType
						}
					})
				end
			end

			local v92 = {}

			for _, v93 in v84 do
				local uri = v93.uri
				table.insert(v91, { type = "image", uri = uri })
				table.insert(v92, { capture = v93.capture, uri = uri, uploadStatus = "uploaded" })
			end

			startPrompt(v91, v92)
			return true
		end
	end, {
		v5,
		v9,
		v10,
		v14,
		ref7,
		setState8,
		v50,
		v8,
		sessionId,
		universeId,
		placeId,
		isAssistantResponding,
		v6,
		v58,
		setComposerText,
		v63,
		v67,
		v81,
		v78,
		data.createUniverseOnFirstPrompt,
		setState6,
		v27,
		agentRollbackRequestStore
	})

	local useCallback = React.useCallback
	local function fn2()
		if FFlagBuildExperienceModelPicker then
			local v83 = ref7
			local current2 = v83.current

			if current2 ~= nil and not current2.started then
				current2.attempt.release()
				v83.current = nil

				setState8(false)

				if not current2.started then
					ref6.current += 1
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

		local current2 = ref5.current
		local v83 = sessionId
		local v84

		if current2 == nil or current2.session ~= v8 then
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
			current3 = ref4.current
		end

		if current3 == nil then
			v80.cancelRequestBeforeTurnStarts()
		elseif FFlagBuildExperienceModelPicker then
			if FFlagBuildExperiencePromptFailureTelemetry and current3.reportUserStop ~= nil then
				current3.reportUserStop()
			end

			current3.stop()
		else
			local current4 = ref6.current
			ref6.current += 1

			if FFlagBuildExperiencePromptFailureTelemetry and current3.reportUserStop ~= nil then
				current3.reportUserStop()
			end

			if not v80.stopRequestBeforeReceipt(current3) then
				current3.stop()
			end

			v19(nil)
			ref8.current = nil

			if
				FFlagBuildExperienceRestoreStoppedPrompt
				and ref15 ~= nil
				and ref15.current ~= current4
				and state5 ~= nil
				and ref9.current == ""
				and v27.isAwaitingUserMessageEcho
			then
				setComposerText(state5.text)

				if FFlagBuildExperienceChatImageAttachments and state5.images ~= nil and #v54.current == 0 then
					ref21.current(state5.images)
				end

				if
					FFlagBuildExperienceChatResourceAttachments
					and state5.resourceAttachments ~= nil
					and #v56.current == 0
				then
					ref20.current(state5.resourceAttachments)
				end
			end

			setState5(nil)
			setState6({
				session = v8,
				sessionId = v8.getCasSessionId(),
				startSequenceId = v27.activeTurnStartSequenceId
			})

			if placeId ~= nil then
				v59(placeId, "Idle")
			end
		end
	end

	local v84

	if FFlagBuildExperienceRestoreStoppedPrompt then
		v84 = state5
	end

	local v85

	if FFlagBuildExperienceRestoreStoppedPrompt then
		v85 = setComposerText
	end

	local stopAssistantResponse = useCallback(fn2, {
		ref7,
		setState8,
		v8,
		sessionId,
		placeId,
		v59,
		v19,
		setState5,
		setState6,
		v27,
		v80,
		v84,
		v85
	})

	local v87 = data.autoFocusComposer == nil or data.autoFocusComposer
	local v88

	if data.focusComposerWhen == nil then
		v88 = v87
	else
		v88 = data.focusComposerWhen
	end

	React.useEffect(function()
		if not (v87 and v88) then
			return function() end
		end

		local v89 = false
		local function fn3()
			return v89
		end

		scheduleComposerAutoFocus(ref18, fn3) -- inferred equivalent call
		return function()
			v89 = true
		end
	end, { v87, v88 })

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

			for k, v93 in v25.onAnswerSelectedByToolCallId do
				onAnswerSelectedByToolCallId[k] = function(p, p2, flag: boolean?)
					v50(nil)
					v93(p, p2, flag)
				end
			end

			local onAnswerConfirmedByToolCallId = {}

			for k, v94 in v25.onAnswerConfirmedByToolCallId do
				onAnswerConfirmedByToolCallId[k] = function()
					v50(nil)
					v94()
				end
			end

			return {
				onAnswerSelectedByToolCallId = onAnswerSelectedByToolCallId,
				onAnswerConfirmedByToolCallId = onAnswerConfirmedByToolCallId,
				onPlanAcceptedByToolCallId = v25.onPlanAcceptedByToolCallId,
				onDevProductApprovedByToolCallId = v25.onDevProductApprovedByToolCallId,
				onDevProductRejectedByToolCallId = v25.onDevProductRejectedByToolCallId
			}
		end, { v25, v50 })
	else
		localToolActions = v25
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
			local current2 = ref4.current

			if current2 == nil then
				return false
			end

			local current3 = ref5.current
			local v94 = sessionId
			local v95

			if current3 == nil or current3.session ~= v8 then
				v95 = false
			elseif v94 == nil or v94 == "" or current3.sessionId == v94 then
				v95 = true
			elseif current3.sessionId == nil then
				v95 = current3.session.getCasSessionId() == v94
			else
				v95 = false
			end

			if v95 then
				v50(nil)
				return current2.trySubmitAnswerText(p, p2, p3)
			end

			return false
		end, { v8, sessionId, v50 })
	end

	local v94 = {}
	v94.currentSessionId = v13
	v94.internalTesting = internalTesting
	v94.agentSpecVersion = agentSpecVersion
	v94.setAgentSpecVersion = setAgentSpecVersion
	v94.messages = messages
	v94.localToolActions = localToolActions
	v94.answerForm = answerForm
	v94.submitAnswerText = submitAnswerText
	v94.composerText = composerText
	v94.composerErrorText = state9
	v94.fundingFailure = state13
	v94.setComposerText = setComposerText
	v94.setPrefilledComposerText = setPrefilledComposerText
	v94.composerImages = not FFlagBuildExperienceChatImageAttachments and {} or state11
	v94.setComposerImages = setComposerImages
	v94.retryComposerImage = retryComposerImage
	v94.composerResourceAttachments = not FFlagBuildExperienceChatResourceAttachments and {} or state12
	v94.findComposerResourceAttachmentIndexByUri = findComposerResourceAttachmentIndexByUri
	v94.addComposerResourceAttachment = addComposerResourceAttachment
	v94.removeComposerResourceAttachmentAtIndex = removeComposerResourceAttachmentAtIndex
	v94.clearComposerResourceAttachments = clearComposerResourceAttachments
	local hasPreparedModelSession

	if FFlagBuildExperienceModelPicker then
		if v10 == nil then
			hasPreparedModelSession = false
		else
			hasPreparedModelSession = v10.hasObservedModels
		end
	end

	v94.hasPreparedModelSession = hasPreparedModelSession
	local modelSessionModels

	if FFlagBuildExperienceModelPicker and v10 ~= nil then
		modelSessionModels = v10.models
	end

	v94.modelSessionModels = modelSessionModels

	if not (FFlagBuildExperienceChatImageAttachments and isComposerSendBlocked) then
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

	v94.isComposerSendBlocked = isComposerSendBlocked

	v94.isAssistantResponding = isAssistantResponding
	v94.canStopAssistantResponse = v21 ~= nil or (v45 or FFlagBuildExperienceModelPicker and state8)

	v94.canSendWhileResponding = canSendWhileResponding
	v94.sendMessage = sendMessage
	v94.stopAssistantResponse = stopAssistantResponse
	v94.setScrollingFrame = v58.setScrollingFrame
	local anchorScrollToInstance

	if FFlagBuildExperienceChatAccordionScrollAnchor then
		anchorScrollToInstance = v58.anchorToInstance
	end

	v94.anchorScrollToInstance = anchorScrollToInstance

	v94.textBoxRef = ref18
	v94.clockBinding = clockBinding
	v94.playtestPlaceId = placeId

	if placeId == nil then
		launchPlaytest = nil
	end

	v94.launchPlaytest = launchPlaytest
	v94.hasPublishedTurn = includesPublishTool
	v94.subagentTaskState = subagentTaskState
	v94.isHistoryHydrationComplete = isHistoryHydrationComplete
	v94.isHistoryLoading = isHistoryLoading
	v94.isHistoryExhausted = v32 and not v30
	return v94
end

return useChatSessionCore
