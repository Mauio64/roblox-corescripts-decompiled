local parent = script:FindFirstAncestor("ErrorReporters").Parent
local SentrySdk = require(parent.SentrySdk)
local Client = SentrySdk.Client
local RunService = game:GetService("RunService")

local Cryo = require(parent.Cryo)
local t = require(parent.t)

local ErrorQueue = require(script.Parent.Parent.ErrorQueue)
local FIntOldestUAVersionToReportErrors = require(script.Parent.Parent.FIntOldestUAVersionToReportErrors)

local FIntSentryErrorLevelQueueTimeLimitSeconds = require(script.Parent.Parent.FIntSentryErrorLevelQueueTimeLimitSeconds)

local FIntSentryDebugLevelQueueTimeLimitSeconds = require(script.Parent.Parent.FIntSentryDebugLevelQueueTimeLimitSeconds)
local FFlagSentrySplitQueuesBySeverity = require(script.Parent.Parent.FFlagSentrySplitQueuesBySeverity)
local ErrorReport = require(script.Parent.ErrorReport)
local SentryReporterUtility = require(script.Parent.SentryReporterUtility)
local Constants = require(script.Parent.Constants)
local FFlagLuaAppSentryStampOccurrenceTime = require(script.Parent.Flags.FFlagLuaAppSentryStampOccurrenceTime)

local IAttributes = ErrorReport.IAttributes
local IAnnotations = ErrorReport.IAnnotations

local isDevelopmentMode = require(script.Parent.isDevelopmentMode)

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

local function truncateLog(value: string)
	local v = string.len(value)

	if v <= 20971520 then
		return value, false
	end

	local v2 = string.format("[LOG TRUNCATED - Original size: %.2f MB, kept latest %.2f MB]\n\n", v / 1048576, 20)

	return v2 .. string.sub(value, v - (20971520 - string.len(v2)) + 1), true
end

local SentryReporter = {}
SentryReporter.__index = SentryReporter

local function createSentryClient(dsn: string, environment: string?, release: string?, p)
	return Client:new({ dsn = dsn, environment = environment, release = release }, p)
end

local function buildErrorKey(value: string, value2: string) -- 1 equivalent call inferred from this helper
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

function SentryReporter.new(data)
	local v, v2 = strictInterface(data)

	if not v then
		if not isDevelopmentMode then
			return nil
		end

		error("invalid arguments for SentryReporter: " .. v2)
	end

	local v3 = {
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
		_sentryClient = Client:new(
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

	setmetatable(v3, SentryReporter)

	local function reportQueuedError(_: string, p, p2: number)
		if v3:sendErrorReport(p.errorReport, p.log) and v3._errorFlushedCallback ~= nil then
			v3._errorFlushedCallback(p2)
		end
	end

	local v4 = data.debugQueueOptions

	if FFlagSentrySplitQueuesBySeverity then
		v4 = Cryo.Dictionary.join(
			{ queueTimeLimit = FIntSentryDebugLevelQueueTimeLimitSeconds },
			data.debugQueueOptions or {}
		)
	end

	local debugLevelQueue = ErrorQueue.new(reportQueuedError, v4)
	v3._debugLevelQueue = debugLevelQueue

	debugLevelQueue:startTimer()

	if FFlagSentrySplitQueuesBySeverity then
		local errorLevelQueue = ErrorQueue.new(
			reportQueuedError,
			Cryo.Dictionary.join(
				{
					queueTimeLimit = FIntSentryErrorLevelQueueTimeLimitSeconds,
					flushImmediately = true
				},
				data.errorQueueOptions or {}
			)
		)

		v3._errorLevelQueue = errorLevelQueue

		errorLevelQueue:startTimer()
	end

	return v3
end

function SentryReporter:isTooOldToReportErrors(): boolean
	local robloxVersion = RunService:GetRobloxVersion()
	local v = tonumber(string.match(robloxVersion, ".(%d+)."))

	if v then
		return v < FIntOldestUAVersionToReportErrors
	end

	return false
end

function SentryReporter:_sendLogAttachment(p: string, value: string)
	local v = string.len(value)
	local v2 = string.len(value)
	local v3

	if v2 <= 20971520 then
		v3 = false
	else
		local v4 = string.format("[LOG TRUNCATED - Original size: %.2f MB, kept latest %.2f MB]\n\n", v2 / 1048576, 20)

		value = v4 .. string.sub(value, v2 - (20971520 - string.len(v4)) + 1)
		v3 = true
	end

	if v3 and self._shouldLogDevelopmentInfo then
		local v4 = string.format("Log attachment truncated: original %.2f MB, sending latest %.2f MB", v / 1048576, 20)

		print("[Sentry] " .. v4)
	end

	if self._shouldLogDevelopmentInfo and not v3 then
		local v4 = string.format("Sending log attachment for event: %s (%.2f KB)", p, v / 1024)
		print("[Sentry] " .. v4)
	end

	self._sentryClient:send_event_with_attachments(p, {
		{ filename = "app.log", data = value, content_type = "text/plain" }
	}, function(p2, p3, _)
		if p2 then
			if self._shouldLogDevelopmentInfo then
				print("[Sentry] Successfully attached log to event:", p)
			end

			if self._logAttachmentSuccessCallback ~= nil then
				self._logAttachmentSuccessCallback()
			end
		else
			if self._shouldLogDevelopmentInfo then
				local v4

				if type(p3) == "table" then
					v4 = p3.error or "unknown error"
				else
					v4 = tostring(p3)
				end

				warn("[Sentry] Failed to attach log:", v4)
			end

			if self._logAttachmentFailureCallback ~= nil then
				self._logAttachmentFailureCallback(p3)
			end
		end
	end)
end

function SentryReporter:_handleSentryExceptionCallback(flag: boolean, p, p2: string?, p3: string?)
	if flag then
		if self._shouldLogDevelopmentInfo then
			print("[Sentry] Successfully reported error to Sentry:", p2)
		end

		if self._sentryClientSuccessCallback ~= nil then
			self._sentryClientSuccessCallback()
		end

		if p3 and p2 then
			self:_sendLogAttachment(p2, p3)
		end
	else
		if self._shouldLogDevelopmentInfo then
			local v

			if type(p) == "table" then
				v = p.error or "unknown error"
			else
				v = tostring(p)
			end

			warn("[Sentry] Failed to report error to Sentry:", v)
		end

		if self._sentryClientFailureCallback ~= nil then
			self._sentryClientFailureCallback(p)
		end
	end
end

function SentryReporter:sendErrorReport(object, p: string?): boolean
	if not self._isEnabled or self:isTooOldToReportErrors() then
		return false
	end

	if isDevelopmentMode then
		assert(object:validate())
	end

	local message = object.message or "Unknown error message"
	local level = object.level or Constants.DEFAULT_ERROR_LEVEL

	local errorToContext = SentryReporterUtility.parseErrorToContext(object)
	local threadsToSentry = SentryReporterUtility.parseThreadsToSentry(object.threads)

	local stacktrace = nil

	if threadsToSentry and threadsToSentry.values then
		for _, value in ipairs(threadsToSentry.values) do
			if value.main == true or value.crashed == true then
				stacktrace = value.stacktrace
				break
			end
		end
	end

	local v

	if defineFastFlag and object.breadcrumbs and #object.breadcrumbs > 0 then
		local breadcrumbs = object.breadcrumbs
		local count = #breadcrumbs

		if count <= 100 then
			v = breadcrumbs
		else
			v = {}

			for i = count - 100 + 1, count do
				table.insert(v, breadcrumbs[i])
			end
		end
	end

	if self._shouldLogDevelopmentInfo then
		print("[Sentry] Report Context:", errorToContext)
		print("[Sentry] Threads:", threadsToSentry)
		print("[Sentry] Main Stacktrace:", stacktrace)
		print("[Sentry] Level:", level)
		print("[Sentry] Breadcrumbs:", v)
	end

	local sentryClient = self._sentryClient

	local function fn(p2, p3, p4)
		self:_handleSentryExceptionCallback(p2, p3, p4, p)
	end

	local v2

	if FFlagLuaAppSentryStampOccurrenceTime then
		v2 = object.timestamp
	end

	sentryClient:capture_exception(
		{ type = "LuaError", message = message, stacktrace = stacktrace },
		level,
		errorToContext,
		threadsToSentry,
		fn,
		v,
		v2,
		object.tags
	)

	return true
end

function SentryReporter._sendLogToReport(_, _: string, value: string?)
	if type(value) ~= "string" or #value == 0 then
		return
	end

	pcall(function() end)
end

function SentryReporter:_generateLog()
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

function SentryReporter:_generateErrorReport(p: string, p2: string, stackDetails, p3, level)
	local v

	if type(stackDetails) == "table" then
		if level ~= nil then
			stackDetails = Cryo.Dictionary.join(stackDetails, { level = level })
		end

		v = ErrorReport.fromDetails(stackDetails)
	else
		v = ErrorReport.fromMessageAndStack(p, p2, level)

		if type(stackDetails) == "string" then
			v:addAnnotations({ stackDetails = stackDetails })
		end
	end

	if FFlagLuaAppSentryStampOccurrenceTime then
		v.timestamp = os.time()
	end

	if p3 ~= nil then
		v:addCustomMetadata(p3)
	end

	v:addAttributes(self._sharedAttributes)

	if self._sharedAnnotations and next(self._sharedAnnotations) ~= nil then
		v:addAnnotations(self._sharedAnnotations)
	end

	if self._processErrorReportMethod ~= nil then
		v = self._processErrorReportMethod(v)
	end

	return v, (self:_generateLog())
end

function SentryReporter:reportErrorImmediately(p: string, p2: string, p3, p4, p5)
	if not self._isEnabled then
		return
	end

	local errorReport, v = self:_generateErrorReport(p, p2, p3, p4, p5)

	self:sendErrorReport(errorReport, v)
end

function SentryReporter:_getQueueForLevel(p)
	if self._errorLevelQueue == nil or (p or Constants.DEFAULT_ERROR_LEVEL) ~= "error" then
		return self._debugLevelQueue
	end

	return self._errorLevelQueue
end

function SentryReporter:reportErrorDeferred(value: string, value2: string, p, p2, p3)
	if not self._isEnabled then
		return
	end

	local errorKey = buildErrorKey(value, value2) -- inferred equivalent call
	local queueForLevel = self:_getQueueForLevel(p3)
	local v

	if queueForLevel:hasError(errorKey) then
		v = { errorReport = nil, log = nil }
	else
		local errorReport, log = self:_generateErrorReport(value, value2, p, p2, p3)

		v = { errorReport = errorReport, log = log }
	end

	if self._errorQueuedCallback ~= nil then
		self._errorQueuedCallback()
	end

	queueForLevel:addError(errorKey, v)
end

function SentryReporter:reportAllErrors()
	if self._debugLevelQueue ~= nil then
		self._debugLevelQueue:reportAllErrors()
	end

	if self._errorLevelQueue ~= nil then
		self._errorLevelQueue:reportAllErrors()
	end
end

function SentryReporter:stop()
	self._isEnabled = false

	if self._debugLevelQueue ~= nil then
		self:reportAllErrors()
		self._debugLevelQueue:stopTimer()
	end

	if self._errorLevelQueue ~= nil then
		self._errorLevelQueue:stopTimer()
	end
end

function SentryReporter:updateSharedAttributes(p)
	local joined = Cryo.Dictionary.join(self._sharedAttributes, p)

	local v, v2 = IAttributes(joined)

	if not v then
		if not isDevelopmentMode then
			return
		end

		assert(v, v2)
	end

	self._sharedAttributes = joined
end

function SentryReporter:setTag(p: string, p2: string)
	self._sentryClient:set_tag(p, p2)
end

function SentryReporter:setUser(p)
	self._sentryClient:set_user(p)
end

function SentryReporter:updateSharedAnnotations(p)
	local joined = Cryo.Dictionary.join(self._sharedAnnotations, p)

	local v, v2 = IAnnotations(joined)

	if not v then
		if not isDevelopmentMode then
			return
		end

		assert(v, v2)
	end

	self._sharedAnnotations = joined
end

return SentryReporter
