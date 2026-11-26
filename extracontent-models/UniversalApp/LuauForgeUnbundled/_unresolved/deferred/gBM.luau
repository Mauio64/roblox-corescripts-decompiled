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

local v5 = {
	ParseFailure = {
		eventName = "experienceDetailsParseFailure",
		backends = { default.TelemetryBackends.EventIngest, default.TelemetryBackends.Points },
		throttlingPercentage = defineFastInt,
		description = "\"Failed to parse data from API response\"",
		lastUpdated = { 25, 8, 7 },
		links = "https://roblox.atlassian.net/wiki/x/q4Ji4w"
	},
	MissingData = {
		eventName = "experienceDetailsMissingData",
		backends = { default.TelemetryBackends.EventIngest, default.TelemetryBackends.Points },
		throttlingPercentage = defineFastInt,
		description = "\"Data missing from API response\"",
		lastUpdated = { 25, 8, 7 },
		links = "https://roblox.atlassian.net/wiki/x/q4Ji4w"
	},
	InvalidData = {
		eventName = "experienceDetailsInvalidData",
		backends = { default.TelemetryBackends.EventIngest, default.TelemetryBackends.Points },
		throttlingPercentage = defineFastInt,
		description = "\"Invalid data found in API response\"",
		lastUpdated = { 25, 8, 7 },
		links = "https://roblox.atlassian.net/wiki/x/q4Ji4w"
	},
	SduiLayoutOrderConflict = (fFlagLuaAppEdpBackendV2SduiInterleaveDefault or fFlagLuaAppEdpBackendV2SduiInterleaveIxp) and {
		eventName = "experienceDetailsSduiLayoutOrderConflict",
		backends = { default.TelemetryBackends.EventIngest, default.TelemetryBackends.Points },
		throttlingPercentage = defineFastInt,
		description = "\"SDUI component layout order conflicts with existing EDP layout order\"",
		lastUpdated = { 25, 8, 28 },
		links = "https://roblox.atlassian.net/wiki/x/q4Ji4w"
	} or nil,
	FetchRequest = {
		eventName = "experienceDetailsFetchRequest",
		backends = { default.TelemetryBackends.EventIngest, default.TelemetryBackends.Points },
		throttlingPercentage = defineFastInt2,
		description = "\"Experience details page fetch request\"",
		lastUpdated = { 25, 10, 29 },
		links = "https://roblox.atlassian.net/wiki/x/q4Ji4w"
	},
	FetchRequestEvent = {
		eventName = "experienceDetailsFetchRequestEvent",
		backends = { default.TelemetryBackends.EventIngest, default.TelemetryBackends.Points },
		throttlingPercentage = defineFastInt2,
		description = "Experience details page fetch request",
		lastUpdated = { 25, 10, 29 },
		links = "https://roblox.atlassian.net/wiki/x/q4Ji4w"
	},
	FetchMissingData = {
		eventName = "experienceDetailsFetchMissingData",
		backends = { default.TelemetryBackends.EventIngest, default.TelemetryBackends.Points },
		throttlingPercentage = defineFastInt,
		description = "\"Data missing during fetch request\"",
		lastUpdated = { 25, 8, 7 },
		links = "https://roblox.atlassian.net/wiki/x/q4Ji4w"
	},
	FetchSuccess = fFlagLuaAppEdpBackendV2LogFetchSuccessAndFailure and {
		eventName = "experienceDetailsFetchSuccess",
		backends = { default.TelemetryBackends.Counter },
		throttlingPercentage = defineFastInt2,
		description = "\"Fetch request succeeded\"",
		lastUpdated = { 25, 10, 29 },
		links = "https://roblox.atlassian.net/wiki/x/q4Ji4w"
	} or nil,
	FetchSuccessEvent = fFlagLuaAppEdpBackendV2LogFetchSuccessAndFailure and {
		eventName = "experienceDetailsFetchSuccessEvent",
		backends = { default.TelemetryBackends.EventIngest, default.TelemetryBackends.Points },
		throttlingPercentage = defineFastInt2,
		description = "Fetch request succeeded",
		lastUpdated = { 25, 10, 29 },
		links = "https://roblox.atlassian.net/wiki/x/q4Ji4w"
	} or nil,
	FetchFailure = fFlagLuaAppEdpBackendV2LogFetchSuccessAndFailure and {
		eventName = "experienceDetailsFetchFailure",
		backends = { default.TelemetryBackends.Counter, default.TelemetryBackends.Points },
		throttlingPercentage = defineFastInt2,
		description = "\"Fetch request failed\"",
		lastUpdated = { 25, 10, 29 },
		links = "https://roblox.atlassian.net/wiki/x/q4Ji4w"
	} or nil,
	FetchFailureEvent = fFlagLuaAppEdpBackendV2LogFetchSuccessAndFailure and {
		eventName = "experienceDetailsFetchFailureEvent",
		backends = { default.TelemetryBackends.EventIngest, default.TelemetryBackends.Points },
		throttlingPercentage = defineFastInt2,
		description = "Fetch request failed",
		lastUpdated = { 25, 10, 29 },
		links = "https://roblox.atlassian.net/wiki/x/q4Ji4w"
	} or nil,
	VisibilityVariables = {
		eventName = "experienceDetailsVisibilityVariables",
		backends = { default.TelemetryBackends.Points },
		throttlingPercentage = defineFastInt,
		description = "\"Visibility variables\"",
		lastUpdated = { 25, 11, 12 },
		links = "https://roblox.atlassian.net/wiki/x/q4Ji4w"
	}
}

function v5.logParseFailure(p2, universeId)
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
