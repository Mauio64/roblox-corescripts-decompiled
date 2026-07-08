local FriendsLanding = script:FindFirstAncestor("FriendsLanding")
local Context = require(FriendsLanding.dependencies).SocialLibraries.Context
local ButtonClickEvents = require(script.ButtonClickEvents)
local ImpressionEvents = require(script.ImpressionEvents)
local AnalyticsContext = require(script.AnalyticsContext)

return {
	Class = require(script.FriendsLandingAnalytics),
	Context = AnalyticsContext,
	connect = Context.getConnect(AnalyticsContext),
	with = Context.getWith(AnalyticsContext),
	ButtonClickEvents = ButtonClickEvents,
	AddFriendsPageLoadAnalytics = require(script.AddFriendsPageLoadAnalytics),
	ImpressionEvents = ImpressionEvents
}
