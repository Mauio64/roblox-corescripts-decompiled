local PYMKCarousel = script:FindFirstAncestor("PYMKCarousel")
local dependencies = require(PYMKCarousel.dependencies)
local Context = dependencies.SocialLibraries.Context
local PYMKCarouselAnalyticsContext = require(script.PYMKCarouselAnalyticsContext)
local setupFireEvent = require(script.setupFireEvent)
local useAnalytics = require(script.useAnalytics)
local useUserSeenEvent = require(script.useUserSeenEvent)
local getFFlagPYMKAddFriendsEntry = dependencies.getFFlagPYMKAddFriendsEntry

return {
	setupFireEvent = setupFireEvent,
	Context = PYMKCarouselAnalyticsContext,
	connect = Context.getConnect(PYMKCarouselAnalyticsContext),
	with = Context.getWith(PYMKCarouselAnalyticsContext),
	EventNames = require(script.EventNames),
	BtnValues = if not getFFlagPYMKAddFriendsEntry() then nil else require(script.BtnValues),
	useAnalytics = useAnalytics,
	useUserSeenEvent = useUserSeenEvent
}
