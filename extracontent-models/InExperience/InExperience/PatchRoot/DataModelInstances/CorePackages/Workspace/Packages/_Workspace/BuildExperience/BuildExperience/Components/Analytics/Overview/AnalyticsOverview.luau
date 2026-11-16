local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local React = require(parent.React)

require(BuildExperience.Analytics.AnalyticsMetric)
local AnalyticsWindow = require(BuildExperience.Analytics.AnalyticsWindow)
local FFlagBuildCheckGamePermissions = require(BuildExperience.Flags.FFlagBuildCheckGamePermissions)
local AnalyticsOverviewView = require(script.Parent.AnalyticsOverviewView)
local useAnalyticsOverviewViewModel = require(script.Parent.useAnalyticsOverviewViewModel)
local useGamePermissions = require(BuildExperience.useGamePermissions)

local function AnalyticsOverview(props)
	local state, setState = React.useState(props.initialWindowId or AnalyticsWindow.DEFAULT_WINDOW_ID)
	local state2, setState2 = React.useState(nil)

	local initialMetricId = props.initialMetricId or "UniqueUsersWithPlaySessions"
	local window = AnalyticsWindow.WindowById[state] or AnalyticsWindow.LastWeek

	local v = useAnalyticsOverviewViewModel(props.universeId, window, initialMetricId, state2, setState2)

	local onSheetClose = React.useCallback(function()
		setState2(nil)
	end, {})
	local onOpenChat = props.onOpenChat

	if FFlagBuildCheckGamePermissions and not useGamePermissions({ universeId = props.universeId }).canEditOnBuild then
		onOpenChat = nil
	end

	return React.createElement(AnalyticsOverviewView, {
		overviewTitle = v.overviewTitle,
		keyStatsTitle = v.keyStatsTitle,
		instantStats = v.instantStats,
		statsCards = v.statsCards,
		windows = v.windows,
		selectedWindowId = state,
		onWindowSelected = setState,
		universeId = props.universeId,
		window = window,
		sheet = v.sheet,
		onSheetClose = onSheetClose,
		onOpenChat = onOpenChat,
		layoutOrder = props.layoutOrder,
		testId = props.testId
	})
end

return AnalyticsOverview
