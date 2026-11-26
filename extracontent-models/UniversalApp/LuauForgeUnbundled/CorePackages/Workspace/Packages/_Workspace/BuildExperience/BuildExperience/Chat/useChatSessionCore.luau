local FFlagBuildExperienceModelPicker = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceModelPicker")
local FFlagBuildExperienceChatOpenId = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceChatOpenId")
local engineFeature = game:GetEngineFeature("BuildAppStorageKey")

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

local uploadCaptureAsync = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/utils/uploadCaptureAsync")

local Debug = CreatorAgentChat.debug
local requestFailureKind = CreatorAgentChat.RequestFailureKind
local sendBuildExperienceEvent = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Telemetry/sendBuildExperienceEvent")
local signal = Signals.createSignal(false)
local function noopSetAgentSpecVersion(p2) end

local v8 = {
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

	local v9 = p2.sessionId == p4 or p2.sessionId == nil and p2.session.getCasSessionId() == p4
	return v9
end

local function isEvolvingAdUpsellScope(p2, p3, p4)
	local v9 = p2.universeId == nil or p3 == nil or p2.universeId == p3
	local v10 = p2.sessionId == nil or p4 == nil or p2.sessionId == p4
	return v9 and v10
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

		local v9 = not (turnId == nil) and data.liveTurnIds[turnId] == true
		local historyWatermarkSequenceId = data.historyWatermarkSequenceId
		local v10 = not item.isDone

		if v10 then
			if historyWatermarkSequenceId == nil then
				v10 = false
			else
				v10 = historyWatermarkSequenceId < item.startSequenceId
			end
		end

		if v9 or v10 then
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
	local v9 = 8
	local function tryFocus()
		if callback() then
			return
		end

		local current = p2.current

		if current then
			current.focus()
			return
		end

		v9 -= 1

		if v9 > 0 then
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
	local v9 = p3 == true and p4 == nil and p5 ~= nil

	if p2 == nil and not v9 then
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

	local v9 = React.useContext(localizationRoactContext)
	local formatted = v9:Format(LocalizationStrings.CHAT_CREATE_UNIVERSE_ERROR)
	local formatted2 = v9:Format(LocalizationStrings.CHAT_CAPTURE_UPLOAD_ERROR)

	local v10 = if FFlagBuildExperienceModelPicker then SignalsReact.useSignalState(localUserIdStore.getCurrentUserId) else nil

	local state, setState = React.useState(nil)
	local state2, setState2 = React.useState(nil)

	if FFlagBuildExperienceModelPicker and state ~= nil and state.accountId ~= v10 then
		state = nil
	end

	if FFlagBuildExperienceModelPicker and state2 ~= nil and state2.accountId ~= v10 then
		state2 = nil
	end

	local ref = React.useRef(true)
	local v11 = React.useCallback(function()
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

	local v12 = data.hydrateHistoryWhen == nil or data.hydrateHistoryWhen
	local v13 = data.sendMessageWhen == nil or data.sendMessageWhen
	local v14 = fFlagBuildExperienceLibrary and data.isLibraryChat == true

	local v15 = if FFlagBuildAdUpsell then React.useRef(data.trackAdUpsellTurns == true).current else false

	local creatorAgentChatStore = CreatorAgentChat.getCreatorAgentChatStore()
	local v16 = GetAgentRollbackRequestStore()

	local v17 = React.useMemo(function()
		if universeId == nil then
			return nil
		end

		return creatorAgentChatStore.getSessionForProject(universeId, placeId, sessionId)
	end, { universeId, placeId, sessionId, creatorAgentChatStore, v10 })

	React.useLayoutEffect(function()
		if v17 == nil or sessionId == nil or sessionId == "" then
			return
		end

		v17.setCasSessionId(sessionId)
	end, { v17, sessionId })
	local v18, state3, setState3, v19

	if FFlagBuildExperienceModelPicker then
		local ref2 = React.useRef(true)

		React.useLayoutEffect(function()
			ref2.current = true
			return function()
				ref2.current = false
			end
		end, { ref2 })

		v18 = React.useMemo(function()
			return { pending = false, mounted = true }
		end, {
			v10,
			data.modelSelectionDraftId,
			data.universeId,
			data.placeId,
			data.sessionId
		})

		state3, setState3 = React.useState(false)
		local v20 = v18
		local v21 = setState3

		React.useLayoutEffect(function()
			v20.mounted = true
			v21(false)
			return function()
				v20.mounted = false
			end
		end, { v20, v21 })
		v19 = ref2
	else
		v19 = nil
		v18 = nil
		setState3 = nil
		state3 = false
	end

	local v20 = if FFlagBuildExperienceModelPicker then useBuildModelSession(universeId, data.modelSelectionDraftId, v17) else nil

	local v21 = React.useMemo(function()
		if v17 == nil then
			return signal5
		end

		return Signals.createComputed(function(p2)
			return {
				session = v17,
				sessionId = v17.getCasSessionId(),
				events = v17.getMergedHistory(p2)
			}
		end)
	end, { v17 })
	local v22 = SignalsReact.useSignalState(v21)
	local v23 = if v17 ~= nil then v17.getCasSessionId() else nil
	local v24 = nil
	local setAgentSpecVersion = noopSetAgentSpecVersion
	local v25 = nil
	local v26 = nil
	local v27 = nil

	if FFlagBuildExperienceModelPicker and enabled then
		local entry = if v20 ~= nil then v20.entry else nil
		local v29
		v29, v25 = v6(entry, v17, data.sessionId)
		v27 = v29

		if v27 ~= nil then
			v24 = v27.previewHash
		end

		setAgentSpecVersion = function(p2)
			if v27 ~= nil then
				v27.onSelect()
				v27.onSaveSpec(p2, v27.previewSpecName)
			end
		end
	elseif enabled then
		local ref2 = React.useRef(nil)

		if ref2.current == nil then
			ref2.current = CreatorAgentChat.experimentOverride.createPendingKey()
		end

		local current = ref2.current

		local ref3 = React.useRef(false)

		local v28 = CreatorAgentChat.experimentOverride.getKey(v23) or current

		local v29 = React.useMemo(function()
			return CreatorAgentChat.experimentOverride.getStateSignal(v28)
		end, { v28 })

		v24 = SignalsReact.useSignalState(v29).specVersion

		setAgentSpecVersion = React.useCallback(function(p2)
			local v30 = if v17 ~= nil then v17.getCasSessionId() else nil
			local v31 = CreatorAgentChat.experimentOverride.getKey(v30)

			if v31 == nil then
				v31 = current
				ref3.current = true

				if v17 ~= nil then
					v17.setPendingExperimentKey(current)
				end
			end

			CreatorAgentChat.experimentOverride.set(v31, p2)
		end, { v17, current })

		React.useEffect(function()
			if v17 == nil or not ref3.current then
				return
			end

			v17.setPendingExperimentKey(current)
		end, { v17, current })

		React.useEffect(function()
			return function()
				CreatorAgentChat.experimentOverride.clear(current)
			end
		end, { current })
		v26 = ref3
		v25 = current
	end

	local v28 = (v22.session ~= v17 or v22.sessionId ~= v23) and {} or v22.events
	local v29 = not (sessionId == nil) and sessionId ~= ""

	if not v29 then
		v29 = not (universeId == nil) and universeId ~= 0
	end

	local v30

	if v12 then
		v30 = not (v17 == nil) and (if v29 then not (v17.hasLoadedHistory() and #v28 > 0) else v29)
	else
		v30 = v12
	end

	local state4, setState4 = React.useState(function()
		return {
			session = v17,
			sessionId = sessionId,
			universeId = universeId,
			hydrateHistoryWhen = v12,
			isLoading = v30
		}
	end)
	local v32

	if
		state4 == nil
		or state4.session ~= v17
		or state4.sessionId ~= sessionId
		or state4.universeId ~= universeId
	then
		v32 = false
	else
		v32 = state4.hydrateHistoryWhen == v12
	end

	local v33 = if v32 then not state4.isLoading else not v30

	local v34 = not v33

	if not v34 then
		v34 = not (v17 == nil) and v17.getNextHistoryPageToken() ~= nil
	end

	local state5, setState5 = React.useState(nil)

	local state6, setState6 = React.useState(nil)

	React.useEffect(function()
		setState6(nil)
	end, { v17, sessionId })
	local v35 = sessionId
	local v36

	if state6 == nil or state6.session ~= v17 then
		v36 = false
	elseif v35 == nil or v35 == "" or state6.sessionId == v35 then
		v36 = true
	else
		v36 = state6.sessionId == nil and state6.session.getCasSessionId() == v35
	end

	if not v36 then
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
		local v37 = ref5
		local v38 = setState8

		local function fn()
			if
				enabled
				and v37.current ~= nil
				and not v37.current.started
				and ref3.current ~= nil
				and data.sessionId ~= nil
				and data.sessionId ~= ""
				and ref3.current.sessionId ~= data.sessionId
			then
				v37.current.attempt.release()
				v37.current = nil
			end

			if v37.current == nil then
				v38(false)
				setState5(nil)
			end

			return function()
				local current = v37.current

				if current ~= nil and not (current.started and current.attempt.isCurrent()) then
					current.attempt.release()
					v37.current = nil

					if current.onTerminal ~= nil then
						current.onTerminal()
					end
				end
			end
		end

		React.useLayoutEffect(fn, {
			if v20 ~= nil then v20.entry else nil,
			data.sessionId,
			v38,
			setState5
		})
	else
		ref5 = nil
		setState8 = nil
		state8 = false
	end

	local ref6 = React.useRef(nil)

	local v37 = React.useCallback(function(current, p2)
		assert(current == nil or p2 ~= nil, "Active turns require an owning session")
		ref2.current = current
		ref3.current = current ~= nil and {
			session = p2,
			sessionId = p2.getCasSessionId()
		} or nil

		setState7(current)
	end, { setState7 })

	local current = ref3.current
	local v38 = sessionId
	local v39

	if current == nil or current.session ~= v17 then
		v39 = false
	elseif v38 == nil or v38 == "" or current.sessionId == v38 then
		v39 = true
	else
		v39 = current.sessionId == nil and current.session.getCasSessionId() == v38
	end

	local v40 = if v39 then state7 else nil
	local v41 = if v40 == nil then signal2 else v40.getOptimisticLocalTools

	local v42 = if v40 == nil then signal3 else v40.getLocalToolActions

	local v43 = if v40 == nil then signal4 else v40.getSetupErrorText

	local v44 = SignalsReact.useSignalState(v41)
	local v45 = SignalsReact.useSignalState(v42)
	local v46 = SignalsReact.useSignalState(v43)

	if v46 ~= nil then
		v46 = v9:Format(v46)
	end

	local v47 = React.useMemo(function()
		local v50 = state5
		local v52 = data.createUniverseOnFirstPrompt == true and v17 == nil and v50 ~= nil

		if v40 == nil and not v52 then
			return nil
		end

		return { setupErrorText = v46 }
	end, { v40, data.createUniverseOnFirstPrompt, state5, v17, v46 })

	local v48 = React.useMemo(function()
		local v52 = if v17 == nil then sessionId else v17.getCasSessionId() or sessionId
		local v53 = if v17 == nil then universeId else v17.universeId
		local v54 = if v17 == nil then placeId else v17.placeId
		local v51 = {
			sessionId = v52,
			universeId = v53,
			placeId = v54,
			optimisticLocalTools = v44,
			pendingUserMessage = 0,
			pendingUserImages = 0,
			pendingUserResourceAttachments = 0,
			pendingUserMessageAfterSequenceId = 0,
			liveAssistantMessage = 0,
			optimisticCancelledStartSequenceId = 0
		}

		local v55 = if state5 ~= nil and not not sessionPromptMessageFilter.shouldOptimisticallyDisplay(state5.text) then state5.text else nil
		v51.pendingUserMessage = v55

		local v56 = if state5 ~= nil and not not sessionPromptMessageFilter.shouldOptimisticallyDisplay(state5.text) then state5.images else nil
		v51.pendingUserImages = v56

		local v57 = if state5 ~= nil and not not sessionPromptMessageFilter.shouldOptimisticallyDisplay(state5.text) then state5.resourceAttachments else nil
		v51.pendingUserResourceAttachments = v57

		local v58 = if state5 ~= nil then state5.afterSequenceId else nil
		v51.pendingUserMessageAfterSequenceId = v58

		v51.liveAssistantMessage = v47

		local v59 = if state6 ~= nil then state6.startSequenceId else nil
		v51.optimisticCancelledStartSequenceId = v59
		return parseSessionStream(v28, v51)
	end, {
		v28,
		v17,
		sessionId,
		universeId,
		placeId,
		v44,
		state5,
		v47,
		state6
	})
	local v49

	if v15 then
		local useRef = React.useRef
		local v50 = {
			isInitialized = false,
			universeId = universeId,
			sessionId = 0,
			historyWatermarkSequenceId = 0,
			lastProcessedSequenceId = nil,
			liveTurnIds = 0,
			liveTurnStartSequenceIds = 0
		}

		local v51 = if v17 == nil then sessionId else v17.getCasSessionId() or sessionId
		v50.sessionId = v51
		v50.historyWatermarkSequenceId = v48.latestSequenceId

		v50.liveTurnIds = {}
		v50.liveTurnStartSequenceIds = {}
		v49 = useRef(v50)
	else
		v49 = nil
	end

	local v50

	if v49 == nil then
		v50 = nil
	else
		v50 = React.useCallback(function(p2)
			if p2 ~= nil then
				v49.current.liveTurnIds[p2] = true
			end
		end, { v49 })
	end

	local messages = v48.messages
	local v51 = not (v17 == nil) and v17.getNextHistoryPageToken() ~= nil
	local v52 = v17 == nil or (not v29 or v17.hasLoadedHistory())

	local v53 = v33 and v52 and (v17 == nil or #messages > 0 or not v51)

	local subagentTaskState = v48.subagentTaskState
	local includesPublishTool = v48.includesPublishTool
	local message = messages[#messages]
	local v55 = React.useMemo(function()
		if placeId == nil then
			return signal
		end

		return v16.getIsPendingForPlaceId(placeId)
	end, { placeId, v16 })

	local v56 = SignalsReact.useSignalState(v55)
	local v57

	if v40 == nil then
		if message == nil or message.kind ~= "assistant_turn" then
			v57 = v56
		else
			v57 = not message.isDone or v56
		end
	else
		v57 = true
	end

	local v58 = v57 and not v56 and hasPendingLocalToolResponse(v44)

	local activeTurnState = v48.activeTurnState
	React.useEffect(function()
		if v40 == nil or activeTurnState == nil then
			return
		end

		v40.syncFromTurnState(activeTurnState)
	end, { v40, activeTurnState })

	if v15 then
		React.useEffect(function()
			local onAssistantTurnCompleted = data.onAssistantTurnCompleted

			local v59 = v49
			local v60 = if v17 == nil then universeId else v17.universeId or universeId
			local v61 = if v17 == nil then sessionId else v17.getCasSessionId() or sessionId
			local v62 = v59.current
			local v63 = v62.universeId == nil or v60 == nil or v62.universeId == v60
			local v64 = v62.sessionId == nil or v61 == nil or v62.sessionId == v61

			if v63 and v64 then
				v62.universeId = v60 or v62.universeId
				v62.sessionId = v61 or v62.sessionId
			else
				v62 = {
					isInitialized = false,
					universeId = v60,
					sessionId = v61,
					historyWatermarkSequenceId = v48.latestSequenceId,
					lastProcessedSequenceId = nil,
					liveTurnIds = {},
					liveTurnStartSequenceIds = {}
				}

				v59.current = v62
			end

			if v53 then
				if not v62.isInitialized then
					v62.isInitialized = true
					noteLiveAdUpsellTurns(v62, messages)
					local v65 = nil

					for k in v62.liveTurnStartSequenceIds do
						if v65 == nil or k < v65 then
							v65 = k
						end
					end

					if v65 == nil then
						v62.lastProcessedSequenceId = v62.historyWatermarkSequenceId or v48.latestSequenceId
					else
						v62.lastProcessedSequenceId = v65 - 1
					end

					v62.liveTurnIds = {}
					v62.liveTurnStartSequenceIds = {}
				end

				if v60 == nil or v60 == 0 then
					return
				end

				local v65 = v62.lastProcessedSequenceId or -1

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

					if endSequenceId == nil or endSequenceId <= v65 then
						continue
					end

					if onAssistantTurnCompleted ~= nil then
						onAssistantTurnCompleted({
							universeId = v60,
							sessionId = message2.sessionId or v61,
							turnState = message2.turnState,
							latestSequenceId = endSequenceId
						})
					end

					v62.lastProcessedSequenceId = endSequenceId
					v65 = endSequenceId
				end
			else
				v62.historyWatermarkSequenceId = v62.historyWatermarkSequenceId or v48.latestSequenceId
				noteLiveAdUpsellTurns(v62, messages)
			end
		end, {
			data.onAssistantTurnCompleted,
			v17,
			universeId,
			sessionId,
			v53,
			messages,
			v48.latestSequenceId
		})
	end

	local v59, v60 = React.useBinding("")
	local state9, setState9 = React.useState(nil)

	local state10, setState10 = React.useState(false)
	local v61 = React.useCallback(function(p2)
		setState9(p2)
		setState10(false)
	end, {})
	local v62 = React.useCallback(function(p2)
		setState9(p2)
		setState10(true)
	end, {})
	local ref7 = React.useRef("")
	local ref8 = React.useRef("")

	local ref9 = if FFlagBuildExperiencePrefillSkipsDraftPersist and engineFeature then React.useRef(nil) else nil

	local ref10 = React.useRef(nil)
	local ref11 = React.useRef(v23)
	local ref12 = React.useRef(nil)
	ref11.current = v23

	local v63 = data.createUniverseOnFirstPrompt == true and universeId == nil
	local createUniverseOnFirstPrompt = data.createUniverseOnFirstPrompt == true
	local v64 = not FFlagBuildExperienceNewGameChatDraft and { current = createUniverseOnFirstPrompt }
		or React.useRef(createUniverseOnFirstPrompt)

	v64.current = createUniverseOnFirstPrompt

	local ref13 = if FFlagBuildExperienceRestoreStoppedPrompt then React.useRef(nil) else nil

	local ref14 = React.useRef({})
	local ref15 = React.useRef(0)
	local state11, setState11 = React.useState({})
	local ref16 = React.useRef({})

	local state12, setState12 = React.useState({})

	local ref17 = React.useRef({})
	local ref18 = React.useRef({
		universeId = data.universeId,
		placeId = data.placeId
	})

	local ref19 = React.useRef(nil)
	local v65 = ReactUtils.useClock()

	local v66 = useChatScroll(v14)

	local v67 = React.useCallback(function(p2, p3)
		GetPlaytestLoadingStore().setAgentStatusForPlaceId(p2, p3)
	end, {})

	local v68 = React.useCallback(function(callback)
		local function fn()
			if callback == nil then
				return false
			end

			return callback()
		end

		v66.captureDistanceFromBottom()

		if v17 == nil then
			return
		end

		v17.requestOlderHistoryWhile(fn, function()
			return v66.isNearTopRef.current
		end)
	end, { v17, v66 })

	local v69 = React.useCallback(function(callback)
		task.delay(0.1, function()
			if
				callback()
				or v17 == nil
				or v17.getNextHistoryPageToken() == nil
				or not v66.isNearTopRef.current
			then
				return
			end

			v68(callback)
		end)
	end, { v68, v66, v17 })

	local v70 = React.useCallback(function(p2)
		if not (v17 ~= nil and v17.getNextHistoryPageToken() ~= nil) then
			return
		end

		v69(p2)
	end, { v69, v17 })
	local ref20 = React.useRef(v70)
	ref20.current = v70

	React.useEffect(function()
		v66.setOnScrolledToTop(function()
			v68(nil)
		end)
		return function()
			v66.setOnScrolledToTop(nil)
		end
	end, { v66.setOnScrolledToTop, v68 })

	React.useEffect(function()
		if v12 and v17 ~= nil then
			local flag = false
			local function setHistoryLoading(p2)
				if setState4 == nil or flag then
					return
				end

				setState4({
					session = v17,
					sessionId = sessionId,
					universeId = universeId,
					hydrateHistoryWhen = v12,
					isLoading = p2
				})
			end
			local v71 = not (v17.hasLoadedHistory() and #v17.getMergedHistory(false) > 0)

			if setState4 ~= nil and not flag then
				setState4({
					session = v17,
					sessionId = sessionId,
					universeId = universeId,
					hydrateHistoryWhen = v12,
					isLoading = v71
				})
			end

			local v72 = sessionId
			local function isHydrateCancelled(): boolean
				if flag then
					return true
				end

				if v72 == nil or v72 == "" then
					return false
				end

				return v17.getCasSessionId() ~= v72
			end

			local function continueAfterSessionReady()
				local v73 = if flag then true else not (v72 == nil or v72 == "") and v17.getCasSessionId() ~= v72

				if v73 then
					return
				end

				ref20.current(isHydrateCancelled)
			end

			local function hydrateKnownSession(p2)
				v17.setCasSessionId(p2)

				if v14 and ref2.current ~= nil then
					if setState4 ~= nil then
						if flag then
							return
						end

						setState4({
							session = v17,
							sessionId = sessionId,
							universeId = universeId,
							hydrateHistoryWhen = v12,
							isLoading = false
						})
					end
				elseif
					v14
					or not v17.hasLoadedHistory()
					or not (#v17.getMergedHistory(false) > 0)
					or FFlagBuildExperienceModelPicker and not v17.hasObservedModels(false)
				then
					if v17.refreshSession(isHydrateCancelled, true) then
						local v73 = if flag then true else not (v72 == nil or v72 == "") and v17.getCasSessionId() ~= v72

						if not v73 then
							local v74 = if flag then true else not (v72 == nil or v72 == "") and v17.getCasSessionId() ~= v72

							if not v74 then
								ref20.current(isHydrateCancelled)
							end
						end
					end

					if setState4 ~= nil then
						if flag then
							return
						end

						setState4({
							session = v17,
							sessionId = sessionId,
							universeId = universeId,
							hydrateHistoryWhen = v12,
							isLoading = false
						})
					end
				else
					local v73 = if flag then true else not (v72 == nil or v72 == "") and v17.getCasSessionId() ~= v72

					if not v73 then
						ref20.current(isHydrateCancelled)
					end

					if setState4 ~= nil then
						if flag then
							return
						end

						setState4({
							session = v17,
							sessionId = sessionId,
							universeId = universeId,
							hydrateHistoryWhen = v12,
							isLoading = false
						})
					end
				end
			end

			task.spawn(function()
				local v73 = sessionId

				if v14 and (v73 == nil or v73 == "") then
					v73 = v17.getCasSessionId()
				end

				if v73 ~= nil and v73 ~= "" then
					hydrateKnownSession(v73)
					return
				end

				if FFlagBuildExperienceModelPicker then
					local casSessionId = v17.getCasSessionId()

					if
						casSessionId ~= nil
						and v17.hasLoadedHistory()
						and #v17.getMergedHistory(false) > 0
						and not v17.hasObservedModels(false)
					then
						hydrateKnownSession(casSessionId)
						return
					end
				end

				if
					universeId == nil
					or universeId == 0
					or v17.hasLoadedHistory() and #v17.getMergedHistory(false) > 0
				then
					if setState4 ~= nil then
						if flag then
							return
						end

						setState4({
							session = v17,
							sessionId = sessionId,
							universeId = universeId,
							hydrateHistoryWhen = v12,
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
						local v74 = if flag then true else not (v72 == nil or v72 == "") and v17.getCasSessionId() ~= v72

						if v74 then
							break
						end

						task.wait()
					end

					if v14 then
						local v74 = if flag then true else not (v72 == nil or v72 == "") and v17.getCasSessionId() ~= v72

						if v74 then
							return
						end

						local casSessionId = v17.getCasSessionId()

						if casSessionId ~= nil and casSessionId ~= "" then
							hydrateKnownSession(casSessionId)
							return
						end
					end

					local v74 = if flag then true else not (v72 == nil or v72 == "") and v17.getCasSessionId() ~= v72

					if v74 or sessionFindByUniverse.state(false).status ~= "succeeded" then
						if setState4 ~= nil then
							if flag then
								return
							end

							setState4({
								session = v17,
								sessionId = sessionId,
								universeId = universeId,
								hydrateHistoryWhen = v12,
								isLoading = false
							})
						end
					else
						local result = sessionFindByUniverse.state(false).result
						local sessions = if result ~= nil then result.sessions else nil
						local v75 = if typeof(sessions) == "table" then sessions[1] else nil
						local sessionId2 = if typeof(v75) == "table" then v75.sessionId else nil

						if typeof(sessionId2) == "string" and sessionId2 ~= "" then
							setState2({
								universeId = universeId,
								placeId = placeId,
								sessionId = sessionId2,
								accountId = if FFlagBuildExperienceModelPicker then v10 else nil
							})
						else
							v17.markHistoryLoaded()

							if setState4 ~= nil then
								if flag then
									return
								end

								setState4({
									session = v17,
									sessionId = sessionId,
									universeId = universeId,
									hydrateHistoryWhen = v12,
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
				session = v17,
				sessionId = sessionId,
				universeId = universeId,
				hydrateHistoryWhen = v12,
				isLoading = false
			})
		end
	end, { v17, sessionId, universeId, placeId, creatorAgentChatStore, v12, v14, v10 })

	React.useEffect(function()
		if v17 == nil then
			return
		end

		local v71 = false
		local function refreshKnownSession()
			local v72 = v17.getCasSessionId()

			if (v72 == nil or v72 == "") and sessionId ~= nil and sessionId ~= "" then
				v72 = sessionId
			end

			if v72 == nil or v72 == "" then
				return
			end

			task.spawn(function()
				local function isRefreshCancelled()
					return v71
				end

				if v17.refreshSession(isRefreshCancelled, true) and not v71 then
					ref20.current(function()
						return v71
					end)
				end
			end)
		end

		local connection = MessageBusService:Subscribe(messageId, function(p2)
			ref.current = true

			if engineFeature then
				local v72 = v17.getCasSessionId()

				if (v72 == nil or v72 == "") and sessionId ~= nil and sessionId ~= "" then
					v72 = sessionId
				end

				local v73 = FFlagBuildExperiencePrefillSkipsDraftPersist

				if v73 then
					v73 = not (ref7.current == "") and ref7.current == ref9.current
				end

				if v72 ~= nil and v72 ~= "" and not v73 then
					local v74 = v7.getChatDraft(v72) or ""
					ref8.current = v74
					ref7.current = v74
					v60(v74)
					v61(nil)
				end
			end

			refreshKnownSession()
		end, false, true)
		local onUnhideConnection = AppLifecycleObserverService.OnUnhide:Connect(refreshKnownSession)

		return function()
			v71 = true
			connection:Disconnect()
			onUnhideConnection:Disconnect()
		end
	end, { v17, sessionId, ref })

	React.useEffect(function()
		if not v12 then
			return
		end

		v66.lockToBottom()
	end, { v12, v14, v17, sessionId, v66 })

	local v71 = React.useCallback(function(current2)
		ref7.current = current2
		v60(current2)
		v61(nil)
	end, { v60, v61 })
	local v72

	if engineFeature then
		v72 = React.useCallback(function()
			if ref10.current ~= nil then
				task.cancel(ref10.current)
				ref10.current = nil
			end
		end, {})
	else
		v72 = nil
	end

	local v73

	if FFlagBuildExperienceNewGameChatDraft then
		v73 = React.useCallback(function()
			local current2 = ref11.current

			if current2 ~= nil and current2 ~= "" then
				return current2
			end

			if v64.current then
				return getNewGameChatDraftKey()
			end

			return nil
		end, {})
	else
		v73 = nil
	end

	local v74

	if engineFeature then
		v74 = React.useCallback(function(current2)
			ref8.current = current2
			v72()

			local v75 = if FFlagBuildExperienceNewGameChatDraft then v73() else ref11.current

			if v75 == nil or v75 == "" then
				return
			end

			ref10.current = task.delay(0.5, function()
				ref10.current = nil
				v7.setChatDraft(v75, current2)
			end)
		end, { v72, v73 })
	else
		v74 = nil
	end

	local v75

	if engineFeature then
		v75 = React.useCallback(function(current2)
			local v76 = if FFlagBuildExperienceNewGameChatDraft then v73() else ref11.current

			if v76 == nil or v76 == "" then
				return
			end

			ref8.current = current2
			v72()
			v7.setChatDraft(v76, current2)
		end, { v72, v73 })
	else
		v75 = nil
	end

	local v76

	if engineFeature then
		v76 = React.useCallback(function(p2, p3)
			local v77 = if FFlagBuildExperienceNewGameChatDraft and v64.current then getNewGameChatDraftKey() else nil

			if v77 ~= nil then
				v7.setChatDraft(v77, "")
			end

			if p3 == nil or p3 == "" or ref8.current ~= p2 then
				return
			end

			ref8.current = ""
			v72()
			v7.setChatDraft(p3, "")
		end, { v72 })
	else
		v76 = nil
	end

	local v77 = React.useCallback(function(p2)
		v71(p2)

		if engineFeature then
			if FFlagBuildExperiencePrefillSkipsDraftPersist then
				local current2 = ref9.current

				if current2 ~= nil and p2 == current2 then
					return
				end

				ref9.current = nil
			end

			v74(p2)
		end
	end, { v71, v74 })
	local v78

	if FFlagBuildExperiencePrefillSkipsDraftPersist and engineFeature then
		v78 = React.useCallback(function(current2)
			ref9.current = current2
			v71(current2)
		end, { v71 })
	else
		v78 = v77
	end

	if FFlagBuildExperienceNewGameChatDraft and engineFeature then
		React.useEffect(function()
			if not v63 or v23 ~= nil and v23 ~= "" then
				return
			end

			local v79 = getNewGameChatDraftKey()

			if v79 == nil then
				return
			end

			local v80 = v7.getChatDraft(v79) or ""

			if v80 ~= "" and ref7.current == "" then
				ref8.current = v80
				v71(v80)
			end
		end, { v63, v23, v71 })
	end

	local function fn()
		if not engineFeature or (v23 == nil or v23 == "") then
			return
		end

		local current2 = ref12.current
		ref12.current = v23
		v72()

		if FFlagBuildExperiencePrefillSkipsDraftPersist and current2 == nil and ref7.current ~= "" and ref7.current == ref9.current then
			ref8.current = v7.getChatDraft(v23) or ""
		elseif current2 == nil and ref7.current ~= "" then
			ref8.current = ref7.current
			v7.setChatDraft(v23, ref7.current)
		else
			local v79 = v7.getChatDraft(v23) or ""
			ref8.current = v79
			v71(v79)
		end

		return function()
			local v79 = ref10.current ~= nil
			v72()

			if v79 then
				v7.setChatDraft(v23, ref8.current)
			end
		end
	end

	React.useEffect(fn, {
		v23,
		v72,
		v71,
		if FFlagBuildExperienceModelPicker then v17 else nil
	})

	local function commitComposerResourceAttachments(current2)
		ref17.current = current2
		setState12(current2)
		v61(nil)
	end

	local function findComposerResourceAttachmentIndexByUri(p2)
		for k, v81 in ref17.current do
			if chatTypes.getResourceAttachmentUri(v81) == p2 then
				return k
			end
		end

		return nil
	end

	local function addComposerResourceAttachment(p2)
		local clone = table.clone(ref17.current)
		table.insert(clone, p2)
		ref17.current = clone
		setState12(clone)
		v61(nil)
	end

	local function removeComposerResourceAttachmentAtIndex(p2)
		local clone = table.clone(ref17.current)
		table.remove(clone, p2)
		ref17.current = clone
		setState12(clone)
		v61(nil)
	end

	local function clearComposerResourceAttachments()
		local v81 = {}
		ref17.current = v81
		setState12(v81)
		v61(nil)
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

	local function commitComposerImages(current2)
		ref16.current = current2
		setState11(current2)
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
		local current2 = ref16.current
		local clone = table.clone(current2)

		for k, v81 in current2 do
			if v81.capture == p2 then
				clone[k] = fn2(v81)
				ref16.current = clone
				setState11(clone)

				return clone
			end
		end

		return current2
	end

	local function beginComposerImageUpload(p2)
		ref15.current += 1
		local current2 = ref15.current
		ref14.current[p2] = current2

		local v82 = updateComposerImage(p2, function(p3)
			local clone = table.clone(p3)
			clone.uri = nil
			clone.uploadStatus = "uploading"
			clone.uploadError = nil
			return clone
		end)
		local flag = true
		local v83

		for k, v84 in v82 do
			if v84.uploadStatus == "failed" then
				v83 = true
				flag = false
				break
			end
		end

		if flag then
			v83 = false
		end

		if not v83 then
			v61(nil)
		end

		uploadCaptureAsync(p2):andThen(function(p3)
			if ref14.current[p2] ~= current2 then
				return
			end

			ref14.current[p2] = nil
			local v84 = updateComposerImage(p2, function(p4)
				local clone = table.clone(p4)
				clone.uri = `rbxassetid://{p3.assetId}`
				clone.uploadStatus = "uploaded"
				clone.uploadError = nil
				return clone
			end)
			local flag2 = true
			local v85

			for k, v86 in v84 do
				if v86.uploadStatus == "failed" then
					v85 = true
					flag2 = false
					break
				end
			end

			if flag2 then
				v85 = false
			end

			if not v85 then
				v61(nil)
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

			v61(formatted2)
		end)
	end

	local function setComposerImages(list)
		local current2 = ref16.current

		local captures = {}
		local v81 = {}

		for i = 1, math.min(#list, 2) do
			local item = list[i]
			local v82

			if item.capture == nil or item.uri ~= nil or item.uploadStatus ~= nil then
				v82 = item
			else
				v82 = item

				for k, v84 in current2 do
					if v84.capture == item.capture then
						v82 = v84
						break
					end
				end
			end

			if v82.uri == nil or v82.uploadStatus ~= nil then
				if v82.capture ~= nil and v82.uri == nil and v82.uploadStatus == nil then
					v82 = table.clone(v82)
					v82.uploadStatus = "uploading"
					table.insert(captures, v82.capture)
				end
			else
				v82 = table.clone(v82)
				v82.uploadStatus = "uploaded"
			end

			table.insert(v81, v82)
		end

		for k, v82 in current2 do
			local v83 = false

			for k2, v85 in v81 do
				if v85.capture == v82.capture then
					v83 = true
					break
				end
			end

			if v83 or v82.capture == nil then
				continue
			end

			ref14.current[v82.capture] = nil
		end

		ref16.current = v81
		setState11(v81)
		local flag = true
		local v82

		for k, v83 in v81 do
			if v83.uploadStatus == "failed" then
				v82 = true
				flag = false
				break
			end
		end

		if flag then
			v82 = false
		end

		if not v82 then
			v61(nil)
		end

		for k, v83 in captures do
			beginComposerImageUpload(v83)
		end
	end
	local ref22 = React.useRef(setComposerImages)
	ref22.current = setComposerImages

	local function retryComposerImage(p2)
		local v81 = ref16.current[p2]

		if v81 == nil or v81.capture == nil or v81.uploadStatus ~= "failed" then
			return
		end

		beginComposerImageUpload(v81.capture)
	end

	local v81 = false

	for k, v83 in state11 do
		if v83.uri == nil or v83.uploadStatus == "uploading" or v83.uploadStatus == "failed" then
			v81 = true
			break
		end
	end

	local v83 = React.useCallback(function(p2)
		return function(p3, p4)
			if ref4.current == p2 then
				local current2 = ref3.current
				local v85 = sessionId
				local v86

				if current2 == nil or current2.session ~= v17 then
					v86 = false
				elseif v85 == nil or v85 == "" or current2.sessionId == v85 then
					v86 = true
				else
					v86 = current2.sessionId == nil and current2.session.getCasSessionId() == v85
				end

				if v86 then
					local v87 = false

					if FFlagBuildExperienceAnswerForm then
						local current3 = ref2.current

						if current3 ~= nil then
							local getLocalToolActions = current3.getLocalToolActions
							v87 = next(getLocalToolActions(false).onAnswerSelectedByToolCallId) ~= nil
						end
					end

					if p3 ~= nil and ref7.current == "" and not v87 then
						v77(p3)
					end

					v61((v9:Format((creatorAgentChat.getToolResultFailureComposerError(p4)))))
				end
			end
		end
	end, { v17, sessionId, v77, v61, v9 })

	local v84 = data.onPromptFailure
	local state13

	if FFlagBuildExperienceModelPicker then
		local setState13
		state13, setState13 = React.useState(nil)

		if state13 == nil or state13.owner ~= v17 then
			state13 = nil
		end

		v84 = React.useCallback(function(p2, p3)
			if p2 == CreatorAgentChat.ErrorCodes.OutOfCredits then
				setState13(function(p4)
					return {
						count = not p4 and 1 or p4.count + 1,
						reason = p3,
						owner = v17
					}
				end)
			end

			if data.onPromptFailure ~= nil then
				data.onPromptFailure(p2, p3)
			end
		end, { v17, data.onPromptFailure })
	end

	local v85 = React.useCallback(function(p2, p3, p4, p5, p6, data2)
		if ref4.current ~= p2 then
			return
		end

		if FFlagBuildExperienceModelPicker and v19 ~= nil and not v19.current then
			GetBuildCreatorCreditRefreshStore(false).settled()
			return
		end

		v37(nil)
		ref6.current = nil
		setState5(nil)

		if FFlagBuildExperienceModelPicker then
			GetBuildCreatorCreditRefreshStore(false).settled()
		end

		if p3 == nil then
			if data2.placeId ~= nil then
				v67(data2.placeId, "Completed")
			end

			v66.scrollToBottomAfterSend()

			local casSessionId = data2.getCasSessionId()

			if casSessionId ~= nil and casSessionId ~= "" then
				if data.createUniverseOnFirstPrompt and sessionId == nil and data2.universeId ~= nil then
					local v86 = {
						universeId = data2.universeId,
						placeId = data2.placeId,
						sessionId = casSessionId
					}

					if FFlagBuildExperienceModelPicker then
						local clone = table.clone(v86)
						clone.accountId = v10
						setState(clone)
					else
						setState(v86)
					end

					if data.onProjectResolved ~= nil then
						data.onProjectResolved(v86)
					end
				end

				task.spawn(function()
					data2.refreshSession(function(): boolean
						return ref4.current ~= p2
					end)
				end)
			end
		else
			if v84 ~= nil then
				v84(p3.errorCode, p3.outOfCreditsReason)
			end

			if data2.placeId ~= nil then
				v67(data2.placeId, "Idle")
			end

			if p5 ~= nil then
				ref22.current(p5)
			end

			if p6 ~= nil then
				ref21.current(p6)
			end

			if p4 ~= nil then
				v77(p4)
				v61((v9:Format((creatorAgentChat.getPromptFailureComposerError(p3)))))
			end

			task.spawn(function()
				data2.refreshSession(function(): boolean
					return ref4.current ~= p2
				end)
			end)
		end
	end, {
		v19,
		data.createUniverseOnFirstPrompt,
		v84,
		data.onProjectResolved,
		sessionId,
		v67,
		setState,
		v10,
		v66,
		v77,
		v61,
		v37,
		setState5,
		v9
	})

	local ref23 = React.useRef(v12)
	React.useEffect(function()
		local v86 = v12 and not ref23.current
		ref23.current = v12

		if v14 or not v12 or not v86 and not v57 and v40 == nil then
			return
		end

		v66.scrollToBottomUnconditionally()
		task.defer(v66.scrollToBottomUnconditionally)
		task.delay(0.15, v66.scrollToBottomUnconditionally)
	end, {
		v12,
		v14,
		v57,
		v40,
		#messages,
		v66
	})

	React.useEffect(function()
		if ref2.current ~= nil then
			local current2 = ref3.current
			local v87 = sessionId
			local v88

			if current2 == nil or current2.session ~= v17 then
				v88 = false
			elseif v87 == nil or v87 == "" or current2.sessionId == v87 then
				v88 = true
			else
				v88 = current2.sessionId == nil and current2.session.getCasSessionId() == v87
			end

			if v88 then
				return
			end
		end

		if not (state6 == nil and v17 ~= nil) then
			return
		end

		local v86 = v17
		local v87 = v86.getCasSessionId()

		if typeof(v87) ~= "string" or v87 == "" then
			local universeId2 = v86.universeId
			local placeId2 = v86.placeId
			v87 = if not (universeId2 == nil or placeId2 == nil) then `{universeId2}:{placeId2}` else nil
		end

		if v87 == nil then
			return
		end

		local function attachResumedTurn(p2, current2)
			ref4.current += 1
			local current3 = ref4.current
			ref6.current = current2

			if placeId ~= nil then
				v67(placeId, "Loading")
			end

			local createResumedAssistantTurn = creatorAgentChat.createResumedAssistantTurn

			local function fn2(p3)
				v85(current3, p3, nil, nil, nil, v17)
			end
			local v90 = if current2 ~= nil then current2 - 1 else nil
			local resumedAssistantTurn = createResumedAssistantTurn(v17, p2, fn2, v90, v83(current3), v11)

			v37(resumedAssistantTurn, v17)
			resumedAssistantTurn.start()
			v66.scrollToBottomUnconditionally()
		end

		if v48.activeTurnState == nil or v48.activeTurnItemIndex == nil or v48.activeTurnState.isDone then
			ref6.current = nil

			local activeTurnHandle = creatorAgentChatStore.getActiveTurnHandle(v87)
			local v88 = if activeTurnHandle ~= nil then activeTurnHandle.state(false) else nil
			local v89 = not (activeTurnHandle == nil or v88 == nil) and not v88.isDone

			if (v57 or v89) and v89 then
				attachResumedTurn(activeTurnHandle, nil)
			end
		else
			local activeTurnStartSequenceId = v48.activeTurnStartSequenceId

			if ref6.current == activeTurnStartSequenceId and v40 ~= nil then
				return
			end

			local v88 = creatorAgentChatStore.resumeTurnFromHistory(
				v87,
				v48.activeTurnState,
				v48.activeTurnSequenceIds
			)

			if v88 ~= nil then
				attachResumedTurn(v88, activeTurnStartSequenceId)
			end
		end
	end, {
		v48,
		v17,
		sessionId,
		creatorAgentChatStore,
		v57,
		v40,
		placeId,
		v67,
		v85,
		v66,
		v37,
		state6,
		v83,
		v11
	})

	local v86 = React.useCallback(
		function(p2, p3, p4, p5, p6, current2, p7, p8, callback, onTerminal, callback2, p9, callback3)
			local function startAdmitted(p10)
				setState5({
					text = p3,
					images = p5,
					resourceAttachments = p6,
					afterSequenceId = p7
				})

				local v87 = v50

				local fn2 = engineFeature and p8 ~= nil and function(p11)
					if v87 ~= nil then
						v87(p11)
					end

					v76(p8, p2.getCasSessionId() or sessionId)
				end or v87
				local v88

				if FFlagBuildExperienceRestoreStoppedPrompt and ref13 ~= nil then
					local v89 = ref13
					v88 = function(p11)
						v89.current = current2

						if fn2 ~= nil then
							fn2(p11)
						end
					end
				else
					v88 = fn2
				end

				local fn3 = callback ~= nil and function(p11)
					if v88 ~= nil then
						v88(p11)
					end

					callback(p2.getCasSessionId())
				end or v88

				local fn4 = fFlagBuildExperienceLibrary and callback2 ~= nil and function()
					if engineFeature and p8 ~= nil then
						v76(p8, p2.getCasSessionId() or sessionId)
					end

					callback2(p2.getCasSessionId())
				end or nil
				local v89, v90

				if FFlagBuildExperienceModelPicker and p9 ~= nil then
					local v91 = p9

					v89 = fn3 ~= nil and function(p11)
						if v91.isCurrent() then
							fn3(p11)
						end
					end or fn3

					if fn4 == nil then
						v90 = fn4
					else
						v90 = function()
							if v91.isCurrent() then
								fn4()
							end
						end
					end
				else
					v90 = fn4
					v89 = fn3
				end

				local v91 = nil
				local createLiveAssistantTurn = creatorAgentChat.createLiveAssistantTurn

				local function fn5(p11)
					if FFlagBuildExperienceModelPicker and p9 ~= nil then
						local current3 = p9.isCurrent()
						p9.release()

						if not current3 then
							if ref2.current == v91 and ref4.current == current2 then
								v37(nil)
								ref6.current = nil
								setState5(nil)

								if p2.placeId ~= nil then
									v67(p2.placeId, "Idle")
								end
							end

							if onTerminal ~= nil then
								onTerminal()
							end

							return
						end
					end

					v85(current2, p11, p8, p5, p6, p2)

					if onTerminal ~= nil then
						onTerminal()
					end
				end
				local v94 = v83(current2)
				local v96 = if FFlagBuildExperienceModelPicker then p10 else nil
				local v97 = if FFlagBuildExperienceModelPicker and p10 ~= nil then p10.sessionId else nil
				v91 = createLiveAssistantTurn(
					p2,
					p4,
					fn5,
					v94,
					v11,
					v89,
					v90,
					v96,
					v97,
					FFlagBuildExperienceModelPicker and p9 ~= nil and function(): boolean
						return not p9.isCurrent()
					end or nil
				)

				if p2.placeId ~= nil then
					v67(p2.placeId, "Loading")
				end

				v37(v91, p2)
				v66.scrollToBottomAfterSend()
				v91.start()
			end

			if not FFlagBuildExperienceModelPicker then
				startAdmitted(nil)
				return
			end

			local v87 = ref5
			local v88 = setState8
			local v89 = p9

			if not v89 then
				local entry = if v20 ~= nil then v20.entry else nil
				local creatorCreditStore = CreatorCredit.getCreatorCreditStore(false)
				local promptExperiment = CreatorAgentChat.experimentOverride.getPromptExperiment(CreatorAgentChat.experimentOverride.getKey(p2.getCasSessionId()) or v25)
				local v91

				if enabled and v25 ~= nil then
					v91 = CreatorAgentChat.experimentOverride.getInternalSelection(
						CreatorAgentChat.experimentOverride.getKey(p2.getCasSessionId()) or v25,
						false
					)
				end

				v89 = beginBuildModelSend(entry, creatorCreditStore, promptExperiment, v91)
			end

			p9 = v89

			if p9 == nil then
				if onTerminal ~= nil then
					onTerminal()
				end
			else
				local v90 = p9

				local v91 = {
					attempt = v90,
					started = false,
					onTerminal = onTerminal,
					restoreDraft = callback3
				}
				v87.current = v91
				v88(true)
				task.spawn(function()
					local success, result, v92 = pcall(v90.prepare, p2)
					local v93 = not v90.isCurrent() or ref4.current ~= current2

					if v93 or not success or result == nil then
						v90.release()

						if v87.current == v91 then
							v87.current = nil
							v88(false)
							setState5(nil)
						end

						if v93 then
							if ref4.current == current2 and callback3 ~= nil then
								callback3(true)
							end
						else
							local v94 = LocalizationStrings.CHAT_DEFAULT_FAILURE

							if success and v92 ~= nil then
								if v92.kind == "setup" then
									local getPromptFailureComposerError = creatorAgentChat.getPromptFailureComposerError
									local v95 = {
										errorCode = v92.errorCode,
										isContentPolicy = false,
										setupStage = 0
									}

									local v96 = if v92.setupError and v92.setupError.stage ~= "session_load" then v92.setupError.stage else nil
									v95.setupStage = v96
									v94 = getPromptFailureComposerError(v95)
								elseif v92.kind == "unavailable" then
									v94 = LocalizationStrings.MODEL_PICKER_UNAVAILABLE
								elseif v92.kind == "denied" then
									v94 = LocalizationStrings.CHAT_ERROR_OUT_OF_CREDITS
									GetBuildCreatorCreditRefreshStore(false).refresh()
								end

								if v84 ~= nil then
									v84(v92.errorCode, v92.reason)
								end
							end

							if callback3 ~= nil then
								callback3(false)
							end

							v62(v9:Format(v94))
						end

						if onTerminal ~= nil then
							onTerminal()
						end
					else
						v88(false)
						v91.started = true
						startAdmitted(result)
					end
				end)
			end
		end,
		{
			v20,
			v25,
			ref5,
			v18,
			setState8,
			v62,
			v9,
			v84,
			v85,
			v67,
			v66,
			v37,
			setState5,
			v83,
			v11,
			v50,
			v76,
			sessionId
		}
	)

	local ref24 = React.useRef(v48.latestSequenceId)
	ref24.current = v48.latestSequenceId
	local v88 = useAgentRollbackRequest({
		universeId = universeId,
		placeId = placeId,
		session = v17,
		activeTurnHandleRef = ref2,
		startRollbackTurn = React.useCallback(function(data2, callback, callback2)
			local v88 = v17

			if v88 == nil then
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

			v66.captureStickToBottomForSend()
			ref4.current += 1
			local current2 = ref4.current
			setState6(nil)
			local v90 = buildAgentRollbackPrompt(data2.versionNumber, data2.noteTitle, data2.noteDescription)

			v86(v88, v90, v90, nil, nil, current2, ref24.current, nil, function()
				v66.scrollToBottomUnconditionally()
				callback()
			end, callback2)
		end, { v17, ref5, v66, setState6, v86 })
	})

	React.useLayoutEffect(function()
		if state7 ~= nil then
			local current2 = ref3.current
			local v90 = sessionId
			local v91

			if current2 == nil or current2.session ~= v17 then
				v91 = false
			elseif v90 == nil or v90 == "" or current2.sessionId == v90 then
				v91 = true
			else
				v91 = current2.sessionId == nil and current2.session.getCasSessionId() == v90
			end

			if not v91 then
				local current3 = ref3.current
				ref4.current += 1
				ref6.current = nil

				if v88.stopRequestBeforeReceipt(state7) then
					if current3 ~= nil and current3.session.placeId ~= nil then
						v67(current3.session.placeId, "Idle")
					end
				else
					state7.detach()

					if FFlagBuildExperienceModelPicker then
						local v93 = ref5
						local current4 = v93.current

						if current4 ~= nil and current4.started then
							current4.attempt.unlockSelection()
							v93.current = nil
						end
					end
				end

				v37(nil, nil)
				setState5(nil)
				setState6(nil)
			end
		end
	end, { v17, sessionId, state7, v37, v88, v67, ref5 })

	local v89 = React.useCallback(function(p2, p3, p4, p5, p6, p7, p8, p9)
		setState5({
			text = p2,
			images = p4,
			resourceAttachments = p5,
			afterSequenceId = p7
		})

		local v90 = nil
		local universeId2 = nil

		if FFlagBuildExperienceModelPicker and data.modelSelectionDraftId ~= nil then
			v90 = GetBuildModelSelectionStore(false).retainDraftForCreation(data.modelSelectionDraftId)
		end

		local v91 = setState3
		local v92 = v18
		local entry = if v20 ~= nil then v20.entry else nil
		local function canConfigure(): boolean
			return entry ~= nil and entry.getSelection(false) ~= nil
		end

		if v92 ~= nil then
			v92.pending = true
			v91(true)
		end

		local lastTime = os.clock()
		local v93 = nil

		local v94 = if FFlagBuildExperienceChatOpenId then CreatorAgentChat.chatOpenTelemetry.getChatOpenIdForUniverse(nil) else nil

		local v95 = UniverseCreate.getUniverseCreateStore().createUniverse({
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
				v93 = { universeId = p10.universeId, placeId = p10.rootPlaceId }
			end

			local v96 = if FFlagBuildExperienceModelPicker then entry == nil or entry.getSelection(false) == nil else ref4.current ~= p6

			if v96 then
				return nil
			end

			local universeConfigurationStore = UniverseConfiguration.getUniverseConfigurationStore()

			return universeConfigurationStore.patchConfiguration(p10.universeId, {
				audiences = { 1 }
			}):andThen(function()
				if FFlagBuildExperienceModelPicker then
					local v97 = not (entry == nil) and entry.getSelection(false) ~= nil

					if not v97 then
						return nil
					end
				end

				return universeConfigurationStore.setTeamCreate(p10.universeId, true)
			end):andThen(function(): nil
				local v97

				if FFlagBuildExperienceModelPicker then
					v97 = entry == nil or entry.getSelection(false) == nil or v92 == nil or not v92.mounted
				else
					v97 = ref4.current ~= p6
				end

				if v97 then
					return nil
				end

				local v98 = { universeId = p10.universeId, placeId = p10.rootPlaceId }

				if FFlagBuildExperienceModelPicker then
					local clone = table.clone(v98)
					clone.accountId = v10
					setState(clone)
				else
					setState(v98)
				end

				if data.onProjectResolved ~= nil then
					data.onProjectResolved(v98)
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
					and (FFlagBuildExperienceModelPicker and CreatorAgentChat.experimentOverride.has(v25) or v26 ~= nil and v26.current)
				then
					sessionForProject.setPendingExperimentKey(v25)
				end

				v86(sessionForProject, p2, p3, p4, p5, p6, p7, p2, nil, nil, nil, p8, p9)

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
				local v96 = math.round((os.clock() - lastTime) * 1000)
				local v97 = v93 == nil and {} or {
					universeId = v93.universeId,
					placeId = v93.placeId
				}

				local v98 = FFlagBuildExperienceChatOpenId
					and {
						universeId = v97.universeId,
						placeId = v97.placeId,
						chatOpenId = v94
					}
					or v97

				local v99 = {
					isContentPolicy = "false",
					setupStage = v93 == nil and "create_universe" or "configure_universe",
					errorCopyKey = LocalizationStrings.CHAT_CREATE_UNIVERSE_ERROR,
					elapsedMs = tostring(v96),
					receivedResponse = "false",
					stalled = tostring(chatConstants.PROMPT_STALL_SECONDS * 1000 <= v96)
				}

				v99.failureKind = requestFailureKind.Unknown

				if typeof(p10) == "table" and typeof(p10.responseCode) == "number" then
					v99.failureKind = requestFailureKind.Http
					v99.httpStatusCode = tostring(p10.responseCode)
				end

				sendBuildExperienceEvent("SEND_PROMPT_START", v98)
				sendBuildExperienceEvent("SEND_PROMPT_FAILED", v98, v99)
			end

			v37(nil)
			setState5(nil)
			v77(p2)

			if p4 ~= nil then
				ref22.current(p4)
			end

			if p5 ~= nil then
				ref21.current(p5)
			end

			if p8 ~= nil then
				p8.release()

				setState8(false)
			end

			v61(formatted)
		end)

		if FFlagBuildExperienceModelPicker then
			v95:finally(function()
				if v90 ~= nil then
					v90(universeId2)
				end

				if v92 ~= nil then
					v92.pending = false

					if v92.mounted then
						v91(false)
					end
				end
			end)
		end
	end, {
		v18,
		v20,
		setState3,
		setState8,
		sessionId,
		creatorAgentChatStore,
		data.onProjectResolved,
		data.modelSelectionDraftId,
		v37,
		v77,
		v61,
		setState,
		v10,
		setState5,
		v86,
		formatted,
		v25,
		v26
	})

	local v90 = React.useCallback(function(p2): boolean
		if not v13 or v18 ~= nil and v18.pending then
			return false
		end

		local current2 = ref7.current
		local v91 = string.gsub(current2, "^%s*(.-)%s*$", "%1")

		local current3 = ref16.current
		local current4 = ref17.current

		if v91 == "" and #current3 == 0 then
			v77("")
			return false
		end

		for k, v92 in current3 do
			if v92.uri == nil or v92.uploadStatus == "uploading" or v92.uploadStatus == "failed" then
				return false
			end
		end

		local current5 = ref3.current
		local v93 = sessionId
		local v94

		if current5 == nil or current5.session ~= v17 then
			v94 = false
		elseif v93 == nil or v93 == "" or current5.sessionId == v93 then
			v94 = true
		else
			v94 = current5.sessionId == nil and current5.session.getCasSessionId() == v93
		end

		local current6 = if v94 then ref2.current else nil

		if v57 or v14 and current6 ~= nil then
			if
				#current3 > 0
				or #current4 > 0
				or (current6 == nil or not current6.trySubmitComposerText(v91))
			then
				return false
			end

			v77("")

			if ref19.current then
				ref19.current.releaseFocus()
			end

			v66.scrollToBottomAfterSend()
			return true
		else
			local v95 = data.createUniverseOnFirstPrompt == true and universeId == nil

			if not v95 and v17 == nil or placeId ~= nil and v16.getIsPendingForPlaceId(placeId)(false) then
				return false
			end

			local function restoreDraft(p3)
				if p3 and (ref7.current ~= "" or #ref16.current > 0 or #ref17.current > 0) then
					return
				end

				v77(v91)
				ref22.current(current3)
				ref21.current(current4)
			end

			local v96

			if FFlagBuildExperienceModelPicker then
				v61(nil)

				local entry = if v20 ~= nil then v20.entry else nil
				local creatorCreditStore = CreatorCredit.getCreatorCreditStore(false)
				local getPromptExperiment = CreatorAgentChat.experimentOverride.getPromptExperiment
				local getKey = CreatorAgentChat.experimentOverride.getKey
				local v98 = if v17 ~= nil then v17.getCasSessionId() else nil
				local promptExperiment = getPromptExperiment(getKey(v98) or v25)
				local v99

				if enabled and v25 ~= nil then
					local getInternalSelection = CreatorAgentChat.experimentOverride.getInternalSelection
					local getKey2 = CreatorAgentChat.experimentOverride.getKey
					local v100 = if v17 ~= nil then v17.getCasSessionId() else nil
					v99 = getInternalSelection(getKey2(v100) or v25, false)
				end

				v96 = beginBuildModelSend(entry, creatorCreditStore, promptExperiment, v99)

				if v96 == nil then
					return false
				end

				ref5.current = {
					attempt = v96,
					started = false,
					restoreDraft = restoreDraft
				}

				setState8(true)
			else
				v96 = nil
			end

			v66.captureStickToBottomForSend()
			ref4.current += 1
			local current7 = ref4.current
			setState6(nil)

			if engineFeature then
				v75(v91)
			end

			v71("")
			ref22.current({})
			ref21.current({})

			if ref19.current then
				ref19.current.releaseFocus()
			end

			local function startPrompt(p3, p4)
				if v95 then
					v89(
						v91,
						p3,
						p4,
						current4,
						current7,
						v48.latestSequenceId,
						v96,
						if FFlagBuildExperienceModelPicker then restoreDraft else nil
					)
				else
					local latestSequenceId = v48.latestSequenceId
					local v106 = if fFlagBuildExperienceLibrary then p2 else nil
					v86(
						v17,
						v91,
						p3,
						p4,
						current4,
						current7,
						latestSequenceId,
						v91,
						nil,
						nil,
						v106,
						v96,
						if FFlagBuildExperienceModelPicker then restoreDraft else nil
					)
				end
			end

			if #current3 == 0 and #current4 == 0 then
				startPrompt(v91, nil)
				return true
			end

			local v98 = {}

			if v91 ~= "" then
				table.insert(v98, { type = "text", text = v91 })
			end

			for k, v99 in current4 do
				if v99.type == "resource_link" then
					table.insert(v98, {
						type = v99.type,
						uri = v99.uri,
						name = v99.name,
						mimeType = v99.mimeType
					})
				else
					table.insert(v98, {
						type = v99.type,
						resource = {
							uri = v99.resource.uri,
							text = v99.resource.text,
							blob = nil,
							mimeType = v99.resource.mimeType
						}
					})
				end
			end

			local v99 = {}

			for k, v100 in current3 do
				local uri = v100.uri
				table.insert(v98, { type = "image", uri = uri })
				table.insert(v99, {
					capture = v100.capture,
					uri = uri,
					uploadStatus = "uploaded"
				})
			end

			startPrompt(v98, v99)
			return true
		end
	end, {
		v13,
		v18,
		v20,
		v25,
		ref5,
		setState8,
		v61,
		v17,
		sessionId,
		universeId,
		placeId,
		v57,
		v14,
		v66,
		v77,
		v71,
		v75,
		v89,
		v86,
		data.createUniverseOnFirstPrompt,
		setState6,
		v48,
		v16
	})

	local useCallback = React.useCallback
	local function fn2()
		if FFlagBuildExperienceModelPicker then
			local v91 = ref5
			local current2 = v91.current

			if current2 ~= nil and not current2.started then
				current2.attempt.release()
				v91.current = nil

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
		local v92 = sessionId
		local v93

		if current2 == nil or current2.session ~= v17 then
			v93 = false
		elseif v92 == nil or v92 == "" or current2.sessionId == v92 then
			v93 = true
		else
			v93 = current2.sessionId == nil and current2.session.getCasSessionId() == v92
		end

		local current3 = if v93 then ref2.current else nil

		if current3 == nil then
			v88.cancelRequestBeforeTurnStarts()
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

			if not v88.stopRequestBeforeReceipt(current3) then
				current3.stop()
			end

			v37(nil)
			ref6.current = nil

			if
				FFlagBuildExperienceRestoreStoppedPrompt
				and ref13 ~= nil
				and ref13.current ~= current4
				and state5 ~= nil
				and ref7.current == ""
				and v48.isAwaitingUserMessageEcho
			then
				v77(state5.text)

				if state5.images ~= nil and #ref16.current == 0 then
					ref22.current(state5.images)
				end

				if state5.resourceAttachments ~= nil and #ref17.current == 0 then
					ref21.current(state5.resourceAttachments)
				end
			end

			setState5(nil)
			setState6({
				session = v17,
				sessionId = v17.getCasSessionId(),
				startSequenceId = v48.activeTurnStartSequenceId
			})

			if placeId ~= nil then
				v67(placeId, "Idle")
			end
		end
	end

	local v96 = if FFlagBuildExperienceRestoreStoppedPrompt then state5 else nil
	local v98 = useCallback(fn2, {
		ref5,
		setState8,
		v17,
		sessionId,
		placeId,
		v67,
		v37,
		setState5,
		setState6,
		v48,
		v88,
		v96,
		if FFlagBuildExperienceRestoreStoppedPrompt then v77 else nil
	})

	local v99 = data.autoFocusComposer == nil or data.autoFocusComposer
	local v100 = if data.focusComposerWhen == nil then v99 else data.focusComposerWhen
	React.useEffect(function()
		if not (v99 and v100) then
			return function() end
		end

		local v101 = false
		local v102 = ref19
		local function fn3()
			return v101
		end

		local v103 = 8
		local function tryFocus()
			if fn3() then
				return
			end

			local current2 = v102.current

			if current2 then
				current2.focus()
				return
			end

			v103 -= 1

			if v103 > 0 then
				task.delay(0, tryFocus)
			end
		end
		task.defer(tryFocus)

		return function()
			v101 = true
		end
	end, { v99, v100 })

	local v101 = React.useCallback(function(p2)
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
	local v102

	if FFlagBuildExperienceAnswerForm then
		v102 = React.useMemo(function()
			local v103 = {}

			for k, v104 in v45.onAnswerSelectedByToolCallId do
				v103[k] = function(p2, p3, p4)
					v61(nil)
					v104(p2, p3, p4)
				end
			end

			local v104 = {}

			for k, v105 in v45.onAnswerConfirmedByToolCallId do
				v104[k] = function()
					v61(nil)
					v105()
				end
			end

			return {
				onAnswerSelectedByToolCallId = v103,
				onAnswerConfirmedByToolCallId = v104,
				onPlanAcceptedByToolCallId = v45.onPlanAcceptedByToolCallId,
				onDevProductApprovedByToolCallId = v45.onDevProductApprovedByToolCallId,
				onDevProductRejectedByToolCallId = v45.onDevProductRejectedByToolCallId
			}
		end, { v45, v61 })
	else
		v102 = v45
	end

	local v103

	if FFlagBuildExperienceAnswerForm then
		v103 = React.useMemo(function()
			return v5(activeTurnState, v44, v102)
		end, { activeTurnState, v44, v102 })
	end

	local v104

	if FFlagBuildExperienceAnswerForm then
		v104 = React.useCallback(function(p2, p3, p4)
			local current2 = ref2.current

			if current2 == nil then
				return false
			end

			local current3 = ref3.current
			local v106 = sessionId
			local v107

			if current3 == nil or current3.session ~= v17 then
				v107 = false
			elseif v106 == nil or v106 == "" or current3.sessionId == v106 then
				v107 = true
			else
				v107 = current3.sessionId == nil and current3.session.getCasSessionId() == v106
			end

			if v107 then
				v61(nil)
				return current2.trySubmitAnswerText(p2, p3, p4)
			end

			return false
		end, { v17, sessionId, v61 })
	end

	local v105 = {}
	v105.currentSessionId = v23
	v105.internalTesting = v27
	v105.agentSpecVersion = v24
	v105.setAgentSpecVersion = setAgentSpecVersion
	v105.messages = messages
	v105.localToolActions = v102
	v105.answerForm = v103
	v105.submitAnswerText = v104
	v105.composerText = v59
	v105.composerErrorText = state9
	v105.fundingFailure = state13
	v105.setComposerText = v77
	v105.setPrefilledComposerText = v78
	v105.composerImages = state11
	v105.setComposerImages = setComposerImages
	v105.retryComposerImage = retryComposerImage
	v105.composerResourceAttachments = state12
	v105.findComposerResourceAttachmentIndexByUri = findComposerResourceAttachmentIndexByUri
	v105.addComposerResourceAttachment = addComposerResourceAttachment
	v105.removeComposerResourceAttachmentAtIndex = removeComposerResourceAttachmentAtIndex
	v105.clearComposerResourceAttachments = clearComposerResourceAttachments
	local v106 = if FFlagBuildExperienceModelPicker then not (v20 == nil) and v20.hasObservedModels else nil
	v105.hasPreparedModelSession = v106

	local v107 = if FFlagBuildExperienceModelPicker and v20 ~= nil then v20.models else nil
	v105.modelSessionModels = v107

	if not v81 then
		v81 = FFlagBuildExperienceModelPicker

		if v81 then
			v81 = state3 or state8 or (v20 ~= nil and v20.isBusy and true or false) and not v57

			if not v81 then
				v81 = not (state9 == nil) and not state10
			end
		end
	end

	v105.isComposerSendBlocked = v81

	v105.isAssistantResponding = v57
	v105.canStopAssistantResponse = v40 ~= nil or (v56 or FFlagBuildExperienceModelPicker and state8)

	v105.canSendWhileResponding = v58
	v105.sendMessage = v90
	v105.stopAssistantResponse = v98
	v105.setScrollingFrame = v66.setScrollingFrame

	local v108 = if FFlagBuildExperienceChatAccordionScrollAnchor then v66.anchorToInstance else nil
	v105.anchorScrollToInstance = v108

	v105.textBoxRef = ref19
	v105.clockBinding = v65
	v105.playtestPlaceId = placeId

	if placeId == nil then
		v101 = nil
	end

	v105.launchPlaytest = v101
	v105.hasPublishedTurn = includesPublishTool
	v105.subagentTaskState = subagentTaskState
	v105.isHistoryHydrationComplete = v33
	v105.isHistoryLoading = v34
	v105.isHistoryExhausted = v53 and not v51
	return v105
end

return useChatSessionCore
