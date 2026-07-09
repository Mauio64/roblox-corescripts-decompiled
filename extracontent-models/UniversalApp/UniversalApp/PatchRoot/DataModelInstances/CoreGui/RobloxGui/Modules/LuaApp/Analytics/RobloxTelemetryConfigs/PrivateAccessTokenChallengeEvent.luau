local CorePackages = game:GetService("CorePackages")
local LoggingProtocol = require(CorePackages.Workspace.Packages.LoggingProtocol)

return {
	eventName = "accountSecurityChallengePrivateAccessTokenEvent",
	throttlingPercentage = 10000,
	description = "Tracks lifecycle events for the Private Access Token GCS challenge",
	links = "https://roblox.atlassian.net/wiki/spaces/BaS/pages/2871099676/Native+PAT+Tech+Spec#Events-and-Metrics-Tracking%3A",
	backends = { LoggingProtocol.TelemetryBackends.EventIngest },
	lastUpdated = {
		24,
		1,
		22
	}
}
