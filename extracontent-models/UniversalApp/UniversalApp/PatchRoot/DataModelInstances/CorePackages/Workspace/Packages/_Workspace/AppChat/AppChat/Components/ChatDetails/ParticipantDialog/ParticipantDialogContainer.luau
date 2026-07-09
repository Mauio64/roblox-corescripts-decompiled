local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local EnumScreens = require(AppChat.EnumScreens)

require(AppChat.types)

local useAppPolicy = require(AppChat.Hooks.useAppPolicy)
local useIsExternalNavigationAvailable = require(AppChat.Hooks.useIsExternalNavigationAvailable)
local Conversation = require(AppChat.Models.Conversation)
local Cryo = require(AppChatParent.Cryo)
local FocusNavigationUtils = require(AppChatParent.FocusNavigationUtils)
local InputHandlers = require(AppChatParent.InputHandlers)
local NotificationModalsManager = require(AppChatParent.NotificationModalsManager)
local React = require(AppChatParent.React)

require(AppChatParent.ReactFocusNavigation)

local SharedFlags = require(AppChatParent.SharedFlags)
local useLocalization = require(AppChatParent.Localization).Hooks.useLocalization
local useTelemetry = require(AppChat.Telemetry.useTelemetry)
local useDispatch = require(AppChatParent.RoactUtils).Hooks.RoactRodux.useDispatch
local useSelector = require(AppChatParent.RoactUtils).Hooks.RoactRodux.useSelector
local useNavigation = require(AppChatParent.Navigation).useNavigation
local SocialCommon = require(AppChatParent.SocialCommon)
local SocialLuaAnalytics = require(AppChatParent.SocialLuaAnalytics)
local NetworkingFriends = require(AppChat.Http.NetworkingFriends)
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local FocusNavigableSurfaceWrapper = FocusNavigationUtils.FocusNavigableSurfaceWrapper
local AppFocusRoot = FocusNavigationUtils.AppFocusRoot
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local FFlagDisableBlockAndReport = SharedFlags.FFlagDisableBlockAndReport
local FFlagEnableChatDetailsOpenChat = require(AppChat.Flags.FFlagEnableChatDetailsOpenChat)
local FFlagAppChatEnableTrustedFriendEntryPoint = require(AppChat.Flags.FFlagAppChatEnableTrustedFriendEntryPoint)
local FFlagAppChatTrustedFriendEntryPointAnalytics = require(AppChat.Flags.FFlagAppChatTrustedFriendEntryPointAnalytics)
local memo = React.memo
local GenericDialogType = require(script.Parent.Parent.Dialogs.GenericDialogType)
local ChatDetailsTelemetryEvents = require(AppChat.Components.ChatDetails.ChatDetailsTelemetryEvents)
local ChatDialogTelemetryLayer = require(AppChat.Telemetry.Layers.ChatDialogTelemetryLayer)
local ParticipantDialog = require(script.Parent.ParticipantDialog)
local PlayerContextualMenuWrapper = require(script.Parent.PlayerContextualMenuWrapper)
local useTrustedFriendAction = require(script.Parent.useTrustedFriendAction)
local connectAnalytics = require(AppChat.LegacyAnalytics.connectAnalytics)
local RoactChatAnalytics = require(AppChat.LegacyAnalytics.RoactChatAnalytics)
local createConversation = require(AppChat.Conversations.Thunks.createConversation)
local parseCreateConversationErrors = require(AppChat.Conversations.Thunks.parseCreateConversationErrors)
local ChatEntryPointNames = SocialCommon.Enums.ChatEntryPointNames
local EnteredChatFromEntryPoint = require(AppChat.Actions).EnteredChatFromEntryPoint
local Logger = require(script.Parent.Logger)
local Sources = SocialLuaAnalytics.Analytics.Enums.Sources
local t1 = {
	conversationId = nil,
	participantId = nil,
	anchorRef = nil,
	showRemoveUserButton = false,
	isWideMode = false,
	viewProfileText = "Feature.Chat.Label.ViewProfile",
	chatText = "CommonUI.Features.Label.Chat",
	reportUserText = "Feature.Chat.Action.ReportUser",
	removeFromGroupText = "Feature.Chat.Action.RemoveFromGroup",
	openBlockingModal = nil,
	analytics = nil,
	navigateToDialog = function() -- line: 84
	end,
	onDismiss = function() -- line: 91
	end
}

function ParticipantDialogContainer(t2: {[any]: any}) -- line: 97
	-- upvalues: Cryo (copy), t1 (copy), FFlagAppChatTrustedFriendEntryPointAnalytics (copy), useTelemetry (copy), ChatDialogTelemetryLayer (copy), useNavigation (copy), useDispatch (copy), useAppPolicy (copy), FFlagEnableChatDetailsOpenChat (copy), useSelector (copy), Conversation (copy), React (copy), NetworkingFriends (copy), useLocalization (copy), useIsExternalNavigationAvailable (copy), EnumScreens (copy), FFlagAppChatEnableTrustedFriendEntryPoint (copy), useTrustedFriendAction (copy), FocusNavigationEventNameEnum (copy), InputHandlers (copy), Logger (copy), GenericDialogType (copy), RoactChatAnalytics (copy), ChatDetailsTelemetryEvents (copy), NotificationModalsManager (copy), Sources (copy), EnteredChatFromEntryPoint (copy), ChatEntryPointNames (copy), createConversation (copy), parseCreateConversationErrors (copy), FFlagDisableBlockAndReport (copy), AppFocusRoot (copy), FocusNavigableSurfaceIdentifierEnum (copy), PlayerContextualMenuWrapper (copy), FocusNavigableSurfaceWrapper (copy), ParticipantDialog (copy)
	local v46 = Cryo.Dictionary.join(t1, t2)
	local u47 = nil

	if FFlagAppChatTrustedFriendEntryPointAnalytics then
		u47 = useTelemetry(ChatDialogTelemetryLayer.Context)
	end

	local v48 = useNavigation()
	local v49 = useDispatch()
	local v50 = v46.navigateToDialog or function() -- line: 106
	end
	local v51 = useAppPolicy(function(p1) -- line: 108
		return p1.getChatViewProfileOption()
	end)
	local u52 = nil
	local v53 = false

	if FFlagEnableChatDetailsOpenChat then
		u52 = useSelector(function(p2) -- line: 117
			-- upvalues: v46 (copy), Conversation (copy)
			local v74 = p2.ChatAppReducer and p2.ChatAppReducer.Conversations
			local v75 = v74 and v74[v46.conversationId]

			return v75 and v75.conversationType == Conversation.Type.MULTI_USER_CONVERSATION
		end)

		local v54 = useSelector(function(p3) -- line: 123
			-- upvalues: v46 (copy)
			local v77 = p3.ChatAppReducer and p3.ChatAppReducer.Friends
			local v78 = v77 and v77.friendshipStatus

			return v78 and v78[v46.participantId] == Enum.FriendStatus.Friend
		end)

		React.useEffect(function() -- line: 129
			-- upvalues: u52 (ref), v49 (copy), NetworkingFriends (copy), v46 (copy)
			if u52 then
				v49(NetworkingFriends.GetExtendedFriendshipStatus.API({
					targetUserId = v46.participantId
				}))
			end
		end, {
			v46.participantId,
			v49,
			u52
		})
		v53 = not not u52 and not not v54
	end

	local v55 = useLocalization({
		viewProfileText = v46.viewProfileText,
		chatText = if not FFlagEnableChatDetailsOpenChat then nil else v46.chatText,
		reportUserText = v46.reportUserText,
		removeFromGroupText = v46.removeFromGroupText
	})
	local v56 = useIsExternalNavigationAvailable({ EnumScreens.ViewUserProfile })[EnumScreens.ViewUserProfile]
	local u57 = nil

	if FFlagAppChatEnableTrustedFriendEntryPoint then
		u57 = useTrustedFriendAction(v46.participantId)
	end

	local v58 = if not u57 then nil else u57.action
	local v59 = not u57 and function() -- line: 160
	end or u57.refetch
	local v60 = v56 and v58 ~= nil
	local v61 = v58 ~= nil and v58.isDisabled
	local v62 = if u57 == nil then nil else u57.actionText
	local v63 = React.useMemo(function() -- line: 166
		-- upvalues: FocusNavigationEventNameEnum (copy), InputHandlers (copy), v46 (copy)
		return {
			[FocusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(p4) -- line: 169
					-- upvalues: v46 (copy)
					v46.onDismiss()
					p4:cancel()
				end)
			}
		}
	end, { v46.onDismiss })
	local v64 = React.useCallback(function(p5, p6) -- line: 177
		-- upvalues: Logger (copy), v46 (copy), v50 (copy), GenericDialogType (copy)
		Logger:info("User activated removeFromGroup | userId: {}, conversationId: {}", p5, p6)
		v46.onDismiss()
		v50(GenericDialogType.RemoveUserDialog, {
			conversationId = p6,
			participantId = p5
		})
	end, {
		v46.onDismiss,
		v50
	})
	local v65 = React.useCallback(function(p7) -- line: 186
		-- upvalues: v48 (copy), EnumScreens (copy), Logger (copy), v46 (copy), RoactChatAnalytics (copy)
		local v82 = v48.getScreenProps("navigateToLuaAppPages", {})[EnumScreens.ViewUserProfile]

		if v82 then
			Logger:info("Navigate To UserProfile from {screen}")

			if v46.analytics then
				v46.analytics:navigate(RoactChatAnalytics.NavigationEvents.ChatDetailsProfile)
			end

			v46.onDismiss()
			v82(p7, {})

			return
		end

		Logger:warning("UserProfile page was not set in navigateToLuaAppPages screenProps")
	end, {
		v48,
		v46.analytics,
		v46.onDismiss
	})
	local v66 = React.useCallback(function() -- line: 203
		-- upvalues: v58 (copy), FFlagAppChatTrustedFriendEntryPointAnalytics (copy), u47 (ref), ChatDetailsTelemetryEvents (copy), v46 (copy), v49 (copy), NetworkingFriends (copy), v59 (copy), NotificationModalsManager (copy), u57 (ref), Logger (copy), Sources (copy), v48 (copy), EnumScreens (copy)
		if v58 == nil then
			return
		end

		if v58.actionType == "RemoveTrustedConnection" then
			if FFlagAppChatTrustedFriendEntryPointAnalytics and u47 then
				u47.emit(ChatDetailsTelemetryEvents.ParticipantDialogRemoveTrustedConnectionClicked, {})
			end

			v46.onDismiss()
			v49(NetworkingFriends.RemoveTC.API(v46.participantId)):andThen(function() -- line: 214
				-- upvalues: v59 (copy), NotificationModalsManager (copy), u57 (ref)
				v59()
				NotificationModalsManager.SetUIBloxToast({
					sequenceNumber = DateTime.now().UnixTimestamp,
					toastTitle = if not u57 then nil else u57.toastText
				})
			end):catch(function(p8) -- line: 221
				-- upvalues: Logger (copy), v46 (copy)
				Logger:warning("Error removing trusted connection for userId {}: {}", v46.participantId, (tostring(p8)))
			end)

			return
		end

		local modalVariantOverride = v58.modalVariantOverride

		if v58.actionType == "AddIncomingTrustedConnection" then
			if FFlagAppChatTrustedFriendEntryPointAnalytics and u47 then
				u47.emit(ChatDetailsTelemetryEvents.ParticipantDialogAddIncomingTrustedConnectionClicked, {})
			end
		elseif FFlagAppChatTrustedFriendEntryPointAnalytics and u47 then
			u47.emit(ChatDetailsTelemetryEvents.ParticipantDialogAddTrustedConnectionClicked, {
				modalVariantOverride = modalVariantOverride
			})
		end

		v46.onDismiss()

		if v58.actionType == "AddIncomingTrustedConnection" then
			local t3 = {
				userId = v46.participantId,
				source = if not FFlagAppChatTrustedFriendEntryPointAnalytics then nil else Sources.ChatDetails,
				onRequestAccepted = v59
			}

			v48.navigate(EnumScreens.AppChatTrustedContactsModal, {
				props = t3
			})

			return
		end

		local t4 = {
			userId = v46.participantId,
			source = Sources.ChatDetails,
			modalVariantOverride = modalVariantOverride,
			onRequestSent = v59
		}

		v48.navigate(EnumScreens.AppChatTrustedContactsModal, {
			props = t4
		})
	end, {
		v58,
		u57,
		v46.participantId,
		v46.onDismiss,
		v49,
		v59,
		v48,
		if not FFlagAppChatTrustedFriendEntryPointAnalytics then nil else u47
	})
	local v67 = React.useCallback(function(p9) -- line: 276
		-- upvalues: Logger (copy), v49 (copy), EnteredChatFromEntryPoint (copy), ChatEntryPointNames (copy), v46 (copy), createConversation (copy), v48 (copy), EnumScreens (copy), parseCreateConversationErrors (copy)
		Logger:info("User activated openChat | userId: {}", p9)
		v49(EnteredChatFromEntryPoint(ChatEntryPointNames.ChatDetailsParticipantDialog))
		v46.onDismiss()
		v49(createConversation("one_to_one", { (tostring(p9)) })):andThen(function(p10) -- line: 281
			-- upvalues: v48 (copy), EnumScreens (copy)
			v48.navigate(EnumScreens.ChatConversation, {
				conversationId = p10.id
			})
		end):catch(function(p11) -- line: 286
			-- upvalues: Logger (copy), p9 (copy), parseCreateConversationErrors (copy), v48 (copy), EnumScreens (copy)
			Logger:warning("Error creating 1:1 conversation for userId {}: {}", p9, (tostring(p11)))

			local v95 = parseCreateConversationErrors(p11) ~= "participant_chat_disabled" and "Feature.Toast.NetworkingError.SomethingIsWrong" or "Feature.Chat.Message.PartyUnavailableWithUser"

			v48.navigate(EnumScreens.RoactChatToast, {
				toastProps = {
					toastContent = {
						toastTitle = v95
					}
				}
			})
		end)
	end, {
		v49,
		v48,
		v46.onDismiss
	})
	local v68 = React.useCallback(function(p12, p13) -- line: 301
		-- upvalues: v46 (copy), v48 (copy), EnumScreens (copy)
		v46.onDismiss()
		v48.navigate(EnumScreens.AppChatReportAbuse, {
			participantId = p12,
			conversationId = p13
		})
	end, {
		v48,
		v46.onDismiss
	})
	local v69 = React.useCallback(function(p14, p15) -- line: 309
		-- upvalues: v48 (copy), EnumScreens (copy), v46 (copy), FFlagDisableBlockAndReport (copy)
		v46.onDismiss()
		v48.navigate(EnumScreens.BlockingModal, {
			navProps = {
				userId = p14,
				openReportUser = function() -- line: 310
					-- upvalues: v48 (copy), EnumScreens (copy), p14 (copy), p15 (copy)
					v48.pop()
					v48.navigate(EnumScreens.AppChatReportAbuse, {
						participantId = p14,
						conversationId = p15
					})
				end,
				disableReportOption = FFlagDisableBlockAndReport
			}
		})
	end, {
		v48,
		v46.onDismiss
	})
	local v70 = Cryo.Dictionary.join(v46, v55, {
		showViewProfileButton = v51,
		showChatButton = v53,
		showTrustedFriendButton = v60,
		trustedFriendText = v62,
		isTrustedFriendButtonDisabled = v61,
		openViewProfile = v65,
		openTrustedFriend = v66,
		openChat = if not FFlagEnableChatDetailsOpenChat then nil else v67,
		openReportUser = v68,
		openRemoveUserDialog = v64
	})

	if not v56 then
		return React.createElement(AppFocusRoot, {
			isAutoFocusRoot = true,
			isFocusable = true,
			isIsolated = true,
			shouldRestoreFocus = false,
			customEventHandlers = v63,
			surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.PopUp
		}, { React.createElement(PlayerContextualMenuWrapper, {
			conversationId = v46.conversationId,
			participantId = v46.participantId,
			onDismiss = v46.onDismiss,
			openRemoveUserDialog = v64,
			removeFromGroupText = v55.removeFromGroupText,
			openReportUser = v68,
			showRemoveUserButton = v46.showRemoveUserButton,
			openBlockingModal = if not v46.openBlockingModal then v69 else v46.openBlockingModal
		}) })
	end

	return React.createElement(FocusNavigableSurfaceWrapper, {
		isAutoFocusRoot = true,
		isFocusable = true,
		isIsolated = true,
		customEventHandlers = v63,
		surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.PopUp
	}, { React.createElement(ParticipantDialog, v70) })
end

ParticipantDialogContainer = connectAnalytics(function(p16) -- line: 374
	return {
		analytics = p16
	}
end)(ParticipantDialogContainer)

return memo(ParticipantDialogContainer)
