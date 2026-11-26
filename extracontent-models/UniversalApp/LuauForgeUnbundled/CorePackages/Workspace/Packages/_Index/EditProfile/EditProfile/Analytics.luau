local EditProfileAnalyticsContext = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/Analytics/EditProfileAnalyticsContext")
local context = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/LuaSocialLibrariesDeps").SocialLibraries.config({}).Context

return {
	AnalyticsService = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/Analytics/AnalyticsService"),
	Context = EditProfileAnalyticsContext,
	connect = context.getConnect(EditProfileAnalyticsContext),
	EventNames = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/Analytics/Enums/EventNames"),
	setupFireAnalyticsEvents = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/Analytics/setupFireAnalyticsEvents"),
	useAnalytics = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/Analytics/useAnalytics"),
	AnalyticsServiceV2 = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/Analytics/AnalyticsServiceV2")
}
