local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")

local GoalMetricRowView = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Analytics/Goals/GoalMetricRowView")
local useGoalMetricRowViewModel = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Analytics/Goals/useGoalMetricRowViewModel")

local function GoalMetricRow(p2)
	local v5 = useGoalMetricRowViewModel(p2)
	return React.createElement(GoalMetricRowView, v5)
end

return GoalMetricRow
