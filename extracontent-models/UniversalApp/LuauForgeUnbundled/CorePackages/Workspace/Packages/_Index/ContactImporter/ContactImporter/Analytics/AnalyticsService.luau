local EventIngestService = game:GetService("EventIngestService")

local analytics = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactImporter/Analytics").Analytics.new(game:GetService("RbxAnalyticsService"))
return {
	EventStream = {
		setRBXEventStream = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/Analytics/setupSetRbxEventStream")(EventIngestService)
	},
	Diag = analytics.Diag
}
