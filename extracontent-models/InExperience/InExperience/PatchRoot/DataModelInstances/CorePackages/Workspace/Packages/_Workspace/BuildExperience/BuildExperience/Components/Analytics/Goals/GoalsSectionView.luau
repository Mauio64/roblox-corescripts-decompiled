local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)

local View = Foundation.View

require(parent.DataHydration.CreatorAnalytics)
require(BuildExperience.Analytics.AnalyticsWindow)
local GoalCard = require(script.Parent.GoalCard)
require(BuildExperience.Analytics.Goals.GoalTypes)
require(script.Parent.useGoalsSectionViewModel)

local function GoalsSectionView(props)
	local testId = props.testId or "GoalsSection"

	local children = {}

	for _, entry in props.entries do
		local goal = entry.goal
		children[goal.id] = React.createElement(GoalCard, {
			onActivated = entry.onActivated,
			goal = goal,
			universeId = props.universeId,
			window = props.window,
			latestByMetric = props.latestByMetric,
			metadataStatus = props.metadataStatus,
			isLocked = entry.isLocked,
			lockedActions = props.lockedActions,
			layoutOrder = entry.layoutOrder,
			testId = `{testId}.{goal.id}`
		})
	end

	return React.createElement(
		View,
		{
			LayoutOrder = props.layoutOrder,
			tag = "col gap-xxlarge size-full-0 auto-y",
			testId = testId
		},
		children
	)
end

return GoalsSectionView
