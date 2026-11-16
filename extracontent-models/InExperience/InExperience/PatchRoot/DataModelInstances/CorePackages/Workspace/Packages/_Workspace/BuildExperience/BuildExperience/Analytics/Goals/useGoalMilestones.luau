local parent = script:FindFirstAncestor("BuildExperience").Parent

local SignalsReact = require(parent.SignalsReact)

local CreatorAnalytics = require(parent.DataHydration.CreatorAnalytics)

local v = {}

local function useGoalMilestones(p: number)
	local fetchGoalMilestones = CreatorAnalytics.getGoalMilestonesStore(false).getAndFetchGoalMilestones(p)
	local v2 = SignalsReact.useSignalState(fetchGoalMilestones.data)
	local v3 = SignalsReact.useSignalState(fetchGoalMilestones.status)

	return v2 or v, v2 ~= nil or v3 == "Failed"
end

return useGoalMilestones
