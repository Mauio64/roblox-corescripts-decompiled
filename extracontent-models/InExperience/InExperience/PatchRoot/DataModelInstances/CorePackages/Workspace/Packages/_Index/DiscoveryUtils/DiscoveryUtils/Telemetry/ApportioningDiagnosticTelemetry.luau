local TelemetryService = game:GetService("TelemetryService")
local parent = script:FindFirstAncestor("DiscoveryUtils").Parent

local Cryo = require(parent.Cryo)

local v = {
	eventName = "NxmApportioningDiagnostic",
	description = "Diagnostic events for the NxM apportioning dry-run",
	lastUpdated = { 26, 7, 7 },
	backends = { "EventIngest", "Points" },
	throttlingPercentage = game:DefineFastInt("LuaAppNxMApportioningDiagnosticThrottleHundredthsPercent", 0)
}

local standardizedFields = { "addOSInfo", "addSessionInfo", "addSessionId" }

return {
	log = function(eventKind: string, options)
		TelemetryService:LogEvent(v, {
			standardizedFields = standardizedFields,
			customFields = Cryo.Dictionary.join(options or {}, { eventKind = eventKind })
		})
	end
}
