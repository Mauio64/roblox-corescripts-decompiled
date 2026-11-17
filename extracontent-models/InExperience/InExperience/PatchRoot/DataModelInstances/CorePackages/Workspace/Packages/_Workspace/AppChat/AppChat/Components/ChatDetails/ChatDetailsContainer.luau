local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local Cryo = require(parent.Cryo)
local React = require(parent.React)
local UIBlox = require(parent.UIBlox)
local Promise = require(parent.Promise)
local getDeepValue = require(AppChat.Utils.getDeepValue)
local UserProfiles = require(parent.UserProfiles)

local useCallback = React.useCallback
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useEffect = React.useEffect
local RoactUtils2 = require(parent.RoactUtils)
local useEffectOnMount = RoactUtils2.Hooks.useEffectOnMount
local useIsGroupChatEnabled = require(AppChat.Hooks.useIsGroupChatEnabled)
local useState = React.useState
local useStyle = UIBlox.Core.Style.useStyle
local RoactUtils3 = require(parent.RoactUtils)
local useSelector = RoactUtils3.Hooks.RoactRodux.useSelector
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local Conversation = require(AppChat.Models.Conversation)
local ConversationChannels = require(AppChat.Models.ConversationChannels)
local useUserProfilesFetch = UserProfiles.Hooks.useUserProfilesFetch
local userProfilesCombinedNameAndUsernameByUserIds = UserProfiles.Queries.userProfilesCombinedNameAndUsernameByUserIds
local useIsUserPending = require(AppChat.Hooks.useIsUserPending)
local LuaAppNavigationContext = require(AppChat.LuaAppNavigationContext)
local Navigation = require(parent.Navigation)
local useNavigation = Navigation.useNavigation
local useIsChatEnabled = require(AppChat.Hooks.useIsChatEnabled)
local UniversalAppPolicy = require(parent.UniversalAppPolicy)
local useAppPolicy = UniversalAppPolicy.useAppPolicy
local ChatPlacementContext = require(AppChat.Contexts.ChatPlacementContext)
local useChatPlacementContext = ChatPlacementContext.useChatPlacementContext
local isPlacementInExperience = ChatPlacementContext.isPlacementInExperience

local getConversationTitle = require(AppChat.Conversations.getConversationTitle)

local selectChatUserEntryModelList = require(script.Parent.Selectors.selectChatUserEntryModelList)
local ParticipantDialogContainer = require(script.Parent.ParticipantDialog.ParticipantDialogContainer)

local ChatDetailsPage = require(script.Parent.ChatDetailsPage)
local GenericDialogType = require(script.Parent.Dialogs.GenericDialogType)

local AppChatNetworking = require(parent.AppChatNetworking)

local useTelemetry = require(AppChat.Telemetry.useTelemetry)
local ChatDetailsTelemetryLayer = require(AppChat.Telemetry.Layers.ChatDetailsTelemetryLayer)
local ChatDetailsTelemetryEvents = require(AppChat.Components.ChatDetails.ChatDetailsTelemetryEvents)
local ChatConversationTelemetryState = require(AppChat.Contexts.TelemetryState.ChatConversationTelemetryState)
local ChatDetailsTelemetryState = require(AppChat.Contexts.TelemetryState.ChatDetailsTelemetryState)
local FFlagAppChatUseUserProfileHydration = require(AppChat.Flags.FFlagAppChatUseUserProfileHydration)
local useProfileNames = require(AppChat.Hooks.useProfileNames)
local getCombinedNameFromProfileNames = require(AppChat.Users.getCombinedNameFromProfileNames)
local SharedFlags = require(parent.SharedFlags)
local GetFFlagIsSquadEnabled = SharedFlags.GetFFlagIsSquadEnabled

local v = {
	topBarHeight = 0,
	wideMode = false,
	participants = nil,
	isGroupConversation = nil,
	isGroupOwner = nil,
	conversationId = nil,
	conversation = nil,
	navigateBack = function() end,
	navigateToEditChatMembers = function() end,
	navigateToDialog = function() end,
	navigateToToast = function() end,
	navigateToConversation = function() end,
	navigateToChatLanding = function() end
}

local function getParticipantProfiles(p, participants)
	local participantProfiles = {}

	for k, item in participants do
		local combinedNameFromProfileNames = getCombinedNameFromProfileNames(p, item)

		if combinedNameFromProfileNames then
			participantProfiles[k] = {
				names = { combinedName = combinedNameFromProfileNames }
			}
		end
	end

	return participantProfiles
end

return function(options)
	local joined = Cryo.Dictionary.join(v, options or {})
	local style = useStyle()
	local v2 = useLocalization({
		pageHeaderText = GetFFlagIsSquadEnabled() and "Feature.Chat.Label.Details" or "Feature.Chat.Label.ChatDetails",
		generalText = "Feature.Chat.Label.General",
		titleNotSetText = "Feature.Chat.Label.NotSet",
		membersText = "Feature.Chat.Label.Members",
		addFriendsText = "Feature.Chat.Label.AddFriends",
		leaveGroupText = "Feature.Chat.Heading.LeaveGroup",
		chatGroupText = GetFFlagIsSquadEnabled() and "Feature.Chat.Label.GroupName" or "Feature.Chat.Label.ChatGroupName",
		onlinePresenceText = "Common.Presence.Label.Online",
		offlinePresenceText = "Common.Presence.Label.Offline",
		tooManyPeopleText = {
			GetFFlagIsSquadEnabled() and "Feature.Chat.Message.AddFriendsPartyLimit" or "Feature.Chat.Message.AddFriendsLimit",
			friendNum = 5,
			connectionsNum = 5
		},
		networkErrorToastText = "Feature.Toast.NetworkingError.SomethingIsWrong",
		conversationTypeHeaderText = "Feature.Chat.Label.ExpandedChatFeatures",
		enabledText = "Feature.Chat.Label.Available",
		disabledText = "Feature.Chat.Label.Unavailable",
		createUnfilteredChatText = "Feature.Chat.Label.CreateUnfilteredChat",
		createUnfilteredChatSubtitleText = "Feature.Chat.Description.CreateUnfilteredChatCell"
	})

	local v3 = React.useContext(LuaAppNavigationContext)
	local v4 = useDispatch()
	local state, setState = useState(false)
	local state2, setState2 = useState(nil)
	local state3, setState3 = useState(nil)
	local v5 = useNavigation()
	local shouldShowAddFriends = useIsGroupChatEnabled()
	local v6 = useIsChatEnabled()
	useEffect(function()
		if not v6 then
			joined.navigateToChatLanding()
		end
	end, { v6, joined.navigateToChatLanding })

	local conversation = useSelector(function(p)
		return getDeepValue(p, `ChatAppReducer.Conversations.{joined.conversationId or ""}`) or Conversation.empty()
	end)

	local v7 = useSelector(function(p)
		return getDeepValue(p, `ChatAppReducer.ParticipantMetadata.{joined.conversationId or ""}`)
	end)

	local source = conversation and conversation.source

	useEffect(function()
		if source ~= "channels" then
			return
		end

		v4(AppChatNetworking.rodux.GetConversationsParticipantsMetadata.API({ joined.conversationId })):catch(function()
			warn("Error in ChatDetailsContainer -> GetConversationsParticipantsMetadata")
		end)
	end, { joined.conversationId, joined.participants, source })

	local v8 = nil
	local v9 = nil

	if FFlagAppChatUseUserProfileHydration then
		v9 = useProfileNames(conversation.participants)
	else
		v8 = useUserProfilesFetch({
			userIds = conversation.participants,
			query = userProfilesCombinedNameAndUsernameByUserIds
		})
	end

	local v10 = useTelemetry(ChatDetailsTelemetryLayer.Context)
	local values, isGroupConversation, isGroupOwner, conversationTitle, v11, shouldHideGroupChatFunctionality, flag

	if conversation then
		values = useSelector(function(p)
			local participants = conversation.participants
			local v12

			if FFlagAppChatUseUserProfileHydration then
				v12 = getParticipantProfiles(v9, conversation.participants)
			elseif v8 and v8.data then
				v12 = v8.data.userProfiles
			end

			return selectChatUserEntryModelList(p, participants, v12)
		end)

		isGroupConversation = conversation.conversationType == Conversation.Type.MULTI_USER_CONVERSATION
		isGroupOwner = useSelector(function(p)
			return isGroupConversation and conversation.initiator == p.LocalUserId
		end)

		conversationTitle = getConversationTitle(conversation)

		if v7 then
			for k, v12 in values do
				values[k] = Cryo.Dictionary.join(v12, { metadata = v7[k] })
			end
		end

		v11 = useIsUserPending(conversation)
		shouldHideGroupChatFunctionality = isGroupConversation and v11

		if shouldHideGroupChatFunctionality then
			shouldShowAddFriends = false
		end

		if conversation.moderationType == ConversationChannels.ModerationType.TrustedComms then
			flag = true
		else
			flag = false
		end
	else
		isGroupOwner = nil
		isGroupConversation = nil
	end

	local v12 = values and #values or 0
	local conversationTypeText

	if flag then
		conversationTypeText = v2.enabledText
	else
		conversationTypeText = v2.disabledText
	end

	if conversation.isDefaultTitle then
		conversationTitle = v2.titleNotSetText
	end

	local function onGroupNameEntryCellActivated()
		joined.navigateToDialog(GenericDialogType.EditChatGroupNameDialog, {
			conversationId = joined.conversationId
		})
	end
	local function onLeaveGroupCellActivated()
		local isRooted

		if v5 then
			isRooted = v5.getParam("isRooted", false)
		else
			isRooted = false
		end

		joined.navigateToDialog(GenericDialogType.LeaveGroupDialog, {
			conversationId = joined.conversationId,
			isRooted = isRooted
		})

		v10.emit(ChatDetailsTelemetryEvents.ChatDetailsLeaveGroupBtnClicked, {})
	end
	local onConversationTypeIconActivated = useCallback(function()
		if v5 then
			v3.navigateToUnfilteredThreadsLearnMore(v5.navigate)
		else
			v3.navigateToUnfilteredThreadsLearnMore()
		end
	end, { v3, v5 })
	local onCreateUnfilteredChatCellActivated = useCallback(function()
		v10.emit(ChatDetailsTelemetryEvents.ChatDetailsCreateUnfilteredChatCellClicked, {})
		setState(true)
		v4(AppChatNetworking.rodux.DuplicateConversation.API(joined.conversationId, "trusted_comms")):andThen(function(p)
			local responseBody = p.responseBody

			local id = responseBody
				and responseBody.conversations
				and responseBody.conversations[1]
				and responseBody.conversations[1].id

			if id then
				joined.navigateToConversation(id)
			else
				joined.navigateToToast({
					toastProps = {
						toastContent = { toastTitle = v2.networkErrorToastText }
					}
				})
			end
		end):catch(function()
			joined.navigateToToast({
				toastProps = {
					toastContent = { toastTitle = v2.networkErrorToastText }
				}
			})
		end):finally(function()
			setState(false)
		end)
	end, {
		v4,
		setState,
		joined.navigateToToast,
		joined.navigateToConversation,
		joined.conversationId,
		v12,
		isGroupOwner,
		v10
	})

	local function onDismiss() -- 1 equivalent call inferred from this helper
		setState2(nil)
		setState3(nil)
	end

	local function fn(toastTitle)
		joined.navigateToToast({
			toastProps = {
				toastContent = { toastTitle = toastTitle }
			}
		})
	end

	local function fn2(tooManyPeopleText)
		local v13 = conversation
		Promise.new(function(callback, callback2)
			if #v13.participants > 5 then
				callback2()
			else
				callback()
			end
		end):andThen(function()
			joined.navigateToEditChatMembers(conversation)
		end, function()
			fn(tooManyPeopleText)
		end)
		v10.emit(ChatDetailsTelemetryEvents.ChatDetailsAddFriendsBtnClicked, {})
	end

	local v13 = useAppPolicy(function(p)
		return p.getWebViewSupport()
	end)

	local placementInExperience = isPlacementInExperience(useChatPlacementContext().chatPlacement)

	local moderationType = conversation and conversation.moderationType or Cryo.None
	local userPendingStatus = conversation and conversation.userPendingStatus or Cryo.None
	local v14 = ChatConversationTelemetryState.useMergeState()
	useEffect(function()
		v14({
			conversationId = joined.conversationId,
			moderationType = moderationType,
			userPendingStatus = userPendingStatus
		})
	end, { joined.conversationId, moderationType, userPendingStatus })
	local v15 = ChatDetailsTelemetryState.useMergeState()
	useEffect(function()
		v15({
			participantsCount = #conversation.participants,
			isGroupOwner = isGroupOwner
		})
	end, { #conversation.participants, isGroupOwner })

	useEffectOnMount(function()
		v10.emit(ChatDetailsTelemetryEvents.ScreenRendered, {
			isGroupConversation = isGroupConversation
		})
	end)
	local joined2 = Cryo.Dictionary.join({
		navigateBack = joined.navigateBack,
		onGroupNameEntryCellActivated = onGroupNameEntryCellActivated,
		onLeaveGroupCellActivated = onLeaveGroupCellActivated,
		onParticipantCellActivated = function(p, p2)
			local v16 = tostring(p)

			if state2 == v16 then
				onDismiss() -- inferred equivalent call
			else
				setState2(v16)
				setState3(p2)
			end
		end,
		onAddFriendsCellActivated = function()
			return fn2(v2.tooManyPeopleText)
		end,
		onConversationTypeIconActivated = onConversationTypeIconActivated,
		onCreateUnfilteredChatCellActivated = onCreateUnfilteredChatCellActivated,
		conversationTitle = conversationTitle,
		conversation = conversation,
		conversationId = joined.conversationId,
		participants = values,
		isGroupConversation = isGroupConversation,
		wideMode = joined.wideMode,
		shouldHideGroupChatFunctionality = shouldHideGroupChatFunctionality,
		shouldShowAddFriends = shouldShowAddFriends,
		shouldShowCreateUnfilteredChat = false,
		shouldShowConversationTypeInfo = v13 or placementInExperience,
		conversationTypeText = conversationTypeText,
		isCreateUnfilteredChatLoading = state,
		topBarHeight = joined.topBarHeight,
		LayoutOrder = 2,
		style = style
	}, v2)

	joined2.activeParticipantId = state2

	local createElement = React.createElement
	local v16 = {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Active = true,
		AutoButtonColor = false,
		Selectable = false
	}

	local v17 = {
		ChatDetailsPage = React.createElement("Frame", {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1
		}, {
			UIListLayout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			Content = React.createElement(ChatDetailsPage, joined2)
		}),
		ParticipantDialog = 0
	}
	local participantDialog

	if state2 ~= nil then
		participantDialog = React.createElement(ParticipantDialogContainer, {
			anchorRef = state3,
			conversationId = joined.conversationId,
			isWideMode = joined.wideMode,
			navigateToDialog = joined.navigateToDialog,
			onDismiss = onDismiss,
			participantId = state2,
			showRemoveUserButton = not v11 and isGroupConversation and isGroupOwner
		})
	end

	v17.ParticipantDialog = participantDialog
	return createElement("ImageButton", v16, v17)
end
