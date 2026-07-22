local TelemetryService = game:GetService("TelemetryService")
local Parent = script:FindFirstAncestor("DiscoveryUtils").Parent
local Cryo = require(Parent.Cryo)
local t1 = {
	eventName = "NxmApportioningDiagnostic",
	description = "Diagnostic events for the NxM apportioning dry-run",
	lastUpdated = {
		26,
		7,
		7
	},
	backends = {
		"EventIngest",
		"Points"
	},
	throttlingPercentage = game:DefineFastInt("LuaAppNxMApportioningDiagnosticThrottleHundredthsPercent", 0)
}
local t2 = {
	"addOSInfo",
	"addSessionInfo",
	"addSessionId"
}

return {
	log = function(s1: string, t3: {[any]: any}?) -- line: 32
		-- upvalues: Cryo (copy), TelemetryService (copy), t1 (copy), t2 (copy)
		local v8 = Cryo.Dictionary.join(t3 or {}, {
			eventKind = s1
		})

		TelemetryService:LogEvent(t1, {
			standardizedFields = t2,
			customFields = v8
		})
	end
}
