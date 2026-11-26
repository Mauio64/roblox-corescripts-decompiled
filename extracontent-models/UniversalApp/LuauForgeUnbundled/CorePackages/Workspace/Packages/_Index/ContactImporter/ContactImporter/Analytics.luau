local context = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/dependencies").SocialLibraries.Context

local ContactImporterAnalyticsContext = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/Analytics/ContactImporterAnalyticsContext")
return {
	setupFireAnalyticsEvents = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/Analytics/setupFireAnalyticsEvents"),
	Context = ContactImporterAnalyticsContext,
	connect = context.getConnect(ContactImporterAnalyticsContext),
	useAnalytics = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/Analytics/useAnalytics"),
	EventNames = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/Analytics/Enums/EventNames"),
	EntryPoints = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/Analytics/Enums/ContactImporterEntryPoints"),
	FieldNames = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/Analytics/FieldNames"),
	AnalyticsService = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/Analytics/AnalyticsService")
}
