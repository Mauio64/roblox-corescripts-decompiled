local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local Foundation = require(BuildExperienceParent.Foundation)
local React = require(BuildExperienceParent.React)
local LocalizationStrings = require(BuildExperience.LocalizationStrings)
local BuildEmptyState = require(BuildExperience.Components.BuildEmptyState.BuildEmptyState)
local BuildPillMenuPortal = require(BuildExperience.Components.BuildPillMenu.BuildPillMenuPortal)
local ChatActions = require(BuildExperience.Components.Chat.ChatActions)
local ChatMessageList = require(BuildExperience.Components.Chat.ChatMessageList)
local Sheet = require(BuildExperience.FoundationFork.Sheet)

require(BuildExperience.Chat.chatTypes)
require(BuildExperience.Chat.useChatSessionCore)

local FFlagEnableBuildExperienceScrollPerformanceTracking = require(BuildExperience.Flags.FFlagEnableBuildExperienceScrollPerformanceTracking)
local v12 = if not FFlagEnableBuildExperienceScrollPerformanceTracking then nil else require(BuildExperience.Telemetry.useScrollPerformanceTracker)
local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens

local function ChatSheetContent(t1: {[any]: any}) -- line: 52
	-- upvalues: React (copy), FFlagEnableBuildExperienceScrollPerformanceTracking (copy), v12 (copy), Sheet (copy)
	local v18 = React.useRef(nil)

	if FFlagEnableBuildExperienceScrollPerformanceTracking then
		v12("LuaApp_Build_Chat_Scroll", v18)
	end

	local v19 = React.useCallback(function(p1) -- line: 62
		-- upvalues: v18 (copy), t1 (copy)
		v18.current = p1
		t1.setScrollingFrame(p1)
	end, { t1.setScrollingFrame })

	return React.createElement(Sheet.Content, {
		scrollingFrameRef = if not FFlagEnableBuildExperienceScrollPerformanceTracking then t1.setScrollingFrame else v19
	}, t1.children)
end
local function ChatSheetView(t2: {[any]: any}) -- line: 74
	-- upvalues: useTokens (copy), ChatMessageList (copy), React (copy), BuildEmptyState (copy), View (copy), Sheet (copy), ChatSheetContent (copy), ChatActions (copy), LocalizationStrings (copy), BuildPillMenuPortal (copy)
	local v21 = useTokens()
	local v22 = ChatMessageList({
		messages = t2.messages,
		clockBinding = t2.clockBinding,
		localToolActions = t2.localToolActions,
		emptyState = React.createElement(BuildEmptyState),
		onPlaytest = t2.onPlaytest,
		isPlaytestLoading = t2.isPlaytestLoading
	})
	local v23 = React.createElement(View, {
		testId = "ChatSheet.MessageList",
		layout = {
			FillDirection = Enum.FillDirection.Vertical,
			Padding = UDim.new(0, v21.Size.Size_800)
		},
		tag = {
			["size-full"] = #t2.messages == 0,
			["size-full-0 auto-y"] = #t2.messages > 0
		}
	}, v22)

	return React.createElement(Sheet.Root, {
		isOpen = t2.isOpen,
		snapPoints = t2.snapPoints,
		defaultSnapPointIndex = t2.defaultSnapPointIndex,
		onClose = t2.onClose
	}, {
		Content = React.createElement(ChatSheetContent, {
			setScrollingFrame = t2.scrollingFrameRef
		}, {
			MessageList = v23
		}),
		Actions = React.createElement(Sheet.Actions, nil, {
			Footer = React.createElement(ChatActions, {
				composerText = t2.composerText,
				composerErrorText = t2.composerErrorText,
				onComposerChanged = t2.onComposerChanged,
				placeholder = LocalizationStrings.CHAT_COMPOSER_PLACEHOLDER,
				textBoxRef = t2.textBoxRef,
				isAssistantResponding = t2.isAssistantResponding,
				canStopAssistantResponse = t2.canStopAssistantResponse,
				onSend = t2.onSend,
				onStop = t2.onStop
			})
		}),
		TopBarPillMenu = if t2.topBarPillMenuTarget == nil then nil else React.createElement(BuildPillMenuPortal, {
			testId = "build-pill-menu",
			target = t2.topBarPillMenuTarget
		})
	})
end

return ChatSheetView
