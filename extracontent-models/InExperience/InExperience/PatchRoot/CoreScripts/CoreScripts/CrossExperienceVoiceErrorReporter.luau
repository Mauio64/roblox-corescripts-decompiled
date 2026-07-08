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
local BacktraceReporter = require(CorePackages.Workspace.Packages.ErrorReporters).BacktraceReporter

game:DefineFastFlag("DisableCEVBacktraceReporting", false)
game:DefineFastString("CoreScriptBacktraceErrorUploadToken", "")
game:DefineFastInt("CEVBacktracePIIFilterEraseTimeoutSeconds", 300)
game:DefineFastFlag("CEVBacktraceRepeatedErrorRateLimiting", true)
game:DefineFastInt("CEVBacktraceRepeatedErrorRateLimitCount", 5)
game:DefineFastInt("CEVBacktraceRepeatedErrorRateLimitPeriod", 60)
game:DefineFastInt("CEVBacktraceRepeatedErrorRateLimitProcessIntervalTenths", 10)
game:DefineFastInt("CEVBacktraceErrorReportPercentage", 100)

local function CanReportCEVBacktrace() -- line: 41
	return math.random(1, 100) <= math.clamp(game:GetFastInt("CEVBacktraceErrorReportPercentage"), 0, 100)
end

if not game:GetFastFlag("DisableCEVBacktraceReporting") and (game:GetFastString("CoreScriptBacktraceErrorUploadToken") ~= "" and math.random(1, 100) <= math.clamp(game:GetFastInt("CEVBacktraceErrorReportPercentage"), 0, 100)) then
	local t1 = {
		AppName = "CrossExperienceVoice",
		LocalVersion = RunService:GetRobloxVersion(),
		BaseUrl = ContentProvider.BaseUrl,
		PlaceId = game.PlaceId,
		Platform = UserInputService:GetPlatform().Name,
		UserAgent = HttpService:GetUserAgent(),
		CoreScriptVersion = RunService:GetCoreScriptVersion()
	}
	local v16 = PiiFilter.new({
		eraseTimeout = game:GetFastInt("CEVBacktracePIIFilterEraseTimeoutSeconds")
	})
	local FastFlag = game:GetFastFlag("CEVBacktraceRepeatedErrorRateLimiting")
	local u18 = nil

	if FastFlag then
		u18 = RateLimiter.new({
			period = game:GetFastInt("CEVBacktraceRepeatedErrorRateLimitPeriod"),
			threshold = game:GetFastInt("CEVBacktraceRepeatedErrorRateLimitCount"),
			processInterval = game:GetFastInt("CEVBacktraceRepeatedErrorRateLimitProcessIntervalTenths") / 10
		})
	end

	local function processReport(p1) -- line: 76
		-- upvalues: t1 (copy), Players (copy), RunService (copy)
		p1:addAttributes(t1)
		p1:addAttributes({
			PlayerCount = #Players:GetPlayers(),
			RobloxChannel = RunService:GetRobloxClientChannel()
		})

		return p1
	end

	local v20 = BacktraceReporter.new({
		httpService = HttpService,
		token = game:GetFastString("CoreScriptBacktraceErrorUploadToken"),
		processErrorReportMethod = processReport
	})

	local function handleErrorDetailed(p2, p3, p4, p5) -- line: 94
		-- upvalues: CoreGui (copy), CorePackages (copy), v16 (copy), FastFlag (copy), u18 (ref), v20 (copy)
		if p4 ~= nil and (p4:IsDescendantOf(CoreGui) or p4:IsDescendantOf(CorePackages)) then
			local v27 = v16:cleanPii(p2)
			local v28 = v16:cleanPii(p3)

			if p5 ~= nil then
				p5 = v16:cleanPii(p5)
			end

			if FastFlag then
				local v29 = v27 .. v28

				if u18:isRateLimited(v29) then
					return
				end

				u18:increment(v29)
			end

			v20:reportErrorDeferred(v27, v28, p5)
		end
	end

	ScriptContext.ErrorDetailed:Connect(function(...) -- line: 121
		-- upvalues: handleErrorDetailed (copy)
		local ok, result = pcall(handleErrorDetailed, ...)

		if not ok then
			warn(("CEV error reporter failed to handle an error:\n%s"):format(result))
		end
	end)
	t1.ServerVersion = RobloxReplicatedStorage:WaitForChild("GetServerVersion", 1e999):InvokeServer()
end
