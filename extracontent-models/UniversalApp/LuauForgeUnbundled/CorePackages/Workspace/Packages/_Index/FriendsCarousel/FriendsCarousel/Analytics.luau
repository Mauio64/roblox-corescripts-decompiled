local context = require("@game/CorePackages/Workspace/Packages/_Index/FriendsCarousel/FriendsCarousel/dependencies").SocialLibraries.Context

local FriendsCarouselAnalyticsContext = require("@game/CorePackages/Workspace/Packages/_Index/FriendsCarousel/FriendsCarousel/Analytics/FriendsCarouselAnalyticsContext")
local module2 = require("@game/CorePackages/Workspace/Packages/_Index/FriendsCarousel/FriendsCarousel/Analytics/setupFireEvent")
local module3 = require("@game/CorePackages/Workspace/Packages/_Index/FriendsCarousel/FriendsCarousel/Analytics/useAnalytics")

local AnalyticsSetup = require("@game/CorePackages/Workspace/Packages/_Index/FriendsCarousel/FriendsCarousel/Analytics/AnalyticsSetup")

return {
	EventNames = require("@game/CorePackages/Workspace/Packages/_Index/FriendsCarousel/FriendsCarousel/Analytics/EventNames"),
	Analytics = AnalyticsSetup,
	setupFireEvent = module2,
	Context = FriendsCarouselAnalyticsContext,
	connect = context.getConnect(FriendsCarouselAnalyticsContext),
	with = context.getWith(FriendsCarouselAnalyticsContext),
	useAnalytics = module3
}
