local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local React = require(parent.React)

local AnalyticsEventContext = require(BuildExperience.Analytics.AnalyticsEventContext)
local AnalyticsPageEvents = require(BuildExperience.Analytics.AnalyticsPageEvents)
require(BuildExperience.Analytics.Goals.GoalLockedActionId)
local FFlagBuildExperienceEventContextTelemetry = require(BuildExperience.Flags.FFlagBuildExperienceEventContextTelemetry)

local function useGoalLockedTelemetry(p: number, p2: string, p3, p4)
	local ref = React.useRef({})
	local v

	if FFlagBuildExperienceEventContextTelemetry then
		v = React.useContext(AnalyticsEventContext)
	else
		v = nil
	end

	React.useEffect(function()
		if p3 ~= nil then
			local formatted = `{p}.{p2}.{p3}.primary`

			if not ref.current[formatted] then
				ref.current[formatted] = true
				AnalyticsPageEvents.goalCtaImpression(p, p2, p3, "primary", v)
			end
		end

		if p4 ~= nil then
			local formatted = `{p}.{p2}.{p4}.secondary`

			if not ref.current[formatted] then
				ref.current[formatted] = true
				AnalyticsPageEvents.goalCtaImpression(p, p2, p4, "secondary", v)
			end
		end
	end, { p, p2, p3, p4, v })

	return React.useCallback(function(p5, p6)
		AnalyticsPageEvents.goalCtaClick(p, p2, p6, p5, v)
	end, { p, p2, v })
end

return useGoalLockedTelemetry
