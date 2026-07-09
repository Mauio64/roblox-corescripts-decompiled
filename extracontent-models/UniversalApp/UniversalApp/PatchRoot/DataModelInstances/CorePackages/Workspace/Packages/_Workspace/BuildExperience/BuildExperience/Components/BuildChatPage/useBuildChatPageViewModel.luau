local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")

require(BuildExperienceParent.DataHydration.CreatorAgentChat)

local Foundation = require(BuildExperienceParent.Foundation)
local React = require(BuildExperienceParent.React)

require(BuildExperience.Chat.chatTypes)

local useChatPlaytestFooter = require(BuildExperience.Chat.useChatPlaytestFooter)
local useChatSessionCore = require(BuildExperience.Chat.useChatSessionCore)
local sendBuildExperienceEvent = require(BuildExperience.Telemetry.sendBuildExperienceEvent)
local GetBuildOverflowMenuStore = require(BuildExperience.Stores.GetBuildOverflowMenuStore)
local GetCreatorAgentResumeStore = require(BuildExperience.Stores.GetCreatorAgentResumeStore)

require(script.Parent.BuildChatPageView)

local useTokens = Foundation.Hooks.useTokens

local function getKeyboardTop() -- line: 35
	-- upvalues: UserInputService (copy), GuiService (copy)
	if not UserInputService.OnScreenKeyboardVisible then
		return 0
	end

	local GuiInset = GuiService:GetGuiInset()

	return (math.max(0, UserInputService.OnScreenKeyboardPosition.Y - GuiInset.Y))
end
local function useBuildChatPageViewModel(t1: {[any]: any}) -- line: 43
	-- upvalues: useTokens (copy), GetBuildOverflowMenuStore (copy), GetCreatorAgentResumeStore (copy), React (copy), UserInputService (copy), GuiService (copy), useChatSessionCore (copy), useChatPlaytestFooter (copy), sendBuildExperienceEvent (copy)
	local v17 = useTokens()
	local v18 = GetBuildOverflowMenuStore()
	local v19 = GetCreatorAgentResumeStore()
	local v20, v21 = React.useState(nil)
	local useState = React.useState
	local n1

	if not UserInputService.OnScreenKeyboardVisible then
		n1 = 0
	else
		local GuiInset = GuiService:GetGuiInset()

		n1 = math.max(0, UserInputService.OnScreenKeyboardPosition.Y - GuiInset.Y)
	end

	local v25, v26 = useState(n1)
	local v27, v28 = React.useState(0)
	local v29 = React.useCallback(function() -- line: 52
		-- upvalues: v26 (copy), UserInputService (copy), GuiService (copy)
		local v44 = v26
		local n2

		if not UserInputService.OnScreenKeyboardVisible then
			n2 = 0
		else
			local GuiInset = GuiService:GetGuiInset()

			n2 = math.max(0, UserInputService.OnScreenKeyboardPosition.Y - GuiInset.Y)
		end

		v44(n2)
	end, {})

	React.useEffect(function() -- line: 56
		-- upvalues: v29 (copy), UserInputService (copy)
		v29()

		local connection = UserInputService:GetPropertyChangedSignal("OnScreenKeyboardVisible"):Connect(v29)
		local connection2 = UserInputService:GetPropertyChangedSignal("OnScreenKeyboardSize"):Connect(v29)
		local connection3 = UserInputService:GetPropertyChangedSignal("OnScreenKeyboardPosition"):Connect(v29)

		return function() -- line: 64
			-- upvalues: connection (copy), connection2 (copy), connection3 (copy)
			connection:Disconnect()
			connection2:Disconnect()
			connection3:Disconnect()
		end
	end, { v29 })

	local v30 = React.useCallback(function(p1) -- line: 71
		-- upvalues: v28 (copy)
		v28(p1.AbsolutePosition.Y + p1.AbsoluteSize.Y)
	end, {})
	local v31 = if not (v25 <= 0) and not (v27 <= 0) then math.max(0, v27 - v25) else 0
	local v32 = useChatSessionCore({
		autoFocusComposer = false,
		universeId = t1.target.universeId,
		placeId = t1.target.placeId,
		sessionId = t1.target.sessionId
	})
	local v33 = useChatPlaytestFooter(v32, "BuildChatPlaytestCta")
	local subagentTaskState = v32.subagentTaskState
	local v35 = subagentTaskState ~= nil and #subagentTaskState.groups > 0
	local v36 = t1.target.isNewGameTarget == true
	local v37 = #v32.messages == 0

	React.useEffect(function() -- line: 89
		-- upvalues: v19 (copy), t1 (copy)
		v19.setActiveTarget({
			universeId = t1.target.universeId,
			sessionId = t1.target.sessionId
		})

		return function() -- line: 94
			-- upvalues: v19 (copy)
			v19.setActiveTarget(nil)
		end
	end, {
		v19,
		t1.target.universeId,
		t1.target.sessionId
	})

	local v38 = React.useCallback(function() -- line: 99
		-- upvalues: v32 (copy)
		if v32.textBoxRef.current then
			v32.textBoxRef.current.releaseFocus()
		end
	end, { v32.textBoxRef })
	local v39 = React.useCallback(function() -- line: 105
		-- upvalues: v38 (copy), t1 (copy)
		v38()
		t1.onClose()
	end, {
		v38,
		t1.onClose
	})
	local v40 = React.useCallback(function(p2) -- line: 110
		-- upvalues: v38 (copy), t1 (copy)
		if p2.type == "openPage" then
			v38()

			if t1.onOpenConfigurationPage then
				t1.onOpenConfigurationPage(p2.page)
			end
		end
	end, {
		v38,
		t1.onOpenConfigurationPage
	})
	local v41 = React.useCallback(function() -- line: 119
		-- upvalues: sendBuildExperienceEvent (copy), t1 (copy), v32 (copy)
		sendBuildExperienceEvent("PLAY_CLICK", {
			universeId = t1.target.universeId,
			placeId = v32.playtestPlaceId
		})

		if v32.launchPlaytest then
			v32.launchPlaytest("BuildChatPage")
		end
	end, {
		v32.launchPlaytest,
		v32.playtestPlaceId,
		t1.target.universeId
	})
	local v42 = React.useCallback(function() -- line: 129
		-- upvalues: subagentTaskState (copy), v38 (copy), t1 (copy)
		if subagentTaskState == nil then
			return
		end

		v38()
		t1.onOpenAgentsPage(subagentTaskState)
	end, {
		v38,
		t1.onOpenAgentsPage,
		subagentTaskState
	})
	local v43 = React.useCallback(function(s1: string) -- line: 137
		-- upvalues: v38 (copy), v21 (copy)
		v38()
		v21(s1)
	end, { v38 })

	return {
		target = t1.target,
		keyboardOverlap = v31,
		onPageMetricsChanged = v30,
		selectedChipGroupName = v20,
		onChipActivated = v43,
		onChipBottomSheetClose = function() -- line: 148
			-- upvalues: v21 (copy)
			v21(nil)
		end,
		onClose = v39,
		onOverflowMenuAction = v40,
		onPlayActivated = v41,
		onOpenAgentsPage = v42,
		buildOverflowMenuStore = v18,
		messages = v32.messages,
		localToolActions = v32.localToolActions,
		clockBinding = v32.clockBinding,
		onPlaytest = v33.onPlaytest,
		isPlaytestLoading = v33.isPlaytestLoading,
		isChatEmpty = v37,
		isNewGameTarget = v36,
		hasPublishedTurn = v32.hasPublishedTurn,
		hasTaskGroups = v35,
		taskState = subagentTaskState,
		scrollingFrameRef = v32.setScrollingFrame,
		composerText = v32.composerText,
		composerErrorText = v32.composerErrorText,
		onComposerChanged = v32.setComposerText,
		textBoxRef = v32.textBoxRef,
		isAssistantResponding = v32.isAssistantResponding,
		onSend = v32.sendMessage,
		onStop = v32.stopAssistantResponse,
		statusChipGap = v17.Gap.Small,
		paddingBottom = v17.Padding.Small + v31
	}
end

return useBuildChatPageViewModel
