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

	local target = React.useMemo(function()
		local v10 = {
			universeId = data.target.universeId,
			placeId = data.target.placeId,
			sessionId = data.target.sessionId,
			experienceName = getHydratedExperienceName(data.target.experienceName, v5), -- inferred equivalent call
			isNewGameTarget = data.target.isNewGameTarget,
			modelSelectionDraftId = 0,
			creatorName = 0,
			gameIcon = 0
		}
		local modelSelectionDraftId

		if FFlagBuildExperienceModelPicker then
			modelSelectionDraftId = data.target.modelSelectionDraftId
		end

		v10.modelSelectionDraftId = modelSelectionDraftId

		v10.creatorName = data.target.creatorName
		v10.gameIcon = data.target.gameIcon
		return v10
	end, {
		data.target.universeId,
		data.target.placeId,
		data.target.sessionId,
		data.target.experienceName,
		data.target.isNewGameTarget,
		data.target.modelSelectionDraftId,
		data.target.creatorName,
		data.target.gameIcon,
		v5
	})

	local useCallback = React.useCallback
	local function fn(data2)
		if FFlagBuildExperienceModelPicker and target.modelSelectionDraftId ~= nil then
			GetBuildModelSelectionStore(false).promoteDraft(target.modelSelectionDraftId, data2.universeId)
		end

		if data.onNavigateToResolvedTarget ~= nil then
			local onNavigateToResolvedTarget = data.onNavigateToResolvedTarget
			local v10 = {
				universeId = data2.universeId,
				placeId = data2.placeId,
				sessionId = data2.sessionId,
				experienceName = target.experienceName,
				isNewGameTarget = target.isNewGameTarget,
				modelSelectionDraftId = 0,
				creatorName = 0,
				gameIcon = 0
			}
			local modelSelectionDraftId

			if FFlagBuildExperienceModelPicker then
				modelSelectionDraftId = target.modelSelectionDraftId
			end

			v10.modelSelectionDraftId = modelSelectionDraftId

			v10.creatorName = target.creatorName
			v10.gameIcon = target.gameIcon
			onNavigateToResolvedTarget(v10)
		end
	end

	local v10

	if FFlagBuildExperienceModelPicker then
		v10 = { data.onNavigateToResolvedTarget, target }
	else
		v10 = {
			data.onNavigateToResolvedTarget,
			target.experienceName,
			target.isNewGameTarget,
			target.creatorName,
			target.gameIcon
		}
	end

	local onProjectResolved = useCallback(fn, v10)

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
	local v11

	if FFlagBuildAdUpsell then
		v11 = GetAdUpsellEventStore(false)
	else
		v11 = nil
	end

	local onAssistantTurnCompleted

	if FFlagBuildAdUpsell then
		onAssistantTurnCompleted = React.useCallback(function(p)
			if v11 ~= nil then
				v11.reportAssistantTurnCompleted(p)
			end
		end, { v11 })
	end

	local v12 = {
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
	local modelSelectionDraftId

	if FFlagBuildExperienceModelPicker then
		modelSelectionDraftId = target.modelSelectionDraftId
	end

	v12.modelSelectionDraftId = modelSelectionDraftId
	v12.onProjectResolved = onProjectResolved

	if FFlagBuildExperienceModelPicker then
		onPromptFailure = nil
	end

	v12.onPromptFailure = onPromptFailure
	v12.trackAdUpsellTurns = FFlagBuildAdUpsell
	v12.onAssistantTurnCompleted = onAssistantTurnCompleted
	v12.sendMessageWhen = not isChatReadOnly
	local v13 = useChatSessionCore(v12)

	local isChatEmpty = #v13.messages == 0
	local v14 = usePromptChipViewModel(v13, data.target, isChatReadOnly)
	local promptChips = v14.promptChips
	local isPromptChipsLoading = v14.isPromptChipsLoading
	local onPromptChipActivated = v14.onPromptChipActivated
	local onPromptChipExhausted = v14.onPromptChipExhausted
	local onComposerChanged = v14.onComposerChanged
	local modelPicker

	if FFlagBuildExperienceModelPicker then
		modelPicker = useBuildModelSelection(
			data.target.universeId,
			data.target.modelSelectionDraftId,
			data.modelPicker,
			v13.modelSessionModels,
			v13.hasPreparedModelSession,
			v13.internalTesting
		)
	end

	if FFlagBuildExperienceAnalytics then
		local ref2 = React.useRef(false)

		React.useEffect(function()
			local initialPrompt = data.initialPrompt

			if ref2.current or initialPrompt == nil or initialPrompt == "" then
				return
			end

			v13.setComposerText(initialPrompt)

			if v13.sendMessage() then
				ref2.current = true
			end
		end, { data.initialPrompt, v13.sendMessage, v13.setComposerText })
	end

	if FFlagBuildExperienceMonetizationNativeUI then
		local universeId = data.target.universeId
		local sessionId = data.target.sessionId
		local setPrefilledComposerText = v13.setPrefilledComposerText
		local sendMessage = v13.sendMessage
		local isFocused = data.isFocused ~= false
		local v15

		if FFlagBuildExperienceDeveloperProductContext then
			v15 = v13
		end

		useBuildPromptDraft(universeId, sessionId, setPrefilledComposerText, sendMessage, isFocused, v15)
	elseif FFlagBuildExperienceManageDevProduct then
		local universeId = data.target.universeId
		local sessionId = data.target.sessionId
		local setPrefilledComposerText = v13.setPrefilledComposerText
		local sendMessage = v13.sendMessage
		local v15

		if FFlagBuildExperienceDeveloperProductContext then
			v15 = v13
		end

		useBuildPromptDraft(universeId, sessionId, setPrefilledComposerText, sendMessage, nil, v15)
	end

	local v15 = useChatPlaytestFooter(v13, "BuildChatPlaytestCta")
	local subagentTaskState = v13.subagentTaskState
	local hasTaskGroups

	if subagentTaskState == nil then
		hasTaskGroups = false
	else
		hasTaskGroups = #subagentTaskState.groups > 0
	end

	local v16 = false

	for _, message in v13.messages do
		if message.kind == "user_message" then
			v16 = true
			break
		end
	end

	local v17

	if state3 == permissionsProtocol.Status.DENIED then
		v17 = not state4 and (not state7 or state8)
	else
		v17 = false
	end

	local ref2 = React.useRef(false)

	React.useEffect(function()
		if not engineFeature then
			return function() end
		end

		local isAssistantResponding = v17 and v16 and v13.isAssistantResponding

		if isAssistantResponding and not state8 then
			setState8(true)
			setState7(true)
			BuildAppStorage.markPushNotificationsUpsellShown()
		elseif not isAssistantResponding and state8 then
			setState8(false)
		end

		return function() end
	end, { v17, v16, v13.isAssistantResponding, state7, state8 })

	React.useEffect(function()
		local universeId = data.target.universeId
		local v18 = ref2.current and not v13.isAssistantResponding
		ref2.current = v13.isAssistantResponding

		if not v18 or universeId == nil or universeId == 0 then
			return function() end
		end

		if FFlagBuildAdUpsell then
			task.defer(function()
				if ref.current then
					fetchCachedUniverseSummary(universeId) -- inferred equivalent call
				end
			end)
		else
			fetchCachedUniverseSummary(universeId) -- inferred equivalent call
		end

		return function() end
	end, { data.target.universeId, v13.isAssistantResponding })

	local useEffect = React.useEffect
	local function fn2()
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

	local v18

	if FFlagBuildExperienceMonetizationNativeUI then
		v18 = {
			creatorAgentResumeStore,
			data.target.universeId or false,
			data.target.sessionId or false,
			data.isFocused ~= false
		}
	else
		v18 = { creatorAgentResumeStore, data.target.universeId, data.target.sessionId }
	end

	useEffect(fn2, v18)

	local v19 = React.useCallback(function()
		if v13.textBoxRef.current then
			v13.textBoxRef.current.releaseFocus()
		end
	end, { v13.textBoxRef })

	local onOpenCreatorCreditPage = React.useCallback(function()
		v19()

		if data.onOpenCreatorCreditPage ~= nil then
			data.onOpenCreatorCreditPage()
		end
	end, { v19, data.onOpenCreatorCreditPage })

	if data.onOpenCreatorCreditPage == nil then
		onOpenCreatorCreditPage = nil
	end

	local v20

	if FFlagEnableBuildAdPromotion then
		v20 = React.useCallback(function()
			v19()

			if data.onOpenGetUsersPage ~= nil then
				data.onOpenGetUsersPage()
			end
		end, { v19, data.onOpenGetUsersPage })
	end

	if data.onOpenGetUsersPage == nil then
		v20 = nil
	end

	local v21 = {
		namedTier = FFlagBuildExperienceModelPicker and modelPicker and modelPicker.selectedId == "advanced" and not (modelPicker.internalTesting and modelPicker.internalTesting.isSelected) and "advanced" or nil,
		onOpenCreatorCreditPage = onOpenCreatorCreditPage,
		outOfCreditsPromptFailureCount = 0,
		outOfCreditsPromptFailureReason = 0,
		isAssistantResponding = 0
	}
	local count

	if FFlagBuildExperienceModelPicker then
		if v13.fundingFailure then
			count = v13.fundingFailure.count
		end
	else
		count = state11.count
	end

	v21.outOfCreditsPromptFailureCount = count
	local reason

	if FFlagBuildExperienceModelPicker then
		if v13.fundingFailure then
			reason = v13.fundingFailure.reason
		end
	else
		reason = state11.reason
	end

	v21.outOfCreditsPromptFailureReason = reason

	v21.isAssistantResponding = v13.isAssistantResponding
	local v22 = useCreatorCreditChatUpsellViewModel(v21)

	local v23 = (FFlagBuildAdUpsell or FFlagEnableBuildAdPromotion)
		and GameConfigurationLabels.getAudience(v5) == UniverseConfiguration.PrivacyType.Public
	local sessionId

	if FFlagBuildAdUpsell or FFlagBuildExperienceLibrary then
		sessionId = getResolvedSessionId(v13.messages, data.target.sessionId, data.target.universeId)
	else
		sessionId = nil
	end

	local v24

	if FFlagBuildAdUpsell then
		v24 = useAdUpsellChatViewModel({
			messages = v13.messages,
			isHistoryExhausted = v13.isHistoryExhausted,
			sessionId = sessionId,
			isPublic = v23,
			isPageVisible = data.isFocused ~= false,
			universeId = data.target.universeId
		})
	else
		v24 = v2
	end

	local v25

	if FFlagBuildAgentAdCampaignCard then
		v25 = useAgentAdCampaignChatViewModel({
			universeId = data.target.universeId,
			sessionId = sessionId,
			isPageVisible = data.isFocused ~= false
		})
	else
		v25 = v3
	end

	local onClose = React.useCallback(function()
		v19()
		data.onClose()
	end, { v19, data.onClose })

	local onOverflowMenuAction = React.useCallback(function(p)
		if p.type == "openPage" then
			v19()

			if data.onOpenConfigurationPage then
				data.onOpenConfigurationPage(p.page)
			end
		elseif p.type == "openInvitePicker" then
			v19()

			if data.onOpenInvitePicker then
				data.onOpenInvitePicker()
			end
		elseif p.type == "openInviteManagement" then
			v19()

			if data.onOpenInviteManagement then
				data.onOpenInviteManagement()
			end
		end
	end, { v19, data.onOpenConfigurationPage, data.onOpenInvitePicker, data.onOpenInviteManagement })
	local onPublish

	if FFlagBuildExperiencePlaytestCardPublishCta then
		onPublish = React.useCallback(function()
			onOverflowMenuAction({ type = "openPage", page = "publish" })
		end, { onOverflowMenuAction })
	end

	local onOpenLibrary = React.useCallback(function()
		v19()

		if data.onOpenLibrary ~= nil then
			data.onOpenLibrary(sessionId)
		end
	end, { v19, data.onOpenLibrary, sessionId })

	local onPlayActivated = React.useCallback(function()
		sendBuildExperienceEvent(
			FFlagBuildEventsUpdate1 and "PLAYTEST_CLICK" or "PLAY_CLICK",
			{ universeId = data.target.universeId, placeId = v13.playtestPlaceId },
			FFlagBuildEventsUpdate1 and { context = "app_header" } or nil
		)

		if v13.launchPlaytest then
			v13.launchPlaytest("BuildChatPage")
		end
	end, { v13.launchPlaytest, v13.playtestPlaceId, data.target.universeId })

	local onOpenAgentsPage = React.useCallback(function()
		v19()
		data.onOpenAgentsPage(subagentTaskState or v)
	end, { v19, data.onOpenAgentsPage, subagentTaskState })

	local onChipActivated = React.useCallback(function(p: string)
		v19()
		setState(p)
	end, { v19 })

	local v26 = {}
	v26.target = target
	v26.agentSpecVersion = v13.agentSpecVersion
	v26.setAgentSpecVersion = v13.setAgentSpecVersion
	v26.keyboardOverlap = keyboardOverlap
	v26.onPageMetricsChanged = onPageMetricsChanged
	v26.selectedChipGroupName = state
	v26.onChipActivated = onChipActivated

	function v26.onChipBottomSheetClose()
		setState(nil)
	end

	v26.onClose = onClose
	v26.onOpenLibrary = onOpenLibrary
	v26.isLibraryDisabled = FFlagBuildExperienceLibrary and (data.target.universeId == nil or v9)
	v26.onOverflowMenuAction = onOverflowMenuAction
	v26.onPlayActivated = onPlayActivated
	v26.onOpenAgentsPage = onOpenAgentsPage
	v26.onOpenCreatorCreditPage = onOpenCreatorCreditPage
	v26.onOpenGetUsersPage = v20
	v26.isUniversePublic = v23
	v26.buildOverflowMenuStore = buildOverflowMenuStore
	v26.messages = v13.messages
	v26.localToolActions = v13.localToolActions
	local answerForm

	if FFlagBuildExperienceAnswerForm then
		answerForm = v13.answerForm
	end

	v26.answerForm = answerForm
	local onSubmitAnswerText

	if FFlagBuildExperienceAnswerForm then
		onSubmitAnswerText = v13.submitAnswerText
	end

	v26.onSubmitAnswerText = onSubmitAnswerText
	v26.clockBinding = v13.clockBinding
	v26.onPlaytest = v15.onPlaytest

	if data.onOpenConfigurationPage == nil then
		onPublish = nil
	end

	v26.onPublish = onPublish
	v26.isPlaytestLoading = v15.isPlaytestLoading
	v26.isPlaytestDisabled = isPlaytestDisabled
	local showPushNotificationsUpsell

	if engineFeature then
		showPushNotificationsUpsell = state8 and v17
	else
		showPushNotificationsUpsell = v17
	end

	v26.showPushNotificationsUpsell = showPushNotificationsUpsell

	v26.isPushNotificationsRequestPending = state5
	v26.shouldOpenPushNotificationsSettings = state6
	v26.onNotifyMe = onNotifyMe
	v26.onOpenPushNotificationsSettings = onOpenPushNotificationsSettings
	v26.onNotNow = onNotNow
	v26.showBuyMoreRobuxCard = v22.showBuyMoreRobuxCard
	v26.buyMoreRobuxCardTitle = v22.buyMoreRobuxCardTitle
	v26.buyMoreRobuxCardDescription = v22.buyMoreRobuxCardDescription
	v26.buyMoreRobuxCardPrimaryActionText = v22.buyMoreRobuxCardPrimaryActionText
	v26.onBuyMoreRobuxCardPrimaryAction = v22.onBuyMoreRobuxCardPrimaryAction
	v26.buyMoreRobuxCardSecondaryActionText = v22.buyMoreRobuxCardSecondaryActionText
	v26.onBuyMoreRobuxCardSecondaryAction = v22.onBuyMoreRobuxCardSecondaryAction
	v26.adUpsellCards = v24.adUpsellCards
	v26.adUpsellCongratsAnchorIndex = v24.adUpsellCongratsAnchorIndex
	v26.adUpsellFreePromotionsRemaining = v24.adUpsellFreePromotionsRemaining
	v26.isAdUpsellCreatePending = v24.isAdUpsellCreatePending
	v26.isAdUpsellCreateDisabled = isAdUpsellCreateDisabled
	v26.isAdCampaignSheetOpen = v24.isAdCampaignSheetOpen
	v26.hasAdCampaignCreateError = v24.hasAdCampaignCreateError
	v26.adCampaignCreateErrorKind = v24.adCampaignCreateErrorKind
	v26.adCampaignDurationDays = v24.adCampaignDurationDays
	v26.adCampaignEstimatedPriceRobux = v24.adCampaignEstimatedPriceRobux
	v26.adCampaignOffers = v24.adCampaignOffers
	v26.adCampaignRunStartTimeMs = v24.adCampaignRunStartTimeMs
	v26.adCampaignRunEndTimeMs = v24.adCampaignRunEndTimeMs
	v26.isAdCampaignCreatedToastVisible = v24.isAdCampaignCreatedToastVisible
	v26.onAdCampaignCreatedToastDismiss = v24.onAdCampaignCreatedToastDismiss
	v26.onAdUpsellCreate = v24.onAdUpsellCreate
	v26.onAdUpsellDismiss = v24.onAdUpsellDismiss
	v26.onAdUpsellImpression = v24.onAdUpsellImpression
	v26.onAdCampaignSheetClose = v24.onAdCampaignSheetClose
	v26.onAdCampaignSheetCreate = v24.onAdCampaignSheetCreate
	v26.isAgentAdCampaignSheetOpen = v25.isSheetOpen
	v26.isAgentAdCampaignCreatePending = v25.isCreatePending
	v26.hasAgentAdCampaignCreateError = v25.hasCreateError
	v26.agentAdCampaignCreateErrorKind = v25.createErrorKind
	v26.agentAdCampaignOffers = v25.campaignOffers
	v26.agentAdCampaignRunStartTimeMs = v25.runStartTimeMs
	v26.onAgentAdCampaignOfferSelected = v25.onOfferSelected
	v26.getAgentAdCampaignCardState = v25.getCardState
	local isAgentAdCampaignCreateDisabled

	if isAdUpsellCreateDisabled then
		isAgentAdCampaignCreateDisabled = v3.isCreateDisabled
	else
		isAgentAdCampaignCreateDisabled = v25.isCreateDisabled
	end

	v26.isAgentAdCampaignCreateDisabled = isAgentAdCampaignCreateDisabled

	v26.agentAdCampaignAttemptedOption = v25.attemptedOption

	if isAdUpsellCreateDisabled then
		v20 = nil
	end

	v26.onAgentAdCampaignActive = v20
	v26.onAgentAdCampaignSheetClose = v25.onSheetClose
	v26.onAgentAdCampaignSheetCreate = v25.onSheetCreate
	v26.isAdUpsellVisible = data.isFocused ~= false
	v26.isChatEmpty = isChatEmpty
	v26.isHistoryLoading = v13.isHistoryLoading or v8
	v26.isNewGameTarget = isNewGameTarget
	v26.hasPublishedTurn = v13.hasPublishedTurn
	v26.hasPublishedVersion = v5 ~= nil and v5.isActive
	v26.hasTaskGroups = hasTaskGroups
	v26.taskState = subagentTaskState
	v26.scrollingFrameRef = v13.setScrollingFrame
	v26.anchorScrollToInstance = v13.anchorScrollToInstance
	v26.onChatViewportChanged = onChatViewportChanged
	v26.isChatScrollable = state2
	v26.modelPicker = modelPicker
	v26.composerText = v13.composerText
	v26.composerErrorText = v13.composerErrorText
	v26.onComposerChanged = onComposerChanged
	v26.promptChips = promptChips
	v26.isPromptChipsLoading = isPromptChipsLoading
	v26.onPromptChipActivated = onPromptChipActivated
	v26.onPromptChipExhausted = onPromptChipExhausted
	v26.composerImages = v13.composerImages
	v26.onComposerImagesChanged = v13.setComposerImages
	v26.onRetryComposerImage = v13.retryComposerImage
	v26.composerResourceAttachments = v13.composerResourceAttachments
	v26.onRemoveComposerResourceAttachment = v13.removeComposerResourceAttachmentAtIndex
	v26.isComposerSendBlocked = v13.isComposerSendBlocked
	v26.textBoxRef = v13.textBoxRef
	v26.isAssistantResponding = v13.isAssistantResponding
	v26.canStopAssistantResponse = v13.canStopAssistantResponse
	v26.canSendWhileResponding = v13.canSendWhileResponding
	v26.isChatReadOnly = isChatReadOnly
	v26.chatPermissions = chatPermissions
	v26.onSend = v13.sendMessage
	v26.onStop = v13.stopAssistantResponse
	v26.statusChipGap = v4.Gap.Small
	v26.paddingBottom = v4.Padding.Small + keyboardOverlap
	return v26
end

return useBuildChatPageViewModel
