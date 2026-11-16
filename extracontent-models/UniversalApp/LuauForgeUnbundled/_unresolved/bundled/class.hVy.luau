local ScriptContext = game:GetService("ScriptContext")
local RunService = game:GetService("RunService")
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local module = require("@luauforge/bundled/hVz")
local v5 = require("@luauforge/bundled/bXv").new()
local sessionInfo = require("@luauforge/bundled/hVA").SessionInfo
local sessionType = require("@luauforge/bundled/foF").SessionType

local default = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsErrorBoundary/LoggingProtocol").default

local module2 = require("@luauforge/bundled/hVH")
local module3 = require("@luauforge/bundled/hVI")

local module4 = require("@luauforge/bundled/hVJ")

local module5 = require("@luauforge/bundled/hVK")

local fFlagLuaAppEnableBacktraceSessionInfo = require("@luauforge/bundled/hVL").FFlagLuaAppEnableBacktraceSessionInfo

local module6 = require("@luauforge/bundled/hWl")
local tokenBucketRateLimiter = require("@luauforge/bundled/hVL").TokenBucketRateLimiter

local module7 = require("@luauforge/bundled/hWm")
local sessionWithErrorReporter = require("@luauforge/bundled/hWn").SessionWithErrorReporter

local module8 = require("@luauforge/bundled/hWq")

local fVariable = settings():GetFVariable("LuaAppsDiagErrorCounter")
local defineFastString = game:DefineFastString("LuaErrorByPlatformCounter", "LuaErrorPlatformOther")

local fFlagDisableGoogleAnalyticsErrorReporting = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagDisableGoogleAnalyticsErrorReporting
local errorQueue

if fFlagDisableGoogleAnalyticsErrorReporting then
	errorQueue = nil
else
	errorQueue = require("@luauforge/bundled/hVL").ErrorQueue
end

local v6 = not fFlagDisableGoogleAnalyticsErrorReporting or nil
local fVariable2 = tonumber(settings():GetFVariable("LuaAppErrorReporterRateLimitThreshold"))

local fVariable3 = tonumber(settings():GetFVariable("LuaAppErrorReporterRateLimitIntervalInSec"))

local fVariable4 = settings():GetFVariable("LuaAppsDiagRateLimitedErrorsCounter")
local v7 = fVariable2 * 2

local v8 = { [module8.DEBUG] = "debug", [module8.ERROR] = "error" }

local v9 = {
	maxTokens = 3,
	refillRate = 3,
	refillIntervalSeconds = 600,
	initialTokens = 3
}

local function createProductName(p2)
	local robloxVersion = RunService:GetRobloxVersion()
	return string.format("%s-%s", p2, robloxVersion)
end

local function convertNewlinesToPipes(value)
	local flag = true
	local v10 = ""

	for k in value:gmatch("[^\r\n]+") do
		if flag then
			v10 = k
			flag = false
		else
			v10 ..= " | " .. k
		end
	end

	return v10
end

local function removePlayerPersonalData(p2)
	return module(p2)
end

local function printError(list, list2, list3, instance)
	local v10 = {
		"---- Unhandled Error Handler -----",
		string.format("Current App<%s, %d> : \n%s\n", type(list), #list, list),
		string.format("Message<%s,%d> :\n%s\n", type(list2), #list2, list2),
		string.format("Stack<%s,%d> :\n%s", type(list3), #list3, list3),
		string.format("Script<%s> :\n%s", type(instance), instance:GetFullName()),
		"----------------------------------"
	}

	print(table.concat(v10, "\n"))
end

local fn = not fFlagDisableGoogleAnalyticsErrorReporting and function(p2, data, p3)
	v5.GoogleAnalytics:trackEvent(data.productName, data.errorMessage, data.errorStack, p3)
end or nil

local function reportErrorToDiag()
	v5.Diag:reportCounter(fVariable, 1)
end

local function reportErrorToDiagByPlatform()
	v5.Diag:reportCounter(defineFastString, 1)
end

local function reportErrorRateLimitingToDiag()
	v5.Diag:reportCounter(fVariable4, 1)
end

local class = {}
class.__index = class

function class:getSessionInformation()
	local sessionInformation = {}

	for i, v10 in ipairs({
		sessionType.StructuralIdentifier.Level0,
		sessionType.StructuralIdentifier.Level1,
		sessionType.StructuralIdentifier.Level2a,
		sessionType.StructuralIdentifier.Level2b
	}) do
		local sessionByLevel = sessionInfo.getSessionByLevel(v10)

		if not sessionByLevel then
			continue
		end

		sessionInformation[v10] = sessionByLevel.level
		sessionInformation[v10 .. "_sessionId"] = sessionByLevel.sessionId
		sessionInformation[v10 .. "_tagName"] = sessionByLevel.tagName
	end

	return sessionInformation
end

function class.new(p2, p3, backtraceReporter, severity, sentryReporter)
	local v10 = p2 or ScriptContext.Error
	local v11 = p3 or fVariable3
	local v12 = {
		_isInstance = true,
		_verbose = false,
		_signalConnectionToken = nil,
		_shouldReportDiag = true,
		_shouldReportGoogleAnalytics = if not fFlagDisableGoogleAnalyticsErrorReporting then v6 else nil,
		_shouldReportInflux = true,
		_currentApp = "Unknown",
		_reportQueueGA = nil,
		_backtraceReporter = backtraceReporter,
		_sentryReporter = sentryReporter,
		_rateLimitingThreshold = fVariable2,
		_rateLimitingIntervalSec = v11,
		_rateLimitCounts = {},
		_rateLimitNextTick = tick() + v11,
		_loggingProtocol = default,
		_severity = severity,
		_sessionWithErrorReporter = sessionWithErrorReporter.new(module7, 300, nil),
		_tokenBucketRateLimiter = 0
	}

	local v14 = if module6 then tokenBucketRateLimiter.new(v9) else nil
	v12._tokenBucketRateLimiter = v14

	setmetatable(v12, class)

	if not fFlagDisableGoogleAnalyticsErrorReporting then
		v12._reportQueueGA = errorQueue.new(fn, { queueKeyLimit = 10 })
	end

	v12._signalConnectionToken = v10:connect(function(p4, p5, p6, p7)
		local success, result = pcall(function()
			if module5 then
				module4.logObservedErrorSignal()
			end

			local unstable_parseReactError, v15 = React.unstable_parseReactError(p4)

			p4 = unstable_parseReactError.message

			p5 = unstable_parseReactError.stack or p5

			p7 = p7 or v15

			local severity2 = v12._severity

			v12:handleError(p4, p5, p6, p7, severity2)
		end)

		if not success then
			warn(string.format("An error occurred while reporting an error : %s", result))
		end
	end)

	if not (RunService:IsStudio() or _G.__TESTEZ_RUNNING_TEST__) then
		game:BindToClose(function()
			v12:delete()
		end)
	end

	v12._rateLimitHeartbeatConnectionToken = RunService.Heartbeat:connect(function()
		local now = tick()

		if v12._rateLimitNextTick < now then
			v12:_processRateLimitingTick()
			v12._rateLimitNextTick = now + v12._rateLimitingIntervalSec
		end
	end)

	return v12
end

function class:_processRateLimitingTick()
	local count = 0

	for k, rateLimitCount in pairs(self._rateLimitCounts) do
		if self._rateLimitingThreshold <= rateLimitCount then
			count += 1
		end

		local v10 = rateLimitCount - self._rateLimitingThreshold

		if v7 < v10 then
			self._rateLimitCounts[k] = v7
		elseif v10 <= 0 then
			self._rateLimitCounts[k] = nil
		else
			self._rateLimitCounts[k] = v10
		end
	end

	if count > 0 then
		v5.Diag:reportCounter(fVariable4, 1)
	end
end

function class:_processErrorForRateLimiting(p3, p4): boolean
	local v10 = p3 .. p4
	local v11 = self._rateLimitCounts[v10] or 0
	self._rateLimitCounts[v10] = v11 + 1

	return self._rateLimitingThreshold <= v11
end

function class:delete()
	if self._rateLimitHeartbeatConnectionToken ~= nil then
		self._rateLimitHeartbeatConnectionToken:disconnect()
	end

	self._signalConnectionToken:disconnect()

	if not fFlagDisableGoogleAnalyticsErrorReporting then
		self._reportQueueGA:reportAllErrors()
		self._reportQueueGA:stopTimer()
	end

	if self._backtraceReporter ~= nil then
		self._backtraceReporter:stop()
	end

	if self._sentryReporter ~= nil then
		self._sentryReporter:stop()
	end
end

function class:setCurrentApp(currentApp)
	if type(currentApp) ~= "string" then
		error("appName must be a string")
	end

	self._currentApp = currentApp
end

if not fFlagDisableGoogleAnalyticsErrorReporting then
	function class:startQueueTimers()
		self._reportQueueGA:startTimer()
	end
end

function class:stopQueueTimers()
	if not fFlagDisableGoogleAnalyticsErrorReporting then
		self._reportQueueGA:stopTimer()
	end
end

function class:reportRobloxTelemetryEvent(p3, p4, p5, instance)
	local v10 = { app = p3, err = p4, stack = p5, script = instance:GetFullName() }

	self._loggingProtocol:logRobloxTelemetryEvent(module2, nil, v10)
end

function class:reportRobloxTelemetryCounter(p3)
	if p3 == nil then
		self._loggingProtocol:logRobloxTelemetryCounter(module3, 1)
	else
		self._loggingProtocol:logRobloxTelemetryCounter(module3, 1, {
			tag_severity = p3
		})
	end
end

function class:reportSessionWithError(p3, p4, p5)
	self._sessionWithErrorReporter:reportEvent(p3, p4, p5)
end

function class:handleError(p2, p3, p4, p5, p6)
	local currentApp = self._currentApp
	local robloxVersion = RunService:GetRobloxVersion()
	local v10 = string.format("%s-%s", currentApp, robloxVersion)

	if self._verbose then
		printError(v10, p2, p3, p4)
	end

	local v11 = module(p2)
	local v12 = module(p3)
	local flag = true
	local v13 = ""

	for k in v12:gmatch("[^\r\n]+") do
		if flag then
			v13 = k
			flag = false
		else
			v13 ..= " | " .. k
		end
	end

	if p5 ~= nil then
		p5 = module(p5)
	end

	if module6 then
		if not self._tokenBucketRateLimiter:consume(1) then
			return
		end
	elseif self:_processErrorForRateLimiting(v11, v13) then
		return
	end

	local v14 = string.format("%s | %s", v11, v12)

	if not fFlagDisableGoogleAnalyticsErrorReporting and self._shouldReportGoogleAnalytics then
		self._reportQueueGA:addError(v14, {
			productName = v10,
			errorMessage = v11,
			errorStack = v13
		})
	end

	local v15 = if fFlagLuaAppEnableBacktraceSessionInfo then self:getSessionInformation() else nil

	if self._sentryReporter ~= nil then
		local v16 = v8[p6]
		self._sentryReporter:reportErrorDeferred(v11, v12, p5, nil, v16)
	end

	if self._backtraceReporter ~= nil then
		if fFlagLuaAppEnableBacktraceSessionInfo then
			self._backtraceReporter:reportErrorDeferred(v11, v12, p5, v15)
		else
			self._backtraceReporter:reportErrorDeferred(v11, v12, p5)
		end
	end

	if self._shouldReportInflux then
		self:reportRobloxTelemetryEvent(v10, v11, v13, p4)
	end

	if self._shouldReportDiag then
		self:reportRobloxTelemetryCounter(p6)

		self:reportSessionWithError(1, nil, p6)
		v5.Diag:reportCounter(fVariable, 1)

		v5.Diag:reportCounter(defineFastString, 1)
	end
end

return class
