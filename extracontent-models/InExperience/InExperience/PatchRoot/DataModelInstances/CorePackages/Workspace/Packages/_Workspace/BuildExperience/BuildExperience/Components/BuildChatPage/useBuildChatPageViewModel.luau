local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local GuiService = game:GetService("GuiService")
local MessageBusService = game:GetService("MessageBusService")
local UserInputService = game:GetService("UserInputService")
local CreatorAgentChat = require(BuildExperienceParent.DataHydration.CreatorAgentChat)
local UniverseConfiguration = require(BuildExperienceParent.DataHydration.UniverseConfiguration)
local Foundation = require(BuildExperienceParent.Foundation)
local React = require(BuildExperienceParent.React)
local Signals = require(BuildExperienceParent.Signals)
local SignalsReact = require(BuildExperienceParent.SignalsReact)

require(BuildExperience.Chat.chatTypes)

local useChatPlaytestFooter = require(BuildExperience.Chat.useChatPlaytestFooter)
local useChatSessionCore = require(BuildExperience.Chat.useChatSessionCore)
local sendBuildExperienceEvent = require(BuildExperience.Telemetry.sendBuildExperienceEvent)
local GetBuildOverflowMenuStore = require(BuildExperience.Stores.GetBuildOverflowMenuStore)
local GetCreatorAgentResumeStore = require(BuildExperience.Stores.GetCreatorAgentResumeStore)

require(script.Parent.BuildChatPageView)

local useCreatorCreditChatUpsellViewModel = require(script.Parent.useCreatorCreditChatUpsellViewModel)
local EngineFeature = game:GetEngineFeature("BuildAppStorageKey")
local v19 = if not EngineFeature then nil else require(BuildExperience.Storage.BuildAppStorage)
local default = require(BuildExperienceParent.LinkingProtocol).LinkingProtocol.default
local PermissionsProtocol = require(BuildExperienceParent.PermissionsProtocol).PermissionsProtocol
local useTokens = Foundation.Hooks.useTokens
local MessageId = MessageBusService:GetMessageId("Realtime", "appResume")
local t1 = {
	allComplete = false,
	groups = {}
}

local function getKeyboardTop() -- line: 71
	-- upvalues: UserInputService (copy), GuiService (copy)
	if not UserInputService.OnScreenKeyboardVisible then
		return 0
	end

	local GuiInset = GuiService:GetGuiInset()

	return (math.max(0, UserInputService.OnScreenKeyboardPosition.Y - GuiInset.Y))
end
local function useUniverseSummary(n1: number?) -- line: 79
	-- upvalues: UniverseConfiguration (copy), React (copy), Signals (copy), SignalsReact (copy)
	local v31 = UniverseConfiguration.getUniverseConfigurationStore()
	local v32 = React.useMemo(function() -- line: 81
		-- upvalues: Signals (copy), n1 (copy), v31 (copy)
		return Signals.createComputed(function(p1) -- line: 82
			-- upvalues: n1 (copy), v31 (copy)
			if n1 == nil or n1 == 0 then
				return nil
			end

			return v31.getAndFetchSummary(n1).data(p1)
		end)
	end, {
		v31,
		n1
	})

	return SignalsReact.useSignalState(v32)
end
local function getHydratedExperienceName(s1: string, p2) -- line: 93
	local v35 = if p2 == nil then nil else p2.name

	if typeof(v35) == "string" and v35 ~= "" then
		return v35
	end

	return s1
end
local function useBuildChatPageViewModel(t2: {[any]: any}) -- line: 101
	-- upvalues: useTokens (copy), useUniverseSummary (copy), GetBuildOverflowMenuStore (copy), GetCreatorAgentResumeStore (copy), React (copy), EngineFeature (copy), v19 (copy), UserInputService (copy), GuiService (copy), PermissionsProtocol (copy), MessageBusService (copy), MessageId (copy), default (copy), CreatorAgentChat (copy), useChatSessionCore (copy), useChatPlaytestFooter (copy), UniverseConfiguration (copy), useCreatorCreditChatUpsellViewModel (copy), sendBuildExperienceEvent (copy), t1 (copy)
	local v37 = useTokens()
	local v38 = useUniverseSummary(t2.target.universeId)
	local v39 = GetBuildOverflowMenuStore()
	local v40 = GetCreatorAgentResumeStore()
	local v41, v42 = React.useState(nil)
	local v43, v44 = React.useState(false)
	local v45, v46 = React.useState(nil)
	local v47, v48 = React.useState(false)
	local v49, v50 = React.useState(false)
	local v51, v52 = React.useState(false)
	local v53, v54 = React.useState(function() -- line: 114
		-- upvalues: EngineFeature (copy), v19 (copy)
		return EngineFeature and v19.wasPushNotificationsUpsellShownToday()
	end)
	local v55, v56 = React.useState(false)
	local v57 = React.useRef(false)
	local useState = React.useState
	local n2

	if not UserInputService.OnScreenKeyboardVisible then
		n2 = 0
	else
		local GuiInset = GuiService:GetGuiInset()

		n2 = math.max(0, UserInputService.OnScreenKeyboardPosition.Y - GuiInset.Y)
	end

	local v61, v62 = useState(n2)
	local v63, v64 = React.useState(0)
	local v65 = React.useCallback(function() -- line: 124
		-- upvalues: PermissionsProtocol (copy), v57 (copy), v46 (copy), v52 (copy)
		return PermissionsProtocol.default:hasPermissions({ PermissionsProtocol.Permissions.POST_NOTIFICATIONS }):andThen(function(p3) -- line: 129
			-- upvalues: v57 (copy), v46 (copy), PermissionsProtocol (copy), v52 (copy)
			if v57.current then
				v46(p3.status)

				if p3.status == PermissionsProtocol.Status.AUTHORIZED then
					v52(false)
				end
			end
		end, function() -- line: 136
		end)
	end, {})

	React.useEffect(function() -- line: 141
		-- upvalues: v57 (copy), v65 (copy), MessageBusService (copy), MessageId (copy)
		v57.current = true
		v65()

		local v98 = MessageBusService:Subscribe(MessageId, v65, false, true)

		return function() -- line: 146
			-- upvalues: v57 (copy), v98 (copy)
			v57.current = false
			v98:Disconnect()
		end
	end, { v65 })

	local v66 = React.useCallback(function() -- line: 152
		-- upvalues: v49 (copy), v50 (copy), PermissionsProtocol (copy), v57 (copy), v46 (copy), v52 (copy)
		if v49 then
			return
		end

		v50(true)
		PermissionsProtocol.default:requestPermissions({ PermissionsProtocol.Permissions.POST_NOTIFICATIONS }):andThen(function(p4) -- line: 162
			-- upvalues: v57 (copy), v46 (copy), PermissionsProtocol (copy), v52 (copy), v50 (copy)
			if not v57.current then
				return
			end

			v46(p4.status)

			if p4.status == PermissionsProtocol.Status.DENIED then
				v52(true)
			end

			v50(false)
		end, function() -- line: 171
			-- upvalues: v57 (copy), v50 (copy)
			if v57.current then
				v50(false)
			end
		end)
	end, { v49 })
	local v67 = React.useCallback(function() -- line: 178
		-- upvalues: default (copy)
		default:switchToSettingsApp():catch(function() -- line: 179
		end)
	end, {})
	local v68 = React.useCallback(function() -- line: 182
		-- upvalues: v48 (copy)
		v48(true)
	end, {})
	local v69 = React.useCallback(function() -- line: 186
		-- upvalues: v62 (copy), UserInputService (copy), GuiService (copy)
		local v99 = v62
		local n3

		if not UserInputService.OnScreenKeyboardVisible then
			n3 = 0
		else
			local GuiInset = GuiService:GetGuiInset()

			n3 = math.max(0, UserInputService.OnScreenKeyboardPosition.Y - GuiInset.Y)
		end

		v99(n3)
	end, {})

	React.useEffect(function() -- line: 190
		-- upvalues: v69 (copy), UserInputService (copy)
		v69()

		local connection = UserInputService:GetPropertyChangedSignal("OnScreenKeyboardVisible"):Connect(v69)
		local connection2 = UserInputService:GetPropertyChangedSignal("OnScreenKeyboardSize"):Connect(v69)
		local connection3 = UserInputService:GetPropertyChangedSignal("OnScreenKeyboardPosition"):Connect(v69)

		return function() -- line: 198
			-- upvalues: connection (copy), connection2 (copy), connection3 (copy)
			connection:Disconnect()
			connection2:Disconnect()
			connection3:Disconnect()
		end
	end, { v69 })

	local v70 = React.useCallback(function(p5) -- line: 205
		-- upvalues: v64 (copy)
		v64(p5.AbsolutePosition.Y + p5.AbsoluteSize.Y)
	end, {})
	local v71 = React.useCallback(function(p6) -- line: 209
		-- upvalues: v44 (copy)
		local AbsoluteWindowSizeY = p6.AbsoluteWindowSize.Y

		v44(AbsoluteWindowSizeY > 0 and AbsoluteWindowSizeY < p6.AbsoluteCanvasSize.Y)
	end, {})
	local v72 = if not (v61 <= 0) and not (v63 <= 0) then math.max(0, v63 - v61) else 0
	local v73 = t2.target.isNewGameTarget == true
	local v74 = React.useMemo(function() -- line: 217
		-- upvalues: t2 (copy), v38 (copy)
		local t3 = {
			universeId = t2.target.universeId,
			placeId = t2.target.placeId,
			sessionId = t2.target.sessionId
		}
		local experienceName = t2.target.experienceName
		local v110 = v38
		local v111 = if v110 == nil then nil else v110.name

		t3.experienceName = if typeof(v111) ~= "string" or v111 == "" then experienceName else v111
		t3.isNewGameTarget = t2.target.isNewGameTarget
		t3.creatorName = t2.target.creatorName
		t3.gameIcon = t2.target.gameIcon

		return t3
	end, {
		t2.target.universeId,
		t2.target.placeId,
		t2.target.sessionId,
		t2.target.experienceName,
		t2.target.isNewGameTarget,
		t2.target.creatorName,
		t2.target.gameIcon,
		v38
	})
	local v75 = React.useCallback(function(t4: {[any]: any}) -- line: 240
		-- upvalues: t2 (copy), v74 (copy)
		if t2.onNavigateToResolvedTarget ~= nil then
			t2.onNavigateToResolvedTarget({
				universeId = t4.universeId,
				placeId = t4.placeId,
				sessionId = t4.sessionId,
				experienceName = v74.experienceName,
				isNewGameTarget = v74.isNewGameTarget,
				creatorName = v74.creatorName,
				gameIcon = v74.gameIcon
			})
		end
	end, {
		t2.onNavigateToResolvedTarget,
		v74.experienceName,
		v74.isNewGameTarget,
		v74.creatorName,
		v74.gameIcon
	})
	local v76, v77 = React.useState({
		count = 0,
		reason = nil
	})
	local v78 = React.useCallback(function(n4: number?, p7) -- line: 266
		-- upvalues: CreatorAgentChat (copy), v77 (copy)
		if n4 == CreatorAgentChat.ErrorCodes.OutOfCredits then
			v77(function(p8) -- line: 268
				-- upvalues: p7 (copy)
				return {
					count = p8.count + 1,
					reason = p7
				}
			end)
		end
	end, {})
	local v79 = useChatSessionCore({
		autoFocusComposer = false,
		universeId = t2.target.universeId,
		placeId = t2.target.placeId,
		sessionId = t2.target.sessionId,
		createUniverseOnFirstPrompt = v73,
		onProjectResolved = v75,
		onPromptFailure = v78
	})
	local v80 = useChatPlaytestFooter(v79, "BuildChatPlaytestCta")
	local subagentTaskState = v79.subagentTaskState
	local v82 = subagentTaskState ~= nil and #subagentTaskState.groups > 0
	local v83 = #v79.messages == 0
	local u84 = false

	for _, v86 in v79.messages do
		if v86.kind == "user_message" then
			u84 = true

			break
		end
	end

	local v87 = v45 == PermissionsProtocol.Status.DENIED and (not v47 and (not v53 or v55))
	local v88 = React.useRef(false)

	React.useEffect(function() -- line: 304
		-- upvalues: EngineFeature (copy), v87 (copy), u84 (ref), v79 (copy), v55 (copy), v56 (copy), v54 (copy), v19 (copy)
		if not EngineFeature then
			return function() -- line: 306
			end
		end

		local v115 = v87 and (u84 and v79.isAssistantResponding)

		if v115 and not v55 then
			v56(true)
			v54(true)
			v19.markPushNotificationsUpsellShown()
		elseif not v115 and v55 then
			v56(false)
		end

		return function() -- line: 320
		end
	end, {
		v87,
		u84,
		v79.isAssistantResponding,
		v53,
		v55
	})
	React.useEffect(function() -- line: 331
		-- upvalues: t2 (copy), v88 (copy), v79 (copy), UniverseConfiguration (copy)
		local universeId = t2.target.universeId
		local v117 = v88.current and not v79.isAssistantResponding

		v88.current = v79.isAssistantResponding

		if not v117 or (universeId == nil or universeId == 0) then
			return function() -- line: 337
			end
		end

		local v118 = UniverseConfiguration.getUniverseConfigurationStore()

		if v118.getSummary(universeId).data(false) ~= nil then
			v118.fetchSummary(universeId)
		end

		return function() -- line: 344
		end
	end, {
		t2.target.universeId,
		v79.isAssistantResponding
	})
	React.useEffect(function() -- line: 347
		-- upvalues: v40 (copy), t2 (copy)
		v40.setActiveTarget({
			universeId = t2.target.universeId,
			sessionId = t2.target.sessionId
		})

		return function() -- line: 352
			-- upvalues: v40 (copy)
			v40.setActiveTarget(nil)
		end
	end, {
		v40,
		t2.target.universeId,
		t2.target.sessionId
	})

	local v89 = React.useCallback(function() -- line: 357
		-- upvalues: v79 (copy)
		if v79.textBoxRef.current then
			v79.textBoxRef.current.releaseFocus()
		end
	end, { v79.textBoxRef })
	local v90 = React.useCallback(function() -- line: 363
		-- upvalues: v89 (copy), t2 (copy)
		v89()

		if t2.onOpenCreatorCreditPage ~= nil then
			t2.onOpenCreatorCreditPage()
		end
	end, {
		v89,
		t2.onOpenCreatorCreditPage
	})
	local v91 = if t2.onOpenCreatorCreditPage == nil then nil else v90
	local v92 = useCreatorCreditChatUpsellViewModel({
		onOpenCreatorCreditPage = v91,
		outOfCreditsPromptFailureCount = v76.count,
		outOfCreditsPromptFailureReason = v76.reason,
		isAssistantResponding = v79.isAssistantResponding
	})
	local v93 = React.useCallback(function() -- line: 378
		-- upvalues: v89 (copy), t2 (copy)
		v89()
		t2.onClose()
	end, {
		v89,
		t2.onClose
	})
	local v94 = React.useCallback(function(p9) -- line: 383
		-- upvalues: v89 (copy), t2 (copy)
		if p9.type == "openPage" then
			v89()

			if t2.onOpenConfigurationPage then
				t2.onOpenConfigurationPage(p9.page)

				return
			end
		elseif p9.type == "openInvitePicker" then
			v89()

			if t2.onOpenInvitePicker then
				t2.onOpenInvitePicker()
			end
		end
	end, {
		v89,
		t2.onOpenConfigurationPage,
		t2.onOpenInvitePicker
	})
	local v95 = React.useCallback(function() -- line: 397
		-- upvalues: sendBuildExperienceEvent (copy), t2 (copy), v79 (copy)
		sendBuildExperienceEvent("PLAY_CLICK", {
			universeId = t2.target.universeId,
			placeId = v79.playtestPlaceId
		})

		if v79.launchPlaytest then
			v79.launchPlaytest("BuildChatPage")
		end
	end, {
		v79.launchPlaytest,
		v79.playtestPlaceId,
		t2.target.universeId
	})
	local v96 = React.useCallback(function() -- line: 407
		-- upvalues: v89 (copy), t2 (copy), subagentTaskState (copy), t1 (copy)
		v89()
		t2.onOpenAgentsPage(subagentTaskState or t1)
	end, {
		v89,
		t2.onOpenAgentsPage,
		subagentTaskState
	})
	local v97 = React.useCallback(function(s2: string) -- line: 412
		-- upvalues: v89 (copy), v42 (copy)
		v89()
		v42(s2)
	end, { v89 })

	return {
		target = v74,
		keyboardOverlap = v72,
		onPageMetricsChanged = v70,
		selectedChipGroupName = v41,
		onChipActivated = v97,
		onChipBottomSheetClose = function() -- line: 423
			-- upvalues: v42 (copy)
			v42(nil)
		end,
		onClose = v93,
		onOverflowMenuAction = v94,
		onPlayActivated = v95,
		onOpenAgentsPage = v96,
		onOpenCreatorCreditPage = v91,
		buildOverflowMenuStore = v39,
		messages = v79.messages,
		localToolActions = v79.localToolActions,
		clockBinding = v79.clockBinding,
		onPlaytest = v80.onPlaytest,
		isPlaytestLoading = v80.isPlaytestLoading,
		showPushNotificationsUpsell = if not EngineFeature then v87 else v55 and v87,
		isPushNotificationsRequestPending = v49,
		shouldOpenPushNotificationsSettings = v51,
		onNotifyMe = v66,
		onOpenPushNotificationsSettings = v67,
		onNotNow = v68,
		showBuyMoreRobuxCard = v92.showBuyMoreRobuxCard,
		buyMoreRobuxCardTitle = v92.buyMoreRobuxCardTitle,
		buyMoreRobuxCardDescription = v92.buyMoreRobuxCardDescription,
		buyMoreRobuxCardPrimaryActionText = v92.buyMoreRobuxCardPrimaryActionText,
		onBuyMoreRobuxCardPrimaryAction = v92.onBuyMoreRobuxCardPrimaryAction,
		buyMoreRobuxCardSecondaryActionText = v92.buyMoreRobuxCardSecondaryActionText,
		onBuyMoreRobuxCardSecondaryAction = v92.onBuyMoreRobuxCardSecondaryAction,
		isChatEmpty = v83,
		isNewGameTarget = v73,
		hasPublishedTurn = v79.hasPublishedTurn,
		hasPublishedVersion = v38 ~= nil and v38.isActive,
		hasTaskGroups = v82,
		taskState = subagentTaskState,
		scrollingFrameRef = v79.setScrollingFrame,
		onChatViewportChanged = v71,
		isChatScrollable = v43,
		composerText = v79.composerText,
		composerErrorText = v79.composerErrorText,
		onComposerChanged = v79.setComposerText,
		textBoxRef = v79.textBoxRef,
		isAssistantResponding = v79.isAssistantResponding,
		canStopAssistantResponse = v79.canStopAssistantResponse,
		canSendWhileResponding = v79.canSendWhileResponding,
		onSend = v79.sendMessage,
		onStop = v79.stopAssistantResponse,
		statusChipGap = v37.Gap.Small,
		paddingBottom = v37.Padding.Small + v72
	}
end

return useBuildChatPageViewModel
