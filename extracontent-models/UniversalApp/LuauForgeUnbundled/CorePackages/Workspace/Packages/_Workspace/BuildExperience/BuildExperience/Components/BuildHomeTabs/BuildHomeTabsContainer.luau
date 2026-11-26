require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")

local FFlagBuildExperienceFoundationTabs = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceFoundationTabs")
local FFlagBuildExperienceHomeTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceHomeTelemetry")

local BuildHomeTabsView = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/BuildHomeTabs/BuildHomeTabsView")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Stores/GetSearchQueryStore/createSearchQueryStore")
local GamesFilter = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Stores/GetMyCreationsFilterStore/GamesFilter")
local GetPreviewsFilterStore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Stores/GetPreviewsFilterStore")
local MyCreationsFilterContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/MyCreationsFilter/MyCreationsFilterContainer")
local PreviewsTabView = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/PreviewsTab/PreviewsTabView")
local useBuildHomeTabsFillBehavior = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/BuildHomeTabs/useBuildHomeTabsFillBehavior")
local useBuildHomeTabsViewModel = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/BuildHomeTabs/useBuildHomeTabsViewModel")
local usePreviewResults = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/PreviewsTab/usePreviewResults")
local usePreviewsTabViewModel = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/PreviewsTab/usePreviewsTabViewModel")

local v5 = { GamesFilter.All, GamesFilter.GroupGames, GamesFilter.SharedGames }
local v6 = { games = GamesFilter.SharedGames }

local function BuildHomeTabsContainer(props)
	local creatorGroupsStore = props.creatorGroupsStore
	local previewsFilterStore = props.previewsFilterStore or GetPreviewsFilterStore()

	local v7 = previewsFilterStore.useFilter()

	local v8 = usePreviewResults({
		searchStore = props.searchStore,
		creatorGroupsStore = creatorGroupsStore,
		filter = v7,
		isFocused = props.isFocused
	})

	local v10 = {
		tabStore = props.tabStore,
		searchQueryStore = props.searchQueryStore,
		isFocused = 0
	}
	local v11 = if FFlagBuildExperienceHomeTelemetry then props.isFocused else nil
	v10.isFocused = v11
	local v12 = useBuildHomeTabsViewModel(v10)

	local v13 = if FFlagBuildExperienceFoundationTabs then useBuildHomeTabsFillBehavior() else nil

	local v14 = usePreviewsTabViewModel({ results = v8 })

	return React.createElement(BuildHomeTabsView, {
		LayoutOrder = props.LayoutOrder,
		showTabs = v12.showTabs,
		activeTab = v12.activeTab,
		tabs = v12.tabs,
		onTabActivated = v12.onTabActivated,
		pageOffset = v12.pageOffset,
		tabOrder = v12.tabOrder,
		tabsFillBehavior = v13,
		gamesContent = props.gamesContent,
		previewsContent = React.createElement(PreviewsTabView, {
			rows = v14.rows,
			listStatus = v14.listStatus,
			loadError = v14.loadError,
			isLoadingMore = v14.isLoadingMore,
			failedLoadMore = v14.failedLoadMore,
			refresh = v14.refresh,
			loadMoreIfNeeded = v14.loadMoreIfNeeded,
			retryLoadMore = v14.retryLoadMore,
			emptyText = v14.emptyText,
			filterHeader = React.createElement(MyCreationsFilterContainer, {
				LayoutOrder = 0,
				filterStore = previewsFilterStore,
				creatorGroupsStore = creatorGroupsStore,
				groups = v8.previewGroups,
				defaultFilter = v6,
				options = v5,
				testId = "PreviewsFilterView"
			})
		})
	})
end

return BuildHomeTabsContainer
