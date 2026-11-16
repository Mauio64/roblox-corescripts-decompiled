local BackHandlerContext = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Contexts/BackHandlerContext")
local EnumScreens = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/EnumScreens")
require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/types")
local module3 = require("@luauforge/bundled/gsb")
local useIsExternalNavigationAvailable = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useIsExternalNavigationAvailable")
local Conversation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Models/Conversation")

local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/FocusNavigationUtils")
local InputHandlers = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/InputHandlers")
local NotificationModalsManager = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/NotificationModalsManager")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/ReactFocusNavigation")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags")
local useGetFriendshipStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/FriendsHydrationReact").useGetFriendshipStatus
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Localization").Hooks.useLocalization
local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactUtils").Hooks.RoactRodux.useDispatch
local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactUtils").Hooks.RoactRodux.useSelector
local useNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Navigation").useNavigation
local SocialCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SocialCommon")
local SocialLuaAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SocialLuaAnalytics")

local NetworkingBlocking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Http/NetworkingBlocking")

local focusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local focusNavigableSurfaceWrapper = FocusNavigationUtils.FocusNavigableSurfaceWrapper
local appFocusRoot = FocusNavigationUtils.AppFocusRoot
local focusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum

local fFlagDisableBlockAndReport = SharedFlags.FFlagDisableBlockAndReport
local FFlagAppChatMigrateFriendshipStatuses = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatMigrateFriendshipStatuses")

local memo = React.memo

local GenericDialogType = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatDetails/Dialogs/GenericDialogType")
local ParticipantDialog = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatDetails/ParticipantDialog/ParticipantDialog")
local PlayerContextualMenuWrapper = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatDetails/ParticipantDialog/PlayerContextualMenuWrapper")
local useTrustedFriendAction = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatDetails/ParticipantDialog/useTrustedFriendAction")
local connectAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/LegacyAnalytics/connectAnalytics")
local RoactChatAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/LegacyAnalytics/RoactChatAnalytics")
local createConversation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Thunks/createConversation")
local parseCreateConversationErrors = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Thunks/parseCreateConversationErrors")
local chatEntryPointNames = SocialCommon.Enums.ChatEntryPointNames
local enteredChatFromEntryPoint = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Actions").EnteredChatFromEntryPoint
local Logger = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatDetails/ParticipantDialog/Logger")

local sources = SocialLuaAnalytics.Analytics.Enums.Sources

local v5 = { skipFetch = true }

local v6 = {
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

function LUAUFORGE_MODULE_GLOBALS_hsA_ParticipantDialogContainer(p2)
	local joined = Cryo.Dictionary.join(v6, p2)
	local v7 = React.useContext(BackHandlerContext)
	local ref = React.useRef(joined.onDismiss)
	ref.current = joined.onDismiss
	React.useLayoutEffect(function()
		return v7(function()
			ref.current()
		end)
	end, { v7 })

	local v8 = useNavigation()
	local v9 = useDispatch()
	local navigateToDialog = joined.navigateToDialog or function() end

	local v10 = module3(function(p3)
		return p3.getChatViewProfileOption()
	end)

	local v11 = useSelector(function(p3)
		local conversations = p3.ChatAppReducer and p3.ChatAppReducer.Conversations
		local v12 = conversations and conversations[joined.conversationId]
		return v12 and v12.conversationType == Conversation.Type.MULTI_USER_CONVERSATION
	end)
	local v12

	if FFlagAppChatMigrateFriendshipStatuses then
		local participantId = joined.participantId
		local v14 = if not v11 then v5 else nil
		v12 = useGetFriendshipStatus(participantId, v14) == Enum.FriendStatus.Friend
	else
		v12 = useSelector(function(p3)
			local friends = p3.ChatAppReducer and p3.ChatAppReducer.Friends
			local friendshipStatus = friends and friends.friendshipStatus
			return friendshipStatus and friendshipStatus[joined.participantId] == Enum.FriendStatus.Friend
		end)

		React.useEffect(function()
			if v11 then
				v9(NetworkingBlocking.GetExtendedFriendshipStatus.API({
					targetUserId = joined.participantId
				}))
			end
		end, { joined.participantId, v9, v11 })
	end

	local v14 = useLocalization({
		viewProfileText = joined.viewProfileText,
		chatText = joined.chatText,
		reportUserText = joined.reportUserText,
		removeFromGroupText = joined.removeFromGroupText,
		chatUnavailableWithUser = "Feature.Chat.Message.ChatUnavailableWithUser",
		networkErrorText = "Feature.Toast.NetworkingError.SomethingIsWrong"
	})

	local v15 = useIsExternalNavigationAvailable({ EnumScreens.ViewUserProfile })[EnumScreens.ViewUserProfile]

	local v16 = useTrustedFriendAction(joined.participantId)
	local action = v16.action
	local refetch = v16.refetch
	local v17 = v15 and action ~= nil
	local v18 = not (action == nil) and action.isDisabled
	local actionText = v16.actionText

	local v19 = React.useMemo(function()
		local v20 = {}
		v20[focusNavigationEventNameEnum.NavigateBack] = {
			handler = InputHandlers.onRelease(function(object)
				joined.onDismiss()
				object:cancel()
			end)
		}

		return v20
	end, { joined.onDismiss })

	local v20 = React.useCallback(function(p3, p4)
		Logger:info("User activated removeFromGroup | userId: {}, conversationId: {}", p3, p4)
		joined.onDismiss()
		navigateToDialog(GenericDialogType.RemoveUserDialog, {
			conversationId = p4,
			participantId = p3
		})
	end, { joined.onDismiss, navigateToDialog })

	local v21 = React.useCallback(function(p3)
		local v22 = v8.getScreenProps("navigateToLuaAppPages", {})[EnumScreens.ViewUserProfile]

		if not v22 then
			Logger:warning("UserProfile page was not set in navigateToLuaAppPages screenProps")

			return
		end

		Logger:info("Navigate To UserProfile from {screen}")

		if joined.analytics then
			joined.analytics:navigate(RoactChatAnalytics.NavigationEvents.ChatDetailsProfile)
		end

		joined.onDismiss()
		v22(p3, {})
	end, { v8, joined.analytics, joined.onDismiss })

	local v22 = React.useCallback(function()
		if action == nil then
			return
		end

		if action.actionType == "RemoveTrustedConnection" then
			joined.onDismiss()
			v9(NetworkingBlocking.RemoveTC.API(joined.participantId)):andThen(function()
				refetch()
				NotificationModalsManager.SetUIBloxToast({
					sequenceNumber = DateTime.now().UnixTimestamp,
					toastTitle = v16.toastText
				})
			end):catch(function(p3)
				Logger:warning(
					"Error removing trusted connection for userId {}: {}",
					joined.participantId,
					(tostring(p3))
				)
			end)
		else
			local modalVariantOverride = action.modalVariantOverride
			joined.onDismiss()

			if action.actionType == "AddIncomingTrustedConnection" then
				local v23 = {
					userId = joined.participantId,
					onRequestAccepted = refetch
				}

				v8.navigate(EnumScreens.TrustedConnectionsUpsell, v23)
			else
				local v23 = {
					userId = joined.participantId,
					source = sources.ChatDetails,
					modalVariantOverride = modalVariantOverride,
					onRequestSent = refetch
				}

				v8.navigate(EnumScreens.TrustedConnectionsUpsell, v23)
			end
		end
	end, { action, v16, joined.participantId, joined.onDismiss, v9, refetch, v8 })

	local v23 = React.useCallback(function(p3)
		Logger:info("User activated openChat | userId: {}", p3)
		v9(enteredChatFromEntryPoint(chatEntryPointNames.ChatDetailsParticipantDialog))
		joined.onDismiss()
		v9(createConversation("one_to_one", { (tostring(p3)) })):andThen(function(p4)
			v8.navigate(EnumScreens.ChatConversation, { conversationId = p4.id })
		end):catch(function(p4)
			Logger:warning("Error creating 1:1 conversation for userId {}: {}", p3, (tostring(p4)))
			local v24 = if parseCreateConversationErrors(p4) == "participant_chat_disabled" then v14.chatUnavailableWithUser else v14.networkErrorText
			v8.navigate(EnumScreens.RoactChatToast, {
				toastProps = {
					toastContent = { toastTitle = v24 }
				}
			})
		end)
	end, { v9, v8, joined.onDismiss, v14 })

	local v24 = React.useCallback(function(p3, p4)
		joined.onDismiss()
		v8.navigate(EnumScreens.AppChatReportAbuse, {
			participantId = p3,
			conversationId = p4
		})
	end, { v8, joined.onDismiss })

	local v25 = React.useCallback(function(p3, p4)
		local function fn()
			v8.pop()
			v8.navigate(EnumScreens.AppChatReportAbuse, {
				participantId = p3,
				conversationId = p4
			})
		end

		joined.onDismiss()
		v8.navigate(EnumScreens.BlockingModal, {
			navProps = {
				userId = p3,
				openReportUser = fn,
				disableReportOption = fFlagDisableBlockAndReport
			}
		})
	end, { v8, joined.onDismiss })

	local joined2 = Cryo.Dictionary.join(joined, v14, {
		showViewProfileButton = v10,
		showChatButton = v11 and v12 and true or false,
		showTrustedFriendButton = v17,
		trustedFriendText = actionText,
		isTrustedFriendButtonDisabled = v18,
		openViewProfile = v21,
		openTrustedFriend = v22,
		openChat = v23,
		openReportUser = v24,
		openRemoveUserDialog = v20
	})

	if v15 then
		return React.createElement(focusNavigableSurfaceWrapper, {
			customEventHandlers = v19,
			isAutoFocusRoot = true,
			isFocusable = true,
			isIsolated = true,
			surfaceIdentifier = focusNavigableSurfaceIdentifierEnum.PopUp
		}, { React.createElement(ParticipantDialog, joined2) })
	end

	local createElement = React.createElement
	local v27 = {
		customEventHandlers = v19,
		isAutoFocusRoot = true,
		isFocusable = true,
		isIsolated = true,
		shouldRestoreFocus = false,
		surfaceIdentifier = focusNavigableSurfaceIdentifierEnum.PopUp
	}

	local createElement2 = React.createElement
	local v30 = {
		conversationId = joined.conversationId,
		participantId = joined.participantId,
		onDismiss = joined.onDismiss,
		openRemoveUserDialog = v20,
		removeFromGroupText = v14.removeFromGroupText,
		openReportUser = v24,
		showRemoveUserButton = joined.showRemoveUserButton,
		openBlockingModal = 0
	}

	if joined.openBlockingModal then
		v25 = joined.openBlockingModal
	end

	v30.openBlockingModal = v25
	return createElement(appFocusRoot, v27, { createElement2(PlayerContextualMenuWrapper, v30) })
end

LUAUFORGE_MODULE_GLOBALS_hsA_ParticipantDialogContainer = connectAnalytics(function(p2)
	return { analytics = p2 }
end)(LUAUFORGE_MODULE_GLOBALS_hsA_ParticipantDialogContainer)

return memo(LUAUFORGE_MODULE_GLOBALS_hsA_ParticipantDialogContainer)
