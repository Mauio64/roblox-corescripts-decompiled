local module = require("@game/CorePackages/Workspace/Packages/_Index/ProfileInsights/ProfileInsights/data-hydration/ProfileInsightsModel")

return {
	ProfileInsightsStore = require("@game/CorePackages/Workspace/Packages/_Index/ProfileInsights/ProfileInsights/data-hydration/ProfileInsightsStore"),
	ProfileInsightsModel = module,
	useSignalProfileInsightsByUserId = require("@game/CorePackages/Workspace/Packages/_Index/ProfileInsights/ProfileInsights/Hooks/useSignalProfileInsightsByUserId"),
	["data-hydration"] = require("@game/CorePackages/Workspace/Packages/_Index/ProfileInsights/ProfileInsights/data-hydration")
}
