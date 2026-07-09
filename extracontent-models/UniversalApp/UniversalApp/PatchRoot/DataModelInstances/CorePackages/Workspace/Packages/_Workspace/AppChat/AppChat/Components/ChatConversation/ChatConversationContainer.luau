local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local HttpService = game:GetService("HttpService")
local IXPService = game:GetService("IXPService")
local Logger = require(script.Parent.Logger)
local React = require(AppChatParent.React)
local Cryo = require(AppChatParent.Cryo)
local RoactNavigation = require(AppChatParent.RoactNavigation)
local UniversalAppPolicy = require(AppChatParent.UniversalAppPolicy).UniversalAppPolicy
local ChatConversation = require(script.Parent.ChatConversation)
local PendingStateConversationPage = require(script.Parent.PendingState.PendingStateConversationPage)
local RoactChatAnalytics = require(AppChat.LegacyAnalytics.RoactChatAnalytics)
local useAnalytics = require(AppChat.LegacyAnalytics.useAnalytics)
local selectMessagesPure = require(AppChat.Components.ChatConversation.Messages.Selectors.selectMessagesPure)
local ConversationChannels = require(AppChat.Models.ConversationChannels)
local Conversation = require(AppChat.Models.Conversation)
local GenericDialogType = require(AppChat.Components.ChatDetails.Dialogs.GenericDialogType)
local AppChatNetworking = require(AppChatParent.AppChatNetworking)
local mapDispatchToProps = require(script.Parent.mapDispatchToProps)
local useGetConversationFromId = require(AppChat.Hooks.useGetConversationFromId)
local useLocalization = require(AppChatParent.Localization).Hooks.useLocalization
local useEffect = React.useEffect
local useLocalUserId = require(AppChatParent.RobloxAppHooks).useLocalUserId
local useDispatch = require(AppChatParent.RoactUtils).Hooks.RoactRodux.useDispatch
local useMapDispatch = require(AppChat.Hooks.useMapDispatch)
local useGetUsers = require(AppChat.Hooks.useGetUsers)
local useGetUsersTyping = require(AppChat.Hooks.useGetUsersTyping)
local useSignalState = require(AppChatParent.SignalsReact).useSignalState
local GetReplyingToStore = require(AppChat.Stores.GetReplyingToStore)
local GetConversationMessageViewModelStore = require(AppChat.Stores.GetConversationMessageViewModelStore)
local useReplyingToMessage = require(script.Parent.MessageInteraction.ReplyingContext.useReplyingToMessage)
local useReplyingToMessageDispatch = require(script.Parent.MessageInteraction.ReplyingContext.useReplyingToMessageDispatch)
local FFlagAppChatSignalsReplyStore = require(AppChat.Flags.FFlagAppChatSignalsReplyStore)
local UserProfiles = require(AppChatParent.UserProfiles)
local getConversationTitle = require(AppChat.Conversations.getConversationTitle)
local getOtherParticipants = require(AppChat.Conversations.getOtherParticipants)
local useRecipientIds = require(AppChat.Hooks.useRecipientIds)
local useIsUserPending = require(AppChat.Hooks.useIsUserPending)
local useChatIsVisible = require(AppChat.Hooks.useChatIsVisible)
local useSelector = require(AppChatParent.RoactUtils).Hooks.RoactRodux.useSelector
local useIsExternalNavigationAvailable = require(AppChat.Hooks.useIsExternalNavigationAvailable)
local useIsInExperience = require(AppChat.Hooks.useIsInExperience)
local useIsChatUserMessagesEnabled = require(AppChat.Hooks.useIsChatUserMessagesEnabled)
local chatInputBoxDisabledPressedSignal = require(AppChatParent.InterventionShared).Signals.chatInputBoxDisabledPressedSignal
local RoduxNetworking = require(AppChat.Http.RoduxNetworking)
local useChatTimeoutDetails = require(AppChat.Hooks.useChatTimeoutDetails)
local ChatConversationTelemetryLayer = require(AppChat.Telemetry.Layers.ChatConversationTelemetryLayer)
local ChatConversationTelemetryState = require(AppChat.Contexts.TelemetryState.ChatConversationTelemetryState)
local useTelemetry = require(AppChat.Telemetry.useTelemetry)
local ChatConversationTelemetryEvents = require(script.Parent.ChatConversationTelemetryEvents)
local useIsChatEnabled = require(AppChat.Hooks.useIsChatEnabled)
local interventionTreatmentShownSignal = require(AppChatParent.InterventionShared).Signals.interventionTreatmentShownSignal
local useSignal = require(AppChatParent.RoactUtils).Hooks.useSignal
local Constants = require(AppChatParent.InterventionShared).Utils.Constants
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
local GetFFlagEnableAppChatInExperience = require(AppChatParent.SharedFlags).GetFFlagEnableAppChatInExperience
local FFlagRenderChatConversationOnlyWhenVisible = require(AppChat.Flags.FFlagRenderChatConversationOnlyWhenVisible)
local FFlagTCUpsellModalEnabled_DEV = require(AppChatParent.SharedFlags).FFlagTCUpsellModalEnabled_DEV
local GetFFlagIsSquadEnabled = require(AppChatParent.SharedFlags).GetFFlagIsSquadEnabled
local FFlagDebugEnableTCDoubleOptIn_DEV = require(AppChatParent.SharedFlags).FFlagDebugEnableTCDoubleOptIn_DEV
local FFlagAppChatEnableDoubleOptIn = require(AppChatParent.SharedFlags).FFlagAppChatEnableDoubleOptIn
local FFlagEnableAEGIS2AppChatConversationBanner = require(AppChatParent.SharedFlags).FFlagEnableAEGIS2AppChatConversationBanner
local FFlagAppChatShowOSAOnPageEntry = require(AppChatParent.SharedFlags).FFlagAppChatShowOSAOnPageEntry
local v74 = game:DefineFastInt("AppChatGetAllMessagesDepth", 100)
local FFlagAppChatNavigateBackIfOSAUnacknowledged = require(AppChatParent.SharedFlags).FFlagAppChatNavigateBackIfOSAUnacknowledged
local shouldShowOSAForConversation = require(AppChat.Utils.shouldShowOSAForConversation)
local FFlagAppChatSignalsMessageStore = require(AppChat.Flags.FFlagAppChatSignalsMessageStore)
local useMessageItemList = require(AppChat.Hooks.useMessageItemList).useMessageItemList
local shouldShowU13ChatOptInForConversation = require(AppChat.Utils.shouldShowU13ChatOptInForConversation)
local navigateWithOsaGate = require(AppChat.Utils).navigateWithOsaGate
local FFlagAppChatReactToFaeForOsa = require(AppChat.Flags.FFlagAppChatReactToFaeForOsa)
local FFlagAppChatNudgeToChatUpsellEnabled = require(AppChat.Flags.FFlagAppChatNudgeToChatUpsellEnabled)
local FFlagAppChatConversationLoadingSkeleton = require(AppChat.Flags.FFlagAppChatConversationLoadingSkeleton)
local isSyntheticSystemMessageId = require(script.Parent.Utils.isSyntheticSystemMessageId)
local v85 = game:DefineFastFlag("AppChatConversationPageSyntheticSystemMessageIxpEnabled", false)
local v86 = game:DefineFastString("AppChatConversationPageSyntheticSystemMessageIxpLayer", "Party.ConversationPage")

local function isOverlayNavigation(p1) -- line: 107
	return not not p1 and (not not p1.action and (not not p1.action.params and (p1.action.params.isOverlay or false)))
end

local t1 = {
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
	severalUsersTyping = "Feature.Chat.Message.SeveralUsersTyping",
	pendingStateBodyKey = "Feature.Chat.Message.ChatIsUnfiltered",
	connectUnavailableWithUserKey = "Feature.Chat.RobloxConnectUnavailableWithUser",
	inputBarDisabledKey = "Feature.Chat.Label.ChatDisabled",
	getCanAccessParty = true,
	oneUserTyping = {
		"Feature.Chat.Message.OneUserTyping",
		DISPLAY_NAME = ""
	},
	twoUsersTyping = {
		"Feature.Chat.Message.TwoUsersTyping",
		DISPLAY_NAME_1 = "",
		DISPLAY_NAME_2 = ""
	},
	chatUnavailableWithUserKey = not GetFFlagIsSquadEnabled() and "Feature.Chat.Message.ChatUnavailableWithUser" or "Feature.Chat.Message.PartyUnavailableWithUser",
	getReadingMessagesIsEnabled = function() -- line: 134
	end,
	updateConversationTitle = function(_) -- line: 135
	end,
	navigateToScreen = function() -- line: 136
	end,
	navigateToChatLanding = function() -- line: 138
	end,
	releaseInputBarFocus = function() -- line: 139
	end,
	navigateToSquadLobby = function() -- line: 140
	end,
	navigateToConversationOverlay = function() -- line: 141
	end
}

local function getOsaState(p3, p4, p5) -- line: 146
	-- upvalues: Conversation (copy), FFlagAppChatConversationLoadingSkeleton (copy), getOtherParticipants (copy), UserProfiles (copy)
	local v95 = p3 and p3.fetchedOldestMessage
	local v96 = not p3 or p3.conversationType ~= Conversation.Type.MULTI_USER_CONVERSATION
	local v97 = p3 and (v96 and (p3.source == "friends" or (p3.osaAcknowledgementStatus == Conversation.OsaAcknowledgementStatus.Unacknowledged or p3.osaAcknowledgementStatus == Conversation.OsaAcknowledgementStatus.Acknowledged)))
	local v98 = p3 and p3.osaAcknowledgementStatus == Conversation.OsaAcknowledgementStatus.Unacknowledged
	local v99 = p3 and p3.source == "friends"
	local v100 = v97 and (v98 and not v99)
	local v101 = v97 and (v95 or v99)
	local v102 = nil
	local v103 = nil

	if FFlagAppChatConversationLoadingSkeleton then
		v102 = v100 or v101

		local v104 = if not v102 then nil else getOtherParticipants(p3, p4)[1]

		v103 = v104 == nil or (p5 ~= nil and p5.error ~= nil or p5 ~= nil and (p5.data ~= nil and UserProfiles.Selectors.getCombinedNameFromId(p5.data, v104) ~= nil))
	end

	return {
		shouldShowOsaCardInConversation = v97,
		fetchedOldestMessage = v95,
		shouldShowOsaCardOnInitialLoad = v100,
		shouldShowOsaCardNow = v101,
		isFriendsConversation = v99,
		willShowOsaCard = v102,
		isOsaCardReady = v103
	}
end

function ChatConversationContainer(p6) -- line: 192
	-- upvalues: Cryo (copy), t1 (copy), useAnalytics (copy), React (copy), RoactChatAnalytics (copy), useMapDispatch (copy), mapDispatchToProps (copy), useGetConversationFromId (copy), useRecipientIds (copy), HttpService (copy), useLocalUserId (copy), useChatIsVisible (copy), useIsChatUserMessagesEnabled (copy), useIsChatEnabled (copy), useDispatch (copy), FFlagAppChatPerfTracking (copy), FFlagAppChatMessageTTIMilestones (copy), AppChatPerfTracker (copy), useEffect (copy), FFlagAppChatNavigateBackIfOSAUnacknowledged (copy), FFlagAppChatShowOSAOnPageEntry (copy), RoactNavigation (copy), navigateWithOsaGate (copy), shouldShowOSAForConversation (copy), FFlagAppChatReactToFaeForOsa (copy), shouldShowU13ChatOptInForConversation (copy), useSignal (copy), interventionTreatmentShownSignal (copy), Constants (copy), UserProfiles (copy), getOtherParticipants (copy), getConversationTitle (copy), useGetUsers (copy), useGetUsersTyping (copy), FFlagAppChatSignalsMessageStore (copy), useMessageItemList (copy), selectMessagesPure (copy), getOsaState (copy), EnumMessageTypes (copy), EnumCustomEntryTypes (copy), FFlagAppChatConversationLoadingSkeleton (copy), useSelector (copy), AppChatNetworking (copy), RoduxNetworking (copy), GetFFlagEnableAppChatInExperience (copy), useIsInExperience (copy), FFlagAppChatSignalsReplyStore (copy), GetReplyingToStore (copy), GetConversationMessageViewModelStore (copy), useSignalState (copy), useReplyingToMessage (copy), useReplyingToMessageDispatch (copy), useLocalization (copy), useTelemetry (copy), ChatConversationTelemetryLayer (copy), ChatConversationTelemetryState (copy), useIsUserPending (copy), FFlagAppChatEnableDoubleOptIn (copy), useCallbackWithDynamicConversationId (copy), Logger (copy), FFlagDebugEnableTCDoubleOptIn_DEV (copy), useKeybind (copy), FFlagTCUpsellModalEnabled_DEV (copy), FFlagEnableAEGIS2AppChatConversationBanner (copy), FFlagAppChatNudgeToChatUpsellEnabled (copy), useShouldShowConversationOverlay (copy), useChatTimeoutDetails (copy), ChatConversationTelemetryEvents (copy), v85 (copy), isSyntheticSystemMessageId (copy), IXPService (copy), v86 (copy), ConversationChannels (copy), useIsExternalNavigationAvailable (copy), EnumScreens (copy), Conversation (copy), GenericDialogType (copy), chatInputBoxDisabledPressedSignal (copy), FFlagRenderChatConversationOnlyWhenVisible (copy), getAllRemainingOlderMessages (copy), getOlderMessages (copy), v74 (copy), PendingStateConversationPage (copy), ChatConversation (copy)
	local v106 = Cryo.Dictionary.join(t1, p6)
	local v107 = useAnalytics()
	local v108 = React.useCallback(function(p7) -- line: 195
		-- upvalues: v107 (copy), RoactChatAnalytics (copy), v106 (copy)
		v107:navigate(RoactChatAnalytics.NavigationEvents.ChatConversationProfile)
		v106.openViewProfile(p7)
	end, {
		v106.openViewProfile,
		v107
	})
	local v109 = useMapDispatch(mapDispatchToProps)
	local u110 = useGetConversationFromId(v106.conversationId)
	local v111 = useRecipientIds(u110)
	local ok, result = pcall(function() -- line: 203
		-- upvalues: HttpService (copy), v111 (copy)
		return HttpService:JSONEncode(v111)
	end)
	local v114 = not ok and "[]" or result
	local v115 = useLocalUserId()
	local v116 = useChatIsVisible()
	local v117 = useIsChatUserMessagesEnabled()
	local v118 = useIsChatEnabled()
	local v119 = useDispatch()

	if FFlagAppChatPerfTracking and (FFlagAppChatMessageTTIMilestones and AppChatPerfTracker.Hooks) then
		local v120 = AppChatPerfTracker.getEventName(AppChatPerfTracker.Events.ChatConversationTTI) or ""

		AppChatPerfTracker.Hooks.useTTIRenderAndMountedTracking(v120)
	end

	useEffect(function() -- line: 224
		-- upvalues: v118 (copy), v106 (copy)
		if not v118 then
			v106.navigateToChatLanding()
		end
	end, {
		v118,
		v106.navigateToChatLanding
	})

	if FFlagAppChatNavigateBackIfOSAUnacknowledged then
		local v121 = not not v106.navigation and (not not v106.navigation.getParam and v106.navigation.getParam("isNavigatedFromGroupOSAJoin", false))

		if FFlagAppChatShowOSAOnPageEntry then
			useEffect(function() -- line: 237
				-- upvalues: v106 (copy), RoactNavigation (copy), navigateWithOsaGate (copy), v119 (copy)
				if not v106.navigation or not v106.navigation.addListener then
					return
				end

				local v194 = v106.navigation.addListener(RoactNavigation.Events.WillFocus, function() -- line: 241
					-- upvalues: navigateWithOsaGate (copy), v106 (copy), v119 (copy)
					navigateWithOsaGate({
						conversationId = v106.conversationId,
						dispatch = v119,
						onAccepted = function() -- line: 245
						end,
						onDeclined = function() -- line: 246
							-- upvalues: v106 (copy)
							v106.navigateToChatLanding()
						end
					})
				end)

				return function() -- line: 251
					-- upvalues: v194 (copy)
					if v194 then
						v194:remove()
					end
				end
			end, {
				v106.navigation,
				v106.conversationId,
				v119
			})
		else
			useEffect(function() -- line: 258
				-- upvalues: v121 (copy), shouldShowOSAForConversation (copy), u110 (ref), v106 (copy)
				if not v121 and shouldShowOSAForConversation(u110) then
					v106.navigateToChatLanding()
				end
			end, {
				u110,
				v106.navigateToChatLanding,
				v121
			})
		end
	end

	if FFlagAppChatReactToFaeForOsa then
		useEffect(function() -- line: 268
			-- upvalues: u110 (ref), shouldShowOSAForConversation (copy), shouldShowU13ChatOptInForConversation (copy), navigateWithOsaGate (copy), v106 (copy), v119 (copy)
			if not u110 then
				return
			end

			local v195 = shouldShowOSAForConversation(u110)
			local v196 = shouldShowU13ChatOptInForConversation(u110)

			if v195 or v196 then
				navigateWithOsaGate({
					conversationId = v106.conversationId,
					dispatch = v119,
					onAccepted = function() -- line: 278
					end,
					onDeclined = function() -- line: 279
						-- upvalues: v106 (copy)
						v106.navigateToChatLanding()
					end
				})
			end
		end, {
			u110,
			v106.conversationId,
			v119
		})
	end

	useSignal(interventionTreatmentShownSignal, React.useCallback(function(p8) -- line: 295
		-- upvalues: Constants (copy), v106 (copy)
		if p8 == Constants.TreatmentType.PartyChatNudgeDialog or p8 == Constants.TreatmentType.PartyChatTimeoutDialog then
			v106.releaseInputBarFocus()
		end
	end, { v106.releaseInputBarFocus }))

	local v122 = UserProfiles.Hooks.useUserProfilesFetch({
		userIds = getOtherParticipants(u110, v115),
		query = UserProfiles.Queries.userProfilesCombinedNameAndUsernameByUserIds
	})
	local u123 = getConversationTitle(u110)
	local v124 = useGetUsers()
	local v125 = useGetUsersTyping(v106.conversationId)
	local v126 = React.useRef({
		itemList = {},
		previousMessagesState = {},
		previousSendingMessagesState = {},
		previousMessagesResult = {}
	})
	local u127 = nil

	if FFlagAppChatSignalsMessageStore then
		u127 = useMessageItemList(v106.conversationId, v124, v115, u110)
	end

	local v128 = React.useMemo(function() -- line: 326
		-- upvalues: FFlagAppChatSignalsMessageStore (copy), u127 (ref), FFlagAppChatPerfTracking (copy), FFlagAppChatMessageTTIMilestones (copy), AppChatPerfTracker (copy), v106 (copy), v126 (copy), selectMessagesPure (copy), u110 (ref), v124 (copy), v115 (copy)
		if FFlagAppChatSignalsMessageStore then
			return u127
		end

		local v198 = FFlagAppChatPerfTracking and (FFlagAppChatMessageTTIMilestones and AppChatPerfTracker.isActive(AppChatPerfTracker.Events.ChatConversationTTI, {
			conversationId = v106.conversationId
		}))

		if v198 then
			local t2 = {
				conversationId = v106.conversationId
			}

			AppChatPerfTracker.trackMilestone(AppChatPerfTracker.Events.ChatConversationTTI, AppChatPerfTracker.Milestone.DataProcessingStarted.Name, t2)
			AppChatPerfTracker.trackSubphase(AppChatPerfTracker.Events.ChatConversationTTI, AppChatPerfTracker.Milestone.DataProcessingStarted.Name, AppChatPerfTracker.Milestone.DataProcessingStarted.Subphase.DataUpdate, t2)
		end

		v126.current = selectMessagesPure({
			conversation = u110,
			conversationId = v106.conversationId,
			Users = v124,
			localUserId = v115
		}, v126.current)

		if v198 then
			local t3 = {
				conversationId = v106.conversationId
			}

			AppChatPerfTracker.trackMilestone(AppChatPerfTracker.Events.ChatConversationTTI, AppChatPerfTracker.Milestone.DataProcessingCompleted.Name, t3)
			AppChatPerfTracker.trackSubphase(AppChatPerfTracker.Events.ChatConversationTTI, AppChatPerfTracker.Milestone.DataProcessingCompleted.Name, AppChatPerfTracker.Milestone.DataProcessingCompleted.Subphase.DataUpdate, t3)
		end

		return v126.current.itemList
	end, {
		u110,
		v106.conversationId,
		v124,
		v115,
		u127
	})
	local v129 = getOsaState(u110, v115, v122)
	local v130 = React.useMemo(function() -- line: 378
		-- upvalues: v129 (copy), v128 (copy), EnumMessageTypes (copy), EnumCustomEntryTypes (copy)
		if v129.shouldShowOsaCardOnInitialLoad and not v129.fetchedOldestMessage then
			return {}
		end

		local v201 = table.clone(v128)

		if v129.shouldShowOsaCardNow then
			table.insert(v201, {
				messageType = EnumMessageTypes.Custom,
				customEntryType = EnumCustomEntryTypes.OsaContextCardOneToOne,
				stable_key = EnumCustomEntryTypes.OsaContextCardOneToOne
			})
		end

		return v201
	end, {
		v128,
		u110,
		v129.shouldShowOsaCardOnInitialLoad,
		v129.shouldShowOsaCardInConversation,
		v129.shouldShowOsaCardNow,
		v129.fetchedOldestMessage
	})
	local v131 = false

	if FFlagAppChatConversationLoadingSkeleton then
		local v132 = useSelector(function(p9) -- line: 407
			-- upvalues: AppChatNetworking (copy), v106 (copy)
			return AppChatNetworking.rodux.GetOlderMessages.getStatus(p9, v106.conversationId)
		end)
		local isOsaCardReady, willShowOsaCard

		if v129.isFriendsConversation then
			isOsaCardReady = v129.isOsaCardReady
			willShowOsaCard = v129.willShowOsaCard
		elseif v129.shouldShowOsaCardOnInitialLoad then
			isOsaCardReady = v129.fetchedOldestMessage == true and v129.isOsaCardReady
			willShowOsaCard = true
		else
			isOsaCardReady = v132 == RoduxNetworking.Enum.NetworkStatus.Done or v129.fetchedOldestMessage == true
			willShowOsaCard = v132 == RoduxNetworking.Enum.NetworkStatus.NotStarted or v132 == RoduxNetworking.Enum.NetworkStatus.Fetching
		end

		local v135 = React.useRef({
			conversationId = nil,
			hasLoadedFirstPage = false
		})

		if v135.current.conversationId ~= v106.conversationId then
			v135.current = {
				hasLoadedFirstPage = false,
				conversationId = v106.conversationId
			}
		end

		v135.current.hasLoadedFirstPage = v135.current.hasLoadedFirstPage or isOsaCardReady
		v131 = u110 and (not v135.current.hasLoadedFirstPage and willShowOsaCard)
	end

	local v136 = if not v125[1] or not v122.data then nil else UserProfiles.Selectors.getCombinedNameFromId(v122.data, v125[1].id)
	local v137 = if not v125[2] or not v122.data then nil else UserProfiles.Selectors.getCombinedNameFromId(v122.data, v125[2].id)
	local v138 = true

	if #v125 == 1 and not v136 then
		v138 = false
	elseif #v125 == 2 and (not v136 or not v137) then
		v138 = false
	end

	local v139 = GetFFlagEnableAppChatInExperience() and useIsInExperience()
	local v140 = if not FFlagAppChatSignalsReplyStore then nil else GetReplyingToStore(false)
	local v141 = if not FFlagAppChatSignalsReplyStore then nil else GetConversationMessageViewModelStore(false).conversationMessageStore
	local v142 = nil
	local v143 = nil
	local v144 = nil
	local v145 = nil
	local v146 = nil

	if FFlagAppChatSignalsReplyStore then
		v144 = useSignalState(v140.getMessageId)

		if v144 then
			local v147 = v141.messages(false)[v144]
			local v148 = if not v147 or not v147.sender_user_id then nil else tostring(v147.sender_user_id)

			v146 = v148 == v115
			v145 = if v146 or (not v148 or not v122.data) then nil else UserProfiles.Selectors.getCombinedNameFromId(v122.data, v148)
		end
	else
		v142 = useReplyingToMessage()
		v143 = useReplyingToMessageDispatch()

		if v142 then
			v146 = v115 == v142.senderTargetId
			v145 = if v146 or not v122.data then nil else UserProfiles.Selectors.getCombinedNameFromId(v122.data, v142.senderTargetId)
		end
	end

	local v149 = useLocalization({
		chatInputPlaceholder = v106.chatInputPlaceholderKey,
		replyChatInputPlaceholder = {
			v106.replyChatInputPlaceholderKey,
			DISPLAY_NAME = v145
		},
		replyToYourselfChatInputPlaceholder = v106.replyToYourselfChatInputPlaceholderKey,
		invalidMessageTypeText = v106.notImplementedMessageTypeKey,
		messageDefaultNoticeText = v106.messageDefaultNoticeKey,
		messageModeratedNoticeText = v106.messageModeratedNoticeKey,
		messageHiddenNoticeText = v106.messageHiddenNoticeKey,
		networkErrorText = v106.networkErrorTextKey,
		newText = v106.newTextKey,
		schedulePartyText = v106.schedulePartyTextKey,
		unknownUserText = v106.unknownUserTextKey,
		oneUserTyping = {
			"Feature.Chat.Message.OneUserTyping",
			DISPLAY_NAME = v136
		},
		twoUsersTyping = {
			"Feature.Chat.Message.TwoUsersTyping",
			DISPLAY_NAME_1 = v136,
			DISPLAY_NAME_2 = v137
		},
		severalUsersTyping = v106.severalUsersTyping,
		bottomModalText = v106.chatUnavailableWithUserKey,
		inputBarDisabledText = v106.inputBarDisabledKey
	})
	local v150 = useTelemetry(ChatConversationTelemetryLayer.Context)
	local v151 = ChatConversationTelemetryState.useMergeState()
	local v152 = ChatConversationTelemetryState.useClearState()
	local v153 = u110 and u110.moderationType or Cryo.None
	local v154 = u110 and u110.userPendingStatus or Cryo.None

	useEffect(function() -- line: 521
		-- upvalues: v151 (copy), v106 (copy), v153 (copy), v154 (copy)
		v151({
			conversationId = v106.conversationId,
			moderationType = v153,
			userPendingStatus = v154
		})
	end, {
		v151,
		v106.conversationId,
		v153,
		v154
	})

	local v155 = useIsUserPending(u110 or {})
	local v156 = u110 and u110.source

	if FFlagAppChatEnableDoubleOptIn then
		local v157, v158 = useCallbackWithDynamicConversationId(AppChatNetworking.rodux.GetModalSequence.API, v106.conversationId)

		useEffect(function() -- line: 537
			-- upvalues: v158 (copy), v155 (copy), v156 (copy), v119 (copy), AppChatNetworking (copy), v106 (copy), v139 (copy), Logger (copy), v157 (copy)
			if not v158 then
				return
			end

			if v155 and v156 == "channels" then
				v119(AppChatNetworking.rodux.GetPendingStateModal.API(v106.conversationId, v139)):catch(function(p10) -- line: 543
					-- upvalues: Logger (copy)
					Logger:warning(`GetPendingStateModal error in ChatConversationContainer { tostring(p10) }`)
				end)
			end

			if not v155 then
				v119(v157({
					modalSequence = AppChatNetworking.Constants.ModalSequence.ConversationTopModal,
					isInExperience = v139
				})):catch(function(p11) -- line: 552
					-- upvalues: Logger (copy)
					Logger:warning(`GetModalSequence for ConversationTopModal error in ChatConversationContainer { tostring(p11) }`)
				end)
			end
		end, {
			v106.conversationId,
			v158,
			v139,
			v155,
			v156
		})
	else
		useEffect(function() -- line: 560
			-- upvalues: v156 (copy), v155 (copy), v119 (copy), AppChatNetworking (copy), v106 (copy), v139 (copy)
			if v156 ~= "channels" then
				return
			end

			if v155 then
				v119(AppChatNetworking.rodux.GetPendingStateModal.API(v106.conversationId, v139)):catch(function(p12) -- line: 566
					warn("GetPendingStateModal error in ChatConversationContainer " .. tostring(p12))
				end)

				return
			end

			v119(AppChatNetworking.rodux.GetConversationTopModal.API(v106.conversationId, v139)):catch(function(p13) -- line: 572
				warn("GetConversationTopModal error in ChatConversationContainer " .. tostring(p13))
			end)
		end, {
			v106.conversationId,
			v119,
			v156
		})
	end

	local v159, u160 = useCallbackWithDynamicConversationId(AppChatNetworking.rodux.GetModalSequence.API, v106.conversationId)

	useEffect(function() -- line: 583
		-- upvalues: v155 (copy), u160 (ref), v119 (copy), v159 (copy), AppChatNetworking (copy), v139 (copy), Logger (copy)
		if not v155 and u160 then
			v119(v159({
				modalSequence = AppChatNetworking.Constants.ModalSequence.ConversationOverlay,
				isInExperience = v139
			})):catch(function(p14) -- line: 588
				-- upvalues: Logger (copy)
				Logger:warning(`GetModalSequence error in ChatConversationContainer { tostring(p14) }`)
			end)
		end
	end, {
		u160,
		v106.conversationId,
		v155,
		v139,
		v153
	})

	if FFlagDebugEnableTCDoubleOptIn_DEV then
		useKeybind({
			keyCode = Enum.KeyCode.O,
			modifierKey = Enum.ModifierKey.Ctrl
		}, function() -- line: 595
			-- upvalues: Logger (copy), v119 (copy), v106 (copy), AppChatNetworking (copy)
			Logger:debug("Ctrl + O pressed, showing new TC double opt in banner")
			v119({
				type = "DEBUG_ShowNewTopModal",
				conversationId = v106.conversationId,
				modalVariant = AppChatNetworking.Constants.ConversationTopModal.AddTrustedConnection
			})
		end, {
			v119,
			v106.conversationId
		})
		useKeybind({
			keyCode = Enum.KeyCode.P,
			modifierKey = Enum.ModifierKey.Ctrl
		}, function() -- line: 604
			-- upvalues: Logger (copy), v119 (copy), v106 (copy), AppChatNetworking (copy)
			Logger:debug("Ctrl + P pressed, showing new TC double opt in request banner")
			v119({
				type = "DEBUG_ShowNewTopModal",
				conversationId = v106.conversationId,
				modalVariant = AppChatNetworking.Constants.ConversationTopModal.TrustedConnectionRequest
			})
		end, {
			v119,
			v106.conversationId
		})
	end

	if FFlagTCUpsellModalEnabled_DEV then
		useKeybind({
			keyCode = Enum.KeyCode.L,
			modifierKey = Enum.ModifierKey.Ctrl
		}, function() -- line: 615
			-- upvalues: Logger (copy), v119 (copy), v106 (copy), AppChatNetworking (copy)
			Logger:debug("Ctrl + L pressed, showing new TC created overlay")
			v119({
				type = "DEBUG_ShowNewTCOverlay",
				conversationId = v106.conversationId,
				modalVariant = AppChatNetworking.Constants.ConversationOverlay.TrustedConnectionCreated
			})
		end, {
			v119,
			v106.conversationId
		})
	end

	if FFlagEnableAEGIS2AppChatConversationBanner or FFlagAppChatNudgeToChatUpsellEnabled then
		local v161, v162 = useCallbackWithDynamicConversationId(AppChatNetworking.rodux.GetModalSequence.API, v106.conversationId)
		local u163 = v161

		u160 = v162
		useEffect(function() -- line: 631
			-- upvalues: u160 (ref), v119 (copy), u163 (ref), AppChatNetworking (copy), v139 (copy), Logger (copy)
			if not u160 then
				return
			end

			v119(u163({
				modalSequence = AppChatNetworking.Constants.ModalSequence.ConversationBottomModal,
				isInExperience = v139
			})):catch(function(p15) -- line: 639
				-- upvalues: Logger (copy)
				Logger:warning(`GetModalSequence for ConversationBottomModal error in ChatConversationContainer { tostring(p15) }`)
			end)
		end, {
			v106.conversationId,
			u160,
			v139
		})
	end

	local v164 = useShouldShowConversationOverlay(v106.conversationId)

	useEffect(function() -- line: 647
		-- upvalues: v164 (copy), v106 (copy)
		if v164 then
			v106.navigateToConversationOverlay()
		end
	end, {
		v164,
		v106.conversationId
	})

	local v165 = v156 ~= "channels"
	local v166 = useSelector(function(p16) -- line: 658
		-- upvalues: v165 (copy), AppChatNetworking (copy), v106 (copy), RoduxNetworking (copy)
		return ((if not v165 then AppChatNetworking.rodux.GetChatModerationStatuses.getStatus(p16, v106.conversationId) else AppChatNetworking.rodux.GetChatModerationStatuses.getStatus(p16))) == RoduxNetworking.Enum.NetworkStatus.NotStarted
	end)

	useEffect(function() -- line: 665
		-- upvalues: v166 (copy), v119 (copy), AppChatNetworking (copy), v165 (copy), v106 (copy)
		if v166 then
			v119(AppChatNetworking.rodux.GetChatModerationStatuses.API((if not v165 then { v106.conversationId } else nil))):catch(function(p17) -- line: 671
				warn("GetChatModerationStatuses error in ChatConversationContainer " .. tostring(p17))
			end)
		end
	end, {
		v106.conversationId,
		v165,
		v119,
		v166
	})

	local v167 = useChatTimeoutDetails({
		conversationId = v106.conversationId,
		conversationModerationType = v153
	})
	local isTimedOut = v167.isTimedOut
	local timeoutEndTimestamp = v167.timeoutEndTimestamp
	local decisionEventId = v167.decisionEventId
	local duration = v167.duration

	useEffect(function() -- line: 687
		-- upvalues: v150 (copy), ChatConversationTelemetryEvents (copy), v128 (copy)
		v150.emit(ChatConversationTelemetryEvents.ScreenRendered, {
			loadedMessageCount = #v128
		})
	end, { v106.conversationId })

	if v85 then
		local v172 = v128[1]
		local v173 = if not v172 then nil else v172.id

		useEffect(function() -- line: 701
			-- upvalues: isSyntheticSystemMessageId (copy), v173 (copy), IXPService (copy), v86 (copy)
			if isSyntheticSystemMessageId(v173) then
				IXPService:LogFlagLinkedUserLayerExposure(v86)
			end
		end, {
			v106.conversationId,
			v173
		})
	end

	local v174 = React.useCallback(function(s1: string) -- line: 708
		-- upvalues: v150 (copy), ChatConversationTelemetryEvents (copy), v152 (copy)
		v150.emit(ChatConversationTelemetryEvents.ScreenExit, {
			conversationExitType = s1
		})
		v152()
	end, {
		v150,
		v152
	})

	u110 = u110 or {}

	local v175 = u110.participantPendingStatus ~= ConversationChannels.UserPendingStatus.Pending and v117
	local v176 = not v175 and v117
	local v177 = useIsExternalNavigationAvailable({ EnumScreens.ViewUserProfile })
	local v178 = u110.conversationType == Conversation.Type.MULTI_USER_CONVERSATION
	local v179 = useSelector(function(p18) -- line: 728
		-- upvalues: v178 (copy), u110 (ref)
		return v178 and u110.initiator == p18.LocalUserId
	end)

	local function v180(p19) -- line: 733
		-- upvalues: v177 (copy), EnumScreens (copy), v108 (copy), v106 (copy), GenericDialogType (copy), v155 (copy), v178 (copy), v179 (copy)
		if v177[EnumScreens.ViewUserProfile] then
			v108(p19)

			return
		end

		v106.navigateToScreen(GenericDialogType.ParticipantDialog, {
			conversationId = v106.conversationId,
			participantId = p19,
			showRemoveUserButton = not v155 and (v178 and v179)
		}, true)
	end

	local v181 = if not if not FFlagAppChatSignalsReplyStore then v142 else v144 then v149.chatInputPlaceholder else if not v146 then v149.replyChatInputPlaceholder else v149.replyToYourselfChatInputPlaceholder

	useEffect(function() -- line: 751
		-- upvalues: v106 (copy), u123 (ref)
		v106.updateConversationTitle(u123)
	end, {
		u123,
		v106.updateConversationTitle
	})

	local v182 = React.useCallback(function() -- line: 755
		-- upvalues: chatInputBoxDisabledPressedSignal (copy), timeoutEndTimestamp (ref), decisionEventId (ref), duration (ref)
		chatInputBoxDisabledPressedSignal:fire({
			endTimestamp = timeoutEndTimestamp,
			decisionEventId = decisionEventId,
			duration = duration
		})
	end, {
		timeoutEndTimestamp,
		decisionEventId,
		duration
	})
	local v183, v184 = React.useState(v106.navigation and (v106.navigation.isFocused and v106.navigation.isFocused()))
	local v185 = nil
	local u186 = nil

	if FFlagAppChatPerfTracking then
		v185 = v183

		if FFlagRenderChatConversationOnlyWhenVisible and v106.isFocused and not v106.isFocused() then
			v185 = false
		end

		u186 = v185 and not v155
	end

	local v187 = nil

	if FFlagAppChatPerfTracking then
		local v188 = React.useRef(false)

		React.useEffect(function() -- line: 784
			-- upvalues: v188 (copy), v175 (copy)
			v188.current = not v175
		end, {
			v106.conversationId,
			v175
		})

		local v189 = React.useCallback(function(s2: string) -- line: 788
			-- upvalues: AppChatPerfTracker (copy), v106 (copy), u186 (ref), v188 (copy), Logger (copy), v128 (copy)
			if not AppChatPerfTracker.isActive(AppChatPerfTracker.Events.ChatConversationTTI, {
				conversationId = v106.conversationId
			}) or not u186 then
				return
			end

			if not v188.current then
				Logger:debug("TTI: Messages ready but waiting for input bar (chatInputBarReady={}, reason={})", v188.current, s2)

				return
			end

			AppChatPerfTracker.finish(AppChatPerfTracker.Events.ChatConversationTTI, {
				conversationId = v106.conversationId,
				numElementsRendered = #v128
			})
		end, {
			v106.conversationId,
			v183,
			v155,
			#v128
		})

		React.useEffect(function() -- line: 812
			-- upvalues: v189 (copy)
			v189("messages_ready")
		end, {
			v189,
			#v128,
			v106.conversationId
		})
		v187 = React.useCallback(function() -- line: 816
			-- upvalues: v188 (copy), v189 (copy)
			v188.current = true
			v189("input_bar_ready")
		end, { v189 })
	end

	if FFlagAppChatPerfTracking then
		local v190 = React.useRef(nil)

		React.useEffect(function() -- line: 830
			-- upvalues: Logger (copy), v106 (copy), v190 (copy), FFlagAppChatMessageTTIMilestones (copy), AppChatPerfTracker (copy)
			Logger:debug("Perf: Resetting message perf tracking for conversation {}", v106.conversationId)
			v190.current = nil

			local t4 = {
				conversationId = v106.conversationId
			}

			if FFlagAppChatMessageTTIMilestones then
				AppChatPerfTracker.cancel(AppChatPerfTracker.Events.MessageSendTTI, t4)
				AppChatPerfTracker.cancel(AppChatPerfTracker.Events.MessageReceiveTTI, t4)

				return
			end

			AppChatPerfTracker.cancel(AppChatPerfTracker.Events.MessageSendToPendingRender, t4)
			AppChatPerfTracker.cancel(AppChatPerfTracker.Events.MessageSendResponseToFinalRender, t4)
			AppChatPerfTracker.cancel(AppChatPerfTracker.Events.MessageSendToFinalRender, t4)
			AppChatPerfTracker.cancel(AppChatPerfTracker.Events.MessageReceiveToRender, t4)
		end, { v106.conversationId })
		React.useEffect(function() -- line: 848
			-- upvalues: v128 (copy), v106 (copy), v115 (copy), v190 (copy), FFlagAppChatMessageTTIMilestones (copy), AppChatPerfTracker (copy)
			local v209 = v128[1]

			if not v209 or not v209.id then
				return
			end

			local t5 = {
				conversationId = v106.conversationId
			}
			local v211 = v209.senderTargetId == v115

			if not v209.isSending and (v209.senderType == "system" or not v211) then
				if v209.id ~= v190.current then
					v190.current = v209.id

					if FFlagAppChatMessageTTIMilestones then
						AppChatPerfTracker.finish(AppChatPerfTracker.Events.MessageReceiveTTI, t5)
					else
						AppChatPerfTracker.finish(AppChatPerfTracker.Events.MessageReceiveToRender, t5)
					end
				end
			elseif FFlagAppChatMessageTTIMilestones then
				if AppChatPerfTracker.isActive(AppChatPerfTracker.Events.MessageReceiveTTI, t5) then
					AppChatPerfTracker.cancel(AppChatPerfTracker.Events.MessageReceiveTTI, t5)
				end
			elseif AppChatPerfTracker.isActive(AppChatPerfTracker.Events.MessageReceiveToRender, t5) then
				AppChatPerfTracker.cancel(AppChatPerfTracker.Events.MessageReceiveToRender, t5)
			end

			if not v211 then
				return
			end

			if FFlagAppChatMessageTTIMilestones then
				if v209.isSending then
					AppChatPerfTracker.trackMilestone(AppChatPerfTracker.Events.MessageSendTTI, AppChatPerfTracker.Milestone.FunctionallyReady, t5)

					return
				end

				AppChatPerfTracker.finish(AppChatPerfTracker.Events.MessageSendTTI, t5)

				return
			end

			if v209.isSending then
				AppChatPerfTracker.finish(AppChatPerfTracker.Events.MessageSendToPendingRender, t5)

				return
			end

			AppChatPerfTracker.finish(AppChatPerfTracker.Events.MessageSendResponseToFinalRender, t5)
			AppChatPerfTracker.finish(AppChatPerfTracker.Events.MessageSendToFinalRender, t5)
		end, {
			v128,
			v115,
			v106.conversationId
		})
	end

	useEffect(function() -- line: 912
		-- upvalues: v106 (copy), RoactNavigation (copy), FFlagAppChatPerfTracking (copy), v184 (copy), AppChatPerfTracker (copy)
		local v212 = v106.navigation and (v106.navigation.addListener and v106.navigation.addListener(RoactNavigation.Events.WillBlur, function(p20) -- line: 915
			-- upvalues: FFlagAppChatPerfTracking (copy), v184 (copy), AppChatPerfTracker (copy), v106 (copy)
			if FFlagAppChatPerfTracking then
				local v222 = not not p20 and (not not p20.action and (not not p20.action.params and (p20.action.params.isOverlay or false)))

				v184(v222)

				if v222 then
					return
				end

				if AppChatPerfTracker.isActive(AppChatPerfTracker.Events.ChatConversationTTI, {
					conversationId = v106.conversationId
				}) then
					AppChatPerfTracker.cancel(AppChatPerfTracker.Events.ChatConversationTTI, {
						conversationId = v106.conversationId
					})

					return
				end
			else
				if p20 and p20.action and p20.action.params and p20.action.params.isOverlay then
					v184(true)

					return
				end

				v184(false)
			end
		end))
		local v213 = v106.navigation and (v106.navigation.addListener and v106.navigation.addListener(RoactNavigation.Events.WillFocus, function(_) -- line: 946
			-- upvalues: v184 (copy)
			v184(true)
		end))

		return function() -- line: 950
			-- upvalues: v212 (copy), v213 (copy)
			if v212 then
				v212.remove()
			end

			if v213 then
				v213.remove()
			end
		end
	end, {
		v106.navigation,
		v106.conversationId
	})
	useEffect(function() -- line: 961
		-- upvalues: v129 (copy), v119 (copy), getAllRemainingOlderMessages (copy), getOlderMessages (copy), v106 (copy), v74 (copy), v149 (copy)
		if v129.shouldShowOsaCardOnInitialLoad then
			v119(getAllRemainingOlderMessages(getOlderMessages, v106.conversationId, v74)):catch(function() -- line: 965
				-- upvalues: v106 (copy), v149 (copy)
				v106.navigateToToast({
					toastProps = {
						toastContent = {
							toastTitle = v149.networkErrorText
						}
					}
				})
			end)
		end
	end, { v129.shouldShowOsaCardOnInitialLoad })

	local getCanAccessParty = v106.getCanAccessParty

	if FFlagAppChatPerfTracking then
		if not v185 then
			return nil
		end

		if v155 then
			return React.createElement(PendingStateConversationPage, {
				conversationId = v106.conversationId,
				topBarHeight = v106.topBarHeight,
				networkErrorText = v149.networkErrorText,
				navigateToToast = v106.navigateToToast,
				wideMode = v106.wideMode,
				onConversationUnmount = v174,
				navigateBack = v106.navigateBack
			})
		end

		return React.createElement(ChatConversation, Cryo.Dictionary.join(v106, v109, v149, {
			moreMenuEnabled = getCanAccessParty,
			conversation = u110,
			conversationTitle = u123,
			itemList = v130,
			localUserId = v115,
			openGameDetailsPage = v106.openGameDetailsPage,
			openViewProfile = v180,
			readingMessagesIsEnabled = v106.getReadingMessagesIsEnabled(),
			Users = v124,
			usersTyping = v125,
			displayNamesAvailable = v138,
			onConversationUnmount = v174,
			recipientIdsSerialized = v114,
			chatIsVisible = v116,
			chatInputPlaceholder = v181,
			replyingToMessageId = if not FFlagAppChatSignalsReplyStore then nil else v144,
			replyingToMessage = if FFlagAppChatSignalsReplyStore then nil else v142,
			replyingToMessageDispatch = if FFlagAppChatSignalsReplyStore then nil else v143,
			shouldShowChatInputBar = v175,
			shouldShowLegacyBottomModal = v176,
			shouldDisableChatInputBar = isTimedOut,
			onChatInputBarReady = if not FFlagAppChatPerfTracking then nil else v187,
			inputBarDisabledEndTimestampDisplay = timeoutEndTimestamp,
			onDisabledInputBarActivated = v182,
			scrollToTopOnInitialOsaLoad = v129.shouldShowOsaCardOnInitialLoad and v129.fetchedOldestMessage,
			navigateToSquadLobby = if not getCanAccessParty then nil else v106.navigateToSquadLobby,
			shouldHideMoreMenuButton = if not getCanAccessParty then nil else not v175,
			isInitialMessageLoading = if not FFlagAppChatConversationLoadingSkeleton then nil else v131
		}))
	end

	if not v183 then
		return nil
	end

	if FFlagRenderChatConversationOnlyWhenVisible and v106.isFocused and not v106.isFocused() then
		return nil
	end

	if v155 then
		return React.createElement(PendingStateConversationPage, {
			conversationId = v106.conversationId,
			topBarHeight = v106.topBarHeight,
			networkErrorText = v149.networkErrorText,
			navigateToToast = v106.navigateToToast,
			wideMode = v106.wideMode,
			onConversationUnmount = v174,
			navigateBack = v106.navigateBack,
			style = v106.style
		})
	end

	return React.createElement(ChatConversation, Cryo.Dictionary.join(v106, v109, v149, {
		moreMenuEnabled = getCanAccessParty,
		conversation = u110,
		conversationTitle = u123,
		itemList = v130,
		localUserId = v115,
		openGameDetailsPage = v106.openGameDetailsPage,
		openViewProfile = v180,
		readingMessagesIsEnabled = v106.getReadingMessagesIsEnabled(),
		Users = v124,
		usersTyping = v125,
		displayNamesAvailable = v138,
		onConversationUnmount = v174,
		recipientIdsSerialized = v114,
		chatIsVisible = v116,
		chatInputPlaceholder = v181,
		replyingToMessageId = if not FFlagAppChatSignalsReplyStore then nil else v144,
		replyingToMessage = if FFlagAppChatSignalsReplyStore then nil else v142,
		replyingToMessageDispatch = if FFlagAppChatSignalsReplyStore then nil else v143,
		shouldShowChatInputBar = v175,
		shouldShowLegacyBottomModal = v176,
		shouldDisableChatInputBar = isTimedOut,
		onChatInputBarReady = if not FFlagAppChatPerfTracking then nil else v187,
		inputBarDisabledEndTimestampDisplay = timeoutEndTimestamp,
		onDisabledInputBarActivated = v182,
		scrollToTopOnInitialOsaLoad = v129.shouldShowOsaCardOnInitialLoad and v129.fetchedOldestMessage,
		navigateToSquadLobby = if not getCanAccessParty then nil else v106.navigateToSquadLobby,
		shouldHideMoreMenuButton = if not getCanAccessParty then nil else not v175,
		isInitialMessageLoading = if not FFlagAppChatConversationLoadingSkeleton then nil else v131
	}))
end

return UniversalAppPolicy.connect(function(p22) -- line: 1090
	return {
		viewProfileOnAvatarPressed = p22.getChatTapConversationThumbnail(),
		getCanAccessParty = p22.getCanAccessParty()
	}
end)(ChatConversationContainer)
