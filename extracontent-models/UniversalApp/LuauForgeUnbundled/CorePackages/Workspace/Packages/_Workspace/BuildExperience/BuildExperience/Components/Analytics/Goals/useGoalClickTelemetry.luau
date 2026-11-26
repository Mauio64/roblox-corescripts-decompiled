local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")

local AnalyticsEventContext = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Analytics/AnalyticsEventContext")
local AnalyticsPageEvents = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Analytics/AnalyticsPageEvents")
local FFlagBuildExperienceEventContextTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceEventContextTelemetry")

local function useGoalClickTelemetry(p2)
	local v5 = if FFlagBuildExperienceEventContextTelemetry then React.useContext(AnalyticsEventContext) else nil

	return React.useCallback(function(p3)
		AnalyticsPageEvents.goalClick(p2, p3, v5)
	end, { p2, v5 })
end

return useGoalClickTelemetry
