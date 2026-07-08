local ContentProvider = game:GetService("ContentProvider")
local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local RobloxReplicatedStorage = game:GetService("RobloxReplicatedStorage")
local RunService = game:GetService("RunService")
local ScriptContext = game:GetService("ScriptContext")
local UserInputService = game:GetService("UserInputService")
local RobloxGui = CoreGui.RobloxGui
local RateLimiter = require(RobloxGui.Modules.ErrorReporting.RateLimiter)
local PiiFilter = require(RobloxGui.Modules.ErrorReporting.PiiFilter)
local LuaCoreScriptsErrorV2CounterConfig = require(RobloxGui.Modules.ErrorReporting.LuaCoreScriptsErrorV2CounterConfig)
local BacktraceReporter = require(CorePackages.Workspace.Packages.ErrorReporters).BacktraceReporter
local default = require(CorePackages.Workspace.Packages.LoggingProtocol).default
local React = require(CorePackages.Packages.React)
local v17 = game:DefineFastFlag("EnableCoreScriptsSessionWithError", false)
local SessionWithErrorReporter = require(CorePackages.Workspace.Packages.AppObservability).SessionWithErrorReporter
local v19 = if not v17 then nil else require(RobloxGui.Modules.ErrorReporting.LuaCoreScriptsSessionWithErrorConfig)

game:DefineFastFlag("DisableCorescriptBacktraceReporting", false)
game:DefineFastString("CoreScriptBacktraceErrorUploadToken", "")
game:DefineFastInt("CoreScriptBacktracePIIFilterEraseTimeoutSeconds", 300)
game:DefineFastFlag("CoreScriptBacktraceRepeatedErrorRateLimiting", true)
game:DefineFastInt("CoreScriptBacktraceRepeatedErrorRateLimitCount", 5)
game:DefineFastInt("CoreScriptBacktraceRepeatedErrorRateLimitPeriod", 60)
game:DefineFastInt("CoreScriptBacktraceRepeatedErrorRateLimitProcessIntervalTenths", 10)
game:DefineFastInt("CoreScriptBacktraceErrorReportPercentage", 100)

local v20 = game:DefineFastFlag("EnableCoreScriptsSessionWithError", false)

local function CanReportCoreScriptBacktrace() -- line: 52
	return math.random(1, 100) <= math.clamp(game:GetFastInt("CoreScriptBacktraceErrorReportPercentage"), 0, 100)
end

if not game:GetFastFlag("DisableCorescriptBacktraceReporting") and (game:GetFastString("CoreScriptBacktraceErrorUploadToken") ~= "" and math.random(1, 100) <= math.clamp(game:GetFastInt("CoreScriptBacktraceErrorReportPercentage"), 0, 100)) then
	local t1 = {
		LocalVersion = RunService:GetRobloxVersion(),
		BaseUrl = ContentProvider.BaseUrl,
		PlaceId = game.PlaceId,
		Platform = UserInputService:GetPlatform().Name,
		UserAgent = HttpService:GetUserAgent(),
		CoreScriptVersion = RunService:GetCoreScriptVersion()
	}
	local v23 = PiiFilter.new({
		eraseTimeout = game:GetFastInt("CoreScriptBacktracePIIFilterEraseTimeoutSeconds")
	})
	local FastFlag = game:GetFastFlag("CoreScriptBacktraceRepeatedErrorRateLimiting")
	local u25 = nil

	if FastFlag then
		u25 = RateLimiter.new({
			period = game:GetFastInt("CoreScriptBacktraceRepeatedErrorRateLimitPeriod"),
			threshold = game:GetFastInt("CoreScriptBacktraceRepeatedErrorRateLimitCount"),
			processInterval = game:GetFastInt("CoreScriptBacktraceRepeatedErrorRateLimitProcessIntervalTenths") / 10
		})
	end

	local v26 = if not v20 then nil else SessionWithErrorReporter.new(v19, 300, nil)

	local function processReport(p1) -- line: 90
		-- upvalues: t1 (copy), Players (copy), RunService (copy)
		p1:addAttributes(t1)
		p1:addAttributes({
			PlayerCount = #Players:GetPlayers()
		})
		p1:addAttributes({
			RobloxChannel = RunService:GetRobloxClientChannel()
		})

		return p1
	end

	local v28 = BacktraceReporter.new({
		httpService = HttpService,
		token = game:GetFastString("CoreScriptBacktraceErrorUploadToken"),
		processErrorReportMethod = processReport
	})

	local function handleErrorDetailed(p2, p3, p4, p5) -- line: 111
		-- upvalues: CoreGui (copy), CorePackages (copy), React (copy), v23 (copy), FastFlag (copy), u25 (ref), v28 (copy), default (copy), LuaCoreScriptsErrorV2CounterConfig (copy), v20 (copy), v26 (copy)
		if p4 ~= nil and (p4:IsDescendantOf(CoreGui) or p4:IsDescendantOf(CorePackages)) then
			local v35, v36 = React.unstable_parseReactError(p2)
			local message = v35.message
			local v38 = v35.stack or p3
			local v39 = p5 or v36
			local v40 = v23:cleanPii(message)
			local v41 = v23:cleanPii(v38)

			if v39 ~= nil then
				v39 = v23:cleanPii(v39)
			end

			if FastFlag then
				local v42 = v40 .. v41

				if u25:isRateLimited(v42) then
					return
				end

				u25:increment(v42)
			end

			v28:reportErrorDeferred(v40, v41, v39)
			default:logRobloxTelemetryCounter(LuaCoreScriptsErrorV2CounterConfig, 1)

			if v20 then
				v26:reportEvent(1, nil, "ERROR")
			end
		end
	end

	ScriptContext.ErrorDetailed:Connect(function(...) -- line: 154
		-- upvalues: handleErrorDetailed (copy)
		local ok, result = pcall(handleErrorDetailed, ...)

		if not ok then
			warn(("CoreScript error reporter failed to handle an error:\n%s"):format(result))
		end
	end)
	t1.ServerVersion = RobloxReplicatedStorage:WaitForChild("GetServerVersion", 1e999):InvokeServer()
end
