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
local BuyMoreRobuxCard = require(BuildExperience.Components.Chat.BuyMoreRobuxCard)
local ChatActions = require(BuildExperience.Components.Chat.ChatActions)
local ChatMessageList = require(BuildExperience.Components.Chat.ChatMessageList)
local PushNotificationsUpsellCard = require(BuildExperience.Components.Chat.PushNotificationsUpsellCard)
local SubagentStatus = require(BuildExperience.Components.SubagentStatus)

require(BuildExperience.Stores.GetBuildOverflowMenuStore)
require(BuildExperience.Stores.GetBuildOverflowMenuStore.createBuildOverflowMenuStore)
require(BuildExperience.Chat.useChatSessionCore)

local FFlagEnableBuildExperienceScrollPerformanceTracking = require(BuildExperience.Flags.FFlagEnableBuildExperienceScrollPerformanceTracking)
local v18 = if not FFlagEnableBuildExperienceScrollPerformanceTracking then nil else require(BuildExperience.Telemetry.useScrollPerformanceTracker)
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

local function findGroup(p1, s1: string?) -- line: 108
	if p1 == nil or s1 == nil then
		return nil
	end

	for _, v36 in p1.groups do
		if s1 == v36.name then
			return v36
		end
	end

	return nil
end
local function getGroupStatus(p2) -- line: 120
	-- upvalues: SubagentTaskStatus (copy)
	if p2.isLoading then
		return SubagentTaskStatus.InProgress
	end

	if p2.isComplete then
		return SubagentTaskStatus.Done
	end

	return SubagentTaskStatus.Pending
end
local function toTodoItems(p3) -- line: 130
	local t1 = {}

	if p3 == nil then
		return t1
	end

	for v40, v41 in p3.tasks do
		t1[v40] = {
			title = v41.text,
			description = v41.description,
			status = v41.status,
			testId = `BuildChatPage.TodoBottomSheet.{ p3.name }.{ v40 }`
		}
	end

	return t1
end
local function BuildChatPageView(t2: {[any]: any}) -- line: 146
	-- upvalues: useTokens (copy), React (copy), FFlagEnableBuildExperienceScrollPerformanceTracking (copy), v18 (copy), ChatMessageList (copy), BuildEmptyState (copy), PushNotificationsUpsellCard (copy), SubagentTaskStatus (copy), SubagentStatus (copy), View (copy), IconButton (copy), IconName (copy), InputSize (copy), FoundationText (copy), chatConstants (copy), PlayButton (copy), ButtonVariant (copy), AgentDetailMenu (copy), BuildOverflowMenuButton (copy), ScrollView (copy), Foundation (copy), Divider (copy), BuyMoreRobuxCard (copy), ChatActions (copy), LocalizationStrings (copy), toTodoItems (copy)
	local v43 = useTokens()
	local v44 = React.useRef(nil)
	local g51 = nil
	local v48 = nil

	if FFlagEnableBuildExperienceScrollPerformanceTracking then
		v18("LuaApp_Build_Chat_Scroll", v44)
	end

	local v45 = React.useCallback(function(p4) -- line: 154
		-- upvalues: v44 (copy), t2 (copy)
		v44.current = p4
		t2.scrollingFrameRef(p4)
	end, { t2.scrollingFrameRef })
	local taskState = t2.taskState
	local selectedChipGroupName = t2.selectedChipGroupName

	if taskState == nil or selectedChipGroupName == nil then
		v48 = nil
	else
		for _, v50 in taskState.groups do
			if selectedChipGroupName == v50.name then
				v48 = v50
				g51 = true
			end

			if g51 then
				break
			end
		end

		if not g51 then
			v48 = nil
		end
	end

	g51 = false

	local v52 = ChatMessageList({
		messages = t2.messages,
		clockBinding = t2.clockBinding,
		localToolActions = t2.localToolActions,
		emptyState = React.createElement(BuildEmptyState),
		onPlaytest = t2.onPlaytest,
		isPlaytestLoading = t2.isPlaytestLoading
	})
	local v53 = false

	for _, v55 in t2.messages do
		if v55.kind == "user_message" then
			v53 = true

			break
		end
	end

	if t2.showPushNotificationsUpsell and v53 and t2.isAssistantResponding then
		v52.PushNotificationsUpsell = React.createElement(PushNotificationsUpsellCard, {
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
		for v57, v58 in t2.taskState.groups do
			local v59 = if not v58.isLoading then if not v58.isComplete then SubagentTaskStatus.Pending else SubagentTaskStatus.Done else SubagentTaskStatus.InProgress

			t3[`Group{ v57 }`] = React.createElement(SubagentStatus.Root, {
				layoutOrder = v57,
				text = v58.name,
				isChecked = v58.isComplete,
				onActivated = function() -- line: 203
					-- upvalues: t2 (copy), v58 (copy)
					t2.onChipActivated(v58.name)
				end,
				testId = `BuildChatPage.SubagentStatus.{ v58.name }`
			}, {
				Indicator = if v59 == SubagentTaskStatus.Pending then nil else React.createElement(SubagentStatus.LoadingIndicator, {
					status = v59,
					testId = `BuildChatPage.SubagentStatus.{ v58.name }.Indicator`
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
					onAction = t2.onOverflowMenuAction,
					onOpenCreatorCreditPage = t2.onOpenCreatorCreditPage
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
			scrollingFrameRef = if not FFlagEnableBuildExperienceScrollPerformanceTracking then t2.scrollingFrameRef else v45,
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
					Padding = UDim.new(0, v43.Size.Size_800)
				},
				tag = {
					["composition-content-body"] = true,
					["size-full"] = t2.isChatEmpty,
					["size-full-0 auto-y padding-y-large"] = not t2.isChatEmpty
				}
			}, v52)
		}),
		Actions = React.createElement(View, {
			LayoutOrder = 3,
			testId = "BuildChatPage.ActionBody",
			tag = {
				["composition-content-body"] = true,
				["size-full-0 auto-y"] = true,
				["col gap-medium"] = t2.showBuyMoreRobuxCard
			}
		}, {
			BuyMoreRobux = if not t2.showBuyMoreRobuxCard then nil else React.createElement(BuyMoreRobuxCard, {
				LayoutOrder = 1,
				title = t2.buyMoreRobuxCardTitle,
				description = t2.buyMoreRobuxCardDescription,
				primaryActionText = t2.buyMoreRobuxCardPrimaryActionText,
				onPrimaryAction = t2.onBuyMoreRobuxCardPrimaryAction,
				secondaryActionText = t2.buyMoreRobuxCardSecondaryActionText,
				onSecondaryAction = t2.onBuyMoreRobuxCardSecondaryAction
			}),
			Footer = React.createElement(ChatActions, {
				LayoutOrder = if not t2.showBuyMoreRobuxCard then nil else 2,
				composerText = t2.composerText,
				composerErrorText = t2.composerErrorText,
				onComposerChanged = t2.onComposerChanged,
				placeholder = LocalizationStrings.CHAT_COMPOSER_PLACEHOLDER,
				textBoxRef = t2.textBoxRef,
				isAssistantResponding = t2.isAssistantResponding,
				canStopAssistantResponse = t2.canStopAssistantResponse,
				canSendWhileResponding = t2.canSendWhileResponding,
				onSend = t2.onSend,
				onStop = t2.onStop
			})
		}),
		TodoBottomSheet = React.createElement(SubagentStatus.TodoBottomSheet, {
			title = v48 == nil and "" or v48.name,
			items = toTodoItems(v48),
			isOpen = v48 ~= nil,
			onClose = t2.onChipBottomSheetClose
		})
	})
end

return BuildChatPageView
