local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local GuiService = game:GetService("GuiService")
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

local useTokens = Foundation.Hooks.useTokens

local function getKeyboardTop() -- line: 45
	-- upvalues: UserInputService (copy), GuiService (copy)
	if not UserInputService.OnScreenKeyboardVisible then
		return 0
	end

	local GuiInset = GuiService:GetGuiInset()

	return (math.max(0, UserInputService.OnScreenKeyboardPosition.Y - GuiInset.Y))
end
local function useUniverseSummary(n1: number?) -- line: 53
	-- upvalues: UniverseConfiguration (copy), React (copy), Signals (copy), SignalsReact (copy)
	local v22 = UniverseConfiguration.getUniverseConfigurationStore()
	local v23 = React.useMemo(function() -- line: 55
		-- upvalues: Signals (copy), n1 (copy), v22 (copy)
		return Signals.createComputed(function(p1) -- line: 56
			-- upvalues: n1 (copy), v22 (copy)
			if n1 == nil or n1 == 0 then
				return nil
			end

			return v22.getAndFetchSummary(n1).data(p1)
		end)
	end, {
		v22,
		n1
	})

	return SignalsReact.useSignalState(v23)
end
local function getHydratedExperienceName(s1: string, p2) -- line: 67
	local v26 = if p2 == nil then nil else p2.name

	if typeof(v26) == "string" and v26 ~= "" then
		return v26
	end

	return s1
end
local function useBuildChatPageViewModel(t1: {[any]: any}) -- line: 75
	-- upvalues: useTokens (copy), useUniverseSummary (copy), GetBuildOverflowMenuStore (copy), GetCreatorAgentResumeStore (copy), React (copy), UserInputService (copy), GuiService (copy), useChatSessionCore (copy), useChatPlaytestFooter (copy), UniverseConfiguration (copy), sendBuildExperienceEvent (copy)
	local v28 = useTokens()
	local v29 = useUniverseSummary(t1.target.universeId)
	local v30 = GetBuildOverflowMenuStore()
	local v31 = GetCreatorAgentResumeStore()
	local v32, v33 = React.useState(nil)
	local useState = React.useState
	local n2

	if not UserInputService.OnScreenKeyboardVisible then
		n2 = 0
	else
		local GuiInset = GuiService:GetGuiInset()

		n2 = math.max(0, UserInputService.OnScreenKeyboardPosition.Y - GuiInset.Y)
	end

	local v37, v38 = useState(n2)
	local v39, v40 = React.useState(0)
	local v41 = React.useCallback(function() -- line: 85
		-- upvalues: v38 (copy), UserInputService (copy), GuiService (copy)
		local v59 = v38
		local n3

		if not UserInputService.OnScreenKeyboardVisible then
			n3 = 0
		else
			local GuiInset = GuiService:GetGuiInset()

			n3 = math.max(0, UserInputService.OnScreenKeyboardPosition.Y - GuiInset.Y)
		end

		v59(n3)
	end, {})

	React.useEffect(function() -- line: 89
		-- upvalues: v41 (copy), UserInputService (copy)
		v41()

		local connection = UserInputService:GetPropertyChangedSignal("OnScreenKeyboardVisible"):Connect(v41)
		local connection2 = UserInputService:GetPropertyChangedSignal("OnScreenKeyboardSize"):Connect(v41)
		local connection3 = UserInputService:GetPropertyChangedSignal("OnScreenKeyboardPosition"):Connect(v41)

		return function() -- line: 97
			-- upvalues: connection (copy), connection2 (copy), connection3 (copy)
			connection:Disconnect()
			connection2:Disconnect()
			connection3:Disconnect()
		end
	end, { v41 })

	local v42 = React.useCallback(function(p3) -- line: 104
		-- upvalues: v40 (copy)
		v40(p3.AbsolutePosition.Y + p3.AbsoluteSize.Y)
	end, {})
	local v43 = if not (v37 <= 0) and not (v39 <= 0) then math.max(0, v39 - v37) else 0
	local v44 = t1.target.isNewGameTarget == true
	local v45 = React.useMemo(function() -- line: 111
		-- upvalues: t1 (copy), v29 (copy)
		local t2 = {
			universeId = t1.target.universeId,
			placeId = t1.target.placeId,
			sessionId = t1.target.sessionId
		}
		local experienceName = t1.target.experienceName
		local v68 = v29
		local v69 = if v68 == nil then nil else v68.name

		t2.experienceName = if typeof(v69) ~= "string" or v69 == "" then experienceName else v69
		t2.isNewGameTarget = t1.target.isNewGameTarget
		t2.creatorName = t1.target.creatorName
		t2.gameIcon = t1.target.gameIcon

		return t2
	end, {
		t1.target.universeId,
		t1.target.placeId,
		t1.target.sessionId,
		t1.target.experienceName,
		t1.target.isNewGameTarget,
		t1.target.creatorName,
		t1.target.gameIcon,
		v29
	})
	local v46 = React.useCallback(function(t3: {[any]: any}) -- line: 134
		-- upvalues: t1 (copy), v45 (copy)
		if t1.onNavigateToResolvedTarget ~= nil then
			t1.onNavigateToResolvedTarget({
				universeId = t3.universeId,
				placeId = t3.placeId,
				sessionId = t3.sessionId,
				experienceName = v45.experienceName,
				isNewGameTarget = v45.isNewGameTarget,
				creatorName = v45.creatorName,
				gameIcon = v45.gameIcon
			})
		end
	end, {
		t1.onNavigateToResolvedTarget,
		v45.experienceName,
		v45.isNewGameTarget,
		v45.creatorName,
		v45.gameIcon
	})
	local v47 = useChatSessionCore({
		autoFocusComposer = false,
		universeId = t1.target.universeId,
		placeId = t1.target.placeId,
		sessionId = t1.target.sessionId,
		createUniverseOnFirstPrompt = v44,
		onProjectResolved = v46
	})
	local v48 = useChatPlaytestFooter(v47, "BuildChatPlaytestCta")
	local subagentTaskState = v47.subagentTaskState
	local v50 = subagentTaskState ~= nil and #subagentTaskState.groups > 0
	local v51 = #v47.messages == 0
	local v52 = React.useRef(false)

	React.useEffect(function() -- line: 170
		-- upvalues: t1 (copy), v52 (copy), v47 (copy), UniverseConfiguration (copy)
		local universeId = t1.target.universeId
		local v72 = v52.current and not v47.isAssistantResponding

		v52.current = v47.isAssistantResponding

		if not v72 or (universeId == nil or universeId == 0) then
			return function() -- line: 176
			end
		end

		local v73 = UniverseConfiguration.getUniverseConfigurationStore()

		if v73.getSummary(universeId).data(false) ~= nil then
			v73.fetchSummary(universeId)
		end

		return function() -- line: 183
		end
	end, {
		t1.target.universeId,
		v47.isAssistantResponding
	})
	React.useEffect(function() -- line: 186
		-- upvalues: v31 (copy), t1 (copy)
		v31.setActiveTarget({
			universeId = t1.target.universeId,
			sessionId = t1.target.sessionId
		})

		return function() -- line: 191
			-- upvalues: v31 (copy)
			v31.setActiveTarget(nil)
		end
	end, {
		v31,
		t1.target.universeId,
		t1.target.sessionId
	})

	local v53 = React.useCallback(function() -- line: 196
		-- upvalues: v47 (copy)
		if v47.textBoxRef.current then
			v47.textBoxRef.current.releaseFocus()
		end
	end, { v47.textBoxRef })
	local v54 = React.useCallback(function() -- line: 202
		-- upvalues: v53 (copy), t1 (copy)
		v53()
		t1.onClose()
	end, {
		v53,
		t1.onClose
	})
	local v55 = React.useCallback(function(p4) -- line: 207
		-- upvalues: v53 (copy), t1 (copy)
		if p4.type == "openPage" then
			v53()

			if t1.onOpenConfigurationPage then
				t1.onOpenConfigurationPage(p4.page)
			end
		end
	end, {
		v53,
		t1.onOpenConfigurationPage
	})
	local v56 = React.useCallback(function() -- line: 216
		-- upvalues: sendBuildExperienceEvent (copy), t1 (copy), v47 (copy)
		sendBuildExperienceEvent("PLAY_CLICK", {
			universeId = t1.target.universeId,
			placeId = v47.playtestPlaceId
		})

		if v47.launchPlaytest then
			v47.launchPlaytest("BuildChatPage")
		end
	end, {
		v47.launchPlaytest,
		v47.playtestPlaceId,
		t1.target.universeId
	})
	local v57 = React.useCallback(function() -- line: 226
		-- upvalues: subagentTaskState (copy), v53 (copy), t1 (copy)
		if subagentTaskState == nil then
			return
		end

		v53()
		t1.onOpenAgentsPage(subagentTaskState)
	end, {
		v53,
		t1.onOpenAgentsPage,
		subagentTaskState
	})
	local v58 = React.useCallback(function(s2: string) -- line: 234
		-- upvalues: v53 (copy), v33 (copy)
		v53()
		v33(s2)
	end, { v53 })

	return {
		target = v45,
		keyboardOverlap = v43,
		onPageMetricsChanged = v42,
		selectedChipGroupName = v32,
		onChipActivated = v58,
		onChipBottomSheetClose = function() -- line: 245
			-- upvalues: v33 (copy)
			v33(nil)
		end,
		onClose = v54,
		onOverflowMenuAction = v55,
		onPlayActivated = v56,
		onOpenAgentsPage = v57,
		buildOverflowMenuStore = v30,
		messages = v47.messages,
		localToolActions = v47.localToolActions,
		clockBinding = v47.clockBinding,
		onPlaytest = v48.onPlaytest,
		isPlaytestLoading = v48.isPlaytestLoading,
		isChatEmpty = v51,
		isNewGameTarget = v44,
		hasPublishedTurn = v47.hasPublishedTurn,
		hasTaskGroups = v50,
		taskState = subagentTaskState,
		scrollingFrameRef = v47.setScrollingFrame,
		composerText = v47.composerText,
		composerErrorText = v47.composerErrorText,
		onComposerChanged = v47.setComposerText,
		textBoxRef = v47.textBoxRef,
		isAssistantResponding = v47.isAssistantResponding,
		canStopAssistantResponse = v47.canStopAssistantResponse,
		onSend = v47.sendMessage,
		onStop = v47.stopAssistantResponse,
		statusChipGap = v28.Gap.Small,
		paddingBottom = v28.Padding.Small + v43
	}
end

return useBuildChatPageViewModel
