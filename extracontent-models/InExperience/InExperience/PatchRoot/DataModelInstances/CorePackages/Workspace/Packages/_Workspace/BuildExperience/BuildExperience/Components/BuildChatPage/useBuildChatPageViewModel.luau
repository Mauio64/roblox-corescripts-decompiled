local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local GuiService = game:GetService("GuiService")
local MessageBusService = game:GetService("MessageBusService")
local UserInputService = game:GetService("UserInputService")

require(BuildExperienceParent.DataHydration.CreatorAgentChat)

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

local default = require(BuildExperienceParent.LinkingProtocol).LinkingProtocol.default
local PermissionsProtocol = require(BuildExperienceParent.PermissionsProtocol).PermissionsProtocol
local useTokens = Foundation.Hooks.useTokens
local MessageId = MessageBusService:GetMessageId("Realtime", "appResume")
local t1 = {
	allComplete = false,
	groups = {}
}

local function getKeyboardTop() -- line: 55
	-- upvalues: UserInputService (copy), GuiService (copy)
	if not UserInputService.OnScreenKeyboardVisible then
		return 0
	end

	local GuiInset = GuiService:GetGuiInset()

	return (math.max(0, UserInputService.OnScreenKeyboardPosition.Y - GuiInset.Y))
end
local function useUniverseSummary(n1: number?) -- line: 63
	-- upvalues: UniverseConfiguration (copy), React (copy), Signals (copy), SignalsReact (copy)
	local v27 = UniverseConfiguration.getUniverseConfigurationStore()
	local v28 = React.useMemo(function() -- line: 65
		-- upvalues: Signals (copy), n1 (copy), v27 (copy)
		return Signals.createComputed(function(p1) -- line: 66
			-- upvalues: n1 (copy), v27 (copy)
			if n1 == nil or n1 == 0 then
				return nil
			end

			return v27.getAndFetchSummary(n1).data(p1)
		end)
	end, {
		v27,
		n1
	})

	return SignalsReact.useSignalState(v28)
end
local function getHydratedExperienceName(s1: string, p2) -- line: 77
	local v31 = if p2 == nil then nil else p2.name

	if typeof(v31) == "string" and v31 ~= "" then
		return v31
	end

	return s1
end
local function useBuildChatPageViewModel(t2: {[any]: any}) -- line: 85
	-- upvalues: useTokens (copy), useUniverseSummary (copy), GetBuildOverflowMenuStore (copy), GetCreatorAgentResumeStore (copy), React (copy), UserInputService (copy), GuiService (copy), PermissionsProtocol (copy), MessageBusService (copy), MessageId (copy), default (copy), useChatSessionCore (copy), useChatPlaytestFooter (copy), UniverseConfiguration (copy), sendBuildExperienceEvent (copy), t1 (copy)
	local v33 = useTokens()
	local v34 = useUniverseSummary(t2.target.universeId)
	local v35 = GetBuildOverflowMenuStore()
	local v36 = GetCreatorAgentResumeStore()
	local v37, v38 = React.useState(nil)
	local v39, v40 = React.useState(false)
	local v41, v42 = React.useState(nil)
	local v43, v44 = React.useState(false)
	local v45, v46 = React.useState(false)
	local v47, v48 = React.useState(false)
	local v49 = React.useRef(false)
	local useState = React.useState
	local n2

	if not UserInputService.OnScreenKeyboardVisible then
		n2 = 0
	else
		local GuiInset = GuiService:GetGuiInset()

		n2 = math.max(0, UserInputService.OnScreenKeyboardPosition.Y - GuiInset.Y)
	end

	local v53, v54 = useState(n2)
	local v55, v56 = React.useState(0)
	local v57 = React.useCallback(function() -- line: 102
		-- upvalues: PermissionsProtocol (copy), v49 (copy), v42 (copy), v48 (copy)
		return PermissionsProtocol.default:hasPermissions({ PermissionsProtocol.Permissions.POST_NOTIFICATIONS }):andThen(function(p3) -- line: 107
			-- upvalues: v49 (copy), v42 (copy), PermissionsProtocol (copy), v48 (copy)
			if v49.current then
				v42(p3.status)

				if p3.status == PermissionsProtocol.Status.AUTHORIZED then
					v48(false)
				end
			end
		end, function() -- line: 114
		end)
	end, {})

	React.useEffect(function() -- line: 119
		-- upvalues: v49 (copy), v57 (copy), MessageBusService (copy), MessageId (copy)
		v49.current = true
		v57()

		local v80 = MessageBusService:Subscribe(MessageId, v57, false, true)

		return function() -- line: 124
			-- upvalues: v49 (copy), v80 (copy)
			v49.current = false
			v80:Disconnect()
		end
	end, { v57 })

	local v58 = React.useCallback(function() -- line: 130
		-- upvalues: v45 (copy), v46 (copy), PermissionsProtocol (copy), v49 (copy), v42 (copy), v48 (copy)
		if v45 then
			return
		end

		v46(true)
		PermissionsProtocol.default:requestPermissions({ PermissionsProtocol.Permissions.POST_NOTIFICATIONS }):andThen(function(p4) -- line: 140
			-- upvalues: v49 (copy), v42 (copy), PermissionsProtocol (copy), v48 (copy), v46 (copy)
			if not v49.current then
				return
			end

			v42(p4.status)

			if p4.status == PermissionsProtocol.Status.DENIED then
				v48(true)
			end

			v46(false)
		end, function() -- line: 149
			-- upvalues: v49 (copy), v46 (copy)
			if v49.current then
				v46(false)
			end
		end)
	end, { v45 })
	local v59 = React.useCallback(function() -- line: 156
		-- upvalues: default (copy)
		default:switchToSettingsApp():catch(function() -- line: 157
		end)
	end, {})
	local v60 = React.useCallback(function() -- line: 160
		-- upvalues: v44 (copy)
		v44(true)
	end, {})
	local v61 = React.useCallback(function() -- line: 164
		-- upvalues: v54 (copy), UserInputService (copy), GuiService (copy)
		local v81 = v54
		local n3

		if not UserInputService.OnScreenKeyboardVisible then
			n3 = 0
		else
			local GuiInset = GuiService:GetGuiInset()

			n3 = math.max(0, UserInputService.OnScreenKeyboardPosition.Y - GuiInset.Y)
		end

		v81(n3)
	end, {})

	React.useEffect(function() -- line: 168
		-- upvalues: v61 (copy), UserInputService (copy)
		v61()

		local connection = UserInputService:GetPropertyChangedSignal("OnScreenKeyboardVisible"):Connect(v61)
		local connection2 = UserInputService:GetPropertyChangedSignal("OnScreenKeyboardSize"):Connect(v61)
		local connection3 = UserInputService:GetPropertyChangedSignal("OnScreenKeyboardPosition"):Connect(v61)

		return function() -- line: 176
			-- upvalues: connection (copy), connection2 (copy), connection3 (copy)
			connection:Disconnect()
			connection2:Disconnect()
			connection3:Disconnect()
		end
	end, { v61 })

	local v62 = React.useCallback(function(p5) -- line: 183
		-- upvalues: v56 (copy)
		v56(p5.AbsolutePosition.Y + p5.AbsoluteSize.Y)
	end, {})
	local v63 = React.useCallback(function(p6) -- line: 187
		-- upvalues: v40 (copy)
		local AbsoluteWindowSizeY = p6.AbsoluteWindowSize.Y

		v40(AbsoluteWindowSizeY > 0 and AbsoluteWindowSizeY < p6.AbsoluteCanvasSize.Y)
	end, {})
	local v64 = if not (v53 <= 0) and not (v55 <= 0) then math.max(0, v55 - v53) else 0
	local v65 = t2.target.isNewGameTarget == true
	local v66 = React.useMemo(function() -- line: 195
		-- upvalues: t2 (copy), v34 (copy)
		local t3 = {
			universeId = t2.target.universeId,
			placeId = t2.target.placeId,
			sessionId = t2.target.sessionId
		}
		local experienceName = t2.target.experienceName
		local v92 = v34
		local v93 = if v92 == nil then nil else v92.name

		t3.experienceName = if typeof(v93) ~= "string" or v93 == "" then experienceName else v93
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
		v34
	})
	local v67 = React.useCallback(function(t4: {[any]: any}) -- line: 218
		-- upvalues: t2 (copy), v66 (copy)
		if t2.onNavigateToResolvedTarget ~= nil then
			t2.onNavigateToResolvedTarget({
				universeId = t4.universeId,
				placeId = t4.placeId,
				sessionId = t4.sessionId,
				experienceName = v66.experienceName,
				isNewGameTarget = v66.isNewGameTarget,
				creatorName = v66.creatorName,
				gameIcon = v66.gameIcon
			})
		end
	end, {
		t2.onNavigateToResolvedTarget,
		v66.experienceName,
		v66.isNewGameTarget,
		v66.creatorName,
		v66.gameIcon
	})
	local v68 = useChatSessionCore({
		autoFocusComposer = false,
		universeId = t2.target.universeId,
		placeId = t2.target.placeId,
		sessionId = t2.target.sessionId,
		createUniverseOnFirstPrompt = v65,
		onProjectResolved = v67
	})
	local v69 = useChatPlaytestFooter(v68, "BuildChatPlaytestCta")
	local subagentTaskState = v68.subagentTaskState
	local v71 = subagentTaskState ~= nil and #subagentTaskState.groups > 0
	local v72 = #v68.messages == 0
	local v73 = React.useRef(false)

	React.useEffect(function() -- line: 254
		-- upvalues: t2 (copy), v73 (copy), v68 (copy), UniverseConfiguration (copy)
		local universeId = t2.target.universeId
		local v96 = v73.current and not v68.isAssistantResponding

		v73.current = v68.isAssistantResponding

		if not v96 or (universeId == nil or universeId == 0) then
			return function() -- line: 260
			end
		end

		local v97 = UniverseConfiguration.getUniverseConfigurationStore()

		if v97.getSummary(universeId).data(false) ~= nil then
			v97.fetchSummary(universeId)
		end

		return function() -- line: 267
		end
	end, {
		t2.target.universeId,
		v68.isAssistantResponding
	})
	React.useEffect(function() -- line: 270
		-- upvalues: v36 (copy), t2 (copy)
		v36.setActiveTarget({
			universeId = t2.target.universeId,
			sessionId = t2.target.sessionId
		})

		return function() -- line: 275
			-- upvalues: v36 (copy)
			v36.setActiveTarget(nil)
		end
	end, {
		v36,
		t2.target.universeId,
		t2.target.sessionId
	})

	local v74 = React.useCallback(function() -- line: 280
		-- upvalues: v68 (copy)
		if v68.textBoxRef.current then
			v68.textBoxRef.current.releaseFocus()
		end
	end, { v68.textBoxRef })
	local v75 = React.useCallback(function() -- line: 286
		-- upvalues: v74 (copy), t2 (copy)
		v74()
		t2.onClose()
	end, {
		v74,
		t2.onClose
	})
	local v76 = React.useCallback(function(p7) -- line: 291
		-- upvalues: v74 (copy), t2 (copy)
		if p7.type == "openPage" then
			v74()

			if t2.onOpenConfigurationPage then
				t2.onOpenConfigurationPage(p7.page)
			end
		end
	end, {
		v74,
		t2.onOpenConfigurationPage
	})
	local v77 = React.useCallback(function() -- line: 300
		-- upvalues: sendBuildExperienceEvent (copy), t2 (copy), v68 (copy)
		sendBuildExperienceEvent("PLAY_CLICK", {
			universeId = t2.target.universeId,
			placeId = v68.playtestPlaceId
		})

		if v68.launchPlaytest then
			v68.launchPlaytest("BuildChatPage")
		end
	end, {
		v68.launchPlaytest,
		v68.playtestPlaceId,
		t2.target.universeId
	})
	local v78 = React.useCallback(function() -- line: 310
		-- upvalues: v74 (copy), t2 (copy), subagentTaskState (copy), t1 (copy)
		v74()
		t2.onOpenAgentsPage(subagentTaskState or t1)
	end, {
		v74,
		t2.onOpenAgentsPage,
		subagentTaskState
	})
	local v79 = React.useCallback(function(s2: string) -- line: 315
		-- upvalues: v74 (copy), v38 (copy)
		v74()
		v38(s2)
	end, { v74 })

	return {
		target = v66,
		keyboardOverlap = v64,
		onPageMetricsChanged = v62,
		selectedChipGroupName = v37,
		onChipActivated = v79,
		onChipBottomSheetClose = function() -- line: 326
			-- upvalues: v38 (copy)
			v38(nil)
		end,
		onClose = v75,
		onOverflowMenuAction = v76,
		onPlayActivated = v77,
		onOpenAgentsPage = v78,
		buildOverflowMenuStore = v35,
		messages = v68.messages,
		localToolActions = v68.localToolActions,
		clockBinding = v68.clockBinding,
		onPlaytest = v69.onPlaytest,
		isPlaytestLoading = v69.isPlaytestLoading,
		showPushNotificationsUpsell = v41 == PermissionsProtocol.Status.DENIED and not v43,
		isPushNotificationsRequestPending = v45,
		shouldOpenPushNotificationsSettings = v47,
		onNotifyMe = v58,
		onOpenPushNotificationsSettings = v59,
		onNotNow = v60,
		isChatEmpty = v72,
		isNewGameTarget = v65,
		hasPublishedTurn = v68.hasPublishedTurn,
		hasPublishedVersion = v34 ~= nil and v34.isActive,
		hasTaskGroups = v71,
		taskState = subagentTaskState,
		scrollingFrameRef = v68.setScrollingFrame,
		onChatViewportChanged = v63,
		isChatScrollable = v39,
		composerText = v68.composerText,
		composerErrorText = v68.composerErrorText,
		onComposerChanged = v68.setComposerText,
		textBoxRef = v68.textBoxRef,
		isAssistantResponding = v68.isAssistantResponding,
		canStopAssistantResponse = v68.canStopAssistantResponse,
		onSend = v68.sendMessage,
		onStop = v68.stopAssistantResponse,
		statusChipGap = v33.Gap.Small,
		paddingBottom = v33.Padding.Small + v64
	}
end

return useBuildChatPageViewModel
