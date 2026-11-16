local EventIngestService = game:GetService("EventIngestService")

local analytics = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileQRCode/Analytics").Analytics.new(game:GetService("RbxAnalyticsService"))
return {
	EventStream = {
		setRBXEventStream = require("@game/CorePackages/Workspace/Packages/_Index/ProfileQRCode/ProfileQRCode/Analytics/setupSetRbxEventStream")(EventIngestService)
	},
	Diag = analytics.Diag
}
