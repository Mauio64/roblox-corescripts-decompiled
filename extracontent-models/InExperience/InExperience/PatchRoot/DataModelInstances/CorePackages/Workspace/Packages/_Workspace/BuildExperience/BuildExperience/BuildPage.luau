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

local FFlagBuildExperienceChatSheetReversedContent = require(script.Parent.Flags.FFlagBuildExperienceChatSheetReversedContent)

local v = { 0.5, 1 }
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
local FFlagBuildExperienceAnalytics = SharedFlags.FFlagBuildExperienceAnalytics
local FFlagBuildExperienceHideNavBarOnSubPages = SharedFlags.FFlagBuildExperienceHideNavBarOnSubPages
local FFlagBuildExperienceChatOpenTelemetry = require(script.Parent.Flags.FFlagBuildExperienceChatOpenTelemetry)
local GetAdsCampaignDeepLinkStore = require(BuildExperience.Stores.GetAdsCampaignDeepLinkStore)
local sendBuildExperienceEvent = require(BuildExperience.Telemetry.sendBuildExperienceEvent)
local v2 = FFlagBuildAdUpsell or FFlagBuildExperienceMonetizationNativeUI
local v3 = not FFlagEnableBuildTabOverride
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

local v4 = {
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
	local v5

	if FFlagBuildExperienceModelPicker then
		v5 = SignalsReact.useSignalState(localUserIdStore.getCurrentUserId)
	end

	return useSessionSummary((React.useMemo(function()
		return creatorAgentChatStore.getSessionForProject(target.universeId, target.placeId, target.sessionId)
	end, { creatorAgentChatStore, target.universeId, target.placeId, target.sessionId, v5 }))).subagentTaskState or BuildNavigationParams.getSubagentTaskState(navigation)
end

local function useOpenBuildChat(navigation) -- 2 equivalent calls inferred from this helper
	return React.useCallback(function(target)
		if FFlagBuildExperienceModelPicker then
			target = prepareBuildModelSelectionTarget(target)
		end

		if FFlagBuildExperienceChatOpenTelemetry then
			sendBuildExperienceEvent("CHAT_OPEN", {
				universeId = target.universeId,
				placeId = target.placeId
			}, {
				isNewGame = tostring(target.isNewGameTarget == true)
			})
		end

		navigation.navigate(v4.BuildChat, { target = target })
	end, { navigation })
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
				local v5 = BuildOverflowMenuScreens.SCREEN_BY_PAGE[p]

				if v5 == nil then
					return
				end

				navigation.navigate(v5, { target = target })
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
	local v5 = target ~= nil
	local onComposerActivated = React.useCallback(function()
		if v5 then
			setState(true)
		end
	end, { v5 })
	local onClose = React.useCallback(function()
		setState(false)
	end, {})

	React.useEffect(function()
		if not state then
			return
		end

		local v6 = navigation.addListener(RoactNavigation.Events.WillBlur, onClose)
		return function()
			v6.remove()
		end
	end, { state, navigation, onClose })

	local createElement = React.createElement
	local fragment = React.Fragment
	local v6 = {
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
			snapPoints = not FFlagBuildExperienceChatSheetReversedContent and { 0.5 } or v,
			universeId = target.universeId
		})
	end

	v6.Chat = chat
	return createElement(fragment, nil, v6)
end

local function BuildHomeScreen(p)
	local screenProps = p.screenProps or {}
	local navigation = p.navigation
	local v5 = useBuildPageLayout()
	local isFocused = useNavigationFocus()
	local tokens = v5.tokens
	local fallbackExperienceName = useLocalization({
		fallbackExperienceName = LocalizationStrings.BUILD_ASSISTANT_FALLBACK_NAME
	}).fallbackExperienceName
	local onOpenChat = useOpenBuildChat(navigation) -- inferred equivalent call
	local v6

	if FFlagBuildExperienceMyCreationsLongPressMenu then
		v6 = useHomeConfigurationPages(navigation)
	end

	local publishSheetTarget

	if v6 ~= nil then
		publishSheetTarget = v6.publishSheetTarget
	end

	local v7

	if FFlagAppThemeHalloween2026BuildBackground then
		v7 = useThemeBackground() ~= nil
	else
		v7 = false
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

		return resumeBuildChat({
			universeId = screenProps.universeId,
			sessionId = screenProps.sessionId,
			creatorAgentChatStore = screenProps.creatorAgentChatStore,
			configurationStore = screenProps.configurationStore,
			fallbackExperienceName = fallbackExperienceName,
			onOpenChat = onOpenChat
		})
	end

	local universeId = screenProps.universeId
	local sessionId = screenProps.sessionId
	local resumeRequestId = screenProps.resumeRequestId
	local v8

	if FFlagBuildAdUpsell then
		v8 = screenProps.adsCampaignIntent
	end

	useEffect(fn, {
		onOpenChat,
		universeId,
		sessionId,
		resumeRequestId,
		v8,
		screenProps.creatorAgentChatStore,
		screenProps.configurationStore,
		fallbackExperienceName
	})

	local searchQueryStore = screenProps.searchQueryStore or GetSearchQueryStore()

	local onOpenSearch = React.useCallback(function()
		local searchQueryStore2 = searchQueryStore
		searchQueryStore2.beginSearch()

		navigation.navigate(v4.BuildSearch, { searchQueryStore = searchQueryStore2 })
	end, { navigation, searchQueryStore })

	local createElement = React.createElement
	local v9 = {
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

	if v6 ~= nil then
		onOpenConfigurationPage = v6.onOpenConfigurationPage
	end

	v9.onOpenConfigurationPage = onOpenConfigurationPage
	local v10 = createElement(MyCreationsTab, v9)

	local createElement2 = React.createElement
	local v11 = {
		BackgroundColor3 = tokens.Color.Surface.Surface_0.Color3,
		BackgroundTransparency = v7 and 1 or tokens.Color.Surface.Surface_0.Transparency,
		includeBottomBar = v5.shouldIncludeBottomBar,
		includeStatusBar = true
	}

	local createElement3 = React.createElement

	local v12 = {
		Header = React.createElement(BuildPageHeader, {
			LayoutOrder = 1,
			height = v5.topBarHeight,
			searchQueryStore = searchQueryStore,
			onOpenSearch = onOpenSearch
		}),
		Content = 0
	}

	local createElement4 = React.createElement

	if FFlagBuildExperiencePreviewsTab then
		v10 = React.createElement(BuildHomeTabsContainer, {
			LayoutOrder = 3,
			gamesContent = v10,
			isFocused = isFocused,
			searchStore = screenProps.searchStore,
			searchQueryStore = searchQueryStore
		})
	end

	v12.Content = createElement4(
		View,
		{ LayoutOrder = 2, ZIndex = 4, tag = "col align-x-center fill gap-small size-full-0" },
		{ SearchBarContainer = nil, MyCreations = v10 }
	)
	local v13 = {
		Page = createElement3(View, {
			tag = FFlagAppThemeHalloween2026BuildBackground and {
				["col align-x-center size-full"] = true,
				["bg-surface-0"] = not v7
			} or "col align-x-center size-full bg-surface-0"
		}, v12),
		PublishSheet = 0
	}
	local publishSheet

	if
		FFlagBuildPublishNavigationSheet
		and v6 ~= nil
		and publishSheetTarget ~= nil
		and publishSheetTarget.universeId ~= nil
	then
		publishSheet = React.createElement(PublishSheetController, {
			isOpen = v6.isPublishSheetOpen,
			target = publishSheetTarget,
			onClose = v6.onClosePublishSheet,
			navigateToSubPage = v6.navigateToPublishSubPage
		})
	end

	v13.PublishSheet = publishSheet
	return createElement2(FullscreenPageWithSafeArea, v11, v13)
end

local function BuildSearchResults(props)
	local v5 = props.searchQueryStore.useDraftQuery()
	local current = props.closingSnapshot.current
	local results

	if current == nil then
		results = props.results
	else
		results = current.results
	end

	local v6

	if current == nil then
		v6 = v5 == "" or v5 ~= results.query or results.isSettledNoResults
	else
		v6 = current.showEmptyState
	end

	if v6 then
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
	local v5 = useBuildPageLayout()
	local v6 = useNavigationFocus()
	local v7 = useOnScreenKeyboardVisible()
	local searchQueryStore = navigation.getParam("searchQueryStore")
		or screenProps.searchQueryStore
		or GetSearchQueryStore()
	local v8 = SignalsReact.useSignalBinding(searchQueryStore.getDraftQuery)
	local v9 = useLocalization({ searchbarPlaceholder = "Feature.Build.Label.SearchGames" })
	local onOpenChat = useOpenBuildChat(navigation) -- inferred equivalent call
	local results = useMyCreationsResults({
		creatorAgentChatStore = screenProps.creatorAgentChatStore,
		configurationStore = screenProps.configurationStore,
		searchStore = screenProps.searchStore,
		searchQueryStore = searchQueryStore,
		isFocused = v6
	})

	local ref = React.useRef(nil)
	local current = ref.current
	local mapped = v8:map(function(p2: string)
		local current2 = ref.current
		return if current2 == nil then p2 else current2.query
	end)
	local v10

	if current == nil then
		v10 = results
	else
		v10 = current.results
	end

	local ref2 = React.useRef(nil)
	useScrollPerformanceTracker("LuaApp_Build_Search_Scroll", ref2)
	local createFooter = React.useCallback(function()
		if v10.isLoadingMore then
			return React.createElement(ExperienceResultsLoadingSkeleton, {
				LayoutOrder = 1,
				index = 1,
				testIdPrefix = "SearchPage"
			})
		end

		return nil
	end, { v10.isLoadingMore })
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
		BackgroundColor3 = v5.tokens.Color.Surface.Surface_0.Color3,
		BackgroundTransparency = v5.tokens.Color.Surface.Surface_0.Transparency,
		includeBottomBar = v5.shouldIncludeBottomBar and not v7,
		includeStatusBar = true
	}, {
		Page = React.createElement(SearchPageContainer, {
			ref = ref2,
			createFooter = createFooter,
			onBack = onBack,
			onCanvasPositionChangedCallback = v10.loadMoreIfNeeded,
			onCanvasSizeChangedCallback = v10.loadMoreIfNeeded,
			refresh = v10.refresh,
			searchBarProps = {
				clear = searchQueryStore.clear,
				onFocusGained = searchQueryStore.beginSearch,
				placeholder = v9.searchbarPlaceholder,
				query = mapped,
				setQuery = searchQueryStore.setQuery,
				shouldFocus = v6
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
	local v5 = useBuildPageLayout()

	local isFocused = not v2 or useNavigationFocus()
	local v6 = useOnScreenKeyboardVisible()
	local state, setState = React.useState(false)
	local state2, setState2 = React.useState(false)

	if FFlagBuildExperienceModelPicker then
		local v7 = SignalsReact.useSignalState(localUserIdStore.getCurrentUserId)

		React.useLayoutEffect(function()
			if target ~= nil and (tonumber(v7) or 0) > 0 then
				local target2 = prepareBuildModelSelectionTarget(target)

				if target2 ~= target then
					navigation.setParams({ target = target2 })
				end
			end
		end, { v7, target, navigation })
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

		local v7 = BuildOverflowMenuScreens.SCREEN_BY_PAGE[p2]

		if v7 == nil then
			return
		end

		navigation.navigate(v7, { target = target })
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
		navigation.navigate(v4.BuildAgents, { target = target })
	end, { navigation, target })
	local onOpenCreatorCreditPage = React.useCallback(function()
		navigation.navigate(v4.BuildCreatorCredit, { target = target })
	end, { navigation, target })

	local navigateToSubPage = React.useCallback(function(p2: string, target2)
		navigation.navigate(p2, { target = target2 })
	end, { navigation })
	local onOpenGetUsersPage

	if FFlagEnableBuildAdPromotion then
		onOpenGetUsersPage = React.useCallback(function()
			navigation.navigate(v4.BuildGetUsers, { target = target })
		end, { navigation, target })
	end

	local onNavigateToResolvedTarget = React.useCallback(function(target2)
		navigation.setParams({ target = target2 })

		buildExperienceRefreshStore.bumpRefreshTick()
	end, { navigation, buildExperienceRefreshStore })
	local page

	if target ~= nil then
		local createElement = React.createElement
		local v7 = {
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

		if not v2 then
			isFocused = nil
		end

		v7.isFocused = isFocused
		page = createElement(BuildChatPage, v7)
	end

	local universeId

	if target ~= nil then
		universeId = target.universeId
	end

	local createElement = React.createElement
	local fragment = React.Fragment
	local v7 = {
		Page = React.createElement(FullscreenPageWithSafeArea, {
			BackgroundColor3 = v5.tokens.Color.Surface.Surface_0.Color3,
			BackgroundTransparency = v5.tokens.Color.Surface.Surface_0.Transparency,
			includeBottomBar = v5.shouldIncludeBottomBar and not v6,
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

	v7.Picker = picker
	local publishSheet

	if FFlagBuildPublishNavigationSheet and target ~= nil and target.universeId ~= nil then
		publishSheet = React.createElement(PublishSheetController, {
			isOpen = state2,
			target = target,
			onClose = onClose2,
			navigateToSubPage = navigateToSubPage
		})
	end

	v7.PublishSheet = publishSheet
	return createElement(fragment, nil, v7)
end

local function BuildAgentsScreen(p)
	local navigation = p.navigation
	local v5 = useBuildPageLayout()
	local v6 = useLiveSubagentTaskState(navigation)
	local agents = useLocalization({ agents = LocalizationStrings.SUBAGENT_STATUS_AGENTS }).agents

	local onClose = React.useCallback(function()
		navigation.goBack()
	end, { navigation })
	local onAgentActivated = React.useCallback(function(p2)
		navigation.navigate(v4.BuildAgentDetails, {
			target = BuildNavigationParams.getTarget(navigation),
			subagentTaskGroupName = p2.name
		})
	end, { navigation })

	local element = React.createElement(SubagentStatus.AgentsList, {
		groups = v6 == nil and {} or v6.groups,
		onAgentActivated = onAgentActivated,
		testId = "BuildPage.AgentsList"
	})

	return React.createElement(
		FullscreenPageWithSafeArea,
		{
			BackgroundColor3 = v5.tokens.Color.Surface.Surface_0.Color3,
			BackgroundTransparency = v5.tokens.Color.Surface.Surface_0.Transparency,
			includeBottomBar = v5.shouldIncludeBottomBar,
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
	local v5 = useBuildPageLayout()
	local v6 = useLiveSubagentTaskState(navigation)
	local subagentTaskGroupName = BuildNavigationParams.getSubagentTaskGroupName(navigation)
	local group = findGroup(v6, subagentTaskGroupName) -- inferred equivalent call
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
			BackgroundColor3 = v5.tokens.Color.Surface.Surface_0.Color3,
			BackgroundTransparency = v5.tokens.Color.Surface.Surface_0.Transparency,
			includeBottomBar = v5.shouldIncludeBottomBar,
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
	local v5 = useBuildPageLayout()
	local pageTitle = useLocalization({ pageTitle = LocalizationStrings.CREATOR_CREDIT_PAGE_TITLE }).pageTitle

	local onClose = React.useCallback(function()
		navigation.goBack()
	end, { navigation })

	local element = React.createElement(CreatorCreditPageContainer, nil)

	return React.createElement(
		FullscreenPageWithSafeArea,
		{
			BackgroundColor3 = v5.tokens.Color.Surface.Surface_0.Color3,
			BackgroundTransparency = v5.tokens.Color.Surface.Surface_0.Transparency,
			includeBottomBar = v5.shouldIncludeBottomBar,
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
	local v5 = useBuildPageLayout()
	local target = BuildNavigationParams.getTarget(navigation)
	local universeId

	if target ~= nil then
		universeId = target.universeId
	end

	local pageTitle = useLocalization({ pageTitle = LocalizationStrings.ADS_STATS_PAGE_TITLE }).pageTitle

	local onClose = React.useCallback(function()
		navigation.goBack()
	end, { navigation })

	local v6 = useAdsStatsPageViewModel(universeId)
	local element = React.createElement(AdsStatsView, v6)
	local state, setState = React.useState(nil)

	local disableScrolling = not (v6.isLoading or v6.isFailed or v6.hasCampaigns)
	local footer

	if not (v6.isLoading or v6.isFailed) then
		local createElement = React.createElement

		local v7 = {
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
		local v8 = {
			text = v6.createButtonText,
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

		if v6.createButtonIsExternal then
			icon = IconName.ArrowUpRightFromSquare
		end

		v8.icon = icon
		v8.size = InputSize.Large
		v8.variant = ButtonVariant.Emphasis
		v8.fillBehavior = FillBehavior.Fill
		v8.width = UDim.new(1, 0)
		v8.isLoading = v6.isPromotionCreatePending
		v8.onActivated = v6.onCreatePrimary
		v7.Actions = createElement2(
			View,
			{
				LayoutOrder = 2,
				tag = "row size-full-0 auto-y padding-y-medium",
				testId = "BuildPage.GetUsers.Actions"
			},
			{ Create = createElement3(Button, v8) }
		)
		footer = createElement(View, {
			tag = "col size-full-0 auto-y",
			testId = "BuildPage.GetUsers.Footer"
		}, v7)
	end

	local createElement = React.createElement
	local v7 = {
		BackgroundColor3 = v5.tokens.Color.Surface.Surface_0.Color3,
		BackgroundTransparency = v5.tokens.Color.Surface.Surface_0.Transparency,
		includeBottomBar = v5.shouldIncludeBottomBar,
		includeStatusBar = true
	}

	local v8 = {
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

	if v6.showCreateSuccessToast and state ~= nil then
		successToast = React.createElement(OverlayProvider, { gui = state }, {
			Toast = React.createElement(AdCampaignCreatedToast, {
				onClose = v6.onDismissCreateSuccessToast,
				testId = "BuildPage.GetUsers.SuccessToast",
				title = v6.createSuccessToastText
			})
		})
	end

	v8.SuccessToast = successToast
	return createElement(FullscreenPageWithSafeArea, v7, v8)
end

local v5 = {
	{
		[v4.BuildHome] = { screen = BuildHomeScreen }
	},
	{
		[v4.BuildChat] = { screen = BuildChatScreen }
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
		[v4.BuildAgents] = { screen = BuildAgentsScreen }
	},
	{
		[v4.BuildAgentDetails] = { screen = BuildAgentDetailsScreen }
	},
	{
		[v4.BuildCreatorCredit] = { screen = BuildCreatorCreditScreen }
	}
}

if FFlagBuildExperienceMonetizationNativeUI then
	local v6 = {
		[BuildOverflowMenuScreens.Screens.BuildMonetization] = { screen = BuildMonetizationScreen }
	}
	table.insert(v5, v6)
end

if FFlagBuildExperienceAnalytics then
	local v6 = {
		[BuildOverflowMenuScreens.Screens.BuildStats] = {
			screen = BuildOverflowMenuScreens.BuildStatsScreen
		}
	}
	table.insert(v5, v6)
end

if FFlagEnableBuildAdPromotion then
	local v6 = {
		[v4.BuildGetUsers] = { screen = BuildGetUsersScreen }
	}
	table.insert(v5, v6)
end

local v6 = {
	[v4.BuildSearch] = { screen = BuildSearchScreen }
}
table.insert(v5, v6)

local robloxStackNavigator = RoactNavigation.createRobloxStackNavigator(v5, {
	initialRouteName = v4.BuildHome
})

local function BuildPage(p)
	useTTINavigationTracking("NavigateTo_" .. p.navigation.state.routeName)

	local param = p.navigation.getParam("extraProps", {})
	local v7 = useBuildPageEligibility.useBuildPageEligibility(v3)

	if FFlagBuildExperienceHideNavBarOnSubPages then
		useManageBuildNavBarVisibility(p.navigation, v4.BuildHome)
	end

	if v7.canEnterBuild then
		return React.createElement(robloxStackNavigator, {
			navigation = p.navigation,
			screenProps = param
		})
	end

	if v7.status == useBuildPageEligibility.Status.Ineligible then
		return React.createElement(BuildEligibilityDialog, {
			variant = useBuildPageEligibility.Status.Ineligible,
			onDismiss = v7.onDialogDismiss
		})
	end

	if v7.status == useBuildPageEligibility.Status.Error then
		return React.createElement(BuildEligibilityDialog, {
			variant = useBuildPageEligibility.Status.Error,
			onDismiss = v7.onDialogDismiss
		})
	end

	if v7.status == useBuildPageEligibility.Status.Refreshing then
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
