local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local React = require(parent.React)

require(parent.DataHydration.CreatorAnalytics)
require(BuildExperience.Analytics.AnalyticsWindow)
local useMetricMetadata = require(BuildExperience.Analytics.useMetricMetadata)
local Goals = require(BuildExperience.Analytics.Goals.Goals)
local useGoalMilestones = require(BuildExperience.Analytics.Goals.useGoalMilestones)
local GoalsSectionView = require(script.Parent.GoalsSectionView)
local useGoalLockedActions = require(script.Parent.useGoalLockedActions)
local useGoalClickTelemetry = require(script.Parent.useGoalClickTelemetry)
local useGoalsSectionTelemetry = require(script.Parent.useGoalsSectionTelemetry)
local useGoalsSectionViewModel = require(script.Parent.useGoalsSectionViewModel)
require(BuildExperience.Analytics.Goals.GoalTypes)
local MetricDetailSheet = require(BuildExperience.Components.Analytics.MetricDetailSheet.MetricDetailSheet)

local set = {}
local v = {}

for _, goal in Goals.Goals do
	for _, metricSummary in goal.metricSummaries do
		if set[metricSummary.source.query.metric] then
			continue
		end

		set[metricSummary.source.query.metric] = true
		table.insert(v, metricSummary.source.query.metric)
	end

	if goal.charts == nil then
		continue
	end

	for _, chart in goal.charts do
		if set[chart.id] then
			continue
		end

		set[chart.id] = true
		table.insert(v, chart.id)
	end
end

local function GoalsSection(props)
	local testId = props.testId or "GoalsSection"
	local v2 = useMetricMetadata(v)
	local milestones, v3 = useGoalMilestones(props.universeId)

	local state, setState = React.useState(nil)
	local onClose = React.useCallback(function()
		setState(nil)
	end, {})
	local universeId = props.universeId
	local id = props.window.id
	local v4 = useGoalClickTelemetry(universeId)
	local onGoalSelected = React.useCallback(function(p)
		v4(p.id)
		setState(p)
	end, { v4 })

	local v5 = useGoalsSectionViewModel({
		goals = Goals.Goals,
		milestones = milestones,
		onGoalSelected = onGoalSelected
	})

	local v6 = useGoalLockedActions(props.universeId)
	local overlays = {}
	local v7 = false

	for k, action in v6.actions do
		overlays[k] = action.overlay
		v7 = v7 or action.isLoading == true
	end

	local v8 = v3 and not v7
	useGoalsSectionTelemetry(universeId, id, v8, v5)

	local element = React.createElement(GoalsSectionView, {
		entries = not v8 and {} or v5,
		universeId = props.universeId,
		window = props.window,
		latestByMetric = v2.latestByMetric,
		metadataStatus = v2.status,
		lockedActions = v6.actions,
		layoutOrder = props.layoutOrder,
		testId = testId
	})

	local createElement = React.createElement
	local fragment = React.Fragment
	local v9 = {
		Goals = element,
		ActionOverlays = React.createElement(React.Fragment, nil, overlays),
		Sheet = 0
	}
	local sheet

	if state ~= nil then
		sheet = React.createElement(MetricDetailSheet, {
			metrics = state.charts,
			titleKey = state.titleKey,
			universeId = props.universeId,
			window = props.window,
			latestByMetric = v2.latestByMetric,
			metadataStatus = v2.status,
			onClose = onClose,
			onOpenChat = props.onOpenChat,
			testId = `{testId}.Sheet`
		})
	end

	v9.Sheet = sheet
	return createElement(fragment, nil, v9)
end

return GoalsSection
