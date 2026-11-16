local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local React = require(parent.React)

local AnalyticsPageEvents = require(BuildExperience.Analytics.AnalyticsPageEvents)

local function useGoalClickTelemetry(p: number)
	return React.useCallback(function(p2: string)
		AnalyticsPageEvents.goalClick(p, p2)
	end, { p })
end

return useGoalClickTelemetry
