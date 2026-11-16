local TelemetryService = game:GetService("TelemetryService")

require(script.Parent.types)

local defineFastInt = game:DefineFastInt("LuaHttpClientRequestTimerEventHundredthsPercent", 0)
game:DefineFastInt("LuaHttpClientRequestStatusEventHundredthsPercent", 0)
game:DefineFastInt("LuaHttpClientPayloadSizeEventHundredthsPercent", 0)

local function shouldSample(fastInt): boolean -- 2 equivalent calls inferred from this helper
	return not (fastInt <= 0) and (fastInt >= 10000 or math.random(1, 10000) <= fastInt)
end

local v = {
	eventName = "LuaHttpClient_RequestTimer",
	description = "Duration for lua-apps http-client HTTP requests, bucketed by analyticsKey",
	lastUpdated = { 26, 5, 29 },
	backends = { "Points", "EventIngest" },
	throttlingPercentage = defineFastInt
}

local v2 = {
	eventName = "LuaHttpClient_RequestStatus",
	description = "Status code + final state for lua-apps http-client HTTP requests",
	lastUpdated = { 26, 5, 29 },
	backends = { "RobloxTelemetryCounter" }
}

local v3 = {
	eventName = "LuaHttpClient_PayloadSize",
	description = "Response payload size for lua-apps http-client HTTP requests",
	lastUpdated = { 26, 5, 29 },
	backends = { "RobloxTelemetryStat" }
}

local v4 = {
	[Enum.HttpError.OK] = "OK",
	[Enum.HttpError.InvalidUrl] = "InvalidUrl",
	[Enum.HttpError.DnsResolve] = "DnsResolve",
	[Enum.HttpError.ConnectFail] = "ConnectFail",
	[Enum.HttpError.OutOfMemory] = "OutOfMemory",
	[Enum.HttpError.TimedOut] = "TimedOut",
	[Enum.HttpError.TooManyRedirects] = "TooManyRedirects",
	[Enum.HttpError.InvalidRedirect] = "InvalidRedirect",
	[Enum.HttpError.NetFail] = "NetFail",
	[Enum.HttpError.Aborted] = "Aborted",
	[Enum.HttpError.SslConnectFail] = "SslConnectFail",
	[Enum.HttpError.SslVerificationFail] = "SslVerificationFail",
	[Enum.HttpError.Unknown] = "Unknown"
}

local function payloadSizeOf(responseBody) -- 1 equivalent call inferred from this helper
	if typeof(responseBody) == "buffer" then
		return buffer.len(responseBody)
	end

	if typeof(responseBody) == "string" then
		return (string.len(responseBody))
	end

	return nil
end

local v5 = {
	"DurationInQueue",
	"DurationNameLookup",
	"DurationConnect",
	"DurationSSLHandshake",
	"DurationMakeRequest",
	"DurationReceiveResponse",
	"RoundTripTime"
}

return {
	defaultAnalytics = function(analyticsKey: string, method, _: string, data, durationMs: number, status)
		local customFields = {
			analyticsKey = analyticsKey,
			method = method,
			durationMs = durationMs,
			status = status
		}

		if data and data.stats then
			for _, v6 in v5 do
				local stat = data.stats[v6]

				if typeof(stat) == "number" then
					customFields[v6] = stat * 1000
				end
			end

			local wasRequestRetried = data.stats.WasRequestRetried

			if typeof(wasRequestRetried) == "number" then
				customFields.WasRequestRetried = wasRequestRetried
			end
		end

		TelemetryService:LogEvent(v, {
			customFields = customFields,
			standardizedFields = { "addOSInfo" }
		})

		if shouldSample(game:GetFastInt("LuaHttpClientRequestStatusEventHundredthsPercent")) then -- inferred equivalent call
			local customFields2 = {
				analyticsKey = analyticsKey,
				method = method,
				status = status,
				statusCode = data and data.statusCode or "unknown",
				httpError = 0
			}
			local httpError

			if data and data.httpError then
				httpError = v4[data.httpError]
			end

			customFields2.httpError = httpError
			TelemetryService:LogCounter(v2, { customFields = customFields2 })
		end

		local v6

		if data then
			v6 = payloadSizeOf(data.responseBody) -- inferred equivalent call
		end

		if v6 ~= nil and shouldSample(game:GetFastInt("LuaHttpClientPayloadSizeEventHundredthsPercent")) then -- inferred equivalent call
			TelemetryService:LogStat(v3, {
				customFields = { analyticsKey = analyticsKey }
			}, v6)
		end
	end
}
