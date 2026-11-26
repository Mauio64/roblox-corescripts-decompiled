local context = require("@game/CorePackages/Workspace/Packages/_Index/DiscoverabilityModal/DiscoverabilityModal/dependencies").SocialLibraries.Context

local DiscoverabilityModalAnalyticsContext = require("@game/CorePackages/Workspace/Packages/_Index/DiscoverabilityModal/DiscoverabilityModal/Analytics/DiscoverabilityModalAnalyticsContext")
return {
	setupFireAnalyticsEvents = require("@game/CorePackages/Workspace/Packages/_Index/DiscoverabilityModal/DiscoverabilityModal/Analytics/setupFireAnalyticsEvents"),
	Context = DiscoverabilityModalAnalyticsContext,
	connect = context.getConnect(DiscoverabilityModalAnalyticsContext),
	EventNames = require("@game/CorePackages/Workspace/Packages/_Index/DiscoverabilityModal/DiscoverabilityModal/Analytics/Enums/EventNames"),
	useAnalytics = require("@game/CorePackages/Workspace/Packages/_Index/DiscoverabilityModal/DiscoverabilityModal/Analytics/useAnalytics"),
	EntryPoints = require("@game/CorePackages/Workspace/Packages/_Index/DiscoverabilityModal/DiscoverabilityModal/Analytics/Enums/EntryPoints"),
	AnalyticsService = require("@game/CorePackages/Workspace/Packages/_Index/DiscoverabilityModal/DiscoverabilityModal/Analytics/AnalyticsService")
}
