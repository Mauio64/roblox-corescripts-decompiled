local TelemetryService = game:GetService("TelemetryService")

local defineFastFlag = game:DefineFastFlag("EnableAppAgeSignalsErrorTelemetry", false)

local v5 = {
	ErrorCounter = {
		eventName = "AppAgeSignalsErrorCounter",
		backends = { "RobloxTelemetryCounter" },
		lastUpdated = { 2026, 3, 4 },
		description = "Error counter for app age signals collection flow"
	},
	ErrorEvent = {
		eventName = "AppAgeSignalsError",
		backends = { "EventIngest" },
		throttlingPercentage = 10000,
		lastUpdated = { 2026, 3, 4 },
		description = "Error event for app age signals collection flow"
	}
}

return {
	reportError = function(p2)
		if not defineFastFlag then
			return
		end

		TelemetryService:LogCounter(v5.ErrorCounter, {
			customFields = { error = p2.error, signalSource = p2.signalSource }
		}, 1)

		TelemetryService:LogEvent(v5.ErrorEvent, {
			standardizedFields = { "addSessionInfo", "addSessionId", "addOSInfo" },
			customFields = { error = p2.error, signalSource = p2.signalSource }
		})
	end
}
