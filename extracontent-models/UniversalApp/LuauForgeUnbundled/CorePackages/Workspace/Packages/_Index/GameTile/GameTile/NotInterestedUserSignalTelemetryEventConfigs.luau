local LoggingProtocol = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/LoggingProtocol")

return {
	NotInterestedMissingAppPage = {
		eventName = "Discovery_NotInterestedMissingAppPage",
		backends = { LoggingProtocol.TelemetryBackends.Counter },
		lastUpdated = { 25, 8, 14 },
		description = "Counter for Not Interested Missing App Page"
	},
	NotInterestedUserSignalFailed = {
		eventName = "Discovery_NotInterestedUserSignalFailed",
		backends = { LoggingProtocol.TelemetryBackends.Counter },
		lastUpdated = { 25, 8, 14 },
		description = "Counter for Not Interested User Signal Failed"
	}
}
