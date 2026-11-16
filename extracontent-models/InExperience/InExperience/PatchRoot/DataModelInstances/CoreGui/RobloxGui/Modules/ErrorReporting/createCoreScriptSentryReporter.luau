local CorePackages = game:GetService("CorePackages")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

local ErrorReporters = require(CorePackages.Workspace.Packages.ErrorReporters)
local SentryReporter = ErrorReporters.SentryReporter

local function createCoreScriptSentryReporter(data)
	local runService = data.runService or RunService
	local v = false

	local function processErrorReport(p)
		local v2 = data.processErrorReportMethod(p)
		v2:addCustomMetadata({ CoreScripts = v2.attributes })

		return v2
	end

	local success, result = pcall(function()
		v = runService:IsStudio()

		return SentryReporter.new({
			httpService = HttpService,
			processErrorReportMethod = processErrorReport,
			dsn = data.dsn,
			environment = v and "development" or "production",
			release = runService:GetCoreScriptVersion() or "unknown",
			disableDevelopmentLogging = true
		})
	end)

	if success then
		return result
	end

	if v then
		warn(("[CoreScriptSentryReporter] Failed to initialize: %s"):format((tostring(result))))
	end

	return nil
end

return createCoreScriptSentryReporter
