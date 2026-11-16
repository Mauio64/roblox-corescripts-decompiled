local TelemetryService = game:GetService("TelemetryService")

local v5 = {
	eventName = "LuaAppSentryReporterInit",
	backends = { "RobloxTelemetryCounter" },
	lastUpdated = { 2026, 2, 19 },
	description = "Counter to track SentryReporter initialization success and failure."
}

local v6 = {
	eventName = "LuaAppSentryReporterErrorSent",
	backends = { "RobloxTelemetryCounter" },
	lastUpdated = { 2026, 2, 19 },
	description = "Track successful and failed error reports to Sentry"
}

local v7 = {
	eventName = "LuaAppSentryReporterQueue",
	backends = { "RobloxTelemetryCounter" },
	lastUpdated = { 2026, 8, 27 },
	description = "Track reports entering and leaving the Sentry queue"
}

local v8 = {
	eventName = "LuaAppSentryReporterLogAttachment",
	backends = { "RobloxTelemetryCounter" },
	lastUpdated = { 2026, 2, 19 },
	description = "Track successful and failed log attachments to Sentry"
}

return {
	logInitSuccess = function()
		TelemetryService:LogCounter(v5, {
			customFields = { isSuccess = "true" }
		}, 1)
	end,
	logInitFailure = function()
		TelemetryService:LogCounter(v5, {
			customFields = { isSuccess = "false" }
		}, 1)
	end,
	logErrorSentSuccess = function()
		TelemetryService:LogCounter(v6, {
			customFields = { isSuccess = "true" }
		}, 1)
	end,
	logErrorSentFailure = function()
		TelemetryService:LogCounter(v6, {
			customFields = { isSuccess = "false" }
		}, 1)
	end,
	logLogAttachmentSuccess = function()
		TelemetryService:LogCounter(v8, {
			customFields = { isSuccess = "true" }
		}, 1)
	end,
	logLogAttachmentFailure = function()
		TelemetryService:LogCounter(v8, {
			customFields = { isSuccess = "false" }
		}, 1)
	end,
	logErrorQueued = function()
		TelemetryService:LogCounter(v7, {
			customFields = { tag_stage = "queued" }
		}, 1)
	end,
	logErrorFlushed = function(p2)
		TelemetryService:LogCounter(v7, {
			customFields = { tag_stage = "flushed" }
		}, p2)
	end
}
