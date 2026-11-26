local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")

local AnalyticsEventContext = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Analytics/AnalyticsEventContext")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Analytics/AnalyticsMetric")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Analytics/AnalyticsPageEvents")
local AnalyticsWindow = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Analytics/AnalyticsWindow")
local FFlagBuildCheckGamePermissions = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildCheckGamePermissions")
local FFlagBuildExperienceEventContextTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceEventContextTelemetry")
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
	local v8

	if FFlagBuildExperienceEventContextTelemetry then
		v8 = React.useMemo(function()
			return { placeId = props.placeId, conversationId = props.conversationId }
		end, { props.placeId, props.conversationId })
	end

	local onOpenChat = props.onOpenChat

	if FFlagBuildCheckGamePermissions and not useGamePermissions({ universeId = props.universeId }).canEditOnBuild then
		onOpenChat = nil
	end

	local element = React.createElement(AnalyticsOverviewView, {
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

	if v8 == nil then
		return element
	end

	return React.createElement(AnalyticsEventContext.Provider, { value = v8 }, element)
end

return AnalyticsOverview
