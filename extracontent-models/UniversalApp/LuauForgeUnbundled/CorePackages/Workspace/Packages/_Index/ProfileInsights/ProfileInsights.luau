local module = require("@game/CorePackages/Workspace/Packages/_Index/ProfileInsights/ProfileInsights/Formatters")
local module2 = require("@game/CorePackages/Workspace/Packages/_Index/ProfileInsights/ProfileInsights/data-hydration/ProfileInsightsModel")

return {
	Enums = require("@game/CorePackages/Workspace/Packages/_Index/ProfileInsights/ProfileInsights/Enums"),
	Formatters = module,
	ProfileInsightsStore = require("@game/CorePackages/Workspace/Packages/_Index/ProfileInsights/ProfileInsights/data-hydration/ProfileInsightsStore"),
	ProfileInsightsModel = module2,
	useSignalProfileInsightsByUserId = require("@game/CorePackages/Workspace/Packages/_Index/ProfileInsights/ProfileInsights/Hooks/useSignalProfileInsightsByUserId"),
	["data-hydration"] = require("@game/CorePackages/Workspace/Packages/_Index/ProfileInsights/ProfileInsights/data-hydration")
}
