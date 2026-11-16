local HttpService = game:GetService("HttpService")

local AppCommonLib = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppCommonLib")
local AppChatNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChatNetworking")
local AppNavBar = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppNavBar")
local visibilityControl = AppNavBar.VisibilityControl
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Foundation")
local Components = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/FriendsLanding/Components")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local RoactRodux = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactRodux")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags")
local useThemeBackground = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/ThemeBackground").useThemeBackground
local FFlagAppThemeHalloween2026ChatBackground = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppThemeHalloween2026ChatBackground")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UIBlox")
local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactUtils").Hooks.RoactRodux.useDispatch
local useEffectOnMount = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactUtils").Hooks.useEffectOnMount
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Localization").Hooks.useLocalization
local useLocalUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RobloxAppHooks").useLocalUserId
local useNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Navigation").useNavigation
local usePrevious = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactUtils").Hooks.usePrevious
local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactUtils").Hooks.RoactRodux.useSelector
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RobloxAppEnums").AppPage

local ChatLoadingContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatLanding/ChatLoading/ChatLoadingContainer")
local ChatLandingTelemetryEvents = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatLanding/ChatLandingTelemetryEvents")
local ConversationGroupsEntryContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatLanding/ConversationGroupsEntryContainer")
local ConversationListWithTopBar = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatLanding/ConversationListWithTopBar")
local v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatLanding/Logger"):new("ChatLandingContainer")
local NoConversationsLanding = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatLanding/NoConversationsLanding")
local mapDispatchToProps = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatLanding/mapDispatchToProps")

local ChatLandingTelemetryLayer = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/Layers/ChatLandingTelemetryLayer")
local ChatLandingTelemetryState = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Contexts/TelemetryState/ChatLandingTelemetryState")
local compose = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/SocialLibraries").RoduxTools.compose
local ConversationChannels = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Models/ConversationChannels")
local createConversation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Thunks/createConversation")
local CreateConversationError = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Analytics/Enums/CreateConversationError")
local EmptyStateType = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Analytics/Enums/EmptyStateType")
local EnumScreens = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/EnumScreens")
local EventNames = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Analytics/EventNames")
local fetchConversationsByPage = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Thunks/fetchConversationsByPage")
local getConversationTitle = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/getConversationTitle")
local getOtherParticipants = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/getOtherParticipants")
local parseCreateConversationErrors = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Thunks/parseCreateConversationErrors")
local roactPaginator = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/SocialLibraries").RoactPaginator
local useAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Analytics/useAnalytics")
local useChatPlacementContext = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Contexts/ChatPlacementContext").useChatPlacementContext
local useGetConversations = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useGetConversations")
local useAreConversationsFetching = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useAreConversationsFetching")
local useChatIsVisible = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useChatIsVisible")
local useHasConversations = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useHasConversations")
local useAppChatIsWideMode = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useAppChatIsWideMode")
local useIsAppLoaded = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useIsAppLoaded")
local useIsChatEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useIsChatEnabled")
local useChatSettingsRetrievalStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useChatSettingsRetrievalStatus")
local useIsExternalNavigationAvailable = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useIsExternalNavigationAvailable")
local useIsGroupChatEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useIsGroupChatEnabled")
local useIsInExperience = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useIsInExperience")
local useIsOldestConversationFetched = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useIsOldestConversationFetched")
local useIsUserPending = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useIsUserPending")
local useIsChatEnabledFromReason = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useIsChatEnabledFromReason")
local module45 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Analytics/useAnalytics")
local useTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/useTelemetry")
local getConversationIds = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/getConversationIds")

local FFlagAppChatPerfTracking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatPerfTracking")
local FFlagAppChatMessageTTIMilestones = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatMessageTTIMilestones")
local SignalsMigrationConfig = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/SignalsMigrationConfig")
local AppChatPerfTracker = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/AppChatPerfTracker")
local FFlagAppChatConsoleFocusFixes = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatConsoleFocusFixes")
local FFlagAppChatServerSideConversationSearch = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatServerSideConversationSearch")
local FFlagAppChatSkipSearchWhenChatDisabled = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatSkipSearchWhenChatDisabled")

local useCallback = React.useCallback
local useEffect = React.useEffect

local isVRAppBuild = AppCommonLib.IsVRAppBuild

local useTokens = Foundation.Hooks.useTokens
local useStyle = UIBlox.Core.Style.useStyle
local useTextSizeOffset = UIBlox.Core.Style.useTextSizeOffset

local noFriendsView = Components.NoFriendsView

local fFlagAppIaScrollAway = SharedFlags.FFlagAppIaScrollAway
local fFlagEnableScrollAwayContentScrollableFix = SharedFlags.FFlagEnableScrollAwayContentScrollableFix
local fFlagSignalsNavP3hMisc = SharedFlags.FFlagSignalsNavP3hMisc
local getFFlagChatTabHideGroupsLinkOnVR = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/getFFlagChatTabHideGroupsLinkOnVR")
local GetTopBarStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetTopBarStore")
local partyPageCarouselExperimentation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SocialExperiments").PartyPageCarouselExperimentation
local fFlagCreateConnectionsHub = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").FFlagCreateConnectionsHub
local squadQuickStartExperimentation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SocialExperiments").SquadQuickStartExperimentation
local useCanAccessParty = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Squads/useCanAccessParty")
local useConversationList = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useConversationList")
local useConversationSearchListProps = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useConversationSearchListProps")
local useChatSearchSession = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useChatSearchSession")
local FFlagAppChatSearchSessionTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatSearchSessionTelemetry")
local FFlagAppChatVisibleIsInConversation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatVisibleIsInConversation")
local getIsInConversationForTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatLanding/Utils/getIsInConversationForTelemetry")
local FFlagAppChatConversationLoadRetry = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatConversationLoadRetry")
local RoduxNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Http/RoduxNetworking")

local shouldReadConversationListFromSignalsStore = SignalsMigrationConfig.shouldReadConversationListFromSignalsStore

local placeId = if game.PlaceId > 0 then tostring(game.PlaceId) else nil
local gameId = if game.GameId > 0 then tostring(game.GameId) else nil

local v6 = {
	topBarHeight = 0,
	isShowingFilterBox = false,
	navigateToSquadLobby = function() end
}

local function areConversationIdsEqual(list, list2): boolean
	if #list ~= #list2 then
		return false
	end

	for k, item in list do
		if item ~= list2[k] then
			return false
		end
	end

	return true
end

local function encodeConversationIds(p2)
	local success, result = pcall(function()
		return HttpService:JSONEncode(p2)
	end)

	if success then
		return result
	end

	return "[]"
end

function LUAUFORGE_MODULE_GLOBALS_hgk_ChatLandingContainer(p2)
	local joined = Cryo.Dictionary.join(v6, p2)

	local v7 = useAnalytics()
	local v8 = useChatPlacementContext()
	local v9 = useDispatch()
	local v10 = useIsChatEnabled()
	local v11 = useIsGroupChatEnabled()
	local v12 = useIsChatEnabledFromReason("privacySettingsEnabled")
	local v13 = useIsChatEnabledFromReason("globalRulesEnabled")
	local v14 = useIsChatEnabledFromReason("thirdPartyPrivacySettingsEnabled")
	local v15 = useIsInExperience()
	local v16 = useAppChatIsWideMode(v15)

	if FFlagAppChatPerfTracking and FFlagAppChatMessageTTIMilestones and AppChatPerfTracker.Hooks then
		local v17 = AppChatPerfTracker.getEventName(AppChatPerfTracker.Events.ChatLandingTTI) or ""

		AppChatPerfTracker.Hooks.useTTIRenderAndMountedTracking(v17)
	end

	local v17 = useIsAppLoaded()
	local v18 = useAreConversationsFetching()
	local v19 = useHasConversations()
	local v20 = useIsOldestConversationFetched()
	local v21 = useLocalUserId()
	local v22 = useNavigation()

	local v23 = if FFlagAppThemeHalloween2026ChatBackground then useThemeBackground() ~= nil else false

	local v24 = useStyle()
	local v25 = useTextSizeOffset()
	local v26 = module45()
	local v27 = if FFlagAppChatConsoleFocusFixes then useTokens() else nil

	local v28 = if FFlagAppChatConsoleFocusFixes then v27.Size.Size_1600 + 2 * v25 else 64 + 2 * v25

	local v29 = if fFlagCreateConnectionsHub then v22.getScreenProps("navigateToLuaAppPages", {}) else nil

	local v30 = useGetConversations()
	local v31, v32

	if shouldReadConversationListFromSignalsStore then
		local v33 = useConversationList(true)
		v31 = v33.items
		v32 = v33.listStatus
	else
		v31 = {}
		v32 = {}
	end

	local v33 = if shouldReadConversationListFromSignalsStore then v31 else v30

	if shouldReadConversationListFromSignalsStore then
		v18 = v32.isFetchingConversations == true
	end

	if shouldReadConversationListFromSignalsStore then
		v19 = #v31 > 0
	end

	if shouldReadConversationListFromSignalsStore then
		v20 = v32.oldestConversationIsFetched == true
	end

	local v34, v35

	if FFlagAppChatConversationLoadRetry then
		if shouldReadConversationListFromSignalsStore then
			local isFetchingNextPage = v32.isFetchingNextPage == true
			v34 = v32.isFetchingConversations == true and not isFetchingNextPage
			v35 = not (v32.error == nil or v32.hasFetchedInitialPage == true) and not v34
		else
			local v36 = useSelector(function(p3)
				return AppChatNetworking.rodux.GetUserConversations.getStatus(p3)
			end)

			v34 = v36 == RoduxNetworking.Enum.NetworkStatus.Fetching
			v35 = v36 == RoduxNetworking.Enum.NetworkStatus.Failed
		end
	else
		v35 = false
		v34 = false
	end

	local v36, v37

	if FFlagAppChatServerSideConversationSearch then
		local v38 = joined.isShowingFilterBox == true

		if FFlagAppChatSkipSearchWhenChatDisabled then
			v38 = v38 and v10
		end

		v36, v37 = useConversationSearchListProps(joined.filterText, v38, v21, v11, joined.navigateToConversation)
	else
		v36 = false
		v37 = {}
	end

	if FFlagAppChatSearchSessionTelemetry then
		local v38

		if joined.isShowingFilterBox == true and joined.filterText ~= nil then
			v38 = joined.filterText:match("%S") ~= nil
		else
			v38 = false
		end

		if FFlagAppChatServerSideConversationSearch and FFlagAppChatSkipSearchWhenChatDisabled then
			v38 = v38 and v10
		end

		useChatSearchSession(v38, FFlagAppChatServerSideConversationSearch)
	end

	if shouldReadConversationListFromSignalsStore then
		useEffect(function()
			if #v30 == 0 and #v31 == 0 then
				return
			end

			local v38 = getConversationIds(v30)
			local v39 = getConversationIds(v31)
			local v40

			if #v38 == #v39 then
				local flag = true

				for k, v41 in v38 do
					if v41 ~= v39[k] then
						v40 = false
						flag = false
						break
					end
				end

				if flag then
					v40 = true
				end
			else
				v40 = false
			end

			if not v40 then
				local success, result = pcall(function()
					return HttpService:JSONEncode(v38)
				end)
				local success2, result2 = pcall(function()
					return HttpService:JSONEncode(v39)
				end)

				v5:warning(
					"Conversation list parity mismatch. Rodux ids: {}, Signals ids: {}",
					not success and "[]" or result,
					not success2 and "[]" or result2
				)
			end
		end, { v30, v31 })
	end

	local v38 = usePrevious(v10)
	useEffect(function()
		v5:debug("Comparing previousIsChatEnabled ({}) --> isChatEnabled ({})", v38, v10)

		if v38 ~= nil and v38 ~= v10 and v10 then
			v5:info("Chat has become enabled, fetching conversations")
			v9(fetchConversationsByPage())
		end
	end, { v9, v10, v38 })

	local function fn()
		local count = 0
		local count2 = 0
		local result = {}

		for k, joined2 in v33 do
			if shouldReadConversationListFromSignalsStore and joined2.otherParticipants == nil then
				joined2 = Cryo.Dictionary.join(joined2, {
					otherParticipants = getOtherParticipants(joined2, v21)
				})
			end

			if useIsUserPending(joined2) then
				count += 1
			end

			if joined2.moderationType == ConversationChannels.ModerationType.TrustedComms then
				count2 += 1
			end

			local v39 = getConversationTitle(joined2)

			if v11 or joined2.conversationType ~= "MultiUserConversation" then
				table.insert(result, Cryo.Dictionary.join(joined2, { title = v39 }))
			end
		end

		return result, count, count2
	end

	local v41, v42, v43 = React.useMemo(fn, {
		v33,
		v11,
		if shouldReadConversationListFromSignalsStore then v21 else nil
	})

	local v44 = useTelemetry(ChatLandingTelemetryLayer.Context)
	local v45 = v44.emit

	if shouldReadConversationListFromSignalsStore then
		local ref = React.useRef(v44.emit)
		ref.current = v44.emit
		v45 = function(...)
			ref.current(...)
		end
	end

	local v46 = ChatLandingTelemetryState.useSetState()

	useEffect(function()
		v46(function(p3)
			return Cryo.Dictionary.join(p3, {
				chatLandingListCount = #v41,
				pendingConversationCount = v42,
				unfilteredConversationCount = v43
			})
		end)
	end, {
		#v41,
		v42,
		v43,
		v46
	})

	useEffectOnMount(function()
		v44.emit(ChatLandingTelemetryEvents.ScreenRendered, { isChatEnabled = v10 })
	end)

	local v47 = useLocalization({
		chatUnavailableWithUser = "Feature.Chat.Message.ChatUnavailableWithUser",
		networkErrorText = "Feature.Toast.NetworkingError.SomethingIsWrong",
		conversationLoadError = FFlagAppChatConversationLoadRetry and "CommonUI.Messages.Response.PageError" or nil,
		refresh = FFlagAppChatConversationLoadRetry and "CommonUI.Controls.Action.Refresh" or nil
	})

	local v48 = useCallback(function()
		if partyPageCarouselExperimentation.getPartyPageCarouselEnabled() then
			local guid = HttpService:GenerateGUID(false)

			v7.fireAnalyticsEvent(EventNames.ChatLandingPartyQuickStartButtonClicked, {
				clickLocation = v8.chatPlacement,
				partyAttemptId = guid,
				placeId = placeId,
				universeId = gameId
			})

			v22.navigate(EnumScreens.QuickStartSquadInviteFriends, { uuid = guid })
		end
	end, { v7, v8, v22, placeId, gameId })

	local v49 = useCallback(function(p3)
		if partyPageCarouselExperimentation.getPartyPageCarouselEnabled() then
			v9(createConversation("one_to_one", { p3 }, v26, "navigateToConversationFromSocialCarousel")):andThen(function(p4)
				if FFlagAppChatPerfTracking then
					AppChatPerfTracker.start(AppChatPerfTracker.Events.ChatConversationTTI, {
						conversationId = p4.id
					})
				end

				v22.navigate(EnumScreens.ChatConversation, { conversationId = p4.id })
			end):catch(function(p4)
				local v50 = if parseCreateConversationErrors(p4) == "participant_chat_disabled" then v47.chatUnavailableWithUser else v47.networkErrorText

				v22.navigate(EnumScreens.RoactChatToast, {
					toastProps = {
						toastContent = { toastTitle = v50 }
					}
				})

				if v26 then
					v26.fireAnalyticsEvent(EventNames.NewConversationCreated, {
						createConversationResult = CreateConversationError.FetchConversationError
					})
				end
			end)
		end
	end, { v9, v47, parseCreateConversationErrors, v22, v26 })

	local empty = Cryo.isEmpty(v41)
	local v50 = useChatSettingsRetrievalStatus() ~= "Done" or empty and v18 or empty and v19

	local v51 = false
	local v52 = false
	local v53 = false
	local v54 = useIsExternalNavigationAvailable({ EnumScreens.AddFriends, EnumScreens.PrivacySettings, EnumScreens.Groups })

	local v55 = fFlagAppIaScrollAway and not v15 and AppNavBar.getScrollAwayEnabled()

	local v56 = useCanAccessParty()
	local v57 = squadQuickStartExperimentation.getPartyQuickStartChangesEnabled() and v56

	local v58 = v50

	if FFlagAppChatConversationLoadRetry and v10 and not v36 and empty then
		v58 = v58 or v34
	end

	local v59

	if v58 then
		local createElement = React.createElement
		local v61 = {
			topBarHeight = joined.topBarHeight,
			pageHeaderText = joined.pageHeaderText,
			cellHeight = v28,
			cellWidth = 375,
			topPadding = 0,
			pageBackgroundTransparency = 0
		}

		local v62 = if fFlagAppIaScrollAway and v55 then joined.topBarHeight else nil
		v61.topPadding = v62
		v61.pageBackgroundTransparency = v23 and 1 or nil
		v59 = createElement(ChatLoadingContainer, v61)
		v51 = true
	elseif FFlagAppChatConversationLoadRetry and v10 and not v36 and empty and v17 and not v18 and v35 then
		v59 = React.createElement(Foundation.Empty, {
			text = v47.conversationLoadError,
			button = { text = v47.refresh, onActivated = joined.onRetryConversations }
		})
		v51 = true
	elseif v10 and (v36 or not empty or not v17 or v18) then
		local formatted = `conversationListWithTopBar{joined.filterText}`

		v51 = true
		v52 = true
		v53 = true

		local createElement = React.createElement

		local join = Cryo.Dictionary.join
		local v62 = if joined.isShowingFilterBox then joined.filterText or nil else nil
		local v61 = {
			filterText = v62,
			key = formatted,
			itemList = v41,
			appLoaded = v17,
			localUserId = v21,
			conversationsIsFetching = v18,
			oldestConversationIsFetched = v20,
			entryHeight = v28,
			isInExperience = v15,
			isWideMode = 0,
			navigateToConversationFromUserId = 0,
			navigateToQuickStartSquadInviteFriends = 0,
			showGroupsLink = 0,
			canvasTopPadding = 0,
			pageBackgroundTransparency = 0,
			canAccessParty = 0,
			isPartyQuickStartEnabled = 0
		}

		if not (partyPageCarouselExperimentation.getPartyPageCarouselEnabled() or SignalsMigrationConfig.shouldUseFoundationConversationRow) then
			v16 = nil
		end

		v61.isWideMode = v16

		if not partyPageCarouselExperimentation.getPartyPageCarouselEnabled() then
			v49 = nil
		end

		v61.navigateToConversationFromUserId = v49

		if not partyPageCarouselExperimentation.getPartyPageCarouselEnabled() then
			v48 = nil
		end

		v61.navigateToQuickStartSquadInviteFriends = v48

		v61.showGroupsLink = v54[EnumScreens.Groups]
		local v63 = if fFlagAppIaScrollAway and v55 then joined.topBarHeight else nil
		v61.canvasTopPadding = v63
		v61.pageBackgroundTransparency = v23 and 1 or nil
		v61.canAccessParty = v56
		v61.isPartyQuickStartEnabled = v57
		v59 = createElement(ConversationListWithTopBar, join(joined, v61, v37))
	elseif v10 then
		v59 = React.createElement("Frame", {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundColor3 = v24.Theme.BackgroundDefault.Color,
			BackgroundTransparency = v23 and 1 or v24.Tokens.Color.None.Transparency,
			BorderSizePixel = 0
		}, {
			NoFriendsView = React.createElement(noFriendsView, {
				pageRenderReport = function()
					v44.emit(ChatLandingTelemetryEvents.ChatEmptyStateScreenRendered, {
						emptyStateType = EmptyStateType.NoFriendsView
					})
				end,
				openAddFriendsPage = function()
					v44.emit(ChatLandingTelemetryEvents.ChatAddFriendsBtnClicked, {})

					if fFlagCreateConnectionsHub then
						v29[appPage.CoHubAddConnections]()
					else
						joined.navigateToAddFriends()
					end
				end,
				noFriendsHeaderKey = "Feature.Chat.Label.AddFriends",
				noFriendsTextLabelKey = "Feature.Chat.Text.NoFriends",
				addFriendsBtnLabelKey = "Feature.Chat.Label.AddFriends",
				addFriendsBtnEnabled = v54[EnumScreens.AddFriends]
			})
		})
		v51 = true
	else
		v59 = React.createElement(NoConversationsLanding, {
			chatEnabled = v10,
			privacySettingsEnabled = v12,
			globalRulesEnabled = v13,
			thirdPartyPrivacySettingsEnabled = v14,
			canNavigateToPrivacySettings = v54[EnumScreens.PrivacySettings],
			canNavigateToAddFriends = v54[EnumScreens.AddFriends],
			onCallToAction = function(p3)
				if p3 == "privacy" then
					joined.navigateToPrivacy()
				elseif p3 == "friends" then
					v44.emit(ChatLandingTelemetryEvents.ChatAddFriendsBtnClicked, {})

					if fFlagCreateConnectionsHub then
						v29[appPage.CoHubAddConnections]()
					else
						joined.navigateToAddFriends()
					end
				end
			end,
			fireRenderEvent = function(p3)
				local v60

				if p3 == "friends" then
					v60 = EmptyStateType.NoFriendsView
				elseif p3 == "privacy" then
					v60 = EmptyStateType.ChatSettingsDisabledView
				elseif p3 == "regional" then
					v60 = EmptyStateType.ChatUnavailableRegionView
				else
					v60 = EmptyStateType.EmptyConversationList
				end

				v44.emit(ChatLandingTelemetryEvents.ChatEmptyStateScreenRendered, { emptyStateType = v60 })
			end
		})
	end

	if fFlagAppIaScrollAway and fFlagEnableScrollAwayContentScrollableFix then
		useEffect(function()
			if not v55 then
				return
			end

			visibilityControl.setContentScrollable(v53)
		end, { v53, v55 })
	end

	local v60 = getFFlagChatTabHideGroupsLinkOnVR() and isVRAppBuild() and true or v51

	useEffect(function()
		if v15 then
			GetTopBarStore(false).setScreenTopBar(EnumScreens.ChatLanding, {
				rightHidden = not v52
			})
		end
	end, { v52, v15 })

	if not v60 and v54[EnumScreens.Groups] then
		local createElement = React.createElement
		local fragment = React.Fragment

		local v62 = if fFlagAppIaScrollAway and v55 then React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, joined.topBarHeight)
		}) else nil
		v59 = createElement(fragment, nil, {
			UIPadding = v62,
			groupsLink = React.createElement(ConversationGroupsEntryContainer, { entryHeight = v28 }),
			chatFrame = React.createElement("Frame", {
				Size = UDim2.new(1, 0, 1, -v28),
				Position = UDim2.new(0, 0, 0, v28),
				BackgroundTransparency = 1,
				BorderSizePixel = 0
			}, { chatContainer = v59 })
		})
	end

	local v61 = useChatIsVisible()

	React.useEffect(function()
		if v61 then
			local appChatVisible = ChatLandingTelemetryEvents.AppChatVisible
			local v63 = {
				isChatEnabled = v10,
				isChatLoading = v50,
				isInConversation = 0
			}

			local v64 = if FFlagAppChatVisibleIsInConversation then getIsInConversationForTelemetry(v22) else nil
			v63.isInConversation = v64
			v45(appChatVisible, v63)
		end
	end, { v61, v10, v50 })

	if FFlagAppChatPerfTracking then
		React.useEffect(function()
			if not v61 then
				return
			end

			local v62 = not v58 and v10
			v5:debug(
				"TTI Ready Check (ChatLanding): isLoading={}, isChatEnabled={}, itemCount={}, ready={}",
				v58,
				v10,
				#v41,
				v62
			)

			if v62 and AppChatPerfTracker.isActive(AppChatPerfTracker.Events.ChatLandingTTI) then
				AppChatPerfTracker.finish(AppChatPerfTracker.Events.ChatLandingTTI, {
					numElementsRendered = #v41
				})
			end
		end, {
			v61,
			v58,
			v10,
			#v41
		})
	end

	local ref = React.useRef({ isChatEnabled = v10, isChatLoading = v50 })

	React.useEffect(function()
		ref.current = { isChatEnabled = v10, isChatLoading = v50 }
	end, { v10, v50 })

	useEffect(function()
		return function()
			if v61 then
				v45(ChatLandingTelemetryEvents.AppChatClosed, ref.current)
			end
		end
	end, { v61 })

	if not fFlagSignalsNavP3hMisc then
		return v59
	end

	local ref2 = React.useRef(nil)

	if v61 or ref2.current == nil then
		ref2.current = v59
	end

	return ref2.current
end

local function paginatorParameters()
	return { pageSize = 30 }
end

local v7 = compose(RoactRodux.connect(nil, mapDispatchToProps), roactPaginator.connect(paginatorParameters))(LUAUFORGE_MODULE_GLOBALS_hgk_ChatLandingContainer)

local function PaginatorPropsBridge(p2): nil
	local v8 = p2[roactPaginator.loadNext]
	local v9 = p2[roactPaginator.loadPrevious]
	local onPaginatorReady = p2.onPaginatorReady
	React.useLayoutEffect(function()
		onPaginatorReady({
			[roactPaginator.loadNext] = v8,
			[roactPaginator.loadPrevious] = v9
		})
	end, { v8, v9, onPaginatorReady })
	return nil
end

local v8 = compose(RoactRodux.connect(nil, mapDispatchToProps), roactPaginator.connect(paginatorParameters))(PaginatorPropsBridge)

local v9 = RoactRodux.connect(nil, mapDispatchToProps)(LUAUFORGE_MODULE_GLOBALS_hgk_ChatLandingContainer)

local function ChatLandingContainerWithRetry(p2)
	local state, setState = React.useState(0)
	local ref = React.useRef({})
	local v10 = useCallback(function()
		setState(function(p3)
			return p3 + 1
		end)
	end, {})
	local v11 = useCallback(function(current)
		ref.current = current
	end, {})
	local v12 = useCallback(function(...)
		local v13 = ref.current[roactPaginator.loadNext]

		if v13 then
			return v13(...)
		end

		return nil
	end, {})
	local v13 = useCallback(function(...)
		local v14 = ref.current[roactPaginator.loadPrevious]

		if v14 then
			return v14(...)
		end

		return nil
	end, {})

	return React.createElement(React.Fragment, nil, {
		Paginator = React.createElement(v8, { key = state, onPaginatorReady = v11 }),
		Landing = React.createElement(
			v9,
			Cryo.Dictionary.join(p2, {
				[roactPaginator.loadNext] = v12,
				[roactPaginator.loadPrevious] = v13,
				onRetryConversations = v10
			})
		)
	})
end

if FFlagAppChatConversationLoadRetry then
	return ChatLandingContainerWithRetry
end

return v7
