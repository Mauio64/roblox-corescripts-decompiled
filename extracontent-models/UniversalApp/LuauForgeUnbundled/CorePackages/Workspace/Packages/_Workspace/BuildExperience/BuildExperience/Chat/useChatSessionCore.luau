local FFlagBuildExperienceChatImageAttachments = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceChatImageAttachments")

local fFlagBuildExperienceChatResourceAttachments = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SharedFlags").FFlagBuildExperienceChatResourceAttachments
local FFlagBuildExperienceModelPicker = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceModelPicker")
local engineFeature = game:GetEngineFeature("BuildAppStorageKey")

local FFlagBuildExperienceRefreshChatDraftOnGameLeave = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceRefreshChatDraftOnGameLeave")

local FFlagBuildExperiencePrefillSkipsDraftPersist = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperiencePrefillSkipsDraftPersist")

local MessageBusService = game:GetService("MessageBusService")
local AppLifecycleObserverService = game:GetService("AppLifecycleObserverService")

local CreatorAgentChat = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/CreatorAgentChat")
local UniverseConfiguration = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/UniverseConfiguration")
local UniverseCreate = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/UniverseCreate")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local ReactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/ReactUtils")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SharedFlags")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SignalsReact")
local localizationRoactContext = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Localization").LocalizationRoactContext
local LocalizationStrings = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/LocalizationStrings")

local FFlagBuildExperienceChatAccordionScrollAnchor = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceChatAccordionScrollAnchor")
local FFlagBuildExperienceChatHistoryPrefetch = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceChatHistoryPrefetch")
local FFlagBuildExperienceManageDevProduct = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceManageDevProduct")
local FFlagBuildAdUpsell = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildAdUpsell")
local fFlagBuildExperienceLibrary = SharedFlags.FFlagBuildExperienceLibrary
local fFlagBuildExperiencePromptFailureTelemetry = SharedFlags.FFlagBuildExperiencePromptFailureTelemetry
local FFlagBuildExperienceNewGameChatDraft = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceNewGameChatDraft")
local FFlagBuildExperienceRestoreStoppedPrompt = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceRestoreStoppedPrompt")

local chatConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/chatConstants")
local chatTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/chatTypes")
local creatorAgentChat = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/creatorAgentChat")
local getNewGameChatDraftKey = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/getNewGameChatDraftKey")
local parseSessionStream = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/parseSessionStream")
local FFlagBuildExperienceAnswerForm = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceAnswerForm")

local v5 = if FFlagBuildExperienceAnswerForm then require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/getActiveAnswerForm") else nil

local sessionPromptMessageFilter = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/sessionPromptMessageFilter")
local useAgentRollbackRequest = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/useAgentRollbackRequest")
local useChatScroll = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/useChatScroll")
local buildAgentRollbackPrompt = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/utils/buildAgentRollbackPrompt")
local beginBuildModelSend = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/beginBuildModelSend")
local useBuildModelSession = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/useBuildModelSession")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/ModelPicker/ModelPickerTypes")
local GetBuildCreatorCreditRefreshStore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Stores/GetBuildCreatorCreditRefreshStore")
local localUserIdStore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/LocalUserIdStore").LocalUserIdStore
local CreatorCredit = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/CreatorCredit")
local GetBuildModelSelectionStore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Stores/GetBuildModelSelectionStore")
local GetAgentRollbackRequestStore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Stores/GetAgentRollbackRequestStore")
local GetPlaytestLoadingStore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperiencePlaytestLaunch/GetPlaytestLoadingStore")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperiencePlaytestLaunch/createPlaytestLoadingStore")
local getDefaultTemplatePlaceId = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/utils/getDefaultTemplatePlaceId")
local launchPlaytestWithLoadingState = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperiencePlaytestLaunch/launchPlaytestWithLoadingState")
local enabled = CreatorAgentChat.experimentOverride.isEnabled()

local v6 = if FFlagBuildExperienceModelPicker and enabled then require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/useBuildInternalTesting") else nil

local v7 = if engineFeature then require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Storage/BuildAppStorage") else nil

local v8 = if FFlagBuildExperienceChatImageAttachments then require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/utils/uploadCaptureAsync") else nil

local Debug = CreatorAgentChat.debug
local requestFailureKind = CreatorAgentChat.RequestFailureKind
local sendBuildExperienceEvent = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Telemetry/sendBuildExperienceEvent")
local signal = Signals.createSignal(false)
local function noopSetAgentSpecVersion(p2) end

local frozen = table.freeze({})

local v9 = {
	CreateUniverse = "create_universe",
	ConfigureUniverse = "configure_universe"
}

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

local function sessionOwnerMatches(p2, p3, p4)
	if p2 == nil or p2.session ~= p3 then
		return false
	end

	if p4 == nil or p4 == "" then
		return true
	end

	local v10 = p2.sessionId == p4 or p2.sessionId == nil and p2.session.getCasSessionId() == p4
	return v10
end

local function isEvolvingAdUpsellScope(p2, p3, p4)
	local v10 = p2.universeId == nil or p3 == nil or p2.universeId == p3
	local v11 = p2.sessionId == nil or p4 == nil or p2.sessionId == p4
	return v10 and v11
end

local function getCompletedTurnSequenceId(data)
	if
		data.kind == "assistant_turn"
		and data.isDone
		and data.isOptimisticallyCancelled ~= true
		and data.turnState ~= nil
	then
		return data.endSequenceId or data.startSequenceId
	end

	return nil
end

local function getTurnId(p2)
	local turnFeedbackIds = p2.turnFeedbackIds

	if turnFeedbackIds == nil or typeof(turnFeedbackIds) == "function" then
		return nil
	end

	return turnFeedbackIds.turnId
end

local function noteLiveAdUpsellTurns(data, messages)
	for k, item in messages do
		if not (item.kind == "assistant_turn" and item.startSequenceId ~= nil) then
			continue
		end

		local turnFeedbackIds = item.turnFeedbackIds
		local turnId

		if not (turnFeedbackIds == nil or typeof(turnFeedbackIds) == "function") then
			turnId = turnFeedbackIds.turnId
		end

		local v10 = not (turnId == nil) and data.liveTurnIds[turnId] == true
		local historyWatermarkSequenceId = data.historyWatermarkSequenceId
		local v11 = not item.isDone

		if v11 then
			if historyWatermarkSequenceId == nil then
				v11 = false
			else
				v11 = historyWatermarkSequenceId < item.startSequenceId
			end
		end

		if v10 or v11 then
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

local function trimMessage(value)
	return string.gsub(value, "^%s*(.-)%s*$", "%1")
end

local function scheduleComposerAutoFocus(p2, callback)
	local v10 = 8
	local function tryFocus()
		if callback() then
			return
		end

		local current = p2.current

		if current then
			current.focus()
			return
		end

		v10 -= 1

		if v10 > 0 then
			task.delay(0, tryFocus)
		end
	end
	task.defer(tryFocus)
end

local function getResumeSessionKey(data)
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

local function getLiveAssistantMessage(p2, p3, p4, p5, p6)
	local v10 = p3 == true and p4 == nil and p5 ~= nil

	if p2 == nil and not v10 then
		return nil
	end

	return { setupErrorText = p6 }
end

local function useChatSessionCore(data)
	if FFlagBuildExperienceModelPicker then
		React.useEffect(function()
			return GetBuildCreatorCreditRefreshStore(false).acquire()
		end, {})
	end

	local v10 = React.useContext(localizationRoactContext)
	local formatted = v10:Format(LocalizationStrings.CHAT_CREATE_UNIVERSE_ERROR)

	local v11 = if FFlagBuildExperienceChatImageAttachments then v10:Format(LocalizationStrings.CHAT_CAPTURE_UPLOAD_ERROR) else nil

	local v12 = if FFlagBuildExperienceModelPicker then SignalsReact.useSignalState(localUserIdStore.getCurrentUserId) else nil

	local state, setState = React.useState(nil)
	local state2, setState2 = React.useState(nil)

	if FFlagBuildExperienceModelPicker and state ~= nil and state.accountId ~= v12 then
		state = nil
	end

	if FFlagBuildExperienceModelPicker and state2 ~= nil and state2.accountId ~= v12 then
		state2 = nil
	end

	local ref = React.useRef(true)
	local v13 = React.useCallback(function()
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

	local v14 = data.hydrateHistoryWhen == nil or data.hydrateHistoryWhen
	local v15 = data.sendMessageWhen == nil or data.sendMessageWhen
	local v16 = fFlagBuildExperienceLibrary and data.isLibraryChat == true

	local v17 = if FFlagBuildAdUpsell then React.useRef(data.trackAdUpsellTurns == true).current else false

	local creatorAgentChatStore = CreatorAgentChat.getCreatorAgentChatStore()
	local v18 = GetAgentRollbackRequestStore()

	local v19 = React.useMemo(function()
		if universeId == nil then
			return nil
		end

		return creatorAgentChatStore.getSessionForProject(universeId, placeId, sessionId)
	end, { universeId, placeId, sessionId, creatorAgentChatStore, v12 })

	React.useLayoutEffect(function()
		if v19 == nil or sessionId == nil or sessionId == "" then
			return
		end

		v19.setCasSessionId(sessionId)
	end, { v19, sessionId })
	local v20, state3, setState3, v21

	if FFlagBuildExperienceModelPicker then
		local ref2 = React.useRef(true)

		React.useLayoutEffect(function()
			ref2.current = true
			return function()
				ref2.current = false
			end
		end, { ref2 })

		v20 = React.useMemo(function()
			return { pending = false, mounted = true }
		end, {
			v12,
			data.modelSelectionDraftId,
			data.universeId,
			data.placeId,
			data.sessionId
		})

		state3, setState3 = React.useState(false)
		local v22 = v20
		local v23 = setState3

		React.useLayoutEffect(function()
			v22.mounted = true
			v23(false)
			return function()
				v22.mounted = false
			end
		end, { v22, v23 })
		v21 = ref2
	else
		v21 = nil
		v20 = nil
		setState3 = nil
		state3 = false
	end

	local v22 = if FFlagBuildExperienceModelPicker then useBuildModelSession(universeId, data.modelSelectionDraftId, v19) else nil

	local v23 = React.useMemo(function()
		if v19 == nil then
			return signal5
		end

		return Signals.createComputed(function(p2)
			return {
				session = v19,
				sessionId = v19.getCasSessionId(),
				events = v19.getMergedHistory(p2)
			}
		end)
	end, { v19 })
	local v24 = SignalsReact.useSignalState(v23)
	local v25 = if v19 ~= nil then v19.getCasSessionId() else nil
	local v26 = nil
	local setAgentSpecVersion = noopSetAgentSpecVersion
	local v27 = nil
	local v28 = nil
	local v29 = nil

	if FFlagBuildExperienceModelPicker and enabled then
		local entry = if v22 ~= nil then v22.entry else nil
		local v31
		v31, v27 = v6(entry, v19, data.sessionId)
		v29 = v31

		if v29 ~= nil then
			v26 = v29.previewHash
		end

		setAgentSpecVersion = function(p2)
			if v29 ~= nil then
				v29.onSelect()
				v29.onSaveSpec(p2)
			end
		end
	elseif enabled then
		local ref2 = React.useRef(nil)

		if ref2.current == nil then
			ref2.current = CreatorAgentChat.experimentOverride.createPendingKey()
		end

		local current = ref2.current

		local ref3 = React.useRef(false)

		local v30 = CreatorAgentChat.experimentOverride.getKey(v25) or current

		local v31 = React.useMemo(function()
			return CreatorAgentChat.experimentOverride.getStateSignal(v30)
		end, { v30 })

		v26 = SignalsReact.useSignalState(v31).specVersion

		setAgentSpecVersion = React.useCallback(function(p2)
			local v32 = if v19 ~= nil then v19.getCasSessionId() else nil
			local v33 = CreatorAgentChat.experimentOverride.getKey(v32)

			if v33 == nil then
				v33 = current
				ref3.current = true

				if v19 ~= nil then
					v19.setPendingExperimentKey(current)
				end
			end

			CreatorAgentChat.experimentOverride.set(v33, p2)
		end, { v19, current })

		React.useEffect(function()
			if v19 == nil or not ref3.current then
				return
			end

			v19.setPendingExperimentKey(current)
		end, { v19, current })

		React.useEffect(function()
			return function()
				CreatorAgentChat.experimentOverride.clear(current)
			end
		end, { current })
		v28 = ref3
		v27 = current
	end

	local v30 = (v24.session ~= v19 or v24.sessionId ~= v25) and {} or v24.events
	local v31 = not (sessionId == nil) and sessionId ~= ""

	if not v31 then
		v31 = not (universeId == nil) and universeId ~= 0
	end

	local v32

	if v14 then
		v32 = not (v19 == nil) and (if v31 then not (v19.hasLoadedHistory() and #v30 > 0) else v31)
	else
		v32 = v14
	end

	local state4, setState4 = React.useState(function()
		return {
			session = v19,
			sessionId = sessionId,
			universeId = universeId,
			hydrateHistoryWhen = v14,
			isLoading = v32
		}
	end)
	local v34

	if
		state4 == nil
		or state4.session ~= v19
		or state4.sessionId ~= sessionId
		or state4.universeId ~= universeId
	then
		v34 = false
	else
		v34 = state4.hydrateHistoryWhen == v14
	end

	local v35 = if v34 then not state4.isLoading else not v32

	local v36 = not v35

	if not v36 then
		v36 = not (v19 == nil) and v19.getNextHistoryPageToken() ~= nil
	end

	local state5, setState5 = React.useState(nil)

	local state6, setState6 = React.useState(nil)

	React.useEffect(function()
		setState6(nil)
	end, { v19, sessionId })
	local v37 = sessionId
	local v38

	if state6 == nil or state6.session ~= v19 then
		v38 = false
	elseif v37 == nil or v37 == "" or state6.sessionId == v37 then
		v38 = true
	else
		v38 = state6.sessionId == nil and state6.session.getCasSessionId() == v37
	end

	if not v38 then
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
		local v39 = ref5
		local v40 = setState8

		local function fn()
			if
				enabled
				and v39.current ~= nil
				and not v39.current.started
				and ref3.current ~= nil
				and data.sessionId ~= nil
				and data.sessionId ~= ""
				and ref3.current.sessionId ~= data.sessionId
			then
				v39.current.attempt.release()
				v39.current = nil
			end

			if v39.current == nil then
				v40(false)
				setState5(nil)
			end

			return function()
				local current = v39.current

				if current ~= nil and not (current.started and current.attempt.isCurrent()) then
					current.attempt.release()
					v39.current = nil

					if current.onTerminal ~= nil then
						current.onTerminal()
					end
				end
			end
		end

		React.useLayoutEffect(fn, {
			if v22 ~= nil then v22.entry else nil,
			data.sessionId,
			v40,
			setState5
		})
	else
		ref5 = nil
		setState8 = nil
		state8 = false
	end

	local ref6 = React.useRef(nil)

	local v39 = React.useCallback(function(current, p2)
		assert(current == nil or p2 ~= nil, "Active turns require an owning session")
		ref2.current = current
		ref3.current = current ~= nil and {
			session = p2,
			sessionId = p2.getCasSessionId()
		} or nil

		setState7(current)
	end, { setState7 })

	local current = ref3.current
	local v40 = sessionId
	local v41

	if current == nil or current.session ~= v19 then
		v41 = false
	elseif v40 == nil or v40 == "" or current.sessionId == v40 then
		v41 = true
	else
		v41 = current.sessionId == nil and current.session.getCasSessionId() == v40
	end

	local v42 = if v41 then state7 else nil
	local v43 = if v42 == nil then signal2 else v42.getOptimisticLocalTools

	local v44 = if v42 == nil then signal3 else v42.getLocalToolActions

	local v45 = if v42 == nil then signal4 else v42.getSetupErrorText

	local v46 = SignalsReact.useSignalState(v43)
	local v47 = SignalsReact.useSignalState(v44)
	local v48 = SignalsReact.useSignalState(v45)

	if v48 ~= nil then
		v48 = v10:Format(v48)
	end

	local v49 = React.useMemo(function()
		local v52 = state5
		local v54 = data.createUniverseOnFirstPrompt == true and v19 == nil and v52 ~= nil

		if v42 == nil and not v54 then
			return nil
		end

		return { setupErrorText = v48 }
	end, { v42, data.createUniverseOnFirstPrompt, state5, v19, v48 })

	local v50 = React.useMemo(function()
		local v54 = if v19 == nil then sessionId else v19.getCasSessionId() or sessionId
		local v55 = if v19 == nil then universeId else v19.universeId
		local v56 = if v19 == nil then placeId else v19.placeId
		local v53 = {
			sessionId = v54,
			universeId = v55,
			placeId = v56,
			optimisticLocalTools = v46,
			pendingUserMessage = 0,
			pendingUserImages = 0,
			pendingUserResourceAttachments = 0,
			pendingUserMessageAfterSequenceId = 0,
			liveAssistantMessage = 0,
			optimisticCancelledStartSequenceId = 0
		}

		local v57 = if state5 ~= nil and not not sessionPromptMessageFilter.shouldOptimisticallyDisplay(state5.text) then state5.text else nil
		v53.pendingUserMessage = v57

		local v58 = if FFlagBuildExperienceChatImageAttachments and state5 ~= nil and sessionPromptMessageFilter.shouldOptimisticallyDisplay(state5.text) then state5.images else nil
		v53.pendingUserImages = v58

		local v59 = if fFlagBuildExperienceChatResourceAttachments and state5 ~= nil and sessionPromptMessageFilter.shouldOptimisticallyDisplay(state5.text) then state5.resourceAttachments else nil
		v53.pendingUserResourceAttachments = v59

		local v60 = if state5 ~= nil then state5.afterSequenceId else nil
		v53.pendingUserMessageAfterSequenceId = v60

		v53.liveAssistantMessage = v49

		local v61 = if state6 ~= nil then state6.startSequenceId else nil
		v53.optimisticCancelledStartSequenceId = v61
		return parseSessionStream(v30, v53)
	end, {
		v30,
		v19,
		sessionId,
		universeId,
		placeId,
		v46,
		state5,
		v49,
		state6
	})
	local v51

	if v17 then
		local useRef = React.useRef
		local v52 = {
			isInitialized = false,
			universeId = universeId,
			sessionId = 0,
			historyWatermarkSequenceId = 0,
			lastProcessedSequenceId = nil,
			liveTurnIds = 0,
			liveTurnStartSequenceIds = 0
		}

		local v53 = if v19 == nil then sessionId else v19.getCasSessionId() or sessionId
		v52.sessionId = v53
		v52.historyWatermarkSequenceId = v50.latestSequenceId

		v52.liveTurnIds = {}
		v52.liveTurnStartSequenceIds = {}
		v51 = useRef(v52)
	else
		v51 = nil
	end

	local v52

	if v51 == nil then
		v52 = nil
	else
		v52 = React.useCallback(function(p2)
			if p2 ~= nil then
				v51.current.liveTurnIds[p2] = true
			end
		end, { v51 })
	end

	local messages = v50.messages
	local v53 = not (v19 == nil) and v19.getNextHistoryPageToken() ~= nil
	local v54 = v19 == nil or (not v31 or v19.hasLoadedHistory())

	local v55 = v35 and v54 and (v19 == nil or #messages > 0 or not v53)

	local subagentTaskState = v50.subagentTaskState
	local includesPublishTool = v50.includesPublishTool
	local message = messages[#messages]
	local v57 = React.useMemo(function()
		if placeId == nil then
			return signal
		end

		return v18.getIsPendingForPlaceId(placeId)
	end, { placeId, v18 })

	local v58 = SignalsReact.useSignalState(v57)
	local v59

	if v42 == nil then
		if message == nil or message.kind ~= "assistant_turn" then
			v59 = v58
		else
			v59 = not message.isDone or v58
		end
	else
		v59 = true
	end

	local v60 = v59 and not v58 and hasPendingLocalToolResponse(v46)

	local activeTurnState = v50.activeTurnState
	React.useEffect(function()
		if v42 == nil or activeTurnState == nil then
			return
		end

		v42.syncFromTurnState(activeTurnState)
	end, { v42, activeTurnState })

	if v17 then
		React.useEffect(function()
			local onAssistantTurnCompleted = data.onAssistantTurnCompleted

			local v61 = v51
			local v62 = if v19 == nil then universeId else v19.universeId or universeId
			local v63 = if v19 == nil then sessionId else v19.getCasSessionId() or sessionId
			local v64 = v61.current
			local v65 = v64.universeId == nil or v62 == nil or v64.universeId == v62
			local v66 = v64.sessionId == nil or v63 == nil or v64.sessionId == v63

			if v65 and v66 then
				v64.universeId = v62 or v64.universeId
				v64.sessionId = v63 or v64.sessionId
			else
				v64 = {
					isInitialized = false,
					universeId = v62,
					sessionId = v63,
					historyWatermarkSequenceId = v50.latestSequenceId,
					lastProcessedSequenceId = nil,
					liveTurnIds = {},
					liveTurnStartSequenceIds = {}
				}

				v61.current = v64
			end

			if v55 then
				if not v64.isInitialized then
					v64.isInitialized = true
					noteLiveAdUpsellTurns(v64, messages)
					local v67 = nil

					for k in v64.liveTurnStartSequenceIds do
						if v67 == nil or k < v67 then
							v67 = k
						end
					end

					if v67 == nil then
						v64.lastProcessedSequenceId = v64.historyWatermarkSequenceId or v50.latestSequenceId
					else
						v64.lastProcessedSequenceId = v67 - 1
					end

					v64.liveTurnIds = {}
					v64.liveTurnStartSequenceIds = {}
				end

				if v62 == nil or v62 == 0 then
					return
				end

				local v67 = v64.lastProcessedSequenceId or -1

				for k, message2 in messages do
					local endSequenceId

					if
						message2.kind == "assistant_turn"
						and message2.isDone
						and message2.isOptimisticallyCancelled ~= true
						and message2.turnState ~= nil
					then
						endSequenceId = message2.endSequenceId or message2.startSequenceId
					end

					if endSequenceId == nil or endSequenceId <= v67 then
						continue
					end

					if onAssistantTurnCompleted ~= nil then
						onAssistantTurnCompleted({
							universeId = v62,
							sessionId = message2.sessionId or v63,
							turnState = message2.turnState,
							latestSequenceId = endSequenceId
						})
					end

					v64.lastProcessedSequenceId = endSequenceId
					v67 = endSequenceId
				end
			else
				v64.historyWatermarkSequenceId = v64.historyWatermarkSequenceId or v50.latestSequenceId
				noteLiveAdUpsellTurns(v64, messages)
			end
		end, {
			data.onAssistantTurnCompleted,
			v19,
			universeId,
			sessionId,
			v55,
			messages,
			v50.latestSequenceId
		})
	end

	local v61, v62 = React.useBinding("")
	local state9, setState9 = React.useState(nil)

	local state10, setState10 = React.useState(false)
	local v63 = React.useCallback(function(p2)
		setState9(p2)
		setState10(false)
	end, {})
	local v64 = React.useCallback(function(p2)
		setState9(p2)
		setState10(true)
	end, {})
	local ref7 = React.useRef("")
	local ref8 = React.useRef("")

	local ref9 = if FFlagBuildExperiencePrefillSkipsDraftPersist and engineFeature then React.useRef(nil) else nil

	local ref10 = React.useRef(nil)
	local ref11 = React.useRef(v25)
	local ref12 = React.useRef(nil)
	ref11.current = v25

	local v65 = data.createUniverseOnFirstPrompt == true and universeId == nil
	local createUniverseOnFirstPrompt = data.createUniverseOnFirstPrompt == true
	local v66 = not FFlagBuildExperienceNewGameChatDraft and { current = createUniverseOnFirstPrompt }
		or React.useRef(createUniverseOnFirstPrompt)

	v66.current = createUniverseOnFirstPrompt

	local ref13 = if FFlagBuildExperienceRestoreStoppedPrompt then React.useRef(nil) else nil

	local state11 = not v16 and {} or frozen

	local ref14 = React.useRef({})
	local ref15 = React.useRef(0)
	local setState11, v67

	if FFlagBuildExperienceChatImageAttachments then
		state11, setState11 = React.useState({})

		v67 = React.useRef({})
	else
		v67 = { current = {} }
		setState11 = nil
	end

	local v68 = {
		current = { universeId = data.universeId, placeId = data.placeId }
	}
	local state12, setState12, v69

	if fFlagBuildExperienceChatResourceAttachments then
		state12, setState12 = React.useState({})

		v69 = React.useRef({})

		v68 = React.useRef({ universeId = data.universeId, placeId = data.placeId })
	else
		v69 = { current = {} }
		setState12 = nil
		state12 = {}
	end

	local ref16 = React.useRef(nil)
	local v70 = ReactUtils.useClock()

	local v71 = useChatScroll(v16)

	local v72 = React.useCallback(function(p2, p3)
		GetPlaytestLoadingStore().setAgentStatusForPlaceId(p2, p3)
	end, {})

	local v73 = React.useCallback(function(callback)
		local function fn()
			if callback == nil then
				return false
			end

			return callback()
		end

		v71.captureDistanceFromBottom()

		if v19 == nil then
			return
		end

		if FFlagBuildExperienceChatHistoryPrefetch then
			v19.requestOlderHistoryWhile(fn, function()
				return v71.isNearTopRef.current
			end)
		else
			task.spawn(function()
				if
					v19.loadOlderHistory(fn)
					and v19.getNextHistoryPageToken() ~= nil
					and v71.isAtTopRef.current
				then
					task.delay(0.1, function()
						local v74 = not (callback == nil) and callback()

						if v74 then
							return
						end

						if v71.isViewportUnderfilled() then
							v19.loadOlderHistory(fn)
						end
					end)
				end
			end)
		end
	end, { v19, v71 })

	local v74 = React.useCallback(function(callback)
		task.delay(0.1, function()
			if callback() or v19 == nil or v19.getNextHistoryPageToken() == nil then
				return
			end

			if FFlagBuildExperienceChatHistoryPrefetch then
				if not v71.isNearTopRef.current then
					return
				end
			elseif not v71.isViewportUnderfilled() then
				return
			end

			v73(callback)
		end)
	end, { v73, v71, v19 })

	local v75 = React.useCallback(function(p2)
		if not (v19 ~= nil and v19.getNextHistoryPageToken() ~= nil) then
			return
		end

		v74(p2)
	end, { v74, v19 })
	local ref17 = React.useRef(v75)
	ref17.current = v75

	React.useEffect(function()
		v71.setOnScrolledToTop(function()
			v73(nil)
		end)
		return function()
			v71.setOnScrolledToTop(nil)
		end
	end, { v71.setOnScrolledToTop, v73 })

	React.useEffect(function()
		if v14 and v19 ~= nil then
			local flag = false
			local function setHistoryLoading(p2)
				if setState4 == nil or flag then
					return
				end

				setState4({
					session = v19,
					sessionId = sessionId,
					universeId = universeId,
					hydrateHistoryWhen = v14,
					isLoading = p2
				})
			end
			local v76 = not (v19.hasLoadedHistory() and #v19.getMergedHistory(false) > 0)

			if setState4 ~= nil and not flag then
				setState4({
					session = v19,
					sessionId = sessionId,
					universeId = universeId,
					hydrateHistoryWhen = v14,
					isLoading = v76
				})
			end

			local v77 = sessionId
			local function isHydrateCancelled(): boolean
				if flag then
					return true
				end

				if v77 == nil or v77 == "" then
					return false
				end

				return v19.getCasSessionId() ~= v77
			end

			local function continueAfterSessionReady()
				local v78 = if flag then true else not (v77 == nil or v77 == "") and v19.getCasSessionId() ~= v77

				if v78 then
					return
				end

				ref17.current(isHydrateCancelled)
			end

			local function hydrateKnownSession(p2)
				v19.setCasSessionId(p2)

				if v16 and ref2.current ~= nil then
					if setState4 ~= nil then
						if flag then
							return
						end

						setState4({
							session = v19,
							sessionId = sessionId,
							universeId = universeId,
							hydrateHistoryWhen = v14,
							isLoading = false
						})
					end
				elseif
					v16
					or not v19.hasLoadedHistory()
					or not (#v19.getMergedHistory(false) > 0)
					or FFlagBuildExperienceModelPicker and not v19.hasObservedModels(false)
				then
					local v78

					if FFlagBuildExperienceChatHistoryPrefetch then
						v78 = v19.refreshSession(isHydrateCancelled, true)
					else
						v78 = v19.refreshSession(isHydrateCancelled)
					end

					if v78 then
						local v79 = if flag then true else not (v77 == nil or v77 == "") and v19.getCasSessionId() ~= v77

						if not v79 then
							local v80 = if flag then true else not (v77 == nil or v77 == "") and v19.getCasSessionId() ~= v77

							if not v80 then
								ref17.current(isHydrateCancelled)
							end
						end
					end

					if setState4 ~= nil then
						if flag then
							return
						end

						setState4({
							session = v19,
							sessionId = sessionId,
							universeId = universeId,
							hydrateHistoryWhen = v14,
							isLoading = false
						})
					end
				else
					local v78 = if flag then true else not (v77 == nil or v77 == "") and v19.getCasSessionId() ~= v77

					if not v78 then
						ref17.current(isHydrateCancelled)
					end

					if setState4 ~= nil then
						if flag then
							return
						end

						setState4({
							session = v19,
							sessionId = sessionId,
							universeId = universeId,
							hydrateHistoryWhen = v14,
							isLoading = false
						})
					end
				end
			end

			task.spawn(function()
				local v78 = sessionId

				if v16 and (v78 == nil or v78 == "") then
					v78 = v19.getCasSessionId()
				end

				if v78 ~= nil and v78 ~= "" then
					hydrateKnownSession(v78)
					return
				end

				if FFlagBuildExperienceModelPicker then
					local casSessionId = v19.getCasSessionId()

					if
						casSessionId ~= nil
						and v19.hasLoadedHistory()
						and #v19.getMergedHistory(false) > 0
						and not v19.hasObservedModels(false)
					then
						hydrateKnownSession(casSessionId)
						return
					end
				end

				if
					universeId == nil
					or universeId == 0
					or v19.hasLoadedHistory() and #v19.getMergedHistory(false) > 0
				then
					if setState4 ~= nil then
						if flag then
							return
						end

						setState4({
							session = v19,
							sessionId = sessionId,
							universeId = universeId,
							hydrateHistoryWhen = v14,
							isLoading = false
						})
					end
				else
					local sessionFindByUniverse = creatorAgentChatStore.sessionFindByUniverse({
						universeId = universeId,
						sort = "desc",
						application = "build",
						filterByPinForBuild = true
					})

					while sessionFindByUniverse.state(false).status == "pending" do
						local v79 = if flag then true else not (v77 == nil or v77 == "") and v19.getCasSessionId() ~= v77

						if v79 then
							break
						end

						task.wait()
					end

					if v16 then
						local v79 = if flag then true else not (v77 == nil or v77 == "") and v19.getCasSessionId() ~= v77

						if v79 then
							return
						end

						local casSessionId = v19.getCasSessionId()

						if casSessionId ~= nil and casSessionId ~= "" then
							hydrateKnownSession(casSessionId)
							return
						end
					end

					local v79 = if flag then true else not (v77 == nil or v77 == "") and v19.getCasSessionId() ~= v77

					if v79 or sessionFindByUniverse.state(false).status ~= "succeeded" then
						if setState4 ~= nil then
							if flag then
								return
							end

							setState4({
								session = v19,
								sessionId = sessionId,
								universeId = universeId,
								hydrateHistoryWhen = v14,
								isLoading = false
							})
						end
					else
						local result = sessionFindByUniverse.state(false).result
						local sessions = if result ~= nil then result.sessions else nil
						local v80 = if typeof(sessions) == "table" then sessions[1] else nil
						local sessionId2 = if typeof(v80) == "table" then v80.sessionId else nil

						if typeof(sessionId2) == "string" and sessionId2 ~= "" then
							setState2({
								universeId = universeId,
								placeId = placeId,
								sessionId = sessionId2,
								accountId = if FFlagBuildExperienceModelPicker then v12 else nil
							})
						else
							v19.markHistoryLoaded()

							if setState4 ~= nil then
								if flag then
									return
								end

								setState4({
									session = v19,
									sessionId = sessionId,
									universeId = universeId,
									hydrateHistoryWhen = v14,
									isLoading = false
								})
							end
						end
					end
				end
			end)

			return function()
				flag = true
			end
		elseif setState4 ~= nil then
			setState4({
				session = v19,
				sessionId = sessionId,
				universeId = universeId,
				hydrateHistoryWhen = v14,
				isLoading = false
			})
		end
	end, { v19, sessionId, universeId, placeId, creatorAgentChatStore, v14, v16, v12 })

	React.useEffect(function()
		if v19 == nil then
			return
		end

		local v76 = false
		local function refreshKnownSession()
			local v77 = v19.getCasSessionId()

			if (v77 == nil or v77 == "") and sessionId ~= nil and sessionId ~= "" then
				v77 = sessionId
			end

			if v77 == nil or v77 == "" then
				return
			end

			task.spawn(function()
				local function isRefreshCancelled()
					return v76
				end

				local v78

				if FFlagBuildExperienceChatHistoryPrefetch then
					v78 = v19.refreshSession(isRefreshCancelled, true)
				else
					v78 = v19.refreshSession(isRefreshCancelled)
				end

				if v78 and not v76 then
					ref17.current(function()
						return v76
					end)
				end
			end)
		end

		local connection = MessageBusService:Subscribe(messageId, function(p2)
			ref.current = true

			if FFlagBuildExperienceRefreshChatDraftOnGameLeave and engineFeature then
				local v77 = v19.getCasSessionId()

				if (v77 == nil or v77 == "") and sessionId ~= nil and sessionId ~= "" then
					v77 = sessionId
				end

				local v78 = FFlagBuildExperiencePrefillSkipsDraftPersist

				if v78 then
					v78 = not (ref7.current == "") and ref7.current == ref9.current
				end

				if v77 ~= nil and v77 ~= "" and not v78 then
					local v79 = v7.getChatDraft(v77) or ""
					ref8.current = v79
					ref7.current = v79
					v62(v79)
					v63(nil)
				end
			end

			refreshKnownSession()
		end, false, true)
		local onUnhideConnection = AppLifecycleObserverService.OnUnhide:Connect(refreshKnownSession)

		return function()
			v76 = true
			connection:Disconnect()
			onUnhideConnection:Disconnect()
		end
	end, { v19, sessionId, ref })

	React.useEffect(function()
		if not v14 then
			return
		end

		v71.lockToBottom()
	end, { v14, v16, v19, sessionId, v71 })

	local v76 = React.useCallback(function(current2)
		ref7.current = current2
		v62(current2)
		v63(nil)
	end, { v62, v63 })
	local v77

	if engineFeature then
		v77 = React.useCallback(function()
			if ref10.current ~= nil then
				task.cancel(ref10.current)
				ref10.current = nil
			end
		end, {})
	else
		v77 = nil
	end

	local v78

	if FFlagBuildExperienceNewGameChatDraft then
		v78 = React.useCallback(function()
			local current2 = ref11.current

			if current2 ~= nil and current2 ~= "" then
				return current2
			end

			if v66.current then
				return getNewGameChatDraftKey()
			end

			return nil
		end, {})
	else
		v78 = nil
	end

	local v79

	if engineFeature then
		v79 = React.useCallback(function(current2)
			ref8.current = current2
			v77()

			local v80 = if FFlagBuildExperienceNewGameChatDraft then v78() else ref11.current

			if v80 == nil or v80 == "" then
				return
			end

			ref10.current = task.delay(0.5, function()
				ref10.current = nil
				v7.setChatDraft(v80, current2)
			end)
		end, { v77, v78 })
	else
		v79 = nil
	end

	local v80

	if engineFeature then
		v80 = React.useCallback(function(current2)
			local v81 = if FFlagBuildExperienceNewGameChatDraft then v78() else ref11.current

			if v81 == nil or v81 == "" then
				return
			end

			ref8.current = current2
			v77()
			v7.setChatDraft(v81, current2)
		end, { v77, v78 })
	else
		v80 = nil
	end

	local v81

	if engineFeature then
		v81 = React.useCallback(function(p2, p3)
			local v82 = if FFlagBuildExperienceNewGameChatDraft and v66.current then getNewGameChatDraftKey() else nil

			if v82 ~= nil then
				v7.setChatDraft(v82, "")
			end

			if p3 == nil or p3 == "" or ref8.current ~= p2 then
				return
			end

			ref8.current = ""
			v77()
			v7.setChatDraft(p3, "")
		end, { v77 })
	else
		v81 = nil
	end

	local v82 = React.useCallback(function(p2)
		v76(p2)

		if engineFeature then
			if FFlagBuildExperiencePrefillSkipsDraftPersist then
				local current2 = ref9.current

				if current2 ~= nil and p2 == current2 then
					return
				end

				ref9.current = nil
			end

			v79(p2)
		end
	end, { v76, v79 })
	local v83

	if FFlagBuildExperiencePrefillSkipsDraftPersist and engineFeature then
		v83 = React.useCallback(function(current2)
			ref9.current = current2
			v76(current2)
		end, { v76 })
	else
		v83 = v82
	end

	if FFlagBuildExperienceNewGameChatDraft and engineFeature then
		React.useEffect(function()
			if not v65 or v25 ~= nil and v25 ~= "" then
				return
			end

			local v84 = getNewGameChatDraftKey()

			if v84 == nil then
				return
			end

			local v85 = v7.getChatDraft(v84) or ""

			if v85 ~= "" and ref7.current == "" then
				ref8.current = v85
				v76(v85)
			end
		end, { v65, v25, v76 })
	end

	local function fn()
		if not engineFeature or (v25 == nil or v25 == "") then
			return
		end

		local current2 = ref12.current
		ref12.current = v25
		v77()

		if FFlagBuildExperiencePrefillSkipsDraftPersist and current2 == nil and ref7.current ~= "" and ref7.current == ref9.current then
			ref8.current = v7.getChatDraft(v25) or ""
		elseif current2 == nil and ref7.current ~= "" then
			ref8.current = ref7.current
			v7.setChatDraft(v25, ref7.current)
		else
			local v84 = v7.getChatDraft(v25) or ""
			ref8.current = v84
			v76(v84)
		end

		return function()
			local v84 = ref10.current ~= nil
			v77()

			if v84 then
				v7.setChatDraft(v25, ref8.current)
			end
		end
	end

	React.useEffect(fn, {
		v25,
		v77,
		v76,
		if FFlagBuildExperienceModelPicker then v19 else nil
	})

	local function commitComposerResourceAttachments(current2)
		v69.current = current2

		if setState12 ~= nil then
			setState12(current2)
		end

		v63(nil)
	end

	local function findComposerResourceAttachmentIndexByUri(p2)
		for k, v86 in v69.current do
			if chatTypes.getResourceAttachmentUri(v86) == p2 then
				return k
			end
		end

		return nil
	end

	local function addComposerResourceAttachment(p2)
		local clone = table.clone(v69.current)
		table.insert(clone, p2)
		v69.current = clone

		if setState12 ~= nil then
			setState12(clone)
		end

		v63(nil)
	end

	local function removeComposerResourceAttachmentAtIndex(p2)
		local clone = table.clone(v69.current)
		table.remove(clone, p2)
		v69.current = clone

		if setState12 ~= nil then
			setState12(clone)
		end

		v63(nil)
	end

	local function clearComposerResourceAttachments()
		local v86 = {}
		v69.current = v86

		if setState12 ~= nil then
			setState12(v86)
		end

		v63(nil)
	end
	local ref18 = React.useRef(commitComposerResourceAttachments)
	ref18.current = commitComposerResourceAttachments

	if fFlagBuildExperienceChatResourceAttachments then
		React.useLayoutEffect(function()
			local current2 = v68.current

			if current2.universeId ~= data.universeId or current2.placeId ~= data.placeId then
				ref18.current({})
			end

			v68.current = { universeId = data.universeId, placeId = data.placeId }
		end, { data.universeId, data.placeId })
	end

	local function commitComposerImages(current2)
		v67.current = current2

		if setState11 ~= nil then
			setState11(current2)
		end
	end

	local function hasFailedComposerImage(items): boolean
		for k, item in items do
			if item.uploadStatus == "failed" then
				return true
			end
		end

		return false
	end

	local function updateComposerImage(p2, fn2)
		local current2 = v67.current
		local clone = table.clone(current2)

		for k, v86 in current2 do
			if v86.capture == p2 then
				clone[k] = fn2(v86)
				v67.current = clone

				if setState11 ~= nil then
					setState11(clone)
				end

				return clone
			end
		end

		return current2
	end

	local function beginComposerImageUpload(p2)
		ref15.current += 1
		local current2 = ref15.current
		ref14.current[p2] = current2

		local v87 = updateComposerImage(p2, function(p3)
			local clone = table.clone(p3)
			clone.uri = nil
			clone.uploadStatus = "uploading"
			clone.uploadError = nil
			return clone
		end)
		local flag = true
		local v88

		for k, v89 in v87 do
			if v89.uploadStatus == "failed" then
				v88 = true
				flag = false
				break
			end
		end

		if flag then
			v88 = false
		end

		if not v88 then
			v63(nil)
		end

		v8(p2):andThen(function(p3)
			if ref14.current[p2] ~= current2 then
				return
			end

			ref14.current[p2] = nil
			local v89 = updateComposerImage(p2, function(p4)
				local clone = table.clone(p4)
				clone.uri = `rbxassetid://{p3.assetId}`
				clone.uploadStatus = "uploaded"
				clone.uploadError = nil
				return clone
			end)
			local flag2 = true
			local v90

			for k, v91 in v89 do
				if v91.uploadStatus == "failed" then
					v90 = true
					flag2 = false
					break
				end
			end

			if flag2 then
				v90 = false
			end

			if not v90 then
				v63(nil)
			end
		end):catch(function(uploadError)
			if ref14.current[p2] ~= current2 then
				return
			end

			ref14.current[p2] = nil
			updateComposerImage(p2, function(p3)
				local clone = table.clone(p3)
				clone.uri = nil
				clone.uploadStatus = "failed"
				clone.uploadError = uploadError
				return clone
			end)

			if FFlagBuildExperienceChatImageAttachments then
				v63(v11)
			end
		end)
	end

	local function setComposerImages(list)
		local current2 = v67.current

		local captures = {}
		local v86 = {}

		for i = 1, math.min(#list, 2) do
			local item = list[i]
			local v87

			if item.capture == nil or item.uri ~= nil or item.uploadStatus ~= nil then
				v87 = item
			else
				v87 = item

				for k, v89 in current2 do
					if v89.capture == item.capture then
						v87 = v89
						break
					end
				end
			end

			if v87.uri == nil or v87.uploadStatus ~= nil then
				if v87.capture ~= nil and v87.uri == nil and v87.uploadStatus == nil then
					v87 = table.clone(v87)
					v87.uploadStatus = "uploading"
					table.insert(captures, v87.capture)
				end
			else
				v87 = table.clone(v87)
				v87.uploadStatus = "uploaded"
			end

			table.insert(v86, v87)
		end

		for k, v87 in current2 do
			local v88 = false

			for k2, v90 in v86 do
				if v90.capture == v87.capture then
					v88 = true
					break
				end
			end

			if v88 or v87.capture == nil then
				continue
			end

			ref14.current[v87.capture] = nil
		end

		v67.current = v86

		if setState11 ~= nil then
			setState11(v86)
		end

		local flag = true
		local v87

		for k, v88 in v86 do
			if v88.uploadStatus == "failed" then
				v87 = true
				flag = false
				break
			end
		end

		if flag then
			v87 = false
		end

		if not v87 then
			v63(nil)
		end

		for k, v88 in captures do
			beginComposerImageUpload(v88)
		end
	end
	local ref19 = React.useRef(setComposerImages)
	ref19.current = setComposerImages

	local function retryComposerImage(p2)
		local v86 = v67.current[p2]

		if v86 == nil or v86.capture == nil or v86.uploadStatus ~= "failed" then
			return
		end

		beginComposerImageUpload(v86.capture)
	end

	local v86 = false

	for k, v88 in state11 do
		if v88.uri == nil or v88.uploadStatus == "uploading" or v88.uploadStatus == "failed" then
			v86 = true
			break
		end
	end

	local v88 = React.useCallback(function(p2)
		return function(p3, p4)
			if ref4.current == p2 then
				local current2 = ref3.current
				local v90 = sessionId
				local v91

				if current2 == nil or current2.session ~= v19 then
					v91 = false
				elseif v90 == nil or v90 == "" or current2.sessionId == v90 then
					v91 = true
				else
					v91 = current2.sessionId == nil and current2.session.getCasSessionId() == v90
				end

				if v91 then
					local v92 = false

					if FFlagBuildExperienceAnswerForm then
						local current3 = ref2.current

						if current3 ~= nil then
							local getLocalToolActions = current3.getLocalToolActions
							v92 = next(getLocalToolActions(false).onAnswerSelectedByToolCallId) ~= nil
						end
					end

					if p3 ~= nil and ref7.current == "" and not v92 then
						v82(p3)
					end

					v63((v10:Format((creatorAgentChat.getToolResultFailureComposerError(p4)))))
				end
			end
		end
	end, { v19, sessionId, v82, v63, v10 })

	local v89 = data.onPromptFailure
	local state13

	if FFlagBuildExperienceModelPicker then
		local setState13
		state13, setState13 = React.useState(nil)

		if state13 == nil or state13.owner ~= v19 then
			state13 = nil
		end

		v89 = React.useCallback(function(p2, p3)
			if p2 == CreatorAgentChat.ErrorCodes.OutOfCredits then
				setState13(function(p4)
					return {
						count = not p4 and 1 or p4.count + 1,
						reason = p3,
						owner = v19
					}
				end)
			end

			if data.onPromptFailure ~= nil then
				data.onPromptFailure(p2, p3)
			end
		end, { v19, data.onPromptFailure })
	end

	local v90 = React.useCallback(function(p2, p3, p4, p5, p6, data2)
		if ref4.current ~= p2 then
			return
		end

		if FFlagBuildExperienceModelPicker and v21 ~= nil and not v21.current then
			GetBuildCreatorCreditRefreshStore(false).settled()
			return
		end

		v39(nil)
		ref6.current = nil
		setState5(nil)

		if FFlagBuildExperienceModelPicker then
			GetBuildCreatorCreditRefreshStore(false).settled()
		end

		if p3 == nil then
			if data2.placeId ~= nil then
				v72(data2.placeId, "Completed")
			end

			v71.scrollToBottomAfterSend()

			local casSessionId = data2.getCasSessionId()

			if casSessionId ~= nil and casSessionId ~= "" then
				if data.createUniverseOnFirstPrompt and sessionId == nil and data2.universeId ~= nil then
					local v91 = {
						universeId = data2.universeId,
						placeId = data2.placeId,
						sessionId = casSessionId
					}

					if FFlagBuildExperienceModelPicker then
						local clone = table.clone(v91)
						clone.accountId = v12
						setState(clone)
					else
						setState(v91)
					end

					if data.onProjectResolved ~= nil then
						data.onProjectResolved(v91)
					end
				end

				task.spawn(function()
					data2.refreshSession(function(): boolean
						return ref4.current ~= p2
					end)
				end)
			end
		else
			if v89 ~= nil then
				v89(p3.errorCode, p3.outOfCreditsReason)
			end

			if data2.placeId ~= nil then
				v72(data2.placeId, "Idle")
			end

			if FFlagBuildExperienceChatImageAttachments and p5 ~= nil then
				ref19.current(p5)
			end

			if fFlagBuildExperienceChatResourceAttachments and p6 ~= nil then
				ref18.current(p6)
			end

			if p4 ~= nil then
				v82(p4)
				v63((v10:Format((creatorAgentChat.getPromptFailureComposerError(p3)))))
			end

			task.spawn(function()
				data2.refreshSession(function(): boolean
					return ref4.current ~= p2
				end)
			end)
		end
	end, {
		v21,
		data.createUniverseOnFirstPrompt,
		v89,
		data.onProjectResolved,
		sessionId,
		v72,
		setState,
		v12,
		v71,
		v82,
		v63,
		v39,
		setState5,
		v10
	})

	local ref20 = React.useRef(v14)
	React.useEffect(function()
		local v91 = v14 and not ref20.current
		ref20.current = v14

		if v16 or not v14 or not v91 and not v59 and v42 == nil then
			return
		end

		v71.scrollToBottomUnconditionally()
		task.defer(v71.scrollToBottomUnconditionally)
		task.delay(0.15, v71.scrollToBottomUnconditionally)
	end, {
		v14,
		v16,
		v59,
		v42,
		#messages,
		v71
	})

	React.useEffect(function()
		if ref2.current ~= nil then
			local current2 = ref3.current
			local v92 = sessionId
			local v93

			if current2 == nil or current2.session ~= v19 then
				v93 = false
			elseif v92 == nil or v92 == "" or current2.sessionId == v92 then
				v93 = true
			else
				v93 = current2.sessionId == nil and current2.session.getCasSessionId() == v92
			end

			if v93 then
				return
			end
		end

		if not (state6 == nil and v19 ~= nil) then
			return
		end

		local v91 = v19
		local v92 = v91.getCasSessionId()

		if typeof(v92) ~= "string" or v92 == "" then
			local universeId2 = v91.universeId
			local placeId2 = v91.placeId
			v92 = if not (universeId2 == nil or placeId2 == nil) then `{universeId2}:{placeId2}` else nil
		end

		if v92 == nil then
			return
		end

		local function attachResumedTurn(p2, current2)
			ref4.current += 1
			local current3 = ref4.current
			ref6.current = current2

			if placeId ~= nil then
				v72(placeId, "Loading")
			end

			local createResumedAssistantTurn = creatorAgentChat.createResumedAssistantTurn

			local function fn2(p3)
				v90(current3, p3, nil, nil, nil, v19)
			end
			local v95 = if current2 ~= nil then current2 - 1 else nil
			local resumedAssistantTurn = createResumedAssistantTurn(v19, p2, fn2, v95, v88(current3), v13)

			v39(resumedAssistantTurn, v19)
			resumedAssistantTurn.start()
			v71.scrollToBottomUnconditionally()
		end

		if v50.activeTurnState == nil or v50.activeTurnItemIndex == nil or v50.activeTurnState.isDone then
			ref6.current = nil

			local activeTurnHandle = creatorAgentChatStore.getActiveTurnHandle(v92)
			local v93 = if activeTurnHandle ~= nil then activeTurnHandle.state(false) else nil
			local v94 = not (activeTurnHandle == nil or v93 == nil) and not v93.isDone

			if (v59 or v94) and v94 then
				attachResumedTurn(activeTurnHandle, nil)
			end
		else
			local activeTurnStartSequenceId = v50.activeTurnStartSequenceId

			if ref6.current == activeTurnStartSequenceId and v42 ~= nil then
				return
			end

			local v93 = creatorAgentChatStore.resumeTurnFromHistory(
				v92,
				v50.activeTurnState,
				v50.activeTurnSequenceIds
			)

			if v93 ~= nil then
				attachResumedTurn(v93, activeTurnStartSequenceId)
			end
		end
	end, {
		v50,
		v19,
		sessionId,
		creatorAgentChatStore,
		v59,
		v42,
		placeId,
		v72,
		v90,
		v71,
		v39,
		state6,
		v88,
		v13
	})

	local v91 = React.useCallback(
		function(p2, p3, p4, p5, p6, current2, p7, p8, callback, onTerminal, callback2, p9, callback3)
			local function startAdmitted(p10)
				setState5({
					text = p3,
					images = p5,
					resourceAttachments = p6,
					afterSequenceId = p7
				})

				local v92 = v52

				local fn2 = engineFeature and p8 ~= nil and function(p11)
					if v92 ~= nil then
						v92(p11)
					end

					v81(p8, p2.getCasSessionId() or sessionId)
				end or v92
				local v93

				if FFlagBuildExperienceRestoreStoppedPrompt and ref13 ~= nil then
					local v94 = ref13
					v93 = function(p11)
						v94.current = current2

						if fn2 ~= nil then
							fn2(p11)
						end
					end
				else
					v93 = fn2
				end

				local fn3 = callback ~= nil and function(p11)
					if v93 ~= nil then
						v93(p11)
					end

					callback(p2.getCasSessionId())
				end or v93

				local fn4 = fFlagBuildExperienceLibrary and callback2 ~= nil and function()
					if engineFeature and p8 ~= nil then
						v81(p8, p2.getCasSessionId() or sessionId)
					end

					callback2(p2.getCasSessionId())
				end or nil
				local v94, v95

				if FFlagBuildExperienceModelPicker and p9 ~= nil then
					local v96 = p9

					v94 = fn3 ~= nil and function(p11)
						if v96.isCurrent() then
							fn3(p11)
						end
					end or fn3

					if fn4 == nil then
						v95 = fn4
					else
						v95 = function()
							if v96.isCurrent() then
								fn4()
							end
						end
					end
				else
					v95 = fn4
					v94 = fn3
				end

				local v96 = nil
				local createLiveAssistantTurn = creatorAgentChat.createLiveAssistantTurn

				local function fn5(p11)
					if FFlagBuildExperienceModelPicker and p9 ~= nil then
						local current3 = p9.isCurrent()
						p9.release()

						if not current3 then
							if ref2.current == v96 and ref4.current == current2 then
								v39(nil)
								ref6.current = nil
								setState5(nil)

								if p2.placeId ~= nil then
									v72(p2.placeId, "Idle")
								end
							end

							if onTerminal ~= nil then
								onTerminal()
							end

							return
						end
					end

					v90(current2, p11, p8, p5, p6, p2)

					if onTerminal ~= nil then
						onTerminal()
					end
				end
				local v99 = v88(current2)
				local v101 = if FFlagBuildExperienceModelPicker then p10 else nil
				local v102 = if FFlagBuildExperienceModelPicker and p10 ~= nil then p10.sessionId else nil
				v96 = createLiveAssistantTurn(
					p2,
					p4,
					fn5,
					v99,
					v13,
					v94,
					v95,
					v101,
					v102,
					FFlagBuildExperienceModelPicker and p9 ~= nil and function(): boolean
						return not p9.isCurrent()
					end or nil
				)

				if p2.placeId ~= nil then
					v72(p2.placeId, "Loading")
				end

				v39(v96, p2)
				v71.scrollToBottomAfterSend()
				v96.start()
			end

			if not FFlagBuildExperienceModelPicker then
				startAdmitted(nil)
				return
			end

			local v92 = ref5
			local v93 = setState8
			local v94 = p9

			if not v94 then
				local entry = if v22 ~= nil then v22.entry else nil
				local creatorCreditStore = CreatorCredit.getCreatorCreditStore(false)
				local promptExperiment = CreatorAgentChat.experimentOverride.getPromptExperiment(CreatorAgentChat.experimentOverride.getKey(p2.getCasSessionId()) or v27)

				local v96 = enabled

				if v96 then
					if v27 == nil then
						v96 = false
					else
						v96 = CreatorAgentChat.experimentOverride.getInternalSelection(
							CreatorAgentChat.experimentOverride.getKey(p2.getCasSessionId()) or v27,
							false
						).isSelected
					end
				end

				v94 = beginBuildModelSend(entry, creatorCreditStore, promptExperiment, v96)
			end

			p9 = v94

			if p9 == nil then
				if onTerminal ~= nil then
					onTerminal()
				end
			else
				local v95 = p9

				local v96 = {
					attempt = v95,
					started = false,
					onTerminal = onTerminal,
					restoreDraft = callback3
				}
				v92.current = v96
				v93(true)
				task.spawn(function()
					local success, result, v97 = pcall(v95.prepare, p2)
					local v98 = not v95.isCurrent() or ref4.current ~= current2

					if v98 or not success or result == nil then
						v95.release()

						if v92.current == v96 then
							v92.current = nil
							v93(false)
							setState5(nil)
						end

						if v98 then
							if ref4.current == current2 and callback3 ~= nil then
								callback3(true)
							end
						else
							local v99 = LocalizationStrings.CHAT_DEFAULT_FAILURE

							if success and v97 ~= nil then
								if v97.kind == "setup" then
									local getPromptFailureComposerError = creatorAgentChat.getPromptFailureComposerError
									local v100 = {
										errorCode = v97.errorCode,
										isContentPolicy = false,
										setupStage = 0
									}

									local v101 = if v97.setupError and v97.setupError.stage ~= "session_load" then v97.setupError.stage else nil
									v100.setupStage = v101
									v99 = getPromptFailureComposerError(v100)
								elseif v97.kind == "unavailable" then
									v99 = LocalizationStrings.MODEL_PICKER_UNAVAILABLE
								elseif v97.kind == "denied" then
									v99 = LocalizationStrings.CHAT_ERROR_OUT_OF_CREDITS
									GetBuildCreatorCreditRefreshStore(false).refresh()
								end

								if v89 ~= nil then
									v89(v97.errorCode, v97.reason)
								end
							end

							if callback3 ~= nil then
								callback3(false)
							end

							v64(v10:Format(v99))
						end

						if onTerminal ~= nil then
							onTerminal()
						end
					else
						v93(false)
						v96.started = true
						startAdmitted(result)
					end
				end)
			end
		end,
		{
			v22,
			v27,
			ref5,
			v20,
			setState8,
			v64,
			v10,
			v89,
			v90,
			v72,
			v71,
			v39,
			setState5,
			v88,
			v13,
			v52,
			v81,
			sessionId
		}
	)

	local ref21 = React.useRef(v50.latestSequenceId)
	ref21.current = v50.latestSequenceId
	local v93 = useAgentRollbackRequest({
		universeId = universeId,
		placeId = placeId,
		session = v19,
		activeTurnHandleRef = ref2,
		startRollbackTurn = React.useCallback(function(data2, callback, callback2)
			local v93 = v19

			if v93 == nil then
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

			v71.captureStickToBottomForSend()
			ref4.current += 1
			local current2 = ref4.current
			setState6(nil)
			local v95 = buildAgentRollbackPrompt(data2.versionNumber, data2.noteTitle, data2.noteDescription)

			v91(v93, v95, v95, nil, nil, current2, ref21.current, nil, function()
				v71.scrollToBottomUnconditionally()
				callback()
			end, callback2)
		end, { v19, ref5, v71, setState6, v91 })
	})

	React.useLayoutEffect(function()
		if state7 ~= nil then
			local current2 = ref3.current
			local v95 = sessionId
			local v96

			if current2 == nil or current2.session ~= v19 then
				v96 = false
			elseif v95 == nil or v95 == "" or current2.sessionId == v95 then
				v96 = true
			else
				v96 = current2.sessionId == nil and current2.session.getCasSessionId() == v95
			end

			if not v96 then
				local current3 = ref3.current
				ref4.current += 1
				ref6.current = nil

				if v93.stopRequestBeforeReceipt(state7) then
					if current3 ~= nil and current3.session.placeId ~= nil then
						v72(current3.session.placeId, "Idle")
					end
				else
					state7.detach()

					if FFlagBuildExperienceModelPicker then
						local v98 = ref5
						local current4 = v98.current

						if current4 ~= nil and current4.started then
							current4.attempt.unlockSelection()
							v98.current = nil
						end
					end
				end

				v39(nil, nil)
				setState5(nil)
				setState6(nil)
			end
		end
	end, { v19, sessionId, state7, v39, v93, v72, ref5 })

	local v94 = React.useCallback(function(p2, p3, p4, p5, p6, p7, p8, p9)
		setState5({
			text = p2,
			images = p4,
			resourceAttachments = p5,
			afterSequenceId = p7
		})

		local v95 = nil
		local universeId2 = nil

		if FFlagBuildExperienceModelPicker and data.modelSelectionDraftId ~= nil then
			v95 = GetBuildModelSelectionStore(false).retainDraftForCreation(data.modelSelectionDraftId)
		end

		local v96 = setState3
		local v97 = v20
		local entry = if v22 ~= nil then v22.entry else nil
		local function canConfigure(): boolean
			return entry ~= nil and entry.getSelection(false) ~= nil
		end

		if v97 ~= nil then
			v97.pending = true
			v96(true)
		end

		local lastTime = os.clock()
		local v98 = nil
		local v99 = UniverseCreate.getUniverseCreateStore().createUniverse({
			templatePlaceId = getDefaultTemplatePlaceId(),
			isPublish = true
		}):andThen(function(p10)
			if FFlagBuildExperienceModelPicker then
				universeId2 = p10.universeId
			end

			Debug.log("info", "build_experience create_universe succeeded", {
				durationMs = math.floor((os.clock() - lastTime) * 1000 + 0.5),
				universeId = p10.universeId,
				rootPlaceId = p10.rootPlaceId
			})

			if fFlagBuildExperiencePromptFailureTelemetry then
				v98 = { universeId = p10.universeId, placeId = p10.rootPlaceId }
			end

			local v100 = if FFlagBuildExperienceModelPicker then entry == nil or entry.getSelection(false) == nil else ref4.current ~= p6

			if v100 then
				return nil
			end

			local universeConfigurationStore = UniverseConfiguration.getUniverseConfigurationStore()

			return universeConfigurationStore.patchConfiguration(p10.universeId, {
				audiences = { 1 }
			}):andThen(function()
				if FFlagBuildExperienceModelPicker then
					local v101 = not (entry == nil) and entry.getSelection(false) ~= nil

					if not v101 then
						return nil
					end
				end

				return universeConfigurationStore.setTeamCreate(p10.universeId, true)
			end):andThen(function(): nil
				local v101

				if FFlagBuildExperienceModelPicker then
					v101 = entry == nil or entry.getSelection(false) == nil or v97 == nil or not v97.mounted
				else
					v101 = ref4.current ~= p6
				end

				if v101 then
					return nil
				end

				local v102 = { universeId = p10.universeId, placeId = p10.rootPlaceId }

				if FFlagBuildExperienceModelPicker then
					local clone = table.clone(v102)
					clone.accountId = v12
					setState(clone)
				else
					setState(v102)
				end

				if data.onProjectResolved ~= nil then
					data.onProjectResolved(v102)
				end

				if p8 ~= nil and not p8.isCurrent() then
					return nil
				end

				local sessionForProject = creatorAgentChatStore.getSessionForProject(
					p10.universeId,
					p10.rootPlaceId,
					sessionId
				)

				if
					enabled
					and (FFlagBuildExperienceModelPicker and CreatorAgentChat.experimentOverride.has(v27) or v28 ~= nil and v28.current)
				then
					sessionForProject.setPendingExperimentKey(v27)
				end

				v91(sessionForProject, p2, p3, p4, p5, p6, p7, p2, nil, nil, nil, p8, p9)

				return nil
			end)
		end):catch(function(p10)
			Debug.log("warn", "build_experience create_or_configure_universe failed", {
				durationMs = math.floor((os.clock() - lastTime) * 1000 + 0.5),
				error = p10
			})

			if ref4.current ~= p6 or p8 ~= nil and not p8.isCurrent() then
				return
			end

			if fFlagBuildExperiencePromptFailureTelemetry then
				local v100 = math.round((os.clock() - lastTime) * 1000)
				local v101 = v98 == nil and {} or {
					universeId = v98.universeId,
					placeId = v98.placeId
				}
				local v102 = {
					isContentPolicy = "false",
					setupStage = v98 == nil and "create_universe" or "configure_universe",
					errorCopyKey = LocalizationStrings.CHAT_CREATE_UNIVERSE_ERROR,
					elapsedMs = tostring(v100),
					receivedResponse = "false",
					stalled = tostring(chatConstants.PROMPT_STALL_SECONDS * 1000 <= v100)
				}

				v102.failureKind = requestFailureKind.Unknown

				if typeof(p10) == "table" and typeof(p10.responseCode) == "number" then
					v102.failureKind = requestFailureKind.Http
					v102.httpStatusCode = tostring(p10.responseCode)
				end

				sendBuildExperienceEvent("SEND_PROMPT_START", v101)
				sendBuildExperienceEvent("SEND_PROMPT_FAILED", v101, v102)
			end

			v39(nil)
			setState5(nil)
			v82(p2)

			if FFlagBuildExperienceChatImageAttachments and p4 ~= nil then
				ref19.current(p4)
			end

			if fFlagBuildExperienceChatResourceAttachments and p5 ~= nil then
				ref18.current(p5)
			end

			if p8 ~= nil then
				p8.release()

				setState8(false)
			end

			v63(formatted)
		end)

		if FFlagBuildExperienceModelPicker then
			v99:finally(function()
				if v95 ~= nil then
					v95(universeId2)
				end

				if v97 ~= nil then
					v97.pending = false

					if v97.mounted then
						v96(false)
					end
				end
			end)
		end
	end, {
		v20,
		v22,
		setState3,
		setState8,
		sessionId,
		creatorAgentChatStore,
		data.onProjectResolved,
		data.modelSelectionDraftId,
		v39,
		v82,
		v63,
		setState,
		v12,
		setState5,
		v91,
		formatted,
		v27,
		v28
	})

	local v95 = React.useCallback(function(p2): boolean
		if not v15 or v20 ~= nil and v20.pending then
			return false
		end

		local current2 = ref7.current
		local v96 = string.gsub(current2, "^%s*(.-)%s*$", "%1")

		local v97 = not FFlagBuildExperienceChatImageAttachments and {} or v67.current

		local v98 = not fFlagBuildExperienceChatResourceAttachments and {} or v69.current

		if v96 == "" and #v97 == 0 then
			v82("")
			return false
		end

		if FFlagBuildExperienceChatImageAttachments then
			for k, v99 in v97 do
				if v99.uri == nil or v99.uploadStatus == "uploading" or v99.uploadStatus == "failed" then
					return false
				end
			end
		end

		local current3 = ref3.current
		local v100 = sessionId
		local v101

		if current3 == nil or current3.session ~= v19 then
			v101 = false
		elseif v100 == nil or v100 == "" or current3.sessionId == v100 then
			v101 = true
		else
			v101 = current3.sessionId == nil and current3.session.getCasSessionId() == v100
		end

		local current4 = if v101 then ref2.current else nil

		if v59 or v16 and current4 ~= nil then
			if
				FFlagBuildExperienceChatImageAttachments and #v97 > 0
				or fFlagBuildExperienceChatResourceAttachments and #v98 > 0
				or (current4 == nil or not current4.trySubmitComposerText(v96))
			then
				return false
			end

			v82("")

			if ref16.current then
				ref16.current.releaseFocus()
			end

			v71.scrollToBottomAfterSend()
			return true
		else
			local v102 = data.createUniverseOnFirstPrompt == true and universeId == nil

			if not v102 and v19 == nil or placeId ~= nil and v18.getIsPendingForPlaceId(placeId)(false) then
				return false
			end

			local function restoreDraft(p3)
				if
					p3
					and (ref7.current ~= "" or FFlagBuildExperienceChatImageAttachments and #v67.current > 0 or fFlagBuildExperienceChatResourceAttachments and #v69.current > 0)
				then
					return
				end

				v82(v96)

				if FFlagBuildExperienceChatImageAttachments then
					ref19.current(v97)
				end

				if fFlagBuildExperienceChatResourceAttachments then
					ref18.current(v98)
				end
			end

			local v103

			if FFlagBuildExperienceModelPicker then
				v63(nil)

				local entry = if v22 ~= nil then v22.entry else nil
				local creatorCreditStore = CreatorCredit.getCreatorCreditStore(false)
				local getPromptExperiment = CreatorAgentChat.experimentOverride.getPromptExperiment
				local getKey = CreatorAgentChat.experimentOverride.getKey
				local v105 = if v19 ~= nil then v19.getCasSessionId() else nil
				local promptExperiment = getPromptExperiment(getKey(v105) or v27)

				local v106 = enabled

				if v106 then
					if v27 == nil then
						v106 = false
					else
						local getInternalSelection = CreatorAgentChat.experimentOverride.getInternalSelection
						local getKey2 = CreatorAgentChat.experimentOverride.getKey
						local v107 = if v19 ~= nil then v19.getCasSessionId() else nil
						v106 = getInternalSelection(getKey2(v107) or v27, false).isSelected
					end
				end

				v103 = beginBuildModelSend(entry, creatorCreditStore, promptExperiment, v106)

				if v103 == nil then
					return false
				end

				ref5.current = {
					attempt = v103,
					started = false,
					restoreDraft = restoreDraft
				}

				setState8(true)
			else
				v103 = nil
			end

			v71.captureStickToBottomForSend()
			ref4.current += 1
			local current5 = ref4.current
			setState6(nil)

			if engineFeature then
				v80(v96)
			end

			v76("")

			if FFlagBuildExperienceChatImageAttachments then
				ref19.current({})
			end

			if fFlagBuildExperienceChatResourceAttachments then
				ref18.current({})
			end

			if ref16.current then
				ref16.current.releaseFocus()
			end

			local function startPrompt(p3, p4)
				if v102 then
					v94(
						v96,
						p3,
						p4,
						v98,
						current5,
						v50.latestSequenceId,
						v103,
						if FFlagBuildExperienceModelPicker then restoreDraft else nil
					)
				else
					local latestSequenceId = v50.latestSequenceId
					local v113 = if fFlagBuildExperienceLibrary then p2 else nil
					v91(
						v19,
						v96,
						p3,
						p4,
						v98,
						current5,
						latestSequenceId,
						v96,
						nil,
						nil,
						v113,
						v103,
						if FFlagBuildExperienceModelPicker then restoreDraft else nil
					)
				end
			end

			if #v97 == 0 and #v98 == 0 then
				startPrompt(v96, nil)
				return true
			end

			local v105 = {}

			if v96 ~= "" then
				table.insert(v105, { type = "text", text = v96 })
			end

			for k, v106 in v98 do
				if v106.type == "resource_link" then
					table.insert(v105, {
						type = v106.type,
						uri = v106.uri,
						name = v106.name,
						mimeType = v106.mimeType
					})
				else
					table.insert(v105, {
						type = v106.type,
						resource = {
							uri = v106.resource.uri,
							text = v106.resource.text,
							blob = nil,
							mimeType = v106.resource.mimeType
						}
					})
				end
			end

			local v106 = {}

			for k, v107 in v97 do
				local uri = v107.uri
				table.insert(v105, { type = "image", uri = uri })
				table.insert(v106, {
					capture = v107.capture,
					uri = uri,
					uploadStatus = "uploaded"
				})
			end

			startPrompt(v105, v106)
			return true
		end
	end, {
		v15,
		v20,
		v22,
		v27,
		ref5,
		setState8,
		v63,
		v19,
		sessionId,
		universeId,
		placeId,
		v59,
		v16,
		v71,
		v82,
		v76,
		v80,
		v94,
		v91,
		data.createUniverseOnFirstPrompt,
		setState6,
		v50,
		v18
	})

	local useCallback = React.useCallback
	local function fn2()
		if FFlagBuildExperienceModelPicker then
			local v96 = ref5
			local current2 = v96.current

			if current2 ~= nil and not current2.started then
				current2.attempt.release()
				v96.current = nil

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
		local v97 = sessionId
		local v98

		if current2 == nil or current2.session ~= v19 then
			v98 = false
		elseif v97 == nil or v97 == "" or current2.sessionId == v97 then
			v98 = true
		else
			v98 = current2.sessionId == nil and current2.session.getCasSessionId() == v97
		end

		local current3 = if v98 then ref2.current else nil

		if current3 == nil then
			v93.cancelRequestBeforeTurnStarts()
		elseif FFlagBuildExperienceModelPicker then
			if fFlagBuildExperiencePromptFailureTelemetry and current3.reportUserStop ~= nil then
				current3.reportUserStop()
			end

			current3.stop()
		else
			local current4 = ref4.current
			ref4.current += 1

			if fFlagBuildExperiencePromptFailureTelemetry and current3.reportUserStop ~= nil then
				current3.reportUserStop()
			end

			if not v93.stopRequestBeforeReceipt(current3) then
				current3.stop()
			end

			v39(nil)
			ref6.current = nil

			if
				FFlagBuildExperienceRestoreStoppedPrompt
				and ref13 ~= nil
				and ref13.current ~= current4
				and state5 ~= nil
				and ref7.current == ""
				and v50.isAwaitingUserMessageEcho
			then
				v82(state5.text)

				if FFlagBuildExperienceChatImageAttachments and state5.images ~= nil and #v67.current == 0 then
					ref19.current(state5.images)
				end

				if
					fFlagBuildExperienceChatResourceAttachments
					and state5.resourceAttachments ~= nil
					and #v69.current == 0
				then
					ref18.current(state5.resourceAttachments)
				end
			end

			setState5(nil)
			setState6({
				session = v19,
				sessionId = v19.getCasSessionId(),
				startSequenceId = v50.activeTurnStartSequenceId
			})

			if placeId ~= nil then
				v72(placeId, "Idle")
			end
		end
	end

	local v101 = if FFlagBuildExperienceRestoreStoppedPrompt then state5 else nil
	local v103 = useCallback(fn2, {
		ref5,
		setState8,
		v19,
		sessionId,
		placeId,
		v72,
		v39,
		setState5,
		setState6,
		v50,
		v93,
		v101,
		if FFlagBuildExperienceRestoreStoppedPrompt then v82 else nil
	})

	local v104 = data.autoFocusComposer == nil or data.autoFocusComposer
	local v105 = if data.focusComposerWhen == nil then v104 else data.focusComposerWhen
	React.useEffect(function()
		if not (v104 and v105) then
			return function() end
		end

		local v106 = false
		local v107 = ref16
		local function fn3()
			return v106
		end

		local v108 = 8
		local function tryFocus()
			if fn3() then
				return
			end

			local current2 = v107.current

			if current2 then
				current2.focus()
				return
			end

			v108 -= 1

			if v108 > 0 then
				task.delay(0, tryFocus)
			end
		end
		task.defer(tryFocus)

		return function()
			v106 = true
		end
	end, { v104, v105 })

	local v106 = React.useCallback(function(p2)
		if placeId == nil then
			return
		end

		local fn3 = game.GameId == 0 and function()
			ref.current = true
		end or nil

		if launchPlaytestWithLoadingState(placeId, p2, true, fn3) and fn3 ~= nil then
			ref.current = false
		end
	end, { placeId, ref })
	local v108

	if FFlagBuildExperienceAnswerForm then
		v108 = React.useMemo(function()
			local v109 = {}

			for k, v110 in v47.onAnswerSelectedByToolCallId do
				v109[k] = function(p2, p3, p4)
					v63(nil)
					v110(p2, p3, p4)
				end
			end

			local v110 = {}

			for k, v111 in v47.onAnswerConfirmedByToolCallId do
				v110[k] = function()
					v63(nil)
					v111()
				end
			end

			return {
				onAnswerSelectedByToolCallId = v109,
				onAnswerConfirmedByToolCallId = v110,
				onPlanAcceptedByToolCallId = v47.onPlanAcceptedByToolCallId,
				onDevProductApprovedByToolCallId = v47.onDevProductApprovedByToolCallId,
				onDevProductRejectedByToolCallId = v47.onDevProductRejectedByToolCallId
			}
		end, { v47, v63 })
	else
		v108 = v47
	end

	local v109

	if FFlagBuildExperienceAnswerForm then
		v109 = React.useMemo(function()
			return v5(activeTurnState, v46, v108)
		end, { activeTurnState, v46, v108 })
	end

	local v110

	if FFlagBuildExperienceAnswerForm then
		v110 = React.useCallback(function(p2, p3, p4)
			local current2 = ref2.current

			if current2 == nil then
				return false
			end

			local current3 = ref3.current
			local v112 = sessionId
			local v113

			if current3 == nil or current3.session ~= v19 then
				v113 = false
			elseif v112 == nil or v112 == "" or current3.sessionId == v112 then
				v113 = true
			else
				v113 = current3.sessionId == nil and current3.session.getCasSessionId() == v112
			end

			if v113 then
				v63(nil)
				return current2.trySubmitAnswerText(p2, p3, p4)
			end

			return false
		end, { v19, sessionId, v63 })
	end

	local v111 = {}
	v111.currentSessionId = v25
	v111.internalTesting = v29
	v111.agentSpecVersion = v26
	v111.setAgentSpecVersion = setAgentSpecVersion
	v111.messages = messages
	v111.localToolActions = v108
	v111.answerForm = v109
	v111.submitAnswerText = v110
	v111.composerText = v61
	v111.composerErrorText = state9
	v111.fundingFailure = state13
	v111.setComposerText = v82
	v111.setPrefilledComposerText = v83
	v111.composerImages = not FFlagBuildExperienceChatImageAttachments and {} or state11
	v111.setComposerImages = setComposerImages
	v111.retryComposerImage = retryComposerImage
	v111.composerResourceAttachments = not fFlagBuildExperienceChatResourceAttachments and {} or state12
	v111.findComposerResourceAttachmentIndexByUri = findComposerResourceAttachmentIndexByUri
	v111.addComposerResourceAttachment = addComposerResourceAttachment
	v111.removeComposerResourceAttachmentAtIndex = removeComposerResourceAttachmentAtIndex
	v111.clearComposerResourceAttachments = clearComposerResourceAttachments
	local v112 = if FFlagBuildExperienceModelPicker then not (v22 == nil) and v22.hasObservedModels else nil
	v111.hasPreparedModelSession = v112

	local v113 = if FFlagBuildExperienceModelPicker and v22 ~= nil then v22.models else nil
	v111.modelSessionModels = v113

	if not (FFlagBuildExperienceChatImageAttachments and v86) then
		v86 = FFlagBuildExperienceModelPicker

		if v86 then
			v86 = state3 or state8 or (v22 ~= nil and v22.isBusy and true or false) and not v59

			if not v86 then
				v86 = not (state9 == nil) and not state10
			end
		end
	end

	v111.isComposerSendBlocked = v86

	v111.isAssistantResponding = v59
	v111.canStopAssistantResponse = v42 ~= nil or (v58 or FFlagBuildExperienceModelPicker and state8)

	v111.canSendWhileResponding = v60
	v111.sendMessage = v95
	v111.stopAssistantResponse = v103
	v111.setScrollingFrame = v71.setScrollingFrame

	local v114 = if FFlagBuildExperienceChatAccordionScrollAnchor then v71.anchorToInstance else nil
	v111.anchorScrollToInstance = v114

	v111.textBoxRef = ref16
	v111.clockBinding = v70
	v111.playtestPlaceId = placeId

	if placeId == nil then
		v106 = nil
	end

	v111.launchPlaytest = v106
	v111.hasPublishedTurn = includesPublishTool
	v111.subagentTaskState = subagentTaskState
	v111.isHistoryHydrationComplete = v35
	v111.isHistoryLoading = v36
	v111.isHistoryExhausted = v55 and not v53
	return v111
end

return useChatSessionCore
