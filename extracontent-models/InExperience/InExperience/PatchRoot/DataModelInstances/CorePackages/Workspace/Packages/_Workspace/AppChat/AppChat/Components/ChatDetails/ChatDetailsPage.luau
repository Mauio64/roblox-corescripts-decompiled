local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local Logger = require(script.Parent.Logger)
local Cryo = require(parent.Cryo)
local React = require(parent.React)
local useCallback = React.useCallback
local memo = React.memo
local UIBlox = require(parent.UIBlox)
local Images = UIBlox.App.ImageSet.Images
local UIBlox2 = require(parent.UIBlox)
local useTextSizeOffset = UIBlox2.Core.Style.useTextSizeOffset

local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens

local SectionHeader = require(script.Parent.SectionHeader)
local GroupNameEntryCell = require(script.Parent.GroupNameEntryCell)
local AddFriendsEntry = require(script.Parent.AddFriendsEntry)
local ParticipantList = require(script.Parent.ParticipantList)
local LeaveGroupCell = require(script.Parent.LeaveGroupCell)
local SocialLibraries = require(AppChat.SocialLibraries)
local TestStyle = SocialLibraries.Components.TestStyle
local ConversationTypeCell = require(script.Parent.UnfilteredThreads.ConversationTypeCell)
local CreateUnfilteredChatCell = require(script.Parent.UnfilteredThreads.CreateUnfilteredChatCell)

local useIsAppChatVerticallyConstrained = require(AppChat.App.Hooks.useIsAppChatVerticallyConstrained)
local defineFastFlag = game:DefineFastFlag("AppChatDetailsPageAutomaticCanvasSize", false)
local FFlagDebugAppChatEnableDomLocators = require(AppChat.Flags.FFlagDebugAppChatEnableDomLocators)
local DomLocators = require(AppChat.Utils.DomLocators)

local useIsChatUserMessagesEnabled = require(AppChat.Hooks.useIsChatUserMessagesEnabled)

local v = {
	participants = {},
	localUserId = nil,
	conversation = nil,
	conversationId = nil,
	isGroupConversation = false,
	topBarHeight = 0,
	shouldShowCreateUnfilteredChat = false,
	shouldHideGroupChatFunctionality = false,
	shouldShowAddFriends = true,
	shouldShowConversationTypeInfo = true,
	navigateBack = function() end,
	conversationTitle = "PlaceholderTitle",
	pageHeaderText = "localizedText.ChatDetails",
	generalText = "localizedText.General",
	membersText = "localizedText.Members",
	addFriendsText = "localizedText.AddFriends",
	leaveGroupText = "localizedText.LeaveGroup",
	onlinePresenceText = "localizedText.OnlineText",
	offlinePresenceText = "localizedText.OfflineText",
	conversationTypeHeaderText = "Expressive Chat Features",
	conversationTypeText = "localizedText.ConversationTypeText",
	createUnfilteredChatText = "Create new chat without filters",
	createUnfilteredChatSubTitleText = "All members of this conversation will be invited, but some are not eligible to join.",
	onGroupNameEntryCellActivated = function(_)
		Logger:warning("onGroupNameEntryCellActivated was not passed to ChatDetailsPage")
	end,
	onAddFriendsCellActivated = function(_)
		Logger:warning("onAddFriendsCellActivated was not passed to ChatDetailsPage")
	end,
	onLeaveGroupCellActivated = function(_)
		Logger:warning("onLeaveGroupCellActivated was not passed to ChatDetailsPage")
	end,
	onParticipantCellActivated = function(_, _)
		Logger:warning("onParticipantCellActivated was not passed to ChatDetailsPage")
	end,
	onConversationTypeIconActivated = function(_)
		Logger:warning("onConversationTypeIconActivated was not passed to ChatDetailsPage")
	end,
	onCreateUnfilteredChatCellActivated = function(_)
		Logger:warning("onCreateUnfilteredChatCellActivated was not passed to ChatDetailsPage")
	end,
	LayoutOrder = 0,
	style = Cryo.Dictionary.join(TestStyle, {
		Tokens = {
			Color = { None = {} },
			Size = { Size_0 = 0 }
		}
	})
}

function ChatDetailsPage(p)
	local joined = Cryo.Dictionary.join(v, p)
	local style = joined.style
	local v2 = useTextSizeOffset()
	local v3 = useTokens().Size.Size_1200 + 2 * v2

	local v4 = useIsAppChatVerticallyConstrained()
	local v5 = {
		ChatGroupHeader = {
			marginTop = style.Tokens.Size.Size_0,
			marginBottom = style.Tokens.Size.Size_0
		},
		MembersHeader = {
			marginTop = style.Tokens.Size.Size_0,
			marginBottom = style.Tokens.Size.Size_0
		},
		GroupNameEntryCell = { paddingBottom = style.Tokens.Size.Size_0 }
	}

	local function onEntryActivated(p2, p3)
		Logger:info("onParticipantCellActivated: {}", p2.id)

		if p2.isLocalUser then
			return
		end

		joined.onParticipantCellActivated(p2.id, p3)
	end

	local onActivated3 = useCallback(function()
		joined.onCreateUnfilteredChatCellActivated(joined.conversation)
	end, { joined.conversation })

	local v6 = useCallback(function(_, p2, p3)
		if not joined.wideMode and p2 == Enum.SwipeDirection.Right and p3 == 1 then
			joined.navigateBack()
		end
	end)
	local count = 0

	local function onActivated()
		joined.onAddFriendsCellActivated(joined.conversation)
	end

	local function onActivated2()
		joined.onLeaveGroupCellActivated(joined.conversation)
	end

	local function fn()
		joined.onGroupNameEntryCellActivated(joined.conversation)
	end

	for _, _ in pairs(joined.participants) do
		count += 1
	end

	local v7 = useIsChatUserMessagesEnabled()
	local shouldShowAddFriends = joined.shouldShowAddFriends

	if shouldShowAddFriends then
		count += 1
	end

	local v8 = count * v3

	local v9 = v8 + 8 * v3

	local v10 = not v7

	local createElement = React.createElement
	local v11 = {
		AutoButtonColor = false,
		BackgroundColor3 = style.Theme.BackgroundDefault.Color,
		BorderSizePixel = 0,
		LayoutOrder = joined.LayoutOrder,
		Size = UDim2.new(1, 0, 1, 0),
		Text = "",
		Transparency = style.Tokens.Color.None.Transparency,
		[React.Event.TouchSwipe] = v6,
		Selectable = false
	}

	local createElement2 = React.createElement
	local v12 = {
		Size = UDim2.new(1, 0, 1, 0),
		CanvasSize = UDim2.new(1, 0, 0, defineFastFlag and 0 or v9),
		AutomaticCanvasSize = 0,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ScrollBarThickness = 0,
		LayoutOrder = 0,
		ScrollingDirection = 0,
		Selectable = false
	}
	local automaticCanvasSize

	if defineFastFlag then
		automaticCanvasSize = Enum.AutomaticSize.Y
	end

	v12.AutomaticCanvasSize = automaticCanvasSize

	v12.LayoutOrder = joined.LayoutOrder
	v12.ScrollingDirection = Enum.ScrollingDirection.Y

	local children = {
		UIListLayout = React.createElement("UIListLayout", {
			VerticalAlignment = Enum.VerticalAlignment.Top,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		ChatGroupHeader = 0,
		GroupNameEntryCell = 0,
		MembersHeader = 0,
		MembersFrame = 0,
		LeaveGroupCell = 0,
		ConversationTypeHeader = 0,
		ConversationTypeCell = 0,
		CreateUnfilteredChatCell = 0
	}

	local chatGroupHeader = joined.isGroupConversation

	if chatGroupHeader then
		local createElement3 = React.createElement
		local v13 = {
			marginTop = not v4 and 20 or v5.ChatGroupHeader.marginTop,
			marginBottom = 0,
			LayoutOrder = 1,
			Text = 0,
			style = 0
		}
		local marginBottom

		if v4 then
			marginBottom = v5.ChatGroupHeader.marginBottom
		end

		v13.marginBottom = marginBottom

		v13.Text = joined.chatGroupText
		v13.style = joined.style
		chatGroupHeader = createElement3(SectionHeader, v13)
	end

	children.ChatGroupHeader = chatGroupHeader

	local groupNameEntryCell = joined.isGroupConversation

	if groupNameEntryCell then
		local createElement3 = React.createElement
		local v13 = {
			LayoutOrder = 2,
			groupNameText = joined.conversationTitle,
			iconImage = Images["icons/actions/edit/edit"],
			isDisabled = joined.shouldHideGroupChatFunctionality or v10,
			cellHeight = v3,
			paddingBottom = 0,
			onActivated = 0,
			style = 0
		}
		local paddingBottom

		if v4 then
			paddingBottom = v5.GroupNameEntryCell.paddingBottom
		end

		v13.paddingBottom = paddingBottom
		v13.onActivated = fn
		v13.style = joined.style
		groupNameEntryCell = createElement3(GroupNameEntryCell, v13)
	end

	children.GroupNameEntryCell = groupNameEntryCell

	children.MembersHeader = React.createElement(SectionHeader, {
		LayoutOrder = 3,
		marginTop = not v4 and 14 or v5.MembersHeader.marginTop,
		marginBottom = not v4 and 8 or v5.MembersHeader.marginBottom,
		Text = joined.membersText,
		style = joined.style
	})

	local createElement3 = React.createElement
	local v13 = {
		Size = UDim2.new(1, 0, 0, v8),
		BackgroundColor3 = style.Theme.BackgroundDefault.Color,
		BackgroundTransparency = style.Tokens.Color.None.Transparency,
		BorderSizePixel = 0,
		LayoutOrder = 4
	}

	local v14 = {
		UIListLayout = React.createElement("UIListLayout", {
			VerticalAlignment = Enum.VerticalAlignment.Top,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		AddFriendsCell = 0,
		ParticipantList = 0
	}
	local addFriendsCell

	if shouldShowAddFriends then
		addFriendsCell = React.createElement(AddFriendsEntry, {
			LayoutOrder = 1,
			Text = joined.addFriendsText,
			iconImage = Images["icons/actions/edit/add"],
			cellHeight = v3,
			onActivated = onActivated,
			style = joined.style
		})
	end

	v14.AddFriendsCell = addFriendsCell

	v14.ParticipantList = React.createElement(ParticipantList, {
		activeParticipantId = joined.activeParticipantId,
		LayoutOrder = 2,
		entries = joined.participants,
		entryHeight = v3,
		onlinePresenceText = joined.onlinePresenceText,
		offlinePresenceText = joined.offlinePresenceText,
		childWidth = 120,
		onEntryActivated = onEntryActivated
	})
	children.MembersFrame = createElement3("Frame", v13, v14)

	local leaveGroupCell = joined.isGroupConversation

	if leaveGroupCell then
		local createElement4 = React.createElement
		local v15 = {
			LayoutOrder = 5,
			leaveGroupText = joined.leaveGroupText,
			iconImage = Images["icons/controls/vehicle/exit"],
			cellHeight = v3,
			onActivated = onActivated2,
			style = joined.style,
			testId = 0
		}
		local testId

		if FFlagDebugAppChatEnableDomLocators then
			testId = DomLocators.chatDetailsListActionButton("leaveGroup")
		end

		v15.testId = testId
		leaveGroupCell = createElement4(LeaveGroupCell, v15)
	end

	children.LeaveGroupCell = leaveGroupCell
	local conversationTypeHeader

	if v7 then
		conversationTypeHeader = React.createElement(SectionHeader, {
			LayoutOrder = 6,
			marginTop = 26,
			Text = joined.conversationTypeHeaderText,
			style = joined.style
		})
	end

	children.ConversationTypeHeader = conversationTypeHeader
	local conversationTypeCell

	if v7 then
		conversationTypeCell = React.createElement(ConversationTypeCell, {
			layoutOrder = 7,
			bodyText = joined.conversationTypeText,
			iconImage = Images["icons/actions/info"],
			onIconActivated = joined.onConversationTypeIconActivated,
			shouldShowIcon = joined.shouldShowConversationTypeInfo,
			style = joined.style
		})
	end

	children.ConversationTypeCell = conversationTypeCell
	local createUnfilteredChatCell

	if v7 and joined.shouldShowCreateUnfilteredChat then
		createUnfilteredChatCell = React.createElement(CreateUnfilteredChatCell, {
			layoutOrder = 8,
			bodyText = joined.createUnfilteredChatText,
			subTitleText = joined.createUnfilteredChatSubTitleText,
			iconImage = Images["icons/actions/edit/copy"],
			cellHeight = v3,
			isLoading = joined.isCreateUnfilteredChatLoading,
			conversationId = joined.conversationId,
			onActivated = onActivated3,
			style = joined.style
		})
	end

	children.CreateUnfilteredChatCell = createUnfilteredChatCell
	return createElement("TextButton", v11, {
		ScrollingContent = createElement2("ScrollingFrame", v12, children)
	})
end

return memo(ChatDetailsPage)
