local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Cryo")

require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/CreatorAnalytics")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Analytics/Goals/GoalTypes")

local function isReached(p2, p3)
	return p2.requiredMilestone == nil or p3[p2.requiredMilestone]
end

local function withReachedMilestoneItems(goal, milestones)
	local filtered = Cryo.List.filter(goal.metricSummaries, function(p2)
		return p2.requiredMilestone == nil or milestones[p2.requiredMilestone]
	end)

	local charts = goal.charts
	local filtered2

	if charts ~= nil then
		filtered2 = Cryo.List.filter(charts, function(p2)
			return p2.requiredMilestone == nil or milestones[p2.requiredMilestone]
		end)
	end

	if
		#filtered == #goal.metricSummaries
		and (filtered2 == nil or charts == nil or #filtered2 == #charts)
	then
		return goal
	end

	return Cryo.Dictionary.join(goal, {
		metricSummaries = filtered,
		charts = filtered2
	})
end

local function useGoalsSectionViewModel(data)
	local v5 = false
	local result = {}

	for k, goal in data.goals do
		local v6 = withReachedMilestoneItems(goal, data.milestones)
		v5 = v5 or not data.milestones[v6.unlockMilestone]

		local onGoalSelected = data.onGoalSelected
		table.insert(result, {
			goal = v6,
			isLocked = v5,
			layoutOrder = k,
			onActivated = onGoalSelected ~= nil and v6.charts ~= nil and #v6.charts > 0 and function()
				onGoalSelected(v6)
			end or nil
		})
	end

	return result
end

return useGoalsSectionViewModel
