local SocialTab = script:FindFirstAncestor("SocialTab")
local AnalyticsContext = require(script.AnalyticsContext)
local Context = require(SocialTab.dependencies).SocialLibraries.Context

return {
	Class = require(script.SocialTabAnalytics),
	Context = AnalyticsContext,
	connect = Context.getConnect(AnalyticsContext),
	with = Context.getWith(AnalyticsContext)
}
