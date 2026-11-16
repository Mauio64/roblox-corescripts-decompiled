return function(p)
	return {
		Diag = { reportCounter = p.fn(), reportStats = p.fn() },
		EventStream = { setRBXEventStream = p.fn(), sendEventDeferred = p.fn() },
		Telemetry = {
			logRobloxTelemetryCounter = p.fn(),
			logRobloxTelemetryEvent = p.fn(),
			logRobloxTelemetryStat = p.fn(),
			TelemetryBackends = {
				Points = "Points",
				Stats = "RobloxTelemetryStat",
				Counters = "RobloxTelemetryCounter",
				EventIngest = "EventIngest"
			}
		}
	}
end
