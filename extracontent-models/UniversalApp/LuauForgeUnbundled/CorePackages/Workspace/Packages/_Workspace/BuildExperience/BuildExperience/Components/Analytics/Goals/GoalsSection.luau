local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")

require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/CreatorAnalytics")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Analytics/AnalyticsWindow")
local useMetricMetadata = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Analytics/useMetricMetadata")
local module3 = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Analytics/Goals/Goals")
local useGoalMilestones = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Analytics/Goals/useGoalMilestones")
local GoalsSectionView = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Analytics/Goals/GoalsSectionView")
local useGoalLockedActions = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Analytics/Goals/useGoalLockedActions")
local useGoalClickTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Analytics/Goals/useGoalClickTelemetry")
local useGoalsSectionTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Analytics/Goals/useGoalsSectionTelemetry")
local useGoalsSectionViewModel = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Analytics/Goals/useGoalsSectionViewModel")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Analytics/Goals/GoalTypes")
local MetricDetailSheet = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Analytics/MetricDetailSheet/MetricDetailSheet")

local set = {}
local v5 = {}

for k, goal in module3.Goals do
	for k2, metricSummary in goal.metricSummaries do
		if set[metricSummary.source.query.metric] then
			continue
		end

		set[metricSummary.source.query.metric] = true
		table.insert(v5, metricSummary.source.query.metric)
	end

	if goal.charts == nil then
		continue
	end

	for k2, chart in goal.charts do
		if set[chart.id] then
			continue
		end

		set[chart.id] = true
		table.insert(v5, chart.id)
	end
end

local function GoalsSection(props)
	local testId = props.testId or "GoalsSection"
	local v6 = useMetricMetadata(v5)
	local v7, v8 = useGoalMilestones(props.universeId)

	local state, setState = React.useState(nil)
	local v9 = React.useCallback(function()
		setState(nil)
	end, {})
	local universeId = props.universeId
	local id = props.window.id
	local v10 = useGoalClickTelemetry(universeId)
	local v11 = React.useCallback(function(p2)
		v10(p2.id)
		setState(p2)
	end, { v10 })

	local v12 = useGoalsSectionViewModel({ goals = module3.Goals, milestones = v7, onGoalSelected = v11 })

	local v13 = useGoalLockedActions(props.universeId)
	local overlays = {}
	local v14 = false

	for k, action in v13.actions do
		overlays[k] = action.overlay
		v14 = v14 or action.isLoading == true
	end

	local v15 = v8 and not v14
	useGoalsSectionTelemetry(universeId, id, v15, v12)

	local element = React.createElement(GoalsSectionView, {
		entries = not v15 and {} or v12,
		universeId = props.universeId,
		window = props.window,
		latestByMetric = v6.latestByMetric,
		metadataStatus = v6.status,
		lockedActions = v13.actions,
		layoutOrder = props.layoutOrder,
		testId = testId
	})

	local createElement = React.createElement
	local fragment = React.Fragment
	local v17 = {
		Goals = element,
		ActionOverlays = React.createElement(React.Fragment, nil, overlays),
		Sheet = 0
	}

	local v18 = if state ~= nil then React.createElement(MetricDetailSheet, {
		metrics = state.charts,
		titleKey = state.titleKey,
		universeId = props.universeId,
		window = props.window,
		latestByMetric = v6.latestByMetric,
		metadataStatus = v6.status,
		onClose = v9,
		onOpenChat = props.onOpenChat,
		testId = `{testId}.Sheet`
	}) else nil
	v17.Sheet = v18
	return createElement(fragment, nil, v17)
end

return GoalsSection
