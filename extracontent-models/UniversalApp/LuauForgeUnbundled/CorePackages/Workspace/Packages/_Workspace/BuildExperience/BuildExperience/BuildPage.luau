local FFlagBuildExperienceModelPicker = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceModelPicker")
local prepareBuildModelSelectionTarget = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/prepareBuildModelSelectionTarget")
local GetBuildModelSelectionStore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Stores/GetBuildModelSelectionStore")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local Navigation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Navigation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local RoactNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/RoactNavigation")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SharedFlags")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Localization").Hooks.useLocalization
local LocalizationStrings = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/LocalizationStrings")

local fullscreenPageWithSafeArea = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/AppBlox").FullscreenPageWithSafeArea
local loading = Foundation.Loading
local overlayProvider = Foundation.OverlayProvider
local view = Foundation.View
local CreatorAgentChat = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/CreatorAgentChat")
local useNavigationFocus = Navigation.useNavigationFocus

local iconName = Foundation.Enums.IconName
local iconSize = Foundation.Enums.IconSize
local button = Foundation.Button
local buttonVariant = Foundation.Enums.ButtonVariant
local fillBehavior = Foundation.Enums.FillBehavior
local inputSize = Foundation.Enums.InputSize
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SignalsReact")
local localUserIdStore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/LocalUserIdStore").LocalUserIdStore
local BuildPageHeader = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/BuildPageHeader/BuildPageHeader")
local BuildChatPage = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/BuildChatPage/BuildChatPage")
local ChatSheet = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/ChatSheet/ChatSheet")
local fFlagBuildExperienceLibrary = SharedFlags.FFlagBuildExperienceLibrary
local openLibrary = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/utils/openLibrary")
local SearchPageContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/SearchPage/SearchPageContainer")
local SearchEmptyState = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/SearchEmptyState/SearchEmptyState")
local SubagentStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/SubagentStatus")
local MyCreationsTab = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/MyCreationsTab/MyCreationsTab")
local ExperienceResultsList = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/MyCreationsTab/ExperienceResultsList")

local ExperienceResultsLoadingSkeleton = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/MyCreationsTab/ExperienceResultsLoadingSkeleton")
local useMyCreationsResults = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/MyCreationsTab/useMyCreationsResults")
local BuildOverflowMenuScreens = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/BuildPillMenu/BuildOverflowMenuScreens")
local FFlagBuildExperienceMonetizationNativeUI = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceMonetizationNativeUI")
local OverflowMenuPageShell = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/BuildPillMenu/OverflowMenuPageShell")
local PrivateInvitesPickerHost = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/PrivateInvitesPicker/PrivateInvitesPickerHost")
local CreatorCreditPageContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/CreatorCreditSheet/CreatorCreditPageContainer")

local CreatorCreditBalanceChipContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/CreatorCreditSheet/CreatorCreditBalanceChip/CreatorCreditBalanceChipContainer")
local AdsStatsView = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Ads/AdsStatsView")
local useAdsStatsPageViewModel = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Ads/useAdsStatsPageViewModel")
local AdsManagerMenuButton = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Ads/AdsManagerMenuButton")
local AdCampaignCreatedToast = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Ads/AdCampaignCreatedToast")

require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/chatTypes")
local useSessionSummary = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/useSessionSummary")
local useScrollPerformanceTracker = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Telemetry/useScrollPerformanceTracker")

local v5 = { 0.5, 1 }
local FFlagBuildAdUpsell = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildAdUpsell")
local FFlagEnableBuildAdPromotion = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagEnableBuildAdPromotion")

require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Stores/GetBuildOverflowMenuStore/createBuildOverflowMenuStore")
local GetBuildExperienceRefreshStore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Stores/GetBuildExperienceRefreshStore")
local GetSearchQueryStore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Stores/GetSearchQueryStore")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Stores/GetSearchQueryStore/createSearchQueryStore")
local BuildNavigationParams = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/utils/BuildNavigationParams")
local resumeBuildChat = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/utils/resumeBuildChat")
local useBuildPageLayout = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/utils/useBuildPageLayout")
local useManageBuildNavBarVisibility = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/utils/useManageBuildNavBarVisibility")
local useOnScreenKeyboardVisible = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/utils/useOnScreenKeyboardVisible")
local FFlagBuildPublishNavigationSheet = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildPublishNavigationSheet")
local FFlagBuildExperiencePrivateInvites = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperiencePrivateInvites")
local FFlagBuildExperienceEventContextTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceEventContextTelemetry")

local FFlagBuildExperienceMyCreationsLongPressMenu = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceMyCreationsLongPressMenu")
local FFlagBuildExperiencePreviewsTab = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperiencePreviewsTab")
local FFlagAppThemeHalloween2026BuildBackground = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagAppThemeHalloween2026BuildBackground")
local useThemeBackground = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/ThemeBackground").useThemeBackground
local FFlagBuildWithGroups = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildWithGroups")

local v6 = if FFlagBuildExperiencePreviewsTab then require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/BuildHomeTabs/BuildHomeTabsContainer") else nil

local fFlagEnableBuildTabOverride = SharedFlags.FFlagEnableBuildTabOverride
local FFlagBuildExperienceHomeTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceHomeTelemetry")
local fFlagBuildExperienceAnalytics = SharedFlags.FFlagBuildExperienceAnalytics
local fFlagBuildExperienceHideNavBarOnSubPages = SharedFlags.FFlagBuildExperienceHideNavBarOnSubPages
local FFlagBuildExperienceChatOpenTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceChatOpenTelemetry")
local FFlagBuildExperienceChatOpenId = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceChatOpenId")
local FFlagBuildExperiencePageImpressions = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperiencePageImpressions")
local useBuildPageImpression = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Telemetry/useBuildPageImpression")
local GetAdsCampaignDeepLinkStore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Stores/GetAdsCampaignDeepLinkStore")
local sendBuildExperienceEvent = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Telemetry/sendBuildExperienceEvent")
local v7 = FFlagBuildAdUpsell or FFlagBuildExperienceMonetizationNativeUI
local v8 = not fFlagEnableBuildTabOverride
local BuildEligibilityDialog = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/BuildEligibilityDialog")
local useBuildPageEligibility = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/useBuildPageEligibility")

local v9 = if FFlagBuildPublishNavigationSheet then require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/PublishSheet/PublishSheetController") else nil

local useTTINavigationTracking = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/TTINavigationTracking").useTTINavigationTracking

local v10 = {
	BuildHome = "BuildHome",
	BuildChat = BuildNavigationParams.BUILD_CHAT_SCREEN,
	BuildSearch = "BuildSearch",
	BuildAgents = "BuildAgents",
	BuildAgentDetails = "BuildAgentDetails",
	BuildCreatorCredit = "BuildCreatorCredit",
	BuildGetUsers = "BuildGetUsers"
}

local function shouldShowSearchEmptyState(p2, p3)
	return p2 == "" or (p2 ~= p3.query or p3.isSettledNoResults)
end

local function findGroup(p2, p3)
	if p2 == nil or p3 == nil then
		return nil
	end

	for k, group in p2.groups do
		if group.name == p3 then
			return group
		end
	end

	return nil
end

local function useLiveSubagentTaskState(navigation)
	local target = BuildNavigationParams.getTarget(navigation)
	assert(target ~= nil, "Agent pages require a build target")
	local creatorAgentChatStore = CreatorAgentChat.getCreatorAgentChatStore()

	local v11 = if FFlagBuildExperienceModelPicker then SignalsReact.useSignalState(localUserIdStore.getCurrentUserId) else nil

	return useSessionSummary((React.useMemo(function()
		return creatorAgentChatStore.getSessionForProject(
			target.universeId,
			target.placeId,
			target.sessionId
		)
	end, {
		creatorAgentChatStore,
		target.universeId,
		target.placeId,
		target.sessionId,
		v11
	}))).subagentTaskState or BuildNavigationParams.getSubagentTaskState(navigation)
end

local function useOpenBuildChat(navigation, p2)
	local function fn(state, p3)
		if FFlagBuildExperienceModelPicker then
			state = prepareBuildModelSelectionTarget(state)
		end

		if FFlagBuildExperienceChatOpenId then
			state = table.clone(state)
			local HttpService = game:GetService("HttpService")
			state.chatOpenId = HttpService:GenerateGUID(false)
		end

		if FFlagBuildExperienceChatOpenTelemetry then
			local v13 = {
				universeId = state.universeId,
				placeId = state.placeId,
				conversationId = 0,
				chatOpenId = 0
			}
			local v14 = if FFlagBuildExperienceEventContextTelemetry then state.sessionId else nil
			v13.conversationId = v14
			v13.chatOpenId = state.chatOpenId
			local v15 = {
				isNewGame = tostring(state.isNewGameTarget == true),
				context = 0
			}
			local v16 = if FFlagBuildExperienceEventContextTelemetry then p3 or p2 else nil
			v15.context = v16
			sendBuildExperienceEvent("CHAT_OPEN", v13, v15)
		end

		navigation.navigate(v10.BuildChat, { target = state })
	end

	return React.useCallback(fn, { navigation, if FFlagBuildExperienceEventContextTelemetry then p2 else nil })
end

local function useHomeConfigurationPages(navigation)
	local state, setState = React.useState(nil)
	local state2, setState2 = React.useState(false)
	local v11 = React.useCallback(function()
		setState2(false)
	end, {})
	local v12 = React.useCallback(function(p2, p3)
		navigation.navigate(p2, { target = p3 })
	end, { navigation })
	return {
		onOpenConfigurationPage = React.useCallback(function(p2, p3)
			if FFlagBuildPublishNavigationSheet and p2 == "publish" then
				setState(p3)
				setState2(true)
			else
				local v13 = BuildOverflowMenuScreens.SCREEN_BY_PAGE[p2]

				if v13 == nil then
					return
				end

				navigation.navigate(v13, { target = p3 })
			end
		end, { navigation }),
		publishSheetTarget = state,
		isPublishSheetOpen = state2,
		onClosePublishSheet = v11,
		navigateToPublishSubPage = v12
	}
end

local function BuildMonetizationScreen(p2)
	local navigation = p2.navigation
	local target = BuildNavigationParams.getTarget(navigation)
	local state, setState = React.useState(false)
	local v11 = target ~= nil
	local v12 = React.useCallback(function()
		if v11 then
			setState(true)
		end
	end, { v11 })
	local v13 = React.useCallback(function()
		setState(false)
	end, {})

	React.useEffect(function()
		if not state then
			return
		end

		local v14 = navigation.addListener(RoactNavigation.Events.WillBlur, v13)
		return function()
			v14.remove()
		end
	end, { state, navigation, v13 })

	local createElement = React.createElement
	local fragment = React.Fragment
	local v15 = {
		Page = React.createElement(BuildOverflowMenuScreens.BuildMonetizationScreen, {
			navigation = navigation,
			onComposerActivated = v12
		}),
		Chat = 0
	}

	local v16 = if state and target ~= nil then React.createElement(ChatSheet, {
		autoFocusComposer = true,
		defaultSnapPointIndex = 1,
		isOpen = true,
		onClose = v13,
		placeId = target.placeId,
		sessionId = target.sessionId,
		snapPoints = v5,
		universeId = target.universeId
	}) else nil
	v15.Chat = v16
	return createElement(fragment, nil, v15)
end

local function BuildHomeScreen(p2)
	local screenProps = p2.screenProps or {}
	local navigation = p2.navigation
	local v11 = useBuildPageLayout()
	local v12 = useNavigationFocus()
	local tokens = v11.tokens
	local fallbackExperienceName = useLocalization({
		fallbackExperienceName = LocalizationStrings.BUILD_ASSISTANT_FALLBACK_NAME
	}).fallbackExperienceName

	local v13 = useOpenBuildChat(navigation, FFlagBuildExperienceEventContextTelemetry and "my_creations" or nil)

	local v14 = if FFlagBuildExperienceMyCreationsLongPressMenu then useHomeConfigurationPages(navigation) else nil

	local publishSheetTarget = if v14 ~= nil then v14.publishSheetTarget else nil

	local v15 = if FFlagAppThemeHalloween2026BuildBackground then useThemeBackground() ~= nil else false

	local useEffect = React.useEffect
	local function fn()
		if FFlagBuildAdUpsell then
			local v16 = GetAdsCampaignDeepLinkStore(false)

			if screenProps.resumeRequestId then
				local universeId = if screenProps.adsCampaignIntent then screenProps.universeId else nil

				if v16.begin(screenProps.resumeRequestId, universeId) and universeId ~= nil then
					sendBuildExperienceEvent("AD_CAMPAIGN_DEEP_LINK_RECEIVED", {
						universeId = screenProps.universeId
					}, {
						requestId = screenProps.resumeRequestId
					})
				end
			else
				local request = v16.getRequest(false)

				if request ~= nil then
					v16.finish(request.id)
				end
			end
		end

		local v17 = {
			universeId = screenProps.universeId,
			sessionId = screenProps.sessionId,
			creatorAgentChatStore = screenProps.creatorAgentChatStore,
			configurationStore = screenProps.configurationStore,
			fallbackExperienceName = fallbackExperienceName,
			onOpenChat = 0
		}
		local v18

		if FFlagBuildExperienceEventContextTelemetry then
			v18 = function(p3)
				v13(p3, "deep_link")
			end
		else
			v18 = v13
		end

		v17.onOpenChat = v18
		return resumeBuildChat(v17)
	end

	local universeId = screenProps.universeId
	local sessionId = screenProps.sessionId
	local resumeRequestId = screenProps.resumeRequestId
	local v17 = if FFlagBuildAdUpsell then screenProps.adsCampaignIntent else nil
	useEffect(fn, {
		v13,
		universeId,
		sessionId,
		resumeRequestId,
		v17,
		screenProps.creatorAgentChatStore,
		screenProps.configurationStore,
		fallbackExperienceName
	})

	local searchQueryStore = screenProps.searchQueryStore or GetSearchQueryStore()

	local v18 = React.useCallback(function()
		local v19 = searchQueryStore

		if FFlagBuildExperienceHomeTelemetry then
			sendBuildExperienceEvent("SEARCH_OPEN", {}, { context = "home_header" })
		end

		v19.beginSearch()

		navigation.navigate(v10.BuildSearch, { searchQueryStore = v19 })
	end, { navigation, searchQueryStore })

	local createElement = React.createElement
	local v20 = {
		LayoutOrder = 3,
		creatorAgentChatStore = screenProps.creatorAgentChatStore,
		configurationStore = screenProps.configurationStore,
		searchStore = screenProps.searchStore,
		searchQueryStore = screenProps.searchQueryStore,
		isFocused = v12,
		autoOpenNewGame = screenProps.universeId == nil and screenProps.sessionId == nil,
		onOpenChat = v13,
		onOpenConfigurationPage = 0
	}

	local v22 = if v14 ~= nil then v14.onOpenConfigurationPage else nil
	v20.onOpenConfigurationPage = v22
	local v23 = createElement(MyCreationsTab, v20)

	local createElement2 = React.createElement
	local v25 = {
		BackgroundColor3 = tokens.Color.Surface.Surface_0.Color3,
		BackgroundTransparency = v15 and 1 or tokens.Color.Surface.Surface_0.Transparency,
		includeBottomBar = v11.shouldIncludeBottomBar,
		includeStatusBar = true
	}

	local createElement3 = React.createElement

	local v29 = {
		Header = React.createElement(BuildPageHeader, {
			LayoutOrder = 1,
			height = v11.topBarHeight,
			searchQueryStore = searchQueryStore,
			onOpenSearch = v18
		}),
		Content = 0
	}

	local createElement4 = React.createElement

	if FFlagBuildExperiencePreviewsTab then
		v23 = React.createElement(v6, {
			LayoutOrder = 3,
			gamesContent = v23,
			isFocused = v12,
			searchStore = screenProps.searchStore,
			searchQueryStore = searchQueryStore
		})
	end

	v29.Content = createElement4(
		view,
		{
			LayoutOrder = 2,
			ZIndex = 4,
			tag = "col align-x-center fill gap-small size-full-0"
		},
		{ SearchBarContainer = nil, MyCreations = v23 }
	)
	local v26 = {
		Page = createElement3(view, {
			tag = FFlagAppThemeHalloween2026BuildBackground and {
				["col align-x-center size-full"] = true,
				["bg-surface-0"] = not v15
			} or "col align-x-center size-full bg-surface-0"
		}, v29),
		PublishSheet = 0
	}

	local v33 = if FFlagBuildPublishNavigationSheet and v14 ~= nil and publishSheetTarget ~= nil and publishSheetTarget.universeId ~= nil then React.createElement(v9, {
		isOpen = v14.isPublishSheetOpen,
		target = publishSheetTarget,
		onClose = v14.onClosePublishSheet,
		navigateToSubPage = v14.navigateToPublishSubPage
	}) else nil
	v26.PublishSheet = v33
	return createElement2(fullscreenPageWithSafeArea, v25, v26)
end

local function BuildSearchResults(props)
	local v11 = props.searchQueryStore.useDraftQuery()
	local current = props.closingSnapshot.current
	local results = if current == nil then props.results else current.results
	local v12

	if current == nil then
		v12 = v11 == "" or v11 ~= results.query or results.isSettledNoResults
	else
		v12 = current.showEmptyState
	end

	if v12 then
		return React.createElement(SearchEmptyState, { testId = "SearchPage.EmptyState" })
	end

	return React.createElement(ExperienceResultsList, {
		items = results.items,
		hasDisplayedItems = #results.displayedItems > 0,
		hasDisplayedResult = results.hasDisplayedResult,
		hasPendingSummary = results.hasPendingSummary,
		listStatus = results.listStatus,
		failedLoadMore = results.failedLoadMore,
		retryLoadMore = results.retryLoadMore,
		loadError = results.loadError,
		onOpenChat = props.onOpenChat,
		testIdPrefix = "SearchPage"
	})
end

local function BuildSearchScreen(p2)
	local screenProps = p2.screenProps or {}
	local navigation = p2.navigation
	local v11 = useBuildPageLayout()
	local v12 = useNavigationFocus()
	local v13 = useOnScreenKeyboardVisible()
	local v14 = navigation.getParam("searchQueryStore") or screenProps.searchQueryStore or GetSearchQueryStore()
	local v15 = SignalsReact.useSignalBinding(v14.getDraftQuery)
	local v16 = useLocalization({
		searchbarPlaceholder = "Feature.Build.Label.SearchGames"
	})

	local v17 = useOpenBuildChat(navigation, FFlagBuildExperienceEventContextTelemetry and "search_results" or nil)
	local v18 = useMyCreationsResults({
		creatorAgentChatStore = screenProps.creatorAgentChatStore,
		configurationStore = screenProps.configurationStore,
		searchStore = screenProps.searchStore,
		searchQueryStore = v14,
		isFocused = v12
	})

	local ref = React.useRef(nil)
	local current = ref.current
	local mapped = v15:map(function(p3)
		local current2 = ref.current

		if current2 == nil then
			return p3
		end

		return current2.query
	end)

	local v19 = if current == nil then v18 else current.results
	local ref2 = React.useRef(nil)
	useScrollPerformanceTracker("LuaApp_Build_Search_Scroll", ref2)
	local v20 = React.useCallback(function()
		if v19.isLoadingMore then
			return React.createElement(ExperienceResultsLoadingSkeleton, {
				LayoutOrder = 1,
				index = 1,
				testIdPrefix = "SearchPage"
			})
		end

		return nil
	end, { v19.isLoadingMore })
	local v21 = React.useCallback(function()
		local draftQuery = v14.getDraftQuery()
		local v22 = ref
		local v23 = { query = draftQuery, results = v18, showEmptyState = 0 }

		local v24 = v18
		v23.showEmptyState = draftQuery == "" or draftQuery ~= v24.query or v24.isSettledNoResults
		v22.current = v23

		v14.endSearch()
		navigation.goBack()
	end, { ref, navigation, v18, v14 })

	React.useEffect(function()
		v14.beginSearch()
		return v14.endSearch
	end, { v14 })

	return React.createElement(fullscreenPageWithSafeArea, {
		BackgroundColor3 = v11.tokens.Color.Surface.Surface_0.Color3,
		BackgroundTransparency = v11.tokens.Color.Surface.Surface_0.Transparency,
		includeBottomBar = v11.shouldIncludeBottomBar and not v13,
		includeStatusBar = true
	}, {
		Page = React.createElement(SearchPageContainer, {
			ref = ref2,
			createFooter = v20,
			onBack = v21,
			onCanvasPositionChangedCallback = v19.loadMoreIfNeeded,
			onCanvasSizeChangedCallback = v19.loadMoreIfNeeded,
			refresh = v19.refresh,
			searchBarProps = {
				clear = v14.clear,
				onFocusGained = v14.beginSearch,
				placeholder = v16.searchbarPlaceholder,
				query = mapped,
				setQuery = v14.setQuery,
				shouldFocus = v12
			},
			showEmptyState = false
		}, {
			ExperienceResults = React.createElement(BuildSearchResults, {
				closingSnapshot = ref,
				onOpenChat = v17,
				results = v18,
				searchQueryStore = v14
			})
		})
	})
end

local function BuildChatScreen(p2)
	local navigation = p2.navigation
	local target = BuildNavigationParams.getTarget(navigation)

	local v11 = if fFlagBuildExperienceAnalytics then BuildNavigationParams.getInitialPrompt(navigation) else nil

	local v12 = GetBuildExperienceRefreshStore()
	local v13 = useBuildPageLayout()

	local v14 = not v7 or useNavigationFocus()
	local v15 = useOnScreenKeyboardVisible()
	local state, setState = React.useState(false)
	local state2, setState2 = React.useState(false)

	if FFlagBuildExperienceModelPicker then
		local v16 = SignalsReact.useSignalState(localUserIdStore.getCurrentUserId)

		React.useLayoutEffect(function()
			if target ~= nil and (tonumber(v16) or 0) > 0 then
				local v17 = prepareBuildModelSelectionTarget(target)

				if v17 ~= target then
					navigation.setParams({ target = v17 })
				end
			end
		end, { v16, target, navigation })
		local modelSelectionDraftId = if target ~= nil then target.modelSelectionDraftId else nil
		React.useEffect(function()
			return function()
				if modelSelectionDraftId ~= nil then
					GetBuildModelSelectionStore(false).discardDraft(modelSelectionDraftId)
				end
			end
		end, { modelSelectionDraftId })
	end

	local v16 = React.useCallback(function()
		if FFlagBuildWithGroups and target ~= nil and target.isNewGameTarget == true and target.universeId ~= nil then
			require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Stores/GetMyCreationsFilterStore")().setFilter({ games = "MyGames" })

			if FFlagBuildExperiencePreviewsTab then
				require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Stores/GetBuildHomeTabStore")().setTab("Games")
			end
		end

		navigation.goBack()
	end, { navigation, target })

	local v17 = React.useCallback(function()
		setState2(false)
	end, {})

	local v18 = React.useCallback(function(p3)
		if FFlagBuildPublishNavigationSheet and p3 == "publish" then
			setState2(true)
			return
		end

		local v19 = BuildOverflowMenuScreens.SCREEN_BY_PAGE[p3]

		if v19 == nil then
			return
		end

		navigation.navigate(v19, { target = target })
	end, { navigation, target })

	local v19 = React.useCallback(function()
		setState(true)
	end, {})
	local v20 = React.useCallback(function()
		setState(false)
	end, {})

	local v21 = React.useCallback(function()
		navigation.navigate(BuildOverflowMenuScreens.Screens.BuildPlaytestInviteManagement, {
			target = target
		})
	end, { navigation, target })
	local v22

	if fFlagBuildExperienceLibrary then
		v22 = React.useCallback(function(p3)
			local placeId = if target ~= nil then target.placeId else nil

			if placeId ~= nil then
				openLibrary(placeId, p3)
			end
		end, { target })
	end

	local v23 = React.useCallback(function()
		setState(false)

		if FFlagBuildExperiencePrivateInvites then
			v21()
		end
	end, { v21 })
	local v24 = React.useCallback(function()
		navigation.navigate(v10.BuildAgents, { target = target })
	end, { navigation, target })
	local v25 = React.useCallback(function()
		navigation.navigate(v10.BuildCreatorCredit, { target = target })
	end, { navigation, target })

	local v26 = React.useCallback(function(p3, p4)
		navigation.navigate(p3, { target = p4 })
	end, { navigation })
	local v27

	if FFlagEnableBuildAdPromotion then
		v27 = React.useCallback(function()
			navigation.navigate(v10.BuildGetUsers, { target = target })
		end, { navigation, target })
	end

	local v28 = React.useCallback(function(p3)
		navigation.setParams({ target = p3 })

		v12.bumpRefreshTick()
	end, { navigation, v12 })
	local v29

	if target ~= nil then
		local createElement = React.createElement
		local v31 = {
			target = target,
			onOpenLibrary = v22,
			initialPrompt = v11,
			onClose = v16,
			onOpenAgentsPage = v24,
			onOpenCreatorCreditPage = v25,
			onOpenGetUsersPage = v27,
			onOpenConfigurationPage = v18,
			onOpenInvitePicker = v19,
			onOpenInviteManagement = v21,
			onNavigateToResolvedTarget = v28,
			isFocused = nil
		}

		if not v7 then
			v14 = nil
		end

		v31.isFocused = v14
		v29 = createElement(BuildChatPage, v31)
	end

	local universeId = if target ~= nil then target.universeId else nil

	local createElement = React.createElement
	local fragment = React.Fragment
	local v31 = {
		Page = React.createElement(fullscreenPageWithSafeArea, {
			BackgroundColor3 = v13.tokens.Color.Surface.Surface_0.Color3,
			BackgroundTransparency = v13.tokens.Color.Surface.Surface_0.Transparency,
			includeBottomBar = v13.shouldIncludeBottomBar and not v15,
			includeStatusBar = true
		}, { Page = v29 }),
		Picker = 0,
		PublishSheet = 0
	}

	local v32 = if state and universeId ~= nil then React.createElement(PrivateInvitesPickerHost, {
		universeId = universeId,
		onClose = v20,
		onInvitesSent = v23
	}) else nil
	v31.Picker = v32

	local v33 = if FFlagBuildPublishNavigationSheet and target ~= nil and target.universeId ~= nil then React.createElement(v9, {
		isOpen = state2,
		target = target,
		onClose = v17,
		navigateToSubPage = v26
	}) else nil
	v31.PublishSheet = v33
	return createElement(fragment, nil, v31)
end

local function BuildAgentsScreen(p2)
	local navigation = p2.navigation
	local v11 = useBuildPageLayout()
	local v12 = useLiveSubagentTaskState(navigation)
	local agents = useLocalization({ agents = LocalizationStrings.SUBAGENT_STATUS_AGENTS }).agents

	local v13 = React.useCallback(function()
		navigation.goBack()
	end, { navigation })
	local v14 = React.useCallback(function(p3)
		navigation.navigate(v10.BuildAgentDetails, {
			target = BuildNavigationParams.getTarget(navigation),
			subagentTaskGroupName = p3.name
		})
	end, { navigation })

	local element = React.createElement(SubagentStatus.AgentsList, {
		groups = v12 == nil and {} or v12.groups,
		onAgentActivated = v14,
		testId = "BuildPage.AgentsList"
	})

	return React.createElement(
		fullscreenPageWithSafeArea,
		{
			BackgroundColor3 = v11.tokens.Color.Surface.Surface_0.Color3,
			BackgroundTransparency = v11.tokens.Color.Surface.Surface_0.Transparency,
			includeBottomBar = v11.shouldIncludeBottomBar,
			includeStatusBar = true
		},
		{
			Page = React.createElement(OverflowMenuPageShell, {
				title = agents,
				onClose = v13,
				content = element,
				scrollPerformanceIntervalName = "LuaApp_Build_Agents_Scroll",
				testId = "BuildPage.AgentsPage"
			})
		}
	)
end

local function BuildAgentDetailsScreen(p2)
	local navigation = p2.navigation
	local v11 = useBuildPageLayout()
	local v12 = useLiveSubagentTaskState(navigation)
	local subagentTaskGroupName = BuildNavigationParams.getSubagentTaskGroupName(navigation)
	local v13

	if not (v12 == nil or subagentTaskGroupName == nil) then
		for k, group in v12.groups do
			if group.name == subagentTaskGroupName then
				v13 = group
				break
			end
		end
	end

	local agents = useLocalization({ agents = LocalizationStrings.SUBAGENT_STATUS_AGENTS }).agents

	local v14 = React.useCallback(function()
		navigation.goBack()
	end, { navigation })
	local v15

	if v13 == nil then
		v15 = React.createElement(view, { tag = "size-full" })
	else
		v15 = React.createElement(SubagentStatus.AgentDetailsList, {
			group = v13,
			testId = "BuildPage.AgentDetailsList"
		})
	end

	return React.createElement(
		fullscreenPageWithSafeArea,
		{
			BackgroundColor3 = v11.tokens.Color.Surface.Surface_0.Color3,
			BackgroundTransparency = v11.tokens.Color.Surface.Surface_0.Transparency,
			includeBottomBar = v11.shouldIncludeBottomBar,
			includeStatusBar = true
		},
		{
			Page = React.createElement(OverflowMenuPageShell, {
				title = subagentTaskGroupName or agents,
				onClose = v14,
				content = v15,
				scrollPerformanceIntervalName = "LuaApp_Build_AgentDetails_Scroll",
				testId = "BuildPage.AgentDetailsPage"
			})
		}
	)
end

local function BuildCreatorCreditScreen(p2)
	local navigation = p2.navigation

	if FFlagBuildExperiencePageImpressions then
		useBuildPageImpression("creator-credit-ai-usage", BuildNavigationParams.getTarget(navigation))
	end

	local v11 = useBuildPageLayout()
	local pageTitle = useLocalization({ pageTitle = LocalizationStrings.CREATOR_CREDIT_PAGE_TITLE }).pageTitle

	local v12 = React.useCallback(function()
		navigation.goBack()
	end, { navigation })

	local element = React.createElement(CreatorCreditPageContainer, nil)

	return React.createElement(
		fullscreenPageWithSafeArea,
		{
			BackgroundColor3 = v11.tokens.Color.Surface.Surface_0.Color3,
			BackgroundTransparency = v11.tokens.Color.Surface.Surface_0.Transparency,
			includeBottomBar = v11.shouldIncludeBottomBar,
			includeStatusBar = true
		},
		{
			Page = React.createElement(OverflowMenuPageShell, {
				title = pageTitle,
				onClose = v12,
				content = element,
				headerTrailing = React.createElement(CreatorCreditBalanceChipContainer),
				scrollPerformanceIntervalName = "LuaApp_Build_CreatorCredit_Scroll",
				testId = "BuildPage.CreatorCreditPage"
			})
		}
	)
end

local function BuildGetUsersScreen(p2)
	local navigation = p2.navigation
	local v11 = useBuildPageLayout()
	local target = BuildNavigationParams.getTarget(navigation)
	local universeId = if target ~= nil then target.universeId else nil

	if FFlagBuildExperiencePageImpressions then
		useBuildPageImpression("get-users", target)
	end

	local pageTitle = useLocalization({ pageTitle = LocalizationStrings.ADS_STATS_PAGE_TITLE }).pageTitle

	local v12 = React.useCallback(function()
		navigation.goBack()
	end, { navigation })

	local v13 = useAdsStatsPageViewModel(universeId)
	local element = React.createElement(AdsStatsView, v13)
	local state, setState = React.useState(nil)

	local v14 = not (v13.isLoading or v13.isFailed or v13.hasCampaigns)
	local v15

	if not (v13.isLoading or v13.isFailed) then
		local createElement = React.createElement

		local v18 = {
			ToastAnchor = React.createElement(view, {
				LayoutOrder = 1,
				ref = setState,
				tag = "size-full-0",
				testId = "BuildPage.GetUsers.ToastAnchor"
			}),
			Actions = 0
		}

		local createElement2 = React.createElement

		local createElement3 = React.createElement
		local v23 = {
			text = v13.createButtonText,
			icon = 0,
			size = 0,
			variant = 0,
			fillBehavior = 0,
			width = 0,
			isLoading = 0,
			onActivated = 0,
			testId = "BuildPage.GetUsers.Create"
		}

		local v24 = if v13.createButtonIsExternal then iconName.ArrowUpRightFromSquare else nil
		v23.icon = v24
		v23.size = inputSize.Large
		v23.variant = buttonVariant.Emphasis
		v23.fillBehavior = fillBehavior.Fill
		v23.width = UDim.new(1, 0)
		v23.isLoading = v13.isPromotionCreatePending
		v23.onActivated = v13.onCreatePrimary
		v18.Actions = createElement2(
			view,
			{
				LayoutOrder = 2,
				tag = "row size-full-0 auto-y padding-y-medium",
				testId = "BuildPage.GetUsers.Actions"
			},
			{ Create = createElement3(button, v23) }
		)
		v15 = createElement(
			view,
			{ tag = "col size-full-0 auto-y", testId = "BuildPage.GetUsers.Footer" },
			v18
		)
	end

	local createElement = React.createElement
	local v17 = {
		BackgroundColor3 = v11.tokens.Color.Surface.Surface_0.Color3,
		BackgroundTransparency = v11.tokens.Color.Surface.Surface_0.Transparency,
		includeBottomBar = v11.shouldIncludeBottomBar,
		includeStatusBar = true
	}

	local v18 = {
		Page = React.createElement(OverflowMenuPageShell, {
			title = pageTitle,
			onClose = v12,
			content = element,
			footer = v15,
			disableScrolling = v14,
			headerTrailing = React.createElement(AdsManagerMenuButton, {
				universeId = universeId,
				testId = "BuildPage.GetUsersPage.AdsManagerMenu"
			}),
			scrollPerformanceIntervalName = "LuaApp_Build_GetUsers_Scroll",
			testId = "BuildPage.GetUsersPage"
		}),
		SuccessToast = 0
	}

	local v19 = if v13.showCreateSuccessToast and state ~= nil then React.createElement(overlayProvider, {
		gui = state
	}, {
		Toast = React.createElement(AdCampaignCreatedToast, {
			onClose = v13.onDismissCreateSuccessToast,
			testId = "BuildPage.GetUsers.SuccessToast",
			title = v13.createSuccessToastText
		})
	}) else nil
	v18.SuccessToast = v19
	return createElement(fullscreenPageWithSafeArea, v17, v18)
end

local v23 = {
	{
		[v10.BuildHome] = { screen = BuildHomeScreen }
	},
	{
		[v10.BuildChat] = { screen = BuildChatScreen }
	},
	{
		[BuildOverflowMenuScreens.Screens.BuildPublish] = { screen = BuildOverflowMenuScreens.BuildPublishScreen }
	},
	{
		[BuildOverflowMenuScreens.Screens.BuildSettings] = { screen = BuildOverflowMenuScreens.BuildSettingsScreen }
	},
	{
		[BuildOverflowMenuScreens.Screens.BuildAudience] = { screen = BuildOverflowMenuScreens.BuildAudienceScreen }
	},
	{
		[BuildOverflowMenuScreens.Screens.BuildPlaytestInviteManagement] = {
			screen = BuildOverflowMenuScreens.BuildPlaytestInviteManagementScreen
		}
	},
	{
		[BuildOverflowMenuScreens.Screens.BuildTitleDescription] = {
			screen = BuildOverflowMenuScreens.BuildTitleDescriptionScreen
		}
	},
	{
		[BuildOverflowMenuScreens.Screens.BuildVersionTitleDescription] = {
			screen = BuildOverflowMenuScreens.BuildVersionTitleDescriptionScreen
		}
	},
	{
		[BuildOverflowMenuScreens.Screens.BuildMediaSelection] = {
			screen = BuildOverflowMenuScreens.BuildMediaSelectionScreen
		}
	},
	{
		[v10.BuildAgents] = { screen = BuildAgentsScreen }
	},
	{
		[v10.BuildAgentDetails] = { screen = BuildAgentDetailsScreen }
	},
	{
		[v10.BuildCreatorCredit] = { screen = BuildCreatorCreditScreen }
	}
}

if FFlagBuildExperienceMonetizationNativeUI then
	local v24 = {
		[BuildOverflowMenuScreens.Screens.BuildMonetization] = { screen = BuildMonetizationScreen }
	}
	table.insert(v23, v24)
end

if fFlagBuildExperienceAnalytics then
	local v24 = {
		[BuildOverflowMenuScreens.Screens.BuildStats] = { screen = BuildOverflowMenuScreens.BuildStatsScreen }
	}
	table.insert(v23, v24)
end

if FFlagEnableBuildAdPromotion then
	local v24 = {
		[v10.BuildGetUsers] = { screen = BuildGetUsersScreen }
	}
	table.insert(v23, v24)
end

local v24 = {
	[v10.BuildSearch] = { screen = BuildSearchScreen }
}
table.insert(v23, v24)

local robloxStackNavigator = RoactNavigation.createRobloxStackNavigator(v23, {
	initialRouteName = v10.BuildHome
})

local function BuildPage(p2)
	useTTINavigationTracking("NavigateTo_" .. p2.navigation.state.routeName)

	local param = p2.navigation.getParam("extraProps", {})
	local v25 = useBuildPageEligibility.useBuildPageEligibility(v8)

	if fFlagBuildExperienceHideNavBarOnSubPages then
		useManageBuildNavBarVisibility(p2.navigation, v10.BuildHome)
	end

	if v25.canEnterBuild then
		return React.createElement(robloxStackNavigator, {
			navigation = p2.navigation,
			screenProps = param
		})
	end

	if v25.status == useBuildPageEligibility.Status.Ineligible then
		return React.createElement(BuildEligibilityDialog, {
			variant = useBuildPageEligibility.Status.Ineligible,
			onDismiss = v25.onDialogDismiss
		})
	end

	if v25.status == useBuildPageEligibility.Status.Error then
		return React.createElement(BuildEligibilityDialog, {
			variant = useBuildPageEligibility.Status.Error,
			onDismiss = v25.onDialogDismiss
		})
	end

	if v25.status == useBuildPageEligibility.Status.Refreshing then
		return React.createElement(
			view,
			{
				tag = "col align-x-center align-y-center size-full",
				testId = "BuildPage.EligibilityLoading"
			},
			{
				Spinner = React.createElement(loading, { size = iconSize.Large })
			}
		)
	end

	return React.createElement(view, {
		tag = "size-full",
		testId = "BuildPage.EligibilityPrompting"
	})
end

local extended = React.Component:extend("BuildPageScreen")

function extended.render(p2)
	return React.createElement(BuildPage, p2.props)
end

extended.router = robloxStackNavigator.router

return extended
