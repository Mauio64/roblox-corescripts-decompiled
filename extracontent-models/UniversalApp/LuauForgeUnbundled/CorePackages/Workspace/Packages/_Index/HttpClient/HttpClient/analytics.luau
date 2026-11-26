local TelemetryService = game:GetService("TelemetryService")

require("@game/CorePackages/Workspace/Packages/_Index/HttpClient/HttpClient/types")

local defineFastInt = game:DefineFastInt("LuaHttpClientRequestTimerEventHundredthsPercent", 0)
game:DefineFastInt("LuaHttpClientRequestStatusEventHundredthsPercent", 0)
game:DefineFastInt("LuaHttpClientPayloadSizeEventHundredthsPercent", 0)

local function shouldSample(p2): boolean
	if p2 <= 0 then
		return false
	end

	if p2 >= 10000 then
		return true
	end

	return math.random(1, 10000) <= p2
end

local v5 = {
	eventName = "LuaHttpClient_RequestTimer",
	description = "Duration for lua-apps http-client HTTP requests, bucketed by analyticsKey",
	lastUpdated = { 26, 5, 29 },
	backends = { "Points", "EventIngest" },
	throttlingPercentage = defineFastInt
}

local v6 = {
	eventName = "LuaHttpClient_RequestStatus",
	description = "Status code + final state for lua-apps http-client HTTP requests",
	lastUpdated = { 26, 5, 29 },
	backends = { "RobloxTelemetryCounter" }
}

local v7 = {
	eventName = "LuaHttpClient_PayloadSize",
	description = "Response payload size for lua-apps http-client HTTP requests",
	lastUpdated = { 26, 5, 29 },
	backends = { "RobloxTelemetryStat" }
}

local v8 = {
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

local function payloadSizeOf(value)
	if typeof(value) == "buffer" then
		return buffer.len(value)
	end

	if typeof(value) == "string" then
		return (string.len(value))
	end

	return nil
end

local v9 = {
	"DurationInQueue",
	"DurationNameLookup",
	"DurationConnect",
	"DurationSSLHandshake",
	"DurationMakeRequest",
	"DurationReceiveResponse",
	"RoundTripTime"
}

return {
	defaultAnalytics = function(p2, p3, p4, data, p5, p6)
		local v10 = { analyticsKey = p2, method = p3, durationMs = p5, status = p6 }

		if data and data.stats then
			for k, v11 in v9 do
				local stat = data.stats[v11]

				if typeof(stat) == "number" then
					v10[v11] = stat * 1000
				end
			end

			local wasRequestRetried = data.stats.WasRequestRetried

			if typeof(wasRequestRetried) == "number" then
				v10.WasRequestRetried = wasRequestRetried
			end
		end

		TelemetryService:LogEvent(v5, {
			customFields = v10,
			standardizedFields = { "addOSInfo" }
		})

		local fastInt = game:GetFastInt("LuaHttpClientRequestStatusEventHundredthsPercent")
		local v11 = not (fastInt <= 0) and (fastInt >= 10000 or math.random(1, 10000) <= fastInt)

		if v11 then
			local v15 = {
				analyticsKey = p2,
				method = p3,
				status = p6,
				statusCode = data and data.statusCode or "unknown",
				httpError = 0
			}
			local v16 = if data and data.httpError then v8[data.httpError] else nil
			v15.httpError = v16
			TelemetryService:LogCounter(v6, { customFields = v15 })
		end

		local v12

		if data then
			local responseBody = data.responseBody

			if typeof(responseBody) == "buffer" then
				v12 = buffer.len(responseBody)
			elseif typeof(responseBody) == "string" then
				v12 = string.len(responseBody)
			end
		end

		if v12 ~= nil then
			local fastInt2 = game:GetFastInt("LuaHttpClientPayloadSizeEventHundredthsPercent")
			local v13 = not (fastInt2 <= 0) and (fastInt2 >= 10000 or math.random(1, 10000) <= fastInt2)

			if v13 then
				TelemetryService:LogStat(v7, {
					customFields = { analyticsKey = p2 }
				}, v12)
			end
		end
	end
}
