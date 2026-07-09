local ScriptContext = game:GetService("ScriptContext")
local RunService = game:GetService("RunService")
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local removePII = require(script.Parent.removePII)
local v6 = require(script.Parent.Analytics).new()
local SessionInfo = require(CorePackages.Workspace.Packages.SessionizationUtil).SessionInfo
local SessionType = require(CorePackages.Workspace.Packages.RobloxAppSessionization).SessionType
local default = require(CorePackages.Workspace.Packages.LoggingProtocol).default
local LuaShellErrors = require(script.Parent.RobloxTelemetryConfigs.LuaShellErrors)
local LuaErrorV2CounterConfig = require(script.Parent.RobloxTelemetryConfigs.LuaErrorV2CounterConfig)
local FFlagLuaAppEnableBacktraceSessionInfo = require(CorePackages.Workspace.Packages.ErrorReporters).FFlagLuaAppEnableBacktraceSessionInfo
local FFlagLuaAppEnableTokenBucketLimiter = require(script.Parent.FFlagLuaAppEnableTokenBucketLimiter)
local TokenBucketRateLimiter = require(CorePackages.Workspace.Packages.ErrorReporters).TokenBucketRateLimiter
local FFlagEnableLuaAppSessionWithError = require(script.Parent.FFlagEnableLuaAppSessionWithError)
local LuaAppSessionWithErrorConfig = require(script.Parent.RobloxTelemetryConfigs.LuaAppSessionWithErrorConfig)
local SessionWithErrorReporter = require(CorePackages.Workspace.Packages.AppObservability).SessionWithErrorReporter
local LuaErrorSeverity = require(script.Parent.LuaErrorSeverity)
local FVariable = settings():GetFVariable("LuaAppsDiagErrorCounter")
local v20 = game:DefineFastString("LuaErrorByPlatformCounter", "LuaErrorPlatformOther")
local FFlagDisableGoogleAnalyticsErrorReporting = require(CorePackages.Workspace.Packages.SharedFlags).FFlagDisableGoogleAnalyticsErrorReporting
local v22 = if not FFlagDisableGoogleAnalyticsErrorReporting then require(CorePackages.Workspace.Packages.ErrorReporters).ErrorQueue else nil
local v23 = not FFlagDisableGoogleAnalyticsErrorReporting or nil
local num = tonumber(settings():GetFVariable("LuaAppErrorReporterRateLimitThreshold"))
local num2 = tonumber(settings():GetFVariable("LuaAppErrorReporterRateLimitIntervalInSec"))
local FVariable2 = settings():GetFVariable("LuaAppsDiagRateLimitedErrorsCounter")
local v27 = num * 2
local t1 = {
	[LuaErrorSeverity.DEBUG] = "debug",
	[LuaErrorSeverity.ERROR] = "error"
}
local t2 = {
	maxTokens = 3,
	refillRate = 3,
	refillIntervalSeconds = 600,
	initialTokens = 3
}

local function createProductName(p1) -- line: 84
	-- upvalues: RunService (copy)
	local RobloxVersion = RunService:GetRobloxVersion()

	return string.format("%s-%s", p1, RobloxVersion)
end
local function convertNewlinesToPipes(p2) -- line: 89
	local s1 = ""
	local v43 = true

	for match in p2:gmatch("[^\r\n]+") do
		if v43 then
			s1 = match
			v43 = false
		else
			s1 ..= " | " .. match
		end
	end

	return s1
end
local function removePlayerPersonalData(p3) -- line: 103
	-- upvalues: removePII (copy)
	return removePII(p3)
end
local function printError(p4, p5, p6, p7) -- line: 107
	local t3 = {
		"---- Unhandled Error Handler -----",
		string.format("Current App<%s, %d> : \n%s\n", type(p4), #p4, p4),
		string.format("Message<%s,%d> :\n%s\n", type(p5), #p5, p5),
		string.format("Stack<%s,%d> :\n%s", type(p6), #p6, p6),
		string.format("Script<%s> :\n%s", type(p7), p7:GetFullName()),
		"----------------------------------"
	}

	print(table.concat(t3, "\n"))
end

local v34 = not FFlagDisableGoogleAnalyticsErrorReporting and function(_, p9, p10) -- line: 123
	-- upvalues: v6 (copy)
	v6.GoogleAnalytics:trackEvent(p9.productName, p9.errorMessage, p9.errorStack, p10)
end or nil

local function reportErrorToDiag() -- line: 132
	-- upvalues: v6 (copy), FVariable (copy)
	v6.Diag:reportCounter(FVariable, 1)
end
local function reportErrorToDiagByPlatform() -- line: 137
	-- upvalues: v6 (copy), v20 (copy)
	v6.Diag:reportCounter(v20, 1)
end
local function reportErrorRateLimitingToDiag() -- line: 141
	-- upvalues: v6 (copy), FVariable2 (copy)
	v6.Diag:reportCounter(FVariable2, 1)
end

local t4 = {}

t4.__index = t4

function t4.getSessionInformation(_) -- line: 168
	-- upvalues: SessionType (copy), SessionInfo (copy)
	local t5 = {}

	for _, v in ipairs({
		SessionType.StructuralIdentifier.Level0,
		SessionType.StructuralIdentifier.Level1,
		SessionType.StructuralIdentifier.Level2a,
		SessionType.StructuralIdentifier.Level2b
	}) do
		local v58 = SessionInfo.getSessionByLevel(v)

		if v58 then
			t5[v] = v58.level
			t5[v .. "_sessionId"] = v58.sessionId
			t5[v .. "_tagName"] = v58.tagName
		end
	end

	return t5
end
function t4.new(p12, p13, p14, p15, p16) -- line: 196
	-- upvalues: ScriptContext (copy), num2 (copy), FFlagDisableGoogleAnalyticsErrorReporting (copy), v23 (copy), num (copy), default (copy), FFlagEnableLuaAppSessionWithError (copy), SessionWithErrorReporter (copy), LuaAppSessionWithErrorConfig (copy), FFlagLuaAppEnableTokenBucketLimiter (copy), TokenBucketRateLimiter (copy), t2 (copy), t4 (copy), v22 (copy), v34 (copy), React (copy), RunService (copy)
	if not p12 then
		p12 = ScriptContext.Error
	end

	local v64 = p13 or num2
	local t6 = {
		_isInstance = true,
		_verbose = false,
		_signalConnectionToken = nil,
		_shouldReportDiag = true,
		_shouldReportInflux = true,
		_currentApp = "Unknown",
		_reportQueueGA = nil,
		_shouldReportGoogleAnalytics = if not FFlagDisableGoogleAnalyticsErrorReporting then v23 else nil,
		_backtraceReporter = p14,
		_sentryReporter = p16,
		_rateLimitingThreshold = num,
		_rateLimitingIntervalSec = v64,
		_rateLimitCounts = {},
		_rateLimitNextTick = tick() + v64,
		_loggingProtocol = default,
		_severity = p15,
		_sessionWithErrorReporter = if not FFlagEnableLuaAppSessionWithError then nil else SessionWithErrorReporter.new(LuaAppSessionWithErrorConfig, 300, nil),
		_tokenBucketRateLimiter = if not FFlagLuaAppEnableTokenBucketLimiter then nil else TokenBucketRateLimiter.new(t2)
	}

	setmetatable(t6, t4)

	if not FFlagDisableGoogleAnalyticsErrorReporting then
		t6._reportQueueGA = v22.new(v34, {
			queueKeyLimit = 10
		})
	end

	t6._signalConnectionToken = p12:connect(function(p17, p18, p19, p20) -- line: 253
		-- upvalues: React (copy), t6 (copy)
		local ok, result = pcall(function() -- line: 255
			-- upvalues: React (copy), p17 (ref), p18 (ref), p20 (ref), t6 (copy), p19 (copy)
			local v121, v122 = React.unstable_parseReactError(p17)

			p17 = v121.message
			p18 = v121.stack or p18
			p20 = p20 or v122

			local _severity = t6._severity

			t6:handleError(p17, p18, p19, p20, _severity)
		end)

		if not ok then
			warn(string.format("An error occurred while reporting an error : %s", result))
		end
	end)

	if not RunService:IsStudio() and not _G.__TESTEZ_RUNNING_TEST__ then
		game:BindToClose(function() -- line: 284
			-- upvalues: t6 (copy)
			t6:delete()
		end)
	end

	t6._rateLimitHeartbeatConnectionToken = RunService.Heartbeat:connect(function() -- line: 290
		-- upvalues: t6 (copy)
		local timestamp = tick()

		if timestamp > t6._rateLimitNextTick then
			t6:_processRateLimitingTick()
			t6._rateLimitNextTick = timestamp + t6._rateLimitingIntervalSec
		end
	end)

	return t6
end
function t4._processRateLimitingTick(p21) -- line: 321
	-- upvalues: v27 (copy), v6 (copy), FVariable2 (copy)
	local n1 = 0

	for k, v in pairs(p21._rateLimitCounts) do
		if v >= p21._rateLimitingThreshold then
			n1 += 1
		end

		local v70 = v - p21._rateLimitingThreshold

		if v70 > v27 then
			p21._rateLimitCounts[k] = v27
		elseif v70 <= 0 then
			p21._rateLimitCounts[k] = nil
		else
			p21._rateLimitCounts[k] = v70
		end
	end

	if n1 > 0 then
		v6.Diag:reportCounter(FVariable2, 1)
	end
end
function t4._processErrorForRateLimiting(p22, p23, p24) -- line: 344
	local v74 = p23 .. p24
	local v75 = p22._rateLimitCounts[v74] or 0

	p22._rateLimitCounts[v74] = v75 + 1

	return v75 >= p22._rateLimitingThreshold
end
function t4.delete(p25) -- line: 352
	-- upvalues: FFlagDisableGoogleAnalyticsErrorReporting (copy)
	if p25._rateLimitHeartbeatConnectionToken ~= nil then
		p25._rateLimitHeartbeatConnectionToken:disconnect()
	end

	p25._signalConnectionToken:disconnect()

	if not FFlagDisableGoogleAnalyticsErrorReporting then
		p25._reportQueueGA:reportAllErrors()
		p25._reportQueueGA:stopTimer()
	end

	if p25._backtraceReporter ~= nil then
		p25._backtraceReporter:stop()
	end

	if p25._sentryReporter ~= nil then
		p25._sentryReporter:stop()
	end
end
function t4.setCurrentApp(p26, p27) -- line: 378
	if type(p27) ~= "string" then
		error("appName must be a string")
	end

	p26._currentApp = p27
end

if not FFlagDisableGoogleAnalyticsErrorReporting then
	function t4.startQueueTimers(p28) -- line: 387
		p28._reportQueueGA:startTimer()
	end
end

function t4.stopQueueTimers(p29) -- line: 392
	-- upvalues: FFlagDisableGoogleAnalyticsErrorReporting (copy)
	if not FFlagDisableGoogleAnalyticsErrorReporting then
		p29._reportQueueGA:stopTimer()
	end
end
function t4.reportRobloxTelemetryEvent(p30, p31, p32, p33, p34) -- line: 401
	-- upvalues: LuaShellErrors (copy)
	local t7 = {
		app = p31,
		err = p32,
		stack = p33,
		script = p34:GetFullName()
	}

	p30._loggingProtocol:logRobloxTelemetryEvent(LuaShellErrors, nil, t7)
end
function t4.reportRobloxTelemetryCounter(t8: {[any]: any}, s2: string?) -- line: 417
	-- upvalues: LuaErrorV2CounterConfig (copy)
	if s2 ~= nil then
		local t9 = {
			tag_severity = s2
		}

		t8._loggingProtocol:logRobloxTelemetryCounter(LuaErrorV2CounterConfig, 1, t9)

		return
	end

	t8._loggingProtocol:logRobloxTelemetryCounter(LuaErrorV2CounterConfig, 1)
end
function t4.reportSessionWithError(t10: {[any]: any}, n2: number, p35, s3: string?) -- line: 428
	t10._sessionWithErrorReporter:reportEvent(n2, p35, s3)
end
function t4.handleError(t11: {[any]: any}, p36, p37, p38, p39, s4: string?) -- line: 436
	-- upvalues: RunService (copy), printError (copy), removePII (copy), FFlagLuaAppEnableTokenBucketLimiter (copy), FFlagDisableGoogleAnalyticsErrorReporting (copy), FFlagLuaAppEnableBacktraceSessionInfo (copy), t1 (copy), FFlagEnableLuaAppSessionWithError (copy), v6 (copy), FVariable (copy), v20 (copy)
	local _currentApp = t11._currentApp
	local RobloxVersion = RunService:GetRobloxVersion()
	local v102 = string.format("%s-%s", _currentApp, RobloxVersion)

	if t11._verbose then
		printError(v102, p36, p37, p38)
	end

	local v103 = removePII(p36)
	local v104 = removePII(p37)
	local s5 = ""
	local v106 = true

	for match in v104:gmatch("[^\r\n]+") do
		if v106 then
			s5 = match
			v106 = false
		else
			s5 ..= " | " .. match
		end
	end

	if p39 ~= nil then
		p39 = removePII(p39)
	end

	if FFlagLuaAppEnableTokenBucketLimiter then
		if not t11._tokenBucketRateLimiter:consume(1) then
			return
		end
	elseif t11:_processErrorForRateLimiting(v103, s5) then
		return
	end

	local v108 = string.format("%s | %s", v103, v104)

	if not FFlagDisableGoogleAnalyticsErrorReporting and t11._shouldReportGoogleAnalytics then
		t11._reportQueueGA:addError(v108, {
			productName = v102,
			errorMessage = v103,
			errorStack = s5
		})
	end

	local v109 = nil

	if FFlagLuaAppEnableBacktraceSessionInfo then
		v109 = t11:getSessionInformation()
	end

	if t11._sentryReporter ~= nil then
		local v110 = t1[s4]

		t11._sentryReporter:reportErrorDeferred(v103, v104, p39, nil, v110)
	end

	if t11._backtraceReporter ~= nil then
		if FFlagLuaAppEnableBacktraceSessionInfo then
			t11._backtraceReporter:reportErrorDeferred(v103, v104, p39, v109)
		else
			t11._backtraceReporter:reportErrorDeferred(v103, v104, p39)
		end
	end

	if t11._shouldReportInflux then
		t11:reportRobloxTelemetryEvent(v102, v103, s5, p38)
	end

	if t11._shouldReportDiag then
		t11:reportRobloxTelemetryCounter(s4)

		if FFlagEnableLuaAppSessionWithError then
			t11:reportSessionWithError(1, nil, s4)
		end

		v6.Diag:reportCounter(FVariable, 1)
		v6.Diag:reportCounter(v20, 1)
	end
end

return t4
