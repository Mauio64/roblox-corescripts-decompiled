local Parent = script:FindFirstAncestor("ExperienceLoadingScript").Parent
local TelemetryService = game:GetService("TelemetryService")
local QueueExperimentation = require(Parent.SocialExperiments).QueueExperimentation
local v4 = QueueExperimentation.getIsJoinNewServerButtonEnabled() or QueueExperimentation.getIsAutoJoinNewServerEnabled()
local v5 = game:DefineFastInt("LoadingScreenQueuedStateButtonClickThrottleHundredthsPercent", 10000)
local t1 = {
	"addPlaceId",
	"addUniverseId",
	"addOSInfo"
}
local t2 = {
	eventName = "loadingScreenQueuedStateButtonClick",
	description = "Event fired when the user clicks a queued-state action button on the loading screen.",
	links = "https://docs.google.com/document/d/1vbUe9xu9Hi6P7wpRpBC3jKHLXel03wCB-ezb9eJFCBc/edit?usp=sharing",
	backends = { "EventIngest" },
	throttlingPercentage = v5,
	lastUpdated = {
		2026,
		4,
		8
	}
}

return {
	countPlayerLocalizationChoiceNotReady = function() -- line: 16
		-- upvalues: TelemetryService (copy), t1 (copy)
		local t3 = {
			eventName = "PlayerLocalizationChoiceNotReady",
			description = "Counter to track when the auto translate badge doesn't mount before the API response arrived.",
			links = "https://grafana.rbx.com/goto/cfe9j31p1wge8a?orgId=1",
			backends = { "RobloxTelemetryCounter" },
			lastUpdated = {
				2026,
				2,
				24
			}
		}

		TelemetryService:LogCounter(t3, {
			standardizedFields = t1
		}, 1)
	end,
	countPlayerLocalizationChoiceFailed = function(t4: {[any]: any}) -- line: 27
		-- upvalues: TelemetryService (copy), t1 (copy)
		local t5 = {
			eventName = "PlayerLocalizationChoiceFailed",
			description = "Counter to track when the player localization choice API returns an error.",
			links = "https://grafana.rbx.com/goto/cfe9j31p1wge8a?orgId=1",
			backends = { "RobloxTelemetryCounter" },
			lastUpdated = {
				2026,
				2,
				24
			}
		}

		TelemetryService:LogCounter(t5, {
			standardizedFields = t1,
			customFields = {
				responseCode = t4.responseCode,
				errorType = t4.errorType
			}
		}, 1)
	end,
	countAutoTranslateZeroUniverseId = function() -- line: 44
		-- upvalues: TelemetryService (copy), t1 (copy)
		local t6 = {
			eventName = "AutoTranslateZeroUniverseId",
			description = "Counter to track when AutoTranslateBadge skips the API request because universeId is 0.",
			links = "https://grafana.rbx.com/goto/cfe9j31p1wge8a?orgId=1",
			backends = { "RobloxTelemetryCounter" },
			lastUpdated = {
				2026,
				3,
				11
			}
		}

		TelemetryService:LogCounter(t6, {
			standardizedFields = t1
		}, 1)
	end,
	logQueuedStateButtonClick = function(p1) -- line: 64
		-- upvalues: v4 (copy), TelemetryService (copy), t2 (copy)
		if v4 then
			TelemetryService:LogEvent(t2, {
				customFields = p1 or {}
			})
		end
	end
}
