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
local sendBuildExperienceEvent = require(BuildExperience.Telemetry.sendBuildExperienceEvent)
local FFlagBuildExperienceHomeTelemetry = require(BuildExperience.Flags.FFlagBuildExperienceHomeTelemetry)

local BUILD_HOME_TAB = createBuildHomeTabStore.BUILD_HOME_TAB
local useLocalization = Localization.Hooks.useLocalization

local function useBuildHomeTabsViewModel(data)
	local tabStore = data.tabStore or GetBuildHomeTabStore()
	local v = tabStore.useTab()
	local v2 = (data.searchQueryStore or GetSearchQueryStore()).useIsSearchActive()

	local v3 = useLocalization({
		games = LocalizationStrings.BUILD_HOME_TAB_GAMES,
		previews = LocalizationStrings.BUILD_HOME_TAB_PREVIEWS
	})

	local tabs = React.useMemo(function()
		return {
			{ id = BUILD_HOME_TAB.Games, text = v3.games },
			{ id = BUILD_HOME_TAB.Previews, text = v3.previews }
		}
	end, { v3.games, v3.previews })

	local onTabActivated = React.useCallback(function(p)
		if p ~= BUILD_HOME_TAB.Games and p ~= BUILD_HOME_TAB.Previews then
			return
		end

		if FFlagBuildExperienceHomeTelemetry then
			sendBuildExperienceEvent("TAB_CLICK", {}, { tab = tostring(p), context = "build_home" })
		end

		tabStore.setTab(p)
	end, { tabStore })

	local showTabs = not v2

	if not showTabs then
		v = BUILD_HOME_TAB.Games
	end

	local v4 = useBuildHomeTabsPageLayout({ tabs = tabs, activeTab = v, showTabs = showTabs })

	if FFlagBuildExperienceHomeTelemetry then
		local v5 = showTabs and data.isFocused ~= false
		React.useEffect(function()
			if not v5 then
				return
			end

			sendBuildExperienceEvent("TAB_IMPRESSION", {}, { tab = v, context = "build_home" })
		end, { v, v5 })
	end

	return {
		showTabs = showTabs,
		activeTab = v,
		tabs = tabs,
		onTabActivated = onTabActivated,
		pageOffset = v4.pageOffset,
		tabOrder = v4.tabOrder
	}
end

return useBuildHomeTabsViewModel
