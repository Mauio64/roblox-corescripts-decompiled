local scriptParent = script.Parent
local Context = require(scriptParent.dependencies).SocialLibraries.Context
local DiscoverabilityModalAnalyticsContext = require(script.DiscoverabilityModalAnalyticsContext)

return {
	setupFireAnalyticsEvents = require(script.setupFireAnalyticsEvents),
	Context = DiscoverabilityModalAnalyticsContext,
	connect = Context.getConnect(DiscoverabilityModalAnalyticsContext),
	EventNames = require(script.Enums.EventNames),
	useAnalytics = require(script.useAnalytics),
	EntryPoints = require(script.Enums.EntryPoints),
	AnalyticsService = require(script.AnalyticsService)
}
