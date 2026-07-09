local TelemetryService = game:GetService("TelemetryService")
local t1 = {
	eventName = "LuaAppSentryReporterInit",
	description = "Counter to track SentryReporter initialization success and failure.",
	backends = { "RobloxTelemetryCounter" },
	lastUpdated = {
		2026,
		2,
		19
	}
}
local t2 = {
	eventName = "LuaAppSentryReporterErrorSent",
	description = "Track successful and failed error reports to Sentry",
	backends = { "RobloxTelemetryCounter" },
	lastUpdated = {
		2026,
		2,
		19
	}
}
local t3 = {
	eventName = "LuaAppSentryReporterLogAttachment",
	description = "Track successful and failed log attachments to Sentry",
	backends = { "RobloxTelemetryCounter" },
	lastUpdated = {
		2026,
		2,
		19
	}
}

return {
	logInitSuccess = function() -- line: 143
		-- upvalues: TelemetryService (copy), t1 (copy)
		TelemetryService:LogCounter(t1, {
			customFields = {
				isSuccess = "true"
			}
		}, 1)
	end,
	logInitFailure = function() -- line: 166
		-- upvalues: TelemetryService (copy), t1 (copy)
		TelemetryService:LogCounter(t1, {
			customFields = {
				isSuccess = "false"
			}
		}, 1)
	end,
	logErrorSentSuccess = function() -- line: 186
		-- upvalues: TelemetryService (copy), t2 (copy)
		TelemetryService:LogCounter(t2, {
			customFields = {
				isSuccess = "true"
			}
		}, 1)
	end,
	logErrorSentFailure = function() -- line: 206
		-- upvalues: TelemetryService (copy), t2 (copy)
		TelemetryService:LogCounter(t2, {
			customFields = {
				isSuccess = "false"
			}
		}, 1)
	end,
	logLogAttachmentSuccess = function() -- line: 226
		-- upvalues: TelemetryService (copy), t3 (copy)
		TelemetryService:LogCounter(t3, {
			customFields = {
				isSuccess = "true"
			}
		}, 1)
	end,
	logLogAttachmentFailure = function() -- line: 246
		-- upvalues: TelemetryService (copy), t3 (copy)
		TelemetryService:LogCounter(t3, {
			customFields = {
				isSuccess = "false"
			}
		}, 1)
	end
}
