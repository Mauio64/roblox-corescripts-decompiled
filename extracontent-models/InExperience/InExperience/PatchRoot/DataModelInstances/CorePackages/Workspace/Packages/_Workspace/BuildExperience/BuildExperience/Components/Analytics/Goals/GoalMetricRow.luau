local parent = script:FindFirstAncestor("BuildExperience").Parent

local React = require(parent.React)

local GoalMetricRowView = require(script.Parent.GoalMetricRowView)
local useGoalMetricRowViewModel = require(script.Parent.useGoalMetricRowViewModel)

local function GoalMetricRow(p)
	local v = useGoalMetricRowViewModel(p)
	return React.createElement(GoalMetricRowView, v)
end

return GoalMetricRow
