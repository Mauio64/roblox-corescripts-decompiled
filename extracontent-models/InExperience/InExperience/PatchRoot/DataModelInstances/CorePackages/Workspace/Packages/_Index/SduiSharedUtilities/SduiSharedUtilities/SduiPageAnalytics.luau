local TelemetryService = game:GetService("TelemetryService")
local SduiSharedUtilities = script:FindFirstAncestor("SduiSharedUtilities")

require(SduiSharedUtilities.SduiIntegrationTypes)

local v3 = game:DefineFastInt("SduiPageTimerEventHundredthsPercent", 0)
local v4 = game:DefineFastInt("SduiLoadMoreFromApiEventHundredthsPercent", 0)
local t1 = {
	eventName = "Sdui_PageLoadTimer",
	description = "Duration for sdui page loading, network requests",
	lastUpdated = {
		25,
		11,
		18
	},
	backends = {
		"Points",
		"EventIngest"
	},
	throttlingPercentage = v3
}
local t2 = {
	eventName = "Sdui_LoadMoreFromApi",
	description = "Event log for pagination request",
	lastUpdated = {
		26,
		1,
		9
	},
	backends = {
		"Points",
		"EventIngest"
	},
	throttlingPercentage = v4
}
local t3 = {
	eventName = "Sdui_PageStatus",
	description = "Status code for sdui page requests",
	backends = { "RobloxTelemetryCounter" },
	lastUpdated = {
		25,
		11,
		18
	}
}
local t4 = {
	eventName = "Sdui_PagePayloadSize",
	description = "Payload size for sdui page requests",
	backends = { "RobloxTelemetryStat" },
	lastUpdated = {
		25,
		11,
		19
	}
}
local t5 = {
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

return {
	sendLoadTimerEvent = function(t6: {[any]: any}) -- line: 66
		-- upvalues: TelemetryService (copy), t1 (copy)
		TelemetryService:LogEvent(t1, {
			customFields = t6,
			standardizedFields = { "addOSInfo" }
		})
	end,
	sendPageStatusEvent = function(s1: string, n1: number?, p1) -- line: 89
		-- upvalues: TelemetryService (copy), t3 (copy), t5 (copy)
		TelemetryService:LogCounter(t3, {
			customFields = {
				pageKey = s1,
				statusCode = n1 or "unknown",
				httpError = if not p1 then nil else t5[p1]
			}
		})
	end,
	sendPagePayloadSizeEvent = function(s2: string, p2) -- line: 99
		-- upvalues: TelemetryService (copy), t4 (copy)
		local v16

		if typeof(p2) == "buffer" then
			v16 = buffer.len(p2)
		else
			if typeof(p2) ~= "string" then
				return
			end

			v16 = string.len(p2)
		end

		TelemetryService:LogStat(t4, {
			customFields = {
				pageKey = s2
			}
		}, v16)
	end,
	sendLoadMoreEvent = function(s3: string) -- line: 115
		-- upvalues: TelemetryService (copy), t2 (copy)
		TelemetryService:LogEvent(t2, {
			customFields = {
				surfaceKey = s3
			},
			standardizedFields = { "addOSInfo" }
		})
	end
}
