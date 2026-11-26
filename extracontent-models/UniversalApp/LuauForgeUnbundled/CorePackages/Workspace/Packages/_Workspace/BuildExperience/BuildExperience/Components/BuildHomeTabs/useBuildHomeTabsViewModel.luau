require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Localization")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")

local createBuildHomeTabStore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Stores/GetBuildHomeTabStore/createBuildHomeTabStore")
local GetBuildHomeTabStore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Stores/GetBuildHomeTabStore")
local GetSearchQueryStore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Stores/GetSearchQueryStore")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Stores/GetSearchQueryStore/createSearchQueryStore")
local LocalizationStrings = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/LocalizationStrings")
local useBuildHomeTabsPageLayout = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/BuildHomeTabs/useBuildHomeTabsPageLayout")
local sendBuildExperienceEvent = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Telemetry/sendBuildExperienceEvent")
local FFlagBuildExperienceHomeTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceHomeTelemetry")

local BUILD_HOME_TAB = createBuildHomeTabStore.BUILD_HOME_TAB
local useLocalization = Localization.Hooks.useLocalization

local function useBuildHomeTabsViewModel(data)
	local tabStore = data.tabStore or GetBuildHomeTabStore()
	local v5 = tabStore.useTab()
	local v6 = (data.searchQueryStore or GetSearchQueryStore()).useIsSearchActive()

	local v7 = useLocalization({
		games = LocalizationStrings.BUILD_HOME_TAB_GAMES,
		previews = LocalizationStrings.BUILD_HOME_TAB_PREVIEWS
	})

	local v8 = React.useMemo(function()
		return {
			{ id = BUILD_HOME_TAB.Games, text = v7.games },
			{ id = BUILD_HOME_TAB.Previews, text = v7.previews }
		}
	end, { v7.games, v7.previews })

	local v9 = React.useCallback(function(p2)
		if p2 ~= BUILD_HOME_TAB.Games and p2 ~= BUILD_HOME_TAB.Previews then
			return
		end

		if FFlagBuildExperienceHomeTelemetry then
			sendBuildExperienceEvent("TAB_CLICK", {}, { tab = tostring(p2), context = "build_home" })
		end

		tabStore.setTab(p2)
	end, { tabStore })

	local v10 = not v6

	if not v10 then
		v5 = BUILD_HOME_TAB.Games
	end

	local v11 = useBuildHomeTabsPageLayout({ tabs = v8, activeTab = v5, showTabs = v10 })

	if FFlagBuildExperienceHomeTelemetry then
		local v12 = v10 and data.isFocused ~= false
		React.useEffect(function()
			if not v12 then
				return
			end

			sendBuildExperienceEvent("TAB_IMPRESSION", {}, { tab = v5, context = "build_home" })
		end, { v5, v12 })
	end

	return {
		showTabs = v10,
		activeTab = v5,
		tabs = v8,
		onTabActivated = v9,
		pageOffset = v11.pageOffset,
		tabOrder = v11.tabOrder
	}
end

return useBuildHomeTabsViewModel
