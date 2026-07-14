local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local React = require(BuildExperienceParent.React)
local BuildEmptyState = require(BuildExperience.Components.BuildEmptyState.BuildEmptyState)
local BuildPillMenuPortal = require(BuildExperience.Components.BuildPillMenu.BuildPillMenuPortal)
local ChatActions = require(BuildExperience.Components.Chat.ChatActions)
local ChatMessageList = require(BuildExperience.Components.Chat.ChatMessageList)
local Sheet = require(BuildExperience.FoundationFork.Sheet)

require(BuildExperience.Chat.chatTypes)
require(BuildExperience.Chat.useChatSessionCore)

local function ChatSheetView(t1: {[any]: any}) -- line: 42
	-- upvalues: ChatMessageList (copy), React (copy), BuildEmptyState (copy), Sheet (copy), ChatActions (copy), BuildPillMenuPortal (copy)
	local v11 = ChatMessageList({
		messages = t1.messages,
		clockBinding = t1.clockBinding,
		localToolActions = t1.localToolActions,
		emptyState = React.createElement(BuildEmptyState),
		onPlaytest = t1.onPlaytest,
		isPlaytestLoading = t1.isPlaytestLoading
	})

	return React.createElement(Sheet.Root, {
		isOpen = t1.isOpen,
		snapPoints = t1.snapPoints,
		defaultSnapPointIndex = t1.defaultSnapPointIndex,
		onClose = t1.onClose
	}, {
		Content = React.createElement(Sheet.Content, {
			scrollingFrameRef = t1.scrollingFrameRef
		}, v11),
		Actions = React.createElement(Sheet.Actions, nil, {
			Footer = React.createElement(ChatActions, {
				placeholder = "Describe an idea",
				composerText = t1.composerText,
				composerErrorText = t1.composerErrorText,
				onComposerChanged = t1.onComposerChanged,
				textBoxRef = t1.textBoxRef,
				isAssistantResponding = t1.isAssistantResponding,
				canStopAssistantResponse = t1.canStopAssistantResponse,
				onSend = t1.onSend,
				onStop = t1.onStop
			})
		}),
		TopBarPillMenu = if t1.topBarPillMenuTarget == nil then nil else React.createElement(BuildPillMenuPortal, {
			testId = "build-pill-menu",
			target = t1.topBarPillMenuTarget
		})
	})
end

return ChatSheetView
