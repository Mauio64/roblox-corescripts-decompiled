local context = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/dependencies").SocialLibraries.Context

local module = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/FriendsLandingAnalytics/ButtonClickEvents")
local module2 = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/FriendsLandingAnalytics/ImpressionEvents")
local AnalyticsContext = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/FriendsLandingAnalytics/AnalyticsContext")

return {
	Class = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/FriendsLandingAnalytics/FriendsLandingAnalytics"),
	Context = AnalyticsContext,
	connect = context.getConnect(AnalyticsContext),
	with = context.getWith(AnalyticsContext),
	ButtonClickEvents = module,
	AddFriendsPageLoadAnalytics = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/FriendsLandingAnalytics/AddFriendsPageLoadAnalytics"),
	ImpressionEvents = module2
}
