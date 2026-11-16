local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local EnumScreens = require(AppChat.EnumScreens)
local NetworkingFriends = require(AppChat.Http.NetworkingFriends)
require(AppChat.types)
local useAppPolicy = require(AppChat.Hooks.useAppPolicy)
local useIsExternalNavigationAvailable = require(AppChat.Hooks.useIsExternalNavigationAvailable)
local Conversation = require(AppChat.Models.Conversation)

local Cryo = require(parent.Cryo)
local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local InputHandlers = require(parent.InputHandlers)
local React = require(parent.React)
require(parent.ReactFocusNavigation)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local RoactUtils2 = require(parent.RoactUtils)
local useSelector = RoactUtils2.Hooks.RoactRodux.useSelector

local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local FocusNavigableSurfaceWrapper = FocusNavigationUtils.FocusNavigableSurfaceWrapper
local AppFocusRoot = FocusNavigationUtils.AppFocusRoot
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local FFlagAppChatMigrateFriendshipStatuses = require(AppChat.Flags.FFlagAppChatMigrateFriendshipStatuses)
local FriendsHydrationReact = require(parent.FriendsHydrationReact)
local useGetFriendshipStatus = FriendsHydrationReact.useGetFriendshipStatus

local memo = React.memo

local ParticipantDialogDeprecated = require(script.Parent.ParticipantDialogDeprecated)
local PlayerContextualMenuWrapper = require(script.Parent.PlayerContextualMenuWrapper)

local v = {
	conversationId = nil,
	participantId = nil,
	showRemoveUserButton = false,
	isWideMode = false,
	viewProfileText = "Feature.Chat.Label.ViewProfile",
	chatText = "CommonUI.Features.Label.Chat",
	reportUserText = "Feature.Chat.Action.ReportUser",
	removeFromGroupText = "Feature.Chat.Action.RemoveFromGroup",
	cancelText = "Feature.Chat.Action.Cancel",
	openViewProfile = nil,
	openChat = nil,
	openReportUser = nil,
	openRemoveUserDialog = nil,
	onDismiss = function() end
}

local v2 = { skipFetch = true }

function ParticipantDialogContainerDeprecated(p)
	local joined = Cryo.Dictionary.join(v, p)
	local showViewProfileButton = useAppPolicy(function(p2)
		return p2.getChatViewProfileOption()
	end)

	local v3 = useSelector(function(p2)
		local conversations = p2.ChatAppReducer and p2.ChatAppReducer.Conversations
		local v3 = conversations and conversations[joined.conversationId]
		return v3 and v3.conversationType == Conversation.Type.MULTI_USER_CONVERSATION
	end)

	local v4 = useDispatch()
	local v5

	if FFlagAppChatMigrateFriendshipStatuses then
		local participantId = joined.participantId
		local v6

		if not v3 then
			v6 = v2
		end

		v5 = useGetFriendshipStatus(participantId, v6) == Enum.FriendStatus.Friend
	else
		v5 = useSelector(function(p2)
			local friends = p2.ChatAppReducer and p2.ChatAppReducer.Friends
			local friendshipStatus = friends and friends.friendshipStatus
			return friendshipStatus and friendshipStatus[joined.participantId] == Enum.FriendStatus.Friend
		end)

		React.useEffect(function()
			if v3 then
				v4(NetworkingFriends.GetExtendedFriendshipStatus.API({
					targetUserId = joined.participantId
				}))
			end
		end, { joined.participantId, v4, v3 })
	end

	local v6 = useLocalization({
		viewProfileText = joined.viewProfileText,
		chatText = joined.chatText,
		reportUserText = joined.reportUserText,
		removeFromGroupText = joined.removeFromGroupText,
		cancelText = joined.cancelText
	})

	local v7 = useIsExternalNavigationAvailable({ EnumScreens.ViewUserProfile })

	local customEventHandlers = React.useMemo(function()
		local v8 = {}
		v8[FocusNavigationEventNameEnum.NavigateBack] = {
			handler = InputHandlers.onRelease(function(object)
				joined.onDismiss()
				object:cancel()
			end)
		}

		return v8
	end, { joined.onDismiss })
	local joined2 = Cryo.Dictionary.join(joined, v6, {
		showViewProfileButton = showViewProfileButton,
		showChatButton = v3 and v5 and true or false,
		isWideMode = joined.isWideMode
	})

	if v7[EnumScreens.ViewUserProfile] then
		return React.createElement(FocusNavigableSurfaceWrapper, {
			customEventHandlers = customEventHandlers,
			isAutoFocusRoot = true,
			isFocusable = true,
			isIsolated = true,
			surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.PopUp
		}, { React.createElement(ParticipantDialogDeprecated, joined2) })
	end

	return React.createElement(AppFocusRoot, {
		customEventHandlers = customEventHandlers,
		isAutoFocusRoot = true,
		isFocusable = true,
		isIsolated = true,
		shouldRestoreFocus = false,
		surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.PopUp
	}, { React.createElement(PlayerContextualMenuWrapper, {
			conversationId = joined.conversationId,
			participantId = joined.participantId,
			onDismiss = joined.onDismiss,
			openRemoveUserDialog = joined.openRemoveUserDialog,
			removeFromGroupText = v6.removeFromGroupText,
			openReportUser = joined.openReportUser,
			showRemoveUserButton = joined.showRemoveUserButton,
			openBlockingModal = joined.openBlockingModal
		}) })
end

return memo(ParticipantDialogContainerDeprecated)
