local TelemetryService = game:GetService("TelemetryService")
local t1 = {
	"addOSInfo",
	"addSessionInfo",
	"addSessionId"
}
local t2 = {
	eventName = "TwoByOneTileActivated",
	description = "Counter for TwoByOneTileActivated events.",
	backends = { "RobloxTelemetryCounter" },
	lastUpdated = {
		26,
		1,
		16
	}
}
local t3 = {
	eventName = "TwoByOneTileCtaActivated",
	description = "Counter for TwoByOneTileCtaActivated events.",
	backends = { "RobloxTelemetryCounter" },
	lastUpdated = {
		26,
		2,
		23
	}
}
local t4 = {
	eventName = "TwoByOneTileGameJoinInitiated",
	description = "Counter for TwoByOneTileGameJoinInitiated events.",
	backends = { "RobloxTelemetryCounter" },
	lastUpdated = {
		26,
		1,
		16
	}
}
local t5 = {
	eventName = "TwoByOneTileViewGameDetailsActivated",
	description = "Counter for TwoByOneTileViewGameDetailsActivated events.",
	backends = { "RobloxTelemetryCounter" },
	lastUpdated = {
		26,
		2,
		19
	}
}

return {
	logTwoByOneTileActivated = function() -- line: 43
		-- upvalues: TelemetryService (copy), t2 (copy), t1 (copy)
		TelemetryService:LogCounter(t2, {
			standardizedFields = t1,
			customFields = {}
		}, 1)
	end,
	logTwoByOneTileCtaActivated = function() -- line: 51
		-- upvalues: TelemetryService (copy), t3 (copy), t1 (copy)
		TelemetryService:LogCounter(t3, {
			standardizedFields = t1,
			customFields = {}
		}, 1)
	end,
	logTwoByOneTileGameJoinInitiated = function() -- line: 59
		-- upvalues: TelemetryService (copy), t4 (copy), t1 (copy)
		TelemetryService:LogCounter(t4, {
			standardizedFields = t1,
			customFields = {}
		}, 1)
	end,
	logTwoByOneTileViewGameDetailsActivated = function() -- line: 67
		-- upvalues: TelemetryService (copy), t5 (copy), t1 (copy)
		TelemetryService:LogCounter(t5, {
			standardizedFields = t1,
			customFields = {}
		}, 1)
	end
}
