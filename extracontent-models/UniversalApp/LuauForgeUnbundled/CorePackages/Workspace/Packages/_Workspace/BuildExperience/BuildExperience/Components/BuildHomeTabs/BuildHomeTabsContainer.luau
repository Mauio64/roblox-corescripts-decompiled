require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")

local FFlagBuildExperienceFoundationTabs = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceFoundationTabs")

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

	local v9 = useBuildHomeTabsViewModel({
		tabStore = props.tabStore,
		searchQueryStore = props.searchQueryStore
	})

	local v10 = if FFlagBuildExperienceFoundationTabs then useBuildHomeTabsFillBehavior() else nil

	local v11 = usePreviewsTabViewModel({ results = v8 })

	return React.createElement(BuildHomeTabsView, {
		LayoutOrder = props.LayoutOrder,
		showTabs = v9.showTabs,
		activeTab = v9.activeTab,
		tabs = v9.tabs,
		onTabActivated = v9.onTabActivated,
		pageOffset = v9.pageOffset,
		tabOrder = v9.tabOrder,
		tabsFillBehavior = v10,
		gamesContent = props.gamesContent,
		previewsContent = React.createElement(PreviewsTabView, {
			rows = v11.rows,
			listStatus = v11.listStatus,
			loadError = v11.loadError,
			isLoadingMore = v11.isLoadingMore,
			failedLoadMore = v11.failedLoadMore,
			refresh = v11.refresh,
			loadMoreIfNeeded = v11.loadMoreIfNeeded,
			retryLoadMore = v11.retryLoadMore,
			emptyText = v11.emptyText,
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
