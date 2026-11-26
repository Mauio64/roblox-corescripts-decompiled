local SetAliasAnalyticsContext = require("@game/CorePackages/Workspace/Packages/_Index/SetAlias/SetAlias/Analytics/SetAliasAnalyticsContext")
local context = require("@game/CorePackages/Workspace/Packages/_Index/SetAlias/SetAlias/dependencies").SocialLibraries.Context

return {
	AnalyticsService = require("@game/CorePackages/Workspace/Packages/_Index/SetAlias/SetAlias/Analytics/AnalyticsService"),
	Context = SetAliasAnalyticsContext,
	connect = context.getConnect(SetAliasAnalyticsContext),
	EventNames = require("@game/CorePackages/Workspace/Packages/_Index/SetAlias/SetAlias/Analytics/Enums/EventNames"),
	EntryPoints = require("@game/CorePackages/Workspace/Packages/_Index/SetAlias/SetAlias/Analytics/Enums/EntryPoints"),
	setupFireAnalyticsEvents = require("@game/CorePackages/Workspace/Packages/_Index/SetAlias/SetAlias/Analytics/setupFireAnalyticsEvents"),
	useAnalytics = require("@game/CorePackages/Workspace/Packages/_Index/SetAlias/SetAlias/Analytics/useAnalytics")
}
