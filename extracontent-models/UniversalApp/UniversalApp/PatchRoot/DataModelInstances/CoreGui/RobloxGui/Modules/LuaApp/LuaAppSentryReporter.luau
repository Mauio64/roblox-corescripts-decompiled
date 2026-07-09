local RunService = game:GetService("RunService")
local CorePackages = game:GetService("CorePackages")
local HttpService = game:GetService("HttpService")
local SentryReporter = require(CorePackages.Workspace.Packages.ErrorReporters).SentryReporter
local LuaAppErrorReporterUtil = require(script.Parent.LuaAppErrorReporterUtil)
local LuaAppBacktraceLogger = require(script.Parent.LuaAppBacktraceLogger)
local LuaAppSentryReporterMetrics = require(script.Parent.Sentry.LuaAppSentryReporterMetrics)
local v8 = RunService:IsStudio()
local v9 = game:DefineFastString("LuaAppSentryDsn", "")
local v10 = game:DefineFastFlag("LuaAppSentryAddVersionChannelTags", false)
local v11 = game:DefineFastFlag("LuaAppSentryAddUserContext", false)
local v12 = nil

if v9 ~= "" then
	local CoreScriptVersion = RunService:GetCoreScriptVersion()

	if v8 then
		print("[LuaAppSentryReporter] CoreScript Version:", CoreScriptVersion)
	end

	local ok, result = pcall(function() -- line: 105
		-- upvalues: SentryReporter (copy), HttpService (copy), LuaAppErrorReporterUtil (copy), LuaAppBacktraceLogger (copy), v9 (copy), v8 (copy), CoreScriptVersion (copy), LuaAppSentryReporterMetrics (copy)
		return SentryReporter.new({
			httpService = HttpService,
			processErrorReportMethod = LuaAppErrorReporterUtil.processReport,
			generateLogMethod = function() -- line: 114
				-- upvalues: LuaAppBacktraceLogger (copy)
				return LuaAppBacktraceLogger:generateAppLog()
			end,
			dsn = v9,
			environment = not v8 and "production" or "development",
			release = CoreScriptVersion or "unknown",
			sentryClientSuccessCallback = function() -- line: 123
				-- upvalues: LuaAppSentryReporterMetrics (copy)
				LuaAppSentryReporterMetrics.logErrorSentSuccess()
			end,
			sentryClientFailureCallback = function() -- line: 126
				-- upvalues: LuaAppSentryReporterMetrics (copy)
				LuaAppSentryReporterMetrics.logErrorSentFailure()
			end,
			logAttachmentSuccessCallback = function() -- line: 129
				-- upvalues: LuaAppSentryReporterMetrics (copy)
				LuaAppSentryReporterMetrics.logLogAttachmentSuccess()
			end,
			logAttachmentFailureCallback = function() -- line: 132
				-- upvalues: LuaAppSentryReporterMetrics (copy)
				LuaAppSentryReporterMetrics.logLogAttachmentFailure()
			end
		})
	end)

	if ok then
		v12 = result
		LuaAppSentryReporterMetrics.logInitSuccess()

		if v10 then
			local RobloxVersion = RunService:GetRobloxVersion()
			local RobloxClientChannel = RunService:GetRobloxClientChannel()

			if v12 then
				if RobloxVersion then
					v12:setTag("app_version", RobloxVersion)
				end

				if RobloxClientChannel then
					v12:setTag("roblox_channel", RobloxClientChannel)
				end
			end
		end

		if v11 and v12 then
			v12:setUser({
				id = HttpService:GenerateGUID(false)
			})
		end

		if v8 then
			print("[LuaAppSentryReporter] Initialized successfully")

			return v12
		end
	else
		LuaAppSentryReporterMetrics.logInitFailure()

		if v8 then
			warn("[LuaAppSentryReporter] Failed to initialize:", result)
		end
	end
end

return v12
