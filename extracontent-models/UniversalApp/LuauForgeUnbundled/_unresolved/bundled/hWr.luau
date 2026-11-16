local RunService = game:GetService("RunService")

local HttpService = game:GetService("HttpService")

local sentryReporter = require("@luauforge/bundled/hVL").SentryReporter
local module = require("@luauforge/bundled/hWs")
local module2 = require("@luauforge/bundled/B")
local module3 = require("@luauforge/bundled/hWu")
local module4 = require("@luauforge/bundled/hWv")
local module5 = require("@luauforge/bundled/hWB")
local module6 = require("@luauforge/bundled/hWD")

local isStudio = RunService:IsStudio()
local defineFastString = game:DefineFastString("LuaAppSentryDsn", "")
local defineFastFlag = game:DefineFastFlag("LuaAppSentryReporterIncludeInTags", false)
local defineFastFlag2 = game:DefineFastFlag("LuaAppSentryQueueMetrics", false)
local defineFastFlag3 = game:DefineFastFlag("LuaAppRoRumSentryBreadcrumbs", false)
local defineFastFlag4 = game:DefineFastFlag("LuaAppSentryUserIdFromInstallationId", false)

local function attachRoRumBreadcrumbs(object)
	if not defineFastFlag3 or not module4 or type(object.addBreadcrumbs) ~= "function" then
		return
	end

	object:addBreadcrumbs(module5.fromSpans(module4:getLatestSpans()))
end

local v5 = nil

if defineFastString == "" then
	return v5
end

local coreScriptVersion = RunService:GetCoreScriptVersion()

if isStudio then
	print("[LuaAppSentryReporter] CoreScript Version:", coreScriptVersion)
end

local success, result = pcall(function()
	local new = sentryReporter.new
	local v6 = {
		httpService = HttpService,
		processErrorReportMethod = function(p2)
			local v7 = v5

			if module6 then
				local before_legacy_reporter_init = p2.attributes.before_legacy_reporter_init

				if before_legacy_reporter_init ~= nil then
					p2.tags = {
						reporter_init_phase = before_legacy_reporter_init and "early" or "legacy"
					}
				end
			end

			if defineFastFlag and v7 then
				v7:setTag("country_code", (tostring(module.getCountryCode())))

				local appPolicyAttributes = module.getAppPolicyAttributes(module.APP_POLICY_METADATA_KEYS)

				for k, appPolicyAttribute in appPolicyAttributes do
					v7:setTag(tostring(k), (tostring(appPolicyAttribute)))
				end

				for k, v8 in module.getRolloutFlagAttributes() do
					v7:setTag(tostring(k), (tostring(v8)))
				end
			end

			local v8 = module.processReport(p2)

			if not (defineFastFlag3 and module4 and type(v8.addBreadcrumbs) == "function") then
				return v8
			end

			v8:addBreadcrumbs(module5.fromSpans(module4:getLatestSpans()))

			return v8
		end,
		generateLogMethod = function()
			return module2:generateAppLog()
		end,
		dsn = defineFastString,
		environment = isStudio and "development" or "production",
		release = coreScriptVersion or "unknown",
		errorQueuedCallback = 0,
		errorFlushedCallback = 0,
		sentryClientSuccessCallback = 0,
		sentryClientFailureCallback = 0,
		logAttachmentSuccessCallback = 0,
		logAttachmentFailureCallback = 0
	}

	local v7 = if defineFastFlag2 then module3.logErrorQueued else nil
	v6.errorQueuedCallback = v7

	local v8 = if defineFastFlag2 then module3.logErrorFlushed else nil
	v6.errorFlushedCallback = v8

	function v6.sentryClientSuccessCallback()
		module3.logErrorSentSuccess()
	end
	function v6.sentryClientFailureCallback()
		module3.logErrorSentFailure()
	end
	function v6.logAttachmentSuccessCallback()
		module3.logLogAttachmentSuccess()
	end
	function v6.logAttachmentFailureCallback()
		module3.logLogAttachmentFailure()
	end

	return new(v6)
end)

if success then
	v5 = result
	module3.logInitSuccess()

	if v5 then
		local robloxVersion = RunService:GetRobloxVersion()
		local robloxClientChannel = RunService:GetRobloxClientChannel()

		if robloxVersion then
			v5:setTag("app_version", robloxVersion)
		end

		if robloxClientChannel then
			v5:setTag("roblox_channel", robloxClientChannel)
		end

		local v7 = if defineFastFlag4 then module.getSentryUserId() else HttpService:GenerateGUID(false)
		v5:setUser({ id = v7 })
	end

	if isStudio then
		print("[LuaAppSentryReporter] Initialized successfully")
	end
else
	module3.logInitFailure()

	if isStudio then
		warn("[LuaAppSentryReporter] Failed to initialize:", result)
	end
end

return v5
