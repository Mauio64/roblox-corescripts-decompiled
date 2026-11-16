local FriendsLanding = script:FindFirstAncestor("FriendsLanding")
local dependencies = require(FriendsLanding.dependencies)
local context = dependencies.SocialLibraries.Context

local ButtonClickEvents = require(script.ButtonClickEvents)
local ImpressionEvents = require(script.ImpressionEvents)
local AnalyticsContext = require(script.AnalyticsContext)

return {
	Class = require(script.FriendsLandingAnalytics),
	Context = AnalyticsContext,
	connect = context.getConnect(AnalyticsContext),
	with = context.getWith(AnalyticsContext),
	ButtonClickEvents = ButtonClickEvents,
	AddFriendsPageLoadAnalytics = require(script.AddFriendsPageLoadAnalytics),
	ImpressionEvents = ImpressionEvents
}
