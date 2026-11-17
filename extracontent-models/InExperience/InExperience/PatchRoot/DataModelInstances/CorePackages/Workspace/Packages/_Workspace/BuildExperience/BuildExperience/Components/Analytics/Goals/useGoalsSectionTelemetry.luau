local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local React = require(parent.React)

require(BuildExperience.Analytics.AnalyticsWindow)
local AnalyticsEventContext = require(BuildExperience.Analytics.AnalyticsEventContext)
local AnalyticsPageEvents = require(BuildExperience.Analytics.AnalyticsPageEvents)
local FFlagBuildExperienceEventContextTelemetry = require(BuildExperience.Flags.FFlagBuildExperienceEventContextTelemetry)
require(script.Parent.useGoalsSectionViewModel)

local function useGoalsSectionTelemetry(p: number, p2, flag: boolean, items)
	local ref = React.useRef({})
	local v

	if FFlagBuildExperienceEventContextTelemetry then
		v = React.useContext(AnalyticsEventContext)
	else
		v = nil
	end

	React.useEffect(function()
		if not flag then
			return
		end

		for _, item in items do
			local v2 = item.isLocked and "locked" or "unlocked"
			local formatted = `{p}.{p2}.{item.goal.id}.{v2}`

			if ref.current[formatted] then
				continue
			end

			ref.current[formatted] = true
			AnalyticsPageEvents.goalImpression(p, item.goal.id, v2, p2, v)
		end
	end, { flag, items, p, p2, v })
end

return useGoalsSectionTelemetry
