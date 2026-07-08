local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local EnumScreens = require(AppChat.EnumScreens)
local NetworkingFriends = require(AppChat.Http.NetworkingFriends)

require(AppChat.types)

local useAppPolicy = require(AppChat.Hooks.useAppPolicy)
local useIsExternalNavigationAvailable = require(AppChat.Hooks.useIsExternalNavigationAvailable)
local Conversation = require(AppChat.Models.Conversation)
local Cryo = require(AppChatParent.Cryo)
local FocusNavigationUtils = require(AppChatParent.FocusNavigationUtils)
local InputHandlers = require(AppChatParent.InputHandlers)
local React = require(AppChatParent.React)

require(AppChatParent.ReactFocusNavigation)

local useLocalization = require(AppChatParent.Localization).Hooks.useLocalization
local useDispatch = require(AppChatParent.RoactUtils).Hooks.RoactRodux.useDispatch
local useSelector = require(AppChatParent.RoactUtils).Hooks.RoactRodux.useSelector
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local FocusNavigableSurfaceWrapper = FocusNavigationUtils.FocusNavigableSurfaceWrapper
local AppFocusRoot = FocusNavigationUtils.AppFocusRoot
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local FFlagEnableChatDetailsOpenChat = require(AppChat.Flags.FFlagEnableChatDetailsOpenChat)
local memo = React.memo
local ParticipantDialogDeprecated = require(script.Parent.ParticipantDialogDeprecated)
local PlayerContextualMenuWrapper = require(script.Parent.PlayerContextualMenuWrapper)
local t1 = {
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
	onDismiss = function() -- line: 69
	end
}

function ParticipantDialogContainerDeprecated(t2: {[any]: any}) -- line: 73
	-- upvalues: Cryo (copy), t1 (copy), useAppPolicy (copy), FFlagEnableChatDetailsOpenChat (copy), useSelector (copy), Conversation (copy), useDispatch (copy), React (copy), NetworkingFriends (copy), useLocalization (copy), useIsExternalNavigationAvailable (copy), EnumScreens (copy), FocusNavigationEventNameEnum (copy), InputHandlers (copy), AppFocusRoot (copy), FocusNavigableSurfaceIdentifierEnum (copy), PlayerContextualMenuWrapper (copy), FocusNavigableSurfaceWrapper (copy), ParticipantDialogDeprecated (copy)
	local v25 = Cryo.Dictionary.join(t1, t2)
	local v26 = useAppPolicy(function(p1) -- line: 75
		return p1.getChatViewProfileOption()
	end)
	local u27 = nil
	local u28 = nil
	local v29 = false

	if FFlagEnableChatDetailsOpenChat then
		u27 = useSelector(function(p2) -- line: 85
			-- upvalues: v25 (copy), Conversation (copy)
			local v37 = p2.ChatAppReducer and p2.ChatAppReducer.Conversations
			local v38 = v37 and v37[v25.conversationId]

			return v38 and v38.conversationType == Conversation.Type.MULTI_USER_CONVERSATION
		end)
		u28 = useDispatch()

		local v30 = useSelector(function(p3) -- line: 93
			-- upvalues: v25 (copy)
			local v40 = p3.ChatAppReducer and p3.ChatAppReducer.Friends
			local v41 = v40 and v40.friendshipStatus

			return v41 and v41[v25.participantId] == Enum.FriendStatus.Friend
		end)

		React.useEffect(function() -- line: 99
			-- upvalues: u27 (ref), u28 (ref), NetworkingFriends (copy), v25 (copy)
			if u27 then
				u28(NetworkingFriends.GetExtendedFriendshipStatus.API({
					targetUserId = v25.participantId
				}))
			end
		end, {
			v25.participantId,
			u28,
			u27
		})
		v29 = not not u27 and not not v30
	end

	local v31 = useLocalization({
		viewProfileText = v25.viewProfileText,
		chatText = if not FFlagEnableChatDetailsOpenChat then nil else v25.chatText,
		reportUserText = v25.reportUserText,
		removeFromGroupText = v25.removeFromGroupText,
		cancelText = v25.cancelText
	})
	local v32 = useIsExternalNavigationAvailable({ EnumScreens.ViewUserProfile })
	local v33 = React.useMemo(function() -- line: 122
		-- upvalues: FocusNavigationEventNameEnum (copy), InputHandlers (copy), v25 (copy)
		return {
			[FocusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(p4) -- line: 125
					-- upvalues: v25 (copy)
					v25.onDismiss()
					p4:cancel()
				end)
			}
		}
	end, { v25.onDismiss })
	local v34 = Cryo.Dictionary.join(v25, v31, {
		showViewProfileButton = v26,
		showChatButton = v29,
		isWideMode = v25.isWideMode
	})

	if not v32[EnumScreens.ViewUserProfile] then
		return React.createElement(AppFocusRoot, {
			isAutoFocusRoot = true,
			isFocusable = true,
			isIsolated = true,
			shouldRestoreFocus = false,
			customEventHandlers = v33,
			surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.PopUp
		}, { React.createElement(PlayerContextualMenuWrapper, {
			conversationId = v25.conversationId,
			participantId = v25.participantId,
			onDismiss = v25.onDismiss,
			openRemoveUserDialog = v25.openRemoveUserDialog,
			removeFromGroupText = v31.removeFromGroupText,
			openReportUser = v25.openReportUser,
			showRemoveUserButton = v25.showRemoveUserButton,
			openBlockingModal = v25.openBlockingModal
		}) })
	end

	return React.createElement(FocusNavigableSurfaceWrapper, {
		isAutoFocusRoot = true,
		isFocusable = true,
		isIsolated = true,
		customEventHandlers = v33,
		surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.PopUp
	}, { React.createElement(ParticipantDialogDeprecated, v34) })
end

return memo(ParticipantDialogContainerDeprecated)
