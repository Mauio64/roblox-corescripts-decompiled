local ContactImporter = script:FindFirstAncestor("ContactImporter")
local dependencies = require(ContactImporter.dependencies)
local context = dependencies.SocialLibraries.Context

local ContactImporterAnalyticsContext = require(script.ContactImporterAnalyticsContext)
return {
	setupFireAnalyticsEvents = require(script.setupFireAnalyticsEvents),
	Context = ContactImporterAnalyticsContext,
	connect = context.getConnect(ContactImporterAnalyticsContext),
	useAnalytics = require(script.useAnalytics),
	EventNames = require(script.Enums.EventNames),
	EntryPoints = require(script.Enums.ContactImporterEntryPoints),
	FieldNames = require(script.FieldNames),
	AnalyticsService = require(script.AnalyticsService)
}
