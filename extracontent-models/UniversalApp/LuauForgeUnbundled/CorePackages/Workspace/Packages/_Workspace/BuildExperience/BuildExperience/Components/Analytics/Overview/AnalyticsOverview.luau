local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")

require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Analytics/AnalyticsMetric")
local AnalyticsWindow = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Analytics/AnalyticsWindow")
local FFlagBuildCheckGamePermissions = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildCheckGamePermissions")
local AnalyticsOverviewView = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Analytics/Overview/AnalyticsOverviewView")
local useAnalyticsOverviewViewModel = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Analytics/Overview/useAnalyticsOverviewViewModel")
local useGamePermissions = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/useGamePermissions")

local function AnalyticsOverview(props)
	local state, setState = React.useState(props.initialWindowId or AnalyticsWindow.DEFAULT_WINDOW_ID)
	local state2, setState2 = React.useState(nil)

	local initialMetricId = props.initialMetricId or "UniqueUsersWithPlaySessions"
	local v5 = AnalyticsWindow.WindowById[state] or AnalyticsWindow.LastWeek

	local v6 = useAnalyticsOverviewViewModel(props.universeId, v5, initialMetricId, state2, setState2)

	local v7 = React.useCallback(function()
		setState2(nil)
	end, {})
	local onOpenChat = props.onOpenChat

	if FFlagBuildCheckGamePermissions and not useGamePermissions({ universeId = props.universeId }).canEditOnBuild then
		onOpenChat = nil
	end

	return React.createElement(AnalyticsOverviewView, {
		overviewTitle = v6.overviewTitle,
		keyStatsTitle = v6.keyStatsTitle,
		instantStats = v6.instantStats,
		statsCards = v6.statsCards,
		windows = v6.windows,
		selectedWindowId = state,
		onWindowSelected = setState,
		universeId = props.universeId,
		window = v5,
		sheet = v6.sheet,
		onSheetClose = v7,
		onOpenChat = onOpenChat,
		layoutOrder = props.layoutOrder,
		testId = props.testId
	})
end

return AnalyticsOverview
