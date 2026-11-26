local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")

require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Analytics/AnalyticsWindow")
local AnalyticsEventContext = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Analytics/AnalyticsEventContext")
local AnalyticsPageEvents = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Analytics/AnalyticsPageEvents")
local FFlagBuildExperienceEventContextTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceEventContextTelemetry")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Analytics/Goals/useGoalsSectionViewModel")

local function useGoalsSectionTelemetry(p2, p3, p4, items)
	local ref = React.useRef({})

	local v5 = if FFlagBuildExperienceEventContextTelemetry then React.useContext(AnalyticsEventContext) else nil

	React.useEffect(function()
		if not p4 then
			return
		end

		for k, item in items do
			local v6 = item.isLocked and "locked" or "unlocked"
			local formatted = `{p2}.{p3}.{item.goal.id}.{v6}`

			if ref.current[formatted] then
				continue
			end

			ref.current[formatted] = true
			AnalyticsPageEvents.goalImpression(p2, item.goal.id, v6, p3, v5)
		end
	end, { p4, items, p2, p3, v5 })
end

return useGoalsSectionTelemetry
