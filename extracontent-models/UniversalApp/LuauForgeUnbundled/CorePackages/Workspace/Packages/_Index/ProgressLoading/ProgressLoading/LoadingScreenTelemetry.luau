local TelemetryService = game:GetService("TelemetryService")

local queueExperimentation = require("@game/CorePackages/Workspace/Packages/_Workspace/ProgressLoading/SocialExperiments").QueueExperimentation
local v5 = queueExperimentation.getIsJoinNewServerButtonEnabled()
	or queueExperimentation.getIsAutoJoinNewServerEnabled()

local v6 = { "addPlaceId", "addUniverseId", "addOSInfo" }
local v7 = {
	eventName = "loadingScreenQueuedStateButtonClick",
	backends = { "EventIngest" },
	throttlingPercentage = require("@game/CorePackages/Workspace/Packages/_Workspace/ProgressLoading/SharedFlags").FIntLoadingScreenQueuedStateButtonClickThrottleHundredthsPercent,
	lastUpdated = { 2026, 4, 8 },
	description = "Event fired when the user clicks a queued-state action button on the loading screen.",
	links = "https://docs.google.com/document/d/1vbUe9xu9Hi6P7wpRpBC3jKHLXel03wCB-ezb9eJFCBc/edit?usp=sharing"
}
return {
	countPlayerLocalizationChoiceNotReady = function()
		TelemetryService:LogCounter({
			eventName = "PlayerLocalizationChoiceNotReady",
			backends = { "RobloxTelemetryCounter" },
			lastUpdated = { 2026, 2, 24 },
			description = "Counter to track when the auto translate badge doesn't mount before the API response arrived.",
			links = "https://grafana.rbx.com/goto/cfe9j31p1wge8a?orgId=1"
		}, { standardizedFields = v6 }, 1)
	end,
	countPlayerLocalizationChoiceFailed = function(p2)
		TelemetryService:LogCounter({
			eventName = "PlayerLocalizationChoiceFailed",
			backends = { "RobloxTelemetryCounter" },
			lastUpdated = { 2026, 2, 24 },
			description = "Counter to track when the player localization choice API returns an error.",
			links = "https://grafana.rbx.com/goto/cfe9j31p1wge8a?orgId=1"
		}, {
			standardizedFields = v6,
			customFields = { responseCode = p2.responseCode, errorType = p2.errorType }
		}, 1)
	end,
	countAutoTranslateZeroUniverseId = function()
		TelemetryService:LogCounter({
			eventName = "AutoTranslateZeroUniverseId",
			backends = { "RobloxTelemetryCounter" },
			lastUpdated = { 2026, 3, 11 },
			description = "Counter to track when AutoTranslateBadge skips the API request because universeId is 0.",
			links = "https://grafana.rbx.com/goto/cfe9j31p1wge8a?orgId=1"
		}, { standardizedFields = v6 }, 1)
	end,
	logQueuedStateButtonClick = function(options)
		if v5 then
			TelemetryService:LogEvent(v7, {
				customFields = options or {}
			})
		end
	end
}
