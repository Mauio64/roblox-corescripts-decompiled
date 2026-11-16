local EventIngestService = game:GetService("EventIngestService")

local analytics = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoverabilityModal/Analytics").Analytics.new(game:GetService("RbxAnalyticsService"))
return {
	EventStream = {
		setRBXEventStream = require("@game/CorePackages/Workspace/Packages/_Index/DiscoverabilityModal/DiscoverabilityModal/Analytics/setupSetRbxEventStream")(EventIngestService)
	},
	Diag = analytics.Diag
}
