local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/dependencies")
local context = dependencies.SocialLibraries.Context

local PYMKCarouselAnalyticsContext = require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/Analytics/PYMKCarouselAnalyticsContext")
local module3 = require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/Analytics/setupFireEvent")
local module4 = require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/Analytics/useAnalytics")
local module5 = require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/Analytics/useUserSeenEvent")
local module6 = require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/Analytics/useUserSeenCollectionEvent")

local getFFlagPYMKAddFriendsEntry = dependencies.getFFlagPYMKAddFriendsEntry

local v5 = {
	setupFireEvent = module3,
	Context = PYMKCarouselAnalyticsContext,
	connect = context.getConnect(PYMKCarouselAnalyticsContext),
	with = context.getWith(PYMKCarouselAnalyticsContext),
	EventNames = require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/Analytics/EventNames"),
	BtnValues = 0,
	useAnalytics = 0,
	useUserSeenEvent = 0,
	useUserSeenCollectionEvent = 0
}
local v6 = if getFFlagPYMKAddFriendsEntry() then require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/Analytics/BtnValues") else nil
v5.BtnValues = v6
v5.useAnalytics = module4
v5.useUserSeenEvent = module5
v5.useUserSeenCollectionEvent = module6
return v5
