local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

require(parent.Foundation)
local React = require(parent.React)

local FFlagBuildExperienceFoundationTabs = require(BuildExperience.Flags.FFlagBuildExperienceFoundationTabs)
local FFlagBuildExperienceHomeTelemetry = require(BuildExperience.Flags.FFlagBuildExperienceHomeTelemetry)

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

	local v = {
		tabStore = props.tabStore,
		searchQueryStore = props.searchQueryStore,
		isFocused = 0
	}
	local isFocused

	if FFlagBuildExperienceHomeTelemetry then
		isFocused = props.isFocused
	end

	v.isFocused = isFocused
	local v2 = useBuildHomeTabsViewModel(v)
	local tabsFillBehavior

	if FFlagBuildExperienceFoundationTabs then
		tabsFillBehavior = useBuildHomeTabsFillBehavior()
	end

	local v3 = usePreviewsTabViewModel({ results = results })

	return React.createElement(BuildHomeTabsView, {
		LayoutOrder = props.LayoutOrder,
		showTabs = v2.showTabs,
		activeTab = v2.activeTab,
		tabs = v2.tabs,
		onTabActivated = v2.onTabActivated,
		pageOffset = v2.pageOffset,
		tabOrder = v2.tabOrder,
		tabsFillBehavior = tabsFillBehavior,
		gamesContent = props.gamesContent,
		previewsContent = React.createElement(PreviewsTabView, {
			rows = v3.rows,
			listStatus = v3.listStatus,
			loadError = v3.loadError,
			isLoadingMore = v3.isLoadingMore,
			failedLoadMore = v3.failedLoadMore,
			refresh = v3.refresh,
			loadMoreIfNeeded = v3.loadMoreIfNeeded,
			retryLoadMore = v3.retryLoadMore,
			emptyText = v3.emptyText,
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
