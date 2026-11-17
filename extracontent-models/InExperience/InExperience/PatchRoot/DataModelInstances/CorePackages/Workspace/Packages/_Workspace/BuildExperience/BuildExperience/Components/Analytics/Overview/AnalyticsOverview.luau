local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local React = require(parent.React)

local AnalyticsEventContext = require(BuildExperience.Analytics.AnalyticsEventContext)
require(BuildExperience.Analytics.AnalyticsMetric)
require(BuildExperience.Analytics.AnalyticsPageEvents)
local AnalyticsWindow = require(BuildExperience.Analytics.AnalyticsWindow)
local FFlagBuildCheckGamePermissions = require(BuildExperience.Flags.FFlagBuildCheckGamePermissions)
local FFlagBuildExperienceEventContextTelemetry = require(BuildExperience.Flags.FFlagBuildExperienceEventContextTelemetry)
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
	local v2

	if FFlagBuildExperienceEventContextTelemetry then
		v2 = React.useMemo(function()
			return { placeId = props.placeId, conversationId = props.conversationId }
		end, { props.placeId, props.conversationId })
	end

	local onOpenChat = props.onOpenChat

	if FFlagBuildCheckGamePermissions and not useGamePermissions({ universeId = props.universeId }).canEditOnBuild then
		onOpenChat = nil
	end

	local element = React.createElement(AnalyticsOverviewView, {
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

	if v2 == nil then
		return element
	end

	return (React.createElement(AnalyticsEventContext.Provider, { value = v2 }, element))
end

return AnalyticsOverview
