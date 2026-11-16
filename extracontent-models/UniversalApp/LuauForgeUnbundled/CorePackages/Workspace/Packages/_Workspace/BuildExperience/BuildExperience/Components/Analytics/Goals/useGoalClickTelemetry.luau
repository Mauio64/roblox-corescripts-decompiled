local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")

local AnalyticsPageEvents = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Analytics/AnalyticsPageEvents")

local function useGoalClickTelemetry(p2)
	return React.useCallback(function(p3)
		AnalyticsPageEvents.goalClick(p2, p3)
	end, { p2 })
end

return useGoalClickTelemetry
