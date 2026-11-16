local TelemetryService = game:GetService("TelemetryService")

require("@game/CorePackages/Workspace/Packages/_Workspace/LinkingProtocol/LinkingProtocol/LinkingProtocolTypes")

local v5 = { "addOSInfo", "addSessionInfo", "addSessionId" }

local v6 = {
	eventName = "StartAttributionDecisionPublishedCounter",
	backends = { "RobloxTelemetryCounter" },
	lastUpdated = { 26, 9, 1 },
	description = [[
Counts delayed-AppsFlyer-start decisions published to native. Custom field
"trigger" is Auth / SessionStart / ConsentChanged (ConsentChanged isolates the
live mid-session sell/share toggle); "applySharingFilter" is whether the
partner-postback filter was applied.
		]]
}

return {
	logDecisionPublished = function(p2, p3)
		TelemetryService:LogCounter(v6, {
			standardizedFields = v5,
			customFields = { trigger = p2, applySharingFilter = p3 }
		}, 1)
	end
}
