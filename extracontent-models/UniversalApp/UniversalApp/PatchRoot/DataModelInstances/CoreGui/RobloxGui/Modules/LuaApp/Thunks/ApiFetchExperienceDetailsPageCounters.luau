local CorePackages = game:GetService("CorePackages")
local default = require(CorePackages.Workspace.Packages.LoggingProtocol).default
local FFlagLuaAppEdpBackendV2LogFetchSuccessAndFailure = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpBackendV2LogFetchSuccessAndFailure
local FFlagLuaAppEdpBackendV2SduiInterleaveDefault = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpBackendV2SduiInterleaveDefault
local FFlagLuaAppEdpBackendV2SduiInterleaveIxp = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpBackendV2SduiInterleaveIxp
local FFlagLuaAppEdpBackendV2LogUniverseIdForEvents = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpBackendV2LogUniverseIdForEvents
local v7 = game:DefineFastInt("ApiFetchExperienceDetailsPageThrottlingHundredthsPercent", 0)
local v8 = game:DefineFastInt("ApiFetchExperienceDetailsPageCounterThrottlingHundredthsPercent", 0)
local v9 = game:DefineFastFlag("LuaAppEdpBackendV2LogMissingFetchEventData3", false)
local t1 = {
	ParseFailure = {
		eventName = "experienceDetailsParseFailure",
		description = "\"Failed to parse data from API response\"",
		links = "https://roblox.atlassian.net/wiki/x/q4Ji4w",
		backends = if not v9 then { default.TelemetryBackends.Counter } else {
			default.TelemetryBackends.EventIngest,
			default.TelemetryBackends.Points
		},
		throttlingPercentage = v7,
		lastUpdated = {
			25,
			8,
			7
		}
	},
	MissingData = {
		eventName = "experienceDetailsMissingData",
		description = "\"Data missing from API response\"",
		links = "https://roblox.atlassian.net/wiki/x/q4Ji4w",
		backends = if not v9 then { default.TelemetryBackends.Counter } else {
			default.TelemetryBackends.EventIngest,
			default.TelemetryBackends.Points
		},
		throttlingPercentage = v7,
		lastUpdated = {
			25,
			8,
			7
		}
	},
	InvalidData = {
		eventName = "experienceDetailsInvalidData",
		description = "\"Invalid data found in API response\"",
		links = "https://roblox.atlassian.net/wiki/x/q4Ji4w",
		backends = if not v9 then { default.TelemetryBackends.Counter } else {
			default.TelemetryBackends.EventIngest,
			default.TelemetryBackends.Points
		},
		throttlingPercentage = v7,
		lastUpdated = {
			25,
			8,
			7
		}
	},
	SduiLayoutOrderConflict = if not FFlagLuaAppEdpBackendV2SduiInterleaveDefault and not FFlagLuaAppEdpBackendV2SduiInterleaveIxp then nil else {
		eventName = "experienceDetailsSduiLayoutOrderConflict",
		description = "\"SDUI component layout order conflicts with existing EDP layout order\"",
		links = "https://roblox.atlassian.net/wiki/x/q4Ji4w",
		backends = {
			default.TelemetryBackends.EventIngest,
			default.TelemetryBackends.Points
		},
		throttlingPercentage = v7,
		lastUpdated = {
			25,
			8,
			28
		}
	},
	FetchRequest = {
		eventName = "experienceDetailsFetchRequest",
		description = "\"Experience details page fetch request\"",
		links = "https://roblox.atlassian.net/wiki/x/q4Ji4w",
		backends = if not v9 then { default.TelemetryBackends.Counter } else {
			default.TelemetryBackends.EventIngest,
			default.TelemetryBackends.Points
		},
		throttlingPercentage = if not v9 then v7 else v8,
		lastUpdated = {
			25,
			10,
			29
		}
	},
	FetchRequestEvent = if not v9 then nil else {
		eventName = "experienceDetailsFetchRequestEvent",
		description = "Experience details page fetch request",
		links = "https://roblox.atlassian.net/wiki/x/q4Ji4w",
		backends = {
			default.TelemetryBackends.EventIngest,
			default.TelemetryBackends.Points
		},
		throttlingPercentage = v8,
		lastUpdated = {
			25,
			10,
			29
		}
	},
	FetchMissingData = {
		eventName = "experienceDetailsFetchMissingData",
		description = "\"Data missing during fetch request\"",
		links = "https://roblox.atlassian.net/wiki/x/q4Ji4w",
		backends = if not v9 then { default.TelemetryBackends.Counter } else {
			default.TelemetryBackends.EventIngest,
			default.TelemetryBackends.Points
		},
		throttlingPercentage = v7,
		lastUpdated = {
			25,
			8,
			7
		}
	},
	FetchSuccess = if not FFlagLuaAppEdpBackendV2LogFetchSuccessAndFailure then nil else {
		eventName = "experienceDetailsFetchSuccess",
		description = "\"Fetch request succeeded\"",
		links = "https://roblox.atlassian.net/wiki/x/q4Ji4w",
		backends = { default.TelemetryBackends.Counter },
		throttlingPercentage = if not v9 then v7 else v8,
		lastUpdated = {
			25,
			10,
			29
		}
	},
	FetchSuccessEvent = if not FFlagLuaAppEdpBackendV2LogFetchSuccessAndFailure then nil else {
		eventName = "experienceDetailsFetchSuccessEvent",
		description = "Fetch request succeeded",
		links = "https://roblox.atlassian.net/wiki/x/q4Ji4w",
		backends = {
			default.TelemetryBackends.EventIngest,
			default.TelemetryBackends.Points
		},
		throttlingPercentage = v8,
		lastUpdated = {
			25,
			10,
			29
		}
	},
	FetchFailure = if not FFlagLuaAppEdpBackendV2LogFetchSuccessAndFailure then nil else {
		eventName = "experienceDetailsFetchFailure",
		description = "\"Fetch request failed\"",
		links = "https://roblox.atlassian.net/wiki/x/q4Ji4w",
		backends = {
			default.TelemetryBackends.Counter,
			default.TelemetryBackends.Points
		},
		throttlingPercentage = v8,
		lastUpdated = {
			25,
			10,
			29
		}
	},
	FetchFailureEvent = if not FFlagLuaAppEdpBackendV2LogFetchSuccessAndFailure then nil else {
		eventName = "experienceDetailsFetchFailureEvent",
		description = "Fetch request failed",
		links = "https://roblox.atlassian.net/wiki/x/q4Ji4w",
		backends = {
			default.TelemetryBackends.EventIngest,
			default.TelemetryBackends.Points
		},
		throttlingPercentage = v8,
		lastUpdated = {
			25,
			10,
			29
		}
	},
	VisibilityVariables = {
		eventName = "experienceDetailsVisibilityVariables",
		description = "\"Visibility variables\"",
		links = "https://roblox.atlassian.net/wiki/x/q4Ji4w",
		backends = { default.TelemetryBackends.Points },
		throttlingPercentage = v7,
		lastUpdated = {
			25,
			11,
			12
		}
	}
}

function t1.logParseFailure(s1: string, s2: string?) -- line: 201
	-- upvalues: v9 (copy), default (copy), t1 (copy), FFlagLuaAppEdpBackendV2LogUniverseIdForEvents (copy)
	if v9 then
		default:logRobloxTelemetryEvent(t1.ParseFailure, {}, {
			dataType = s1,
			universeId = if not FFlagLuaAppEdpBackendV2LogUniverseIdForEvents then nil else s2
		})

		return
	end

	default:logRobloxTelemetryCounter(t1.ParseFailure, 1, {
		dataType = s1
	})
end
function t1.logMissingData(s3: string, s4: string?) -- line: 216
	-- upvalues: v9 (copy), default (copy), t1 (copy), FFlagLuaAppEdpBackendV2LogUniverseIdForEvents (copy)
	if v9 then
		default:logRobloxTelemetryEvent(t1.MissingData, {}, {
			dataType = s3,
			universeId = if not FFlagLuaAppEdpBackendV2LogUniverseIdForEvents then nil else s4
		})

		return
	end

	default:logRobloxTelemetryCounter(t1.MissingData, 1, {
		dataType = s3
	})
end
function t1.logInvalidData(s5: string, s6: string?) -- line: 231
	-- upvalues: v9 (copy), default (copy), t1 (copy), FFlagLuaAppEdpBackendV2LogUniverseIdForEvents (copy)
	if v9 then
		default:logRobloxTelemetryEvent(t1.InvalidData, {}, {
			dataType = s5,
			universeId = if not FFlagLuaAppEdpBackendV2LogUniverseIdForEvents then nil else s6
		})

		return
	end

	default:logRobloxTelemetryCounter(t1.InvalidData, 1, {
		dataType = s5
	})
end
function t1.logFetchRequest(s7: string, s8: string?) -- line: 246
	-- upvalues: v9 (copy), t1 (copy), default (copy), FFlagLuaAppEdpBackendV2LogUniverseIdForEvents (copy)
	if v9 and t1.FetchRequestEvent then
		default:logRobloxTelemetryEvent(t1.FetchRequest, {}, {
			requestType = s7,
			universeId = if not FFlagLuaAppEdpBackendV2LogUniverseIdForEvents then nil else s8
		})
		default:logRobloxTelemetryEvent(t1.FetchRequestEvent, {}, {
			requestType = s7,
			universeId = if not FFlagLuaAppEdpBackendV2LogUniverseIdForEvents then nil else s8
		})

		return
	end

	default:logRobloxTelemetryCounter(t1.FetchRequest, 1, {
		requestType = s7
	})
end
function t1.logFetchMissingData(s9: string, s10: string?) -- line: 265
	-- upvalues: v9 (copy), default (copy), t1 (copy), FFlagLuaAppEdpBackendV2LogUniverseIdForEvents (copy)
	if v9 then
		default:logRobloxTelemetryEvent(t1.FetchMissingData, {}, {
			dataType = s9,
			universeId = if not FFlagLuaAppEdpBackendV2LogUniverseIdForEvents then nil else s10
		})

		return
	end

	default:logRobloxTelemetryCounter(t1.FetchMissingData, 1, {
		dataType = s9
	})
end

if FFlagLuaAppEdpBackendV2LogFetchSuccessAndFailure and (t1.FetchSuccess and t1.FetchSuccessEvent) then
	function t1.logFetchSuccess(s11: string?) -- line: 285
		-- upvalues: v9 (copy), default (copy), t1 (copy), FFlagLuaAppEdpBackendV2LogUniverseIdForEvents (copy)
		if v9 then
			default:logRobloxTelemetryEvent(t1.FetchSuccessEvent, {}, {
				universeId = if not FFlagLuaAppEdpBackendV2LogUniverseIdForEvents then nil else s11
			})
			default:logRobloxTelemetryCounter(t1.FetchSuccess, 1, {
				universeId = if not FFlagLuaAppEdpBackendV2LogUniverseIdForEvents then nil else s11
			})

			return
		end

		default:logRobloxTelemetryCounter(t1.FetchSuccess, 1)
	end
end

if FFlagLuaAppEdpBackendV2LogFetchSuccessAndFailure and t1.FetchFailure and t1.FetchFailureEvent then
	function t1.logFetchFailure(s12: string, n1: number?, s13: string?) -- line: 306
		-- upvalues: default (copy), t1 (copy)
		default:logRobloxTelemetryEvent(t1.FetchFailureEvent, {}, {
			universeId = s12,
			errorCode = n1,
			errorMessage = s13
		})
		default:logRobloxTelemetryCounter(t1.FetchFailure, 1, {
			universeId = s12,
			errorCode = n1,
			errorMessage = s13
		})
	end
end

if (FFlagLuaAppEdpBackendV2SduiInterleaveDefault or FFlagLuaAppEdpBackendV2SduiInterleaveIxp) and t1.SduiLayoutOrderConflict then
	function t1.logSduiLayoutOrderConflict(t2: {[any]: any}) -- line: 328
		-- upvalues: default (copy), t1 (copy)
		default:logRobloxTelemetryEvent(t1.SduiLayoutOrderConflict, {}, t2)
	end
end

if (FFlagLuaAppEdpBackendV2SduiInterleaveDefault or FFlagLuaAppEdpBackendV2SduiInterleaveIxp) and t1.VisibilityVariables then
	function t1.logVisibilityVariables(s14: string) -- line: 345
		-- upvalues: default (copy), t1 (copy)
		default:logRobloxTelemetryEvent(t1.VisibilityVariables, {}, {
			presentVarsString = s14
		})
	end
end

return t1
