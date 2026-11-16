local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")

require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Analytics/AnalyticsWindow")
local AnalyticsPageEvents = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Analytics/AnalyticsPageEvents")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Analytics/Goals/useGoalsSectionViewModel")

local function useGoalsSectionTelemetry(p2, p3, p4, items)
	local ref = React.useRef({})

	React.useEffect(function()
		if not p4 then
			return
		end

		for k, item in items do
			local v5 = item.isLocked and "locked" or "unlocked"
			local formatted = `{p2}.{p3}.{item.goal.id}.{v5}`

			if ref.current[formatted] then
				continue
			end

			ref.current[formatted] = true
			AnalyticsPageEvents.goalImpression(p2, item.goal.id, v5, p3)
		end
	end, { p4, items, p2, p3 })
end

return useGoalsSectionTelemetry
