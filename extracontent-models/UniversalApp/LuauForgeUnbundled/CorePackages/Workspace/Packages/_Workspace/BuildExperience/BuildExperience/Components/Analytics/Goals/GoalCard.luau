local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Localization").Hooks.useLocalization

local view = Foundation.View
local text = Foundation.Text

require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/CreatorAnalytics")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Analytics/AnalyticsWindow")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Analytics/Goals/GoalTypes")
local GoalLockedContent = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Analytics/Goals/GoalLockedContent")
local GoalMetricRow = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Analytics/Goals/GoalMetricRow")

local function GoalCard(props)
	local testId = props.testId or "GoalCard"
	local goal = props.goal

	local titleKeysById = { title = goal.titleKey }

	for k, metricSummary in goal.metricSummaries do
		titleKeysById[metricSummary.id] = metricSummary.titleKey
	end

	local v5 = useLocalization(titleKeysById)

	local children = {}

	for k, metricSummary in goal.metricSummaries do
		local v6

		if props.latestByMetric ~= nil then
			v6 = props.latestByMetric[metricSummary.source.query.metric]
		end

		children[metricSummary.id] = React.createElement(GoalMetricRow, {
			title = v5[metricSummary.id],
			universeId = props.universeId,
			summary = metricSummary,
			window = props.window,
			latestAvailableTime = v6,
			metadataStatus = props.metadataStatus,
			layoutOrder = k,
			testId = `{testId}.{metricSummary.id}`
		})
	end

	local createElement = React.createElement
	local v7 = {
		LayoutOrder = props.layoutOrder,
		tag = "col gap-large size-full-0 auto-y",
		testId = testId
	}

	local v8 = {
		Heading = React.createElement(text, {
			LayoutOrder = 1,
			Text = v5.title,
			tag = "size-full-0 auto-y text-heading-small text-align-x-left content-emphasis",
			testId = `{testId}.Heading`
		}),
		Card = 0
	}

	local createElement2 = React.createElement

	local v11 = if not props.isLocked then props.onActivated else nil
	v8.Card = createElement2(
		view,
		{
			LayoutOrder = 2,
			onActivated = v11,
			tag = "col gap-large size-full-0 auto-y padding-large stroke-standard stroke-default radius-large",
			testId = `{testId}.Card`
		},
		props.isLocked and {
			Locked = React.createElement(GoalLockedContent, {
				locked = goal.locked,
				actionHandlers = props.lockedActions,
				goalId = goal.id,
				universeId = props.universeId,
				testId = `{testId}.Locked`
			})
		} or children
	)
	return createElement(view, v7, v8)
end

return GoalCard
