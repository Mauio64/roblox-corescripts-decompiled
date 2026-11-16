local default = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsErrorBoundary/LoggingProtocol").default

local fFlagLuaAppEdpBackendV2LogFetchSuccessAndFailure = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpBackendV2LogFetchSuccessAndFailure

local fFlagLuaAppEdpBackendV2SduiInterleaveDefault = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpBackendV2SduiInterleaveDefault

local fFlagLuaAppEdpBackendV2SduiInterleaveIxp = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpBackendV2SduiInterleaveIxp

local fFlagLuaAppEdpBackendV2LogUniverseIdForEvents = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpBackendV2LogUniverseIdForEvents

local defineFastInt = game:DefineFastInt("ApiFetchExperienceDetailsPageThrottlingHundredthsPercent", 0)

local defineFastInt2 = game:DefineFastInt(
	"ApiFetchExperienceDetailsPageCounterThrottlingHundredthsPercent",
	0
)

local defineFastFlag = game:DefineFastFlag("LuaAppEdpBackendV2LogMissingFetchEventData3", false)

local v5 = {
	ParseFailure = 0,
	MissingData = 0,
	InvalidData = 0,
	SduiLayoutOrderConflict = 0,
	FetchRequest = 0,
	FetchRequestEvent = 0,
	FetchMissingData = 0,
	FetchSuccess = 0,
	FetchSuccessEvent = 0,
	FetchFailure = 0,
	FetchFailureEvent = 0,
	VisibilityVariables = 0
}

local v7 = if defineFastFlag then {
	default.TelemetryBackends.EventIngest,
	default.TelemetryBackends.Points
} else { default.TelemetryBackends.Counter }
v5.ParseFailure = {
	eventName = "experienceDetailsParseFailure",
	backends = v7,
	throttlingPercentage = defineFastInt,
	description = "\"Failed to parse data from API response\"",
	lastUpdated = { 25, 8, 7 },
	links = "https://roblox.atlassian.net/wiki/x/q4Ji4w"
}

local v9 = if defineFastFlag then {
	default.TelemetryBackends.EventIngest,
	default.TelemetryBackends.Points
} else { default.TelemetryBackends.Counter }
v5.MissingData = {
	eventName = "experienceDetailsMissingData",
	backends = v9,
	throttlingPercentage = defineFastInt,
	description = "\"Data missing from API response\"",
	lastUpdated = { 25, 8, 7 },
	links = "https://roblox.atlassian.net/wiki/x/q4Ji4w"
}

local v11 = if defineFastFlag then {
	default.TelemetryBackends.EventIngest,
	default.TelemetryBackends.Points
} else { default.TelemetryBackends.Counter }
v5.InvalidData = {
	eventName = "experienceDetailsInvalidData",
	backends = v11,
	throttlingPercentage = defineFastInt,
	description = "\"Invalid data found in API response\"",
	lastUpdated = { 25, 8, 7 },
	links = "https://roblox.atlassian.net/wiki/x/q4Ji4w"
}

v5.SduiLayoutOrderConflict = (fFlagLuaAppEdpBackendV2SduiInterleaveDefault or fFlagLuaAppEdpBackendV2SduiInterleaveIxp)
	and {
		eventName = "experienceDetailsSduiLayoutOrderConflict",
		backends = { default.TelemetryBackends.EventIngest, default.TelemetryBackends.Points },
		throttlingPercentage = defineFastInt,
		description = "\"SDUI component layout order conflicts with existing EDP layout order\"",
		lastUpdated = { 25, 8, 28 },
		links = "https://roblox.atlassian.net/wiki/x/q4Ji4w"
	}
	or nil

local v13 = if defineFastFlag then {
	default.TelemetryBackends.EventIngest,
	default.TelemetryBackends.Points
} else { default.TelemetryBackends.Counter }
v5.FetchRequest = {
	eventName = "experienceDetailsFetchRequest",
	backends = v13,
	throttlingPercentage = if defineFastFlag then defineFastInt2 else defineFastInt,
	description = "\"Experience details page fetch request\"",
	lastUpdated = { 25, 10, 29 },
	links = "https://roblox.atlassian.net/wiki/x/q4Ji4w"
}

v5.FetchRequestEvent = defineFastFlag and {
	eventName = "experienceDetailsFetchRequestEvent",
	backends = { default.TelemetryBackends.EventIngest, default.TelemetryBackends.Points },
	throttlingPercentage = defineFastInt2,
	description = "Experience details page fetch request",
	lastUpdated = { 25, 10, 29 },
	links = "https://roblox.atlassian.net/wiki/x/q4Ji4w"
} or nil

local v16 = if defineFastFlag then {
	default.TelemetryBackends.EventIngest,
	default.TelemetryBackends.Points
} else { default.TelemetryBackends.Counter }
v5.FetchMissingData = {
	eventName = "experienceDetailsFetchMissingData",
	backends = v16,
	throttlingPercentage = defineFastInt,
	description = "\"Data missing during fetch request\"",
	lastUpdated = { 25, 8, 7 },
	links = "https://roblox.atlassian.net/wiki/x/q4Ji4w"
}
local v17

if fFlagLuaAppEdpBackendV2LogFetchSuccessAndFailure then
	v17 = {
		eventName = "experienceDetailsFetchSuccess",
		backends = { default.TelemetryBackends.Counter },
		throttlingPercentage = 0,
		description = "\"Fetch request succeeded\"",
		lastUpdated = 0,
		links = "https://roblox.atlassian.net/wiki/x/q4Ji4w"
	}

	v17.throttlingPercentage = if defineFastFlag then defineFastInt2 else defineFastInt

	v17.lastUpdated = { 25, 10, 29 }
end

v5.FetchSuccess = v17

v5.FetchSuccessEvent = fFlagLuaAppEdpBackendV2LogFetchSuccessAndFailure and {
	eventName = "experienceDetailsFetchSuccessEvent",
	backends = { default.TelemetryBackends.EventIngest, default.TelemetryBackends.Points },
	throttlingPercentage = defineFastInt2,
	description = "Fetch request succeeded",
	lastUpdated = { 25, 10, 29 },
	links = "https://roblox.atlassian.net/wiki/x/q4Ji4w"
} or nil

v5.FetchFailure = fFlagLuaAppEdpBackendV2LogFetchSuccessAndFailure and {
	eventName = "experienceDetailsFetchFailure",
	backends = { default.TelemetryBackends.Counter, default.TelemetryBackends.Points },
	throttlingPercentage = defineFastInt2,
	description = "\"Fetch request failed\"",
	lastUpdated = { 25, 10, 29 },
	links = "https://roblox.atlassian.net/wiki/x/q4Ji4w"
} or nil

v5.FetchFailureEvent = fFlagLuaAppEdpBackendV2LogFetchSuccessAndFailure and {
	eventName = "experienceDetailsFetchFailureEvent",
	backends = { default.TelemetryBackends.EventIngest, default.TelemetryBackends.Points },
	throttlingPercentage = defineFastInt2,
	description = "Fetch request failed",
	lastUpdated = { 25, 10, 29 },
	links = "https://roblox.atlassian.net/wiki/x/q4Ji4w"
} or nil

v5.VisibilityVariables = {
	eventName = "experienceDetailsVisibilityVariables",
	backends = { default.TelemetryBackends.Points },
	throttlingPercentage = defineFastInt,
	description = "\"Visibility variables\"",
	lastUpdated = { 25, 11, 12 },
	links = "https://roblox.atlassian.net/wiki/x/q4Ji4w"
}

function v5.logParseFailure(p2, universeId)
	if not defineFastFlag then
		default:logRobloxTelemetryCounter(v5.ParseFailure, 1, { dataType = p2 })

		return
	end

	local parseFailure = v5.ParseFailure

	if not fFlagLuaAppEdpBackendV2LogUniverseIdForEvents then
		universeId = nil
	end

	default:logRobloxTelemetryEvent(parseFailure, {}, {
		dataType = p2,
		universeId = universeId
	})
end

function v5.logMissingData(p2, universeId)
	if not defineFastFlag then
		default:logRobloxTelemetryCounter(v5.MissingData, 1, { dataType = p2 })

		return
	end

	local missingData = v5.MissingData

	if not fFlagLuaAppEdpBackendV2LogUniverseIdForEvents then
		universeId = nil
	end

	default:logRobloxTelemetryEvent(missingData, {}, {
		dataType = p2,
		universeId = universeId
	})
end

function v5.logInvalidData(p2, universeId)
	if not defineFastFlag then
		default:logRobloxTelemetryCounter(v5.InvalidData, 1, { dataType = p2 })

		return
	end

	local invalidData = v5.InvalidData

	if not fFlagLuaAppEdpBackendV2LogUniverseIdForEvents then
		universeId = nil
	end

	default:logRobloxTelemetryEvent(invalidData, {}, {
		dataType = p2,
		universeId = universeId
	})
end

function v5.logFetchRequest(p2, universeId)
	if not (defineFastFlag and v5.FetchRequestEvent) then
		default:logRobloxTelemetryCounter(v5.FetchRequest, 1, { requestType = p2 })

		return
	end

	default:logRobloxTelemetryEvent(v5.FetchRequest, {}, {
		requestType = p2,
		universeId = if fFlagLuaAppEdpBackendV2LogUniverseIdForEvents then universeId else nil
	})

	local fetchRequestEvent = v5.FetchRequestEvent

	if not fFlagLuaAppEdpBackendV2LogUniverseIdForEvents then
		universeId = nil
	end

	default:logRobloxTelemetryEvent(fetchRequestEvent, {}, {
		requestType = p2,
		universeId = universeId
	})
end

function v5.logFetchMissingData(p2, universeId)
	if not defineFastFlag then
		default:logRobloxTelemetryCounter(v5.FetchMissingData, 1, { dataType = p2 })

		return
	end

	local fetchMissingData = v5.FetchMissingData

	if not fFlagLuaAppEdpBackendV2LogUniverseIdForEvents then
		universeId = nil
	end

	default:logRobloxTelemetryEvent(fetchMissingData, {}, {
		dataType = p2,
		universeId = universeId
	})
end

if fFlagLuaAppEdpBackendV2LogFetchSuccessAndFailure and v5.FetchSuccess and v5.FetchSuccessEvent then
	function v5.logFetchSuccess(universeId)
		if not defineFastFlag then
			default:logRobloxTelemetryCounter(v5.FetchSuccess, 1)

			return
		end

		default:logRobloxTelemetryEvent(v5.FetchSuccessEvent, {}, {
			universeId = if fFlagLuaAppEdpBackendV2LogUniverseIdForEvents then universeId else nil
		})

		local fetchSuccess = v5.FetchSuccess

		if not fFlagLuaAppEdpBackendV2LogUniverseIdForEvents then
			universeId = nil
		end

		default:logRobloxTelemetryCounter(fetchSuccess, 1, { universeId = universeId })
	end
end

if fFlagLuaAppEdpBackendV2LogFetchSuccessAndFailure and v5.FetchFailure and v5.FetchFailureEvent then
	function v5.logFetchFailure(p2, p3, p4)
		default:logRobloxTelemetryEvent(v5.FetchFailureEvent, {}, {
			universeId = p2,
			errorCode = p3,
			errorMessage = p4
		})

		default:logRobloxTelemetryCounter(v5.FetchFailure, 1, {
			universeId = p2,
			errorCode = p3,
			errorMessage = p4
		})
	end
end

if
	(fFlagLuaAppEdpBackendV2SduiInterleaveDefault or fFlagLuaAppEdpBackendV2SduiInterleaveIxp)
	and v5.SduiLayoutOrderConflict
then
	function v5.logSduiLayoutOrderConflict(p2)
		default:logRobloxTelemetryEvent(v5.SduiLayoutOrderConflict, {}, p2)
	end
end

if
	(fFlagLuaAppEdpBackendV2SduiInterleaveDefault or fFlagLuaAppEdpBackendV2SduiInterleaveIxp)
	and v5.VisibilityVariables
then
	function v5.logVisibilityVariables(p2)
		default:logRobloxTelemetryEvent(v5.VisibilityVariables, {}, {
			presentVarsString = p2
		})
	end
end

return v5
