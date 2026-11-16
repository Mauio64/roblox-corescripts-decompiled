local TelemetryService = game:GetService("TelemetryService")
local SduiSharedUtilities = script:FindFirstAncestor("SduiSharedUtilities")

require(SduiSharedUtilities.SduiIntegrationTypes)

local v = {
	eventName = "Sdui_PageLoadTimer",
	description = "Duration for sdui page loading, network requests",
	lastUpdated = { 25, 11, 18 },
	backends = { "Points", "EventIngest" },
	throttlingPercentage = game:DefineFastInt("SduiPageTimerEventHundredthsPercent", 0)
}
local v2 = {
	eventName = "Sdui_LoadMoreFromApi",
	description = "Event log for pagination request",
	lastUpdated = { 26, 1, 9 },
	backends = { "Points", "EventIngest" },
	throttlingPercentage = game:DefineFastInt("SduiLoadMoreFromApiEventHundredthsPercent", 0)
}

local v3 = {
	eventName = "Sdui_PageStatus",
	backends = { "RobloxTelemetryCounter" },
	lastUpdated = { 25, 11, 18 },
	description = "Status code for sdui page requests"
}

local v4 = {
	eventName = "Sdui_PagePayloadSize",
	backends = { "RobloxTelemetryStat" },
	lastUpdated = { 25, 11, 19 },
	description = "Payload size for sdui page requests"
}

local v5 = {
	eventName = "Sdui_RequestOutcome",
	backends = { "RobloxTelemetryCounter" },
	lastUpdated = { 26, 8, 31 },
	description = "Terminal outcome of sdui page requests, bucketed by endpoint"
}

local v6 = {
	eventName = "Sdui_RequestRetry",
	backends = { "RobloxTelemetryCounter" },
	lastUpdated = { 26, 8, 31 },
	description = "Retry attempts for sdui page requests, bucketed by endpoint"
}

local v7 = {
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

local v8 = {
	eventName = "Sdui_MissingRoot",
	backends = { "RobloxTelemetryCounter" },
	lastUpdated = { 26, 10, 5 },
	description = "Mounted SDUI content has no root after the request deadline and grace period"
}

local v9 = {
	eventName = "Sdui_StaleResponseDiscarded",
	backends = { "RobloxTelemetryCounter" },
	lastUpdated = { 26, 10, 6 },
	description = "SDUI response work discarded after the authenticated account changed"
}
local SduiPageAnalytics = {}

function SduiPageAnalytics.sendLoadTimerEvent(customFields)
	TelemetryService:LogEvent(v, {
		customFields = customFields,
		standardizedFields = { "addOSInfo" }
	})
end

function SduiPageAnalytics.sendPageStatusEvent(pageKey: string, value: number?, p)
	local customFields = {
		pageKey = pageKey,
		statusCode = value or "unknown",
		httpError = 0
	}
	local httpError

	if p then
		httpError = v7[p]
	end

	customFields.httpError = httpError
	TelemetryService:LogCounter(v3, { customFields = customFields })
end

function SduiPageAnalytics.sendPagePayloadSizeEvent(pageKey: string, value)
	local v10

	if typeof(value) == "buffer" then
		v10 = buffer.len(value)
	elseif typeof(value) == "string" then
		v10 = string.len(value)
	else
		return
	end

	TelemetryService:LogStat(v4, {
		customFields = { pageKey = pageKey }
	}, v10)
end

function SduiPageAnalytics.sendLoadMoreEvent(surfaceKey: string)
	TelemetryService:LogEvent(v2, {
		customFields = { surfaceKey = surfaceKey },
		standardizedFields = { "addOSInfo" }
	})
end

function SduiPageAnalytics.sendRequestOutcomeCounter(pageKey: string, endpoint: string, outcome: string, value: number?, p)
	local customFields = {
		pageKey = pageKey,
		endpoint = endpoint,
		outcome = outcome,
		statusCode = value or "unknown",
		httpError = 0
	}
	local httpError

	if not (p == nil or p == Enum.HttpError.OK) then
		httpError = v7[p]
	end

	customFields.httpError = httpError
	TelemetryService:LogCounter(v5, { customFields = customFields })
end

function SduiPageAnalytics.sendRequestRetryCounter(pageKey: string, endpoint: string, attempt: number)
	TelemetryService:LogCounter(v6, {
		customFields = { pageKey = pageKey, endpoint = endpoint, attempt = attempt }
	})
end

function SduiPageAnalytics.sendMissingRoot(surface: string, p: string, flag: boolean)
	TelemetryService:LogCounter(v8, {
		customFields = {
			surface = surface,
			status = p ~= "Ready" and p ~= "NotReady" and p ~= "Failed" and "unknown" or p,
			inFlight = tostring(flag)
		},
		standardizedFields = { "addOSInfo" }
	})
end

function SduiPageAnalytics.sendStaleResponseDiscarded(surface: string, mode: string, stage: string)
	TelemetryService:LogCounter(v9, {
		customFields = { surface = surface, mode = mode, stage = stage },
		standardizedFields = { "addOSInfo" }
	})
end

return SduiPageAnalytics
