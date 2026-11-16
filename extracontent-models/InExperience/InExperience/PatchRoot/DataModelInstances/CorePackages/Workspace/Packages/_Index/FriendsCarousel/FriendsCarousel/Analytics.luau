local FriendsCarousel = script:FindFirstAncestor("FriendsCarousel")
local dependencies = require(FriendsCarousel.dependencies)
local parent = FriendsCarousel.Parent

local context = dependencies.SocialLibraries.Context

local FriendsCarouselAnalyticsContext = require(script.FriendsCarouselAnalyticsContext)
local setupFireEvent = require(script.setupFireEvent)
local useAnalytics = require(script.useAnalytics)

local AnalyticsSetup = require(script.AnalyticsSetup)

return {
	EventNames = require(script.EventNames),
	Analytics = AnalyticsSetup,
	setupFireEvent = setupFireEvent,
	Context = FriendsCarouselAnalyticsContext,
	connect = context.getConnect(FriendsCarouselAnalyticsContext),
	with = context.getWith(FriendsCarouselAnalyticsContext),
	useAnalytics = useAnalytics
}
