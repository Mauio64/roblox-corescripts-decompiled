local ContentProvider = game:GetService("ContentProvider")
local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local RobloxReplicatedStorage = game:GetService("RobloxReplicatedStorage")
local RunService = game:GetService("RunService")
local ScriptContext = game:GetService("ScriptContext")
local UserInputService = game:GetService("UserInputService")

local defineFastFlag = game:DefineFastFlag("CoreScriptErrorReporterUseErrorHandler", false)

local defineFastFlag2 = game:DefineFastFlag("CoreScriptErrorCounterIgnoreReporterSampling", false)

local RobloxGui = CoreGui.RobloxGui
local RateLimiter = require(RobloxGui.Modules.ErrorReporting.RateLimiter)
local PiiFilter = require(RobloxGui.Modules.ErrorReporting.PiiFilter)
local LuaCoreScriptsErrorV2CounterConfig = require(RobloxGui.Modules.ErrorReporting.LuaCoreScriptsErrorV2CounterConfig)
local createCoreScriptErrorHandler = require(RobloxGui.Modules.ErrorReporting.createCoreScriptErrorHandler)
local createCoreScriptReportProcessor = require(RobloxGui.Modules.ErrorReporting.createCoreScriptReportProcessor)
local createCoreScriptSentryReporter

if defineFastFlag then
	createCoreScriptSentryReporter = require(RobloxGui.Modules.ErrorReporting.createCoreScriptSentryReporter)
end

local FFlagCoreScriptErrorReporterIncludeScriptContext = require(RobloxGui.Modules.Flags.FFlagCoreScriptErrorReporterIncludeScriptContext)

local ErrorReporters = require(CorePackages.Workspace.Packages.ErrorReporters)
local BacktraceReporter = ErrorReporters.BacktraceReporter
local LoggingProtocol = require(CorePackages.Workspace.Packages.LoggingProtocol)
local default = LoggingProtocol.default
local React = require(CorePackages.Packages.React)

local AppObservability = require(CorePackages.Workspace.Packages.AppObservability)
local SessionWithErrorReporter = AppObservability.SessionWithErrorReporter

local LuaCoreScriptsSessionWithErrorConfig = require(RobloxGui.Modules.ErrorReporting.LuaCoreScriptsSessionWithErrorConfig)

game:DefineFastFlag("DisableCorescriptBacktraceReporting", false)
game:DefineFastString("CoreScriptBacktraceErrorUploadToken", "")

game:DefineFastInt("CoreScriptBacktracePIIFilterEraseTimeoutSeconds", 300)

game:DefineFastFlag("CoreScriptBacktraceRepeatedErrorRateLimiting", true)
game:DefineFastInt("CoreScriptBacktraceRepeatedErrorRateLimitCount", 5)
game:DefineFastInt("CoreScriptBacktraceRepeatedErrorRateLimitPeriod", 60)

game:DefineFastInt("CoreScriptBacktraceRepeatedErrorRateLimitProcessIntervalTenths", 10)

game:DefineFastInt("CoreScriptBacktraceErrorReportPercentage", 100)

local defineFastString = game:DefineFastString("CoreScriptSentryDsn", "")
local defineFastInt = game:DefineFastInt("CoreScriptSentryRolloutPercentage", 0)

local function CanReportCoreScriptBacktrace(): boolean -- 1 equivalent call inferred from this helper
	return math.random(1, 100) <= math.clamp(game:GetFastInt("CoreScriptBacktraceErrorReportPercentage"), 0, 100)
end

local function CanReportCoreScriptSentry(): boolean -- 1 equivalent call inferred from this helper
	return math.random(1, 100) <= math.clamp(defineFastInt, 0, 100)
end

local v = not game:GetFastFlag("DisableCorescriptBacktraceReporting")

if v then
	if game:GetFastString("CoreScriptBacktraceErrorUploadToken") == "" then
		v = false
	else
		v = CanReportCoreScriptBacktrace() -- inferred equivalent call
	end
end

local v2

if defineFastFlag then
	if defineFastString == "" then
		v2 = false
	else
		v2 = CanReportCoreScriptSentry() -- inferred equivalent call
	end
else
	v2 = defineFastFlag
end

if defineFastFlag and (v or v2 or defineFastFlag2) then
	local coreScriptReportProcessor, v3 = createCoreScriptReportProcessor()

	local piiFilter = PiiFilter.new({
		eraseTimeout = game:GetFastInt("CoreScriptBacktracePIIFilterEraseTimeoutSeconds")
	})
	local rateLimiter

	if game:GetFastFlag("CoreScriptBacktraceRepeatedErrorRateLimiting") then
		rateLimiter = RateLimiter.new({
			period = game:GetFastInt("CoreScriptBacktraceRepeatedErrorRateLimitPeriod"),
			threshold = game:GetFastInt("CoreScriptBacktraceRepeatedErrorRateLimitCount"),
			processInterval = game:GetFastInt("CoreScriptBacktraceRepeatedErrorRateLimitProcessIntervalTenths") / 10
		})
	end

	local v4 = SessionWithErrorReporter.new(LuaCoreScriptsSessionWithErrorConfig, 300, nil)

	local reporters = {}

	if v then
		table.insert(
			reporters,
			BacktraceReporter.new({
				httpService = HttpService,
				token = game:GetFastString("CoreScriptBacktraceErrorUploadToken"),
				processErrorReportMethod = coreScriptReportProcessor
			})
		)
	end

	if v2 then
		local coreScriptSentryReporter = createCoreScriptSentryReporter({
			dsn = defineFastString,
			processErrorReportMethod = coreScriptReportProcessor
		})

		if coreScriptSentryReporter ~= nil then
			table.insert(reporters, coreScriptSentryReporter)
		end
	end

	local coreScriptErrorHandler = createCoreScriptErrorHandler({
		piiFilter = piiFilter,
		rateLimiter = rateLimiter,
		reporters = reporters,
		onErrorReported = function()
			default:logRobloxTelemetryCounter(LuaCoreScriptsErrorV2CounterConfig, 1)

			if #reporters > 0 then
				v4:reportEvent(1, nil, "ERROR")
			end
		end
	})

	if #reporters > 0 or defineFastFlag2 then
		ScriptContext.ErrorDetailed:Connect(function(...)
			local success, result = pcall(coreScriptErrorHandler, ...)

			if not success then
				warn(("CoreScript error reporter failed to handle an error:\n%s"):format(result))
			end
		end)
	end

	if v or v2 then
		v3.ServerVersion = RobloxReplicatedStorage:WaitForChild("GetServerVersion", 1e999):InvokeServer()
	end
end

if v and not defineFastFlag then
	local v3 = {
		LocalVersion = RunService:GetRobloxVersion(),
		BaseUrl = ContentProvider.BaseUrl,
		PlaceId = game.PlaceId,
		Platform = UserInputService:GetPlatform().Name,
		UserAgent = HttpService:GetUserAgent(),
		CoreScriptVersion = RunService:GetCoreScriptVersion()
	}

	local v4 = PiiFilter.new({
		eraseTimeout = game:GetFastInt("CoreScriptBacktracePIIFilterEraseTimeoutSeconds")
	})

	local fastFlag = game:GetFastFlag("CoreScriptBacktraceRepeatedErrorRateLimiting")
	local v5

	if fastFlag then
		v5 = RateLimiter.new({
			period = game:GetFastInt("CoreScriptBacktraceRepeatedErrorRateLimitPeriod"),
			threshold = game:GetFastInt("CoreScriptBacktraceRepeatedErrorRateLimitCount"),
			processInterval = game:GetFastInt("CoreScriptBacktraceRepeatedErrorRateLimitProcessIntervalTenths") / 10
		})
	else
		v5 = nil
	end

	local v6 = SessionWithErrorReporter.new(LuaCoreScriptsSessionWithErrorConfig, 300, nil)

	local function processReport(object)
		object:addAttributes(v3)

		object:addAttributes({
			PlayerCount = #Players:GetPlayers()
		})

		object:addAttributes({
			RobloxChannel = RunService:GetRobloxClientChannel()
		})

		return object
	end

	local v7 = BacktraceReporter.new({
		httpService = HttpService,
		token = game:GetFastString("CoreScriptBacktraceErrorUploadToken"),
		processErrorReportMethod = processReport
	})

	local function handleErrorDetailed(p, p2, coreScript, p3)
		if
			coreScript ~= nil
			and (coreScript:IsDescendantOf(CoreGui) or coreScript:IsDescendantOf(CorePackages) or FFlagCoreScriptErrorReporterIncludeScriptContext and coreScript:IsA("CoreScript") and coreScript:IsDescendantOf(ScriptContext))
		then
			local unstable_parseReactError, v8 = React.unstable_parseReactError(p)

			local message = unstable_parseReactError.message

			local stack = unstable_parseReactError.stack or p2

			p3 = p3 or v8

			local v9 = v4:cleanPii(message)
			local v10 = v4:cleanPii(stack)

			if p3 ~= nil then
				p3 = v4:cleanPii(p3)
			end

			if fastFlag then
				local v11 = v9 .. v10

				if v5:isRateLimited(v11) then
					return
				end

				v5:increment(v11)
			end

			v7:reportErrorDeferred(v9, v10, p3)
			default:logRobloxTelemetryCounter(LuaCoreScriptsErrorV2CounterConfig, 1)

			v6:reportEvent(1, nil, "ERROR")
		end
	end

	ScriptContext.ErrorDetailed:Connect(function(...)
		local success, result = pcall(handleErrorDetailed, ...)

		if not success then
			warn(("CoreScript error reporter failed to handle an error:\n%s"):format(result))
		end
	end)

	v3.ServerVersion = RobloxReplicatedStorage:WaitForChild("GetServerVersion", 1e999):InvokeServer()
end
