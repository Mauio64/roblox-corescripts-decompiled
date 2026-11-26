local client = require("@game/CorePackages/Workspace/Packages/_Workspace/ErrorReporters/SentrySdk").Client
local RunService = game:GetService("RunService")

local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/ErrorReporters/Cryo")
local t = require("@game/CorePackages/Workspace/Packages/_Workspace/ErrorReporters/t")

local ErrorQueue = require("@game/CorePackages/Workspace/Packages/_Workspace/ErrorReporters/ErrorReporters/ErrorQueue")
local FIntOldestUAVersionToReportErrors = require("@game/CorePackages/Workspace/Packages/_Workspace/ErrorReporters/ErrorReporters/FIntOldestUAVersionToReportErrors")

local FIntSentryErrorLevelQueueTimeLimitSeconds = require("@game/CorePackages/Workspace/Packages/_Workspace/ErrorReporters/ErrorReporters/FIntSentryErrorLevelQueueTimeLimitSeconds")

local FIntSentryDebugLevelQueueTimeLimitSeconds = require("@game/CorePackages/Workspace/Packages/_Workspace/ErrorReporters/ErrorReporters/FIntSentryDebugLevelQueueTimeLimitSeconds")
local FFlagSentrySplitQueuesBySeverity = require("@game/CorePackages/Workspace/Packages/_Workspace/ErrorReporters/ErrorReporters/FFlagSentrySplitQueuesBySeverity")
local ErrorReport = require("@game/CorePackages/Workspace/Packages/_Workspace/ErrorReporters/ErrorReporters/Sentry/ErrorReport")
local SentryReporterUtility = require("@game/CorePackages/Workspace/Packages/_Workspace/ErrorReporters/ErrorReporters/Sentry/SentryReporterUtility")
local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/ErrorReporters/ErrorReporters/Sentry/Constants")
local FFlagLuaAppSentryStampOccurrenceTime = require("@game/CorePackages/Workspace/Packages/_Workspace/ErrorReporters/ErrorReporters/Sentry/Flags/FFlagLuaAppSentryStampOccurrenceTime")

local iAttributes = ErrorReport.IAttributes
local iAnnotations = ErrorReport.IAnnotations

local isDevelopmentMode = require("@game/CorePackages/Workspace/Packages/_Workspace/ErrorReporters/ErrorReporters/Sentry/isDevelopmentMode")

local defineFastFlag = game:DefineFastFlag("SentryReportBreadcrumbs", false)

local function latestBreadcrumbs(list)
	local count = #list

	if count <= 100 then
		return list
	end

	local result = {}

	for i = count - 100 + 1, count do
		table.insert(result, list[i])
	end

	return result
end

local function truncateLog(value)
	local v5 = string.len(value)

	if v5 <= 20971520 then
		return value, false
	end

	local v6 = string.format(
		"[LOG TRUNCATED - Original size: %.2f MB, kept latest %.2f MB]\n\n",
		v5 / 1048576,
		20
	)

	return v6 .. string.sub(value, v5 - (20971520 - string.len(v6)) + 1), true
end

local class = {}
class.__index = class

local function createSentryClient(p2, p3, p4, p5)
	return client:new({ dsn = p2, environment = p3, release = p4 }, p5)
end

local function buildErrorKey(value, value2)
	return string.format("%s | %s", value or "", value2 or "")
end

local strictInterface = t.strictInterface({
	httpService = t.some(
		t.instanceOf("HttpService"),
		t.interface({
			JSONEncode = t.callback,
			JSONDecode = t.callback,
			RequestInternal = t.callback
		})
	),
	processErrorReportMethod = t.optional(t.callback),
	debugQueueOptions = t.optional(t.table),
	errorQueueOptions = t.optional(t.table),
	generateLogMethod = t.optional(t.callback),
	logIntervalInSeconds = t.optional(t.numberPositive),
	dsn = t.string,
	environment = t.optional(t.string),
	release = t.optional(t.string),
	errorQueuedCallback = t.optional(t.callback),
	errorFlushedCallback = t.optional(t.callback),
	sentryClientSuccessCallback = t.optional(t.callback),
	sentryClientFailureCallback = t.optional(t.callback),
	logAttachmentSuccessCallback = t.optional(t.callback),
	logAttachmentFailureCallback = t.optional(t.callback),
	disableDevelopmentLogging = t.optional(t.boolean)
})

function class.new(data)
	local v5, v6 = strictInterface(data)

	if not v5 then
		if not isDevelopmentMode then
			return nil
		end

		error("invalid arguments for SentryReporter: " .. v6)
	end

	local v7 = {
		_isEnabled = true,
		_httpService = data.httpService,
		_debugLevelQueue = nil,
		_errorLevelQueue = nil,
		_processErrorReportMethod = data.processErrorReportMethod,
		_sharedAttributes = {},
		_sharedAnnotations = {},
		_generateLogMethod = data.generateLogMethod,
		_logIntervalInSeconds = data.logIntervalInSeconds or 5,
		_lastLogTime = 0,
		_dsn = data.dsn,
		_environment = data.environment,
		_release = data.release,
		_sentryClient = client:new(
			{ dsn = data.dsn, environment = data.environment, release = data.release },
			data.httpService
		),
		_errorQueuedCallback = data.errorQueuedCallback or nil,
		_errorFlushedCallback = data.errorFlushedCallback or nil,
		_sentryClientSuccessCallback = data.sentryClientSuccessCallback or nil,
		_sentryClientFailureCallback = data.sentryClientFailureCallback or nil,
		_logAttachmentSuccessCallback = data.logAttachmentSuccessCallback or nil,
		_logAttachmentFailureCallback = data.logAttachmentFailureCallback or nil,
		_shouldLogDevelopmentInfo = isDevelopmentMode and data.disableDevelopmentLogging ~= true
	}

	setmetatable(v7, class)

	local function reportQueuedError(p2, p3, p4)
		if v7:sendErrorReport(p3.errorReport, p3.log) and v7._errorFlushedCallback ~= nil then
			v7._errorFlushedCallback(p4)
		end
	end

	local v8 = data.debugQueueOptions

	if FFlagSentrySplitQueuesBySeverity then
		v8 = Cryo.Dictionary.join({ queueTimeLimit = FIntSentryDebugLevelQueueTimeLimitSeconds }, data.debugQueueOptions or {})
	end

	local v9 = ErrorQueue.new(reportQueuedError, v8)
	v7._debugLevelQueue = v9

	v9:startTimer()

	if FFlagSentrySplitQueuesBySeverity then
		local v10 = ErrorQueue.new(
			reportQueuedError,
			Cryo.Dictionary.join(
				{ queueTimeLimit = FIntSentryErrorLevelQueueTimeLimitSeconds, flushImmediately = true },
				data.errorQueueOptions or {}
			)
		)

		v7._errorLevelQueue = v10

		v10:startTimer()
	end

	return v7
end

function class:isTooOldToReportErrors(): boolean
	local robloxVersion = RunService:GetRobloxVersion()
	local v5 = tonumber(string.match(robloxVersion, ".(%d+)."))

	if v5 then
		return v5 < FIntOldestUAVersionToReportErrors
	end

	return false
end

function class:_sendLogAttachment(p2, value)
	local v5 = string.len(value)
	local v6 = string.len(value)
	local v7

	if v6 <= 20971520 then
		v7 = false
	else
		local v8 = string.format(
			"[LOG TRUNCATED - Original size: %.2f MB, kept latest %.2f MB]\n\n",
			v6 / 1048576,
			20
		)

		value = v8 .. string.sub(value, v6 - (20971520 - string.len(v8)) + 1)
		v7 = true
	end

	if v7 and self._shouldLogDevelopmentInfo then
		local v8 = string.format(
			"Log attachment truncated: original %.2f MB, sending latest %.2f MB",
			v5 / 1048576,
			20
		)

		print("[Sentry] " .. v8)
	end

	if self._shouldLogDevelopmentInfo and not v7 then
		local v9 = string.format("Sending log attachment for event: %s (%.2f KB)", p2, v5 / 1024)
		print("[Sentry] " .. v9)
	end

	self._sentryClient:send_event_with_attachments(p2, {
		{ filename = "app.log", data = value, content_type = "text/plain" }
	}, function(p3, p4, p5)
		if p3 then
			if self._shouldLogDevelopmentInfo then
				print("[Sentry] Successfully attached log to event:", p2)
			end

			if self._logAttachmentSuccessCallback ~= nil then
				self._logAttachmentSuccessCallback()
			end
		else
			if self._shouldLogDevelopmentInfo then
				local v9 = if type(p4) == "table" then p4.error or "unknown error" else tostring(p4)
				warn("[Sentry] Failed to attach log:", v9)
			end

			if self._logAttachmentFailureCallback ~= nil then
				self._logAttachmentFailureCallback(p4)
			end
		end
	end)
end

function class:_handleSentryExceptionCallback(p2, p3, p4, p5)
	if p2 then
		if self._shouldLogDevelopmentInfo then
			print("[Sentry] Successfully reported error to Sentry:", p4)
		end

		if self._sentryClientSuccessCallback ~= nil then
			self._sentryClientSuccessCallback()
		end

		if p5 and p4 then
			self:_sendLogAttachment(p4, p5)
		end
	else
		if self._shouldLogDevelopmentInfo then
			local v5 = if type(p3) == "table" then p3.error or "unknown error" else tostring(p3)
			warn("[Sentry] Failed to report error to Sentry:", v5)
		end

		if self._sentryClientFailureCallback ~= nil then
			self._sentryClientFailureCallback(p3)
		end
	end
end

function class:sendErrorReport(object2, p2): boolean
	if not self._isEnabled or self:isTooOldToReportErrors() then
		return false
	end

	if isDevelopmentMode then
		assert(object2:validate())
	end

	local message = object2.message or "Unknown error message"
	local level = object2.level or Constants.DEFAULT_ERROR_LEVEL

	local errorToContext = SentryReporterUtility.parseErrorToContext(object2)
	local threadsToSentry = SentryReporterUtility.parseThreadsToSentry(object2.threads)

	local stacktrace = nil

	if threadsToSentry and threadsToSentry.values then
		for i, value in ipairs(threadsToSentry.values) do
			if value.main == true or value.crashed == true then
				stacktrace = value.stacktrace
				break
			end
		end
	end

	local v5

	if defineFastFlag and object2.breadcrumbs and #object2.breadcrumbs > 0 then
		local breadcrumbs = object2.breadcrumbs
		local count = #breadcrumbs

		if count <= 100 then
			v5 = breadcrumbs
		else
			v5 = {}

			for i = count - 100 + 1, count do
				table.insert(v5, breadcrumbs[i])
			end
		end
	end

	if self._shouldLogDevelopmentInfo then
		print("[Sentry] Report Context:", errorToContext)
		print("[Sentry] Threads:", threadsToSentry)
		print("[Sentry] Main Stacktrace:", stacktrace)
		print("[Sentry] Level:", level)
		print("[Sentry] Breadcrumbs:", v5)
	end

	local sentryClient = self._sentryClient

	local function fn(p3, p4, p5)
		self:_handleSentryExceptionCallback(p3, p4, p5, p2)
	end

	local v7 = if FFlagLuaAppSentryStampOccurrenceTime then object2.timestamp else nil
	sentryClient:capture_exception(
		{ type = "LuaError", message = message, stacktrace = stacktrace },
		level,
		errorToContext,
		threadsToSentry,
		fn,
		v5,
		v7,
		object2.tags
	)

	return true
end

function class:_sendLogToReport(p3, value)
	if type(value) ~= "string" or #value == 0 then
		return
	end

	pcall(function() end)
end

function class:_generateLog()
	if self._generateLogMethod == nil or not (tick() - self._lastLogTime > self._logIntervalInSeconds) then
		return nil
	end

	self._lastLogTime = tick()

	local success, result = pcall(function()
		return self._generateLogMethod()
	end)

	if success and type(result) == "string" and #result > 0 then
		return result
	end

	return nil
end

function class:_generateErrorReport(p2, p3, value, p4, p5)
	local v5

	if type(value) == "table" then
		if p5 ~= nil then
			value = Cryo.Dictionary.join(value, { level = p5 })
		end

		v5 = ErrorReport.fromDetails(value)
	else
		v5 = ErrorReport.fromMessageAndStack(p2, p3, p5)

		if type(value) == "string" then
			v5:addAnnotations({ stackDetails = value })
		end
	end

	if FFlagLuaAppSentryStampOccurrenceTime then
		v5.timestamp = os.time()
	end

	if p4 ~= nil then
		v5:addCustomMetadata(p4)
	end

	v5:addAttributes(self._sharedAttributes)

	if self._sharedAnnotations and next(self._sharedAnnotations) ~= nil then
		v5:addAnnotations(self._sharedAnnotations)
	end

	if self._processErrorReportMethod ~= nil then
		v5 = self._processErrorReportMethod(v5)
	end

	return v5, (self:_generateLog())
end

function class:reportErrorImmediately(p2, p3, p4, p5, p6)
	if not self._isEnabled then
		return
	end

	local errorReport, v5 = self:_generateErrorReport(p2, p3, p4, p5, p6)

	self:sendErrorReport(errorReport, v5)
end

function class:_getQueueForLevel(p3)
	if self._errorLevelQueue == nil or (p3 or Constants.DEFAULT_ERROR_LEVEL) ~= "error" then
		return self._debugLevelQueue
	end

	return self._errorLevelQueue
end

function class:reportErrorDeferred(value, value2, p2, p3, p4)
	if not self._isEnabled then
		return
	end

	local v5 = string.format("%s | %s", value or "", value2 or "")

	local queueForLevel = self:_getQueueForLevel(p4)
	local v6

	if queueForLevel:hasError(v5) then
		v6 = { errorReport = nil, log = nil }
	else
		local errorReport, v7 = self:_generateErrorReport(value, value2, p2, p3, p4)

		v6 = { errorReport = errorReport, log = v7 }
	end

	if self._errorQueuedCallback ~= nil then
		self._errorQueuedCallback()
	end

	queueForLevel:addError(v5, v6)
end

function class:reportAllErrors()
	if self._debugLevelQueue ~= nil then
		self._debugLevelQueue:reportAllErrors()
	end

	if self._errorLevelQueue ~= nil then
		self._errorLevelQueue:reportAllErrors()
	end
end

function class:stop()
	self._isEnabled = false

	if self._debugLevelQueue ~= nil then
		self:reportAllErrors()
		self._debugLevelQueue:stopTimer()
	end

	if self._errorLevelQueue ~= nil then
		self._errorLevelQueue:stopTimer()
	end
end

function class:updateSharedAttributes(p3)
	local joined = Cryo.Dictionary.join(self._sharedAttributes, p3)

	local v5, v6 = iAttributes(joined)

	if not v5 then
		if not isDevelopmentMode then
			return
		end

		assert(v5, v6)
	end

	self._sharedAttributes = joined
end

function class:setTag(p3, p4)
	self._sentryClient:set_tag(p3, p4)
end

function class:setUser(p3)
	self._sentryClient:set_user(p3)
end

function class:updateSharedAnnotations(p3)
	local joined = Cryo.Dictionary.join(self._sharedAnnotations, p3)

	local v5, v6 = iAnnotations(joined)

	if not v5 then
		if not isDevelopmentMode then
			return
		end

		assert(v5, v6)
	end

	self._sharedAnnotations = joined
end

return class
