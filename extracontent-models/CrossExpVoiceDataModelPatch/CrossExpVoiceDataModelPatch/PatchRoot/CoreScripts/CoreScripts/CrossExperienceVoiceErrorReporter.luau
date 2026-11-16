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

local ErrorReporters = require(CorePackages.Workspace.Packages.ErrorReporters)
local BacktraceReporter = ErrorReporters.BacktraceReporter

game:DefineFastFlag("DisableCEVBacktraceReporting", false)
game:DefineFastString("CoreScriptBacktraceErrorUploadToken", "")

game:DefineFastInt("CEVBacktracePIIFilterEraseTimeoutSeconds", 300)

game:DefineFastFlag("CEVBacktraceRepeatedErrorRateLimiting", true)
game:DefineFastInt("CEVBacktraceRepeatedErrorRateLimitCount", 5)
game:DefineFastInt("CEVBacktraceRepeatedErrorRateLimitPeriod", 60)

game:DefineFastInt("CEVBacktraceRepeatedErrorRateLimitProcessIntervalTenths", 10)

game:DefineFastInt("CEVBacktraceErrorReportPercentage", 100)

local function CanReportCEVBacktrace(): boolean -- 1 equivalent call inferred from this helper
	return math.random(1, 100) <= math.clamp(game:GetFastInt("CEVBacktraceErrorReportPercentage"), 0, 100)
end

if
	not game:GetFastFlag("DisableCEVBacktraceReporting")
	and game:GetFastString("CoreScriptBacktraceErrorUploadToken") ~= ""
	and CanReportCEVBacktrace() -- inferred equivalent call
then
	local v = {
		LocalVersion = RunService:GetRobloxVersion(),
		BaseUrl = ContentProvider.BaseUrl,
		PlaceId = game.PlaceId,
		Platform = UserInputService:GetPlatform().Name,
		UserAgent = HttpService:GetUserAgent(),
		CoreScriptVersion = RunService:GetCoreScriptVersion(),
		AppName = "CrossExperienceVoice"
	}

	local v2 = PiiFilter.new({
		eraseTimeout = game:GetFastInt("CEVBacktracePIIFilterEraseTimeoutSeconds")
	})

	local fastFlag = game:GetFastFlag("CEVBacktraceRepeatedErrorRateLimiting")
	local v3

	if fastFlag then
		v3 = RateLimiter.new({
			period = game:GetFastInt("CEVBacktraceRepeatedErrorRateLimitPeriod"),
			threshold = game:GetFastInt("CEVBacktraceRepeatedErrorRateLimitCount"),
			processInterval = game:GetFastInt("CEVBacktraceRepeatedErrorRateLimitProcessIntervalTenths") / 10
		})
	else
		v3 = nil
	end

	local function processReport(object)
		object:addAttributes(v)

		object:addAttributes({
			PlayerCount = #Players:GetPlayers(),
			RobloxChannel = RunService:GetRobloxClientChannel()
		})

		return object
	end

	local v4 = BacktraceReporter.new({
		httpService = HttpService,
		token = game:GetFastString("CoreScriptBacktraceErrorUploadToken"),
		processErrorReportMethod = processReport
	})

	local function handleErrorDetailed(p, p2, instance, p3)
		if instance ~= nil and (instance:IsDescendantOf(CoreGui) or instance:IsDescendantOf(CorePackages)) then
			local v5 = v2:cleanPii(p)
			local v6 = v2:cleanPii(p2)

			if p3 ~= nil then
				p3 = v2:cleanPii(p3)
			end

			if fastFlag then
				local v7 = v5 .. v6

				if v3:isRateLimited(v7) then
					return
				end

				v3:increment(v7)
			end

			v4:reportErrorDeferred(v5, v6, p3)
		end
	end

	ScriptContext.ErrorDetailed:Connect(function(...)
		local success, result = pcall(handleErrorDetailed, ...)

		if not success then
			warn(("CEV error reporter failed to handle an error:\n%s"):format(result))
		end
	end)

	v.ServerVersion = RobloxReplicatedStorage:WaitForChild("GetServerVersion", 1e999):InvokeServer()
end
