local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local React = require(parent.React)

local AnalyticsPageEvents = require(BuildExperience.Analytics.AnalyticsPageEvents)
require(BuildExperience.Analytics.Goals.GoalLockedActionId)

local function useGoalLockedTelemetry(p: number, p2: string, p3, p4)
	local ref = React.useRef({})

	React.useEffect(function()
		if p3 ~= nil then
			local formatted = `{p}.{p2}.{p3}.primary`

			if not ref.current[formatted] then
				ref.current[formatted] = true
				AnalyticsPageEvents.goalCtaImpression(p, p2, p3, "primary")
			end
		end

		if p4 ~= nil then
			local formatted = `{p}.{p2}.{p4}.secondary`

			if not ref.current[formatted] then
				ref.current[formatted] = true
				AnalyticsPageEvents.goalCtaImpression(p, p2, p4, "secondary")
			end
		end
	end, { p, p2, p3, p4 })

	return React.useCallback(function(p5, p6)
		AnalyticsPageEvents.goalCtaClick(p, p2, p6, p5)
	end, { p, p2 })
end

return useGoalLockedTelemetry
