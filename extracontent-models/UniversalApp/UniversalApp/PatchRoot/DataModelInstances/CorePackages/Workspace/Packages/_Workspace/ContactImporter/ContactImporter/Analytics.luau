local ContactImporter = script:FindFirstAncestor("ContactImporter")
local Context = require(ContactImporter.dependencies).SocialLibraries.Context
local ContactImporterAnalyticsContext = require(script.ContactImporterAnalyticsContext)

return {
	setupFireAnalyticsEvents = require(script.setupFireAnalyticsEvents),
	Context = ContactImporterAnalyticsContext,
	connect = Context.getConnect(ContactImporterAnalyticsContext),
	useAnalytics = require(script.useAnalytics),
	EventNames = require(script.Enums.EventNames),
	EntryPoints = require(script.Enums.ContactImporterEntryPoints),
	FieldNames = require(script.FieldNames),
	AnalyticsService = require(script.AnalyticsService)
}
