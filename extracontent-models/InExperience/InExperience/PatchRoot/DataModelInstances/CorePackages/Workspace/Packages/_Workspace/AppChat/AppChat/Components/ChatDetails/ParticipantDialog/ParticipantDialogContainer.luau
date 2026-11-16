local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local BackHandlerContext = require(AppChat.Contexts.BackHandlerContext)
local EnumScreens = require(AppChat.EnumScreens)
require(AppChat.types)
local useAppPolicy = require(AppChat.Hooks.useAppPolicy)
local useIsExternalNavigationAvailable = require(AppChat.Hooks.useIsExternalNavigationAvailable)
local Conversation = require(AppChat.Models.Conversation)

local Cryo = require(parent.Cryo)
local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local InputHandlers = require(parent.InputHandlers)
local NotificationModalsManager = require(parent.NotificationModalsManager)
local React = require(parent.React)
require(parent.ReactFocusNavigation)
local SharedFlags = require(parent.SharedFlags)
local FriendsHydrationReact = require(parent.FriendsHydrationReact)
local useGetFriendshipStatus = FriendsHydrationReact.useGetFriendshipStatus
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local RoactUtils2 = require(parent.RoactUtils)
local useSelector = RoactUtils2.Hooks.RoactRodux.useSelector
local Navigation = require(parent.Navigation)
local useNavigation = Navigation.useNavigation
local SocialCommon = require(parent.SocialCommon)
local SocialLuaAnalytics = require(parent.SocialLuaAnalytics)

local NetworkingFriends = require(AppChat.Http.NetworkingFriends)

local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local FocusNavigableSurfaceWrapper = FocusNavigationUtils.FocusNavigableSurfaceWrapper
local AppFocusRoot = FocusNavigationUtils.AppFocusRoot
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum

local FFlagDisableBlockAndReport = SharedFlags.FFlagDisableBlockAndReport
local FFlagAppChatMigrateFriendshipStatuses = require(AppChat.Flags.FFlagAppChatMigrateFriendshipStatuses)

local memo = React.memo

local GenericDialogType = require(script.Parent.Parent.Dialogs.GenericDialogType)
local ParticipantDialog = require(script.Parent.ParticipantDialog)
local PlayerContextualMenuWrapper = require(script.Parent.PlayerContextualMenuWrapper)
local useTrustedFriendAction = require(script.Parent.useTrustedFriendAction)
local connectAnalytics = require(AppChat.LegacyAnalytics.connectAnalytics)
local RoactChatAnalytics = require(AppChat.LegacyAnalytics.RoactChatAnalytics)
local createConversation = require(AppChat.Conversations.Thunks.createConversation)
local parseCreateConversationErrors = require(AppChat.Conversations.Thunks.parseCreateConversationErrors)
local ChatEntryPointNames = SocialCommon.Enums.ChatEntryPointNames
local Actions = require(AppChat.Actions)
local EnteredChatFromEntryPoint = Actions.EnteredChatFromEntryPoint
local Logger = require(script.Parent.Logger)

local Sources = SocialLuaAnalytics.Analytics.Enums.Sources

local v = { skipFetch = true }

local v2 = {
	conversationId = nil,
	participantId = nil,
	anchorRef = nil,
	showRemoveUserButton = false,
	isWideMode = false,
	navigateToDialog = function() end,
	viewProfileText = "Feature.Chat.Label.ViewProfile",
	chatText = "CommonUI.Features.Label.Chat",
	reportUserText = "Feature.Chat.Action.ReportUser",
	removeFromGroupText = "Feature.Chat.Action.RemoveFromGroup",
	onDismiss = function() end,
	openBlockingModal = nil,
	analytics = nil
}

function ParticipantDialogContainer(p)
	local joined = Cryo.Dictionary.join(v2, p)
	local v3 = React.useContext(BackHandlerContext)
	local ref = React.useRef(joined.onDismiss)
	ref.current = joined.onDismiss
	React.useLayoutEffect(function()
		return v3(function()
			ref.current()
		end)
	end, { v3 })

	local v4 = useNavigation()
	local v5 = useDispatch()
	local navigateToDialog = joined.navigateToDialog or function() end

	local showViewProfileButton = useAppPolicy(function(p2)
		return p2.getChatViewProfileOption()
	end)

	local v6 = useSelector(function(p2)
		local conversations = p2.ChatAppReducer and p2.ChatAppReducer.Conversations
		local v6 = conversations and conversations[joined.conversationId]
		return v6 and v6.conversationType == Conversation.Type.MULTI_USER_CONVERSATION
	end)
	local v7

	if FFlagAppChatMigrateFriendshipStatuses then
		local participantId = joined.participantId
		local v8

		if not v6 then
			v8 = v
		end

		v7 = useGetFriendshipStatus(participantId, v8) == Enum.FriendStatus.Friend
	else
		v7 = useSelector(function(p2)
			local friends = p2.ChatAppReducer and p2.ChatAppReducer.Friends
			local friendshipStatus = friends and friends.friendshipStatus
			return friendshipStatus and friendshipStatus[joined.participantId] == Enum.FriendStatus.Friend
		end)

		React.useEffect(function()
			if v6 then
				v5(NetworkingFriends.GetExtendedFriendshipStatus.API({
					targetUserId = joined.participantId
				}))
			end
		end, { joined.participantId, v5, v6 })
	end

	local v8 = useLocalization({
		viewProfileText = joined.viewProfileText,
		chatText = joined.chatText,
		reportUserText = joined.reportUserText,
		removeFromGroupText = joined.removeFromGroupText,
		chatUnavailableWithUser = "Feature.Chat.Message.ChatUnavailableWithUser",
		networkErrorText = "Feature.Toast.NetworkingError.SomethingIsWrong"
	})

	local v9 = useIsExternalNavigationAvailable({ EnumScreens.ViewUserProfile })[EnumScreens.ViewUserProfile]

	local v10 = useTrustedFriendAction(joined.participantId)
	local action = v10.action
	local refetch = v10.refetch
	local showTrustedFriendButton = v9 and action ~= nil
	local isTrustedFriendButtonDisabled

	if action == nil then
		isTrustedFriendButtonDisabled = false
	else
		isTrustedFriendButtonDisabled = action.isDisabled
	end

	local actionText = v10.actionText

	local customEventHandlers = React.useMemo(function()
		local v11 = {}
		v11[FocusNavigationEventNameEnum.NavigateBack] = {
			handler = InputHandlers.onRelease(function(object)
				joined.onDismiss()
				object:cancel()
			end)
		}

		return v11
	end, { joined.onDismiss })

	local openRemoveUserDialog = React.useCallback(function(participantId, conversationId)
		Logger:info("User activated removeFromGroup | userId: {}, conversationId: {}", participantId, conversationId)
		joined.onDismiss()
		navigateToDialog(GenericDialogType.RemoveUserDialog, {
			conversationId = conversationId,
			participantId = participantId
		})
	end, { joined.onDismiss, navigateToDialog })

	local openViewProfile = React.useCallback(function(p2)
		local v11 = v4.getScreenProps("navigateToLuaAppPages", {})[EnumScreens.ViewUserProfile]

		if not v11 then
			Logger:warning("UserProfile page was not set in navigateToLuaAppPages screenProps")

			return
		end

		Logger:info("Navigate To UserProfile from {screen}")

		if joined.analytics then
			joined.analytics:navigate(RoactChatAnalytics.NavigationEvents.ChatDetailsProfile)
		end

		joined.onDismiss()
		v11(p2, {})
	end, { v4, joined.analytics, joined.onDismiss })

	local openTrustedFriend = React.useCallback(function()
		if action == nil then
			return
		end

		if action.actionType == "RemoveTrustedConnection" then
			joined.onDismiss()
			v5(NetworkingFriends.RemoveTC.API(joined.participantId)):andThen(function()
				refetch()
				NotificationModalsManager.SetUIBloxToast({
					sequenceNumber = DateTime.now().UnixTimestamp,
					toastTitle = v10.toastText
				})
			end):catch(function(p2)
				Logger:warning(
					"Error removing trusted connection for userId {}: {}",
					joined.participantId,
					(tostring(p2))
				)
			end)
		else
			local modalVariantOverride = action.modalVariantOverride
			joined.onDismiss()

			if action.actionType == "AddIncomingTrustedConnection" then
				local v11 = { userId = joined.participantId, onRequestAccepted = refetch }

				v4.navigate(EnumScreens.TrustedConnectionsUpsell, v11)
			else
				local v11 = {
					userId = joined.participantId,
					source = Sources.ChatDetails,
					modalVariantOverride = modalVariantOverride,
					onRequestSent = refetch
				}

				v4.navigate(EnumScreens.TrustedConnectionsUpsell, v11)
			end
		end
	end, { action, v10, joined.participantId, joined.onDismiss, v5, refetch, v4 })

	local openChat = React.useCallback(function(p2)
		Logger:info("User activated openChat | userId: {}", p2)
		v5(EnteredChatFromEntryPoint(ChatEntryPointNames.ChatDetailsParticipantDialog))
		joined.onDismiss()
		v5(createConversation("one_to_one", { (tostring(p2)) })):andThen(function(p3)
			v4.navigate(EnumScreens.ChatConversation, { conversationId = p3.id })
		end):catch(function(p3)
			Logger:warning("Error creating 1:1 conversation for userId {}: {}", p2, (tostring(p3)))
			local toastTitle

			if parseCreateConversationErrors(p3) == "participant_chat_disabled" then
				toastTitle = v8.chatUnavailableWithUser
			else
				toastTitle = v8.networkErrorText
			end

			v4.navigate(EnumScreens.RoactChatToast, {
				toastProps = {
					toastContent = { toastTitle = toastTitle }
				}
			})
		end)
	end, { v5, v4, joined.onDismiss, v8 })

	local openReportUser = React.useCallback(function(participantId, conversationId)
		joined.onDismiss()
		v4.navigate(EnumScreens.AppChatReportAbuse, {
			participantId = participantId,
			conversationId = conversationId
		})
	end, { v4, joined.onDismiss })

	local openBlockingModal = React.useCallback(function(p2, conversationId)
		local function fn()
			v4.pop()
			v4.navigate(EnumScreens.AppChatReportAbuse, {
				participantId = p2,
				conversationId = conversationId
			})
		end

		joined.onDismiss()
		v4.navigate(EnumScreens.BlockingModal, {
			navProps = {
				userId = p2,
				openReportUser = fn,
				disableReportOption = FFlagDisableBlockAndReport
			}
		})
	end, { v4, joined.onDismiss })

	local joined2 = Cryo.Dictionary.join(joined, v8, {
		showViewProfileButton = showViewProfileButton,
		showChatButton = v6 and v7 and true or false,
		showTrustedFriendButton = showTrustedFriendButton,
		trustedFriendText = actionText,
		isTrustedFriendButtonDisabled = isTrustedFriendButtonDisabled,
		openViewProfile = openViewProfile,
		openTrustedFriend = openTrustedFriend,
		openChat = openChat,
		openReportUser = openReportUser,
		openRemoveUserDialog = openRemoveUserDialog
	})

	if v9 then
		return React.createElement(FocusNavigableSurfaceWrapper, {
			customEventHandlers = customEventHandlers,
			isAutoFocusRoot = true,
			isFocusable = true,
			isIsolated = true,
			surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.PopUp
		}, { React.createElement(ParticipantDialog, joined2) })
	end

	local createElement = React.createElement
	local v11 = {
		customEventHandlers = customEventHandlers,
		isAutoFocusRoot = true,
		isFocusable = true,
		isIsolated = true,
		shouldRestoreFocus = false,
		surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.PopUp
	}

	local createElement2 = React.createElement
	local v12 = {
		conversationId = joined.conversationId,
		participantId = joined.participantId,
		onDismiss = joined.onDismiss,
		openRemoveUserDialog = openRemoveUserDialog,
		removeFromGroupText = v8.removeFromGroupText,
		openReportUser = openReportUser,
		showRemoveUserButton = joined.showRemoveUserButton,
		openBlockingModal = 0
	}

	if joined.openBlockingModal then
		openBlockingModal = joined.openBlockingModal
	end

	v12.openBlockingModal = openBlockingModal
	return createElement(AppFocusRoot, v11, { createElement2(PlayerContextualMenuWrapper, v12) })
end

ParticipantDialogContainer = connectAnalytics(function(analytics)
	return { analytics = analytics }
end)(ParticipantDialogContainer)

return memo(ParticipantDialogContainer)
