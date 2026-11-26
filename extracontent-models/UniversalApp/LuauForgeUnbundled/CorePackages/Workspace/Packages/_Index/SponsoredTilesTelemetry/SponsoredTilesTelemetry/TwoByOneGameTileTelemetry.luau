local TelemetryService = game:GetService("TelemetryService")

local v5 = { "addOSInfo", "addSessionInfo", "addSessionId" }

local v6 = {
	eventName = "TwoByOneTileActivated",
	backends = { "RobloxTelemetryCounter" },
	lastUpdated = { 26, 1, 16 },
	description = "Counter for TwoByOneTileActivated events."
}

local v7 = {
	eventName = "TwoByOneTileCtaActivated",
	backends = { "RobloxTelemetryCounter" },
	lastUpdated = { 26, 2, 23 },
	description = "Counter for TwoByOneTileCtaActivated events."
}

local v8 = {
	eventName = "TwoByOneTileGameJoinInitiated",
	backends = { "RobloxTelemetryCounter" },
	lastUpdated = { 26, 1, 16 },
	description = "Counter for TwoByOneTileGameJoinInitiated events."
}

local v9 = {
	eventName = "TwoByOneTileViewGameDetailsActivated",
	backends = { "RobloxTelemetryCounter" },
	lastUpdated = { 26, 2, 19 },
	description = "Counter for TwoByOneTileViewGameDetailsActivated events."
}

return {
	logTwoByOneTileActivated = function()
		TelemetryService:LogCounter(v6, { standardizedFields = v5, customFields = {} }, 1)
	end,
	logTwoByOneTileCtaActivated = function()
		TelemetryService:LogCounter(v7, { standardizedFields = v5, customFields = {} }, 1)
	end,
	logTwoByOneTileGameJoinInitiated = function()
		TelemetryService:LogCounter(v8, { standardizedFields = v5, customFields = {} }, 1)
	end,
	logTwoByOneTileViewGameDetailsActivated = function()
		TelemetryService:LogCounter(v9, { standardizedFields = v5, customFields = {} }, 1)
	end
}
