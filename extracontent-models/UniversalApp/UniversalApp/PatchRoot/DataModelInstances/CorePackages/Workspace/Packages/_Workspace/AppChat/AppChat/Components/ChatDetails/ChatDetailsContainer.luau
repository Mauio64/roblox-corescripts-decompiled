local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local Cryo = require(AppChatParent.Cryo)
local React = require(AppChatParent.React)
local UIBlox = require(AppChatParent.UIBlox)
local Promise = require(AppChatParent.Promise)
local getDeepValue = require(AppChat.Utils.getDeepValue)
local UserProfiles = require(AppChatParent.UserProfiles)
local useCallback = React.useCallback
local useDispatch = require(AppChatParent.RoactUtils).Hooks.RoactRodux.useDispatch
local useEffect = React.useEffect
local useEffectOnMount = require(AppChatParent.RoactUtils).Hooks.useEffectOnMount
local useIsGroupChatEnabled = require(AppChat.Hooks.useIsGroupChatEnabled)
local useState = React.useState
local useStyle = UIBlox.Core.Style.useStyle
local useSelector = require(AppChatParent.RoactUtils).Hooks.RoactRodux.useSelector
local useLocalization = require(AppChatParent.Localization).Hooks.useLocalization
local Conversation = require(AppChat.Models.Conversation)
local ConversationChannels = require(AppChat.Models.ConversationChannels)
local useUserProfilesFetch = UserProfiles.Hooks.useUserProfilesFetch
local userProfilesCombinedNameAndUsernameByUserIds = UserProfiles.Queries.userProfilesCombinedNameAndUsernameByUserIds
local useIsUserPending = require(AppChat.Hooks.useIsUserPending)
local LuaAppNavigationContext = require(AppChat.LuaAppNavigationContext)
local useNavigation = require(AppChatParent.Navigation).useNavigation
local useIsChatEnabled = require(AppChat.Hooks.useIsChatEnabled)
local getConversationTitle = require(AppChat.Conversations.getConversationTitle)
local selectChatUserEntryModelList = require(script.Parent.Selectors.selectChatUserEntryModelList)
local ParticipantDialogContainer = require(script.Parent.ParticipantDialog.ParticipantDialogContainer)
local ChatDetailsPage = require(script.Parent.ChatDetailsPage)
local GenericDialogType = require(script.Parent.Dialogs.GenericDialogType)
local AppChatNetworking = require(AppChatParent.AppChatNetworking)
local useTelemetry = require(AppChat.Telemetry.useTelemetry)
local ChatDetailsTelemetryLayer = require(AppChat.Telemetry.Layers.ChatDetailsTelemetryLayer)
local ChatDetailsTelemetryEvents = require(AppChat.Components.ChatDetails.ChatDetailsTelemetryEvents)
local ChatConversationTelemetryState = require(AppChat.Contexts.TelemetryState.ChatConversationTelemetryState)
local ChatDetailsTelemetryState = require(AppChat.Contexts.TelemetryState.ChatDetailsTelemetryState)
local FFlagConnectionsToFriendsRename = require(AppChatParent.SharedFlags).FFlagConnectionsToFriendsRename
local FFlagAppChatAlwaysDisplayUserCardsInChatDetails = require(AppChat.Flags.FFlagAppChatAlwaysDisplayUserCardsInChatDetails)
local getFFlagAppChatParticipantDialogFoundationMenu = require(AppChat.Flags.getFFlagAppChatParticipantDialogFoundationMenu)
local GetFFlagIsSquadEnabled = require(AppChatParent.SharedFlags).GetFFlagIsSquadEnabled
local t1 = {
	topBarHeight = 0,
	wideMode = false,
	participants = nil,
	isGroupConversation = nil,
	isGroupOwner = nil,
	conversationId = nil,
	conversation = nil,
	navigateBack = function() -- line: 62
	end,
	navigateToEditChatMembers = function() -- line: 63
	end,
	navigateToDialog = function() -- line: 64
	end,
	navigateToToast = function() -- line: 65
	end,
	navigateToConversation = function() -- line: 66
	end,
	navigateToChatLanding = function() -- line: 67
	end
}

return function(p1) -- line: 70
	-- upvalues: Cryo (copy), t1 (copy), getFFlagAppChatParticipantDialogFoundationMenu (copy), useStyle (copy), useLocalization (copy), GetFFlagIsSquadEnabled (copy), FFlagConnectionsToFriendsRename (copy), React (copy), LuaAppNavigationContext (copy), useDispatch (copy), useState (copy), useNavigation (copy), useIsGroupChatEnabled (copy), useIsChatEnabled (copy), useEffect (copy), useSelector (copy), getDeepValue (copy), Conversation (copy), AppChatNetworking (copy), useUserProfilesFetch (copy), userProfilesCombinedNameAndUsernameByUserIds (copy), useTelemetry (copy), ChatDetailsTelemetryLayer (copy), FFlagAppChatAlwaysDisplayUserCardsInChatDetails (copy), selectChatUserEntryModelList (copy), getConversationTitle (copy), useIsUserPending (copy), ConversationChannels (copy), Promise (copy), GenericDialogType (copy), ChatDetailsTelemetryEvents (copy), useCallback (copy), ChatConversationTelemetryState (copy), ChatDetailsTelemetryState (copy), useEffectOnMount (copy), ChatDetailsPage (copy), ParticipantDialogContainer (copy)
	local v43 = Cryo.Dictionary.join(t1, p1 or {})
	local v44 = getFFlagAppChatParticipantDialogFoundationMenu()
	local v45 = useStyle()
	local v46 = useLocalization({
		generalText = "Feature.Chat.Label.General",
		titleNotSetText = "Feature.Chat.Label.NotSet",
		membersText = "Feature.Chat.Label.Members",
		leaveGroupText = "Feature.Chat.Heading.LeaveGroup",
		onlinePresenceText = "Common.Presence.Label.Online",
		offlinePresenceText = "Common.Presence.Label.Offline",
		networkErrorToastText = "Feature.Toast.NetworkingError.SomethingIsWrong",
		conversationTypeHeaderText = "Feature.Chat.Label.ExpandedChatFeatures",
		enabledText = "Feature.Chat.Label.Available",
		disabledText = "Feature.Chat.Label.Unavailable",
		createUnfilteredChatText = "Feature.Chat.Label.CreateUnfilteredChat",
		createUnfilteredChatSubtitleText = "Feature.Chat.Description.CreateUnfilteredChatCell",
		pageHeaderText = not GetFFlagIsSquadEnabled() and "Feature.Chat.Label.ChatDetails" or "Feature.Chat.Label.Details",
		addFriendsText = not FFlagConnectionsToFriendsRename and "Feature.Chat.Label.AddConnections" or "Feature.Chat.Label.AddFriends",
		chatGroupText = not GetFFlagIsSquadEnabled() and "Feature.Chat.Label.ChatGroupName" or "Feature.Chat.Label.GroupName",
		tooManyPeopleText = {
			if not GetFFlagIsSquadEnabled() then not FFlagConnectionsToFriendsRename and "Feature.Chat.Message.AddConnectionsLimit" or "Feature.Chat.Message.AddFriendsLimit" else not FFlagConnectionsToFriendsRename and "Feature.Chat.Message.AddConnectionsPartyLimit" or "Feature.Chat.Message.AddFriendsPartyLimit",
			friendNum = 5,
			connectionsNum = 5
		}
	})
	local v47 = React.useContext(LuaAppNavigationContext)
	local v48 = useDispatch()
	local v49, v50 = useState(false)
	local u51 = nil
	local u52 = nil
	local v53 = nil
	local u54 = nil

	if v44 then
		local v55, v56 = useState(nil)

		u51 = v55
		u52 = v56

		local v57

		v53, v57 = useState(nil)
		u54 = v57
	end

	local v58 = useNavigation()
	local v59 = useIsGroupChatEnabled()
	local v60 = useIsChatEnabled()

	useEffect(function() -- line: 123
		-- upvalues: v60 (copy), v43 (copy)
		if not v60 then
			v43.navigateToChatLanding()
		end
	end, {
		v60,
		v43.navigateToChatLanding
	})

	local v61 = useSelector(function(p2) -- line: 129
		-- upvalues: getDeepValue (copy), v43 (copy), Conversation (copy)
		return getDeepValue(p2, `ChatAppReducer.Conversations.{ v43.conversationId or "" }`) or Conversation.empty()
	end)
	local v62 = useSelector(function(p3) -- line: 133
		-- upvalues: getDeepValue (copy), v43 (copy)
		return getDeepValue(p3, `ChatAppReducer.ParticipantMetadata.{ v43.conversationId or "" }`)
	end)
	local v63 = v61 and v61.source

	useEffect(function() -- line: 138
		-- upvalues: v63 (copy), v48 (copy), AppChatNetworking (copy), v43 (copy)
		if v63 ~= "channels" then
			return
		end

		v48(AppChatNetworking.rodux.GetConversationsParticipantsMetadata.API({ v43.conversationId })):catch(function() -- line: 144
			warn("Error in ChatDetailsContainer -> GetConversationsParticipantsMetadata")
		end)
	end, {
		v43.conversationId,
		v43.participants,
		v63
	})

	local v64 = useUserProfilesFetch({
		userIds = v61.participants,
		query = userProfilesCombinedNameAndUsernameByUserIds
	})
	local v65 = useTelemetry(ChatDetailsTelemetryLayer.Context)
	local v66 = nil
	local u67 = nil
	local u68 = nil
	local v69 = nil
	local v70 = nil
	local u71 = nil
	local v72 = nil

	if v61 then
		v66 = useSelector(function(p4) -- line: 163
			-- upvalues: FFlagAppChatAlwaysDisplayUserCardsInChatDetails (copy), selectChatUserEntryModelList (copy), v61 (copy), v64 (copy)
			if FFlagAppChatAlwaysDisplayUserCardsInChatDetails then
				return selectChatUserEntryModelList(p4, v61.participants, if not v64 or not v64.data then nil else v64.data.userProfiles)
			end

			if v64.data then
				return selectChatUserEntryModelList(p4, v61.participants, v64.data.userProfiles)
			end

			return {}
		end)
		u68 = v61.conversationType == Conversation.Type.MULTI_USER_CONVERSATION
		u67 = useSelector(function(p5) -- line: 183
			-- upvalues: u68 (ref), v61 (copy)
			return u68 and v61.initiator == p5.LocalUserId
		end)
		v69 = getConversationTitle(v61)

		if v62 then
			for v73, v74 in v66 do
				v66[v73] = Cryo.Dictionary.join(v74, {
					metadata = v62[v73]
				})
			end
		end

		u71 = useIsUserPending(v61)
		v70 = u68 and u71

		if v70 then
			v59 = false
		end

		v72 = v61.moderationType == ConversationChannels.ModerationType.TrustedComms
	end

	local v75 = v66 and #v66 or 0
	local v76 = if not v72 then v46.disabledText else v46.enabledText

	if v61.isDefaultTitle then
		v69 = v46.titleNotSetText
	end

	local v77 = useCallback(function() -- line: 232
		-- upvalues: v58 (copy), v47 (copy)
		if v58 then
			v47.navigateToUnfilteredThreadsLearnMore(v58.navigate)

			return
		end

		v47.navigateToUnfilteredThreadsLearnMore()
	end, {
		v47,
		v58
	})
	local v78 = useCallback(function() -- line: 240
		-- upvalues: v65 (copy), ChatDetailsTelemetryEvents (copy), v50 (copy), v48 (copy), AppChatNetworking (copy), v43 (copy), v46 (copy)
		v65.emit(ChatDetailsTelemetryEvents.ChatDetailsCreateUnfilteredChatCellClicked, {})
		v50(true)
		v48(AppChatNetworking.rodux.DuplicateConversation.API(v43.conversationId, "trusted_comms")):andThen(function(p6) -- line: 244
			-- upvalues: v43 (copy), v46 (copy)
			local responseBody = p6.responseBody
			local v101 = responseBody and (responseBody.conversations and (responseBody.conversations[1] and responseBody.conversations[1].id))

			if v101 then
				v43.navigateToConversation(v101)

				return
			end

			v43.navigateToToast({
				toastProps = {
					toastContent = {
						toastTitle = v46.networkErrorToastText
					}
				}
			})
		end):catch(function() -- line: 262
			-- upvalues: v43 (copy), v46 (copy)
			v43.navigateToToast({
				toastProps = {
					toastContent = {
						toastTitle = v46.networkErrorToastText
					}
				}
			})
		end):finally(function() -- line: 271
			-- upvalues: v50 (copy)
			v50(false)
		end)
	end, {
		v48,
		v50,
		v43.navigateToToast,
		v43.navigateToConversation,
		v43.conversationId,
		v75,
		u67,
		v65
	})

	local function v79(p7) -- line: 314
		-- upvalues: v43 (copy)
		v43.navigateToToast({
			toastProps = {
				toastContent = {
					toastTitle = p7
				}
			}
		})
	end
	local function v80(p8) -- line: 324
		-- upvalues: v61 (copy), Promise (copy), v43 (copy), v79 (copy), v65 (copy), ChatDetailsTelemetryEvents (copy)
		local v96 = v61

		Promise.new(function(resolve, reject) -- line: 211
			-- upvalues: v96 (copy)
			if #v96.participants > 5 then
				reject()

				return
			end

			resolve()
		end):andThen(function() -- line: 325
			-- upvalues: v43 (copy), v61 (copy)
			v43.navigateToEditChatMembers(v61)
		end, function() -- line: 328
			-- upvalues: v79 (copy), p8 (copy)
			v79(p8)
		end)
		v65.emit(ChatDetailsTelemetryEvents.ChatDetailsAddFriendsBtnClicked, {})
	end

	local v81 = v61 and v61.moderationType or Cryo.None
	local v82 = v61 and v61.userPendingStatus or Cryo.None
	local v83 = ChatConversationTelemetryState.useMergeState()

	useEffect(function() -- line: 338
		-- upvalues: v83 (copy), v43 (copy), v81 (copy), v82 (copy)
		v83({
			conversationId = v43.conversationId,
			moderationType = v81,
			userPendingStatus = v82
		})
	end, {
		v43.conversationId,
		v81,
		v82
	})

	local v84 = ChatDetailsTelemetryState.useMergeState()

	useEffect(function() -- line: 346
		-- upvalues: v84 (copy), v61 (copy), u67 (ref)
		v84({
			participantsCount = #v61.participants,
			isGroupOwner = u67
		})
	end, {
		#v61.participants,
		u67
	})
	useEffectOnMount(function() -- line: 353
		-- upvalues: v65 (copy), ChatDetailsTelemetryEvents (copy), u68 (ref)
		v65.emit(ChatDetailsTelemetryEvents.ScreenRendered, {
			isGroupConversation = u68
		})
	end)

	local v85 = Cryo.Dictionary.join({
		shouldShowCreateUnfilteredChat = false,
		LayoutOrder = 2,
		navigateBack = v43.navigateBack,
		onGroupNameEntryCellActivated = function() -- line: 221
			-- upvalues: v43 (copy), GenericDialogType (copy)
			v43.navigateToDialog(GenericDialogType.EditChatGroupNameDialog, {
				conversationId = v43.conversationId
			})
		end,
		onLeaveGroupCellActivated = function() -- line: 226
			-- upvalues: v43 (copy), GenericDialogType (copy), v65 (copy), ChatDetailsTelemetryEvents (copy)
			v43.navigateToDialog(GenericDialogType.LeaveGroupDialog, {
				conversationId = v43.conversationId
			})
			v65.emit(ChatDetailsTelemetryEvents.ChatDetailsLeaveGroupBtnClicked, {})
		end,
		onParticipantCellActivated = function(p9, p10) -- line: 294
			-- upvalues: v44 (copy), u52 (ref), u54 (ref), u51 (ref), v43 (copy), GenericDialogType (copy), u71 (ref), u68 (ref), u67 (ref)
			local str = tostring(p9)

			if v44 and u52 and u54 then
				if str == u51 then
					if u52 and u54 then
						u52(nil)
						u54(nil)

						return
					end
				else
					u52(str)
					u54(p10)
				end

				return
			end

			v43.navigateToDialog(GenericDialogType.ParticipantDialog, {
				conversationId = v43.conversationId,
				participantId = str,
				showRemoveUserButton = not u71 and (u68 and u67)
			})
		end,
		onAddFriendsCellActivated = function() -- line: 364
			-- upvalues: v80 (copy), v46 (copy)
			return v80(v46.tooManyPeopleText)
		end,
		onConversationTypeIconActivated = v77,
		onCreateUnfilteredChatCellActivated = v78,
		conversationTitle = v69,
		conversation = v61,
		conversationId = v43.conversationId,
		participants = v66,
		isGroupConversation = u68,
		wideMode = v43.wideMode,
		shouldHideGroupChatFunctionality = v70,
		shouldShowAddFriends = v59,
		conversationTypeText = v76,
		isCreateUnfilteredChatLoading = v49,
		topBarHeight = v43.topBarHeight,
		style = v45
	}, v46)

	if v44 then
		v85.activeParticipantId = u51
	end

	return React.createElement("ImageButton", {
		BackgroundTransparency = 1,
		Active = true,
		AutoButtonColor = false,
		Selectable = false,
		Size = UDim2.new(1, 0, 1, 0)
	}, {
		ChatDetailsPage = React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0)
		}, {
			UIListLayout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			Content = React.createElement(ChatDetailsPage, v85)
		}),
		ParticipantDialog = if not v44 or u51 == nil then nil else React.createElement(ParticipantDialogContainer, {
			anchorRef = v53,
			conversationId = v43.conversationId,
			isWideMode = v43.wideMode,
			navigateToDialog = v43.navigateToDialog,
			onDismiss = function() -- line: 287
				-- upvalues: u52 (ref), u54 (ref)
				if u52 and u54 then
					u52(nil)
					u54(nil)
				end
			end,
			participantId = u51,
			showRemoveUserButton = not u71 and (u68 and u67)
		})
	})
end
