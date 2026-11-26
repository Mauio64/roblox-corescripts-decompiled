return function(p2)
	return {
		Diag = { reportCounter = p2.fn(), reportStats = p2.fn() },
		EventStream = { setRBXEventStream = p2.fn(), sendEventDeferred = p2.fn() },
		Telemetry = {
			logRobloxTelemetryCounter = p2.fn(),
			logRobloxTelemetryEvent = p2.fn(),
			logRobloxTelemetryStat = p2.fn(),
			TelemetryBackends = {
				Points = "Points",
				Stats = "RobloxTelemetryStat",
				Counters = "RobloxTelemetryCounter",
				EventIngest = "EventIngest"
			}
		}
	}
end
