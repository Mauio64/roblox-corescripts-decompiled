local TelemetryService = game:GetService("TelemetryService")

require(script.Parent.types)

local v2 = game:DefineFastInt("LuaHttpClientRequestTimerEventHundredthsPercent", 0)

game:DefineFastInt("LuaHttpClientRequestStatusEventHundredthsPercent", 0)
game:DefineFastInt("LuaHttpClientPayloadSizeEventHundredthsPercent", 0)

local function shouldSample(p1) -- line: 18
	if p1 <= 0 then
		return false
	end

	if p1 >= 10000 then
		return true
	end

	return p1 >= math.random(1, 10000)
end

local t1 = {
	eventName = "LuaHttpClient_RequestTimer",
	description = "Duration for lua-apps http-client HTTP requests, bucketed by analyticsKey",
	lastUpdated = {
		26,
		5,
		29
	},
	backends = {
		"Points",
		"EventIngest"
	},
	throttlingPercentage = v2
}
local t2 = {
	eventName = "LuaHttpClient_RequestStatus",
	description = "Status code + final state for lua-apps http-client HTTP requests",
	lastUpdated = {
		26,
		5,
		29
	},
	backends = { "RobloxTelemetryCounter" }
}
local t3 = {
	eventName = "LuaHttpClient_PayloadSize",
	description = "Response payload size for lua-apps http-client HTTP requests",
	lastUpdated = {
		26,
		5,
		29
	},
	backends = { "RobloxTelemetryStat" }
}
local t4 = {
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

local function payloadSizeOf(p2) -- line: 66
	if typeof(p2) == "buffer" then
		return buffer.len(p2)
	end

	if typeof(p2) == "string" then
		return (string.len(p2))
	end

	return nil
end

local t5 = {
	"DurationInQueue",
	"DurationNameLookup",
	"DurationConnect",
	"DurationSSLHandshake",
	"DurationMakeRequest",
	"DurationReceiveResponse",
	"RoundTripTime"
}

return {
	defaultAnalytics = function(s1: string, p3, _: string, p4, n1: number, p5) -- line: 87
		-- upvalues: t5 (copy), TelemetryService (copy), t1 (copy), t2 (copy), t4 (copy), t3 (copy)
		local t6 = {
			analyticsKey = s1,
			method = p3,
			durationMs = n1,
			status = p5
		}

		if p4 and p4.stats then
			for _, v20 in t5 do
				local v21 = p4.stats[v20]

				if typeof(v21) == "number" then
					t6[v20] = v21 * 1000
				end
			end

			local WasRequestRetried = p4.stats.WasRequestRetried

			if typeof(WasRequestRetried) == "number" then
				t6.WasRequestRetried = WasRequestRetried
			end
		end

		TelemetryService:LogEvent(t1, {
			customFields = t6,
			standardizedFields = { "addOSInfo" }
		})

		local FastInt = game:GetFastInt("LuaHttpClientRequestStatusEventHundredthsPercent")

		if not (FastInt <= 0) and (FastInt >= 10000 or FastInt >= math.random(1, 10000)) then
			TelemetryService:LogCounter(t2, {
				customFields = {
					analyticsKey = s1,
					method = p3,
					status = p5,
					statusCode = p4 and p4.statusCode or "unknown",
					httpError = if not p4 or not p4.httpError then nil else t4[p4.httpError]
				}
			})
		end

		local v25

		if p4 then
			local responseBody = p4.responseBody

			v25 = if typeof(responseBody) ~= "buffer" then if typeof(responseBody) ~= "string" then nil else string.len(responseBody) else buffer.len(responseBody)
		else
			v25 = nil
		end

		if v25 ~= nil then
			local FastInt2 = game:GetFastInt("LuaHttpClientPayloadSizeEventHundredthsPercent")

			if not (FastInt2 <= 0) and (FastInt2 >= 10000 or FastInt2 >= math.random(1, 10000)) then
				TelemetryService:LogStat(t3, {
					customFields = {
						analyticsKey = s1
					}
				}, v25)
			end
		end
	end
}
