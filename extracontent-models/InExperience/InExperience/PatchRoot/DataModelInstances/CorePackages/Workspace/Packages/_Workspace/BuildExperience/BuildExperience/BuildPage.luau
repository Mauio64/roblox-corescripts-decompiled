local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local FFlagBuildExperienceModelPicker = require(BuildExperience.Flags.FFlagBuildExperienceModelPicker)
local prepareBuildModelSelectionTarget = require(BuildExperience.Chat.prepareBuildModelSelectionTarget)
local GetBuildModelSelectionStore = require(BuildExperience.Stores.GetBuildModelSelectionStore)

local Foundation = require(parent.Foundation)
local Navigation = require(parent.Navigation)
local React = require(parent.React)
local RoactNavigation = require(parent.RoactNavigation)
local SharedFlags = require(parent.SharedFlags)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local LocalizationStrings = require(BuildExperience.LocalizationStrings)

local AppBlox = require(parent.AppBlox)
local FullscreenPageWithSafeArea = AppBlox.FullscreenPageWithSafeArea
local Loading = Foundation.Loading
local OverlayProvider = Foundation.OverlayProvider
local View = Foundation.View
local CreatorAgentChat = require(parent.DataHydration.CreatorAgentChat)
local useNavigationFocus = Navigation.useNavigationFocus

local IconName = Foundation.Enums.IconName
local IconSize = Foundation.Enums.IconSize
local Button = Foundation.Button
local ButtonVariant = Foundation.Enums.ButtonVariant
local FillBehavior = Foundation.Enums.FillBehavior
local InputSize = Foundation.Enums.InputSize
local SignalsReact = require(parent.SignalsReact)
local LocalUserIdStore = require(parent.LocalUserIdStore)
local localUserIdStore = LocalUserIdStore.LocalUserIdStore
local BuildPageHeader = require(script.Parent.Components.BuildPageHeader.BuildPageHeader)
local BuildChatPage = require(script.Parent.Components.BuildChatPage.BuildChatPage)
local ChatSheet = require(script.Parent.Components.ChatSheet.ChatSheet)
local FFlagBuildExperienceLibrary = SharedFlags.FFlagBuildExperienceLibrary
local openLibrary = require(script.Parent.utils.openLibrary)
local SearchPageContainer = require(script.Parent.Components.SearchPage.SearchPageContainer)
local SearchEmptyState = require(script.Parent.Components.SearchEmptyState.SearchEmptyState)
local SubagentStatus = require(script.Parent.Components.SubagentStatus)
local MyCreationsTab = require(script.Parent.Components.MyCreationsTab.MyCreationsTab)
local ExperienceResultsList = require(script.Parent.Components.MyCreationsTab.ExperienceResultsList)

local ExperienceResultsLoadingSkeleton = require(script.Parent.Components.MyCreationsTab.ExperienceResultsLoadingSkeleton)
local useMyCreationsResults = require(script.Parent.Components.MyCreationsTab.useMyCreationsResults)
local BuildOverflowMenuScreens = require(script.Parent.Components.BuildPillMenu.BuildOverflowMenuScreens)
local FFlagBuildExperienceMonetizationNativeUI = require(script.Parent.Flags.FFlagBuildExperienceMonetizationNativeUI)
local OverflowMenuPageShell = require(script.Parent.Components.BuildPillMenu.OverflowMenuPageShell)
local PrivateInvitesPickerHost = require(script.Parent.Components.PrivateInvitesPicker.PrivateInvitesPickerHost)
local CreatorCreditPageContainer = require(script.Parent.Components.CreatorCreditSheet.CreatorCreditPageContainer)

local CreatorCreditBalanceChipContainer = require(script.Parent.Components.CreatorCreditSheet.CreatorCreditBalanceChip.CreatorCreditBalanceChipContainer)
local AdsStatsView = require(script.Parent.Components.Ads.AdsStatsView)
local useAdsStatsPageViewModel = require(script.Parent.Components.Ads.useAdsStatsPageViewModel)
local AdsManagerMenuButton = require(script.Parent.Components.Ads.AdsManagerMenuButton)
local AdCampaignCreatedToast = require(script.Parent.Components.Ads.AdCampaignCreatedToast)

require(script.Parent.Chat.chatTypes)
local useSessionSummary = require(script.Parent.Chat.useSessionSummary)
local useScrollPerformanceTracker = require(script.Parent.Telemetry.useScrollPerformanceTracker)

local snapPoints = { 0.5, 1 }
local FFlagBuildAdUpsell = require(script.Parent.Flags.FFlagBuildAdUpsell)
local FFlagEnableBuildAdPromotion = require(script.Parent.Flags.FFlagEnableBuildAdPromotion)

require(script.Parent.Stores.GetBuildOverflowMenuStore.createBuildOverflowMenuStore)
local GetBuildExperienceRefreshStore = require(script.Parent.Stores.GetBuildExperienceRefreshStore)
local GetSearchQueryStore = require(script.Parent.Stores.GetSearchQueryStore)
require(script.Parent.Stores.GetSearchQueryStore.createSearchQueryStore)
local BuildNavigationParams = require(script.Parent.utils.BuildNavigationParams)
local resumeBuildChat = require(script.Parent.utils.resumeBuildChat)
local useBuildPageLayout = require(script.Parent.utils.useBuildPageLayout)
local useManageBuildNavBarVisibility = require(script.Parent.utils.useManageBuildNavBarVisibility)
local useOnScreenKeyboardVisible = require(script.Parent.utils.useOnScreenKeyboardVisible)
local FFlagBuildPublishNavigationSheet = require(script.Parent.Flags.FFlagBuildPublishNavigationSheet)
local FFlagBuildExperiencePrivateInvites = require(script.Parent.Flags.FFlagBuildExperiencePrivateInvites)
local FFlagBuildExperienceEventContextTelemetry = require(script.Parent.Flags.FFlagBuildExperienceEventContextTelemetry)

local FFlagBuildExperienceMyCreationsLongPressMenu = require(script.Parent.Flags.FFlagBuildExperienceMyCreationsLongPressMenu)
local FFlagBuildExperiencePreviewsTab = require(script.Parent.Flags.FFlagBuildExperiencePreviewsTab)
local FFlagAppThemeHalloween2026BuildBackground = require(script.Parent.Flags.FFlagAppThemeHalloween2026BuildBackground)
local ThemeBackground = require(parent.ThemeBackground)
local useThemeBackground = ThemeBackground.useThemeBackground
local FFlagBuildWithGroups = require(script.Parent.Flags.FFlagBuildWithGroups)
local BuildHomeTabsContainer

if FFlagBuildExperiencePreviewsTab then
	BuildHomeTabsContainer = require(script.Parent.Components.BuildHomeTabs.BuildHomeTabsContainer)
else
	BuildHomeTabsContainer = nil
end

local FFlagEnableBuildTabOverride = SharedFlags.FFlagEnableBuildTabOverride
local FFlagBuildExperienceHomeTelemetry = require(script.Parent.Flags.FFlagBuildExperienceHomeTelemetry)
local FFlagBuildExperienceAnalytics = SharedFlags.FFlagBuildExperienceAnalytics
local FFlagBuildExperienceHideNavBarOnSubPages = SharedFlags.FFlagBuildExperienceHideNavBarOnSubPages
local FFlagBuildExperienceChatOpenTelemetry = require(script.Parent.Flags.FFlagBuildExperienceChatOpenTelemetry)
local FFlagBuildExperienceChatOpenId = require(script.Parent.Flags.FFlagBuildExperienceChatOpenId)
local FFlagBuildExperiencePageImpressions = require(script.Parent.Flags.FFlagBuildExperiencePageImpressions)
local useBuildPageImpression = require(BuildExperience.Telemetry.useBuildPageImpression)
local GetAdsCampaignDeepLinkStore = require(BuildExperience.Stores.GetAdsCampaignDeepLinkStore)
local sendBuildExperienceEvent = require(BuildExperience.Telemetry.sendBuildExperienceEvent)
local v = FFlagBuildAdUpsell or FFlagBuildExperienceMonetizationNativeUI
local v2 = not FFlagEnableBuildTabOverride
local BuildEligibilityDialog = require(script.Parent.Components.BuildEligibilityDialog)
local useBuildPageEligibility = require(script.Parent.useBuildPageEligibility)
local PublishSheetController

if FFlagBuildPublishNavigationSheet then
	PublishSheetController = require(script.Parent.Components.PublishSheet.PublishSheetController)
else
	PublishSheetController = nil
end

local TTINavigationTracking = require(parent.TTINavigationTracking)
local useTTINavigationTracking = TTINavigationTracking.useTTINavigationTracking

local v3 = {
	BuildHome = "BuildHome",
	BuildChat = BuildNavigationParams.BUILD_CHAT_SCREEN,
	BuildSearch = "BuildSearch",
	BuildAgents = "BuildAgents",
	BuildAgentDetails = "BuildAgentDetails",
	BuildCreatorCredit = "BuildCreatorCredit",
	BuildGetUsers = "BuildGetUsers"
}

local function shouldShowSearchEmptyState(p: string, p2)
	return p == "" or (p ~= p2.query or p2.isSettledNoResults)
end

local function findGroup(p, subagentTaskGroupName: string?) -- 1 equivalent call inferred from this helper
	if p == nil or subagentTaskGroupName == nil then
		return nil
	end

	for _, group in p.groups do
		if group.name == subagentTaskGroupName then
			return group
		end
	end

	return nil
end

local function useLiveSubagentTaskState(navigation)
	local target = BuildNavigationParams.getTarget(navigation)
	assert(target ~= nil, "Agent pages require a build target")
	local creatorAgentChatStore = CreatorAgentChat.getCreatorAgentChatStore()
	local v4

	if FFlagBuildExperienceModelPicker then
		v4 = SignalsReact.useSignalState(localUserIdStore.getCurrentUserId)
	end

	return useSessionSummary((React.useMemo(function()
		return creatorAgentChatStore.getSessionForProject(target.universeId, target.placeId, target.sessionId)
	end, { creatorAgentChatStore, target.universeId, target.placeId, target.sessionId, v4 }))).subagentTaskState or BuildNavigationParams.getSubagentTaskState(navigation)
end

local function useOpenBuildChat(navigation, p: string?)
	local useCallback = React.useCallback
	local function fn(state, p2: string?)
		if FFlagBuildExperienceModelPicker then
			state = prepareBuildModelSelectionTarget(state)
		end

		if FFlagBuildExperienceChatOpenId then
			state = table.clone(state)
			local HttpService = game:GetService("HttpService")
			state.chatOpenId = HttpService:GenerateGUID(false)
		end

		if FFlagBuildExperienceChatOpenTelemetry then
			local v4 = {
				universeId = state.universeId,
				placeId = state.placeId,
				conversationId = 0,
				chatOpenId = 0
			}
			local conversationId

			if FFlagBuildExperienceEventContextTelemetry then
				conversationId = state.sessionId
			end

			v4.conversationId = conversationId
			v4.chatOpenId = state.chatOpenId
			local v5 = {
				isNewGame = tostring(state.isNewGameTarget == true),
				context = 0
			}
			local context

			if FFlagBuildExperienceEventContextTelemetry then
				context = p2 or p
			end

			v5.context = context
			sendBuildExperienceEvent("CHAT_OPEN", v4, v5)
		end

		navigation.navigate(v3.BuildChat, { target = state })
	end

	local v4

	if FFlagBuildExperienceEventContextTelemetry then
		v4 = p
	end

	return useCallback(fn, { navigation, v4 })
end

local function useHomeConfigurationPages(navigation)
	local state, setState = React.useState(nil)
	local state2, setState2 = React.useState(false)
	local onClosePublishSheet = React.useCallback(function()
		setState2(false)
	end, {})
	local navigateToPublishSubPage = React.useCallback(function(p: string, target)
		navigation.navigate(p, { target = target })
	end, { navigation })
	return {
		onOpenConfigurationPage = React.useCallback(function(p, target)
			if FFlagBuildPublishNavigationSheet and p == "publish" then
				setState(target)
				setState2(true)
			else
				local v4 = BuildOverflowMenuScreens.SCREEN_BY_PAGE[p]

				if v4 == nil then
					return
				end

				navigation.navigate(v4, { target = target })
			end
		end, { navigation }),
		publishSheetTarget = state,
		isPublishSheetOpen = state2,
		onClosePublishSheet = onClosePublishSheet,
		navigateToPublishSubPage = navigateToPublishSubPage
	}
end

local function BuildMonetizationScreen(p)
	local navigation = p.navigation
	local target = BuildNavigationParams.getTarget(navigation)
	local state, setState = React.useState(false)
	local v4 = target ~= nil
	local onComposerActivated = React.useCallback(function()
		if v4 then
			setState(true)
		end
	end, { v4 })
	local onClose = React.useCallback(function()
		setState(false)
	end, {})

	React.useEffect(function()
		if not state then
			return
		end

		local v5 = navigation.addListener(RoactNavigation.Events.WillBlur, onClose)
		return function()
			v5.remove()
		end
	end, { state, navigation, onClose })

	local createElement = React.createElement
	local fragment = React.Fragment
	local v5 = {
		Page = React.createElement(BuildOverflowMenuScreens.BuildMonetizationScreen, {
			navigation = navigation,
			onComposerActivated = onComposerActivated
		}),
		Chat = 0
	}
	local chat

	if state and target ~= nil then
		chat = React.createElement(ChatSheet, {
			autoFocusComposer = true,
			defaultSnapPointIndex = 1,
			isOpen = true,
			onClose = onClose,
			placeId = target.placeId,
			sessionId = target.sessionId,
			snapPoints = snapPoints,
			universeId = target.universeId
		})
	end

	v5.Chat = chat
	return createElement(fragment, nil, v5)
end

local function BuildHomeScreen(p)
	local screenProps = p.screenProps or {}
	local navigation = p.navigation
	local v4 = useBuildPageLayout()
	local isFocused = useNavigationFocus()
	local tokens = v4.tokens
	local fallbackExperienceName = useLocalization({
		fallbackExperienceName = LocalizationStrings.BUILD_ASSISTANT_FALLBACK_NAME
	}).fallbackExperienceName

	local onOpenChat = useOpenBuildChat(navigation, FFlagBuildExperienceEventContextTelemetry and "my_creations" or nil)
	local v5

	if FFlagBuildExperienceMyCreationsLongPressMenu then
		v5 = useHomeConfigurationPages(navigation)
	end

	local publishSheetTarget

	if v5 ~= nil then
		publishSheetTarget = v5.publishSheetTarget
	end

	local v6

	if FFlagAppThemeHalloween2026BuildBackground then
		v6 = useThemeBackground() ~= nil
	else
		v6 = false
	end

	local useEffect = React.useEffect
	local function fn()
		if FFlagBuildAdUpsell then
			local adsCampaignDeepLinkStore = GetAdsCampaignDeepLinkStore(false)

			if screenProps.resumeRequestId then
				local universeId

				if screenProps.adsCampaignIntent then
					universeId = screenProps.universeId
				end

				if adsCampaignDeepLinkStore.begin(screenProps.resumeRequestId, universeId) and universeId ~= nil then
					sendBuildExperienceEvent(
						"AD_CAMPAIGN_DEEP_LINK_RECEIVED",
						{ universeId = screenProps.universeId },
						{ requestId = screenProps.resumeRequestId }
					)
				end
			else
				local request = adsCampaignDeepLinkStore.getRequest(false)

				if request ~= nil then
					adsCampaignDeepLinkStore.finish(request.id)
				end
			end
		end

		local v7 = {
			universeId = screenProps.universeId,
			sessionId = screenProps.sessionId,
			creatorAgentChatStore = screenProps.creatorAgentChatStore,
			configurationStore = screenProps.configurationStore,
			fallbackExperienceName = fallbackExperienceName,
			onOpenChat = 0
		}
		local onOpenChat2

		if FFlagBuildExperienceEventContextTelemetry then
			onOpenChat2 = function(p2)
				onOpenChat(p2, "deep_link")
			end
		else
			onOpenChat2 = onOpenChat
		end

		v7.onOpenChat = onOpenChat2
		return resumeBuildChat(v7)
	end

	local universeId = screenProps.universeId
	local sessionId = screenProps.sessionId
	local resumeRequestId = screenProps.resumeRequestId
	local v7

	if FFlagBuildAdUpsell then
		v7 = screenProps.adsCampaignIntent
	end

	useEffect(fn, {
		onOpenChat,
		universeId,
		sessionId,
		resumeRequestId,
		v7,
		screenProps.creatorAgentChatStore,
		screenProps.configurationStore,
		fallbackExperienceName
	})

	local searchQueryStore = screenProps.searchQueryStore or GetSearchQueryStore()

	local onOpenSearch = React.useCallback(function()
		local searchQueryStore2 = searchQueryStore

		if FFlagBuildExperienceHomeTelemetry then
			sendBuildExperienceEvent("SEARCH_OPEN", {}, { context = "home_header" })
		end

		searchQueryStore2.beginSearch()

		navigation.navigate(v3.BuildSearch, { searchQueryStore = searchQueryStore2 })
	end, { navigation, searchQueryStore })

	local createElement = React.createElement
	local v8 = {
		LayoutOrder = 3,
		creatorAgentChatStore = screenProps.creatorAgentChatStore,
		configurationStore = screenProps.configurationStore,
		searchStore = screenProps.searchStore,
		searchQueryStore = screenProps.searchQueryStore,
		isFocused = isFocused,
		autoOpenNewGame = screenProps.universeId == nil and screenProps.sessionId == nil,
		onOpenChat = onOpenChat,
		onOpenConfigurationPage = 0
	}
	local onOpenConfigurationPage

	if v5 ~= nil then
		onOpenConfigurationPage = v5.onOpenConfigurationPage
	end

	v8.onOpenConfigurationPage = onOpenConfigurationPage
	local v9 = createElement(MyCreationsTab, v8)

	local createElement2 = React.createElement
	local v10 = {
		BackgroundColor3 = tokens.Color.Surface.Surface_0.Color3,
		BackgroundTransparency = v6 and 1 or tokens.Color.Surface.Surface_0.Transparency,
		includeBottomBar = v4.shouldIncludeBottomBar,
		includeStatusBar = true
	}

	local createElement3 = React.createElement

	local v11 = {
		Header = React.createElement(BuildPageHeader, {
			LayoutOrder = 1,
			height = v4.topBarHeight,
			searchQueryStore = searchQueryStore,
			onOpenSearch = onOpenSearch
		}),
		Content = 0
	}

	local createElement4 = React.createElement

	if FFlagBuildExperiencePreviewsTab then
		v9 = React.createElement(BuildHomeTabsContainer, {
			LayoutOrder = 3,
			gamesContent = v9,
			isFocused = isFocused,
			searchStore = screenProps.searchStore,
			searchQueryStore = searchQueryStore
		})
	end

	v11.Content = createElement4(
		View,
		{ LayoutOrder = 2, ZIndex = 4, tag = "col align-x-center fill gap-small size-full-0" },
		{ SearchBarContainer = nil, MyCreations = v9 }
	)
	local v12 = {
		Page = createElement3(View, {
			tag = FFlagAppThemeHalloween2026BuildBackground and {
				["col align-x-center size-full"] = true,
				["bg-surface-0"] = not v6
			} or "col align-x-center size-full bg-surface-0"
		}, v11),
		PublishSheet = 0
	}
	local publishSheet

	if
		FFlagBuildPublishNavigationSheet
		and v5 ~= nil
		and publishSheetTarget ~= nil
		and publishSheetTarget.universeId ~= nil
	then
		publishSheet = React.createElement(PublishSheetController, {
			isOpen = v5.isPublishSheetOpen,
			target = publishSheetTarget,
			onClose = v5.onClosePublishSheet,
			navigateToSubPage = v5.navigateToPublishSubPage
		})
	end

	v12.PublishSheet = publishSheet
	return createElement2(FullscreenPageWithSafeArea, v10, v12)
end

local function BuildSearchResults(props)
	local v4 = props.searchQueryStore.useDraftQuery()
	local current = props.closingSnapshot.current
	local results

	if current == nil then
		results = props.results
	else
		results = current.results
	end

	local v5

	if current == nil then
		v5 = v4 == "" or v4 ~= results.query or results.isSettledNoResults
	else
		v5 = current.showEmptyState
	end

	if v5 then
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

local function BuildSearchScreen(p)
	local screenProps = p.screenProps or {}
	local navigation = p.navigation
	local v4 = useBuildPageLayout()
	local v5 = useNavigationFocus()
	local v6 = useOnScreenKeyboardVisible()
	local searchQueryStore = navigation.getParam("searchQueryStore")
		or screenProps.searchQueryStore
		or GetSearchQueryStore()
	local v7 = SignalsReact.useSignalBinding(searchQueryStore.getDraftQuery)
	local v8 = useLocalization({ searchbarPlaceholder = "Feature.Build.Label.SearchGames" })

	local onOpenChat = useOpenBuildChat(
		navigation,
		FFlagBuildExperienceEventContextTelemetry and "search_results" or nil
	)
	local results = useMyCreationsResults({
		creatorAgentChatStore = screenProps.creatorAgentChatStore,
		configurationStore = screenProps.configurationStore,
		searchStore = screenProps.searchStore,
		searchQueryStore = searchQueryStore,
		isFocused = v5
	})

	local ref = React.useRef(nil)
	local current = ref.current
	local mapped = v7:map(function(p2: string)
		local current2 = ref.current
		return if current2 == nil then p2 else current2.query
	end)
	local v9

	if current == nil then
		v9 = results
	else
		v9 = current.results
	end

	local ref2 = React.useRef(nil)
	useScrollPerformanceTracker("LuaApp_Build_Search_Scroll", ref2)
	local createFooter = React.useCallback(function()
		if v9.isLoadingMore then
			return React.createElement(ExperienceResultsLoadingSkeleton, {
				LayoutOrder = 1,
				index = 1,
				testIdPrefix = "SearchPage"
			})
		end

		return nil
	end, { v9.isLoadingMore })
	local onBack = React.useCallback(function()
		local draftQuery = searchQueryStore.getDraftQuery()
		local current2 = { query = draftQuery, results = results, showEmptyState = 0 }

		local results2 = results
		current2.showEmptyState = draftQuery == "" or draftQuery ~= results2.query or results2.isSettledNoResults
		ref.current = current2

		searchQueryStore.endSearch()
		navigation.goBack()
	end, { ref, navigation, results, searchQueryStore })

	React.useEffect(function()
		searchQueryStore.beginSearch()
		return searchQueryStore.endSearch
	end, { searchQueryStore })

	return React.createElement(FullscreenPageWithSafeArea, {
		BackgroundColor3 = v4.tokens.Color.Surface.Surface_0.Color3,
		BackgroundTransparency = v4.tokens.Color.Surface.Surface_0.Transparency,
		includeBottomBar = v4.shouldIncludeBottomBar and not v6,
		includeStatusBar = true
	}, {
		Page = React.createElement(SearchPageContainer, {
			ref = ref2,
			createFooter = createFooter,
			onBack = onBack,
			onCanvasPositionChangedCallback = v9.loadMoreIfNeeded,
			onCanvasSizeChangedCallback = v9.loadMoreIfNeeded,
			refresh = v9.refresh,
			searchBarProps = {
				clear = searchQueryStore.clear,
				onFocusGained = searchQueryStore.beginSearch,
				placeholder = v8.searchbarPlaceholder,
				query = mapped,
				setQuery = searchQueryStore.setQuery,
				shouldFocus = v5
			},
			showEmptyState = false
		}, {
			ExperienceResults = React.createElement(BuildSearchResults, {
				closingSnapshot = ref,
				onOpenChat = onOpenChat,
				results = results,
				searchQueryStore = searchQueryStore
			})
		})
	})
end

local function BuildChatScreen(p)
	local navigation = p.navigation
	local target = BuildNavigationParams.getTarget(navigation)
	local initialPrompt

	if FFlagBuildExperienceAnalytics then
		initialPrompt = BuildNavigationParams.getInitialPrompt(navigation)
	end

	local buildExperienceRefreshStore = GetBuildExperienceRefreshStore()
	local v4 = useBuildPageLayout()

	local isFocused = not v or useNavigationFocus()
	local v5 = useOnScreenKeyboardVisible()
	local state, setState = React.useState(false)
	local state2, setState2 = React.useState(false)

	if FFlagBuildExperienceModelPicker then
		local v6 = SignalsReact.useSignalState(localUserIdStore.getCurrentUserId)

		React.useLayoutEffect(function()
			if target ~= nil and (tonumber(v6) or 0) > 0 then
				local target2 = prepareBuildModelSelectionTarget(target)

				if target2 ~= target then
					navigation.setParams({ target = target2 })
				end
			end
		end, { v6, target, navigation })
		local modelSelectionDraftId

		if target == nil then
			modelSelectionDraftId = nil
		else
			modelSelectionDraftId = target.modelSelectionDraftId
		end

		React.useEffect(function()
			return function()
				if modelSelectionDraftId ~= nil then
					GetBuildModelSelectionStore(false).discardDraft(modelSelectionDraftId)
				end
			end
		end, { modelSelectionDraftId })
	end

	local onClose = React.useCallback(function()
		if FFlagBuildWithGroups and target ~= nil and target.isNewGameTarget == true and target.universeId ~= nil then
			local GetMyCreationsFilterStore = require(script.Parent.Stores.GetMyCreationsFilterStore)
			GetMyCreationsFilterStore().setFilter({ games = "MyGames" })

			if FFlagBuildExperiencePreviewsTab then
				local GetBuildHomeTabStore = require(script.Parent.Stores.GetBuildHomeTabStore)
				GetBuildHomeTabStore().setTab("Games")
			end
		end

		navigation.goBack()
	end, { navigation, target })

	local onClose2 = React.useCallback(function()
		setState2(false)
	end, {})

	local onOpenConfigurationPage = React.useCallback(function(p2)
		if FFlagBuildPublishNavigationSheet and p2 == "publish" then
			setState2(true)
			return
		end

		local v6 = BuildOverflowMenuScreens.SCREEN_BY_PAGE[p2]

		if v6 == nil then
			return
		end

		navigation.navigate(v6, { target = target })
	end, { navigation, target })

	local onOpenInvitePicker = React.useCallback(function()
		setState(true)
	end, {})
	local onClose3 = React.useCallback(function()
		setState(false)
	end, {})

	local onOpenInviteManagement = React.useCallback(function()
		navigation.navigate(BuildOverflowMenuScreens.Screens.BuildPlaytestInviteManagement, {
			target = target
		})
	end, { navigation, target })
	local onOpenLibrary

	if FFlagBuildExperienceLibrary then
		onOpenLibrary = React.useCallback(function(p2: string?)
			local placeId

			if target ~= nil then
				placeId = target.placeId
			end

			if placeId ~= nil then
				openLibrary(placeId, p2)
			end
		end, { target })
	end

	local onInvitesSent = React.useCallback(function()
		setState(false)

		if FFlagBuildExperiencePrivateInvites then
			onOpenInviteManagement()
		end
	end, { onOpenInviteManagement })
	local onOpenAgentsPage = React.useCallback(function()
		navigation.navigate(v3.BuildAgents, { target = target })
	end, { navigation, target })
	local onOpenCreatorCreditPage = React.useCallback(function()
		navigation.navigate(v3.BuildCreatorCredit, { target = target })
	end, { navigation, target })

	local navigateToSubPage = React.useCallback(function(p2: string, target2)
		navigation.navigate(p2, { target = target2 })
	end, { navigation })
	local onOpenGetUsersPage

	if FFlagEnableBuildAdPromotion then
		onOpenGetUsersPage = React.useCallback(function()
			navigation.navigate(v3.BuildGetUsers, { target = target })
		end, { navigation, target })
	end

	local onNavigateToResolvedTarget = React.useCallback(function(target2)
		navigation.setParams({ target = target2 })

		buildExperienceRefreshStore.bumpRefreshTick()
	end, { navigation, buildExperienceRefreshStore })
	local page

	if target ~= nil then
		local createElement = React.createElement
		local v6 = {
			target = target,
			onOpenLibrary = onOpenLibrary,
			initialPrompt = initialPrompt,
			onClose = onClose,
			onOpenAgentsPage = onOpenAgentsPage,
			onOpenCreatorCreditPage = onOpenCreatorCreditPage,
			onOpenGetUsersPage = onOpenGetUsersPage,
			onOpenConfigurationPage = onOpenConfigurationPage,
			onOpenInvitePicker = onOpenInvitePicker,
			onOpenInviteManagement = onOpenInviteManagement,
			onNavigateToResolvedTarget = onNavigateToResolvedTarget,
			isFocused = nil
		}

		if not v then
			isFocused = nil
		end

		v6.isFocused = isFocused
		page = createElement(BuildChatPage, v6)
	end

	local universeId

	if target ~= nil then
		universeId = target.universeId
	end

	local createElement = React.createElement
	local fragment = React.Fragment
	local v6 = {
		Page = React.createElement(FullscreenPageWithSafeArea, {
			BackgroundColor3 = v4.tokens.Color.Surface.Surface_0.Color3,
			BackgroundTransparency = v4.tokens.Color.Surface.Surface_0.Transparency,
			includeBottomBar = v4.shouldIncludeBottomBar and not v5,
			includeStatusBar = true
		}, { Page = page }),
		Picker = 0,
		PublishSheet = 0
	}
	local picker

	if state and universeId ~= nil then
		picker = React.createElement(PrivateInvitesPickerHost, {
			universeId = universeId,
			onClose = onClose3,
			onInvitesSent = onInvitesSent
		})
	end

	v6.Picker = picker
	local publishSheet

	if FFlagBuildPublishNavigationSheet and target ~= nil and target.universeId ~= nil then
		publishSheet = React.createElement(PublishSheetController, {
			isOpen = state2,
			target = target,
			onClose = onClose2,
			navigateToSubPage = navigateToSubPage
		})
	end

	v6.PublishSheet = publishSheet
	return createElement(fragment, nil, v6)
end

local function BuildAgentsScreen(p)
	local navigation = p.navigation
	local v4 = useBuildPageLayout()
	local v5 = useLiveSubagentTaskState(navigation)
	local agents = useLocalization({ agents = LocalizationStrings.SUBAGENT_STATUS_AGENTS }).agents

	local onClose = React.useCallback(function()
		navigation.goBack()
	end, { navigation })
	local onAgentActivated = React.useCallback(function(p2)
		navigation.navigate(v3.BuildAgentDetails, {
			target = BuildNavigationParams.getTarget(navigation),
			subagentTaskGroupName = p2.name
		})
	end, { navigation })

	local element = React.createElement(SubagentStatus.AgentsList, {
		groups = v5 == nil and {} or v5.groups,
		onAgentActivated = onAgentActivated,
		testId = "BuildPage.AgentsList"
	})

	return React.createElement(
		FullscreenPageWithSafeArea,
		{
			BackgroundColor3 = v4.tokens.Color.Surface.Surface_0.Color3,
			BackgroundTransparency = v4.tokens.Color.Surface.Surface_0.Transparency,
			includeBottomBar = v4.shouldIncludeBottomBar,
			includeStatusBar = true
		},
		{
			Page = React.createElement(OverflowMenuPageShell, {
				title = agents,
				onClose = onClose,
				content = element,
				scrollPerformanceIntervalName = "LuaApp_Build_Agents_Scroll",
				testId = "BuildPage.AgentsPage"
			})
		}
	)
end

local function BuildAgentDetailsScreen(p)
	local navigation = p.navigation
	local v4 = useBuildPageLayout()
	local v5 = useLiveSubagentTaskState(navigation)
	local subagentTaskGroupName = BuildNavigationParams.getSubagentTaskGroupName(navigation)
	local group = findGroup(v5, subagentTaskGroupName) -- inferred equivalent call
	local agents = useLocalization({ agents = LocalizationStrings.SUBAGENT_STATUS_AGENTS }).agents

	local onClose = React.useCallback(function()
		navigation.goBack()
	end, { navigation })
	local content

	if group == nil then
		content = React.createElement(View, { tag = "size-full" })
	else
		content = React.createElement(SubagentStatus.AgentDetailsList, {
			group = group,
			testId = "BuildPage.AgentDetailsList"
		})
	end

	return React.createElement(
		FullscreenPageWithSafeArea,
		{
			BackgroundColor3 = v4.tokens.Color.Surface.Surface_0.Color3,
			BackgroundTransparency = v4.tokens.Color.Surface.Surface_0.Transparency,
			includeBottomBar = v4.shouldIncludeBottomBar,
			includeStatusBar = true
		},
		{
			Page = React.createElement(OverflowMenuPageShell, {
				title = subagentTaskGroupName or agents,
				onClose = onClose,
				content = content,
				scrollPerformanceIntervalName = "LuaApp_Build_AgentDetails_Scroll",
				testId = "BuildPage.AgentDetailsPage"
			})
		}
	)
end

local function BuildCreatorCreditScreen(p)
	local navigation = p.navigation

	if FFlagBuildExperiencePageImpressions then
		useBuildPageImpression("creator-credit-ai-usage", BuildNavigationParams.getTarget(navigation))
	end

	local v4 = useBuildPageLayout()
	local pageTitle = useLocalization({ pageTitle = LocalizationStrings.CREATOR_CREDIT_PAGE_TITLE }).pageTitle

	local onClose = React.useCallback(function()
		navigation.goBack()
	end, { navigation })

	local element = React.createElement(CreatorCreditPageContainer, nil)

	return React.createElement(
		FullscreenPageWithSafeArea,
		{
			BackgroundColor3 = v4.tokens.Color.Surface.Surface_0.Color3,
			BackgroundTransparency = v4.tokens.Color.Surface.Surface_0.Transparency,
			includeBottomBar = v4.shouldIncludeBottomBar,
			includeStatusBar = true
		},
		{
			Page = React.createElement(OverflowMenuPageShell, {
				title = pageTitle,
				onClose = onClose,
				content = element,
				headerTrailing = React.createElement(CreatorCreditBalanceChipContainer),
				scrollPerformanceIntervalName = "LuaApp_Build_CreatorCredit_Scroll",
				testId = "BuildPage.CreatorCreditPage"
			})
		}
	)
end

local function BuildGetUsersScreen(p)
	local navigation = p.navigation
	local v4 = useBuildPageLayout()
	local target = BuildNavigationParams.getTarget(navigation)
	local universeId

	if target ~= nil then
		universeId = target.universeId
	end

	if FFlagBuildExperiencePageImpressions then
		useBuildPageImpression("get-users", target)
	end

	local pageTitle = useLocalization({ pageTitle = LocalizationStrings.ADS_STATS_PAGE_TITLE }).pageTitle

	local onClose = React.useCallback(function()
		navigation.goBack()
	end, { navigation })

	local v5 = useAdsStatsPageViewModel(universeId)
	local element = React.createElement(AdsStatsView, v5)
	local state, setState = React.useState(nil)

	local disableScrolling = not (v5.isLoading or v5.isFailed or v5.hasCampaigns)
	local footer

	if not (v5.isLoading or v5.isFailed) then
		local createElement = React.createElement

		local v6 = {
			ToastAnchor = React.createElement(View, {
				LayoutOrder = 1,
				ref = setState,
				tag = "size-full-0",
				testId = "BuildPage.GetUsers.ToastAnchor"
			}),
			Actions = 0
		}

		local createElement2 = React.createElement

		local createElement3 = React.createElement
		local v7 = {
			text = v5.createButtonText,
			icon = 0,
			size = 0,
			variant = 0,
			fillBehavior = 0,
			width = 0,
			isLoading = 0,
			onActivated = 0,
			testId = "BuildPage.GetUsers.Create"
		}
		local icon

		if v5.createButtonIsExternal then
			icon = IconName.ArrowUpRightFromSquare
		end

		v7.icon = icon
		v7.size = InputSize.Large
		v7.variant = ButtonVariant.Emphasis
		v7.fillBehavior = FillBehavior.Fill
		v7.width = UDim.new(1, 0)
		v7.isLoading = v5.isPromotionCreatePending
		v7.onActivated = v5.onCreatePrimary
		v6.Actions = createElement2(
			View,
			{
				LayoutOrder = 2,
				tag = "row size-full-0 auto-y padding-y-medium",
				testId = "BuildPage.GetUsers.Actions"
			},
			{ Create = createElement3(Button, v7) }
		)
		footer = createElement(View, {
			tag = "col size-full-0 auto-y",
			testId = "BuildPage.GetUsers.Footer"
		}, v6)
	end

	local createElement = React.createElement
	local v6 = {
		BackgroundColor3 = v4.tokens.Color.Surface.Surface_0.Color3,
		BackgroundTransparency = v4.tokens.Color.Surface.Surface_0.Transparency,
		includeBottomBar = v4.shouldIncludeBottomBar,
		includeStatusBar = true
	}

	local v7 = {
		Page = React.createElement(OverflowMenuPageShell, {
			title = pageTitle,
			onClose = onClose,
			content = element,
			footer = footer,
			disableScrolling = disableScrolling,
			headerTrailing = React.createElement(AdsManagerMenuButton, {
				universeId = universeId,
				testId = "BuildPage.GetUsersPage.AdsManagerMenu"
			}),
			scrollPerformanceIntervalName = "LuaApp_Build_GetUsers_Scroll",
			testId = "BuildPage.GetUsersPage"
		}),
		SuccessToast = 0
	}
	local successToast

	if v5.showCreateSuccessToast and state ~= nil then
		successToast = React.createElement(OverlayProvider, { gui = state }, {
			Toast = React.createElement(AdCampaignCreatedToast, {
				onClose = v5.onDismissCreateSuccessToast,
				testId = "BuildPage.GetUsers.SuccessToast",
				title = v5.createSuccessToastText
			})
		})
	end

	v7.SuccessToast = successToast
	return createElement(FullscreenPageWithSafeArea, v6, v7)
end

local v4 = {
	{
		[v3.BuildHome] = { screen = BuildHomeScreen }
	},
	{
		[v3.BuildChat] = { screen = BuildChatScreen }
	},
	{
		[BuildOverflowMenuScreens.Screens.BuildPublish] = {
			screen = BuildOverflowMenuScreens.BuildPublishScreen
		}
	},
	{
		[BuildOverflowMenuScreens.Screens.BuildSettings] = {
			screen = BuildOverflowMenuScreens.BuildSettingsScreen
		}
	},
	{
		[BuildOverflowMenuScreens.Screens.BuildAudience] = {
			screen = BuildOverflowMenuScreens.BuildAudienceScreen
		}
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
		[v3.BuildAgents] = { screen = BuildAgentsScreen }
	},
	{
		[v3.BuildAgentDetails] = { screen = BuildAgentDetailsScreen }
	},
	{
		[v3.BuildCreatorCredit] = { screen = BuildCreatorCreditScreen }
	}
}

if FFlagBuildExperienceMonetizationNativeUI then
	local v5 = {
		[BuildOverflowMenuScreens.Screens.BuildMonetization] = { screen = BuildMonetizationScreen }
	}
	table.insert(v4, v5)
end

if FFlagBuildExperienceAnalytics then
	local v5 = {
		[BuildOverflowMenuScreens.Screens.BuildStats] = {
			screen = BuildOverflowMenuScreens.BuildStatsScreen
		}
	}
	table.insert(v4, v5)
end

if FFlagEnableBuildAdPromotion then
	local v5 = {
		[v3.BuildGetUsers] = { screen = BuildGetUsersScreen }
	}
	table.insert(v4, v5)
end

local v5 = {
	[v3.BuildSearch] = { screen = BuildSearchScreen }
}
table.insert(v4, v5)

local robloxStackNavigator = RoactNavigation.createRobloxStackNavigator(v4, {
	initialRouteName = v3.BuildHome
})

local function BuildPage(p)
	useTTINavigationTracking("NavigateTo_" .. p.navigation.state.routeName)

	local param = p.navigation.getParam("extraProps", {})
	local v6 = useBuildPageEligibility.useBuildPageEligibility(v2)

	if FFlagBuildExperienceHideNavBarOnSubPages then
		useManageBuildNavBarVisibility(p.navigation, v3.BuildHome)
	end

	if v6.canEnterBuild then
		return React.createElement(robloxStackNavigator, {
			navigation = p.navigation,
			screenProps = param
		})
	end

	if v6.status == useBuildPageEligibility.Status.Ineligible then
		return React.createElement(BuildEligibilityDialog, {
			variant = useBuildPageEligibility.Status.Ineligible,
			onDismiss = v6.onDialogDismiss
		})
	end

	if v6.status == useBuildPageEligibility.Status.Error then
		return React.createElement(BuildEligibilityDialog, {
			variant = useBuildPageEligibility.Status.Error,
			onDismiss = v6.onDialogDismiss
		})
	end

	if v6.status == useBuildPageEligibility.Status.Refreshing then
		return React.createElement(
			View,
			{
				tag = "col align-x-center align-y-center size-full",
				testId = "BuildPage.EligibilityLoading"
			},
			{
				Spinner = React.createElement(Loading, { size = IconSize.Large })
			}
		)
	end

	return React.createElement(View, {
		tag = "size-full",
		testId = "BuildPage.EligibilityPrompting"
	})
end

local extended = React.Component:extend("BuildPageScreen")

function extended.render(p)
	return React.createElement(BuildPage, p.props)
end

extended.router = robloxStackNavigator.router

return extended
