require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Analytics/AnalyticsWindow")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Analytics/Goals/GoalLockedActionId")
local sendBuildExperienceEvent = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Telemetry/sendBuildExperienceEvent")

return {
	goalImpression = function(p2, p3, p4, p5)
		sendBuildExperienceEvent("ANALYTICS_PAGE_GOAL_IMPRESSION", { universeId = p2 }, {
			goalId = p3,
			state = p4,
			windowId = p5
		})
	end,
	goalClick = function(p2, p3)
		sendBuildExperienceEvent("ANALYTICS_PAGE_GOAL_CLICK", { universeId = p2 }, { goalId = p3 })
	end,
	goalCtaImpression = function(p2, p3, p4, p5)
		sendBuildExperienceEvent("ANALYTICS_PAGE_GOAL_CTA_IMPRESSION", { universeId = p2 }, {
			goalId = p3,
			actionId = p4,
			slot = p5
		})
	end,
	goalCtaClick = function(p2, p3, p4, p5)
		sendBuildExperienceEvent("ANALYTICS_PAGE_GOAL_CTA_CLICK", { universeId = p2 }, {
			goalId = p3,
			actionId = p4,
			slot = p5
		})
	end
}
