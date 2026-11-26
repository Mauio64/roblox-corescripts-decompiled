local TelemetryService = game:GetService("TelemetryService")

local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryUtils/Cryo")

local v5 = {
	eventName = "NxmApportioningDiagnostic",
	description = "Diagnostic events for the NxM apportioning dry-run",
	lastUpdated = { 26, 7, 7 },
	backends = { "EventIngest", "Points" },
	throttlingPercentage = game:DefineFastInt("LuaAppNxMApportioningDiagnosticThrottleHundredthsPercent", 0)
}

local v6 = { "addOSInfo", "addSessionInfo", "addSessionId" }

return {
	log = function(p2, options)
		TelemetryService:LogEvent(v5, {
			standardizedFields = v6,
			customFields = Cryo.Dictionary.join(options or {}, { eventKind = p2 })
		})
	end
}
