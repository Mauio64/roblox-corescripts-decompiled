local TelemetryService = game:GetService("TelemetryService")

local v5 = {
	LogOutButtonClickFields = {
		eventName = "moreGridItemClick",
		backends = { "EventIngest" },
		throttlingPercentage = game:DefineFastInt("MoreLogOutTelemetryThrottleHundredthsPercent", 10000),
		lastUpdated = { 2026, 10, 1 },
		description = "Event fired every time the User engages with the Log Out button on the More page",
		links = "https://roblox.atlassian.net/wiki/spaces/APEX/pages/5137399812/More+Page+Flyout+CTA+Button+IXP+Spec"
	}
}

local v6 = {
	placeId = "addPlaceId",
	universeId = "addUniverseId",
	playsessionId = "addPlaySessionId",
	sessionInfo = "addSessionInfo"
}

local v7 = {}
v7.__index = v7

function v7.sendLogOutButtonClick(p2)
	TelemetryService:LogEvent(v5.LogOutButtonClickFields, {
		standardizedFields = {
			"addPlaceId",
			"addUniverseId",
			"addPlaySessionId",
			"addSessionInfo"
		},
		customFields = p2,
		eventContext = "moreGridItem"
	})
end

return v7
