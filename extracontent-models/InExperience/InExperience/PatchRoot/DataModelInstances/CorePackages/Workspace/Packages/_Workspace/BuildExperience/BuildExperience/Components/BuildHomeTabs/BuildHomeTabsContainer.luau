local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

require(parent.Foundation)
local React = require(parent.React)

local FFlagBuildExperienceFoundationTabs = require(BuildExperience.Flags.FFlagBuildExperienceFoundationTabs)

local BuildHomeTabsView = require(script.Parent.BuildHomeTabsView)
require(BuildExperience.Stores.GetSearchQueryStore.createSearchQueryStore)
local GamesFilter = require(BuildExperience.Stores.GetMyCreationsFilterStore.GamesFilter)
local GetPreviewsFilterStore = require(BuildExperience.Stores.GetPreviewsFilterStore)
local MyCreationsFilterContainer = require(BuildExperience.Components.MyCreationsFilter.MyCreationsFilterContainer)
local PreviewsTabView = require(BuildExperience.Components.PreviewsTab.PreviewsTabView)
local useBuildHomeTabsFillBehavior = require(script.Parent.useBuildHomeTabsFillBehavior)
local useBuildHomeTabsViewModel = require(script.Parent.useBuildHomeTabsViewModel)
local usePreviewResults = require(BuildExperience.Components.PreviewsTab.usePreviewResults)
local usePreviewsTabViewModel = require(BuildExperience.Components.PreviewsTab.usePreviewsTabViewModel)

local options = { GamesFilter.All, GamesFilter.GroupGames, GamesFilter.SharedGames }
local defaultFilter = { games = GamesFilter.SharedGames }

local function BuildHomeTabsContainer(props)
	local creatorGroupsStore = props.creatorGroupsStore
	local previewsFilterStore = props.previewsFilterStore or GetPreviewsFilterStore()

	local filter = previewsFilterStore.useFilter()

	local results = usePreviewResults({
		searchStore = props.searchStore,
		creatorGroupsStore = creatorGroupsStore,
		filter = filter,
		isFocused = props.isFocused
	})

	local v = useBuildHomeTabsViewModel({
		tabStore = props.tabStore,
		searchQueryStore = props.searchQueryStore
	})
	local tabsFillBehavior

	if FFlagBuildExperienceFoundationTabs then
		tabsFillBehavior = useBuildHomeTabsFillBehavior()
	end

	local v2 = usePreviewsTabViewModel({ results = results })

	return React.createElement(BuildHomeTabsView, {
		LayoutOrder = props.LayoutOrder,
		showTabs = v.showTabs,
		activeTab = v.activeTab,
		tabs = v.tabs,
		onTabActivated = v.onTabActivated,
		pageOffset = v.pageOffset,
		tabOrder = v.tabOrder,
		tabsFillBehavior = tabsFillBehavior,
		gamesContent = props.gamesContent,
		previewsContent = React.createElement(PreviewsTabView, {
			rows = v2.rows,
			listStatus = v2.listStatus,
			loadError = v2.loadError,
			isLoadingMore = v2.isLoadingMore,
			failedLoadMore = v2.failedLoadMore,
			refresh = v2.refresh,
			loadMoreIfNeeded = v2.loadMoreIfNeeded,
			retryLoadMore = v2.retryLoadMore,
			emptyText = v2.emptyText,
			filterHeader = React.createElement(MyCreationsFilterContainer, {
				LayoutOrder = 0,
				filterStore = previewsFilterStore,
				creatorGroupsStore = creatorGroupsStore,
				groups = results.previewGroups,
				defaultFilter = defaultFilter,
				options = options,
				testId = "PreviewsFilterView"
			})
		})
	})
end

return BuildHomeTabsContainer
