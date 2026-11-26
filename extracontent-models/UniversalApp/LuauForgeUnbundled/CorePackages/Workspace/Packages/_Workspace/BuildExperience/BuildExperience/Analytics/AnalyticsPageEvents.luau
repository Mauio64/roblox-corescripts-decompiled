require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Analytics/AnalyticsWindow")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Analytics/Goals/GoalLockedActionId")
local sendBuildExperienceEvent = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Telemetry/sendBuildExperienceEvent")
local FFlagBuildExperienceEventContextTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceEventContextTelemetry")

local function getGranularity(p2, p3)
	local v5 = if p3 ~= nil then p3.placeId else nil
	local v6 = if p3 ~= nil then p3.conversationId else nil
	return { universeId = p2, placeId = v5, conversationId = v6 }
end

return {
	goalImpression = function(p2, p3, p4, p5, p6)
		local v8

		if FFlagBuildExperienceEventContextTelemetry then
			v8 = { universeId = p2, placeId = 0, conversationId = 0 }

			local v9 = if p6 ~= nil then p6.placeId else nil
			v8.placeId = v9
			local v10 = if p6 ~= nil then p6.conversationId else nil
			v8.conversationId = v10
		else
			v8 = { universeId = p2 }
		end

		sendBuildExperienceEvent("ANALYTICS_PAGE_GOAL_IMPRESSION", v8, {
			goalId = p3,
			state = p4,
			windowId = p5
		})
	end,
	goalClick = function(p2, p3, p4)
		local v7

		if FFlagBuildExperienceEventContextTelemetry then
			v7 = { universeId = p2, placeId = 0, conversationId = 0 }

			local v8 = if p4 ~= nil then p4.placeId else nil
			v7.placeId = v8
			local v9 = if p4 ~= nil then p4.conversationId else nil
			v7.conversationId = v9
		else
			v7 = { universeId = p2 }
		end

		sendBuildExperienceEvent("ANALYTICS_PAGE_GOAL_CLICK", v7, { goalId = p3 })
	end,
	goalCtaImpression = function(p2, p3, p4, p5, p6)
		local v8

		if FFlagBuildExperienceEventContextTelemetry then
			v8 = { universeId = p2, placeId = 0, conversationId = 0 }

			local v9 = if p6 ~= nil then p6.placeId else nil
			v8.placeId = v9
			local v10 = if p6 ~= nil then p6.conversationId else nil
			v8.conversationId = v10
		else
			v8 = { universeId = p2 }
		end

		sendBuildExperienceEvent("ANALYTICS_PAGE_GOAL_CTA_IMPRESSION", v8, {
			goalId = p3,
			actionId = p4,
			slot = p5
		})
	end,
	goalCtaClick = function(p2, p3, p4, p5, p6)
		local v8

		if FFlagBuildExperienceEventContextTelemetry then
			v8 = { universeId = p2, placeId = 0, conversationId = 0 }

			local v9 = if p6 ~= nil then p6.placeId else nil
			v8.placeId = v9
			local v10 = if p6 ~= nil then p6.conversationId else nil
			v8.conversationId = v10
		else
			v8 = { universeId = p2 }
		end

		sendBuildExperienceEvent("ANALYTICS_PAGE_GOAL_CTA_CLICK", v8, {
			goalId = p3,
			actionId = p4,
			slot = p5
		})
	end
}
