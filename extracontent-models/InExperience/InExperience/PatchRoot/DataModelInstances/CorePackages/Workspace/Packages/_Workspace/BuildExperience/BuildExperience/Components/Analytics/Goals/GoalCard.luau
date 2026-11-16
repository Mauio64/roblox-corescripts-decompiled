local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local View = Foundation.View
local Text = Foundation.Text

require(parent.DataHydration.CreatorAnalytics)
require(BuildExperience.Analytics.AnalyticsWindow)
require(BuildExperience.Analytics.Goals.GoalTypes)
local GoalLockedContent = require(script.Parent.GoalLockedContent)
local GoalMetricRow = require(script.Parent.GoalMetricRow)

local function GoalCard(props)
	local testId = props.testId or "GoalCard"
	local goal = props.goal

	local titleKeysById = { title = goal.titleKey }

	for _, metricSummary in goal.metricSummaries do
		titleKeysById[metricSummary.id] = metricSummary.titleKey
	end

	local v = useLocalization(titleKeysById)

	local children = {}

	for k, metricSummary in goal.metricSummaries do
		local latestAvailableTime

		if props.latestByMetric ~= nil then
			latestAvailableTime = props.latestByMetric[metricSummary.source.query.metric]
		end

		children[metricSummary.id] = React.createElement(GoalMetricRow, {
			title = v[metricSummary.id],
			universeId = props.universeId,
			summary = metricSummary,
			window = props.window,
			latestAvailableTime = latestAvailableTime,
			metadataStatus = props.metadataStatus,
			layoutOrder = k,
			testId = `{testId}.{metricSummary.id}`
		})
	end

	local createElement = React.createElement
	local v2 = {
		LayoutOrder = props.layoutOrder,
		tag = "col gap-large size-full-0 auto-y",
		testId = testId
	}

	local v3 = {
		Heading = React.createElement(Text, {
			LayoutOrder = 1,
			Text = v.title,
			tag = "size-full-0 auto-y text-heading-small text-align-x-left content-emphasis",
			testId = `{testId}.Heading`
		}),
		Card = 0
	}

	local createElement2 = React.createElement
	local onActivated

	if not props.isLocked then
		onActivated = props.onActivated
	end

	v3.Card = createElement2(
		View,
		{
			LayoutOrder = 2,
			onActivated = onActivated,
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
	return createElement(View, v2, v3)
end

return GoalCard
