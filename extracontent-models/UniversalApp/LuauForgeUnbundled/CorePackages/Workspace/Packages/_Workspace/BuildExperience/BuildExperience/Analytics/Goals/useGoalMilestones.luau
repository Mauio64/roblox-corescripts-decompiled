local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SignalsReact")

local CreatorAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/CreatorAnalytics")

local v5 = {}

local function useGoalMilestones(p2)
	local fetchGoalMilestones = CreatorAnalytics.getGoalMilestonesStore(false).getAndFetchGoalMilestones(p2)
	local v6 = SignalsReact.useSignalState(fetchGoalMilestones.data)
	local v7 = SignalsReact.useSignalState(fetchGoalMilestones.status)

	return v6 or v5, v6 ~= nil or v7 == "Failed"
end

return useGoalMilestones
