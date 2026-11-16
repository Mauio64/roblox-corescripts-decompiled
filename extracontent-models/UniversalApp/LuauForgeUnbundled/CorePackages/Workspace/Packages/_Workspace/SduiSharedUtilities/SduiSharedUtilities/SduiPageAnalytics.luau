local TelemetryService = game:GetService("TelemetryService")

require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiSharedUtilities/SduiIntegrationTypes")

local v5 = {
	eventName = "Sdui_PageLoadTimer",
	description = "Duration for sdui page loading, network requests",
	lastUpdated = { 25, 11, 18 },
	backends = { "Points", "EventIngest" },
	throttlingPercentage = game:DefineFastInt("SduiPageTimerEventHundredthsPercent", 0)
}
local v6 = {
	eventName = "Sdui_LoadMoreFromApi",
	description = "Event log for pagination request",
	lastUpdated = { 26, 1, 9 },
	backends = { "Points", "EventIngest" },
	throttlingPercentage = game:DefineFastInt("SduiLoadMoreFromApiEventHundredthsPercent", 0)
}

local v7 = {
	eventName = "Sdui_PageStatus",
	backends = { "RobloxTelemetryCounter" },
	lastUpdated = { 25, 11, 18 },
	description = "Status code for sdui page requests"
}

local v8 = {
	eventName = "Sdui_PagePayloadSize",
	backends = { "RobloxTelemetryStat" },
	lastUpdated = { 25, 11, 19 },
	description = "Payload size for sdui page requests"
}

local v9 = {
	eventName = "Sdui_RequestOutcome",
	backends = { "RobloxTelemetryCounter" },
	lastUpdated = { 26, 8, 31 },
	description = "Terminal outcome of sdui page requests, bucketed by endpoint"
}

local v10 = {
	eventName = "Sdui_RequestRetry",
	backends = { "RobloxTelemetryCounter" },
	lastUpdated = { 26, 8, 31 },
	description = "Retry attempts for sdui page requests, bucketed by endpoint"
}

local v11 = {
	[Enum.HttpError.OK] = "OK",
	[Enum.HttpError.InvalidUrl] = "InvalidUrl",
	[Enum.HttpError.DnsResolve] = "DnsResolve",
	[Enum.HttpError.ConnectFail] = "ConnectFail",
	[Enum.HttpError.OutOfMemory] = "OutOfMemory",
	[Enum.HttpError.TimedOut] = "Timedout",
	[Enum.HttpError.TooManyRedirects] = "TooManyRedirects",
	[Enum.HttpError.InvalidRedirect] = "InvalidRedirect",
	[Enum.HttpError.NetFail] = "NetFail",
	[Enum.HttpError.Aborted] = "Aborted",
	[Enum.HttpError.SslConnectFail] = "SslConnectFail",
	[Enum.HttpError.SslVerificationFail] = "SslVerificationFail",
	[Enum.HttpError.Unknown] = "Unknown"
}

local v12 = {
	eventName = "Sdui_MissingRoot",
	backends = { "RobloxTelemetryCounter" },
	lastUpdated = { 26, 10, 5 },
	description = "Mounted SDUI content has no root after the request deadline and grace period"
}

local v13 = {
	eventName = "Sdui_StaleResponseDiscarded",
	backends = { "RobloxTelemetryCounter" },
	lastUpdated = { 26, 10, 6 },
	description = "SDUI response work discarded after the authenticated account changed"
}
return {
	sendLoadTimerEvent = function(p2)
		TelemetryService:LogEvent(v5, {
			customFields = p2,
			standardizedFields = { "addOSInfo" }
		})
	end,
	sendPageStatusEvent = function(p2, value, p3)
		local v18 = if p3 then v11[p3] else nil
		TelemetryService:LogCounter(v7, {
			customFields = {
				pageKey = p2,
				statusCode = value or "unknown",
				httpError = v18
			}
		})
	end,
	sendPagePayloadSizeEvent = function(p2, value)
		local v14

		if typeof(value) == "buffer" then
			v14 = buffer.len(value)
		elseif typeof(value) == "string" then
			v14 = string.len(value)
		else
			return
		end

		TelemetryService:LogStat(v8, {
			customFields = { pageKey = p2 }
		}, v14)
	end,
	sendLoadMoreEvent = function(p2)
		TelemetryService:LogEvent(v6, {
			customFields = { surfaceKey = p2 },
			standardizedFields = { "addOSInfo" }
		})
	end,
	sendRequestOutcomeCounter = function(p2, p3, p4, value, p5)
		local v18 = if p5 ~= nil and p5 ~= Enum.HttpError.OK then v11[p5] else nil
		TelemetryService:LogCounter(v9, {
			customFields = {
				pageKey = p2,
				endpoint = p3,
				outcome = p4,
				statusCode = value or "unknown",
				httpError = v18
			}
		})
	end,
	sendRequestRetryCounter = function(p2, p3, p4)
		TelemetryService:LogCounter(v10, {
			customFields = { pageKey = p2, endpoint = p3, attempt = p4 }
		})
	end,
	sendMissingRoot = function(p2, p3, p4)
		TelemetryService:LogCounter(v12, {
			customFields = {
				surface = p2,
				status = p3 ~= "Ready" and p3 ~= "NotReady" and p3 ~= "Failed" and "unknown" or p3,
				inFlight = tostring(p4)
			},
			standardizedFields = { "addOSInfo" }
		})
	end,
	sendStaleResponseDiscarded = function(p2, p3, p4)
		TelemetryService:LogCounter(v13, {
			customFields = { surface = p2, mode = p3, stage = p4 },
			standardizedFields = { "addOSInfo" }
		})
	end
}
