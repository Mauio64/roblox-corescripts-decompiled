local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local CreatorAgentChat = require(BuildExperienceParent.DataHydration.CreatorAgentChat)
local Foundation = require(BuildExperienceParent.Foundation)
local React = require(BuildExperienceParent.React)
local chatConstants = require(BuildExperience.Chat.chatConstants)

require(BuildExperience.Chat.chatTypes)

local BuildEmptyState = require(BuildExperience.Components.BuildEmptyState.BuildEmptyState)
local BuildOverflowMenuButton = require(BuildExperience.Components.BuildPillMenu.BuildOverflowMenuButton)
local AgentDetailMenu = require(BuildExperience.Components.BuildPillMenu.AgentDetailMenu)
local PlayButton = require(BuildExperience.Components.PlayButton.PlayButton)
local ChatActions = require(BuildExperience.Components.Chat.ChatActions)
local ChatMessageList = require(BuildExperience.Components.Chat.ChatMessageList)
local SubagentStatus = require(BuildExperience.Components.SubagentStatus)

require(BuildExperience.Stores.GetBuildOverflowMenuStore)
require(BuildExperience.Stores.GetBuildOverflowMenuStore.createBuildOverflowMenuStore)
require(BuildExperience.Chat.useChatSessionCore)

local IconButton = Foundation.IconButton
local ScrollView = Foundation.ScrollView
local FoundationText = Foundation.Text
local View = Foundation.View
local ButtonVariant = Foundation.Enums.ButtonVariant
local IconName = Foundation.Enums.IconName
local InputSize = Foundation.Enums.InputSize
local SubagentTaskStatus = CreatorAgentChat.SubagentTaskStatus

local function findGroup(p1, s1: string?) -- line: 78
	if p1 == nil or s1 == nil then
		return nil
	end

	for _, v29 in p1.groups do
		if s1 == v29.name then
			return v29
		end
	end

	return nil
end
local function getGroupStatus(p2) -- line: 90
	-- upvalues: SubagentTaskStatus (copy)
	if p2.isLoading then
		return SubagentTaskStatus.InProgress
	end

	if p2.isComplete then
		return SubagentTaskStatus.Done
	end

	return SubagentTaskStatus.Pending
end
local function toTodoItems(p3) -- line: 100
	local t1 = {}

	if p3 == nil then
		return t1
	end

	for v33, v34 in p3.tasks do
		t1[v33] = {
			title = v34.text,
			description = v34.description,
			status = v34.status,
			testId = `BuildChatPage.TodoBottomSheet.{ p3.name }.{ v33 }`
		}
	end

	return t1
end
local function BuildChatPageView(t2: {[any]: any}) -- line: 116
	-- upvalues: ChatMessageList (copy), React (copy), BuildEmptyState (copy), SubagentTaskStatus (copy), SubagentStatus (copy), View (copy), IconButton (copy), IconName (copy), InputSize (copy), FoundationText (copy), chatConstants (copy), PlayButton (copy), ButtonVariant (copy), AgentDetailMenu (copy), BuildOverflowMenuButton (copy), ScrollView (copy), Foundation (copy), ChatActions (copy), toTodoItems (copy)
	local taskState = t2.taskState
	local selectedChipGroupName = t2.selectedChipGroupName
	local v38, g41

	if taskState == nil or selectedChipGroupName == nil then
		v38 = nil
	else
		g41 = nil
		v38 = nil

		for _, v40 in taskState.groups do
			if selectedChipGroupName == v40.name then
				v38 = v40
				g41 = true
			end

			if g41 then
				break
			end
		end

		if not g41 then
			v38 = nil
		end
	end

	g41 = false

	local v42 = ChatMessageList({
		messages = t2.messages,
		clockBinding = t2.clockBinding,
		localToolActions = t2.localToolActions,
		emptyState = React.createElement(BuildEmptyState),
		onPlaytest = t2.onPlaytest,
		isPlaytestLoading = t2.isPlaytestLoading
	})
	local t3 = {}

	if t2.taskState ~= nil then
		for v44, v45 in t2.taskState.groups do
			local v46 = if not v45.isLoading then if not v45.isComplete then SubagentTaskStatus.Pending else SubagentTaskStatus.Done else SubagentTaskStatus.InProgress

			t3[`Group{ v44 }`] = React.createElement(SubagentStatus.Root, {
				layoutOrder = v44,
				text = v45.name,
				isChecked = v45.isComplete,
				onActivated = function() -- line: 135
					-- upvalues: t2 (copy), v45 (copy)
					t2.onChipActivated(v45.name)
				end,
				testId = `BuildChatPage.SubagentStatus.{ v45.name }`
			}, {
				Indicator = if v46 == SubagentTaskStatus.Pending then nil else React.createElement(SubagentStatus.LoadingIndicator, {
					status = v46,
					testId = `BuildChatPage.SubagentStatus.{ v45.name }.Indicator`
				})
			})
		end
	end

	return React.createElement(View, {
		tag = "col align-x-center size-full bg-surface-0",
		onAbsolutePositionChanged = t2.onPageMetricsChanged,
		onAbsoluteSizeChanged = t2.onPageMetricsChanged,
		padding = {
			bottom = UDim.new(0, t2.paddingBottom)
		}
	}, {
		Header = React.createElement(View, {
			LayoutOrder = 1,
			tag = "col align-x-center size-full-0 auto-y bg-surface-0"
		}, {
			HeaderBar = React.createElement(View, {
				LayoutOrder = 1,
				tag = "composition-content-header row align-y-center gap-small size-full-0 auto-y padding-y-medium",
				testId = "BuildChatPage.HeaderBar"
			}, {
				Back = React.createElement(IconButton, {
					LayoutOrder = 1,
					isCircular = true,
					testId = "BuildChatPage.BackButton",
					icon = IconName.ChevronLargeLeft,
					onActivated = t2.onClose,
					size = InputSize.Medium
				}),
				Title = React.createElement(FoundationText, {
					LayoutOrder = 2,
					tag = "fill text-heading-small text-align-x-left text-truncate-split content-emphasis",
					Text = if not t2.isNewGameTarget then t2.target.experienceName else chatConstants.BUILD_CHAT_PAGE_TITLE
				}),
				Play = React.createElement(PlayButton, {
					LayoutOrder = 3,
					isActive = true,
					activeIcon = IconName.PlaySmall,
					inActiveIcon = IconName.PlaySmall,
					isDisabled = t2.isNewGameTarget and not t2.hasPublishedTurn,
					onActivated = t2.onPlayActivated,
					variant = ButtonVariant.Utility
				}),
				AgentDetail = React.createElement(AgentDetailMenu, {
					layoutOrder = 4,
					isDisabled = not t2.hasTaskGroups,
					onActivated = t2.onOpenAgentsPage
				}),
				Overflow = React.createElement(BuildOverflowMenuButton, {
					layoutOrder = 5,
					icon = IconName.ThreeDotsHorizontal,
					target = {
						universeId = t2.target.universeId,
						placeId = t2.target.placeId,
						sessionId = t2.target.sessionId,
						isNewGameTarget = t2.isNewGameTarget
					},
					store = t2.buildOverflowMenuStore,
					onClose = t2.onClose,
					onAction = t2.onOverflowMenuAction
				})
			}),
			SubagentStatus = if not t2.hasTaskGroups then nil else React.createElement(ScrollView, {
				LayoutOrder = 2,
				tag = "composition-content-header size-full-0 auto-y padding-bottom-small",
				testId = "BuildChatPage.SubagentStatus",
				layout = {
					FillDirection = Enum.FillDirection.Horizontal,
					Padding = UDim.new(0, t2.statusChipGap)
				},
				scroll = {
					AutomaticCanvasSize = Enum.AutomaticSize.X,
					AutomaticSize = Enum.AutomaticSize.Y,
					CanvasSize = UDim2.fromOffset(0, 0),
					ScrollingDirection = Enum.ScrollingDirection.X,
					scrollBarVisibility = Foundation.Enums.ScrollBarVisibility.None
				}
			}, t3)
		}),
		Messages = React.createElement(ScrollView, {
			LayoutOrder = 2,
			tag = "fill size-full-0",
			scrollingFrameRef = t2.scrollingFrameRef,
			scroll = {
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				CanvasSize = UDim2.new(1, 0, 0, 0),
				ScrollingDirection = Enum.ScrollingDirection.Y
			}
		}, {
			MessageColumn = React.createElement(View, {
				testId = "BuildChatPage.MessageBody",
				Size = if not t2.isChatEmpty then nil else UDim2.fromScale(1, 1),
				tag = {
					["composition-content-body col size-full"] = t2.isChatEmpty,
					["composition-content-body col gap-medium size-full-0 auto-y padding-y-large"] = not t2.isChatEmpty
				}
			}, v42)
		}),
		Actions = React.createElement(View, {
			LayoutOrder = 3,
			tag = "composition-content-body size-full-0 auto-y",
			testId = "BuildChatPage.ActionBody"
		}, {
			Footer = React.createElement(ChatActions, {
				placeholder = "Describe an idea",
				composerText = t2.composerText,
				composerErrorText = t2.composerErrorText,
				onComposerChanged = t2.onComposerChanged,
				textBoxRef = t2.textBoxRef,
				isAssistantResponding = t2.isAssistantResponding,
				onSend = t2.onSend,
				onStop = t2.onStop
			})
		}),
		TodoBottomSheet = React.createElement(SubagentStatus.TodoBottomSheet, {
			title = v38 == nil and "" or v38.name,
			items = toTodoItems(v38),
			isOpen = v38 ~= nil,
			onClose = t2.onChipBottomSheetClose
		})
	})
end

return BuildChatPageView
