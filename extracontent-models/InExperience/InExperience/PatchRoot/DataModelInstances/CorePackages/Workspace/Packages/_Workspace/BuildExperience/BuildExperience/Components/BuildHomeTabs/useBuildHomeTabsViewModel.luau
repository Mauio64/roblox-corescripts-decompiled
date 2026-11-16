local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

require(parent.Foundation)
local Localization = require(parent.Localization)
local React = require(parent.React)

local createBuildHomeTabStore = require(BuildExperience.Stores.GetBuildHomeTabStore.createBuildHomeTabStore)
local GetBuildHomeTabStore = require(BuildExperience.Stores.GetBuildHomeTabStore)
local GetSearchQueryStore = require(BuildExperience.Stores.GetSearchQueryStore)
require(BuildExperience.Stores.GetSearchQueryStore.createSearchQueryStore)
local LocalizationStrings = require(BuildExperience.LocalizationStrings)
local useBuildHomeTabsPageLayout = require(script.Parent.useBuildHomeTabsPageLayout)

local BUILD_HOME_TAB = createBuildHomeTabStore.BUILD_HOME_TAB
local useLocalization = Localization.Hooks.useLocalization

local function useBuildHomeTabsViewModel(p)
	local tabStore = p.tabStore or GetBuildHomeTabStore()
	local activeTab = tabStore.useTab()
	local v = (p.searchQueryStore or GetSearchQueryStore()).useIsSearchActive()

	local v2 = useLocalization({
		games = LocalizationStrings.BUILD_HOME_TAB_GAMES,
		previews = LocalizationStrings.BUILD_HOME_TAB_PREVIEWS
	})

	local tabs = React.useMemo(function()
		return {
			{ id = BUILD_HOME_TAB.Games, text = v2.games },
			{ id = BUILD_HOME_TAB.Previews, text = v2.previews }
		}
	end, { v2.games, v2.previews })

	local onTabActivated = React.useCallback(function(p2)
		if p2 ~= BUILD_HOME_TAB.Games and p2 ~= BUILD_HOME_TAB.Previews then
			return
		end

		tabStore.setTab(p2)
	end, { tabStore })

	local showTabs = not v

	if not showTabs then
		activeTab = BUILD_HOME_TAB.Games
	end

	local v3 = useBuildHomeTabsPageLayout({
		tabs = tabs,
		activeTab = activeTab,
		showTabs = showTabs
	})

	return {
		showTabs = showTabs,
		activeTab = activeTab,
		tabs = tabs,
		onTabActivated = onTabActivated,
		pageOffset = v3.pageOffset,
		tabOrder = v3.tabOrder
	}
end

return useBuildHomeTabsViewModel
