local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")

local AnalyticsPageEvents = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Analytics/AnalyticsPageEvents")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Analytics/Goals/GoalLockedActionId")

local function useGoalLockedTelemetry(p2, p3, p4, p5)
	local ref = React.useRef({})

	React.useEffect(function()
		if p4 ~= nil then
			local formatted = `{p2}.{p3}.{p4}.primary`

			if not ref.current[formatted] then
				ref.current[formatted] = true
				AnalyticsPageEvents.goalCtaImpression(p2, p3, p4, "primary")
			end
		end

		if p5 ~= nil then
			local formatted = `{p2}.{p3}.{p5}.secondary`

			if not ref.current[formatted] then
				ref.current[formatted] = true
				AnalyticsPageEvents.goalCtaImpression(p2, p3, p5, "secondary")
			end
		end
	end, { p2, p3, p4, p5 })

	return React.useCallback(function(p6, p7)
		AnalyticsPageEvents.goalCtaClick(p2, p3, p7, p6)
	end, { p2, p3 })
end

return useGoalLockedTelemetry
