local PYMKCarousel = script:FindFirstAncestor("PYMKCarousel")
local dependencies = require(PYMKCarousel.dependencies)
local context = dependencies.SocialLibraries.Context

local PYMKCarouselAnalyticsContext = require(script.PYMKCarouselAnalyticsContext)
local setupFireEvent = require(script.setupFireEvent)
local useAnalytics = require(script.useAnalytics)
local useUserSeenEvent = require(script.useUserSeenEvent)
local useUserSeenCollectionEvent = require(script.useUserSeenCollectionEvent)

local getFFlagPYMKAddFriendsEntry = dependencies.getFFlagPYMKAddFriendsEntry

local Analytics = {
	setupFireEvent = setupFireEvent,
	Context = PYMKCarouselAnalyticsContext,
	connect = context.getConnect(PYMKCarouselAnalyticsContext),
	with = context.getWith(PYMKCarouselAnalyticsContext),
	EventNames = require(script.EventNames),
	BtnValues = 0,
	useAnalytics = 0,
	useUserSeenEvent = 0,
	useUserSeenCollectionEvent = 0
}
local btnValues

if getFFlagPYMKAddFriendsEntry() then
	btnValues = require(script.BtnValues)
end

Analytics.BtnValues = btnValues
Analytics.useAnalytics = useAnalytics
Analytics.useUserSeenEvent = useUserSeenEvent
Analytics.useUserSeenCollectionEvent = useUserSeenCollectionEvent
return Analytics
