local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local CreatorAgentChat = require(BuildExperienceParent.DataHydration.CreatorAgentChat)
local Foundation = require(BuildExperienceParent.Foundation)
local React = require(BuildExperienceParent.React)
local LocalizationStrings = require(BuildExperience.LocalizationStrings)
local chatConstants = require(BuildExperience.Chat.chatConstants)

require(BuildExperience.Chat.chatTypes)

local BuildEmptyState = require(BuildExperience.Components.BuildEmptyState.BuildEmptyState)
local BuildOverflowMenuButton = require(BuildExperience.Components.BuildPillMenu.BuildOverflowMenuButton)
local AgentDetailMenu = require(BuildExperience.Components.BuildPillMenu.AgentDetailMenu)
local PlayButton = require(BuildExperience.Components.PlayButton.PlayButton)
local ChatActions = require(BuildExperience.Components.Chat.ChatActions)
local ChatMessageList = require(BuildExperience.Components.Chat.ChatMessageList)
local PushNotificationsUpsellCard = require(BuildExperience.Components.Chat.PushNotificationsUpsellCard)
local SubagentStatus = require(BuildExperience.Components.SubagentStatus)

require(BuildExperience.Stores.GetBuildOverflowMenuStore)
require(BuildExperience.Stores.GetBuildOverflowMenuStore.createBuildOverflowMenuStore)
require(BuildExperience.Chat.useChatSessionCore)

local FFlagEnableBuildExperienceScrollPerformanceTracking = require(BuildExperience.Flags.FFlagEnableBuildExperienceScrollPerformanceTracking)
local v17 = if not FFlagEnableBuildExperienceScrollPerformanceTracking then nil else require(BuildExperience.Telemetry.useScrollPerformanceTracker)
local Divider = Foundation.Divider
local IconButton = Foundation.IconButton
local ScrollView = Foundation.ScrollView
local FoundationText = Foundation.Text
local View = Foundation.View
local ButtonVariant = Foundation.Enums.ButtonVariant
local IconName = Foundation.Enums.IconName
local InputSize = Foundation.Enums.InputSize
local useTokens = Foundation.Hooks.useTokens
local SubagentTaskStatus = CreatorAgentChat.SubagentTaskStatus

local function findGroup(p1, s1: string?) -- line: 97
	if p1 == nil or s1 == nil then
		return nil
	end

	for _, v35 in p1.groups do
		if s1 == v35.name then
			return v35
		end
	end

	return nil
end
local function getGroupStatus(p2) -- line: 109
	-- upvalues: SubagentTaskStatus (copy)
	if p2.isLoading then
		return SubagentTaskStatus.InProgress
	end

	if p2.isComplete then
		return SubagentTaskStatus.Done
	end

	return SubagentTaskStatus.Pending
end
local function toTodoItems(p3) -- line: 119
	local t1 = {}

	if p3 == nil then
		return t1
	end

	for v39, v40 in p3.tasks do
		t1[v39] = {
			title = v40.text,
			description = v40.description,
			status = v40.status,
			testId = `BuildChatPage.TodoBottomSheet.{ p3.name }.{ v39 }`
		}
	end

	return t1
end
local function BuildChatPageView(t2: {[any]: any}) -- line: 135
	-- upvalues: useTokens (copy), React (copy), FFlagEnableBuildExperienceScrollPerformanceTracking (copy), v17 (copy), ChatMessageList (copy), BuildEmptyState (copy), PushNotificationsUpsellCard (copy), SubagentTaskStatus (copy), SubagentStatus (copy), View (copy), IconButton (copy), IconName (copy), InputSize (copy), FoundationText (copy), chatConstants (copy), PlayButton (copy), ButtonVariant (copy), AgentDetailMenu (copy), BuildOverflowMenuButton (copy), ScrollView (copy), Foundation (copy), Divider (copy), ChatActions (copy), LocalizationStrings (copy), toTodoItems (copy)
	local v42 = useTokens()
	local v43 = React.useRef(nil)
	local g50 = nil
	local v47 = nil

	if FFlagEnableBuildExperienceScrollPerformanceTracking then
		v17("LuaApp_Build_Chat_Scroll", v43)
	end

	local v44 = React.useCallback(function(p4) -- line: 143
		-- upvalues: v43 (copy), t2 (copy)
		v43.current = p4
		t2.scrollingFrameRef(p4)
	end, { t2.scrollingFrameRef })
	local taskState = t2.taskState
	local selectedChipGroupName = t2.selectedChipGroupName

	if taskState == nil or selectedChipGroupName == nil then
		v47 = nil
	else
		for _, v49 in taskState.groups do
			if selectedChipGroupName == v49.name then
				v47 = v49
				g50 = true
			end

			if g50 then
				break
			end
		end

		if not g50 then
			v47 = nil
		end
	end

	g50 = false

	local v51 = ChatMessageList({
		messages = t2.messages,
		clockBinding = t2.clockBinding,
		localToolActions = t2.localToolActions,
		emptyState = React.createElement(BuildEmptyState),
		onPlaytest = t2.onPlaytest,
		isPlaytestLoading = t2.isPlaytestLoading
	})
	local v52 = false

	for _, v54 in t2.messages do
		if v54.kind == "user_message" then
			v52 = true

			break
		end
	end

	if t2.showPushNotificationsUpsell and v52 and t2.isAssistantResponding then
		v51.PushNotificationsUpsell = React.createElement(PushNotificationsUpsellCard, {
			LayoutOrder = #t2.messages + 1,
			isRequestPending = t2.isPushNotificationsRequestPending,
			shouldOpenSettings = t2.shouldOpenPushNotificationsSettings,
			onNotifyMe = t2.onNotifyMe,
			onOpenSettings = t2.onOpenPushNotificationsSettings,
			onNotNow = t2.onNotNow
		})
	end

	local t3 = {}

	if t2.taskState ~= nil then
		for v56, v57 in t2.taskState.groups do
			local v58 = if not v57.isLoading then if not v57.isComplete then SubagentTaskStatus.Pending else SubagentTaskStatus.Done else SubagentTaskStatus.InProgress

			t3[`Group{ v56 }`] = React.createElement(SubagentStatus.Root, {
				layoutOrder = v56,
				text = v57.name,
				isChecked = v57.isComplete,
				onActivated = function() -- line: 183
					-- upvalues: t2 (copy), v57 (copy)
					t2.onChipActivated(v57.name)
				end,
				testId = `BuildChatPage.SubagentStatus.{ v57.name }`
			}, {
				Indicator = if v58 == SubagentTaskStatus.Pending then nil else React.createElement(SubagentStatus.LoadingIndicator, {
					status = v58,
					testId = `BuildChatPage.SubagentStatus.{ v57.name }.Indicator`
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
					onActivated = t2.onOpenAgentsPage
				}),
				Overflow = React.createElement(BuildOverflowMenuButton, {
					layoutOrder = 5,
					icon = IconName.ThreeDotsHorizontal,
					isDisabled = t2.target.universeId == nil,
					hasPublishedTurn = t2.hasPublishedTurn,
					hasPublishedVersion = t2.hasPublishedVersion,
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
			}, t3),
			Divider = React.createElement(Divider, {
				LayoutOrder = 3,
				testId = "BuildChatPage.HeaderDivider",
				Visible = t2.isChatScrollable
			})
		}),
		Messages = React.createElement(ScrollView, {
			LayoutOrder = 2,
			tag = "fill size-full-0",
			scrollingFrameRef = if not FFlagEnableBuildExperienceScrollPerformanceTracking then t2.scrollingFrameRef else v44,
			onAbsoluteCanvasSizeChanged = t2.onChatViewportChanged,
			onAbsoluteWindowSizeChanged = t2.onChatViewportChanged,
			scroll = {
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				CanvasSize = UDim2.new(1, 0, 0, 0),
				ScrollingDirection = Enum.ScrollingDirection.Y
			}
		}, {
			MessageColumn = React.createElement(View, {
				testId = "BuildChatPage.MessageBody",
				layout = {
					FillDirection = Enum.FillDirection.Vertical,
					Padding = UDim.new(0, v42.Size.Size_800)
				},
				tag = {
					["composition-content-body"] = true,
					["size-full"] = t2.isChatEmpty,
					["size-full-0 auto-y padding-y-large"] = not t2.isChatEmpty
				}
			}, v51)
		}),
		Actions = React.createElement(View, {
			LayoutOrder = 3,
			tag = "composition-content-body size-full-0 auto-y",
			testId = "BuildChatPage.ActionBody"
		}, {
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
		TodoBottomSheet = React.createElement(SubagentStatus.TodoBottomSheet, {
			title = v47 == nil and "" or v47.name,
			items = toTodoItems(v47),
			isOpen = v47 ~= nil,
			onClose = t2.onChipBottomSheetClose
		})
	})
end

return BuildChatPageView
