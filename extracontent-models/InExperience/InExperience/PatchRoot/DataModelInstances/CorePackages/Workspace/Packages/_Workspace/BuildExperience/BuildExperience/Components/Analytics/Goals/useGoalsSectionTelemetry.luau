local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local React = require(parent.React)

require(BuildExperience.Analytics.AnalyticsWindow)
local AnalyticsPageEvents = require(BuildExperience.Analytics.AnalyticsPageEvents)
require(script.Parent.useGoalsSectionViewModel)

local function useGoalsSectionTelemetry(p: number, p2, flag: boolean, items)
	local ref = React.useRef({})

	React.useEffect(function()
		if not flag then
			return
		end

		for _, item in items do
			local v = item.isLocked and "locked" or "unlocked"
			local formatted = `{p}.{p2}.{item.goal.id}.{v}`

			if ref.current[formatted] then
				continue
			end

			ref.current[formatted] = true
			AnalyticsPageEvents.goalImpression(p, item.goal.id, v, p2)
		end
	end, { flag, items, p, p2 })
end

return useGoalsSectionTelemetry
