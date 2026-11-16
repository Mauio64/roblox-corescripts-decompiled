local HttpService = game:GetService("HttpService")

local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local AppCommonLib = require(parent.AppCommonLib)
local AppChatNetworking = require(parent.AppChatNetworking)
local AppNavBar = require(parent.AppNavBar)
local VisibilityControl = AppNavBar.VisibilityControl
local Cryo = require(parent.Cryo)
local Foundation = require(parent.Foundation)
local Components = require(parent.FriendsLanding.Components)
local React = require(parent.React)
local RoactRodux = require(parent.RoactRodux)
local SharedFlags = require(parent.SharedFlags)
local ThemeBackground = require(parent.ThemeBackground)
local useThemeBackground = ThemeBackground.useThemeBackground
local FFlagAppThemeHalloween2026ChatBackground = require(AppChat.Flags.FFlagAppThemeHalloween2026ChatBackground)
local UIBlox = require(parent.UIBlox)
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local RoactUtils2 = require(parent.RoactUtils)
local useEffectOnMount = RoactUtils2.Hooks.useEffectOnMount
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useLocalUserId = RobloxAppHooks.useLocalUserId
local Navigation = require(parent.Navigation)
local useNavigation = Navigation.useNavigation
local RoactUtils3 = require(parent.RoactUtils)
local usePrevious = RoactUtils3.Hooks.usePrevious
local RoactUtils4 = require(parent.RoactUtils)
local useSelector = RoactUtils4.Hooks.RoactRodux.useSelector
local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage

local ChatLoadingContainer = require(script.Parent.ChatLoading.ChatLoadingContainer)
local ChatLandingTelemetryEvents = require(script.Parent.ChatLandingTelemetryEvents)
local ConversationGroupsEntryContainer = require(script.Parent.ConversationGroupsEntryContainer)
local ConversationListWithTopBar = require(script.Parent.ConversationListWithTopBar)
local Logger = require(script.Parent.Logger)
local v = Logger:new(script.Name)
local NoConversationsLanding = require(script.Parent.NoConversationsLanding)
local mapDispatchToProps = require(script.Parent.mapDispatchToProps)

local ChatLandingTelemetryLayer = require(AppChat.Telemetry.Layers.ChatLandingTelemetryLayer)
local ChatLandingTelemetryState = require(AppChat.Contexts.TelemetryState.ChatLandingTelemetryState)
local SocialLibraries = require(AppChat.SocialLibraries)
local compose = SocialLibraries.RoduxTools.compose
local ConversationChannels = require(AppChat.Models.ConversationChannels)
local createConversation = require(AppChat.Conversations.Thunks.createConversation)
local CreateConversationError = require(AppChat.Analytics.Enums.CreateConversationError)
local EmptyStateType = require(AppChat.Analytics.Enums.EmptyStateType)
local EnumScreens = require(AppChat.EnumScreens)
local EventNames = require(AppChat.Analytics.EventNames)
local fetchConversationsByPage = require(AppChat.Conversations.Thunks.fetchConversationsByPage)
local getConversationTitle = require(AppChat.Conversations.getConversationTitle)
local getOtherParticipants = require(AppChat.Conversations.getOtherParticipants)
local parseCreateConversationErrors = require(AppChat.Conversations.Thunks.parseCreateConversationErrors)
local SocialLibraries2 = require(AppChat.SocialLibraries)
local RoactPaginator = SocialLibraries2.RoactPaginator
local useAnalytics = require(AppChat.Analytics.useAnalytics)
local ChatPlacementContext = require(AppChat.Contexts.ChatPlacementContext)
local useChatPlacementContext = ChatPlacementContext.useChatPlacementContext
local useGetConversations = require(AppChat.Hooks.useGetConversations)
local useAreConversationsFetching = require(AppChat.Hooks.useAreConversationsFetching)
local useChatIsVisible = require(AppChat.Hooks.useChatIsVisible)
local useHasConversations = require(AppChat.Hooks.useHasConversations)
local useAppChatIsWideMode = require(AppChat.Hooks.useAppChatIsWideMode)
local useIsAppLoaded = require(AppChat.Hooks.useIsAppLoaded)
local useIsChatEnabled = require(AppChat.Hooks.useIsChatEnabled)
local useChatSettingsRetrievalStatus = require(AppChat.Hooks.useChatSettingsRetrievalStatus)
local useIsExternalNavigationAvailable = require(AppChat.Hooks.useIsExternalNavigationAvailable)
local useIsGroupChatEnabled = require(AppChat.Hooks.useIsGroupChatEnabled)
local useIsInExperience = require(AppChat.Hooks.useIsInExperience)
local useIsOldestConversationFetched = require(AppChat.Hooks.useIsOldestConversationFetched)
local useIsUserPending = require(AppChat.Hooks.useIsUserPending)
local useIsChatEnabledFromReason = require(AppChat.Hooks.useIsChatEnabledFromReason)
local useAnalytics2 = require(AppChat.Analytics.useAnalytics)
local useTelemetry = require(AppChat.Telemetry.useTelemetry)
local getConversationIds = require(AppChat.Utils.getConversationIds)

local FFlagAppChatPerfTracking = require(AppChat.Flags.FFlagAppChatPerfTracking)
local FFlagAppChatMessageTTIMilestones = require(AppChat.Flags.FFlagAppChatMessageTTIMilestones)
local SignalsMigrationConfig = require(AppChat.Flags.SignalsMigrationConfig)
local AppChatPerfTracker = require(AppChat.Telemetry.AppChatPerfTracker)
local FFlagAppChatConsoleFocusFixes = require(AppChat.Flags.FFlagAppChatConsoleFocusFixes)
local FFlagAppChatServerSideConversationSearch = require(AppChat.Flags.FFlagAppChatServerSideConversationSearch)
local FFlagAppChatSkipSearchWhenChatDisabled = require(AppChat.Flags.FFlagAppChatSkipSearchWhenChatDisabled)

local useCallback = React.useCallback
local useEffect = React.useEffect

local IsVRAppBuild = AppCommonLib.IsVRAppBuild

local useTokens = Foundation.Hooks.useTokens
local useStyle = UIBlox.Core.Style.useStyle
local useTextSizeOffset = UIBlox.Core.Style.useTextSizeOffset

local NoFriendsView = Components.NoFriendsView

local FFlagAppIaScrollAway = SharedFlags.FFlagAppIaScrollAway
local FFlagEnableScrollAwayContentScrollableFix = SharedFlags.FFlagEnableScrollAwayContentScrollableFix
local FFlagSignalsNavP3hMisc = SharedFlags.FFlagSignalsNavP3hMisc
local getFFlagChatTabHideGroupsLinkOnVR = require(AppChat.Flags.getFFlagChatTabHideGroupsLinkOnVR)
local GetTopBarStore = require(AppChat.Stores.GetTopBarStore)
local SocialExperiments = require(parent.SocialExperiments)
local PartyPageCarouselExperimentation = SocialExperiments.PartyPageCarouselExperimentation
local SharedFlags2 = require(parent.SharedFlags)
local FFlagCreateConnectionsHub = SharedFlags2.FFlagCreateConnectionsHub
local SocialExperiments2 = require(parent.SocialExperiments)
local SquadQuickStartExperimentation = SocialExperiments2.SquadQuickStartExperimentation
local useCanAccessParty = require(parent.Squads.useCanAccessParty)
local useConversationList = require(AppChat.Hooks.useConversationList)
local useConversationSearchListProps = require(AppChat.Hooks.useConversationSearchListProps)
local useChatSearchSession = require(AppChat.Hooks.useChatSearchSession)
local FFlagAppChatSearchSessionTelemetry = require(AppChat.Flags.FFlagAppChatSearchSessionTelemetry)
local FFlagAppChatVisibleIsInConversation = require(AppChat.Flags.FFlagAppChatVisibleIsInConversation)
local getIsInConversationForTelemetry = require(script.Parent.Utils.getIsInConversationForTelemetry)
local FFlagAppChatConversationLoadRetry = require(AppChat.Flags.FFlagAppChatConversationLoadRetry)
local RoduxNetworking = require(AppChat.Http.RoduxNetworking)

local shouldReadConversationListFromSignalsStore = SignalsMigrationConfig.shouldReadConversationListFromSignalsStore
local placeId

if game.PlaceId > 0 then
	placeId = tostring(game.PlaceId)
else
	placeId = nil
end

local gameId

if game.GameId > 0 then
	gameId = tostring(game.GameId)
else
	gameId = nil
end

local v2 = {
	topBarHeight = 0,
	isShowingFilterBox = false,
	navigateToSquadLobby = function() end
}

local function areConversationIdsEqual(conversationIds, conversationIds2): boolean -- 1 equivalent call inferred from this helper
	if #conversationIds ~= #conversationIds2 then
		return false
	end

	for k, item in conversationIds do
		if item ~= conversationIds2[k] then
			return false
		end
	end

	return true
end

local function encodeConversationIds(conversationIds) -- 2 equivalent calls inferred from this helper
	local success, result = pcall(function()
		return HttpService:JSONEncode(conversationIds)
	end)
	return if success then result else "[]"
end

function ChatLandingContainer(p)
	local joined = Cryo.Dictionary.join(v2, p)

	local v3 = useAnalytics()
	local v4 = useChatPlacementContext()
	local v5 = useDispatch()
	local v6 = useIsChatEnabled()
	local v7 = useIsGroupChatEnabled()
	local privacySettingsEnabled = useIsChatEnabledFromReason("privacySettingsEnabled")
	local globalRulesEnabled = useIsChatEnabledFromReason("globalRulesEnabled")
	local thirdPartyPrivacySettingsEnabled = useIsChatEnabledFromReason("thirdPartyPrivacySettingsEnabled")
	local isInExperience = useIsInExperience()
	local isWideMode = useAppChatIsWideMode(isInExperience)

	if FFlagAppChatPerfTracking and FFlagAppChatMessageTTIMilestones and AppChatPerfTracker.Hooks then
		local v8 = AppChatPerfTracker.getEventName(AppChatPerfTracker.Events.ChatLandingTTI) or ""

		AppChatPerfTracker.Hooks.useTTIRenderAndMountedTracking(v8)
	end

	local appLoaded = useIsAppLoaded()
	local conversationsIsFetching = useAreConversationsFetching()
	local v8 = useHasConversations()
	local oldestConversationIsFetched = useIsOldestConversationFetched()
	local localUserId = useLocalUserId()
	local v9 = useNavigation()
	local v10

	if FFlagAppThemeHalloween2026ChatBackground then
		v10 = useThemeBackground() ~= nil
	else
		v10 = false
	end

	local v11 = useStyle()
	local v12 = useTextSizeOffset()
	local v13 = useAnalytics2()
	local v14

	if FFlagAppChatConsoleFocusFixes then
		v14 = useTokens()
	end

	local v15

	if FFlagAppChatConsoleFocusFixes then
		v15 = v14.Size.Size_1600 + 2 * v12
	else
		v15 = 64 + 2 * v12
	end

	local v16

	if FFlagCreateConnectionsHub then
		v16 = v9.getScreenProps("navigateToLuaAppPages", {})
	else
		v16 = nil
	end

	local v17 = useGetConversations()
	local v18, v19

	if shouldReadConversationListFromSignalsStore then
		local v20 = useConversationList(true)
		v18 = v20.items
		v19 = v20.listStatus
	else
		v18 = {}
		v19 = {}
	end

	local v20

	if shouldReadConversationListFromSignalsStore then
		v20 = v18
	else
		v20 = v17
	end

	if shouldReadConversationListFromSignalsStore then
		conversationsIsFetching = v19.isFetchingConversations == true
	end

	if shouldReadConversationListFromSignalsStore then
		v8 = #v18 > 0
	end

	if shouldReadConversationListFromSignalsStore then
		oldestConversationIsFetched = v19.oldestConversationIsFetched == true
	end

	local v21, v22

	if FFlagAppChatConversationLoadRetry then
		if shouldReadConversationListFromSignalsStore then
			local isFetchingNextPage = v19.isFetchingNextPage == true

			if v19.isFetchingConversations == true then
				v21 = not isFetchingNextPage
			else
				v21 = false
			end

			if v19.error == nil or v19.hasFetchedInitialPage == true then
				v22 = false
			else
				v22 = not v21
			end
		else
			local v23 = useSelector(function(p2)
				return AppChatNetworking.rodux.GetUserConversations.getStatus(p2)
			end)

			v21 = v23 == RoduxNetworking.Enum.NetworkStatus.Fetching
			v22 = v23 == RoduxNetworking.Enum.NetworkStatus.Failed
		end
	else
		v22 = false
		v21 = false
	end

	local v23, v24

	if FFlagAppChatServerSideConversationSearch then
		local v25 = joined.isShowingFilterBox == true

		if FFlagAppChatSkipSearchWhenChatDisabled then
			v25 = v25 and v6
		end

		v23, v24 = useConversationSearchListProps(
			joined.filterText,
			v25,
			localUserId,
			v7,
			joined.navigateToConversation
		)
	else
		v23 = false
		v24 = {}
	end

	if FFlagAppChatSearchSessionTelemetry then
		local v25

		if joined.isShowingFilterBox == true and joined.filterText ~= nil then
			v25 = joined.filterText:match("%S") ~= nil
		else
			v25 = false
		end

		if FFlagAppChatServerSideConversationSearch and FFlagAppChatSkipSearchWhenChatDisabled then
			v25 = v25 and v6
		end

		useChatSearchSession(v25, FFlagAppChatServerSideConversationSearch)
	end

	if shouldReadConversationListFromSignalsStore then
		useEffect(function()
			if #v17 == 0 and #v18 == 0 then
				return
			end

			local conversationIds = getConversationIds(v17)
			local conversationIds2 = getConversationIds(v18)

			if not areConversationIdsEqual(conversationIds, conversationIds2) then -- inferred equivalent call
				v:warning(
					"Conversation list parity mismatch. Rodux ids: {}, Signals ids: {}",
					encodeConversationIds(conversationIds), -- inferred equivalent call
					encodeConversationIds(conversationIds2) -- inferred equivalent call
				)
			end
		end, { v17, v18 })
	end

	local v25 = usePrevious(v6)
	useEffect(function()
		v:debug("Comparing previousIsChatEnabled ({}) --> isChatEnabled ({})", v25, v6)

		if v25 ~= nil and v25 ~= v6 and v6 then
			v:info("Chat has become enabled, fetching conversations")
			v5(fetchConversationsByPage())
		end
	end, { v5, v6, v25 })

	local useMemo = React.useMemo
	local function fn()
		local count = 0
		local count2 = 0
		local result = {}

		for _, joined2 in v20 do
			if shouldReadConversationListFromSignalsStore and joined2.otherParticipants == nil then
				joined2 = Cryo.Dictionary.join(joined2, {
					otherParticipants = getOtherParticipants(joined2, localUserId)
				})
			end

			if useIsUserPending(joined2) then
				count += 1
			end

			if joined2.moderationType == ConversationChannels.ModerationType.TrustedComms then
				count2 += 1
			end

			local conversationTitle = getConversationTitle(joined2)

			if v7 or joined2.conversationType ~= "MultiUserConversation" then
				table.insert(result, Cryo.Dictionary.join(joined2, { title = conversationTitle }))
			end
		end

		return result, count, count2
	end

	local v26

	if shouldReadConversationListFromSignalsStore then
		v26 = localUserId
	end

	local itemList, pendingConversationCount, unfilteredConversationCount = useMemo(fn, { v20, v7, v26 })

	local v27 = useTelemetry(ChatLandingTelemetryLayer.Context)
	local v28 = v27.emit

	if shouldReadConversationListFromSignalsStore then
		local ref = React.useRef(v27.emit)
		ref.current = v27.emit
		v28 = function(...)
			ref.current(...)
		end
	end

	local v29 = ChatLandingTelemetryState.useSetState()

	useEffect(function()
		v29(function(p2)
			return Cryo.Dictionary.join(p2, {
				chatLandingListCount = #itemList,
				pendingConversationCount = pendingConversationCount,
				unfilteredConversationCount = unfilteredConversationCount
			})
		end)
	end, {
		#itemList,
		pendingConversationCount,
		unfilteredConversationCount,
		v29
	})

	useEffectOnMount(function()
		v27.emit(ChatLandingTelemetryEvents.ScreenRendered, { isChatEnabled = v6 })
	end)

	local v30 = useLocalization({
		chatUnavailableWithUser = "Feature.Chat.Message.ChatUnavailableWithUser",
		networkErrorText = "Feature.Toast.NetworkingError.SomethingIsWrong",
		conversationLoadError = FFlagAppChatConversationLoadRetry and "CommonUI.Messages.Response.PageError" or nil,
		refresh = FFlagAppChatConversationLoadRetry and "CommonUI.Controls.Action.Refresh" or nil
	})

	local navigateToQuickStartSquadInviteFriends = useCallback(function()
		if PartyPageCarouselExperimentation.getPartyPageCarouselEnabled() then
			local guid = HttpService:GenerateGUID(false)

			v3.fireAnalyticsEvent(EventNames.ChatLandingPartyQuickStartButtonClicked, {
				clickLocation = v4.chatPlacement,
				partyAttemptId = guid,
				placeId = placeId,
				universeId = gameId
			})

			v9.navigate(EnumScreens.QuickStartSquadInviteFriends, { uuid = guid })
		end
	end, { v3, v4, v9, placeId, gameId })

	local navigateToConversationFromUserId = useCallback(function(p2)
		if PartyPageCarouselExperimentation.getPartyPageCarouselEnabled() then
			v5(createConversation("one_to_one", { p2 }, v13, "navigateToConversationFromSocialCarousel")):andThen(function(p3)
				if FFlagAppChatPerfTracking then
					AppChatPerfTracker.start(AppChatPerfTracker.Events.ChatConversationTTI, {
						conversationId = p3.id
					})
				end

				v9.navigate(EnumScreens.ChatConversation, { conversationId = p3.id })
			end):catch(function(p3)
				local toastTitle

				if parseCreateConversationErrors(p3) == "participant_chat_disabled" then
					toastTitle = v30.chatUnavailableWithUser
				else
					toastTitle = v30.networkErrorText
				end

				v9.navigate(EnumScreens.RoactChatToast, {
					toastProps = {
						toastContent = { toastTitle = toastTitle }
					}
				})

				if v13 then
					v13.fireAnalyticsEvent(EventNames.NewConversationCreated, {
						createConversationResult = CreateConversationError.FetchConversationError
					})
				end
			end)
		end
	end, { v5, v30, parseCreateConversationErrors, v9, v13 })

	local empty = Cryo.isEmpty(itemList)
	local isChatLoading = useChatSettingsRetrievalStatus() ~= "Done"
		or empty and conversationsIsFetching
		or empty and v8

	local v31 = false
	local v32 = false
	local v49 = false
	local v50 = useIsExternalNavigationAvailable({
		EnumScreens.AddFriends,
		EnumScreens.PrivacySettings,
		EnumScreens.Groups
	})

	local v51 = FFlagAppIaScrollAway and not isInExperience and AppNavBar.getScrollAwayEnabled()

	local canAccessParty = useCanAccessParty()
	local isPartyQuickStartEnabled = SquadQuickStartExperimentation.getPartyQuickStartChangesEnabled()
		and canAccessParty

	local v54 = isChatLoading

	if FFlagAppChatConversationLoadRetry and v6 and not v23 and empty then
		v54 = v54 or v21
	end

	local v55

	if v54 then
		local createElement = React.createElement
		local v56 = {
			topBarHeight = joined.topBarHeight,
			pageHeaderText = joined.pageHeaderText,
			cellHeight = v15,
			cellWidth = 375,
			topPadding = 0,
			pageBackgroundTransparency = 0
		}
		local topPadding

		if FFlagAppIaScrollAway and v51 then
			topPadding = joined.topBarHeight
		end

		v56.topPadding = topPadding
		v56.pageBackgroundTransparency = v10 and 1 or nil
		v55 = createElement(ChatLoadingContainer, v56)
		v31 = true
	elseif
		FFlagAppChatConversationLoadRetry
		and v6
		and not v23
		and empty
		and appLoaded
		and not conversationsIsFetching
		and v22
	then
		v55 = React.createElement(Foundation.Empty, {
			text = v30.conversationLoadError,
			button = { text = v30.refresh, onActivated = joined.onRetryConversations }
		})
		v31 = true
	elseif v6 and (v23 or not empty or not appLoaded or conversationsIsFetching) then
		local formatted = `conversationListWithTopBar{joined.filterText}`

		v31 = true
		v32 = true
		v49 = true

		local createElement = React.createElement

		local join = Cryo.Dictionary.join
		local filterText

		if joined.isShowingFilterBox then
			filterText = joined.filterText or nil
		end

		local v56 = {
			filterText = filterText,
			key = formatted,
			itemList = itemList,
			appLoaded = appLoaded,
			localUserId = localUserId,
			conversationsIsFetching = conversationsIsFetching,
			oldestConversationIsFetched = oldestConversationIsFetched,
			entryHeight = v15,
			isInExperience = isInExperience,
			isWideMode = 0,
			navigateToConversationFromUserId = 0,
			navigateToQuickStartSquadInviteFriends = 0,
			showGroupsLink = 0,
			canvasTopPadding = 0,
			pageBackgroundTransparency = 0,
			canAccessParty = 0,
			isPartyQuickStartEnabled = 0
		}

		if not (PartyPageCarouselExperimentation.getPartyPageCarouselEnabled() or SignalsMigrationConfig.shouldUseFoundationConversationRow) then
			isWideMode = nil
		end

		v56.isWideMode = isWideMode

		if not PartyPageCarouselExperimentation.getPartyPageCarouselEnabled() then
			navigateToConversationFromUserId = nil
		end

		v56.navigateToConversationFromUserId = navigateToConversationFromUserId

		if not PartyPageCarouselExperimentation.getPartyPageCarouselEnabled() then
			navigateToQuickStartSquadInviteFriends = nil
		end

		v56.navigateToQuickStartSquadInviteFriends = navigateToQuickStartSquadInviteFriends

		v56.showGroupsLink = v50[EnumScreens.Groups]
		local canvasTopPadding

		if FFlagAppIaScrollAway and v51 then
			canvasTopPadding = joined.topBarHeight
		end

		v56.canvasTopPadding = canvasTopPadding
		v56.pageBackgroundTransparency = v10 and 1 or nil
		v56.canAccessParty = canAccessParty
		v56.isPartyQuickStartEnabled = isPartyQuickStartEnabled
		v55 = createElement(ConversationListWithTopBar, join(joined, v56, v24))
	elseif v6 then
		v55 = React.createElement("Frame", {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundColor3 = v11.Theme.BackgroundDefault.Color,
			BackgroundTransparency = v10 and 1 or v11.Tokens.Color.None.Transparency,
			BorderSizePixel = 0
		}, {
			NoFriendsView = React.createElement(NoFriendsView, {
				pageRenderReport = function()
					v27.emit(ChatLandingTelemetryEvents.ChatEmptyStateScreenRendered, {
						emptyStateType = EmptyStateType.NoFriendsView
					})
				end,
				openAddFriendsPage = function()
					v27.emit(ChatLandingTelemetryEvents.ChatAddFriendsBtnClicked, {})

					if FFlagCreateConnectionsHub then
						v16[AppPage.CoHubAddConnections]()
					else
						joined.navigateToAddFriends()
					end
				end,
				noFriendsHeaderKey = "Feature.Chat.Label.AddFriends",
				noFriendsTextLabelKey = "Feature.Chat.Text.NoFriends",
				addFriendsBtnLabelKey = "Feature.Chat.Label.AddFriends",
				addFriendsBtnEnabled = v50[EnumScreens.AddFriends]
			})
		})
		v31 = true
	else
		v55 = React.createElement(NoConversationsLanding, {
			chatEnabled = v6,
			privacySettingsEnabled = privacySettingsEnabled,
			globalRulesEnabled = globalRulesEnabled,
			thirdPartyPrivacySettingsEnabled = thirdPartyPrivacySettingsEnabled,
			canNavigateToPrivacySettings = v50[EnumScreens.PrivacySettings],
			canNavigateToAddFriends = v50[EnumScreens.AddFriends],
			onCallToAction = function(p2)
				if p2 == "privacy" then
					joined.navigateToPrivacy()
				elseif p2 == "friends" then
					v27.emit(ChatLandingTelemetryEvents.ChatAddFriendsBtnClicked, {})

					if FFlagCreateConnectionsHub then
						v16[AppPage.CoHubAddConnections]()
					else
						joined.navigateToAddFriends()
					end
				end
			end,
			fireRenderEvent = function(p2)
				local emptyStateType

				if p2 == "friends" then
					emptyStateType = EmptyStateType.NoFriendsView
				elseif p2 == "privacy" then
					emptyStateType = EmptyStateType.ChatSettingsDisabledView
				elseif p2 == "regional" then
					emptyStateType = EmptyStateType.ChatUnavailableRegionView
				else
					emptyStateType = EmptyStateType.EmptyConversationList
				end

				v27.emit(ChatLandingTelemetryEvents.ChatEmptyStateScreenRendered, {
					emptyStateType = emptyStateType
				})
			end
		})
	end

	if FFlagAppIaScrollAway and FFlagEnableScrollAwayContentScrollableFix then
		useEffect(function()
			if not v51 then
				return
			end

			VisibilityControl.setContentScrollable(v49)
		end, { v49, v51 })
	end

	local v56 = getFFlagChatTabHideGroupsLinkOnVR() and IsVRAppBuild() and true or v31

	useEffect(function()
		if isInExperience then
			GetTopBarStore(false).setScreenTopBar(EnumScreens.ChatLanding, {
				rightHidden = not v32
			})
		end
	end, { v32, isInExperience })

	if not v56 and v50[EnumScreens.Groups] then
		local createElement = React.createElement
		local fragment = React.Fragment
		local uiPadding

		if FFlagAppIaScrollAway and v51 then
			uiPadding = React.createElement("UIPadding", {
				PaddingTop = UDim.new(0, joined.topBarHeight)
			})
		end

		v55 = createElement(fragment, nil, {
			UIPadding = uiPadding,
			groupsLink = React.createElement(ConversationGroupsEntryContainer, { entryHeight = v15 }),
			chatFrame = React.createElement("Frame", {
				Size = UDim2.new(1, 0, 1, -v15),
				Position = UDim2.new(0, 0, 0, v15),
				BackgroundTransparency = 1,
				BorderSizePixel = 0
			}, { chatContainer = v55 })
		})
	end

	local v57 = useChatIsVisible()

	React.useEffect(function()
		if v57 then
			local appChatVisible = ChatLandingTelemetryEvents.AppChatVisible
			local v59 = { isChatEnabled = v6, isChatLoading = isChatLoading, isInConversation = 0 }
			local isInConversation

			if FFlagAppChatVisibleIsInConversation then
				isInConversation = getIsInConversationForTelemetry(v9)
			end

			v59.isInConversation = isInConversation
			v28(appChatVisible, v59)
		end
	end, { v57, v6, isChatLoading })

	if FFlagAppChatPerfTracking then
		React.useEffect(function()
			if not v57 then
				return
			end

			local v58 = not v54 and v6
			v:debug(
				"TTI Ready Check (ChatLanding): isLoading={}, isChatEnabled={}, itemCount={}, ready={}",
				v54,
				v6,
				#itemList,
				v58
			)

			if v58 and AppChatPerfTracker.isActive(AppChatPerfTracker.Events.ChatLandingTTI) then
				AppChatPerfTracker.finish(AppChatPerfTracker.Events.ChatLandingTTI, {
					numElementsRendered = #itemList
				})
			end
		end, {
			v57,
			v54,
			v6,
			#itemList
		})
	end

	local ref = React.useRef({ isChatEnabled = v6, isChatLoading = isChatLoading })

	React.useEffect(function()
		ref.current = { isChatEnabled = v6, isChatLoading = isChatLoading }
	end, { v6, isChatLoading })

	useEffect(function()
		return function()
			if v57 then
				v28(ChatLandingTelemetryEvents.AppChatClosed, ref.current)
			end
		end
	end, { v57 })

	if not FFlagSignalsNavP3hMisc then
		return v55
	end

	local ref2 = React.useRef(nil)

	if v57 or ref2.current == nil then
		ref2.current = v55
	end

	return ref2.current
end

local function paginatorParameters()
	return { pageSize = 30 }
end

local v3 = compose(RoactRodux.connect(nil, mapDispatchToProps), RoactPaginator.connect(paginatorParameters))(ChatLandingContainer)

local function PaginatorPropsBridge(p): nil
	local v4 = p[RoactPaginator.loadNext]
	local v5 = p[RoactPaginator.loadPrevious]
	local onPaginatorReady = p.onPaginatorReady
	React.useLayoutEffect(function()
		onPaginatorReady({ [RoactPaginator.loadNext] = v4, [RoactPaginator.loadPrevious] = v5 })
	end, { v4, v5, onPaginatorReady })
	return nil
end

local v4 = compose(RoactRodux.connect(nil, mapDispatchToProps), RoactPaginator.connect(paginatorParameters))(PaginatorPropsBridge)

local v5 = RoactRodux.connect(nil, mapDispatchToProps)(ChatLandingContainer)

local function ChatLandingContainerWithRetry(p)
	local state, setState = React.useState(0)
	local ref = React.useRef({})
	local onRetryConversations = useCallback(function()
		setState(function(p2)
			return p2 + 1
		end)
	end, {})
	local onPaginatorReady = useCallback(function(current)
		ref.current = current
	end, {})
	local v6 = useCallback(function(...)
		local v6 = ref.current[RoactPaginator.loadNext]

		if v6 then
			return v6(...)
		end

		return nil
	end, {})
	local v7 = useCallback(function(...)
		local v7 = ref.current[RoactPaginator.loadPrevious]

		if v7 then
			return v7(...)
		end

		return nil
	end, {})

	return React.createElement(React.Fragment, nil, {
		Paginator = React.createElement(v4, { key = state, onPaginatorReady = onPaginatorReady }),
		Landing = React.createElement(
			v5,
			Cryo.Dictionary.join(p, {
				[RoactPaginator.loadNext] = v6,
				[RoactPaginator.loadPrevious] = v7,
				onRetryConversations = onRetryConversations
			})
		)
	})
end

if FFlagAppChatConversationLoadRetry then
	return ChatLandingContainerWithRetry
end

return v3
