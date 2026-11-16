local BuildExperience = script:FindFirstAncestor("BuildExperience")

local parent = BuildExperience.Parent

local Cryo = require(parent.Cryo)

require(parent.DataHydration.CreatorAnalytics)
require(BuildExperience.Analytics.Goals.GoalTypes)

local function isReached(p, p2) -- 2 equivalent calls inferred from this helper
	return p.requiredMilestone == nil or p2[p.requiredMilestone]
end

local function withReachedMilestoneItems(goal, milestones)
	local filtered = Cryo.List.filter(goal.metricSummaries, function(p)
		return isReached(p, milestones) -- inferred equivalent call
	end)

	local charts = goal.charts
	local filtered2

	if charts ~= nil then
		filtered2 = Cryo.List.filter(charts, function(p)
			return isReached(p, milestones) -- inferred equivalent call
		end)
	end

	if #filtered == #goal.metricSummaries and (filtered2 == nil or charts == nil or #filtered2 == #charts) then
		return goal
	end

	return Cryo.Dictionary.join(goal, { metricSummaries = filtered, charts = filtered2 })
end

local function useGoalsSectionViewModel(data)
	local isLocked = false
	local result = {}

	for k, goal in data.goals do
		local goal2 = withReachedMilestoneItems(goal, data.milestones)
		isLocked = isLocked or not data.milestones[goal2.unlockMilestone]

		local onGoalSelected = data.onGoalSelected
		table.insert(result, {
			goal = goal2,
			isLocked = isLocked,
			layoutOrder = k,
			onActivated = onGoalSelected ~= nil and goal2.charts ~= nil and #goal2.charts > 0 and function()
				onGoalSelected(goal2)
			end or nil
		})
	end

	return result
end

return useGoalsSectionViewModel
