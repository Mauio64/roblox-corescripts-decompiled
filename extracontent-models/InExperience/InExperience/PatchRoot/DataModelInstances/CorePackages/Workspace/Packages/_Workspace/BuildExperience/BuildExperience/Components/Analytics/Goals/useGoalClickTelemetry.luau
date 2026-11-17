local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local React = require(parent.React)

local AnalyticsEventContext = require(BuildExperience.Analytics.AnalyticsEventContext)
local AnalyticsPageEvents = require(BuildExperience.Analytics.AnalyticsPageEvents)
local FFlagBuildExperienceEventContextTelemetry = require(BuildExperience.Flags.FFlagBuildExperienceEventContextTelemetry)

local function useGoalClickTelemetry(p: number)
	local v

	if FFlagBuildExperienceEventContextTelemetry then
		v = React.useContext(AnalyticsEventContext)
	else
		v = nil
	end

	return React.useCallback(function(p2: string)
		AnalyticsPageEvents.goalClick(p, p2, v)
	end, { p, v })
end

return useGoalClickTelemetry
