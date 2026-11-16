require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/ModelPicker/ModelPickerTypes")
local FFlagBuildExperienceModelPicker = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceModelPicker")
local useBuildModelSelection = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/useBuildModelSelection")
local GetBuildModelSelectionStore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Stores/GetBuildModelSelectionStore")

local GuiService = game:GetService("GuiService")
local MessageBusService = game:GetService("MessageBusService")
local UserInputService = game:GetService("UserInputService")

local CreatorAgentChat = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/CreatorAgentChat")
local UniverseConfiguration = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/UniverseConfiguration")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SignalsReact")

require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/chatTypes")
local useChatPlaytestFooter = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/useChatPlaytestFooter")
local FFlagBuildExperienceMonetizationNativeUI = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceMonetizationNativeUI")

local FFlagBuildExperienceDeveloperProductContext = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceDeveloperProductContext")
local FFlagBuildRequestPromptChipsOnEdit = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildRequestPromptChipsOnEdit")
local useBuildPromptChipRequests = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/useBuildPromptChipRequests")
local useBuildPromptDraft = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/useBuildPromptDraft")
local useChatSessionCore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/useChatSessionCore")
local sendBuildExperienceEvent = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Telemetry/sendBuildExperienceEvent")
local GetBuildPromptChipsStore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Stores/GetBuildPromptChipsStore")
local GetBuildOverflowMenuStore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Stores/GetBuildOverflowMenuStore")
local GetCreatorAgentResumeStore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Stores/GetCreatorAgentResumeStore")
local promptChipsStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Stores/GetBuildPromptChipsStore/promptChipsStatus")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/BuildChatPage/BuildChatPageView")
local FFlagBuildExperienceAnswerForm = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceAnswerForm")
local FFlagBuildEnableFTUXChips = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildEnableFTUXChips")

local FFlagBuildExperienceFTUXChipConversationIdTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceFTUXChipConversationIdTelemetry")

local FFlagBuildExperienceFTUXChipExhaustedTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceFTUXChipExhaustedTelemetry")
local useCreatorCreditChatUpsellViewModel = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/BuildChatPage/useCreatorCreditChatUpsellViewModel")
local fFlagBuildExperienceLibrary = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SharedFlags").FFlagBuildExperienceLibrary
local fFlagBuildExperienceAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SharedFlags").FFlagBuildExperienceAnalytics
local FFlagBuildAdUpsell = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildAdUpsell")
local FFlagBuildAgentAdCampaignCard = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildAgentAdCampaignCard")

local v5 = if FFlagBuildAgentAdCampaignCard then require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/BuildChatPage/useAgentAdCampaignChatViewModel") else nil

local FFlagEnableBuildAdPromotion = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagEnableBuildAdPromotion")

local v6 = if FFlagBuildAdUpsell then require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Stores/GetAdUpsellEventStore") else nil

local v7 = if FFlagBuildAdUpsell or FFlagEnableBuildAdPromotion then require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/utils/GameConfigurationLabels") else nil

local v8 = if FFlagBuildAdUpsell then require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/BuildChatPage/useAdUpsellChatViewModel") else nil

local FFlagBuildCheckGamePermissions = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildCheckGamePermissions")
local useGamePermissions = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/useGamePermissions")
local FFlagBuildEventsUpdate1 = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildEventsUpdate1")

local FFlagBuildExperiencePlaytestCardPublishCta = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperiencePlaytestCardPublishCta")
local FFlagBuildExperienceManageDevProduct = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceManageDevProduct")
local engineFeature = game:GetEngineFeature("BuildAppStorageKey")

local v9 = if engineFeature then require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Storage/BuildAppStorage") else nil

local default = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/LinkingProtocol").LinkingProtocol.default
local permissionsProtocol = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/PermissionsProtocol").PermissionsProtocol
local useTokens = Foundation.Hooks.useTokens

local messageId = MessageBusService:GetMessageId("Realtime", "appResume")

local v10 = { groups = {}, allComplete = false }

local v11 = {
	adUpsellCards = {},
	adUpsellCongratsAnchorIndex = nil,
	adUpsellFreePromotionsRemaining = 0,
	isAdUpsellCreatePending = false,
	isAdCampaignSheetOpen = false,
	hasAdCampaignCreateError = false,
	adCampaignCreateErrorKind = nil,
	adCampaignDurationDays = nil,
	adCampaignEstimatedPriceRobux = nil,
	adCampaignOffers = nil,
	adCampaignRunStartTimeMs = nil,
	adCampaignRunEndTimeMs = nil,
	isAdCampaignCreatedToastVisible = false,
	onAdCampaignCreatedToastDismiss = function() end,
	onAdUpsellCreate = function() end,
	onAdUpsellDismiss = function() end,
	onAdUpsellImpression = function() end,
	onAdCampaignSheetClose = function() end,
	onAdCampaignSheetCreate = function() end
}

local v12 = {
	isSheetOpen = false,
	isCreatePending = false,
	hasCreateError = false,
	createErrorKind = nil,
	campaignOffers = nil,
	runStartTimeMs = nil,
	onOfferSelected = function() end,
	isCreateDisabled = function(): boolean
		return true
	end,
	getCardState = function(): nil
		return nil
	end,
	onSheetClose = function() end,
	onSheetCreate = function() end
}

local function getKeyboardTop()
	if not UserInputService.OnScreenKeyboardVisible then
		return 0
	end

	local guiInset = GuiService:GetGuiInset()
	return (math.max(0, UserInputService.OnScreenKeyboardPosition.Y - guiInset.Y))
end

local function useUniverseSummary(universeId)
	local universeConfigurationStore = UniverseConfiguration.getUniverseConfigurationStore()
	local v13 = React.useMemo(function()
		return Signals.createComputed(function(p2)
			if universeId == nil or universeId == 0 then
				return nil
			end

			return universeConfigurationStore.getAndFetchSummary(universeId).data(p2)
		end)
	end, { universeConfigurationStore, universeId })

	return SignalsReact.useSignalState(v13)
end

local function fetchCachedUniverseSummary(p2)
	local universeConfigurationStore = UniverseConfiguration.getUniverseConfigurationStore()

	if universeConfigurationStore.getSummary(p2).data(false) ~= nil then
		universeConfigurationStore.fetchSummary(p2)
	end
end

local function getResolvedSessionId(messages, sessionId, universeId)
	if sessionId ~= nil and sessionId ~= "" then
		return sessionId
	end

	for i = #messages, 1, -1 do
		local item = messages[i]

		if
			item.kind == "assistant_turn"
			and item.sessionId ~= nil
			and (universeId == nil or item.universeId == universeId)
		then
			return item.sessionId
		end
	end

	return nil
end

local function getHydratedExperienceName(p2, p3)
	local name = if p3 ~= nil then p3.name else nil

	if typeof(name) == "string" and name ~= "" then
		return name
	end

	return p2
end

local function usePromptChipViewModel(data, target, p2)
	local v13 = {}
	local v14 = false
	local function onPromptChipActivated() end
	local onChipExhausted = nil
	local v15 = data.setComposerText

	if not (FFlagBuildEnableFTUXChips or FFlagBuildRequestPromptChipsOnEdit) then
		return {
			promptChips = v13,
			isPromptChipsLoading = false,
			onPromptChipActivated = onPromptChipActivated,
			onPromptChipExhausted = onChipExhausted,
			onComposerChanged = v15
		}
	end

	local v16 = GetBuildPromptChipsStore()

	local v17 = FFlagBuildEnableFTUXChips
		and not p2
		and data.isHistoryHydrationComplete
		and not data.isHistoryLoading
		and #data.messages == 0
	local formatted = `{target.universeId or 0}:{target.placeId or 0}:{target.sessionId or "new"}`

	local v18 = if FFlagBuildExperienceFTUXChipConversationIdTelemetry then data.currentSessionId else target.sessionId
	local v20 = useBuildPromptChipRequests(v16, {
		isActive = v17,
		sessionKey = formatted,
		shouldRequestInitialChips = v17,
		telemetryGranularity = React.useMemo(function()
			return {
				universeId = target.universeId,
				placeId = target.placeId,
				conversationId = v18
			}
		end, { target.universeId or 0, target.placeId or 0, v18 or "" })
	})

	local ref = React.useRef(nil)

	if FFlagBuildEnableFTUXChips then
		local v21 = SignalsReact.useSignalState(v16.getChips)
		local v22 = SignalsReact.useSignalState(v16.getStatus)
		v13 = not v17 and {} or v21

		v14 = v17 and v22 == promptChipsStatus.PROMPT_CHIPS_STATUS.Loading
		onPromptChipActivated = React.useCallback(function(p3)
			local value = data.composerText:getValue()
			v20.requestChipsForSelection(value, p3, function(current)
				if data.composerText:getValue() == value then
					ref.current = current
					data.setComposerText(current)
				end
			end)
		end, { data.composerText, data.setComposerText, v20, ref })

		if FFlagBuildExperienceFTUXChipExhaustedTelemetry then
			onChipExhausted = v20.onChipExhausted
		end
	end

	if FFlagBuildRequestPromptChipsOnEdit then
		v15 = React.useCallback(function(p3)
			data.setComposerText(p3)

			if ref.current == p3 then
				ref.current = nil
				return
			end

			ref.current = nil
			v20.requestChipsForEdit(p3)
		end, { data.setComposerText, v20, ref })
	end

	return {
		promptChips = v13,
		isPromptChipsLoading = v14,
		onPromptChipActivated = onPromptChipActivated,
		onPromptChipExhausted = onChipExhausted,
		onComposerChanged = v15
	}
end

local function useBuildChatPageViewModel(data)
	local v13 = useTokens()
	local v14 = useUniverseSummary(data.target.universeId)
	local v15 = GetBuildOverflowMenuStore()
	local v16 = GetCreatorAgentResumeStore()
	local state, setState = React.useState(nil)
	local state2, setState2 = React.useState(false)

	local state3, setState3 = React.useState(nil)
	local state4, setState4 = React.useState(function()
		return engineFeature and v9.isPushNotificationsUpsellDismissedPermanently()
	end)

	local state5, setState5 = React.useState(false)
	local state6, setState6 = React.useState(false)
	local state7, setState7 = React.useState(function()
		return engineFeature and v9.wasPushNotificationsUpsellShownToday()
	end)

	local state8, setState8 = React.useState(false)
	local ref = React.useRef(false)

	local useState = React.useState
	local v17

	if UserInputService.OnScreenKeyboardVisible then
		local guiInset = GuiService:GetGuiInset()
		v17 = math.max(0, UserInputService.OnScreenKeyboardPosition.Y - guiInset.Y)
	else
		v17 = 0
	end

	local state9, setState9 = useState(v17)
	local state10, setState10 = React.useState(0)

	local v18 = React.useCallback(function()
		return permissionsProtocol.default:hasPermissions({ permissionsProtocol.Permissions.POST_NOTIFICATIONS }):andThen(
			function(p2)
				if ref.current then
					setState3(p2.status)

					if p2.status == permissionsProtocol.Status.AUTHORIZED then
						setState6(false)
					end
				end
			end,
			function() end
		)
	end, {})

	React.useEffect(function()
		ref.current = true
		v18()

		local connection = MessageBusService:Subscribe(messageId, v18, false, true)
		return function()
			ref.current = false
			connection:Disconnect()
		end
	end, { v18 })

	local v19 = React.useCallback(function()
		if state5 then
			return
		end

		setState5(true)
		permissionsProtocol.default:requestPermissions({ permissionsProtocol.Permissions.POST_NOTIFICATIONS }):andThen(
			function(p2)
				if not ref.current then
					return
				end

				setState3(p2.status)

				if p2.status == permissionsProtocol.Status.DENIED then
					setState6(true)
				end

				setState5(false)
			end,
			function()
				if ref.current then
					setState5(false)
				end
			end
		)
	end, { state5 })

	local v20 = React.useCallback(function()
		default:switchToSettingsApp():catch(function() end)
	end, {})

	local v21 = React.useCallback(function()
		if engineFeature then
			v9.markPushNotificationsUpsellDismissedPermanently()
		end

		setState4(true)
	end, {})

	local v22 = React.useCallback(function()
		local v24

		if UserInputService.OnScreenKeyboardVisible then
			local guiInset = GuiService:GetGuiInset()
			v24 = math.max(0, UserInputService.OnScreenKeyboardPosition.Y - guiInset.Y)
		else
			v24 = 0
		end

		setState9(v24)
	end, {})

	React.useEffect(function()
		v22()
		local onScreenKeyboardVisibleChangedConnection = UserInputService:GetPropertyChangedSignal("OnScreenKeyboardVisible"):Connect(v22)
		local onScreenKeyboardSizeChangedConnection = UserInputService:GetPropertyChangedSignal("OnScreenKeyboardSize"):Connect(v22)
		local onScreenKeyboardPositionChangedConnection = UserInputService:GetPropertyChangedSignal("OnScreenKeyboardPosition"):Connect(v22)
		return function()
			onScreenKeyboardVisibleChangedConnection:Disconnect()
			onScreenKeyboardSizeChangedConnection:Disconnect()
			onScreenKeyboardPositionChangedConnection:Disconnect()
		end
	end, { v22 })

	local v23 = React.useCallback(function(p2)
		setState10(p2.AbsolutePosition.Y + p2.AbsoluteSize.Y)
	end, {})

	local v24 = React.useCallback(function(p2)
		local y = p2.AbsoluteWindowSize.Y
		setState2(y > 0 and y < p2.AbsoluteCanvasSize.Y)
	end, {})

	local v25 = (state9 <= 0 or state10 <= 0) and 0 or math.max(0, state10 - state9)
	local isNewGameTarget = data.target.isNewGameTarget == true
	local v26, v27, v28, v29, v30, v31

	if FFlagBuildCheckGamePermissions then
		v26, v27 = useGamePermissions({
			universeId = data.target.universeId,
			isNewGame = isNewGameTarget
		})

		v28 = not v26.canEditOnBuild

		v29 = not v26.canEdit
		v30 = not v26.canEdit
		v31 = not v26.canAdvertise
	else
		v28 = false
		v30 = false
		v31 = false
		v27 = false
		v29 = false
	end

	local v32 = React.useMemo(function()
		local v33 = {
			universeId = data.target.universeId,
			placeId = data.target.placeId,
			sessionId = data.target.sessionId,
			experienceName = 0,
			isNewGameTarget = 0,
			modelSelectionDraftId = 0,
			creatorName = 0,
			gameIcon = 0
		}
		local v34 = data.target.experienceName
		local v35 = v14
		local name = if v35 ~= nil then v35.name else nil

		if typeof(name) == "string" and name ~= "" then
			v34 = name
		end

		v33.experienceName = v34
		v33.isNewGameTarget = data.target.isNewGameTarget

		local v36 = if FFlagBuildExperienceModelPicker then data.target.modelSelectionDraftId else nil
		v33.modelSelectionDraftId = v36

		v33.creatorName = data.target.creatorName
		v33.gameIcon = data.target.gameIcon
		return v33
	end, {
		data.target.universeId,
		data.target.placeId,
		data.target.sessionId,
		data.target.experienceName,
		data.target.isNewGameTarget,
		data.target.modelSelectionDraftId,
		data.target.creatorName,
		data.target.gameIcon,
		v14
	})

	local useCallback = React.useCallback
	local function fn(data2)
		if FFlagBuildExperienceModelPicker and v32.modelSelectionDraftId ~= nil then
			GetBuildModelSelectionStore(false).promoteDraft(v32.modelSelectionDraftId, data2.universeId)
		end

		if data.onNavigateToResolvedTarget ~= nil then
			local onNavigateToResolvedTarget = data.onNavigateToResolvedTarget
			local v33 = {
				universeId = data2.universeId,
				placeId = data2.placeId,
				sessionId = data2.sessionId,
				experienceName = v32.experienceName,
				isNewGameTarget = v32.isNewGameTarget,
				modelSelectionDraftId = 0,
				creatorName = 0,
				gameIcon = 0
			}

			local v34 = if FFlagBuildExperienceModelPicker then v32.modelSelectionDraftId else nil
			v33.modelSelectionDraftId = v34

			v33.creatorName = v32.creatorName
			v33.gameIcon = v32.gameIcon
			onNavigateToResolvedTarget(v33)
		end
	end

	local v33

	if FFlagBuildExperienceModelPicker then
		v33 = { data.onNavigateToResolvedTarget, v32 }
	else
		v33 = {
			data.onNavigateToResolvedTarget,
			v32.experienceName,
			v32.isNewGameTarget,
			v32.creatorName,
			v32.gameIcon
		}
	end

	local v34 = useCallback(fn, v33)

	local state11, setState11 = React.useState({ count = 0, reason = nil })

	local v35 = React.useCallback(function(p2, p3)
		if p2 == CreatorAgentChat.ErrorCodes.OutOfCredits then
			setState11(function(p4)
				return {
					count = p4.count + 1,
					reason = p3
				}
			end)
		end
	end, {})
	local v36 = if FFlagBuildAdUpsell then v6(false) else nil
	local v37

	if FFlagBuildAdUpsell then
		v37 = React.useCallback(function(p2)
			if v36 ~= nil then
				v36.reportAssistantTurnCompleted(p2)
			end
		end, { v36 })
	end

	local v39 = {
		universeId = data.target.universeId,
		placeId = data.target.placeId,
		sessionId = data.target.sessionId,
		autoFocusComposer = isNewGameTarget,
		createUniverseOnFirstPrompt = isNewGameTarget,
		modelSelectionDraftId = 0,
		onProjectResolved = 0,
		onPromptFailure = 0,
		trackAdUpsellTurns = 0,
		onAssistantTurnCompleted = 0,
		sendMessageWhen = 0
	}

	local v40 = if FFlagBuildExperienceModelPicker then v32.modelSelectionDraftId else nil
	v39.modelSelectionDraftId = v40
	v39.onProjectResolved = v34

	if FFlagBuildExperienceModelPicker then
		v35 = nil
	end

	v39.onPromptFailure = v35
	v39.trackAdUpsellTurns = FFlagBuildAdUpsell
	v39.onAssistantTurnCompleted = v37
	v39.sendMessageWhen = not v28
	local v41 = useChatSessionCore(v39)

	local v42 = #v41.messages == 0
	local v43 = usePromptChipViewModel(v41, data.target, v28)
	local promptChips = v43.promptChips
	local isPromptChipsLoading = v43.isPromptChipsLoading
	local onPromptChipActivated = v43.onPromptChipActivated
	local onPromptChipExhausted = v43.onPromptChipExhausted
	local onComposerChanged = v43.onComposerChanged
	local v44

	if FFlagBuildExperienceModelPicker then
		v44 = useBuildModelSelection(
			data.target.universeId,
			data.target.modelSelectionDraftId,
			data.modelPicker,
			v41.modelSessionModels,
			v41.hasPreparedModelSession,
			v41.internalTesting
		)
	end

	if fFlagBuildExperienceAnalytics then
		local ref2 = React.useRef(false)

		React.useEffect(function()
			local initialPrompt = data.initialPrompt

			if ref2.current or initialPrompt == nil or initialPrompt == "" then
				return
			end

			v41.setComposerText(initialPrompt)

			if v41.sendMessage() then
				ref2.current = true
			end
		end, { data.initialPrompt, v41.sendMessage, v41.setComposerText })
	end

	if FFlagBuildExperienceMonetizationNativeUI then
		local universeId = data.target.universeId
		local sessionId = data.target.sessionId
		local setPrefilledComposerText = v41.setPrefilledComposerText
		local sendMessage = v41.sendMessage
		local isFocused = data.isFocused ~= false
		useBuildPromptDraft(
			universeId,
			sessionId,
			setPrefilledComposerText,
			sendMessage,
			isFocused,
			if FFlagBuildExperienceDeveloperProductContext then v41 else nil
		)
	elseif FFlagBuildExperienceManageDevProduct then
		useBuildPromptDraft(
			data.target.universeId,
			data.target.sessionId,
			v41.setPrefilledComposerText,
			v41.sendMessage,
			nil,
			if FFlagBuildExperienceDeveloperProductContext then v41 else nil
		)
	end

	local v45 = useChatPlaytestFooter(v41, "BuildChatPlaytestCta")
	local subagentTaskState = v41.subagentTaskState
	local v46 = not (subagentTaskState == nil) and #subagentTaskState.groups > 0
	local v47 = false

	for k, message in v41.messages do
		if message.kind == "user_message" then
			v47 = true
			break
		end
	end

	local v49 = state3 == permissionsProtocol.Status.DENIED and (not state4 and (not state7 or state8))

	local ref2 = React.useRef(false)

	React.useEffect(function()
		if not engineFeature then
			return function() end
		end

		local isAssistantResponding = v49 and v47 and v41.isAssistantResponding

		if isAssistantResponding and not state8 then
			setState8(true)
			setState7(true)
			v9.markPushNotificationsUpsellShown()
		elseif not isAssistantResponding and state8 then
			setState8(false)
		end

		return function() end
	end, { v49, v47, v41.isAssistantResponding, state7, state8 })

	React.useEffect(function()
		local universeId = data.target.universeId
		local v50 = ref2.current and not v41.isAssistantResponding
		ref2.current = v41.isAssistantResponding

		if not v50 or universeId == nil or universeId == 0 then
			return function() end
		end

		if FFlagBuildAdUpsell then
			task.defer(function()
				if ref.current then
					local v51 = universeId
					local universeConfigurationStore = UniverseConfiguration.getUniverseConfigurationStore()

					if universeConfigurationStore.getSummary(v51).data(false) ~= nil then
						universeConfigurationStore.fetchSummary(v51)
					end
				end
			end)
		else
			local universeConfigurationStore = UniverseConfiguration.getUniverseConfigurationStore()

			if universeConfigurationStore.getSummary(universeId).data(false) ~= nil then
				universeConfigurationStore.fetchSummary(universeId)
			end
		end

		return function() end
	end, { data.target.universeId, v41.isAssistantResponding })

	local useEffect = React.useEffect
	local function fn2()
		if FFlagBuildExperienceMonetizationNativeUI and data.isFocused == false then
			return
		end

		v16.setActiveTarget({
			universeId = data.target.universeId,
			sessionId = data.target.sessionId
		})

		return function()
			v16.setActiveTarget(nil)
		end
	end

	local v50 = if FFlagBuildExperienceMonetizationNativeUI then {
		v16,
		data.target.universeId or false,
		data.target.sessionId or false,
		data.isFocused ~= false
	} else { v16, data.target.universeId, data.target.sessionId }
	useEffect(fn2, v50)

	local v51 = React.useCallback(function()
		if v41.textBoxRef.current then
			v41.textBoxRef.current.releaseFocus()
		end
	end, { v41.textBoxRef })

	local v52 = React.useCallback(function()
		v51()

		if data.onOpenCreatorCreditPage ~= nil then
			data.onOpenCreatorCreditPage()
		end
	end, { v51, data.onOpenCreatorCreditPage })

	if data.onOpenCreatorCreditPage == nil then
		v52 = nil
	end

	local v53

	if FFlagEnableBuildAdPromotion then
		v53 = React.useCallback(function()
			v51()

			if data.onOpenGetUsersPage ~= nil then
				data.onOpenGetUsersPage()
			end
		end, { v51, data.onOpenGetUsersPage })
	end

	if data.onOpenGetUsersPage == nil then
		v53 = nil
	end

	local v55 = {
		namedTier = FFlagBuildExperienceModelPicker and v44 and v44.selectedId == "advanced" and not (v44.internalTesting and v44.internalTesting.isSelected) and "advanced" or nil,
		onOpenCreatorCreditPage = v52,
		outOfCreditsPromptFailureCount = 0,
		outOfCreditsPromptFailureReason = 0,
		isAssistantResponding = 0
	}
	local count

	if FFlagBuildExperienceModelPicker then
		if v41.fundingFailure then
			count = v41.fundingFailure.count
		end
	else
		count = state11.count
	end

	v55.outOfCreditsPromptFailureCount = count
	local reason

	if FFlagBuildExperienceModelPicker then
		if v41.fundingFailure then
			reason = v41.fundingFailure.reason
		end
	else
		reason = state11.reason
	end

	v55.outOfCreditsPromptFailureReason = reason

	v55.isAssistantResponding = v41.isAssistantResponding
	local v56 = useCreatorCreditChatUpsellViewModel(v55)

	local v57 = (FFlagBuildAdUpsell or FFlagEnableBuildAdPromotion) and v7.getAudience(v14) == UniverseConfiguration.PrivacyType.Public
	local v58

	if FFlagBuildAdUpsell or fFlagBuildExperienceLibrary then
		v58 = getResolvedSessionId(v41.messages, data.target.sessionId, data.target.universeId)
	else
		v58 = nil
	end

	local v59

	if FFlagBuildAdUpsell then
		v59 = v8({
			messages = v41.messages,
			isHistoryExhausted = v41.isHistoryExhausted,
			sessionId = v58,
			isPublic = v57,
			isPageVisible = data.isFocused ~= false,
			universeId = data.target.universeId
		})
	else
		v59 = v11
	end

	local v60

	if FFlagBuildAgentAdCampaignCard then
		v60 = v5({
			universeId = data.target.universeId,
			sessionId = v58,
			isPageVisible = data.isFocused ~= false
		})
	else
		v60 = v12
	end

	local v61 = React.useCallback(function()
		v51()
		data.onClose()
	end, { v51, data.onClose })

	local v62 = React.useCallback(function(p2)
		if p2.type == "openPage" then
			v51()

			if data.onOpenConfigurationPage then
				data.onOpenConfigurationPage(p2.page)
			end
		elseif p2.type == "openInvitePicker" then
			v51()

			if data.onOpenInvitePicker then
				data.onOpenInvitePicker()
			end
		elseif p2.type == "openInviteManagement" then
			v51()

			if data.onOpenInviteManagement then
				data.onOpenInviteManagement()
			end
		end
	end, {
		v51,
		data.onOpenConfigurationPage,
		data.onOpenInvitePicker,
		data.onOpenInviteManagement
	})
	local v63

	if FFlagBuildExperiencePlaytestCardPublishCta then
		v63 = React.useCallback(function()
			v62({ type = "openPage", page = "publish" })
		end, { v62 })
	end

	local v64 = React.useCallback(function()
		v51()

		if data.onOpenLibrary ~= nil then
			data.onOpenLibrary(v58)
		end
	end, { v51, data.onOpenLibrary, v58 })

	local v65 = React.useCallback(function()
		sendBuildExperienceEvent(
			FFlagBuildEventsUpdate1 and "PLAYTEST_CLICK" or "PLAY_CLICK",
			{ universeId = data.target.universeId, placeId = v41.playtestPlaceId },
			FFlagBuildEventsUpdate1 and { context = "app_header" } or nil
		)

		if v41.launchPlaytest then
			v41.launchPlaytest("BuildChatPage")
		end
	end, { v41.launchPlaytest, v41.playtestPlaceId, data.target.universeId })

	local v66 = React.useCallback(function()
		v51()
		data.onOpenAgentsPage(subagentTaskState or v10)
	end, { v51, data.onOpenAgentsPage, subagentTaskState })

	local v67 = React.useCallback(function(p2)
		v51()
		setState(p2)
	end, { v51 })

	local v68 = {}
	v68.target = v32
	v68.agentSpecVersion = v41.agentSpecVersion
	v68.setAgentSpecVersion = v41.setAgentSpecVersion
	v68.keyboardOverlap = v25
	v68.onPageMetricsChanged = v23
	v68.selectedChipGroupName = state
	v68.onChipActivated = v67

	function v68.onChipBottomSheetClose()
		setState(nil)
	end

	v68.onClose = v61
	v68.onOpenLibrary = v64
	v68.isLibraryDisabled = fFlagBuildExperienceLibrary and (data.target.universeId == nil or v29)
	v68.onOverflowMenuAction = v62
	v68.onPlayActivated = v65
	v68.onOpenAgentsPage = v66
	v68.onOpenCreatorCreditPage = v52
	v68.onOpenGetUsersPage = v53
	v68.isUniversePublic = v57
	v68.buildOverflowMenuStore = v15
	v68.messages = v41.messages
	v68.localToolActions = v41.localToolActions
	local v69 = if FFlagBuildExperienceAnswerForm then v41.answerForm else nil
	v68.answerForm = v69
	local v70 = if FFlagBuildExperienceAnswerForm then v41.submitAnswerText else nil
	v68.onSubmitAnswerText = v70
	v68.clockBinding = v41.clockBinding
	v68.onPlaytest = v45.onPlaytest

	if data.onOpenConfigurationPage == nil then
		v63 = nil
	end

	v68.onPublish = v63
	v68.isPlaytestLoading = v45.isPlaytestLoading
	v68.isPlaytestDisabled = v30
	local v71 = if engineFeature then state8 and v49 else v49
	v68.showPushNotificationsUpsell = v71

	v68.isPushNotificationsRequestPending = state5
	v68.shouldOpenPushNotificationsSettings = state6
	v68.onNotifyMe = v19
	v68.onOpenPushNotificationsSettings = v20
	v68.onNotNow = v21
	v68.showBuyMoreRobuxCard = v56.showBuyMoreRobuxCard
	v68.buyMoreRobuxCardTitle = v56.buyMoreRobuxCardTitle
	v68.buyMoreRobuxCardDescription = v56.buyMoreRobuxCardDescription
	v68.buyMoreRobuxCardPrimaryActionText = v56.buyMoreRobuxCardPrimaryActionText
	v68.onBuyMoreRobuxCardPrimaryAction = v56.onBuyMoreRobuxCardPrimaryAction
	v68.buyMoreRobuxCardSecondaryActionText = v56.buyMoreRobuxCardSecondaryActionText
	v68.onBuyMoreRobuxCardSecondaryAction = v56.onBuyMoreRobuxCardSecondaryAction
	v68.adUpsellCards = v59.adUpsellCards
	v68.adUpsellCongratsAnchorIndex = v59.adUpsellCongratsAnchorIndex
	v68.adUpsellFreePromotionsRemaining = v59.adUpsellFreePromotionsRemaining
	v68.isAdUpsellCreatePending = v59.isAdUpsellCreatePending
	v68.isAdUpsellCreateDisabled = v31
	v68.isAdCampaignSheetOpen = v59.isAdCampaignSheetOpen
	v68.hasAdCampaignCreateError = v59.hasAdCampaignCreateError
	v68.adCampaignCreateErrorKind = v59.adCampaignCreateErrorKind
	v68.adCampaignDurationDays = v59.adCampaignDurationDays
	v68.adCampaignEstimatedPriceRobux = v59.adCampaignEstimatedPriceRobux
	v68.adCampaignOffers = v59.adCampaignOffers
	v68.adCampaignRunStartTimeMs = v59.adCampaignRunStartTimeMs
	v68.adCampaignRunEndTimeMs = v59.adCampaignRunEndTimeMs
	v68.isAdCampaignCreatedToastVisible = v59.isAdCampaignCreatedToastVisible
	v68.onAdCampaignCreatedToastDismiss = v59.onAdCampaignCreatedToastDismiss
	v68.onAdUpsellCreate = v59.onAdUpsellCreate
	v68.onAdUpsellDismiss = v59.onAdUpsellDismiss
	v68.onAdUpsellImpression = v59.onAdUpsellImpression
	v68.onAdCampaignSheetClose = v59.onAdCampaignSheetClose
	v68.onAdCampaignSheetCreate = v59.onAdCampaignSheetCreate
	v68.isAgentAdCampaignSheetOpen = v60.isSheetOpen
	v68.isAgentAdCampaignCreatePending = v60.isCreatePending
	v68.hasAgentAdCampaignCreateError = v60.hasCreateError
	v68.agentAdCampaignCreateErrorKind = v60.createErrorKind
	v68.agentAdCampaignOffers = v60.campaignOffers
	v68.agentAdCampaignRunStartTimeMs = v60.runStartTimeMs
	v68.onAgentAdCampaignOfferSelected = v60.onOfferSelected
	v68.getAgentAdCampaignCardState = v60.getCardState

	local v72 = if v31 then v12.isCreateDisabled else v60.isCreateDisabled
	v68.isAgentAdCampaignCreateDisabled = v72

	v68.agentAdCampaignAttemptedOption = v60.attemptedOption

	if v31 then
		v53 = nil
	end

	v68.onAgentAdCampaignActive = v53
	v68.onAgentAdCampaignSheetClose = v60.onSheetClose
	v68.onAgentAdCampaignSheetCreate = v60.onSheetCreate
	v68.isAdUpsellVisible = data.isFocused ~= false
	v68.isChatEmpty = v42
	v68.isHistoryLoading = v41.isHistoryLoading or v27
	v68.isNewGameTarget = isNewGameTarget
	v68.hasPublishedTurn = v41.hasPublishedTurn
	v68.hasPublishedVersion = v14 ~= nil and v14.isActive
	v68.hasTaskGroups = v46
	v68.taskState = subagentTaskState
	v68.scrollingFrameRef = v41.setScrollingFrame
	v68.anchorScrollToInstance = v41.anchorScrollToInstance
	v68.onChatViewportChanged = v24
	v68.isChatScrollable = state2
	v68.modelPicker = v44
	v68.composerText = v41.composerText
	v68.composerErrorText = v41.composerErrorText
	v68.onComposerChanged = onComposerChanged
	v68.promptChips = promptChips
	v68.isPromptChipsLoading = isPromptChipsLoading
	v68.onPromptChipActivated = onPromptChipActivated
	v68.onPromptChipExhausted = onPromptChipExhausted
	v68.composerImages = v41.composerImages
	v68.onComposerImagesChanged = v41.setComposerImages
	v68.onRetryComposerImage = v41.retryComposerImage
	v68.composerResourceAttachments = v41.composerResourceAttachments
	v68.onRemoveComposerResourceAttachment = v41.removeComposerResourceAttachmentAtIndex
	v68.isComposerSendBlocked = v41.isComposerSendBlocked
	v68.textBoxRef = v41.textBoxRef
	v68.isAssistantResponding = v41.isAssistantResponding
	v68.canStopAssistantResponse = v41.canStopAssistantResponse
	v68.canSendWhileResponding = v41.canSendWhileResponding
	v68.isChatReadOnly = v28
	v68.chatPermissions = v26
	v68.onSend = v41.sendMessage
	v68.onStop = v41.stopAssistantResponse
	v68.statusChipGap = v13.Gap.Small
	v68.paddingBottom = v13.Padding.Small + v25
	return v68
end

return useBuildChatPageViewModel
