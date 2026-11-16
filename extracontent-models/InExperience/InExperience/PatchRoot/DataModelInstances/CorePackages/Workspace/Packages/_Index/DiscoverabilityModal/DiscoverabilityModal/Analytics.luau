local parent = script.Parent
local dependencies = require(parent.dependencies)
local context = dependencies.SocialLibraries.Context

local DiscoverabilityModalAnalyticsContext = require(script.DiscoverabilityModalAnalyticsContext)
return {
	setupFireAnalyticsEvents = require(script.setupFireAnalyticsEvents),
	Context = DiscoverabilityModalAnalyticsContext,
	connect = context.getConnect(DiscoverabilityModalAnalyticsContext),
	EventNames = require(script.Enums.EventNames),
	useAnalytics = require(script.useAnalytics),
	EntryPoints = require(script.Enums.EntryPoints),
	AnalyticsService = require(script.AnalyticsService)
}
