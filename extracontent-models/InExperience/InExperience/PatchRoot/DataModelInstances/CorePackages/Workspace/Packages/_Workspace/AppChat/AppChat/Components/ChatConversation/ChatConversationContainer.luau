local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent
local HttpService = game:GetService("HttpService")
local IXPService = game:GetService("IXPService")

local Logger = require(script.Parent.Logger)
local React = require(parent.React)
local Cryo = require(parent.Cryo)
local RoactNavigation = require(parent.RoactNavigation)
local UniversalAppPolicy = require(parent.UniversalAppPolicy)
local universalAppPolicy = UniversalAppPolicy.UniversalAppPolicy
local ChatConversation = require(script.Parent.ChatConversation)
local PendingStateConversationPage = require(script.Parent.PendingState.PendingStateConversationPage)

local RoactChatAnalytics = require(AppChat.LegacyAnalytics.RoactChatAnalytics)
local useAnalytics = require(AppChat.LegacyAnalytics.useAnalytics)

local selectMessagesPure = require(AppChat.Components.ChatConversation.Messages.Selectors.selectMessagesPure)
local ConversationChannels = require(AppChat.Models.ConversationChannels)
local Conversation = require(AppChat.Models.Conversation)
local GenericDialogType = require(AppChat.Components.ChatDetails.Dialogs.GenericDialogType)

local AppChatNetworking = require(parent.AppChatNetworking)
local mapDispatchToProps = require(script.Parent.mapDispatchToProps)
local useGetConversationFromId = require(AppChat.Hooks.useGetConversationFromId)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local useEffect = React.useEffect
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useLocalUserId = RobloxAppHooks.useLocalUserId
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useMapDispatch = require(AppChat.Hooks.useMapDispatch)
local useGetUsers = require(AppChat.Hooks.useGetUsers)
local useGetUsersTyping = require(AppChat.Hooks.useGetUsersTyping)
local SignalsReact = require(parent.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local GetReplyingToStore = require(AppChat.Stores.GetReplyingToStore)
local GetConversationMessageViewModelStore = require(AppChat.Stores.GetConversationMessageViewModelStore)
local useReplyingToMessage = require(script.Parent.MessageInteraction.ReplyingContext.useReplyingToMessage)

local useReplyingToMessageDispatch = require(script.Parent.MessageInteraction.ReplyingContext.useReplyingToMessageDispatch)
local FFlagAppChatSignalsReplyStore = require(AppChat.Flags.FFlagAppChatSignalsReplyStore)
local FFlagAppChatUseUserProfileHydration = require(AppChat.Flags.FFlagAppChatUseUserProfileHydration)
local UserProfiles = require(parent.UserProfiles)
local DataHydration = require(parent.DataHydration)
local DataStatus = DataHydration.DataStatus
local useProfileNames = require(AppChat.Hooks.useProfileNames)
local getCombinedNameFromProfileNames = require(AppChat.Users.getCombinedNameFromProfileNames)

local getConversationTitle = require(AppChat.Conversations.getConversationTitle)
local getOtherParticipants = require(AppChat.Conversations.getOtherParticipants)
local useRecipientIds = require(AppChat.Hooks.useRecipientIds)
local useIsUserPending = require(AppChat.Hooks.useIsUserPending)
local useChatIsVisible = require(AppChat.Hooks.useChatIsVisible)
local RoactUtils2 = require(parent.RoactUtils)
local useSelector = RoactUtils2.Hooks.RoactRodux.useSelector
local useIsExternalNavigationAvailable = require(AppChat.Hooks.useIsExternalNavigationAvailable)
local useIsInExperience = require(AppChat.Hooks.useIsInExperience)
local useIsChatUserMessagesEnabled = require(AppChat.Hooks.useIsChatUserMessagesEnabled)
local InterventionShared = require(parent.InterventionShared)
local chatInputBoxDisabledPressedSignal = InterventionShared.Signals.chatInputBoxDisabledPressedSignal
local RoduxNetworking = require(AppChat.Http.RoduxNetworking)
local useChatTimeoutDetails = require(AppChat.Hooks.useChatTimeoutDetails)
local useChatTimeoutDetailsFromHydration = require(AppChat.Hooks.useChatTimeoutDetailsFromHydration)
local ChatConversationTelemetryLayer = require(AppChat.Telemetry.Layers.ChatConversationTelemetryLayer)
local ChatConversationTelemetryState = require(AppChat.Contexts.TelemetryState.ChatConversationTelemetryState)
local useTelemetry = require(AppChat.Telemetry.useTelemetry)
local ChatConversationTelemetryEvents = require(script.Parent.ChatConversationTelemetryEvents)
local useIsChatEnabled = require(AppChat.Hooks.useIsChatEnabled)
local InterventionShared2 = require(parent.InterventionShared)
local interventionTreatmentShownSignal = InterventionShared2.Signals.interventionTreatmentShownSignal
local RoactUtils3 = require(parent.RoactUtils)
local useSignal = RoactUtils3.Hooks.useSignal
local InterventionShared3 = require(parent.InterventionShared)
local Constants = InterventionShared3.Utils.Constants
local getAllRemainingOlderMessages = require(script.Parent.Messages.Thunks.getAllRemainingOlderMessages)
local getOlderMessages = require(script.Parent.Messages.NetworkRequests.getOlderMessages)
local useCallbackWithDynamicConversationId = require(AppChat.Hooks.useCallbackWithDynamicConversationId)
local useShouldShowConversationOverlay = require(AppChat.Hooks.useShouldShowConversationOverlay)
local useKeybind = require(AppChat.App.Hooks.useKeybind)
local EnumScreens = require(AppChat.EnumScreens)
local EnumMessageTypes = require(script.Parent.EnumMessageTypes)
local EnumCustomEntryTypes = require(script.Parent.EnumCustomEntryTypes)
local FFlagAppChatPerfTracking = require(AppChat.Flags.FFlagAppChatPerfTracking)
local FFlagAppChatMessageTTIMilestones = require(AppChat.Flags.FFlagAppChatMessageTTIMilestones)
local AppChatPerfTracker = require(AppChat.Telemetry.AppChatPerfTracker)

local SharedFlags = require(parent.SharedFlags)
local GetFFlagEnableAppChatInExperience = SharedFlags.GetFFlagEnableAppChatInExperience
local SharedFlags2 = require(parent.SharedFlags)
local FFlagTCUpsellModalEnabled_DEV = SharedFlags2.FFlagTCUpsellModalEnabled_DEV
local SharedFlags3 = require(parent.SharedFlags)
local FFlagDebugEnableTCDoubleOptIn_DEV = SharedFlags3.FFlagDebugEnableTCDoubleOptIn_DEV
local SharedFlags4 = require(parent.SharedFlags)
local FFlagAppChatShowOSAOnPageEntry = SharedFlags4.FFlagAppChatShowOSAOnPageEntry
local SharedFlags5 = require(parent.SharedFlags)
local FFlagAppChatReactiveFeatureRestrictions = SharedFlags5.FFlagAppChatReactiveFeatureRestrictions
local SharedFlags6 = require(parent.SharedFlags)
local FFlagAppChatUniversalFeatureRestriction = SharedFlags6.FFlagAppChatUniversalFeatureRestriction

local FIntAppChatGetAllMessagesDepth = require(AppChat.Flags.FIntAppChatGetAllMessagesDepth)

local SharedFlags7 = require(parent.SharedFlags)
local FFlagAppChatNavigateBackIfOSAUnacknowledged = SharedFlags7.FFlagAppChatNavigateBackIfOSAUnacknowledged
local shouldShowOSAForConversation = require(AppChat.Utils.shouldShowOSAForConversation)
local SignalsMigrationConfig = require(AppChat.Flags.SignalsMigrationConfig)
local useMessageItemList = require(AppChat.Hooks.useMessageItemList)
local useMessageItemList2 = useMessageItemList.useMessageItemList
local shouldShowU13ChatOptInForConversation = require(AppChat.Utils.shouldShowU13ChatOptInForConversation)
local Utils = require(AppChat.Utils)
local navigateWithOsaGate = Utils.navigateWithOsaGate
local FFlagAppChatConversationLoadingSkeleton = require(AppChat.Flags.FFlagAppChatConversationLoadingSkeleton)
local FFlagAppChatBlueSentBubblesIxpEnabled = require(AppChat.Flags.FFlagAppChatBlueSentBubblesIxpEnabled)
local FFlagAppChatUseDataHydrationForChatTimeouts = require(AppChat.Flags.FFlagAppChatUseDataHydrationForChatTimeouts)
local FStringAppChatBlueSentBubblesIxpLayer = require(AppChat.Flags.FStringAppChatBlueSentBubblesIxpLayer)

local isSyntheticSystemMessageId = require(script.Parent.Utils.isSyntheticSystemMessageId)

local SharedFlags8 = require(parent.SharedFlags)
local FFlagAppChatConversationTrustedFriendUpsellBanner = SharedFlags8.FFlagAppChatConversationTrustedFriendUpsellBanner
local seedConversationTopModalFromRequest

if FFlagAppChatConversationTrustedFriendUpsellBanner then
	seedConversationTopModalFromRequest = require(AppChat.Sdui.seedConversationTopModalFromRequest)
else
	seedConversationTopModalFromRequest = nil
end

local defineFastFlag = game:DefineFastFlag("AppChatConversationPageSyntheticSystemMessageIxpEnabled", false)

local defineFastString = game:DefineFastString(
	"AppChatConversationPageSyntheticSystemMessageIxpLayer",
	"Party.ConversationPage"
)

local function isOverlayNavigation(p) -- 1 equivalent call inferred from this helper
	return p and p.action and p.action.params and p.action.params.isOverlay or false
end

local v = {
	topBarHeight = 0,
	wideMode = false,
	chatInputPlaceholderKey = "Feature.Chat.Label.ChatInputPlaceholder",
	replyChatInputPlaceholderKey = "Feature.Chat.Label.ReplyChatInputPlaceholder",
	replyToYourselfChatInputPlaceholderKey = "Feature.Chat.Label.ReplyToYourselfChatInputPlaceholder",
	messageDefaultNoticeKey = "Feature.Chat.Message.Default",
	messageModeratedNoticeKey = "Feature.Chat.Message.MessageContentModerated",
	newTextKey = "Feature.Chat.Label.New",
	schedulePartyTextKey = "Feature.Squads.Action.ScheduleParty",
	messageHiddenNoticeKey = "Feature.Chat.Label.MessageNotAvailable",
	networkErrorTextKey = "Feature.Toast.NetworkingError.SomethingIsWrong",
	notImplementedMessageTypeKey = "Feature.Chat.Label.NotImplementedMessageType",
	viewProfileOnAvatarPressed = true,
	unknownUserTextKey = "Feature.Chat.Label.UnknownUser",
	oneUserTyping = {
		"Feature.Chat.Message.OneUserTyping",
		DISPLAY_NAME = ""
	},
	twoUsersTyping = {
		"Feature.Chat.Message.TwoUsersTyping",
		DISPLAY_NAME_1 = "",
		DISPLAY_NAME_2 = ""
	},
	severalUsersTyping = "Feature.Chat.Message.SeveralUsersTyping",
	pendingStateBodyKey = "Feature.Chat.Message.ChatIsUnfiltered",
	connectUnavailableWithUserKey = "Feature.Chat.RobloxConnectUnavailableWithUser",
	chatUnavailableWithUserKey = "Feature.Chat.Message.ChatUnavailableWithUser",
	getReadingMessagesIsEnabled = function() end,
	updateConversationTitle = function(_) end,
	navigateToScreen = function() end,
	inputBarDisabledKey = "Feature.Chat.Label.ChatDisabled",
	navigateToChatLanding = function() end,
	releaseInputBarFocus = function() end,
	navigateToSquadLobby = function() end,
	navigateToConversationOverlay = function() end,
	getCanAccessParty = true
}

local function isNameSettled(p, p2): boolean -- 1 equivalent call inferred from this helper
	return p ~= nil and (p.status ~= DataStatus.NotReady or getCombinedNameFromProfileNames(p, p2) ~= nil)
end

local function getOsaState(data, p, p2, p3)
	local fetchedOldestMessage = data and data.fetchedOldestMessage

	local v2 = not data or data.conversationType ~= Conversation.Type.MULTI_USER_CONVERSATION

	local shouldShowOsaCardInConversation = data
		and v2
		and (data.source == "friends" or data.osaAcknowledgementStatus == Conversation.OsaAcknowledgementStatus.Unacknowledged or data.osaAcknowledgementStatus == Conversation.OsaAcknowledgementStatus.Acknowledged)

	local v3 = data and data.osaAcknowledgementStatus == Conversation.OsaAcknowledgementStatus.Unacknowledged
	local isFriendsConversation = data and data.source == "friends"
	local shouldShowOsaCardOnInitialLoad = shouldShowOsaCardInConversation and v3 and not isFriendsConversation
	local shouldShowOsaCardNow = shouldShowOsaCardInConversation and (fetchedOldestMessage or isFriendsConversation)
	local willShowOsaCard, isOsaCardReady

	if FFlagAppChatConversationLoadingSkeleton then
		willShowOsaCard = shouldShowOsaCardOnInitialLoad or shouldShowOsaCardNow
		local v4

		if willShowOsaCard then
			v4 = getOtherParticipants(data, p)[1]
		end

		if v4 == nil then
			isOsaCardReady = true
		elseif FFlagAppChatUseUserProfileHydration then
			isOsaCardReady = isNameSettled(p3, v4) -- inferred equivalent call

			if not isOsaCardReady then
				if p2 == nil or p2.error == nil then
					if p2 == nil or p2.data == nil then
						isOsaCardReady = false
					else
						isOsaCardReady = UserProfiles.Selectors.getCombinedNameFromId(p2.data, v4) ~= nil
					end
				else
					isOsaCardReady = true
				end
			end
		elseif p2 == nil or p2.error == nil then
			if p2 == nil or p2.data == nil then
				isOsaCardReady = false
			else
				isOsaCardReady = UserProfiles.Selectors.getCombinedNameFromId(p2.data, v4) ~= nil
			end
		else
			isOsaCardReady = true
		end
	end

	return {
		shouldShowOsaCardInConversation = shouldShowOsaCardInConversation,
		fetchedOldestMessage = fetchedOldestMessage,
		shouldShowOsaCardOnInitialLoad = shouldShowOsaCardOnInitialLoad,
		shouldShowOsaCardNow = shouldShowOsaCardNow,
		isFriendsConversation = isFriendsConversation,
		willShowOsaCard = willShowOsaCard,
		isOsaCardReady = isOsaCardReady
	}
end

function ChatConversationContainer(p)
	local joined = Cryo.Dictionary.join(v, p)
	local v2 = useAnalytics()
	local v3 = React.useCallback(function(p2)
		v2:navigate(RoactChatAnalytics.NavigationEvents.ChatConversationProfile)
		joined.openViewProfile(p2)
	end, { joined.openViewProfile, v2 })
	local v4 = useMapDispatch(mapDispatchToProps)
	local conversation = useGetConversationFromId(joined.conversationId)

	local v5 = useRecipientIds(conversation)
	local success, result = pcall(function()
		return HttpService:JSONEncode(v5)
	end)

	local v6 = nil
	local v7 = nil
	local localUserId = useLocalUserId()
	local chatIsVisible = useChatIsVisible()
	local v8 = useIsChatUserMessagesEnabled()
	local v9 = useIsChatEnabled()
	local dispatch = useDispatch()

	if FFlagAppChatPerfTracking and FFlagAppChatMessageTTIMilestones and AppChatPerfTracker.Hooks then
		local v10 = AppChatPerfTracker.getEventName(AppChatPerfTracker.Events.ChatConversationTTI) or ""

		AppChatPerfTracker.Hooks.useTTIRenderAndMountedTracking(v10)
	end

	useEffect(function()
		if not v9 then
			joined.navigateToChatLanding()
		end
	end, { v9, joined.navigateToChatLanding })

	if FFlagAppChatNavigateBackIfOSAUnacknowledged then
		local v10

		if joined.navigation and joined.navigation.getParam then
			v10 = joined.navigation.getParam("isNavigatedFromGroupOSAJoin", false)
		else
			v10 = false
		end

		if FFlagAppChatShowOSAOnPageEntry then
			useEffect(function()
				if joined.navigation and joined.navigation.addListener then
					local v11 = joined.navigation.addListener(RoactNavigation.Events.WillFocus, function()
						navigateWithOsaGate({
							conversationId = joined.conversationId,
							dispatch = dispatch,
							onAccepted = function() end,
							onDeclined = function()
								joined.navigateToChatLanding()
							end
						})
					end)
					return function()
						if v11 then
							v11:remove()
						end
					end
				end
			end, { joined.navigation, joined.conversationId, dispatch })
		else
			useEffect(function()
				if not v10 and shouldShowOSAForConversation(conversation) then
					joined.navigateToChatLanding()
				end
			end, { conversation, joined.navigateToChatLanding, v10 })
		end
	end

	if FFlagAppChatShowOSAOnPageEntry then
		useEffect(function()
			if not conversation then
				return
			end

			local v10 = shouldShowOSAForConversation(conversation)
			local v11 = shouldShowU13ChatOptInForConversation(conversation)

			if v10 or v11 then
				navigateWithOsaGate({
					conversationId = joined.conversationId,
					dispatch = dispatch,
					onAccepted = function() end,
					onDeclined = function()
						joined.navigateToChatLanding()
					end
				})
			end
		end, { conversation, joined.conversationId, dispatch })
	end

	useSignal(interventionTreatmentShownSignal, React.useCallback(function(p2)
		if
			p2 == Constants.TreatmentType.PartyChatNudgeDialog
			or p2 == Constants.TreatmentType.PartyChatTimeoutDialog
		then
			joined.releaseInputBarFocus()
		end
	end, { joined.releaseInputBarFocus }))

	if FFlagAppChatUseUserProfileHydration then
		v7 = useProfileNames(getOtherParticipants(conversation, localUserId))
	else
		v6 = UserProfiles.Hooks.useUserProfilesFetch({
			userIds = getOtherParticipants(conversation, localUserId),
			query = UserProfiles.Queries.userProfilesCombinedNameAndUsernameByUserIds
		})
	end

	local conversationTitle = getConversationTitle(conversation)

	local users = useGetUsers()
	local usersTyping = useGetUsersTyping(joined.conversationId)

	local ref = React.useRef({
		itemList = {},
		previousMessagesState = {},
		previousSendingMessagesState = {},
		previousMessagesResult = {}
	})
	local v10

	if SignalsMigrationConfig.shouldReadMessageListFromSignalsStore then
		v10 = useMessageItemList2(joined.conversationId, users, localUserId, conversation)
	else
		v10 = nil
	end

	local v11 = React.useMemo(function()
		if SignalsMigrationConfig.shouldReadMessageListFromSignalsStore then
			return v10
		end

		local v11 = FFlagAppChatPerfTracking
			and FFlagAppChatMessageTTIMilestones
			and AppChatPerfTracker.isActive(AppChatPerfTracker.Events.ChatConversationTTI, {
				conversationId = joined.conversationId
			})

		if v11 then
			local v12 = { conversationId = joined.conversationId }
			AppChatPerfTracker.trackMilestone(
				AppChatPerfTracker.Events.ChatConversationTTI,
				AppChatPerfTracker.Milestone.DataProcessingStarted.Name,
				v12
			)

			AppChatPerfTracker.trackSubphase(
				AppChatPerfTracker.Events.ChatConversationTTI,
				AppChatPerfTracker.Milestone.DataProcessingStarted.Name,
				AppChatPerfTracker.Milestone.DataProcessingStarted.Subphase.DataUpdate,
				v12
			)
		end

		ref.current = selectMessagesPure(
			{
				conversation = conversation,
				conversationId = joined.conversationId,
				Users = users,
				localUserId = localUserId
			},
			ref.current
		)

		if v11 then
			local v12 = { conversationId = joined.conversationId }
			AppChatPerfTracker.trackMilestone(
				AppChatPerfTracker.Events.ChatConversationTTI,
				AppChatPerfTracker.Milestone.DataProcessingCompleted.Name,
				v12
			)

			AppChatPerfTracker.trackSubphase(
				AppChatPerfTracker.Events.ChatConversationTTI,
				AppChatPerfTracker.Milestone.DataProcessingCompleted.Name,
				AppChatPerfTracker.Milestone.DataProcessingCompleted.Subphase.DataUpdate,
				v12
			)
		end

		return ref.current.itemList
	end, { conversation, joined.conversationId, users, localUserId, v10 })
	local v12

	if FFlagAppChatUseUserProfileHydration then
		v12 = v7
	end

	local osaState = getOsaState(conversation, localUserId, v6, v12)

	local itemList = React.useMemo(function()
		local v13 = {}

		if osaState.shouldShowOsaCardOnInitialLoad and not osaState.fetchedOldestMessage then
			return v13
		end

		local clone = table.clone(v11)

		if osaState.shouldShowOsaCardNow then
			table.insert(clone, {
				messageType = EnumMessageTypes.Custom,
				customEntryType = EnumCustomEntryTypes.OsaContextCardOneToOne,
				stable_key = EnumCustomEntryTypes.OsaContextCardOneToOne
			})
		end

		return clone
	end, {
		v11,
		conversation,
		osaState.shouldShowOsaCardOnInitialLoad,
		osaState.shouldShowOsaCardInConversation,
		osaState.shouldShowOsaCardNow,
		osaState.fetchedOldestMessage
	})
	local isInitialMessageLoading

	if FFlagAppChatConversationLoadingSkeleton then
		local v13 = useSelector(function(p2)
			return AppChatNetworking.rodux.GetOlderMessages.getStatus(p2, joined.conversationId)
		end)
		local v14, v15

		if osaState.isFriendsConversation then
			v14 = osaState.isOsaCardReady
			v15 = osaState.willShowOsaCard
		elseif osaState.shouldShowOsaCardOnInitialLoad then
			if osaState.fetchedOldestMessage == true then
				v14 = osaState.isOsaCardReady
			else
				v14 = false
			end

			v15 = true
		else
			v14 = v13 == RoduxNetworking.Enum.NetworkStatus.Done or osaState.fetchedOldestMessage == true
			v15 = v13 == RoduxNetworking.Enum.NetworkStatus.NotStarted
				or v13 == RoduxNetworking.Enum.NetworkStatus.Fetching
		end

		local ref2 = React.useRef({ conversationId = nil, hasLoadedFirstPage = false })

		if ref2.current.conversationId ~= joined.conversationId then
			ref2.current = { conversationId = joined.conversationId, hasLoadedFirstPage = false }
		end

		ref2.current.hasLoadedFirstPage = ref2.current.hasLoadedFirstPage or v14

		isInitialMessageLoading = conversation and not ref2.current.hasLoadedFirstPage and v15
	else
		isInitialMessageLoading = false
	end

	local v13

	if FFlagAppChatUseUserProfileHydration then
		v13 = getCombinedNameFromProfileNames(v7, usersTyping[1] and usersTyping[1].id)
	elseif usersTyping[1] and v6.data then
		v13 = UserProfiles.Selectors.getCombinedNameFromId(v6.data, usersTyping[1].id)
	end

	local v14

	if FFlagAppChatUseUserProfileHydration then
		v14 = getCombinedNameFromProfileNames(v7, usersTyping[2] and usersTyping[2].id)
	elseif usersTyping[2] and v6.data then
		v14 = UserProfiles.Selectors.getCombinedNameFromId(v6.data, usersTyping[2].id)
	end

	local displayNamesAvailable = true

	if #usersTyping == 1 and not v13 then
		displayNamesAvailable = false
	elseif #usersTyping == 2 and not (v13 and v14) then
		displayNamesAvailable = false
	end

	local isInExperience = GetFFlagEnableAppChatInExperience() and useIsInExperience()
	local v15

	if FFlagAppChatSignalsReplyStore then
		v15 = GetReplyingToStore(false)
	end

	local conversationMessageStore

	if FFlagAppChatSignalsReplyStore then
		conversationMessageStore = GetConversationMessageViewModelStore(false).conversationMessageStore
	end

	local replyingToMessage = nil
	local replyingToMessageDispatch = nil
	local replyingToMessageId = nil
	local v16 = nil
	local v17 = nil

	if FFlagAppChatSignalsReplyStore then
		replyingToMessageId = useSignalState(v15.getMessageId)

		if replyingToMessageId then
			local v18 = conversationMessageStore.messages(false)[replyingToMessageId]
			local sender_user_id

			if v18 and v18.sender_user_id then
				sender_user_id = tostring(v18.sender_user_id)
			end

			v17 = sender_user_id == localUserId

			if FFlagAppChatUseUserProfileHydration then
				if not v17 then
					v16 = getCombinedNameFromProfileNames(v7, sender_user_id)
				end
			elseif not (v17 or not (sender_user_id and v6.data)) then
				v16 = UserProfiles.Selectors.getCombinedNameFromId(v6.data, sender_user_id)
			end
		end
	else
		replyingToMessage = useReplyingToMessage()
		replyingToMessageDispatch = useReplyingToMessageDispatch()

		if replyingToMessage then
			v17 = replyingToMessage.senderTargetId == localUserId

			if FFlagAppChatUseUserProfileHydration then
				if not v17 then
					v16 = getCombinedNameFromProfileNames(v7, replyingToMessage.senderTargetId)
				end
			elseif not (v17 or not v6.data) then
				v16 = UserProfiles.Selectors.getCombinedNameFromId(v6.data, replyingToMessage.senderTargetId)
			end
		end
	end

	local v18 = useLocalization({
		chatInputPlaceholder = joined.chatInputPlaceholderKey,
		replyChatInputPlaceholder = {
			joined.replyChatInputPlaceholderKey,
			DISPLAY_NAME = v16
		},
		replyToYourselfChatInputPlaceholder = joined.replyToYourselfChatInputPlaceholderKey,
		invalidMessageTypeText = joined.notImplementedMessageTypeKey,
		messageDefaultNoticeText = joined.messageDefaultNoticeKey,
		messageModeratedNoticeText = joined.messageModeratedNoticeKey,
		messageHiddenNoticeText = joined.messageHiddenNoticeKey,
		networkErrorText = joined.networkErrorTextKey,
		newText = joined.newTextKey,
		schedulePartyText = joined.schedulePartyTextKey,
		unknownUserText = joined.unknownUserTextKey,
		oneUserTyping = {
			"Feature.Chat.Message.OneUserTyping",
			DISPLAY_NAME = v13
		},
		twoUsersTyping = {
			"Feature.Chat.Message.TwoUsersTyping",
			DISPLAY_NAME_1 = v13,
			DISPLAY_NAME_2 = v14
		},
		severalUsersTyping = joined.severalUsersTyping,
		bottomModalText = joined.chatUnavailableWithUserKey,
		inputBarDisabledText = joined.inputBarDisabledKey
	})

	local v19 = useTelemetry(ChatConversationTelemetryLayer.Context)
	local v20 = ChatConversationTelemetryState.useMergeState()
	local v21 = ChatConversationTelemetryState.useClearState()

	local moderationType = conversation and conversation.moderationType or Cryo.None
	local userPendingStatus = conversation and conversation.userPendingStatus or Cryo.None
	useEffect(function()
		v20({
			conversationId = joined.conversationId,
			moderationType = moderationType,
			userPendingStatus = userPendingStatus
		})
	end, { v20, joined.conversationId, moderationType, userPendingStatus })

	local v22 = useIsUserPending(conversation or {})
	local source = conversation and conversation.source

	local v23, v24 = useCallbackWithDynamicConversationId(
		AppChatNetworking.rodux.GetModalSequence.API,
		joined.conversationId
	)

	useEffect(function()
		if not v24 then
			return
		end

		if v22 and source == "channels" then
			dispatch(AppChatNetworking.rodux.GetPendingStateModal.API(joined.conversationId, isInExperience)):catch(function(p2)
				Logger:warning(`GetPendingStateModal error in ChatConversationContainer {tostring(p2)}`)
			end)
		end

		if not v22 then
			local v25 = dispatch(v23({
				modalSequence = AppChatNetworking.Constants.ModalSequence.ConversationTopModal,
				isInExperience = isInExperience
			}))

			if FFlagAppChatConversationTrustedFriendUpsellBanner then
				v25 = seedConversationTopModalFromRequest(v25, joined.conversationId)
			end

			v25:catch(function(p2)
				Logger:warning(`GetModalSequence for ConversationTopModal error in ChatConversationContainer {tostring(p2)}`)
			end)
		end
	end, { joined.conversationId, v24, isInExperience, v22, source })
	local v25, v26 = useCallbackWithDynamicConversationId(
		AppChatNetworking.rodux.GetModalSequence.API,
		joined.conversationId
	)

	useEffect(function()
		if not v22 and v26 then
			dispatch(v25({
				modalSequence = AppChatNetworking.Constants.ModalSequence.ConversationOverlay,
				isInExperience = isInExperience
			})):catch(function(p2)
				Logger:warning(`GetModalSequence error in ChatConversationContainer {tostring(p2)}`)
			end)
		end
	end, { v26, joined.conversationId, v22, isInExperience, moderationType })

	if FFlagDebugEnableTCDoubleOptIn_DEV then
		useKeybind({ keyCode = Enum.KeyCode.O, modifierKey = Enum.ModifierKey.Ctrl }, function()
			Logger:debug("Ctrl + O pressed, showing new TC double opt in banner")
			dispatch({
				type = "DEBUG_ShowNewTopModal",
				conversationId = joined.conversationId,
				modalVariant = AppChatNetworking.Constants.ConversationTopModal.AddTrustedConnection
			})
		end, { dispatch, joined.conversationId })

		useKeybind({ keyCode = Enum.KeyCode.P, modifierKey = Enum.ModifierKey.Ctrl }, function()
			Logger:debug("Ctrl + P pressed, showing new TC double opt in request banner")
			dispatch({
				type = "DEBUG_ShowNewTopModal",
				conversationId = joined.conversationId,
				modalVariant = AppChatNetworking.Constants.ConversationTopModal.TrustedConnectionRequest
			})
		end, { dispatch, joined.conversationId })
	end

	if FFlagTCUpsellModalEnabled_DEV then
		useKeybind({ keyCode = Enum.KeyCode.L, modifierKey = Enum.ModifierKey.Ctrl }, function()
			Logger:debug("Ctrl + L pressed, showing new TC created overlay")
			dispatch({
				type = "DEBUG_ShowNewTCOverlay",
				conversationId = joined.conversationId,
				modalVariant = AppChatNetworking.Constants.ConversationOverlay.TrustedConnectionCreated
			})
		end, { dispatch, joined.conversationId })
	end

	local v27, v28 = useCallbackWithDynamicConversationId(
		AppChatNetworking.rodux.GetModalSequence.API,
		joined.conversationId
	)

	useEffect(function()
		if not v28 then
			return
		end

		dispatch(v27({
			modalSequence = AppChatNetworking.Constants.ModalSequence.ConversationBottomModal,
			isInExperience = isInExperience
		})):catch(function(p2)
			Logger:warning(`GetModalSequence for ConversationBottomModal error in ChatConversationContainer {tostring(p2)}`)
		end)
	end, { joined.conversationId, v28, isInExperience, dispatch, v27 })

	local v29 = useShouldShowConversationOverlay(joined.conversationId)
	useEffect(function()
		if v29 then
			joined.navigateToConversationOverlay()
		end
	end, { v29, joined.conversationId })
	local v30 = source ~= "channels"
	local v31 = useSelector(function(p2): boolean
		local v31

		if v30 then
			v31 = AppChatNetworking.rodux.GetChatModerationStatuses.getStatus(p2)
		else
			v31 = AppChatNetworking.rodux.GetChatModerationStatuses.getStatus(p2, joined.conversationId)
		end

		return v31 == RoduxNetworking.Enum.NetworkStatus.NotStarted
	end)

	useEffect(function()
		if v31 and not FFlagAppChatUseDataHydrationForChatTimeouts then
			dispatch(AppChatNetworking.rodux.GetChatModerationStatuses.API(not v30 and { joined.conversationId } or nil)):catch(function(p2)
				warn("GetChatModerationStatuses error in ChatConversationContainer " .. tostring(p2))
			end)
		end
	end, { joined.conversationId, v30, dispatch, v31 })
	local v32

	if FFlagAppChatUseDataHydrationForChatTimeouts then
		v32 = useSignalState(useChatTimeoutDetailsFromHydration({
			conversationId = joined.conversationId,
			conversationModerationType = moderationType
		}))
	else
		v32 = useChatTimeoutDetails({
			conversationId = joined.conversationId,
			conversationModerationType = moderationType
		})
	end

	local isTimedOut = v32.isTimedOut
	local timeoutEndTimestamp = v32.timeoutEndTimestamp
	local decisionEventId = v32.decisionEventId
	local duration = v32.duration

	useEffect(function()
		v19.emit(ChatConversationTelemetryEvents.ScreenRendered, {
			loadedMessageCount = #v11
		})
	end, { joined.conversationId })

	if defineFastFlag then
		local v47 = v11[1]
		local id

		if v47 then
			id = v47.id
		else
			id = nil
		end

		useEffect(function()
			if isSyntheticSystemMessageId(id) then
				IXPService:LogFlagLinkedUserLayerExposure(defineFastString)
			end
		end, { joined.conversationId, id })
	end

	if FFlagAppChatBlueSentBubblesIxpEnabled then
		local v47 = React.useMemo(function(): boolean
			for _, v48 in v11 do
				if not v48.isIncoming and v48.messageType == EnumMessageTypes.PlainText then
					return true
				end
			end

			return false
		end, { v11 })
		useEffect(function()
			if v47 then
				IXPService:LogFlagLinkedUserLayerExposure(FStringAppChatBlueSentBubblesIxpLayer)
			end
		end, { joined.conversationId, v47 })
	end

	local onConversationUnmount = React.useCallback(function(conversationExitType: string)
		v19.emit(ChatConversationTelemetryEvents.ScreenExit, {
			conversationExitType = conversationExitType
		})

		v21()
	end, { v19, v21 })

	conversation = conversation or {}
	local shouldShowChatInputBar

	if conversation.participantPendingStatus == ConversationChannels.UserPendingStatus.Pending then
		shouldShowChatInputBar = false
	else
		shouldShowChatInputBar = v8
	end

	local v50 = useIsExternalNavigationAvailable({ EnumScreens.ViewUserProfile })

	local v51 = conversation.conversationType == Conversation.Type.MULTI_USER_CONVERSATION
	local v52 = useSelector(function(p2)
		return v51 and conversation.initiator == p2.LocalUserId
	end)

	local function fn(participantId)
		if v50[EnumScreens.ViewUserProfile] then
			v3(participantId)
		else
			joined.navigateToScreen(GenericDialogType.ParticipantDialog, {
				conversationId = joined.conversationId,
				participantId = participantId,
				showRemoveUserButton = not v22 and v51 and v52
			}, true)
		end
	end

	local v53

	if FFlagAppChatSignalsReplyStore then
		v53 = replyingToMessageId
	else
		v53 = replyingToMessage
	end

	local chatInputPlaceholder

	if v53 then
		if v17 then
			chatInputPlaceholder = v18.replyToYourselfChatInputPlaceholder
		else
			chatInputPlaceholder = v18.replyChatInputPlaceholder
		end
	else
		chatInputPlaceholder = v18.chatInputPlaceholder
	end

	useEffect(function()
		joined.updateConversationTitle(conversationTitle)
	end, { conversationTitle, joined.updateConversationTitle })

	local onDisabledInputBarActivated = React.useCallback(function()
		if not FFlagAppChatUniversalFeatureRestriction then
			chatInputBoxDisabledPressedSignal:fire({
				endTimestamp = timeoutEndTimestamp,
				decisionEventId = decisionEventId,
				duration = duration
			})

			return
		end

		local AbuseVector = require(parent.UniversalFeatureRestrictions.AbuseVector)
		local showFeatureRestriction = require(parent.UniversalFeatureRestrictions.showFeatureRestriction)
		local v56 = {
			onShown = joined.releaseInputBarFocus,
			onAppeal = function() end
		}

		if FFlagAppChatReactiveFeatureRestrictions then
			local InterventionShared4 = require(parent.InterventionShared)
			local partyChatTimeoutReceivedSignal = InterventionShared4.Signals.partyChatTimeoutReceivedSignal
			function v56.onAcknowledgementSuccess()
				partyChatTimeoutReceivedSignal:fire(nil)
			end
		end

		showFeatureRestriction(AbuseVector.PartyChat, v56)
	end, { joined.releaseInputBarFocus, timeoutEndTimestamp, decisionEventId, duration })

	local state, setState = React.useState(joined.navigation and joined.navigation.isFocused and joined.navigation.isFocused())
	local v56, v57

	if FFlagAppChatPerfTracking then
		if joined.isFocused and not joined.isFocused() then
			v56 = false
		else
			v56 = state
		end

		v57 = v56 and not v22
	else
		v57 = nil
	end

	local onChatInputBarReady

	if FFlagAppChatPerfTracking then
		local ref2 = React.useRef(false)

		React.useEffect(function()
			ref2.current = not shouldShowChatInputBar
		end, { joined.conversationId, shouldShowChatInputBar })

		local v59 = React.useCallback(function(p2: string)
			if not (AppChatPerfTracker.isActive(AppChatPerfTracker.Events.ChatConversationTTI, {
				conversationId = joined.conversationId
			}) and v57) then
				return
			end

			if ref2.current then
				AppChatPerfTracker.finish(AppChatPerfTracker.Events.ChatConversationTTI, {
					conversationId = joined.conversationId,
					numElementsRendered = #v11
				})
			else
				Logger:debug(
					"TTI: Messages ready but waiting for input bar (chatInputBarReady={}, reason={})",
					ref2.current,
					p2
				)
			end
		end, {
			joined.conversationId,
			state,
			v22,
			#v11
		})

		React.useEffect(function()
			v59("messages_ready")
		end, { v59, #v11, joined.conversationId })

		onChatInputBarReady = React.useCallback(function()
			ref2.current = true
			v59("input_bar_ready")
		end, { v59 })
	end

	if FFlagAppChatPerfTracking then
		local ref2 = React.useRef(nil)

		React.useEffect(function()
			Logger:debug("Perf: Resetting message perf tracking for conversation {}", joined.conversationId)

			ref2.current = nil

			local v59 = { conversationId = joined.conversationId }

			if FFlagAppChatMessageTTIMilestones then
				AppChatPerfTracker.cancel(AppChatPerfTracker.Events.MessageSendTTI, v59)
				AppChatPerfTracker.cancel(AppChatPerfTracker.Events.MessageReceiveTTI, v59)
			else
				AppChatPerfTracker.cancel(AppChatPerfTracker.Events.MessageSendToPendingRender, v59)
				AppChatPerfTracker.cancel(AppChatPerfTracker.Events.MessageSendResponseToFinalRender, v59)
				AppChatPerfTracker.cancel(AppChatPerfTracker.Events.MessageSendToFinalRender, v59)
				AppChatPerfTracker.cancel(AppChatPerfTracker.Events.MessageReceiveToRender, v59)
			end
		end, { joined.conversationId })

		React.useEffect(function()
			local v59 = v11[1]

			if not (v59 and v59.id) then
				return
			end

			local v60 = { conversationId = joined.conversationId }
			local v61 = v59.senderTargetId == localUserId

			if not v59.isSending and (v59.senderType == "system" or not v61) then
				if v59.id ~= ref2.current then
					ref2.current = v59.id

					if FFlagAppChatMessageTTIMilestones then
						AppChatPerfTracker.finish(AppChatPerfTracker.Events.MessageReceiveTTI, v60)
					else
						AppChatPerfTracker.finish(AppChatPerfTracker.Events.MessageReceiveToRender, v60)
					end
				end
			elseif FFlagAppChatMessageTTIMilestones then
				if AppChatPerfTracker.isActive(AppChatPerfTracker.Events.MessageReceiveTTI, v60) then
					AppChatPerfTracker.cancel(AppChatPerfTracker.Events.MessageReceiveTTI, v60)
				end
			elseif AppChatPerfTracker.isActive(AppChatPerfTracker.Events.MessageReceiveToRender, v60) then
				AppChatPerfTracker.cancel(AppChatPerfTracker.Events.MessageReceiveToRender, v60)
			end

			if not v61 then
				return
			end

			if FFlagAppChatMessageTTIMilestones then
				if v59.isSending then
					AppChatPerfTracker.trackMilestone(
						AppChatPerfTracker.Events.MessageSendTTI,
						AppChatPerfTracker.Milestone.FunctionallyReady,
						v60
					)
				else
					AppChatPerfTracker.finish(AppChatPerfTracker.Events.MessageSendTTI, v60)
				end
			else
				if v59.isSending then
					AppChatPerfTracker.finish(AppChatPerfTracker.Events.MessageSendToPendingRender, v60)
					return
				end

				AppChatPerfTracker.finish(AppChatPerfTracker.Events.MessageSendResponseToFinalRender, v60)
				AppChatPerfTracker.finish(AppChatPerfTracker.Events.MessageSendToFinalRender, v60)
			end
		end, { v11, localUserId, joined.conversationId })
	end

	useEffect(function()
		local v59 = joined.navigation
			and joined.navigation.addListener
			and joined.navigation.addListener(RoactNavigation.Events.WillBlur, function(p2)
				if FFlagAppChatPerfTracking then
					local overlayNavigation = isOverlayNavigation(p2) -- inferred equivalent call
					setState(overlayNavigation)

					if overlayNavigation then
						return
					end

					if AppChatPerfTracker.isActive(AppChatPerfTracker.Events.ChatConversationTTI, {
						conversationId = joined.conversationId
					}) then
						AppChatPerfTracker.cancel(AppChatPerfTracker.Events.ChatConversationTTI, {
							conversationId = joined.conversationId
						})
					end
				elseif p2 and p2.action and p2.action.params and p2.action.params.isOverlay then
					setState(true)
				else
					setState(false)
				end
			end)

		local v60 = joined.navigation
			and joined.navigation.addListener
			and joined.navigation.addListener(RoactNavigation.Events.WillFocus, function(_)
				setState(true)
			end)

		return function()
			if v59 then
				v59.remove()
			end

			if v60 then
				v60.remove()
			end
		end
	end, { joined.navigation, joined.conversationId })

	useEffect(function()
		if osaState.shouldShowOsaCardOnInitialLoad then
			dispatch(getAllRemainingOlderMessages(
				getOlderMessages,
				joined.conversationId,
				FIntAppChatGetAllMessagesDepth
			)):catch(function()
				joined.navigateToToast({
					toastProps = {
						toastContent = { toastTitle = v18.networkErrorText }
					}
				})
			end)
		end
	end, { osaState.shouldShowOsaCardOnInitialLoad })

	local getCanAccessParty = joined.getCanAccessParty

	if FFlagAppChatPerfTracking then
		if not v56 then
			return nil
		end

		if v22 then
			return React.createElement(PendingStateConversationPage, {
				conversationId = joined.conversationId,
				topBarHeight = joined.topBarHeight,
				networkErrorText = v18.networkErrorText,
				navigateToToast = joined.navigateToToast,
				wideMode = joined.wideMode,
				onConversationUnmount = onConversationUnmount,
				navigateBack = joined.navigateBack
			})
		end
	else
		if not state or joined.isFocused and not joined.isFocused() then
			return nil
		end

		if v22 then
			return React.createElement(PendingStateConversationPage, {
				conversationId = joined.conversationId,
				topBarHeight = joined.topBarHeight,
				networkErrorText = v18.networkErrorText,
				navigateToToast = joined.navigateToToast,
				wideMode = joined.wideMode,
				onConversationUnmount = onConversationUnmount,
				navigateBack = joined.navigateBack,
				style = joined.style
			})
		end
	end

	local createElement = React.createElement

	local join = Cryo.Dictionary.join
	local v59 = {
		moreMenuEnabled = getCanAccessParty,
		conversation = conversation,
		conversationTitle = conversationTitle,
		itemList = itemList,
		localUserId = localUserId,
		openGameDetailsPage = joined.openGameDetailsPage,
		openViewProfile = fn,
		readingMessagesIsEnabled = joined.getReadingMessagesIsEnabled(),
		Users = users,
		usersTyping = usersTyping,
		displayNamesAvailable = displayNamesAvailable,
		onConversationUnmount = onConversationUnmount,
		recipientIdsSerialized = not success and "[]" or result,
		chatIsVisible = chatIsVisible,
		chatInputPlaceholder = chatInputPlaceholder,
		replyingToMessageId = 0,
		replyingToMessage = 0,
		replyingToMessageDispatch = 0,
		shouldShowChatInputBar = 0,
		shouldShowLegacyBottomModal = 0,
		shouldDisableChatInputBar = 0,
		onChatInputBarReady = 0,
		inputBarDisabledEndTimestampDisplay = 0,
		onDisabledInputBarActivated = 0,
		scrollToTopOnInitialOsaLoad = 0,
		openMessageListAtStart = 0,
		navigateToSquadLobby = 0,
		shouldHideMoreMenuButton = 0,
		isInitialMessageLoading = 0
	}

	if not FFlagAppChatSignalsReplyStore then
		replyingToMessageId = nil
	end

	v59.replyingToMessageId = replyingToMessageId

	if FFlagAppChatSignalsReplyStore then
		replyingToMessage = nil
	end

	v59.replyingToMessage = replyingToMessage

	if FFlagAppChatSignalsReplyStore then
		replyingToMessageDispatch = nil
	end

	v59.replyingToMessageDispatch = replyingToMessageDispatch

	v59.shouldShowChatInputBar = shouldShowChatInputBar
	v59.shouldShowLegacyBottomModal = not shouldShowChatInputBar and v8
	v59.shouldDisableChatInputBar = isTimedOut

	if not FFlagAppChatPerfTracking then
		onChatInputBarReady = nil
	end

	v59.onChatInputBarReady = onChatInputBarReady
	v59.inputBarDisabledEndTimestampDisplay = timeoutEndTimestamp
	v59.onDisabledInputBarActivated = onDisabledInputBarActivated
	v59.scrollToTopOnInitialOsaLoad = osaState.shouldShowOsaCardOnInitialLoad and osaState.fetchedOldestMessage
	v59.openMessageListAtStart = osaState.shouldShowOsaCardOnInitialLoad
	local navigateToSquadLobby

	if getCanAccessParty then
		navigateToSquadLobby = joined.navigateToSquadLobby
	end

	v59.navigateToSquadLobby = navigateToSquadLobby
	local shouldHideMoreMenuButton

	if getCanAccessParty then
		shouldHideMoreMenuButton = not shouldShowChatInputBar
	end

	v59.shouldHideMoreMenuButton = shouldHideMoreMenuButton

	if not FFlagAppChatConversationLoadingSkeleton then
		isInitialMessageLoading = nil
	end

	v59.isInitialMessageLoading = isInitialMessageLoading
	return createElement(ChatConversation, join(joined, v4, v18, v59))
end

return universalAppPolicy.connect(function(p)
	return {
		viewProfileOnAvatarPressed = p.getChatTapConversationThumbnail(),
		getCanAccessParty = p.getCanAccessParty()
	}
end)(ChatConversationContainer)
