local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local view = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation").View

require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/CreatorAnalytics")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Analytics/AnalyticsWindow")
local GoalCard = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Analytics/Goals/GoalCard")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Analytics/Goals/GoalTypes")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Analytics/Goals/useGoalsSectionViewModel")

local function GoalsSectionView(props)
	local testId = props.testId or "GoalsSection"

	local children = {}

	for k, entry in props.entries do
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
		view,
		{
			LayoutOrder = props.layoutOrder,
			tag = "col gap-xxlarge size-full-0 auto-y",
			testId = testId
		},
		children
	)
end

return GoalsSectionView
