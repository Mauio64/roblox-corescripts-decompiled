local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

require(BuildExperience.Components.ModelPicker.ModelPickerTypes)
local FFlagBuildExperienceModelPicker = require(BuildExperience.Flags.FFlagBuildExperienceModelPicker)
local useBuildModelSelection = require(BuildExperience.Chat.useBuildModelSelection)
local GetBuildModelSelectionStore = require(BuildExperience.Stores.GetBuildModelSelectionStore)

local GuiService = game:GetService("GuiService")
local MessageBusService = game:GetService("MessageBusService")
local UserInputService = game:GetService("UserInputService")

local CreatorAgentChat = require(parent.DataHydration.CreatorAgentChat)
local UniverseConfiguration = require(parent.DataHydration.UniverseConfiguration)
local Foundation = require(parent.Foundation)
local React = require(parent.React)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)

require(BuildExperience.Chat.chatTypes)
local useChatPlaytestFooter = require(BuildExperience.Chat.useChatPlaytestFooter)
local FFlagBuildExperienceMonetizationNativeUI = require(BuildExperience.Flags.FFlagBuildExperienceMonetizationNativeUI)

local FFlagBuildExperienceDeveloperProductContext = require(BuildExperience.Flags.FFlagBuildExperienceDeveloperProductContext)
local FFlagBuildRequestPromptChipsOnEdit = require(BuildExperience.Flags.FFlagBuildRequestPromptChipsOnEdit)
local useBuildPromptChipRequests = require(BuildExperience.Chat.useBuildPromptChipRequests)
local useBuildPromptDraft = require(BuildExperience.Chat.useBuildPromptDraft)
local useChatSessionCore = require(BuildExperience.Chat.useChatSessionCore)
local sendBuildExperienceEvent = require(BuildExperience.Telemetry.sendBuildExperienceEvent)
local FFlagBuildExperienceChatOpenId = require(BuildExperience.Flags.FFlagBuildExperienceChatOpenId)
local GetBuildPromptChipsStore = require(BuildExperience.Stores.GetBuildPromptChipsStore)
local GetBuildOverflowMenuStore = require(BuildExperience.Stores.GetBuildOverflowMenuStore)
local GetCreatorAgentResumeStore = require(BuildExperience.Stores.GetCreatorAgentResumeStore)
local promptChipsStatus = require(BuildExperience.Stores.GetBuildPromptChipsStore.promptChipsStatus)
require(script.Parent.BuildChatPageView)
local FFlagBuildExperienceAnswerForm = require(BuildExperience.Flags.FFlagBuildExperienceAnswerForm)
local FFlagBuildEnableFTUXChips = require(BuildExperience.Flags.FFlagBuildEnableFTUXChips)

local FFlagBuildExperienceFTUXChipConversationIdTelemetry = require(BuildExperience.Flags.FFlagBuildExperienceFTUXChipConversationIdTelemetry)

local FFlagBuildExperienceFTUXChipExhaustedTelemetry = require(BuildExperience.Flags.FFlagBuildExperienceFTUXChipExhaustedTelemetry)
local useCreatorCreditChatUpsellViewModel = require(script.Parent.useCreatorCreditChatUpsellViewModel)
local SharedFlags = require(parent.SharedFlags)
local FFlagBuildExperienceLibrary = SharedFlags.FFlagBuildExperienceLibrary
local SharedFlags2 = require(parent.SharedFlags)
local FFlagBuildExperienceAnalytics = SharedFlags2.FFlagBuildExperienceAnalytics
local FFlagBuildAdUpsell = require(BuildExperience.Flags.FFlagBuildAdUpsell)
local FFlagBuildAgentAdCampaignCard = require(BuildExperience.Flags.FFlagBuildAgentAdCampaignCard)
local useAgentAdCampaignChatViewModel

if FFlagBuildAgentAdCampaignCard then
	useAgentAdCampaignChatViewModel = require(script.Parent.useAgentAdCampaignChatViewModel)
else
	useAgentAdCampaignChatViewModel = nil
end

local FFlagEnableBuildAdPromotion = require(BuildExperience.Flags.FFlagEnableBuildAdPromotion)
local GetAdUpsellEventStore

if FFlagBuildAdUpsell then
	GetAdUpsellEventStore = require(BuildExperience.Stores.GetAdUpsellEventStore)
else
	GetAdUpsellEventStore = nil
end

local GameConfigurationLabels

if FFlagBuildAdUpsell or FFlagEnableBuildAdPromotion then
	GameConfigurationLabels = require(BuildExperience.utils.GameConfigurationLabels)
else
	GameConfigurationLabels = nil
end

local useAdUpsellChatViewModel

if FFlagBuildAdUpsell then
	useAdUpsellChatViewModel = require(script.Parent.useAdUpsellChatViewModel)
else
	useAdUpsellChatViewModel = nil
end

local FFlagBuildCheckGamePermissions = require(BuildExperience.Flags.FFlagBuildCheckGamePermissions)
local useGamePermissions = require(BuildExperience.useGamePermissions)
local FFlagBuildEventsUpdate1 = require(BuildExperience.Flags.FFlagBuildEventsUpdate1)

local FFlagBuildExperiencePlaytestCardPublishCta = require(BuildExperience.Flags.FFlagBuildExperiencePlaytestCardPublishCta)
local FFlagBuildExperienceManageDevProduct = require(BuildExperience.Flags.FFlagBuildExperienceManageDevProduct)
local engineFeature = game:GetEngineFeature("BuildAppStorageKey")
local BuildAppStorage

if engineFeature then
	BuildAppStorage = require(BuildExperience.Storage.BuildAppStorage)
else
	BuildAppStorage = nil
end

local LinkingProtocol = require(parent.LinkingProtocol)
local default = LinkingProtocol.LinkingProtocol.default
local PermissionsProtocol = require(parent.PermissionsProtocol)
local permissionsProtocol = PermissionsProtocol.PermissionsProtocol
local useTokens = Foundation.Hooks.useTokens

local messageId = MessageBusService:GetMessageId("Realtime", "appResume")

local v = { groups = {}, allComplete = false }

local v2 = {
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

local v3 = {
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

local function getKeyboardTop() -- 2 equivalent calls inferred from this helper
	if not UserInputService.OnScreenKeyboardVisible then
		return 0
	end

	local guiInset = GuiService:GetGuiInset()
	return (math.max(0, UserInputService.OnScreenKeyboardPosition.Y - guiInset.Y))
end

local function useUniverseSummary(universeId: number?)
	local universeConfigurationStore = UniverseConfiguration.getUniverseConfigurationStore()
	local v4 = React.useMemo(function()
		return Signals.createComputed(function(p)
			if universeId == nil or universeId == 0 then
				return nil
			end

			return universeConfigurationStore.getAndFetchSummary(universeId).data(p)
		end)
	end, { universeConfigurationStore, universeId })

	return SignalsReact.useSignalState(v4)
end

local function fetchCachedUniverseSummary(universeId: number) -- 2 equivalent calls inferred from this helper
	local universeConfigurationStore = UniverseConfiguration.getUniverseConfigurationStore()

	if universeConfigurationStore.getSummary(universeId).data(false) ~= nil then
		universeConfigurationStore.fetchSummary(universeId)
	end
end

local function getResolvedSessionId(messages, sessionId: string?, universeId: number?)
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

local function getHydratedExperienceName(experienceName: string, p) -- 1 equivalent call inferred from this helper
	local name

	if p ~= nil then
		name = p.name
	end

	if typeof(name) == "string" and name ~= "" then
		return name
	end

	return experienceName
end

local function usePromptChipViewModel(data, target, flag: boolean)
	local promptChips = {}
	local isPromptChipsLoading = false
	local function onPromptChipActivated() end
	local onChipExhausted = nil
	local onComposerChanged = data.setComposerText

	if not (FFlagBuildEnableFTUXChips or FFlagBuildRequestPromptChipsOnEdit) then
		return {
			promptChips = promptChips,
			isPromptChipsLoading = false,
			onPromptChipActivated = onPromptChipActivated,
			onPromptChipExhausted = onChipExhausted,
			onComposerChanged = onComposerChanged
		}
	end

	local buildPromptChipsStore = GetBuildPromptChipsStore()

	local v4 = FFlagBuildEnableFTUXChips
		and not flag
		and data.isHistoryHydrationComplete
		and not data.isHistoryLoading
		and #data.messages == 0
	local formatted = `{target.universeId or 0}:{target.placeId or 0}:{target.sessionId or "new"}`
	local conversationId

	if FFlagBuildExperienceFTUXChipConversationIdTelemetry then
		conversationId = data.currentSessionId
	else
		conversationId = target.sessionId
	end

	local v5 = useBuildPromptChipRequests(buildPromptChipsStore, {
		isActive = v4,
		sessionKey = formatted,
		shouldRequestInitialChips = v4,
		telemetryGranularity = React.useMemo(function()
			return {
				universeId = target.universeId,
				placeId = target.placeId,
				conversationId = conversationId
			}
		end, { target.universeId or 0, target.placeId or 0, conversationId or "" })
	})

	local ref = React.useRef(nil)

	if FFlagBuildEnableFTUXChips then
		local v6 = SignalsReact.useSignalState(buildPromptChipsStore.getChips)
		local v7 = SignalsReact.useSignalState(buildPromptChipsStore.getStatus)
		promptChips = not v4 and {} or v6

		isPromptChipsLoading = v4 and v7 == promptChipsStatus.PROMPT_CHIPS_STATUS.Loading
		onPromptChipActivated = React.useCallback(function(p)
			local value = data.composerText:getValue()
			v5.requestChipsForSelection(value, p, function(current)
				if data.composerText:getValue() == value then
					ref.current = current
					data.setComposerText(current)
				end
			end)
		end, { data.composerText, data.setComposerText, v5, ref })

		if FFlagBuildExperienceFTUXChipExhaustedTelemetry then
			onChipExhausted = v5.onChipExhausted
		end
	end

	if FFlagBuildRequestPromptChipsOnEdit then
		onComposerChanged = React.useCallback(function(p: string)
			data.setComposerText(p)

			if ref.current == p then
				ref.current = nil
				return
			end

			ref.current = nil
			v5.requestChipsForEdit(p)
		end, { data.setComposerText, v5, ref })
	end

	return {
		promptChips = promptChips,
		isPromptChipsLoading = isPromptChipsLoading,
		onPromptChipActivated = onPromptChipActivated,
		onPromptChipExhausted = onChipExhausted,
		onComposerChanged = onComposerChanged
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

		local current2 = current
		return function()
			CreatorAgentChat.chatOpenTelemetry.close(current2)
		end
	end, { current })
	return current
end

local function useChatOpenSessionLink(chatOpenId: string?, target, currentSessionId: string?)
	local ref = React.useRef(nil)
	local v4 = currentSessionId or target.sessionId

	if chatOpenId ~= nil then
		CreatorAgentChat.chatOpenTelemetry.setSessionId(chatOpenId, v4)
	end

	React.useEffect(function()
		if chatOpenId == nil or v4 == nil then
			return
		end

		local current = ref.current

		if current == nil or current.chatOpenId ~= chatOpenId or current.sessionId ~= v4 then
			ref.current = { chatOpenId = chatOpenId, sessionId = v4 }
			sendBuildExperienceEvent("CHAT_SESSION_LINKED", {
				universeId = target.universeId,
				placeId = target.placeId,
				conversationId = v4,
				chatOpenId = chatOpenId
			})
		end
	end, { chatOpenId, v4 })
end

local function useBuildChatPageViewModel(data)
	local v4 = useTokens()
	local v5 = useUniverseSummary(data.target.universeId)
	local buildOverflowMenuStore = GetBuildOverflowMenuStore()
	local creatorAgentResumeStore = GetCreatorAgentResumeStore()
	local state, setState = React.useState(nil)
	local state2, setState2 = React.useState(false)

	local state3, setState3 = React.useState(nil)
	local state4, setState4 = React.useState(function()
		return engineFeature and BuildAppStorage.isPushNotificationsUpsellDismissedPermanently()
	end)

	local state5, setState5 = React.useState(false)
	local state6, setState6 = React.useState(false)
	local state7, setState7 = React.useState(function()
		return engineFeature and BuildAppStorage.wasPushNotificationsUpsellShownToday()
	end)

	local state8, setState8 = React.useState(false)
	local ref = React.useRef(false)

	local state9, setState9 = React.useState(getKeyboardTop()) -- inferred equivalent call
	local state10, setState10 = React.useState(0)

	local v6 = React.useCallback(function()
		return permissionsProtocol.default:hasPermissions({ permissionsProtocol.Permissions.POST_NOTIFICATIONS }):andThen(
			function(p)
				if ref.current then
					setState3(p.status)

					if p.status == permissionsProtocol.Status.AUTHORIZED then
						setState6(false)
					end
				end
			end,
			function() end
		)
	end, {})

	React.useEffect(function()
		ref.current = true
		v6()

		local connection = MessageBusService:Subscribe(messageId, v6, false, true)
		return function()
			ref.current = false
			connection:Disconnect()
		end
	end, { v6 })

	local onNotifyMe = React.useCallback(function()
		if state5 then
			return
		end

		setState5(true)
		permissionsProtocol.default:requestPermissions({ permissionsProtocol.Permissions.POST_NOTIFICATIONS }):andThen(
			function(p)
				if not ref.current then
					return
				end

				setState3(p.status)

				if p.status == permissionsProtocol.Status.DENIED then
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

	local onOpenPushNotificationsSettings = React.useCallback(function()
		default:switchToSettingsApp():catch(function() end)
	end, {})

	local onNotNow = React.useCallback(function()
		if engineFeature then
			BuildAppStorage.markPushNotificationsUpsellDismissedPermanently()
		end

		setState4(true)
	end, {})

	local v7 = React.useCallback(function()
		setState9(getKeyboardTop()) -- inferred equivalent call
	end, {})

	React.useEffect(function()
		v7()
		local onScreenKeyboardVisibleChangedConnection = UserInputService:GetPropertyChangedSignal("OnScreenKeyboardVisible"):Connect(v7)
		local onScreenKeyboardSizeChangedConnection = UserInputService:GetPropertyChangedSignal("OnScreenKeyboardSize"):Connect(v7)
		local onScreenKeyboardPositionChangedConnection = UserInputService:GetPropertyChangedSignal("OnScreenKeyboardPosition"):Connect(v7)
		return function()
			onScreenKeyboardVisibleChangedConnection:Disconnect()
			onScreenKeyboardSizeChangedConnection:Disconnect()
			onScreenKeyboardPositionChangedConnection:Disconnect()
		end
	end, { v7 })

	local onPageMetricsChanged = React.useCallback(function(p)
		setState10(p.AbsolutePosition.Y + p.AbsoluteSize.Y)
	end, {})

	local onChatViewportChanged = React.useCallback(function(p)
		local y = p.AbsoluteWindowSize.Y
		setState2(y > 0 and y < p.AbsoluteCanvasSize.Y)
	end, {})

	local keyboardOverlap = (state9 <= 0 or state10 <= 0) and 0 or math.max(0, state10 - state9)
	local isNewGameTarget = data.target.isNewGameTarget == true
	local chatPermissions, v8, isChatReadOnly, v9, isPlaytestDisabled, isAdUpsellCreateDisabled

	if FFlagBuildCheckGamePermissions then
		chatPermissions, v8 = useGamePermissions({
			universeId = data.target.universeId,
			isNewGame = isNewGameTarget
		})

		isChatReadOnly = not chatPermissions.canEditOnBuild

		v9 = not chatPermissions.canEdit
		isPlaytestDisabled = not chatPermissions.canEdit
		isAdUpsellCreateDisabled = not chatPermissions.canAdvertise
	else
		isChatReadOnly = false
		isPlaytestDisabled = false
		isAdUpsellCreateDisabled = false
		v8 = false
		v9 = false
	end

	local v10

	if FFlagBuildExperienceChatOpenId then
		v10 = useChatOpen(data.target)
	else
		v10 = nil
	end

	local useMemo = React.useMemo
	local function fn()
		local v11 = {
			universeId = data.target.universeId,
			placeId = data.target.placeId,
			sessionId = data.target.sessionId,
			experienceName = getHydratedExperienceName(data.target.experienceName, v5), -- inferred equivalent call
			isNewGameTarget = data.target.isNewGameTarget,
			modelSelectionDraftId = 0,
			creatorName = 0,
			gameIcon = 0,
			chatOpenId = 0
		}
		local modelSelectionDraftId

		if FFlagBuildExperienceModelPicker then
			modelSelectionDraftId = data.target.modelSelectionDraftId
		end

		v11.modelSelectionDraftId = modelSelectionDraftId

		v11.creatorName = data.target.creatorName
		v11.gameIcon = data.target.gameIcon
		local chatOpenId

		if FFlagBuildExperienceChatOpenId then
			chatOpenId = v10
		end

		v11.chatOpenId = chatOpenId
		return v11
	end

	local universeId = data.target.universeId
	local placeId = data.target.placeId
	local sessionId = data.target.sessionId
	local experienceName = data.target.experienceName
	local isNewGameTarget2 = data.target.isNewGameTarget
	local modelSelectionDraftId = data.target.modelSelectionDraftId
	local creatorName = data.target.creatorName
	local gameIcon = data.target.gameIcon
	local v11

	if FFlagBuildExperienceChatOpenId then
		v11 = v10
	end

	local target = useMemo(fn, {
		universeId,
		placeId,
		sessionId,
		experienceName,
		isNewGameTarget2,
		modelSelectionDraftId,
		creatorName,
		gameIcon,
		v5,
		v11
	})

	local useCallback = React.useCallback
	local function fn2(data2)
		if FFlagBuildExperienceModelPicker and target.modelSelectionDraftId ~= nil then
			GetBuildModelSelectionStore(false).promoteDraft(target.modelSelectionDraftId, data2.universeId)
		end

		if FFlagBuildExperienceChatOpenId and target.chatOpenId ~= nil then
			CreatorAgentChat.chatOpenTelemetry.setUniverseId(target.chatOpenId, data2.universeId)
		end

		if data.onNavigateToResolvedTarget ~= nil then
			local onNavigateToResolvedTarget = data.onNavigateToResolvedTarget
			local v12 = {
				universeId = data2.universeId,
				placeId = data2.placeId,
				sessionId = data2.sessionId,
				experienceName = target.experienceName,
				isNewGameTarget = target.isNewGameTarget,
				modelSelectionDraftId = 0,
				creatorName = 0,
				gameIcon = 0,
				chatOpenId = 0
			}
			local modelSelectionDraftId2

			if FFlagBuildExperienceModelPicker then
				modelSelectionDraftId2 = target.modelSelectionDraftId
			end

			v12.modelSelectionDraftId = modelSelectionDraftId2

			v12.creatorName = target.creatorName
			v12.gameIcon = target.gameIcon
			local chatOpenId

			if FFlagBuildExperienceChatOpenId then
				chatOpenId = target.chatOpenId
			end

			v12.chatOpenId = chatOpenId
			onNavigateToResolvedTarget(v12)
		end
	end

	local v12

	if FFlagBuildExperienceModelPicker then
		v12 = { data.onNavigateToResolvedTarget, target }
	else
		v12 = { nil, nil, nil, nil, nil, nil }
		local onNavigateToResolvedTarget = data.onNavigateToResolvedTarget
		local experienceName2 = target.experienceName
		local isNewGameTarget3 = target.isNewGameTarget
		local creatorName2 = target.creatorName
		local gameIcon2 = target.gameIcon
		local v13

		if FFlagBuildExperienceChatOpenId then
			v13 = target.chatOpenId
		end

		v12[1], v12[2], v12[3], v12[4], v12[5], v12[6] = onNavigateToResolvedTarget, experienceName2, isNewGameTarget3, creatorName2, gameIcon2, v13
	end

	local onProjectResolved = useCallback(fn2, v12)

	local state11, setState11 = React.useState({ count = 0, reason = nil })

	local onPromptFailure = React.useCallback(function(p: number?, reason)
		if p == CreatorAgentChat.ErrorCodes.OutOfCredits then
			setState11(function(p2)
				return {
					count = p2.count + 1,
					reason = reason
				}
			end)
		end
	end, {})
	local v13

	if FFlagBuildAdUpsell then
		v13 = GetAdUpsellEventStore(false)
	else
		v13 = nil
	end

	local onAssistantTurnCompleted

	if FFlagBuildAdUpsell then
		onAssistantTurnCompleted = React.useCallback(function(p)
			if v13 ~= nil then
				v13.reportAssistantTurnCompleted(p)
			end
		end, { v13 })
	end

	local v14 = {
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
	local modelSelectionDraftId2

	if FFlagBuildExperienceModelPicker then
		modelSelectionDraftId2 = target.modelSelectionDraftId
	end

	v14.modelSelectionDraftId = modelSelectionDraftId2
	v14.onProjectResolved = onProjectResolved

	if FFlagBuildExperienceModelPicker then
		onPromptFailure = nil
	end

	v14.onPromptFailure = onPromptFailure
	v14.trackAdUpsellTurns = FFlagBuildAdUpsell
	v14.onAssistantTurnCompleted = onAssistantTurnCompleted
	v14.sendMessageWhen = not isChatReadOnly
	local v15 = useChatSessionCore(v14)

	if FFlagBuildExperienceChatOpenId then
		useChatOpenSessionLink(v10, data.target, v15.currentSessionId)
	end

	local isChatEmpty = #v15.messages == 0
	local v16 = usePromptChipViewModel(v15, data.target, isChatReadOnly)
	local promptChips = v16.promptChips
	local isPromptChipsLoading = v16.isPromptChipsLoading
	local onPromptChipActivated = v16.onPromptChipActivated
	local onPromptChipExhausted = v16.onPromptChipExhausted
	local onComposerChanged = v16.onComposerChanged
	local modelPicker

	if FFlagBuildExperienceModelPicker then
		modelPicker = useBuildModelSelection(
			data.target.universeId,
			data.target.modelSelectionDraftId,
			data.modelPicker,
			v15.modelSessionModels,
			v15.hasPreparedModelSession,
			v15.internalTesting
		)
	end

	if FFlagBuildExperienceAnalytics then
		local ref2 = React.useRef(false)

		React.useEffect(function()
			local initialPrompt = data.initialPrompt

			if ref2.current or initialPrompt == nil or initialPrompt == "" then
				return
			end

			v15.setComposerText(initialPrompt)

			if v15.sendMessage() then
				ref2.current = true
			end
		end, { data.initialPrompt, v15.sendMessage, v15.setComposerText })
	end

	if FFlagBuildExperienceMonetizationNativeUI then
		local universeId2 = data.target.universeId
		local sessionId2 = data.target.sessionId
		local setPrefilledComposerText = v15.setPrefilledComposerText
		local sendMessage = v15.sendMessage
		local isFocused = data.isFocused ~= false
		local v17

		if FFlagBuildExperienceDeveloperProductContext then
			v17 = v15
		end

		useBuildPromptDraft(universeId2, sessionId2, setPrefilledComposerText, sendMessage, isFocused, v17)
	elseif FFlagBuildExperienceManageDevProduct then
		local universeId2 = data.target.universeId
		local sessionId2 = data.target.sessionId
		local setPrefilledComposerText = v15.setPrefilledComposerText
		local sendMessage = v15.sendMessage
		local v17

		if FFlagBuildExperienceDeveloperProductContext then
			v17 = v15
		end

		useBuildPromptDraft(universeId2, sessionId2, setPrefilledComposerText, sendMessage, nil, v17)
	end

	local v17 = useChatPlaytestFooter(v15, "BuildChatPlaytestCta")
	local subagentTaskState = v15.subagentTaskState
	local hasTaskGroups

	if subagentTaskState == nil then
		hasTaskGroups = false
	else
		hasTaskGroups = #subagentTaskState.groups > 0
	end

	local v18 = false

	for _, message in v15.messages do
		if message.kind == "user_message" then
			v18 = true
			break
		end
	end

	local v19

	if state3 == permissionsProtocol.Status.DENIED then
		v19 = not state4 and (not state7 or state8)
	else
		v19 = false
	end

	local ref2 = React.useRef(false)

	React.useEffect(function()
		if not engineFeature then
			return function() end
		end

		local isAssistantResponding = v19 and v18 and v15.isAssistantResponding

		if isAssistantResponding and not state8 then
			setState8(true)
			setState7(true)
			BuildAppStorage.markPushNotificationsUpsellShown()
		elseif not isAssistantResponding and state8 then
			setState8(false)
		end

		return function() end
	end, { v19, v18, v15.isAssistantResponding, state7, state8 })

	React.useEffect(function()
		local universeId2 = data.target.universeId
		local v20 = ref2.current and not v15.isAssistantResponding
		ref2.current = v15.isAssistantResponding

		if not v20 or universeId2 == nil or universeId2 == 0 then
			return function() end
		end

		if FFlagBuildAdUpsell then
			task.defer(function()
				if ref.current then
					fetchCachedUniverseSummary(universeId2) -- inferred equivalent call
				end
			end)
		else
			fetchCachedUniverseSummary(universeId2) -- inferred equivalent call
		end

		return function() end
	end, { data.target.universeId, v15.isAssistantResponding })

	local useEffect = React.useEffect
	local function fn3()
		if FFlagBuildExperienceMonetizationNativeUI and data.isFocused == false then
			return
		end

		creatorAgentResumeStore.setActiveTarget({
			universeId = data.target.universeId,
			sessionId = data.target.sessionId
		})

		return function()
			creatorAgentResumeStore.setActiveTarget(nil)
		end
	end

	local v20

	if FFlagBuildExperienceMonetizationNativeUI then
		v20 = {
			creatorAgentResumeStore,
			data.target.universeId or false,
			data.target.sessionId or false,
			data.isFocused ~= false
		}
	else
		v20 = { creatorAgentResumeStore, data.target.universeId, data.target.sessionId }
	end

	useEffect(fn3, v20)

	local v21 = React.useCallback(function()
		if v15.textBoxRef.current then
			v15.textBoxRef.current.releaseFocus()
		end
	end, { v15.textBoxRef })

	local onOpenCreatorCreditPage = React.useCallback(function()
		v21()

		if data.onOpenCreatorCreditPage ~= nil then
			data.onOpenCreatorCreditPage()
		end
	end, { v21, data.onOpenCreatorCreditPage })

	if data.onOpenCreatorCreditPage == nil then
		onOpenCreatorCreditPage = nil
	end

	local v22

	if FFlagEnableBuildAdPromotion then
		v22 = React.useCallback(function()
			v21()

			if data.onOpenGetUsersPage ~= nil then
				data.onOpenGetUsersPage()
			end
		end, { v21, data.onOpenGetUsersPage })
	end

	if data.onOpenGetUsersPage == nil then
		v22 = nil
	end

	local v23 = {
		namedTier = FFlagBuildExperienceModelPicker and modelPicker and modelPicker.selectedId == "advanced" and not (modelPicker.internalTesting and modelPicker.internalTesting.isSelected) and "advanced" or nil,
		onOpenCreatorCreditPage = onOpenCreatorCreditPage,
		outOfCreditsPromptFailureCount = 0,
		outOfCreditsPromptFailureReason = 0,
		isAssistantResponding = 0
	}
	local count

	if FFlagBuildExperienceModelPicker then
		if v15.fundingFailure then
			count = v15.fundingFailure.count
		end
	else
		count = state11.count
	end

	v23.outOfCreditsPromptFailureCount = count
	local reason

	if FFlagBuildExperienceModelPicker then
		if v15.fundingFailure then
			reason = v15.fundingFailure.reason
		end
	else
		reason = state11.reason
	end

	v23.outOfCreditsPromptFailureReason = reason

	v23.isAssistantResponding = v15.isAssistantResponding
	local v24 = useCreatorCreditChatUpsellViewModel(v23)

	local v25 = (FFlagBuildAdUpsell or FFlagEnableBuildAdPromotion)
		and GameConfigurationLabels.getAudience(v5) == UniverseConfiguration.PrivacyType.Public
	local sessionId2

	if FFlagBuildAdUpsell or FFlagBuildExperienceLibrary then
		sessionId2 = getResolvedSessionId(v15.messages, data.target.sessionId, data.target.universeId)
	else
		sessionId2 = nil
	end

	local v26

	if FFlagBuildAdUpsell then
		v26 = useAdUpsellChatViewModel({
			messages = v15.messages,
			isHistoryExhausted = v15.isHistoryExhausted,
			sessionId = sessionId2,
			isPublic = v25,
			isPageVisible = data.isFocused ~= false,
			universeId = data.target.universeId
		})
	else
		v26 = v2
	end

	local v27

	if FFlagBuildAgentAdCampaignCard then
		v27 = useAgentAdCampaignChatViewModel({
			universeId = data.target.universeId,
			sessionId = sessionId2,
			isPageVisible = data.isFocused ~= false
		})
	else
		v27 = v3
	end

	local onClose = React.useCallback(function()
		v21()
		data.onClose()
	end, { v21, data.onClose })

	local onOverflowMenuAction = React.useCallback(function(p)
		if p.type == "openPage" then
			v21()

			if data.onOpenConfigurationPage then
				data.onOpenConfigurationPage(p.page)
			end
		elseif p.type == "openInvitePicker" then
			v21()

			if data.onOpenInvitePicker then
				data.onOpenInvitePicker()
			end
		elseif p.type == "openInviteManagement" then
			v21()

			if data.onOpenInviteManagement then
				data.onOpenInviteManagement()
			end
		end
	end, { v21, data.onOpenConfigurationPage, data.onOpenInvitePicker, data.onOpenInviteManagement })
	local onPublish

	if FFlagBuildExperiencePlaytestCardPublishCta then
		onPublish = React.useCallback(function()
			onOverflowMenuAction({ type = "openPage", page = "publish" })
		end, { onOverflowMenuAction })
	end

	local onOpenLibrary = React.useCallback(function()
		v21()

		if data.onOpenLibrary ~= nil then
			data.onOpenLibrary(sessionId2)
		end
	end, { v21, data.onOpenLibrary, sessionId2 })

	local onPlayActivated = React.useCallback(function()
		sendBuildExperienceEvent(
			FFlagBuildEventsUpdate1 and "PLAYTEST_CLICK" or "PLAY_CLICK",
			{ universeId = data.target.universeId, placeId = v15.playtestPlaceId },
			FFlagBuildEventsUpdate1 and { context = "app_header" } or nil
		)

		if v15.launchPlaytest then
			v15.launchPlaytest("BuildChatPage")
		end
	end, { v15.launchPlaytest, v15.playtestPlaceId, data.target.universeId })

	local onOpenAgentsPage = React.useCallback(function()
		v21()
		data.onOpenAgentsPage(subagentTaskState or v)
	end, { v21, data.onOpenAgentsPage, subagentTaskState })

	local onChipActivated = React.useCallback(function(p: string)
		v21()
		setState(p)
	end, { v21 })

	local v28 = {}
	v28.target = target
	v28.agentSpecVersion = v15.agentSpecVersion
	v28.setAgentSpecVersion = v15.setAgentSpecVersion
	v28.keyboardOverlap = keyboardOverlap
	v28.onPageMetricsChanged = onPageMetricsChanged
	v28.selectedChipGroupName = state
	v28.onChipActivated = onChipActivated

	function v28.onChipBottomSheetClose()
		setState(nil)
	end

	v28.onClose = onClose
	v28.onOpenLibrary = onOpenLibrary
	v28.isLibraryDisabled = FFlagBuildExperienceLibrary and (data.target.universeId == nil or v9)
	v28.onOverflowMenuAction = onOverflowMenuAction
	v28.onPlayActivated = onPlayActivated
	v28.onOpenAgentsPage = onOpenAgentsPage
	v28.onOpenCreatorCreditPage = onOpenCreatorCreditPage
	v28.onOpenGetUsersPage = v22
	v28.isUniversePublic = v25
	v28.buildOverflowMenuStore = buildOverflowMenuStore
	v28.messages = v15.messages
	v28.localToolActions = v15.localToolActions
	local answerForm

	if FFlagBuildExperienceAnswerForm then
		answerForm = v15.answerForm
	end

	v28.answerForm = answerForm
	local onSubmitAnswerText

	if FFlagBuildExperienceAnswerForm then
		onSubmitAnswerText = v15.submitAnswerText
	end

	v28.onSubmitAnswerText = onSubmitAnswerText
	v28.clockBinding = v15.clockBinding
	v28.onPlaytest = v17.onPlaytest

	if data.onOpenConfigurationPage == nil then
		onPublish = nil
	end

	v28.onPublish = onPublish
	v28.isPlaytestLoading = v17.isPlaytestLoading
	v28.isPlaytestDisabled = isPlaytestDisabled
	local showPushNotificationsUpsell

	if engineFeature then
		showPushNotificationsUpsell = state8 and v19
	else
		showPushNotificationsUpsell = v19
	end

	v28.showPushNotificationsUpsell = showPushNotificationsUpsell

	v28.isPushNotificationsRequestPending = state5
	v28.shouldOpenPushNotificationsSettings = state6
	v28.onNotifyMe = onNotifyMe
	v28.onOpenPushNotificationsSettings = onOpenPushNotificationsSettings
	v28.onNotNow = onNotNow
	v28.showBuyMoreRobuxCard = v24.showBuyMoreRobuxCard
	v28.buyMoreRobuxCardTitle = v24.buyMoreRobuxCardTitle
	v28.buyMoreRobuxCardDescription = v24.buyMoreRobuxCardDescription
	v28.buyMoreRobuxCardPrimaryActionText = v24.buyMoreRobuxCardPrimaryActionText
	v28.onBuyMoreRobuxCardPrimaryAction = v24.onBuyMoreRobuxCardPrimaryAction
	v28.buyMoreRobuxCardSecondaryActionText = v24.buyMoreRobuxCardSecondaryActionText
	v28.onBuyMoreRobuxCardSecondaryAction = v24.onBuyMoreRobuxCardSecondaryAction
	v28.adUpsellCards = v26.adUpsellCards
	v28.adUpsellCongratsAnchorIndex = v26.adUpsellCongratsAnchorIndex
	v28.adUpsellFreePromotionsRemaining = v26.adUpsellFreePromotionsRemaining
	v28.isAdUpsellCreatePending = v26.isAdUpsellCreatePending
	v28.isAdUpsellCreateDisabled = isAdUpsellCreateDisabled
	v28.isAdCampaignSheetOpen = v26.isAdCampaignSheetOpen
	v28.hasAdCampaignCreateError = v26.hasAdCampaignCreateError
	v28.adCampaignCreateErrorKind = v26.adCampaignCreateErrorKind
	v28.adCampaignDurationDays = v26.adCampaignDurationDays
	v28.adCampaignEstimatedPriceRobux = v26.adCampaignEstimatedPriceRobux
	v28.adCampaignOffers = v26.adCampaignOffers
	v28.adCampaignRunStartTimeMs = v26.adCampaignRunStartTimeMs
	v28.adCampaignRunEndTimeMs = v26.adCampaignRunEndTimeMs
	v28.isAdCampaignCreatedToastVisible = v26.isAdCampaignCreatedToastVisible
	v28.onAdCampaignCreatedToastDismiss = v26.onAdCampaignCreatedToastDismiss
	v28.onAdUpsellCreate = v26.onAdUpsellCreate
	v28.onAdUpsellDismiss = v26.onAdUpsellDismiss
	v28.onAdUpsellImpression = v26.onAdUpsellImpression
	v28.onAdCampaignSheetClose = v26.onAdCampaignSheetClose
	v28.onAdCampaignSheetCreate = v26.onAdCampaignSheetCreate
	v28.isAgentAdCampaignSheetOpen = v27.isSheetOpen
	v28.isAgentAdCampaignCreatePending = v27.isCreatePending
	v28.hasAgentAdCampaignCreateError = v27.hasCreateError
	v28.agentAdCampaignCreateErrorKind = v27.createErrorKind
	v28.agentAdCampaignOffers = v27.campaignOffers
	v28.agentAdCampaignRunStartTimeMs = v27.runStartTimeMs
	v28.onAgentAdCampaignOfferSelected = v27.onOfferSelected
	v28.getAgentAdCampaignCardState = v27.getCardState
	local isAgentAdCampaignCreateDisabled

	if isAdUpsellCreateDisabled then
		isAgentAdCampaignCreateDisabled = v3.isCreateDisabled
	else
		isAgentAdCampaignCreateDisabled = v27.isCreateDisabled
	end

	v28.isAgentAdCampaignCreateDisabled = isAgentAdCampaignCreateDisabled

	v28.agentAdCampaignAttemptedOption = v27.attemptedOption

	if isAdUpsellCreateDisabled then
		v22 = nil
	end

	v28.onAgentAdCampaignActive = v22
	v28.onAgentAdCampaignSheetClose = v27.onSheetClose
	v28.onAgentAdCampaignSheetCreate = v27.onSheetCreate
	v28.isAdUpsellVisible = data.isFocused ~= false
	v28.isChatEmpty = isChatEmpty
	v28.isHistoryLoading = v15.isHistoryLoading or v8
	v28.isNewGameTarget = isNewGameTarget
	v28.hasPublishedTurn = v15.hasPublishedTurn
	v28.hasPublishedVersion = v5 ~= nil and v5.isActive
	v28.hasTaskGroups = hasTaskGroups
	v28.taskState = subagentTaskState
	v28.scrollingFrameRef = v15.setScrollingFrame
	v28.anchorScrollToInstance = v15.anchorScrollToInstance
	v28.onChatViewportChanged = onChatViewportChanged
	v28.isChatScrollable = state2
	v28.modelPicker = modelPicker
	v28.composerText = v15.composerText
	v28.composerErrorText = v15.composerErrorText
	v28.onComposerChanged = onComposerChanged
	v28.promptChips = promptChips
	v28.isPromptChipsLoading = isPromptChipsLoading
	v28.onPromptChipActivated = onPromptChipActivated
	v28.onPromptChipExhausted = onPromptChipExhausted
	v28.composerImages = v15.composerImages
	v28.onComposerImagesChanged = v15.setComposerImages
	v28.onRetryComposerImage = v15.retryComposerImage
	v28.composerResourceAttachments = v15.composerResourceAttachments
	v28.onRemoveComposerResourceAttachment = v15.removeComposerResourceAttachmentAtIndex
	v28.isComposerSendBlocked = v15.isComposerSendBlocked
	v28.textBoxRef = v15.textBoxRef
	v28.isAssistantResponding = v15.isAssistantResponding
	v28.canStopAssistantResponse = v15.canStopAssistantResponse
	v28.canSendWhileResponding = v15.canSendWhileResponding
	v28.isChatReadOnly = isChatReadOnly
	v28.chatPermissions = chatPermissions
	v28.onSend = v15.sendMessage
	v28.onStop = v15.stopAssistantResponse
	v28.statusChipGap = v4.Gap.Small
	v28.paddingBottom = v4.Padding.Small + keyboardOverlap
	return v28
end

return useBuildChatPageViewModel
