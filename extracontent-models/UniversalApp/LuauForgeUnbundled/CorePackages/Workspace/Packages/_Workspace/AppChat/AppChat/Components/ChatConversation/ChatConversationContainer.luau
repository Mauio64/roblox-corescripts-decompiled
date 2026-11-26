local HttpService = game:GetService("HttpService")
local IXPService = game:GetService("IXPService")

local Logger = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/Logger")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local RoactNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactNavigation")
local universalAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UniversalAppPolicy").UniversalAppPolicy
local ChatConversation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/ChatConversation")
local PendingStateConversationPage = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/PendingState/PendingStateConversationPage")

local RoactChatAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/LegacyAnalytics/RoactChatAnalytics")
local useAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/LegacyAnalytics/useAnalytics")

local selectMessagesPure = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/Messages/Selectors/selectMessagesPure")
local ConversationChannels = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Models/ConversationChannels")
local Conversation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Models/Conversation")
local GenericDialogType = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatDetails/Dialogs/GenericDialogType")

local AppChatNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChatNetworking")
local mapDispatchToProps = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/mapDispatchToProps")
local useGetConversationFromId = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useGetConversationFromId")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Localization").Hooks.useLocalization
local useEffect = React.useEffect
local useLocalUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RobloxAppHooks").useLocalUserId
local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactUtils").Hooks.RoactRodux.useDispatch
local useMapDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useMapDispatch")
local useGetUserFromId = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useGetUserFromId")
local useGetUsersTyping = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useGetUsersTyping")
local useSignalState = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SignalsReact").useSignalState
local GetReplyingToStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetReplyingToStore")
local GetConversationMessageViewModelStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetConversationMessageViewModelStore")
local useReplyingToMessage = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/MessageInteraction/ReplyingContext/useReplyingToMessage")

local useReplyingToMessageDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/MessageInteraction/ReplyingContext/useReplyingToMessageDispatch")
local FFlagAppChatSignalsReplyStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatSignalsReplyStore")
local FFlagAppChatUseUserProfileHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatUseUserProfileHydration")
local UserProfiles = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UserProfiles")
local dataStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/DataHydration").DataStatus
local useProfileNames = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useProfileNames")
local getCombinedNameFromProfileNames = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Users/getCombinedNameFromProfileNames")

local getConversationTitle = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/getConversationTitle")
local getOtherParticipants = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/getOtherParticipants")
local useRecipientIds = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useRecipientIds")
local useIsUserPending = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useIsUserPending")
local useChatIsVisible = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useChatIsVisible")
local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactUtils").Hooks.RoactRodux.useSelector
local useIsExternalNavigationAvailable = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useIsExternalNavigationAvailable")
local useIsInExperience = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useIsInExperience")
local useIsChatUserMessagesEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useIsChatUserMessagesEnabled")
local chatInputBoxDisabledPressedSignal = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/InterventionShared").Signals.chatInputBoxDisabledPressedSignal
local RoduxNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Http/RoduxNetworking")
local useChatTimeoutDetails = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useChatTimeoutDetails")
local useChatTimeoutDetailsFromHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useChatTimeoutDetailsFromHydration")
local ChatDetailsTelemetryLayer = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/Layers/ChatDetailsTelemetryLayer")
local ChatConversationTelemetryState = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Contexts/TelemetryState/ChatConversationTelemetryState")
local useTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/useTelemetry")
local ChatConversationTelemetryEvents = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/ChatConversationTelemetryEvents")
local useIsChatEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useIsChatEnabled")
local interventionTreatmentShownSignal = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/InterventionShared").Signals.interventionTreatmentShownSignal
local useSignal = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactUtils").Hooks.useSignal
local constants = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/InterventionShared").Utils.Constants
local getAllRemainingOlderMessages = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/Messages/Thunks/getAllRemainingOlderMessages")
local getOlderMessages = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/Messages/NetworkRequests/getOlderMessages")
local useCallbackWithDynamicConversationId = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useCallbackWithDynamicConversationId")
local useShouldShowConversationOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useShouldShowConversationOverlay")
local useKeybind = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/App/Hooks/useKeybind")
local EnumScreens = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/EnumScreens")
local EnumMessageTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/EnumMessageTypes")
local EnumCustomEntryTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/EnumCustomEntryTypes")
local FFlagAppChatPerfTracking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatPerfTracking")
local FFlagAppChatMessageTTIMilestones = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatMessageTTIMilestones")
local AppChatPerfTracker = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/AppChatPerfTracker")

local getFFlagEnableAppChatInExperience = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").GetFFlagEnableAppChatInExperience
local fFlagTCUpsellModalEnabled_DEV = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").FFlagTCUpsellModalEnabled_DEV
local fFlagDebugEnableTCDoubleOptIn_DEV = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").FFlagDebugEnableTCDoubleOptIn_DEV
local fFlagAppChatShowOSAOnPageEntry = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").FFlagAppChatShowOSAOnPageEntry
local fFlagAppChatReactiveFeatureRestrictions = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").FFlagAppChatReactiveFeatureRestrictions
local fFlagAppChatUniversalFeatureRestriction = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").FFlagAppChatUniversalFeatureRestriction

local FIntAppChatGetAllMessagesDepth = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FIntAppChatGetAllMessagesDepth")

local fFlagAppChatNavigateBackIfOSAUnacknowledged = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").FFlagAppChatNavigateBackIfOSAUnacknowledged
local shouldShowOSAForConversation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/shouldShowOSAForConversation")
local SignalsMigrationConfig = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/SignalsMigrationConfig")
local useMessageItemList = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useMessageItemList").useMessageItemList
local shouldShowU13ChatOptInForConversation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/shouldShowU13ChatOptInForConversation")
local navigateWithOsaGate = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils").navigateWithOsaGate
local FFlagAppChatConversationLoadingSkeleton = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatConversationLoadingSkeleton")
local FFlagAppChatBlueSentBubblesIxpEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatBlueSentBubblesIxpEnabled")
local FFlagAppChatUseDataHydrationForChatTimeouts = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatUseDataHydrationForChatTimeouts")
local FStringAppChatBlueSentBubblesIxpLayer = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FStringAppChatBlueSentBubblesIxpLayer")

local isSyntheticSystemMessageId = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/Utils/isSyntheticSystemMessageId")

local fFlagAppChatConversationTrustedFriendUpsellBanner = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").FFlagAppChatConversationTrustedFriendUpsellBanner
local v5

if fFlagAppChatConversationTrustedFriendUpsellBanner then
	v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Sdui/seedConversationTopModalFromRequest")
else
	v5 = nil
end

local defineFastFlag = game:DefineFastFlag("AppChatConversationPageSyntheticSystemMessageIxpEnabled", false)

local defineFastString = game:DefineFastString(
	"AppChatConversationPageSyntheticSystemMessageIxpLayer",
	"Party.ConversationPage"
)

local function isOverlayNavigation(p2)
	return p2 and p2.action and p2.action.params and p2.action.params.isOverlay or false
end

local v6 = {
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
	updateConversationTitle = function(p2) end,
	navigateToScreen = function() end,
	inputBarDisabledKey = "Feature.Chat.Label.ChatDisabled",
	navigateToChatLanding = function() end,
	releaseInputBarFocus = function() end,
	navigateToSquadLobby = function() end,
	navigateToConversationOverlay = function() end,
	getCanAccessParty = true
}

local function isNameSettled(p2, p3): boolean
	return p2 ~= nil and (p2.status ~= dataStatus.NotReady or getCombinedNameFromProfileNames(p2, p3) ~= nil)
end

local function getOsaState(data, p2, p3, p4)
	local fetchedOldestMessage = data and data.fetchedOldestMessage

	local v7 = not data or data.conversationType ~= Conversation.Type.MULTI_USER_CONVERSATION

	local v8 = data
		and v7
		and (data.source == "friends" or data.osaAcknowledgementStatus == Conversation.OsaAcknowledgementStatus.Unacknowledged or data.osaAcknowledgementStatus == Conversation.OsaAcknowledgementStatus.Acknowledged)

	local v9 = data and data.osaAcknowledgementStatus == Conversation.OsaAcknowledgementStatus.Unacknowledged
	local v10 = data and data.source == "friends"
	local v11 = v8 and v9 and not v10
	local v12 = v8 and (fetchedOldestMessage or v10)
	local v13, v14

	if FFlagAppChatConversationLoadingSkeleton then
		v13 = v11 or v12
		local v15 = if v13 then getOtherParticipants(data, p2)[1] else nil

		if v15 == nil then
			v14 = true
		elseif FFlagAppChatUseUserProfileHydration then
			v14 = not (p4 == nil) and (p4.status ~= dataStatus.NotReady or getCombinedNameFromProfileNames(p4, v15) ~= nil)

			if not v14 then
				if p3 == nil or p3.error == nil then
					if p3 == nil or p3.data == nil then
						v14 = false
					else
						v14 = UserProfiles.Selectors.getCombinedNameFromId(p3.data, v15) ~= nil
					end
				else
					v14 = true
				end
			end
		elseif p3 == nil or p3.error == nil then
			if p3 == nil or p3.data == nil then
				v14 = false
			else
				v14 = UserProfiles.Selectors.getCombinedNameFromId(p3.data, v15) ~= nil
			end
		else
			v14 = true
		end
	end

	return {
		shouldShowOsaCardInConversation = v8,
		fetchedOldestMessage = fetchedOldestMessage,
		shouldShowOsaCardOnInitialLoad = v11,
		shouldShowOsaCardNow = v12,
		isFriendsConversation = v10,
		willShowOsaCard = v13,
		isOsaCardReady = v14
	}
end

function LUAUFORGE_MODULE_GLOBALS_hvJ_ChatConversationContainer(p2)
	local joined = Cryo.Dictionary.join(v6, p2)
	local v7 = useAnalytics()
	local v8 = React.useCallback(function(p3)
		v7:navigate(RoactChatAnalytics.NavigationEvents.ChatConversationProfile)
		joined.openViewProfile(p3)
	end, { joined.openViewProfile, v7 })
	local v9 = useMapDispatch(mapDispatchToProps)
	local v10 = useGetConversationFromId(joined.conversationId)

	local v11 = useRecipientIds(v10)
	local success, result = pcall(function()
		return HttpService:JSONEncode(v11)
	end)

	local v13 = nil
	local v14 = nil
	local v15 = useLocalUserId()
	local v16 = useChatIsVisible()
	local v17 = useIsChatUserMessagesEnabled()
	local v18 = useIsChatEnabled()
	local v19 = useDispatch()

	if FFlagAppChatPerfTracking and FFlagAppChatMessageTTIMilestones and AppChatPerfTracker.Hooks then
		local v20 = AppChatPerfTracker.getEventName(AppChatPerfTracker.Events.ChatConversationTTI) or ""

		AppChatPerfTracker.Hooks.useTTIRenderAndMountedTracking(v20)
	end

	useEffect(function()
		if not v18 then
			joined.navigateToChatLanding()
		end
	end, { v18, joined.navigateToChatLanding })

	if fFlagAppChatNavigateBackIfOSAUnacknowledged then
		local v20

		if joined.navigation and joined.navigation.getParam then
			v20 = joined.navigation.getParam("isNavigatedFromGroupOSAJoin", false)
		else
			v20 = false
		end

		if fFlagAppChatShowOSAOnPageEntry then
			useEffect(function()
				if joined.navigation and joined.navigation.addListener then
					local v21 = joined.navigation.addListener(RoactNavigation.Events.WillFocus, function()
						navigateWithOsaGate({
							conversationId = joined.conversationId,
							dispatch = v19,
							onAccepted = function() end,
							onDeclined = function()
								joined.navigateToChatLanding()
							end
						})
					end)
					return function()
						if v21 then
							v21:remove()
						end
					end
				end
			end, { joined.navigation, joined.conversationId, v19 })
		else
			useEffect(function()
				if not v20 and shouldShowOSAForConversation(v10) then
					joined.navigateToChatLanding()
				end
			end, { v10, joined.navigateToChatLanding, v20 })
		end
	end

	if fFlagAppChatShowOSAOnPageEntry then
		useEffect(function()
			if not v10 then
				return
			end

			local v20 = shouldShowOSAForConversation(v10)
			local v21 = shouldShowU13ChatOptInForConversation(v10)

			if v20 or v21 then
				navigateWithOsaGate({
					conversationId = joined.conversationId,
					dispatch = v19,
					onAccepted = function() end,
					onDeclined = function()
						joined.navigateToChatLanding()
					end
				})
			end
		end, { v10, joined.conversationId, v19 })
	end

	useSignal(interventionTreatmentShownSignal, React.useCallback(function(p3)
		if
			p3 == constants.TreatmentType.PartyChatNudgeDialog
			or p3 == constants.TreatmentType.PartyChatTimeoutDialog
		then
			joined.releaseInputBarFocus()
		end
	end, { joined.releaseInputBarFocus }))

	if FFlagAppChatUseUserProfileHydration then
		v14 = useProfileNames(getOtherParticipants(v10, v15))
	else
		v13 = UserProfiles.Hooks.useUserProfilesFetch({
			userIds = getOtherParticipants(v10, v15),
			query = UserProfiles.Queries.userProfilesCombinedNameAndUsernameByUserIds
		})
	end

	local v20 = getConversationTitle(v10)

	local v21 = useGetUserFromId()
	local v22 = useGetUsersTyping(joined.conversationId)

	local ref = React.useRef({
		itemList = {},
		previousMessagesState = {},
		previousSendingMessagesState = {},
		previousMessagesResult = {}
	})
	local v23

	if SignalsMigrationConfig.shouldReadMessageListFromSignalsStore then
		v23 = useMessageItemList(joined.conversationId, v21, v15, v10)
	else
		v23 = nil
	end

	local v24 = React.useMemo(function()
		if SignalsMigrationConfig.shouldReadMessageListFromSignalsStore then
			return v23
		end

		local v25 = FFlagAppChatPerfTracking
			and FFlagAppChatMessageTTIMilestones
			and AppChatPerfTracker.isActive(AppChatPerfTracker.Events.ChatConversationTTI, {
				conversationId = joined.conversationId
			})

		if v25 then
			local v26 = { conversationId = joined.conversationId }
			AppChatPerfTracker.trackMilestone(
				AppChatPerfTracker.Events.ChatConversationTTI,
				AppChatPerfTracker.Milestone.DataProcessingStarted.Name,
				v26
			)

			AppChatPerfTracker.trackSubphase(
				AppChatPerfTracker.Events.ChatConversationTTI,
				AppChatPerfTracker.Milestone.DataProcessingStarted.Name,
				AppChatPerfTracker.Milestone.DataProcessingStarted.Subphase.DataUpdate,
				v26
			)
		end

		ref.current = selectMessagesPure(
			{
				conversation = v10,
				conversationId = joined.conversationId,
				Users = v21,
				localUserId = v15
			},
			ref.current
		)

		if v25 then
			local v26 = { conversationId = joined.conversationId }
			AppChatPerfTracker.trackMilestone(
				AppChatPerfTracker.Events.ChatConversationTTI,
				AppChatPerfTracker.Milestone.DataProcessingCompleted.Name,
				v26
			)

			AppChatPerfTracker.trackSubphase(
				AppChatPerfTracker.Events.ChatConversationTTI,
				AppChatPerfTracker.Milestone.DataProcessingCompleted.Name,
				AppChatPerfTracker.Milestone.DataProcessingCompleted.Subphase.DataUpdate,
				v26
			)
		end

		return ref.current.itemList
	end, { v10, joined.conversationId, v21, v15, v23 })

	local v26 = v10
	local v27 = if FFlagAppChatUseUserProfileHydration then v14 else nil
	local v28 = getOsaState(v26, v15, v13, v27)

	local v29 = React.useMemo(function()
		local v30 = {}

		if v28.shouldShowOsaCardOnInitialLoad and not v28.fetchedOldestMessage then
			return v30
		end

		local clone = table.clone(v24)

		if v28.shouldShowOsaCardNow then
			table.insert(clone, {
				messageType = EnumMessageTypes.Custom,
				customEntryType = EnumCustomEntryTypes.OsaContextCardOneToOne,
				stable_key = EnumCustomEntryTypes.OsaContextCardOneToOne
			})
		end

		return clone
	end, {
		v24,
		v10,
		v28.shouldShowOsaCardOnInitialLoad,
		v28.shouldShowOsaCardInConversation,
		v28.shouldShowOsaCardNow,
		v28.fetchedOldestMessage
	})
	local v30

	if FFlagAppChatConversationLoadingSkeleton then
		local v31 = useSelector(function(p3)
			return AppChatNetworking.rodux.GetOlderMessages.getStatus(p3, joined.conversationId)
		end)
		local v32, v33

		if v28.isFriendsConversation then
			v32 = v28.isOsaCardReady
			v33 = v28.willShowOsaCard
		elseif v28.shouldShowOsaCardOnInitialLoad then
			v32 = v28.fetchedOldestMessage == true and v28.isOsaCardReady
			v33 = true
		else
			v32 = v31 == RoduxNetworking.Enum.NetworkStatus.Done or v28.fetchedOldestMessage == true
			v33 = v31 == RoduxNetworking.Enum.NetworkStatus.NotStarted
				or v31 == RoduxNetworking.Enum.NetworkStatus.Fetching
		end

		local ref2 = React.useRef({ conversationId = nil, hasLoadedFirstPage = false })

		if ref2.current.conversationId ~= joined.conversationId then
			ref2.current = {
				conversationId = joined.conversationId,
				hasLoadedFirstPage = false
			}
		end

		ref2.current.hasLoadedFirstPage = ref2.current.hasLoadedFirstPage or v32

		v30 = v10 and not ref2.current.hasLoadedFirstPage and v33
	else
		v30 = false
	end

	local v31

	if FFlagAppChatUseUserProfileHydration then
		v31 = getCombinedNameFromProfileNames(v14, v22[1] and v22[1].id)
	elseif v22[1] and v13.data then
		v31 = UserProfiles.Selectors.getCombinedNameFromId(v13.data, v22[1].id)
	end

	local v32

	if FFlagAppChatUseUserProfileHydration then
		v32 = getCombinedNameFromProfileNames(v14, v22[2] and v22[2].id)
	elseif v22[2] and v13.data then
		v32 = UserProfiles.Selectors.getCombinedNameFromId(v13.data, v22[2].id)
	end

	local v33 = true

	if #v22 == 1 and not v31 then
		v33 = false
	elseif #v22 == 2 and not (v31 and v32) then
		v33 = false
	end

	local v34 = getFFlagEnableAppChatInExperience() and useIsInExperience()

	local v35 = if FFlagAppChatSignalsReplyStore then GetReplyingToStore(false) else nil

	local conversationMessageStore = if FFlagAppChatSignalsReplyStore then GetConversationMessageViewModelStore(false).conversationMessageStore else nil

	local v36 = nil
	local v37 = nil
	local v38 = nil
	local v39 = nil
	local v40 = nil

	if FFlagAppChatSignalsReplyStore then
		v38 = useSignalState(v35.getMessageId)

		if v38 then
			local v41 = conversationMessageStore.messages(false)[v38]
			local sender_user_id = if v41 and v41.sender_user_id then tostring(v41.sender_user_id) else nil
			v40 = sender_user_id == v15

			if FFlagAppChatUseUserProfileHydration then
				if not v40 then
					v39 = getCombinedNameFromProfileNames(v14, sender_user_id)
				end
			elseif not (v40 or not (sender_user_id and v13.data)) then
				v39 = UserProfiles.Selectors.getCombinedNameFromId(v13.data, sender_user_id)
			end
		end
	else
		v36 = useReplyingToMessage()
		v37 = useReplyingToMessageDispatch()

		if v36 then
			v40 = v36.senderTargetId == v15

			if FFlagAppChatUseUserProfileHydration then
				if not v40 then
					v39 = getCombinedNameFromProfileNames(v14, v36.senderTargetId)
				end
			elseif not (v40 or not v13.data) then
				v39 = UserProfiles.Selectors.getCombinedNameFromId(v13.data, v36.senderTargetId)
			end
		end
	end

	local v41 = useLocalization({
		chatInputPlaceholder = joined.chatInputPlaceholderKey,
		replyChatInputPlaceholder = {
			joined.replyChatInputPlaceholderKey,
			DISPLAY_NAME = v39
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
			DISPLAY_NAME = v31
		},
		twoUsersTyping = {
			"Feature.Chat.Message.TwoUsersTyping",
			DISPLAY_NAME_1 = v31,
			DISPLAY_NAME_2 = v32
		},
		severalUsersTyping = joined.severalUsersTyping,
		bottomModalText = joined.chatUnavailableWithUserKey,
		inputBarDisabledText = joined.inputBarDisabledKey
	})

	local v42 = useTelemetry(ChatDetailsTelemetryLayer.Context)
	local v43 = ChatConversationTelemetryState.useMergeState()
	local v44 = ChatConversationTelemetryState.useClearState()

	local moderationType = v10 and v10.moderationType or Cryo.None
	local userPendingStatus = v10 and v10.userPendingStatus or Cryo.None
	useEffect(function()
		v43({
			conversationId = joined.conversationId,
			moderationType = moderationType,
			userPendingStatus = userPendingStatus
		})
	end, { v43, joined.conversationId, moderationType, userPendingStatus })

	local v45 = useIsUserPending(v10 or {})
	local source = v10 and v10.source

	local v46, v47 = useCallbackWithDynamicConversationId(AppChatNetworking.rodux.GetModalSequence.API, joined.conversationId)

	useEffect(function()
		if not v47 then
			return
		end

		if v45 and source == "channels" then
			v19(AppChatNetworking.rodux.GetPendingStateModal.API(joined.conversationId, v34)):catch(function(p3)
				Logger:warning(`GetPendingStateModal error in ChatConversationContainer {tostring(p3)}`)
			end)
		end

		if not v45 then
			local v48 = v19(v46({
				modalSequence = AppChatNetworking.Constants.ModalSequence.ConversationTopModal,
				isInExperience = v34
			}))

			if fFlagAppChatConversationTrustedFriendUpsellBanner then
				v48 = v5(v48, joined.conversationId)
			end

			v48:catch(function(p3)
				Logger:warning(`GetModalSequence for ConversationTopModal error in ChatConversationContainer {tostring(p3)}`)
			end)
		end
	end, { joined.conversationId, v47, v34, v45, source })
	local v48, v49 = useCallbackWithDynamicConversationId(AppChatNetworking.rodux.GetModalSequence.API, joined.conversationId)

	useEffect(function()
		if not v45 and v49 then
			v19(v48({
				modalSequence = AppChatNetworking.Constants.ModalSequence.ConversationOverlay,
				isInExperience = v34
			})):catch(function(p3)
				Logger:warning(`GetModalSequence error in ChatConversationContainer {tostring(p3)}`)
			end)
		end
	end, { v49, joined.conversationId, v45, v34, moderationType })

	if fFlagDebugEnableTCDoubleOptIn_DEV then
		useKeybind({ keyCode = Enum.KeyCode.O, modifierKey = Enum.ModifierKey.Ctrl }, function()
			Logger:debug("Ctrl + O pressed, showing new TC double opt in banner")
			v19({
				type = "DEBUG_ShowNewTopModal",
				conversationId = joined.conversationId,
				modalVariant = AppChatNetworking.Constants.ConversationTopModal.AddTrustedConnection
			})
		end, { v19, joined.conversationId })

		useKeybind({ keyCode = Enum.KeyCode.P, modifierKey = Enum.ModifierKey.Ctrl }, function()
			Logger:debug("Ctrl + P pressed, showing new TC double opt in request banner")
			v19({
				type = "DEBUG_ShowNewTopModal",
				conversationId = joined.conversationId,
				modalVariant = AppChatNetworking.Constants.ConversationTopModal.TrustedConnectionRequest
			})
		end, { v19, joined.conversationId })
	end

	if fFlagTCUpsellModalEnabled_DEV then
		useKeybind({ keyCode = Enum.KeyCode.L, modifierKey = Enum.ModifierKey.Ctrl }, function()
			Logger:debug("Ctrl + L pressed, showing new TC created overlay")
			v19({
				type = "DEBUG_ShowNewTCOverlay",
				conversationId = joined.conversationId,
				modalVariant = AppChatNetworking.Constants.ConversationOverlay.TrustedConnectionCreated
			})
		end, { v19, joined.conversationId })
	end

	local v50, v51 = useCallbackWithDynamicConversationId(AppChatNetworking.rodux.GetModalSequence.API, joined.conversationId)

	useEffect(function()
		if not v51 then
			return
		end

		v19(v50({
			modalSequence = AppChatNetworking.Constants.ModalSequence.ConversationBottomModal,
			isInExperience = v34
		})):catch(function(p3)
			Logger:warning(`GetModalSequence for ConversationBottomModal error in ChatConversationContainer {tostring(p3)}`)
		end)
	end, { joined.conversationId, v51, v34, v19, v50 })

	local v52 = useShouldShowConversationOverlay(joined.conversationId)
	useEffect(function()
		if v52 then
			joined.navigateToConversationOverlay()
		end
	end, { v52, joined.conversationId })
	local v53 = source ~= "channels"
	local v54 = useSelector(function(p3): boolean
		return (if v53 then AppChatNetworking.rodux.GetChatModerationStatuses.getStatus(p3) else AppChatNetworking.rodux.GetChatModerationStatuses.getStatus(
			p3,
			joined.conversationId
		)) == RoduxNetworking.Enum.NetworkStatus.NotStarted
	end)

	useEffect(function()
		if v54 and not FFlagAppChatUseDataHydrationForChatTimeouts then
			v19(AppChatNetworking.rodux.GetChatModerationStatuses.API(not v53 and { joined.conversationId } or nil)):catch(function(p3)
				warn("GetChatModerationStatuses error in ChatConversationContainer " .. tostring(p3))
			end)
		end
	end, { joined.conversationId, v53, v19, v54 })
	local v55

	if FFlagAppChatUseDataHydrationForChatTimeouts then
		v55 = useSignalState(useChatTimeoutDetailsFromHydration({
			conversationId = joined.conversationId,
			conversationModerationType = moderationType
		}))
	else
		v55 = useChatTimeoutDetails({
			conversationId = joined.conversationId,
			conversationModerationType = moderationType
		})
	end

	local isTimedOut = v55.isTimedOut
	local timeoutEndTimestamp = v55.timeoutEndTimestamp
	local decisionEventId = v55.decisionEventId
	local duration = v55.duration

	useEffect(function()
		v42.emit(ChatConversationTelemetryEvents.ScreenRendered, {
			loadedMessageCount = #v24
		})
	end, { joined.conversationId })

	if defineFastFlag then
		local v56 = v24[1]
		local id = if v56 then v56.id else nil
		useEffect(function()
			if isSyntheticSystemMessageId(id) then
				IXPService:LogFlagLinkedUserLayerExposure(defineFastString)
			end
		end, { joined.conversationId, id })
	end

	if FFlagAppChatBlueSentBubblesIxpEnabled then
		local v56 = React.useMemo(function(): boolean
			for k, v57 in v24 do
				if not v57.isIncoming and v57.messageType == EnumMessageTypes.PlainText then
					return true
				end
			end

			return false
		end, { v24 })
		useEffect(function()
			if v56 then
				IXPService:LogFlagLinkedUserLayerExposure(FStringAppChatBlueSentBubblesIxpLayer)
			end
		end, { joined.conversationId, v56 })
	end

	local v56 = React.useCallback(function(p3)
		v42.emit(ChatConversationTelemetryEvents.ScreenExit, { conversationExitType = p3 })

		v44()
	end, { v42, v44 })

	v10 = v10 or {}

	local v57 = not (v10.participantPendingStatus == ConversationChannels.UserPendingStatus.Pending) and v17

	local v59 = useIsExternalNavigationAvailable({ EnumScreens.ViewUserProfile })

	local v60 = v10.conversationType == Conversation.Type.MULTI_USER_CONVERSATION
	local v61 = useSelector(function(p3)
		return v60 and v10.initiator == p3.LocalUserId
	end)

	local function fn(p3)
		if v59[EnumScreens.ViewUserProfile] then
			v8(p3)
		else
			joined.navigateToScreen(GenericDialogType.ParticipantDialog, {
				conversationId = joined.conversationId,
				participantId = p3,
				showRemoveUserButton = not v45 and v60 and v61
			}, true)
		end
	end

	local v62 = if FFlagAppChatSignalsReplyStore then v38 else v36
	local v63

	if v62 then
		v63 = if v40 then v41.replyToYourselfChatInputPlaceholder else v41.replyChatInputPlaceholder
	else
		v63 = v41.chatInputPlaceholder
	end

	useEffect(function()
		joined.updateConversationTitle(v20)
	end, { v20, joined.updateConversationTitle })

	local v64 = React.useCallback(function()
		if not fFlagAppChatUniversalFeatureRestriction then
			chatInputBoxDisabledPressedSignal:fire({
				endTimestamp = timeoutEndTimestamp,
				decisionEventId = decisionEventId,
				duration = duration
			})

			return
		end

		local AbuseVector = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UniversalFeatureRestrictions/AbuseVector")
		local showFeatureRestriction = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UniversalFeatureRestrictions/showFeatureRestriction")
		local v65 = {
			onShown = joined.releaseInputBarFocus,
			onAppeal = function() end
		}

		if fFlagAppChatReactiveFeatureRestrictions then
			local partyChatTimeoutReceivedSignal = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/InterventionShared").Signals.partyChatTimeoutReceivedSignal
			function v65.onAcknowledgementSuccess()
				partyChatTimeoutReceivedSignal:fire(nil)
			end
		end

		showFeatureRestriction(AbuseVector.PartyChat, v65)
	end, { joined.releaseInputBarFocus, timeoutEndTimestamp, decisionEventId, duration })

	local state, setState = React.useState(joined.navigation and joined.navigation.isFocused and joined.navigation.isFocused())
	local v65, v66

	if FFlagAppChatPerfTracking then
		v65 = not (joined.isFocused and not joined.isFocused()) and state
		v66 = v65 and not v45
	else
		v66 = nil
	end

	local v67

	if FFlagAppChatPerfTracking then
		local ref2 = React.useRef(false)

		React.useEffect(function()
			ref2.current = not v57
		end, { joined.conversationId, v57 })

		local v68 = React.useCallback(function(p3)
			if not (AppChatPerfTracker.isActive(AppChatPerfTracker.Events.ChatConversationTTI, {
				conversationId = joined.conversationId
			}) and v66) then
				return
			end

			if ref2.current then
				AppChatPerfTracker.finish(AppChatPerfTracker.Events.ChatConversationTTI, {
					conversationId = joined.conversationId,
					numElementsRendered = #v24
				})
			else
				Logger:debug(
					"TTI: Messages ready but waiting for input bar (chatInputBarReady={}, reason={})",
					ref2.current,
					p3
				)
			end
		end, {
			joined.conversationId,
			state,
			v45,
			#v24
		})

		React.useEffect(function()
			v68("messages_ready")
		end, { v68, #v24, joined.conversationId })

		v67 = React.useCallback(function()
			ref2.current = true
			v68("input_bar_ready")
		end, { v68 })
	end

	if FFlagAppChatPerfTracking then
		local ref2 = React.useRef(nil)

		React.useEffect(function()
			Logger:debug("Perf: Resetting message perf tracking for conversation {}", joined.conversationId)

			ref2.current = nil

			local v68 = { conversationId = joined.conversationId }

			if FFlagAppChatMessageTTIMilestones then
				AppChatPerfTracker.cancel(AppChatPerfTracker.Events.MessageSendTTI, v68)
				AppChatPerfTracker.cancel(AppChatPerfTracker.Events.MessageReceiveTTI, v68)
			else
				AppChatPerfTracker.cancel(AppChatPerfTracker.Events.MessageSendToPendingRender, v68)
				AppChatPerfTracker.cancel(AppChatPerfTracker.Events.MessageSendResponseToFinalRender, v68)
				AppChatPerfTracker.cancel(AppChatPerfTracker.Events.MessageSendToFinalRender, v68)
				AppChatPerfTracker.cancel(AppChatPerfTracker.Events.MessageReceiveToRender, v68)
			end
		end, { joined.conversationId })

		React.useEffect(function()
			local v68 = v24[1]

			if not (v68 and v68.id) then
				return
			end

			local v69 = { conversationId = joined.conversationId }
			local v70 = v68.senderTargetId == v15

			if not v68.isSending and (v68.senderType == "system" or not v70) then
				if v68.id ~= ref2.current then
					ref2.current = v68.id

					if FFlagAppChatMessageTTIMilestones then
						AppChatPerfTracker.finish(AppChatPerfTracker.Events.MessageReceiveTTI, v69)
					else
						AppChatPerfTracker.finish(AppChatPerfTracker.Events.MessageReceiveToRender, v69)
					end
				end
			elseif FFlagAppChatMessageTTIMilestones then
				if AppChatPerfTracker.isActive(AppChatPerfTracker.Events.MessageReceiveTTI, v69) then
					AppChatPerfTracker.cancel(AppChatPerfTracker.Events.MessageReceiveTTI, v69)
				end
			elseif AppChatPerfTracker.isActive(AppChatPerfTracker.Events.MessageReceiveToRender, v69) then
				AppChatPerfTracker.cancel(AppChatPerfTracker.Events.MessageReceiveToRender, v69)
			end

			if not v70 then
				return
			end

			if FFlagAppChatMessageTTIMilestones then
				if v68.isSending then
					AppChatPerfTracker.trackMilestone(
						AppChatPerfTracker.Events.MessageSendTTI,
						AppChatPerfTracker.Milestone.FunctionallyReady,
						v69
					)
				else
					AppChatPerfTracker.finish(AppChatPerfTracker.Events.MessageSendTTI, v69)
				end
			else
				if v68.isSending then
					AppChatPerfTracker.finish(AppChatPerfTracker.Events.MessageSendToPendingRender, v69)
					return
				end

				AppChatPerfTracker.finish(AppChatPerfTracker.Events.MessageSendResponseToFinalRender, v69)
				AppChatPerfTracker.finish(AppChatPerfTracker.Events.MessageSendToFinalRender, v69)
			end
		end, { v24, v15, joined.conversationId })
	end

	useEffect(function()
		local v68 = joined.navigation
			and joined.navigation.addListener
			and joined.navigation.addListener(RoactNavigation.Events.WillBlur, function(p3)
				if FFlagAppChatPerfTracking then
					local isOverlay = p3
						and p3.action
						and p3.action.params
						and p3.action.params.isOverlay
						or false

					setState(isOverlay)

					if isOverlay then
						return
					end

					if AppChatPerfTracker.isActive(AppChatPerfTracker.Events.ChatConversationTTI, {
						conversationId = joined.conversationId
					}) then
						AppChatPerfTracker.cancel(AppChatPerfTracker.Events.ChatConversationTTI, {
							conversationId = joined.conversationId
						})
					end
				elseif p3 and p3.action and p3.action.params and p3.action.params.isOverlay then
					setState(true)
				else
					setState(false)
				end
			end)

		local v69 = joined.navigation
			and joined.navigation.addListener
			and joined.navigation.addListener(RoactNavigation.Events.WillFocus, function(p3)
				setState(true)
			end)

		return function()
			if v68 then
				v68.remove()
			end

			if v69 then
				v69.remove()
			end
		end
	end, { joined.navigation, joined.conversationId })

	useEffect(function()
		if v28.shouldShowOsaCardOnInitialLoad then
			v19(getAllRemainingOlderMessages(getOlderMessages, joined.conversationId, FIntAppChatGetAllMessagesDepth)):catch(function()
				joined.navigateToToast({
					toastProps = {
						toastContent = { toastTitle = v41.networkErrorText }
					}
				})
			end)
		end
	end, { v28.shouldShowOsaCardOnInitialLoad })

	local getCanAccessParty = joined.getCanAccessParty

	if FFlagAppChatPerfTracking then
		if not v65 then
			return nil
		end

		if v45 then
			return React.createElement(PendingStateConversationPage, {
				conversationId = joined.conversationId,
				topBarHeight = joined.topBarHeight,
				networkErrorText = v41.networkErrorText,
				navigateToToast = joined.navigateToToast,
				wideMode = joined.wideMode,
				onConversationUnmount = v56,
				navigateBack = joined.navigateBack
			})
		end
	else
		if not state or joined.isFocused and not joined.isFocused() then
			return nil
		end

		if v45 then
			return React.createElement(PendingStateConversationPage, {
				conversationId = joined.conversationId,
				topBarHeight = joined.topBarHeight,
				networkErrorText = v41.networkErrorText,
				navigateToToast = joined.navigateToToast,
				wideMode = joined.wideMode,
				onConversationUnmount = v56,
				navigateBack = joined.navigateBack,
				style = joined.style
			})
		end
	end

	local createElement = React.createElement

	local join = Cryo.Dictionary.join
	local v69 = {
		moreMenuEnabled = getCanAccessParty,
		conversation = v10,
		conversationTitle = v20,
		itemList = v29,
		localUserId = v15,
		openGameDetailsPage = joined.openGameDetailsPage,
		openViewProfile = fn,
		readingMessagesIsEnabled = joined.getReadingMessagesIsEnabled(),
		Users = v21,
		usersTyping = v22,
		displayNamesAvailable = v33,
		onConversationUnmount = v56,
		recipientIdsSerialized = not success and "[]" or result,
		chatIsVisible = v16,
		chatInputPlaceholder = v63,
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
		v38 = nil
	end

	v69.replyingToMessageId = v38

	if FFlagAppChatSignalsReplyStore then
		v36 = nil
	end

	v69.replyingToMessage = v36

	if FFlagAppChatSignalsReplyStore then
		v37 = nil
	end

	v69.replyingToMessageDispatch = v37

	v69.shouldShowChatInputBar = v57
	v69.shouldShowLegacyBottomModal = not v57 and v17
	v69.shouldDisableChatInputBar = isTimedOut

	if not FFlagAppChatPerfTracking then
		v67 = nil
	end

	v69.onChatInputBarReady = v67
	v69.inputBarDisabledEndTimestampDisplay = timeoutEndTimestamp
	v69.onDisabledInputBarActivated = v64
	v69.scrollToTopOnInitialOsaLoad = v28.shouldShowOsaCardOnInitialLoad and v28.fetchedOldestMessage
	v69.openMessageListAtStart = v28.shouldShowOsaCardOnInitialLoad
	local v70 = if getCanAccessParty then joined.navigateToSquadLobby else nil
	v69.navigateToSquadLobby = v70
	v69.shouldHideMoreMenuButton = if getCanAccessParty then not v57 else nil

	if not FFlagAppChatConversationLoadingSkeleton then
		v30 = nil
	end

	v69.isInitialMessageLoading = v30
	return createElement(ChatConversation, join(joined, v9, v41, v69))
end

return universalAppPolicy.connect(function(p2)
	return {
		viewProfileOnAvatarPressed = p2.getChatTapConversationThumbnail(),
		getCanAccessParty = p2.getCanAccessParty()
	}
end)(LUAUFORGE_MODULE_GLOBALS_hvJ_ChatConversationContainer)
