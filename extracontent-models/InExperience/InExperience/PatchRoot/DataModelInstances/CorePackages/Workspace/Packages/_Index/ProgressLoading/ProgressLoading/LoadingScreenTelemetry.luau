local parent = script:FindFirstAncestor("ProgressLoading").Parent

local TelemetryService = game:GetService("TelemetryService")

local SocialExperiments = require(parent.SocialExperiments)
local QueueExperimentation = SocialExperiments.QueueExperimentation
local v = QueueExperimentation.getIsJoinNewServerButtonEnabled() or QueueExperimentation.getIsAutoJoinNewServerEnabled()

local SharedFlags = require(parent.SharedFlags)

local standardizedFields = { "addPlaceId", "addUniverseId", "addOSInfo" }
local v2 = {
	eventName = "loadingScreenQueuedStateButtonClick",
	backends = { "EventIngest" },
	throttlingPercentage = SharedFlags.FIntLoadingScreenQueuedStateButtonClickThrottleHundredthsPercent,
	lastUpdated = { 2026, 4, 8 },
	description = "Event fired when the user clicks a queued-state action button on the loading screen.",
	links = "https://docs.google.com/document/d/1vbUe9xu9Hi6P7wpRpBC3jKHLXel03wCB-ezb9eJFCBc/edit?usp=sharing"
}
local LoadingScreenTelemetry = {}

function LoadingScreenTelemetry.countPlayerLocalizationChoiceNotReady()
	TelemetryService:LogCounter({
		eventName = "PlayerLocalizationChoiceNotReady",
		backends = { "RobloxTelemetryCounter" },
		lastUpdated = { 2026, 2, 24 },
		description = "Counter to track when the auto translate badge doesn't mount before the API response arrived.",
		links = "https://grafana.rbx.com/goto/cfe9j31p1wge8a?orgId=1"
	}, { standardizedFields = standardizedFields }, 1)
end

function LoadingScreenTelemetry.countPlayerLocalizationChoiceFailed(p)
	TelemetryService:LogCounter({
		eventName = "PlayerLocalizationChoiceFailed",
		backends = { "RobloxTelemetryCounter" },
		lastUpdated = { 2026, 2, 24 },
		description = "Counter to track when the player localization choice API returns an error.",
		links = "https://grafana.rbx.com/goto/cfe9j31p1wge8a?orgId=1"
	}, {
		standardizedFields = standardizedFields,
		customFields = { responseCode = p.responseCode, errorType = p.errorType }
	}, 1)
end

function LoadingScreenTelemetry.countAutoTranslateZeroUniverseId()
	TelemetryService:LogCounter({
		eventName = "AutoTranslateZeroUniverseId",
		backends = { "RobloxTelemetryCounter" },
		lastUpdated = { 2026, 3, 11 },
		description = "Counter to track when AutoTranslateBadge skips the API request because universeId is 0.",
		links = "https://grafana.rbx.com/goto/cfe9j31p1wge8a?orgId=1"
	}, { standardizedFields = standardizedFields }, 1)
end

function LoadingScreenTelemetry.logQueuedStateButtonClick(options)
	if v then
		TelemetryService:LogEvent(v2, {
			customFields = options or {}
		})
	end
end

return LoadingScreenTelemetry
