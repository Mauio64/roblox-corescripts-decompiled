local TelemetryService = game:GetService("TelemetryService")

local standardizedFields = { "addOSInfo", "addSessionInfo", "addSessionId" }

local v = {
	eventName = "TwoByOneTileActivated",
	backends = { "RobloxTelemetryCounter" },
	lastUpdated = { 26, 1, 16 },
	description = "Counter for TwoByOneTileActivated events."
}

local v2 = {
	eventName = "TwoByOneTileCtaActivated",
	backends = { "RobloxTelemetryCounter" },
	lastUpdated = { 26, 2, 23 },
	description = "Counter for TwoByOneTileCtaActivated events."
}

local v3 = {
	eventName = "TwoByOneTileGameJoinInitiated",
	backends = { "RobloxTelemetryCounter" },
	lastUpdated = { 26, 1, 16 },
	description = "Counter for TwoByOneTileGameJoinInitiated events."
}

local v4 = {
	eventName = "TwoByOneTileViewGameDetailsActivated",
	backends = { "RobloxTelemetryCounter" },
	lastUpdated = { 26, 2, 19 },
	description = "Counter for TwoByOneTileViewGameDetailsActivated events."
}
local TwoByOneGameTileTelemetry = {}

function TwoByOneGameTileTelemetry.logTwoByOneTileActivated()
	TelemetryService:LogCounter(v, { standardizedFields = standardizedFields, customFields = {} }, 1)
end

function TwoByOneGameTileTelemetry.logTwoByOneTileCtaActivated()
	TelemetryService:LogCounter(v2, { standardizedFields = standardizedFields, customFields = {} }, 1)
end

function TwoByOneGameTileTelemetry.logTwoByOneTileGameJoinInitiated()
	TelemetryService:LogCounter(v3, { standardizedFields = standardizedFields, customFields = {} }, 1)
end

function TwoByOneGameTileTelemetry.logTwoByOneTileViewGameDetailsActivated()
	TelemetryService:LogCounter(v4, { standardizedFields = standardizedFields, customFields = {} }, 1)
end

return TwoByOneGameTileTelemetry
