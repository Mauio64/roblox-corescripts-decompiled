local TelemetryService = game:GetService("TelemetryService")
local v2 = game:DefineFastFlag("EnableAppAgeSignalsErrorTelemetry", false)
local t1 = {
	ErrorCounter = {
		eventName = "AppAgeSignalsErrorCounter",
		description = "Error counter for app age signals collection flow",
		backends = { "RobloxTelemetryCounter" },
		lastUpdated = {
			2026,
			3,
			4
		}
	},
	ErrorEvent = {
		eventName = "AppAgeSignalsError",
		throttlingPercentage = 10000,
		description = "Error event for app age signals collection flow",
		backends = { "EventIngest" },
		lastUpdated = {
			2026,
			3,
			4
		}
	}
}

return {
	reportError = function(t2: {[any]: any}) -- line: 28
		-- upvalues: v2 (copy), TelemetryService (copy), t1 (copy)
		if not v2 then
			return
		end

		TelemetryService:LogCounter(t1.ErrorCounter, {
			customFields = {
				error = t2.error,
				signalSource = t2.signalSource
			}
		}, 1)
		TelemetryService:LogEvent(t1.ErrorEvent, {
			standardizedFields = {
				"addSessionInfo",
				"addSessionId",
				"addOSInfo"
			},
			customFields = {
				error = t2.error,
				signalSource = t2.signalSource
			}
		})
	end
}
