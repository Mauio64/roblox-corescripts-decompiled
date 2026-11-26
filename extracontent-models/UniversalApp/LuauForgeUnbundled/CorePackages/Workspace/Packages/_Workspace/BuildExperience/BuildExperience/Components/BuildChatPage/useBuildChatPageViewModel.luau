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
local FFlagBuildExperienceChatOpenId = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceChatOpenId")
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

local function useChatOpen(target)
	local ref = React.useRef(nil)

	if target.chatOpenId ~= nil then
		ref.current = target.chatOpenId
	end

	local current = ref.current

	if current ~= nil then
		CreatorAgentChat.chatOpenTelemetry.open(current, target.universeId)

		if target.universeId ~= nil then
			CreatorAgentChat.chatOpenTelemetry.setUniverseId(current, target.universeId)
		end
	end

	React.useEffect(function()
		if current == nil then
			return nil
		end

		local v13 = current
		return function()
			CreatorAgentChat.chatOpenTelemetry.close(v13)
		end
	end, { current })
	return current
end

local function useChatOpenSessionLink(p2, target, currentSessionId)
	local ref = React.useRef(nil)
	local v13 = currentSessionId or target.sessionId

	if p2 ~= nil then
		CreatorAgentChat.chatOpenTelemetry.setSessionId(p2, v13)
	end

	React.useEffect(function()
		if p2 == nil or v13 == nil then
			return
		end

		local current = ref.current

		if current == nil or current.chatOpenId ~= p2 or current.sessionId ~= v13 then
			ref.current = { chatOpenId = p2, sessionId = v13 }
			sendBuildExperienceEvent("CHAT_SESSION_LINKED", {
				universeId = target.universeId,
				placeId = target.placeId,
				conversationId = v13,
				chatOpenId = p2
			})
		end
	end, { p2, v13 })
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

	local v32 = if FFlagBuildExperienceChatOpenId then useChatOpen(data.target) else nil

	local function fn()
		local v33 = {
			universeId = data.target.universeId,
			placeId = data.target.placeId,
			sessionId = data.target.sessionId,
			experienceName = 0,
			isNewGameTarget = 0,
			modelSelectionDraftId = 0,
			creatorName = 0,
			gameIcon = 0,
			chatOpenId = 0
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
		v33.chatOpenId = if FFlagBuildExperienceChatOpenId then v32 else nil
		return v33
	end

	local v35 = React.useMemo(fn, {
		data.target.universeId,
		data.target.placeId,
		data.target.sessionId,
		data.target.experienceName,
		data.target.isNewGameTarget,
		data.target.modelSelectionDraftId,
		data.target.creatorName,
		data.target.gameIcon,
		v14,
		if FFlagBuildExperienceChatOpenId then v32 else nil
	})

	local useCallback = React.useCallback
	local function fn2(data2)
		if FFlagBuildExperienceModelPicker and v35.modelSelectionDraftId ~= nil then
			GetBuildModelSelectionStore(false).promoteDraft(v35.modelSelectionDraftId, data2.universeId)
		end

		if FFlagBuildExperienceChatOpenId and v35.chatOpenId ~= nil then
			CreatorAgentChat.chatOpenTelemetry.setUniverseId(v35.chatOpenId, data2.universeId)
		end

		if data.onNavigateToResolvedTarget ~= nil then
			local onNavigateToResolvedTarget = data.onNavigateToResolvedTarget
			local v36 = {
				universeId = data2.universeId,
				placeId = data2.placeId,
				sessionId = data2.sessionId,
				experienceName = v35.experienceName,
				isNewGameTarget = v35.isNewGameTarget,
				modelSelectionDraftId = 0,
				creatorName = 0,
				gameIcon = 0,
				chatOpenId = 0
			}

			local v37 = if FFlagBuildExperienceModelPicker then v35.modelSelectionDraftId else nil
			v36.modelSelectionDraftId = v37

			v36.creatorName = v35.creatorName
			v36.gameIcon = v35.gameIcon

			local v38 = if FFlagBuildExperienceChatOpenId then v35.chatOpenId else nil
			v36.chatOpenId = v38
			onNavigateToResolvedTarget(v36)
		end
	end

	local v36

	if FFlagBuildExperienceModelPicker then
		v36 = { data.onNavigateToResolvedTarget, v35 }
	else
		v36 = { nil, nil, nil, nil, nil, nil }
		local onNavigateToResolvedTarget = data.onNavigateToResolvedTarget
		local experienceName2 = v35.experienceName
		local isNewGameTarget3 = v35.isNewGameTarget
		local creatorName2 = v35.creatorName
		local gameIcon2 = v35.gameIcon
		local v37 = if FFlagBuildExperienceChatOpenId then v35.chatOpenId else nil
		v36[1], v36[2], v36[3], v36[4], v36[5], v36[6] = onNavigateToResolvedTarget, experienceName2, isNewGameTarget3, creatorName2, gameIcon2, v37
	end

	local v37 = useCallback(fn2, v36)

	local state11, setState11 = React.useState({ count = 0, reason = nil })

	local v38 = React.useCallback(function(p2, p3)
		if p2 == CreatorAgentChat.ErrorCodes.OutOfCredits then
			setState11(function(p4)
				return {
					count = p4.count + 1,
					reason = p3
				}
			end)
		end
	end, {})
	local v39 = if FFlagBuildAdUpsell then v6(false) else nil
	local v40

	if FFlagBuildAdUpsell then
		v40 = React.useCallback(function(p2)
			if v39 ~= nil then
				v39.reportAssistantTurnCompleted(p2)
			end
		end, { v39 })
	end

	local v42 = {
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

	local v43 = if FFlagBuildExperienceModelPicker then v35.modelSelectionDraftId else nil
	v42.modelSelectionDraftId = v43
	v42.onProjectResolved = v37

	if FFlagBuildExperienceModelPicker then
		v38 = nil
	end

	v42.onPromptFailure = v38
	v42.trackAdUpsellTurns = FFlagBuildAdUpsell
	v42.onAssistantTurnCompleted = v40
	v42.sendMessageWhen = not v28
	local v44 = useChatSessionCore(v42)

	if FFlagBuildExperienceChatOpenId then
		useChatOpenSessionLink(v32, data.target, v44.currentSessionId)
	end

	local v45 = #v44.messages == 0
	local v46 = usePromptChipViewModel(v44, data.target, v28)
	local promptChips = v46.promptChips
	local isPromptChipsLoading = v46.isPromptChipsLoading
	local onPromptChipActivated = v46.onPromptChipActivated
	local onPromptChipExhausted = v46.onPromptChipExhausted
	local onComposerChanged = v46.onComposerChanged
	local v47

	if FFlagBuildExperienceModelPicker then
		v47 = useBuildModelSelection(
			data.target.universeId,
			data.target.modelSelectionDraftId,
			data.modelPicker,
			v44.modelSessionModels,
			v44.hasPreparedModelSession,
			v44.internalTesting
		)
	end

	if fFlagBuildExperienceAnalytics then
		local ref2 = React.useRef(false)

		React.useEffect(function()
			local initialPrompt = data.initialPrompt

			if ref2.current or initialPrompt == nil or initialPrompt == "" then
				return
			end

			v44.setComposerText(initialPrompt)

			if v44.sendMessage() then
				ref2.current = true
			end
		end, { data.initialPrompt, v44.sendMessage, v44.setComposerText })
	end

	if FFlagBuildExperienceMonetizationNativeUI then
		local universeId2 = data.target.universeId
		local sessionId2 = data.target.sessionId
		local setPrefilledComposerText = v44.setPrefilledComposerText
		local sendMessage = v44.sendMessage
		local isFocused = data.isFocused ~= false
		useBuildPromptDraft(
			universeId2,
			sessionId2,
			setPrefilledComposerText,
			sendMessage,
			isFocused,
			if FFlagBuildExperienceDeveloperProductContext then v44 else nil
		)
	elseif FFlagBuildExperienceManageDevProduct then
		useBuildPromptDraft(
			data.target.universeId,
			data.target.sessionId,
			v44.setPrefilledComposerText,
			v44.sendMessage,
			nil,
			if FFlagBuildExperienceDeveloperProductContext then v44 else nil
		)
	end

	local v48 = useChatPlaytestFooter(v44, "BuildChatPlaytestCta")
	local subagentTaskState = v44.subagentTaskState
	local v49 = not (subagentTaskState == nil) and #subagentTaskState.groups > 0
	local v50 = false

	for k, message in v44.messages do
		if message.kind == "user_message" then
			v50 = true
			break
		end
	end

	local v52 = state3 == permissionsProtocol.Status.DENIED and (not state4 and (not state7 or state8))

	local ref2 = React.useRef(false)

	React.useEffect(function()
		if not engineFeature then
			return function() end
		end

		local isAssistantResponding = v52 and v50 and v44.isAssistantResponding

		if isAssistantResponding and not state8 then
			setState8(true)
			setState7(true)
			v9.markPushNotificationsUpsellShown()
		elseif not isAssistantResponding and state8 then
			setState8(false)
		end

		return function() end
	end, { v52, v50, v44.isAssistantResponding, state7, state8 })

	React.useEffect(function()
		local universeId2 = data.target.universeId
		local v53 = ref2.current and not v44.isAssistantResponding
		ref2.current = v44.isAssistantResponding

		if not v53 or universeId2 == nil or universeId2 == 0 then
			return function() end
		end

		if FFlagBuildAdUpsell then
			task.defer(function()
				if ref.current then
					local v54 = universeId2
					local universeConfigurationStore = UniverseConfiguration.getUniverseConfigurationStore()

					if universeConfigurationStore.getSummary(v54).data(false) ~= nil then
						universeConfigurationStore.fetchSummary(v54)
					end
				end
			end)
		else
			local universeConfigurationStore = UniverseConfiguration.getUniverseConfigurationStore()

			if universeConfigurationStore.getSummary(universeId2).data(false) ~= nil then
				universeConfigurationStore.fetchSummary(universeId2)
			end
		end

		return function() end
	end, { data.target.universeId, v44.isAssistantResponding })

	local useEffect = React.useEffect
	local function fn3()
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

	local v53 = if FFlagBuildExperienceMonetizationNativeUI then {
		v16,
		data.target.universeId or false,
		data.target.sessionId or false,
		data.isFocused ~= false
	} else { v16, data.target.universeId, data.target.sessionId }
	useEffect(fn3, v53)

	local v54 = React.useCallback(function()
		if v44.textBoxRef.current then
			v44.textBoxRef.current.releaseFocus()
		end
	end, { v44.textBoxRef })

	local v55 = React.useCallback(function()
		v54()

		if data.onOpenCreatorCreditPage ~= nil then
			data.onOpenCreatorCreditPage()
		end
	end, { v54, data.onOpenCreatorCreditPage })

	if data.onOpenCreatorCreditPage == nil then
		v55 = nil
	end

	local v56

	if FFlagEnableBuildAdPromotion then
		v56 = React.useCallback(function()
			v54()

			if data.onOpenGetUsersPage ~= nil then
				data.onOpenGetUsersPage()
			end
		end, { v54, data.onOpenGetUsersPage })
	end

	if data.onOpenGetUsersPage == nil then
		v56 = nil
	end

	local v58 = {
		namedTier = FFlagBuildExperienceModelPicker and v47 and v47.selectedId == "advanced" and not (v47.internalTesting and v47.internalTesting.isSelected) and "advanced" or nil,
		onOpenCreatorCreditPage = v55,
		outOfCreditsPromptFailureCount = 0,
		outOfCreditsPromptFailureReason = 0,
		isAssistantResponding = 0
	}
	local count

	if FFlagBuildExperienceModelPicker then
		if v44.fundingFailure then
			count = v44.fundingFailure.count
		end
	else
		count = state11.count
	end

	v58.outOfCreditsPromptFailureCount = count
	local reason

	if FFlagBuildExperienceModelPicker then
		if v44.fundingFailure then
			reason = v44.fundingFailure.reason
		end
	else
		reason = state11.reason
	end

	v58.outOfCreditsPromptFailureReason = reason

	v58.isAssistantResponding = v44.isAssistantResponding
	local v59 = useCreatorCreditChatUpsellViewModel(v58)

	local v60 = (FFlagBuildAdUpsell or FFlagEnableBuildAdPromotion) and v7.getAudience(v14) == UniverseConfiguration.PrivacyType.Public
	local v61

	if FFlagBuildAdUpsell or fFlagBuildExperienceLibrary then
		v61 = getResolvedSessionId(v44.messages, data.target.sessionId, data.target.universeId)
	else
		v61 = nil
	end

	local v62

	if FFlagBuildAdUpsell then
		v62 = v8({
			messages = v44.messages,
			isHistoryExhausted = v44.isHistoryExhausted,
			sessionId = v61,
			isPublic = v60,
			isPageVisible = data.isFocused ~= false,
			universeId = data.target.universeId
		})
	else
		v62 = v11
	end

	local v63

	if FFlagBuildAgentAdCampaignCard then
		v63 = v5({
			universeId = data.target.universeId,
			sessionId = v61,
			isPageVisible = data.isFocused ~= false
		})
	else
		v63 = v12
	end

	local v64 = React.useCallback(function()
		v54()
		data.onClose()
	end, { v54, data.onClose })

	local v65 = React.useCallback(function(p2)
		if p2.type == "openPage" then
			v54()

			if data.onOpenConfigurationPage then
				data.onOpenConfigurationPage(p2.page)
			end
		elseif p2.type == "openInvitePicker" then
			v54()

			if data.onOpenInvitePicker then
				data.onOpenInvitePicker()
			end
		elseif p2.type == "openInviteManagement" then
			v54()

			if data.onOpenInviteManagement then
				data.onOpenInviteManagement()
			end
		end
	end, {
		v54,
		data.onOpenConfigurationPage,
		data.onOpenInvitePicker,
		data.onOpenInviteManagement
	})
	local v66

	if FFlagBuildExperiencePlaytestCardPublishCta then
		v66 = React.useCallback(function()
			v65({ type = "openPage", page = "publish" })
		end, { v65 })
	end

	local v67 = React.useCallback(function()
		v54()

		if data.onOpenLibrary ~= nil then
			data.onOpenLibrary(v61)
		end
	end, { v54, data.onOpenLibrary, v61 })

	local v68 = React.useCallback(function()
		sendBuildExperienceEvent(
			FFlagBuildEventsUpdate1 and "PLAYTEST_CLICK" or "PLAY_CLICK",
			{ universeId = data.target.universeId, placeId = v44.playtestPlaceId },
			FFlagBuildEventsUpdate1 and { context = "app_header" } or nil
		)

		if v44.launchPlaytest then
			v44.launchPlaytest("BuildChatPage")
		end
	end, { v44.launchPlaytest, v44.playtestPlaceId, data.target.universeId })

	local v69 = React.useCallback(function()
		v54()
		data.onOpenAgentsPage(subagentTaskState or v10)
	end, { v54, data.onOpenAgentsPage, subagentTaskState })

	local v70 = React.useCallback(function(p2)
		v54()
		setState(p2)
	end, { v54 })

	local v71 = {}
	v71.target = v35
	v71.agentSpecVersion = v44.agentSpecVersion
	v71.setAgentSpecVersion = v44.setAgentSpecVersion
	v71.keyboardOverlap = v25
	v71.onPageMetricsChanged = v23
	v71.selectedChipGroupName = state
	v71.onChipActivated = v70

	function v71.onChipBottomSheetClose()
		setState(nil)
	end

	v71.onClose = v64
	v71.onOpenLibrary = v67
	v71.isLibraryDisabled = fFlagBuildExperienceLibrary and (data.target.universeId == nil or v29)
	v71.onOverflowMenuAction = v65
	v71.onPlayActivated = v68
	v71.onOpenAgentsPage = v69
	v71.onOpenCreatorCreditPage = v55
	v71.onOpenGetUsersPage = v56
	v71.isUniversePublic = v60
	v71.buildOverflowMenuStore = v15
	v71.messages = v44.messages
	v71.localToolActions = v44.localToolActions
	local v72 = if FFlagBuildExperienceAnswerForm then v44.answerForm else nil
	v71.answerForm = v72
	local v73 = if FFlagBuildExperienceAnswerForm then v44.submitAnswerText else nil
	v71.onSubmitAnswerText = v73
	v71.clockBinding = v44.clockBinding
	v71.onPlaytest = v48.onPlaytest

	if data.onOpenConfigurationPage == nil then
		v66 = nil
	end

	v71.onPublish = v66
	v71.isPlaytestLoading = v48.isPlaytestLoading
	v71.isPlaytestDisabled = v30
	local v74 = if engineFeature then state8 and v52 else v52
	v71.showPushNotificationsUpsell = v74

	v71.isPushNotificationsRequestPending = state5
	v71.shouldOpenPushNotificationsSettings = state6
	v71.onNotifyMe = v19
	v71.onOpenPushNotificationsSettings = v20
	v71.onNotNow = v21
	v71.showBuyMoreRobuxCard = v59.showBuyMoreRobuxCard
	v71.buyMoreRobuxCardTitle = v59.buyMoreRobuxCardTitle
	v71.buyMoreRobuxCardDescription = v59.buyMoreRobuxCardDescription
	v71.buyMoreRobuxCardPrimaryActionText = v59.buyMoreRobuxCardPrimaryActionText
	v71.onBuyMoreRobuxCardPrimaryAction = v59.onBuyMoreRobuxCardPrimaryAction
	v71.buyMoreRobuxCardSecondaryActionText = v59.buyMoreRobuxCardSecondaryActionText
	v71.onBuyMoreRobuxCardSecondaryAction = v59.onBuyMoreRobuxCardSecondaryAction
	v71.adUpsellCards = v62.adUpsellCards
	v71.adUpsellCongratsAnchorIndex = v62.adUpsellCongratsAnchorIndex
	v71.adUpsellFreePromotionsRemaining = v62.adUpsellFreePromotionsRemaining
	v71.isAdUpsellCreatePending = v62.isAdUpsellCreatePending
	v71.isAdUpsellCreateDisabled = v31
	v71.isAdCampaignSheetOpen = v62.isAdCampaignSheetOpen
	v71.hasAdCampaignCreateError = v62.hasAdCampaignCreateError
	v71.adCampaignCreateErrorKind = v62.adCampaignCreateErrorKind
	v71.adCampaignDurationDays = v62.adCampaignDurationDays
	v71.adCampaignEstimatedPriceRobux = v62.adCampaignEstimatedPriceRobux
	v71.adCampaignOffers = v62.adCampaignOffers
	v71.adCampaignRunStartTimeMs = v62.adCampaignRunStartTimeMs
	v71.adCampaignRunEndTimeMs = v62.adCampaignRunEndTimeMs
	v71.isAdCampaignCreatedToastVisible = v62.isAdCampaignCreatedToastVisible
	v71.onAdCampaignCreatedToastDismiss = v62.onAdCampaignCreatedToastDismiss
	v71.onAdUpsellCreate = v62.onAdUpsellCreate
	v71.onAdUpsellDismiss = v62.onAdUpsellDismiss
	v71.onAdUpsellImpression = v62.onAdUpsellImpression
	v71.onAdCampaignSheetClose = v62.onAdCampaignSheetClose
	v71.onAdCampaignSheetCreate = v62.onAdCampaignSheetCreate
	v71.isAgentAdCampaignSheetOpen = v63.isSheetOpen
	v71.isAgentAdCampaignCreatePending = v63.isCreatePending
	v71.hasAgentAdCampaignCreateError = v63.hasCreateError
	v71.agentAdCampaignCreateErrorKind = v63.createErrorKind
	v71.agentAdCampaignOffers = v63.campaignOffers
	v71.agentAdCampaignRunStartTimeMs = v63.runStartTimeMs
	v71.onAgentAdCampaignOfferSelected = v63.onOfferSelected
	v71.getAgentAdCampaignCardState = v63.getCardState

	local v75 = if v31 then v12.isCreateDisabled else v63.isCreateDisabled
	v71.isAgentAdCampaignCreateDisabled = v75

	v71.agentAdCampaignAttemptedOption = v63.attemptedOption

	if v31 then
		v56 = nil
	end

	v71.onAgentAdCampaignActive = v56
	v71.onAgentAdCampaignSheetClose = v63.onSheetClose
	v71.onAgentAdCampaignSheetCreate = v63.onSheetCreate
	v71.isAdUpsellVisible = data.isFocused ~= false
	v71.isChatEmpty = v45
	v71.isHistoryLoading = v44.isHistoryLoading or v27
	v71.isNewGameTarget = isNewGameTarget
	v71.hasPublishedTurn = v44.hasPublishedTurn
	v71.hasPublishedVersion = v14 ~= nil and v14.isActive
	v71.hasTaskGroups = v49
	v71.taskState = subagentTaskState
	v71.scrollingFrameRef = v44.setScrollingFrame
	v71.anchorScrollToInstance = v44.anchorScrollToInstance
	v71.onChatViewportChanged = v24
	v71.isChatScrollable = state2
	v71.modelPicker = v47
	v71.composerText = v44.composerText
	v71.composerErrorText = v44.composerErrorText
	v71.onComposerChanged = onComposerChanged
	v71.promptChips = promptChips
	v71.isPromptChipsLoading = isPromptChipsLoading
	v71.onPromptChipActivated = onPromptChipActivated
	v71.onPromptChipExhausted = onPromptChipExhausted
	v71.composerImages = v44.composerImages
	v71.onComposerImagesChanged = v44.setComposerImages
	v71.onRetryComposerImage = v44.retryComposerImage
	v71.composerResourceAttachments = v44.composerResourceAttachments
	v71.onRemoveComposerResourceAttachment = v44.removeComposerResourceAttachmentAtIndex
	v71.isComposerSendBlocked = v44.isComposerSendBlocked
	v71.textBoxRef = v44.textBoxRef
	v71.isAssistantResponding = v44.isAssistantResponding
	v71.canStopAssistantResponse = v44.canStopAssistantResponse
	v71.canSendWhileResponding = v44.canSendWhileResponding
	v71.isChatReadOnly = v28
	v71.chatPermissions = v26
	v71.onSend = v44.sendMessage
	v71.onStop = v44.stopAssistantResponse
	v71.statusChipGap = v13.Gap.Small
	v71.paddingBottom = v13.Padding.Small + v25
	return v71
end

return useBuildChatPageViewModel
