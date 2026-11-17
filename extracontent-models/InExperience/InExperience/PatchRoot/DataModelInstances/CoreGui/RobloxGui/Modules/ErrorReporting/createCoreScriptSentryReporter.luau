local AppStorageService = game:GetService("AppStorageService")
local CorePackages = game:GetService("CorePackages")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

local ErrorReporters = require(CorePackages.Workspace.Packages.ErrorReporters)
local SentryReporter = ErrorReporters.SentryReporter

local FFlagCoreScriptSentryReportDeviceContext = require(script.Parent.Parent.Flags.FFlagCoreScriptSentryReportDeviceContext)
local systemInfoProtocol

if FFlagCoreScriptSentryReportDeviceContext then
	local SystemInfoProtocol = require(CorePackages.Workspace.Packages.SystemInfoProtocol)
	systemInfoProtocol = SystemInfoProtocol.SystemInfoProtocol
else
	systemInfoProtocol = nil
end

local FFlagCoreScriptSentrySetUser = require(script.Parent.Parent.Flags.FFlagCoreScriptSentrySetUser)
local FFlagCoreScriptSentryReportTags = require(script.Parent.Parent.Flags.FFlagCoreScriptSentryReportTags)

local function getDeviceAttributes(runService)
	local deviceAttributes = {}

	local success, result = pcall(function()
		return systemInfoProtocol.default:getSystemInfo(systemInfoProtocol.ALL_INFO_NAMES)
	end)

	if success and typeof(result) == "table" then
		for k, v in result do
			deviceAttributes[k] = v
		end
	end

	local success2, result2, rolloutFlagsInVariant = pcall(function()
		return runService:GetControlAndVariantRolloutFlags()
	end)

	if not success2 then
		return deviceAttributes
	end

	if result2 ~= nil and result2 ~= "" then
		deviceAttributes.RolloutFlagsInControl = result2
	end

	if rolloutFlagsInVariant ~= nil and rolloutFlagsInVariant ~= "" then
		deviceAttributes.RolloutFlagsInVariant = rolloutFlagsInVariant
	end

	return deviceAttributes
end

local function getSentryUserId(appStorageService) -- 1 equivalent call inferred from this helper
	local success, result = pcall(function()
		return appStorageService:GetItem("AppInstallationId")
	end)

	if success and result ~= nil and result ~= "" then
		return result
	end

	return HttpService:GenerateGUID(false)
end

local v = {
	client_platform = "Platform",
	place_id = "PlaceId",
	app_version = "LocalVersion",
	roblox_channel = "RobloxChannel"
}

local function getTags(attributes)
	local tags = {}

	for k, v2 in v do
		local v3 = attributes[v2]

		if v3 ~= nil then
			tags[k] = tostring(v3)
		end
	end

	return tags
end

local function createCoreScriptSentryReporter(data)
	local runService = data.runService or RunService
	local appStorageService = data.appStorageService or AppStorageService
	local v2 = false

	local function processErrorReport(p)
		local v3 = data.processErrorReportMethod(p)
		v3:addCustomMetadata({ CoreScripts = v3.attributes })

		if FFlagCoreScriptSentryReportTags then
			v3.tags = getTags(v3.attributes)
		end

		if FFlagCoreScriptSentryReportDeviceContext then
			v3:addAttributes(getDeviceAttributes(runService))
		end

		return v3
	end

	local success, result = pcall(function()
		v2 = runService:IsStudio()

		local v3 = SentryReporter.new({
			httpService = HttpService,
			processErrorReportMethod = processErrorReport,
			dsn = data.dsn,
			environment = v2 and "development" or "production",
			release = runService:GetCoreScriptVersion() or "unknown",
			disableDevelopmentLogging = true
		})

		if FFlagCoreScriptSentrySetUser and v3 ~= nil then
			v3:setUser({
				id = getSentryUserId(appStorageService) -- inferred equivalent call
			})
		end

		return v3
	end)

	if success then
		return result
	end

	if v2 then
		warn(("[CoreScriptSentryReporter] Failed to initialize: %s"):format((tostring(result))))
	end

	return nil
end

return createCoreScriptSentryReporter
