local parent = script:FindFirstAncestor("GameTile").Parent

local LoggingProtocol = require(parent.LoggingProtocol)

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
