local Logger = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatDetails/Logger")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local useCallback = React.useCallback
local memo = React.memo
local images = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UIBlox").App.ImageSet.Images
local useTextSizeOffset = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UIBlox").Core.Style.useTextSizeOffset

local useTokens = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Foundation").Hooks.useTokens

local SectionHeader = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatDetails/SectionHeader")
local module5 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatDetails/GroupNameEntryCell")
local AddFriendsEntry = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatDetails/AddFriendsEntry")
local module7 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatDetails/ParticipantList")
local module8 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatDetails/LeaveGroupCell")
local testStyle = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/SocialLibraries").Components.TestStyle
local module9 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatDetails/UnfilteredThreads/ConversationTypeCell")
local module10 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatDetails/UnfilteredThreads/CreateUnfilteredChatCell")

local useIsAppChatVerticallyConstrained = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/App/Hooks/useIsAppChatVerticallyConstrained")
local defineFastFlag = game:DefineFastFlag("AppChatDetailsPageAutomaticCanvasSize", false)
local FFlagDebugAppChatEnableDomLocators = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagDebugAppChatEnableDomLocators")
local DomLocators = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/DomLocators")

local useIsChatUserMessagesEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useIsChatUserMessagesEnabled")

local v5 = {
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
	onGroupNameEntryCellActivated = function(p2)
		Logger:warning("onGroupNameEntryCellActivated was not passed to ChatDetailsPage")
	end,
	onAddFriendsCellActivated = function(p2)
		Logger:warning("onAddFriendsCellActivated was not passed to ChatDetailsPage")
	end,
	onLeaveGroupCellActivated = function(p2)
		Logger:warning("onLeaveGroupCellActivated was not passed to ChatDetailsPage")
	end,
	onParticipantCellActivated = function(p2, p3)
		Logger:warning("onParticipantCellActivated was not passed to ChatDetailsPage")
	end,
	onConversationTypeIconActivated = function(p2)
		Logger:warning("onConversationTypeIconActivated was not passed to ChatDetailsPage")
	end,
	onCreateUnfilteredChatCellActivated = function(p2)
		Logger:warning("onCreateUnfilteredChatCellActivated was not passed to ChatDetailsPage")
	end,
	LayoutOrder = 0,
	style = Cryo.Dictionary.join(testStyle, {
		Tokens = {
			Color = { None = {} },
			Size = { Size_0 = 0 }
		}
	})
}

function LUAUFORGE_MODULE_GLOBALS_hDM_ChatDetailsPage(p2)
	local joined = Cryo.Dictionary.join(v5, p2)
	local style = joined.style
	local v6 = useTextSizeOffset()
	local v7 = useTokens().Size.Size_1200 + 2 * v6

	local v8 = useIsAppChatVerticallyConstrained()
	local v9 = {
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

	local function onEntryActivated(p3, p4)
		Logger:info("onParticipantCellActivated: {}", p3.id)

		if p3.isLocalUser then
			return
		end

		joined.onParticipantCellActivated(p3.id, p4)
	end

	local v10 = useCallback(function()
		joined.onCreateUnfilteredChatCellActivated(joined.conversation)
	end, { joined.conversation })

	local v11 = useCallback(function(p3, p4, p5)
		if not joined.wideMode and p4 == Enum.SwipeDirection.Right and p5 == 1 then
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

	for k, participant in pairs(joined.participants) do
		count += 1
	end

	local v12 = useIsChatUserMessagesEnabled()
	local shouldShowAddFriends = joined.shouldShowAddFriends

	if shouldShowAddFriends then
		count += 1
	end

	local v13 = count * v7

	local v14 = v13 + 8 * v7

	local v15 = not v12

	local createElement = React.createElement
	local v17 = {
		AutoButtonColor = false,
		BackgroundColor3 = style.Theme.BackgroundDefault.Color,
		BorderSizePixel = 0,
		LayoutOrder = joined.LayoutOrder,
		Size = UDim2.new(1, 0, 1, 0),
		Text = "",
		Transparency = style.Tokens.Color.None.Transparency,
		[React.Event.TouchSwipe] = v11,
		Selectable = false
	}

	local createElement2 = React.createElement
	local v20 = {
		Size = UDim2.new(1, 0, 1, 0),
		CanvasSize = UDim2.new(1, 0, 0, defineFastFlag and 0 or v14),
		AutomaticCanvasSize = 0,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ScrollBarThickness = 0,
		LayoutOrder = 0,
		ScrollingDirection = 0,
		Selectable = false
	}

	local v21 = if defineFastFlag then Enum.AutomaticSize.Y else nil
	v20.AutomaticCanvasSize = v21

	v20.LayoutOrder = joined.LayoutOrder
	v20.ScrollingDirection = Enum.ScrollingDirection.Y

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

	local v22 = joined.isGroupConversation

	if v22 then
		local createElement3 = React.createElement
		local v24 = {
			marginTop = not v8 and 20 or v9.ChatGroupHeader.marginTop,
			marginBottom = 0,
			LayoutOrder = 1,
			Text = 0,
			style = 0
		}
		local v25 = if v8 then v9.ChatGroupHeader.marginBottom else nil
		v24.marginBottom = v25

		v24.Text = joined.chatGroupText
		v24.style = joined.style
		v22 = createElement3(SectionHeader, v24)
	end

	children.ChatGroupHeader = v22

	local v23 = joined.isGroupConversation

	if v23 then
		local createElement3 = React.createElement
		local v25 = {
			LayoutOrder = 2,
			groupNameText = joined.conversationTitle,
			iconImage = images["icons/actions/edit/edit"],
			isDisabled = joined.shouldHideGroupChatFunctionality or v15,
			cellHeight = v7,
			paddingBottom = 0,
			onActivated = 0,
			style = 0
		}

		local v26 = if v8 then v9.GroupNameEntryCell.paddingBottom else nil
		v25.paddingBottom = v26
		v25.onActivated = fn
		v25.style = joined.style
		v23 = createElement3(module5, v25)
	end

	children.GroupNameEntryCell = v23

	children.MembersHeader = React.createElement(SectionHeader, {
		LayoutOrder = 3,
		marginTop = not v8 and 14 or v9.MembersHeader.marginTop,
		marginBottom = not v8 and 8 or v9.MembersHeader.marginBottom,
		Text = joined.membersText,
		style = joined.style
	})

	local createElement3 = React.createElement
	local v25 = {
		Size = UDim2.new(1, 0, 0, v13),
		BackgroundColor3 = style.Theme.BackgroundDefault.Color,
		BackgroundTransparency = style.Tokens.Color.None.Transparency,
		BorderSizePixel = 0,
		LayoutOrder = 4
	}

	local v26 = {
		UIListLayout = React.createElement("UIListLayout", {
			VerticalAlignment = Enum.VerticalAlignment.Top,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		AddFriendsCell = 0,
		ParticipantList = 0
	}

	local v27 = if shouldShowAddFriends then React.createElement(AddFriendsEntry, {
		LayoutOrder = 1,
		Text = joined.addFriendsText,
		iconImage = images["icons/actions/edit/add"],
		cellHeight = v7,
		onActivated = onActivated,
		style = joined.style
	}) else nil
	v26.AddFriendsCell = v27

	v26.ParticipantList = React.createElement(module7, {
		activeParticipantId = joined.activeParticipantId,
		LayoutOrder = 2,
		entries = joined.participants,
		entryHeight = v7,
		onlinePresenceText = joined.onlinePresenceText,
		offlinePresenceText = joined.offlinePresenceText,
		childWidth = 120,
		onEntryActivated = onEntryActivated
	})
	children.MembersFrame = createElement3("Frame", v25, v26)

	local v28 = joined.isGroupConversation

	if v28 then
		local createElement4 = React.createElement
		local v30 = {
			LayoutOrder = 5,
			leaveGroupText = joined.leaveGroupText,
			iconImage = images["icons/controls/vehicle/exit"],
			cellHeight = v7,
			onActivated = onActivated2,
			style = joined.style,
			testId = 0
		}

		local v31 = if FFlagDebugAppChatEnableDomLocators then DomLocators.chatDetailsListActionButton("leaveGroup") else nil
		v30.testId = v31
		v28 = createElement4(module8, v30)
	end

	children.LeaveGroupCell = v28

	local v29 = if v12 then React.createElement(SectionHeader, {
		LayoutOrder = 6,
		marginTop = 26,
		Text = joined.conversationTypeHeaderText,
		style = joined.style
	}) else nil
	children.ConversationTypeHeader = v29

	local v30 = if v12 then React.createElement(module9, {
		layoutOrder = 7,
		bodyText = joined.conversationTypeText,
		iconImage = images["icons/actions/info"],
		onIconActivated = joined.onConversationTypeIconActivated,
		shouldShowIcon = joined.shouldShowConversationTypeInfo,
		style = joined.style
	}) else nil
	children.ConversationTypeCell = v30

	local v31 = if v12 and joined.shouldShowCreateUnfilteredChat then React.createElement(module10, {
		layoutOrder = 8,
		bodyText = joined.createUnfilteredChatText,
		subTitleText = joined.createUnfilteredChatSubTitleText,
		iconImage = images["icons/actions/edit/copy"],
		cellHeight = v7,
		isLoading = joined.isCreateUnfilteredChatLoading,
		conversationId = joined.conversationId,
		onActivated = v10,
		style = joined.style
	}) else nil
	children.CreateUnfilteredChatCell = v31
	return createElement("TextButton", v17, {
		ScrollingContent = createElement2("ScrollingFrame", v20, children)
	})
end

return memo(LUAUFORGE_MODULE_GLOBALS_hDM_ChatDetailsPage)
