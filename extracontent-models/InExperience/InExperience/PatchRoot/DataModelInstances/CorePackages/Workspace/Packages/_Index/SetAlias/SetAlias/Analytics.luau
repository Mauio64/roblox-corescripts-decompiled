local parent = script.Parent
local SetAliasAnalyticsContext = require(script.SetAliasAnalyticsContext)
local dependencies = require(parent.dependencies)
local context = dependencies.SocialLibraries.Context

return {
	AnalyticsService = require(script.AnalyticsService),
	Context = SetAliasAnalyticsContext,
	connect = context.getConnect(SetAliasAnalyticsContext),
	EventNames = require(script.Enums.EventNames),
	EntryPoints = require(script.Enums.EntryPoints),
	setupFireAnalyticsEvents = require(script.setupFireAnalyticsEvents),
	useAnalytics = require(script.useAnalytics)
}
