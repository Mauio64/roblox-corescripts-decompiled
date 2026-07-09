local FriendsCarousel = script:FindFirstAncestor("FriendsCarousel")
local dependencies = require(FriendsCarousel.dependencies)
local _ = FriendsCarousel.Parent
local Context = dependencies.SocialLibraries.Context
local FriendsCarouselAnalyticsContext = require(script.FriendsCarouselAnalyticsContext)
local setupFireEvent = require(script.setupFireEvent)
local useAnalytics = require(script.useAnalytics)
local AnalyticsSetup = require(script.AnalyticsSetup)

return {
	EventNames = require(script.EventNames),
	Analytics = AnalyticsSetup,
	setupFireEvent = setupFireEvent,
	Context = FriendsCarouselAnalyticsContext,
	connect = Context.getConnect(FriendsCarouselAnalyticsContext),
	with = Context.getWith(FriendsCarouselAnalyticsContext),
	useAnalytics = useAnalytics
}
