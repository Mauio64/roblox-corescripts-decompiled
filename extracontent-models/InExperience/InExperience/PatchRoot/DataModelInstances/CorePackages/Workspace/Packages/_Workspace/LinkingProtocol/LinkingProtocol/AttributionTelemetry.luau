local TelemetryService = game:GetService("TelemetryService")

require(script.Parent.LinkingProtocolTypes)

local standardizedFields = { "addOSInfo", "addSessionInfo", "addSessionId" }

local v = {
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
	logDecisionPublished = function(trigger, applySharingFilter: boolean)
		TelemetryService:LogCounter(v, {
			standardizedFields = standardizedFields,
			customFields = { trigger = trigger, applySharingFilter = applySharingFilter }
		}, 1)
	end
}
