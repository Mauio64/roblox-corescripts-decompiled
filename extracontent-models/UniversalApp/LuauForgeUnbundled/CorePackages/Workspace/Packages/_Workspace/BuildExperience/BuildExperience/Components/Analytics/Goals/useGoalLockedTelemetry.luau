local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")

local AnalyticsEventContext = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Analytics/AnalyticsEventContext")
local AnalyticsPageEvents = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Analytics/AnalyticsPageEvents")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Analytics/Goals/GoalLockedActionId")
local FFlagBuildExperienceEventContextTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceEventContextTelemetry")

local function useGoalLockedTelemetry(p2, p3, p4, p5)
	local ref = React.useRef({})

	local v5 = if FFlagBuildExperienceEventContextTelemetry then React.useContext(AnalyticsEventContext) else nil

	React.useEffect(function()
		if p4 ~= nil then
			local formatted = `{p2}.{p3}.{p4}.primary`

			if not ref.current[formatted] then
				ref.current[formatted] = true
				AnalyticsPageEvents.goalCtaImpression(p2, p3, p4, "primary", v5)
			end
		end

		if p5 ~= nil then
			local formatted = `{p2}.{p3}.{p5}.secondary`

			if not ref.current[formatted] then
				ref.current[formatted] = true
				AnalyticsPageEvents.goalCtaImpression(p2, p3, p5, "secondary", v5)
			end
		end
	end, { p2, p3, p4, p5, v5 })

	return React.useCallback(function(p6, p7)
		AnalyticsPageEvents.goalCtaClick(p2, p3, p7, p6, v5)
	end, { p2, p3, v5 })
end

return useGoalLockedTelemetry
