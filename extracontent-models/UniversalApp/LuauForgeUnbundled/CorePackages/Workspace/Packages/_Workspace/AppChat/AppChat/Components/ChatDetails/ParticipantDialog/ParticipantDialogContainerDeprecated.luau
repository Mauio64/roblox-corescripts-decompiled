local EnumScreens = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/EnumScreens")
local NetworkingBlocking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Http/NetworkingBlocking")
require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/types")
local module3 = require("@luauforge/bundled/fNh")
local useIsExternalNavigationAvailable = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useIsExternalNavigationAvailable")
local Conversation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Models/Conversation")

local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/FocusNavigationUtils")
local InputHandlers = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/InputHandlers")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/ReactFocusNavigation")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Localization").Hooks.useLocalization
local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactUtils").Hooks.RoactRodux.useDispatch
local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactUtils").Hooks.RoactRodux.useSelector

local focusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local focusNavigableSurfaceWrapper = FocusNavigationUtils.FocusNavigableSurfaceWrapper
local appFocusRoot = FocusNavigationUtils.AppFocusRoot
local focusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local FFlagAppChatMigrateFriendshipStatuses = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatMigrateFriendshipStatuses")
local useGetFriendshipStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/FriendsHydrationReact").useGetFriendshipStatus

local memo = React.memo

local ParticipantDialogDeprecated = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatDetails/ParticipantDialog/ParticipantDialogDeprecated")
local PlayerContextualMenuWrapper = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatDetails/ParticipantDialog/PlayerContextualMenuWrapper")

local v5 = {
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

local v6 = { skipFetch = true }

function LUAUFORGE_MODULE_GLOBALS_hoR_ParticipantDialogContainerDeprecated(p2)
	local joined = Cryo.Dictionary.join(v5, p2)
	local v7 = module3(function(p3)
		return p3.getChatViewProfileOption()
	end)

	local v8 = useSelector(function(p3)
		local conversations = p3.ChatAppReducer and p3.ChatAppReducer.Conversations
		local v9 = conversations and conversations[joined.conversationId]
		return v9 and v9.conversationType == Conversation.Type.MULTI_USER_CONVERSATION
	end)

	local v9 = useDispatch()
	local v10

	if FFlagAppChatMigrateFriendshipStatuses then
		local participantId = joined.participantId
		local v12 = if not v8 then v6 else nil
		v10 = useGetFriendshipStatus(participantId, v12) == Enum.FriendStatus.Friend
	else
		v10 = useSelector(function(p3)
			local friends = p3.ChatAppReducer and p3.ChatAppReducer.Friends
			local friendshipStatus = friends and friends.friendshipStatus
			return friendshipStatus and friendshipStatus[joined.participantId] == Enum.FriendStatus.Friend
		end)

		React.useEffect(function()
			if v8 then
				v9(NetworkingBlocking.GetExtendedFriendshipStatus.API({
					targetUserId = joined.participantId
				}))
			end
		end, { joined.participantId, v9, v8 })
	end

	local v11 = useLocalization({
		viewProfileText = joined.viewProfileText,
		chatText = joined.chatText,
		reportUserText = joined.reportUserText,
		removeFromGroupText = joined.removeFromGroupText,
		cancelText = joined.cancelText
	})

	local v12 = useIsExternalNavigationAvailable({ EnumScreens.ViewUserProfile })

	local v13 = React.useMemo(function()
		local v14 = {}
		v14[focusNavigationEventNameEnum.NavigateBack] = {
			handler = InputHandlers.onRelease(function(object)
				joined.onDismiss()
				object:cancel()
			end)
		}

		return v14
	end, { joined.onDismiss })
	local joined2 = Cryo.Dictionary.join(joined, v11, {
		showViewProfileButton = v7,
		showChatButton = v8 and v10 and true or false,
		isWideMode = joined.isWideMode
	})

	if v12[EnumScreens.ViewUserProfile] then
		return React.createElement(focusNavigableSurfaceWrapper, {
			customEventHandlers = v13,
			isAutoFocusRoot = true,
			isFocusable = true,
			isIsolated = true,
			surfaceIdentifier = focusNavigableSurfaceIdentifierEnum.PopUp
		}, { React.createElement(ParticipantDialogDeprecated, joined2) })
	end

	return React.createElement(appFocusRoot, {
		customEventHandlers = v13,
		isAutoFocusRoot = true,
		isFocusable = true,
		isIsolated = true,
		shouldRestoreFocus = false,
		surfaceIdentifier = focusNavigableSurfaceIdentifierEnum.PopUp
	}, { React.createElement(PlayerContextualMenuWrapper, {
			conversationId = joined.conversationId,
			participantId = joined.participantId,
			onDismiss = joined.onDismiss,
			openRemoveUserDialog = joined.openRemoveUserDialog,
			removeFromGroupText = v11.removeFromGroupText,
			openReportUser = joined.openReportUser,
			showRemoveUserButton = joined.showRemoveUserButton,
			openBlockingModal = joined.openBlockingModal
		}) })
end

return memo(LUAUFORGE_MODULE_GLOBALS_hoR_ParticipantDialogContainerDeprecated)
