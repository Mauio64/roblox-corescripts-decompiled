local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UIBlox")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Promise")
local getDeepValue = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/getDeepValue")
local UserProfiles = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UserProfiles")

local useCallback = React.useCallback
local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactUtils").Hooks.RoactRodux.useDispatch
local useEffect = React.useEffect
local useEffectOnMount = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactUtils").Hooks.useEffectOnMount
local useIsGroupChatEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useIsGroupChatEnabled")
local useState = React.useState
local useStyle = UIBlox.Core.Style.useStyle
local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactUtils").Hooks.RoactRodux.useSelector
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Localization").Hooks.useLocalization
local Conversation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Models/Conversation")
local ConversationChannels = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Models/ConversationChannels")
local useUserProfilesFetch = UserProfiles.Hooks.useUserProfilesFetch
local userProfilesCombinedNameAndUsernameByUserIds = UserProfiles.Queries.userProfilesCombinedNameAndUsernameByUserIds
local useIsUserPending = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useIsUserPending")
local LuaAppNavigationContext = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/LuaAppNavigationContext")
local useNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Navigation").useNavigation
local useIsChatEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useIsChatEnabled")
local useAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UniversalAppPolicy").useAppPolicy
local ChatPlacementContext = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Contexts/ChatPlacementContext")
local useChatPlacementContext = ChatPlacementContext.useChatPlacementContext
local isPlacementInExperience = ChatPlacementContext.isPlacementInExperience

local getConversationTitle = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/getConversationTitle")

local selectChatUserEntryModelList = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatDetails/Selectors/selectChatUserEntryModelList")
local ParticipantDialogContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatDetails/ParticipantDialog/ParticipantDialogContainer")

local module17 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatDetails/ChatDetailsPage")
local GenericDialogType = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatDetails/Dialogs/GenericDialogType")

local AppChatNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChatNetworking")

local useTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/useTelemetry")
local ChatDialogTelemetryLayer = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/Layers/ChatDialogTelemetryLayer")
local ChatDetailsTelemetryEvents = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatDetails/ChatDetailsTelemetryEvents")
local ChatConversationTelemetryState = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Contexts/TelemetryState/ChatConversationTelemetryState")
local ChatDetailsTelemetryState = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Contexts/TelemetryState/ChatDetailsTelemetryState")
local FFlagAppChatUseUserProfileHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatUseUserProfileHydration")
local useProfileNames = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useProfileNames")
local getCombinedNameFromProfileNames = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Users/getCombinedNameFromProfileNames")
local getFFlagIsSquadEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").GetFFlagIsSquadEnabled

local v5 = {
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

local function getParticipantProfiles(p2, participants)
	local participantProfiles = {}

	for k, item in participants do
		local v6 = getCombinedNameFromProfileNames(p2, item)

		if v6 then
			participantProfiles[k] = {
				names = { combinedName = v6 }
			}
		end
	end

	return participantProfiles
end

return function(options)
	local joined = Cryo.Dictionary.join(v5, options or {})
	local v6 = useStyle()
	local v7 = useLocalization({
		pageHeaderText = getFFlagIsSquadEnabled() and "Feature.Chat.Label.Details" or "Feature.Chat.Label.ChatDetails",
		generalText = "Feature.Chat.Label.General",
		titleNotSetText = "Feature.Chat.Label.NotSet",
		membersText = "Feature.Chat.Label.Members",
		addFriendsText = "Feature.Chat.Label.AddFriends",
		leaveGroupText = "Feature.Chat.Heading.LeaveGroup",
		chatGroupText = getFFlagIsSquadEnabled() and "Feature.Chat.Label.GroupName" or "Feature.Chat.Label.ChatGroupName",
		onlinePresenceText = "Common.Presence.Label.Online",
		offlinePresenceText = "Common.Presence.Label.Offline",
		tooManyPeopleText = {
			getFFlagIsSquadEnabled() and "Feature.Chat.Message.AddFriendsPartyLimit" or "Feature.Chat.Message.AddFriendsLimit",
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

	local v8 = React.useContext(LuaAppNavigationContext)
	local v9 = useDispatch()
	local state, setState = useState(false)
	local state2, setState2 = useState(nil)
	local state3, setState3 = useState(nil)
	local v10 = useNavigation()
	local v11 = useIsGroupChatEnabled()
	local v12 = useIsChatEnabled()
	useEffect(function()
		if not v12 then
			joined.navigateToChatLanding()
		end
	end, { v12, joined.navigateToChatLanding })

	local v13 = useSelector(function(p2)
		return getDeepValue(p2, `ChatAppReducer.Conversations.{joined.conversationId or ""}`) or Conversation.empty()
	end)

	local v14 = useSelector(function(p2)
		return getDeepValue(p2, `ChatAppReducer.ParticipantMetadata.{joined.conversationId or ""}`)
	end)

	local source = v13 and v13.source

	useEffect(function()
		if source ~= "channels" then
			return
		end

		v9(AppChatNetworking.rodux.GetConversationsParticipantsMetadata.API({ joined.conversationId })):catch(function()
			warn("Error in ChatDetailsContainer -> GetConversationsParticipantsMetadata")
		end)
	end, { joined.conversationId, joined.participants, source })

	local v15 = nil
	local v16 = nil

	if FFlagAppChatUseUserProfileHydration then
		v16 = useProfileNames(v13.participants)
	else
		v15 = useUserProfilesFetch({
			userIds = v13.participants,
			query = userProfilesCombinedNameAndUsernameByUserIds
		})
	end

	local v17 = useTelemetry(ChatDialogTelemetryLayer.Context)
	local values, v18, v19, v20, v21, v22, flag

	if v13 then
		values = useSelector(function(p2)
			local participants = v13.participants
			local v24

			if FFlagAppChatUseUserProfileHydration then
				v24 = getParticipantProfiles(v16, v13.participants)
			elseif v15 and v15.data then
				v24 = v15.data.userProfiles
			end

			return selectChatUserEntryModelList(p2, participants, v24)
		end)

		v18 = v13.conversationType == Conversation.Type.MULTI_USER_CONVERSATION
		v19 = useSelector(function(p2)
			return v18 and v13.initiator == p2.LocalUserId
		end)

		v20 = getConversationTitle(v13)

		if v14 then
			for k, v23 in values do
				values[k] = Cryo.Dictionary.join(v23, { metadata = v14[k] })
			end
		end

		v21 = useIsUserPending(v13)
		v22 = v18 and v21

		if v22 then
			v11 = false
		end

		flag = v13.moderationType == ConversationChannels.ModerationType.TrustedComms
	else
		v19 = nil
		v18 = nil
	end

	local v23 = values and #values or 0
	local v24 = if flag then v7.enabledText else v7.disabledText

	if v13.isDefaultTitle then
		v20 = v7.titleNotSetText
	end

	local function onGroupNameEntryCellActivated()
		joined.navigateToDialog(GenericDialogType.EditChatGroupNameDialog, {
			conversationId = joined.conversationId
		})
	end
	local function onLeaveGroupCellActivated()
		local v25 = if v10 then v10.getParam("isRooted", false) else false

		joined.navigateToDialog(GenericDialogType.LeaveGroupDialog, {
			conversationId = joined.conversationId,
			isRooted = v25
		})

		v17.emit(ChatDetailsTelemetryEvents.ChatDetailsLeaveGroupBtnClicked, {})
	end
	local v25 = useCallback(function()
		if v10 then
			v8.navigateToUnfilteredThreadsLearnMore(v10.navigate)
		else
			v8.navigateToUnfilteredThreadsLearnMore()
		end
	end, { v8, v10 })
	local v26 = useCallback(function()
		v17.emit(ChatDetailsTelemetryEvents.ChatDetailsCreateUnfilteredChatCellClicked, {})
		setState(true)
		v9(AppChatNetworking.rodux.DuplicateConversation.API(joined.conversationId, "trusted_comms")):andThen(function(p2)
			local responseBody = p2.responseBody

			local id = responseBody
				and responseBody.conversations
				and responseBody.conversations[1]
				and responseBody.conversations[1].id

			if id then
				joined.navigateToConversation(id)
			else
				joined.navigateToToast({
					toastProps = {
						toastContent = { toastTitle = v7.networkErrorToastText }
					}
				})
			end
		end):catch(function()
			joined.navigateToToast({
				toastProps = {
					toastContent = { toastTitle = v7.networkErrorToastText }
				}
			})
		end):finally(function()
			setState(false)
		end)
	end, {
		v9,
		setState,
		joined.navigateToToast,
		joined.navigateToConversation,
		joined.conversationId,
		v23,
		v19,
		v17
	})

	local function onDismiss()
		setState2(nil)
		setState3(nil)
	end

	local function fn(p2)
		joined.navigateToToast({
			toastProps = {
				toastContent = { toastTitle = p2 }
			}
		})
	end

	local function fn2(tooManyPeopleText)
		local v27 = v13
		Promise.new(function(callback, callback2)
			if #v27.participants > 5 then
				callback2()
			else
				callback()
			end
		end):andThen(function()
			joined.navigateToEditChatMembers(v13)
		end, function()
			fn(tooManyPeopleText)
		end)
		v17.emit(ChatDetailsTelemetryEvents.ChatDetailsAddFriendsBtnClicked, {})
	end

	local v27 = useAppPolicy(function(p2)
		return p2.getWebViewSupport()
	end)

	local placementInExperience = isPlacementInExperience(useChatPlacementContext().chatPlacement)

	local moderationType = v13 and v13.moderationType or Cryo.None
	local userPendingStatus = v13 and v13.userPendingStatus or Cryo.None
	local v28 = ChatConversationTelemetryState.useMergeState()
	useEffect(function()
		v28({
			conversationId = joined.conversationId,
			moderationType = moderationType,
			userPendingStatus = userPendingStatus
		})
	end, { joined.conversationId, moderationType, userPendingStatus })
	local v29 = ChatDetailsTelemetryState.useMergeState()
	useEffect(function()
		v29({
			participantsCount = #v13.participants,
			isGroupOwner = v19
		})
	end, { #v13.participants, v19 })

	useEffectOnMount(function()
		v17.emit(ChatDetailsTelemetryEvents.ScreenRendered, { isGroupConversation = v18 })
	end)
	local joined2 = Cryo.Dictionary.join({
		navigateBack = joined.navigateBack,
		onGroupNameEntryCellActivated = onGroupNameEntryCellActivated,
		onLeaveGroupCellActivated = onLeaveGroupCellActivated,
		onParticipantCellActivated = function(p2, p3)
			local v30 = tostring(p2)

			if state2 == v30 then
				setState2(nil)
				setState3(nil)
			else
				setState2(v30)
				setState3(p3)
			end
		end,
		onAddFriendsCellActivated = function()
			return fn2(v7.tooManyPeopleText)
		end,
		onConversationTypeIconActivated = v25,
		onCreateUnfilteredChatCellActivated = v26,
		conversationTitle = v20,
		conversation = v13,
		conversationId = joined.conversationId,
		participants = values,
		isGroupConversation = v18,
		wideMode = joined.wideMode,
		shouldHideGroupChatFunctionality = v22,
		shouldShowAddFriends = v11,
		shouldShowCreateUnfilteredChat = false,
		shouldShowConversationTypeInfo = v27 or placementInExperience,
		conversationTypeText = v24,
		isCreateUnfilteredChatLoading = state,
		topBarHeight = joined.topBarHeight,
		LayoutOrder = 2,
		style = v6
	}, v7)

	joined2.activeParticipantId = state2

	local createElement = React.createElement
	local v31 = {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Active = true,
		AutoButtonColor = false,
		Selectable = false
	}

	local v32 = {
		ChatDetailsPage = React.createElement(
			"Frame",
			{ Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1 },
			{
				UIListLayout = React.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder
				}),
				Content = React.createElement(module17, joined2)
			}
		),
		ParticipantDialog = 0
	}

	local v33 = if state2 ~= nil then React.createElement(ParticipantDialogContainer, {
		anchorRef = state3,
		conversationId = joined.conversationId,
		isWideMode = joined.wideMode,
		navigateToDialog = joined.navigateToDialog,
		onDismiss = onDismiss,
		participantId = state2,
		showRemoveUserButton = not v21 and v18 and v19
	}) else nil
	v32.ParticipantDialog = v33
	return createElement("ImageButton", v31, v32)
end
