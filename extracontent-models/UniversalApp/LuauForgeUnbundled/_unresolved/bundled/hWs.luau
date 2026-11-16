local ContentProvider = game:GetService("ContentProvider")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local MemStorageService = game:GetService("MemStorageService")
local AppStorageService = game:GetService("AppStorageService")

local UniversalAppPolicy = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy")
local module2 = require("@luauforge/bundled/vM")
local defineFastFlag = game:DefineFastFlag("LuaAppErrorReportCountryCode", false)
local systemInfoProtocol = require("@luauforge/bundled/bXg").SystemInfoProtocol
local localStorageKey = require("@luauforge/bundled/dCq").Enums.LocalStorageKey

local module3 = require("@luauforge/bundled/hWt")

local getAppFeaturePolicies = UniversalAppPolicy.getAppFeaturePolicies

local defineFastFlag2 = game:DefineFastFlag("LuaAppSentryAddAppPolicyMetadata2", false)

local v5 = { "AccountType" }

local v6 = {}
v6.APP_POLICY_METADATA_KEYS = v5
local v7 = nil

function v6.getRolloutFlagAttributes()
	local rolloutFlagAttributes = {}

	local controlAndVariantRolloutFlags, v8 = RunService:GetControlAndVariantRolloutFlags()

	if controlAndVariantRolloutFlags ~= nil and controlAndVariantRolloutFlags ~= "" then
		rolloutFlagAttributes.RolloutFlagsInControl = controlAndVariantRolloutFlags
	end

	if v8 ~= nil and v8 ~= "" then
		rolloutFlagAttributes.RolloutFlagsInVariant = v8
	end

	return rolloutFlagAttributes
end

function v6.getAppStaticAttributes()
	return module2(function()
		local result = {
			AppVersion = RunService:GetRobloxVersion(),
			UserAgent = HttpService:GetUserAgent(),
			BaseUrl = ContentProvider.BaseUrl,
			WindowsLaunchType = MemStorageService:GetItem("Backtrace.WindowsLaunchType"),
			CoreScriptVersion = RunService:GetCoreScriptVersion(),
			AppInstallationId = AppStorageService:GetItem(localStorageKey.AppInstallationId),
			RobloxChannel = RunService:GetRobloxClientChannel()
		}

		for k, v8 in v6.getRolloutFlagAttributes() do
			result[k] = v8
		end

		local success, result2 = pcall(function()
			return systemInfoProtocol.default:getSystemInfo(systemInfoProtocol.ALL_INFO_NAMES)
		end)

		if success and typeof(result2) == "table" then
			for k, v8 in pairs(result2) do
				result[k] = v8
			end
		end

		return result
	end, {})
end

function v6.getAppPolicyAttributes(list)
	return module2(function()
		if list == nil or #list == 0 then
			return {}
		end

		local getRawPolicy = getAppFeaturePolicies().getRawPolicy

		if getRawPolicy == nil then
			return {}
		end

		local rawPolicy = getRawPolicy()

		if type(rawPolicy) ~= "table" then
			return {}
		end

		local result = {}

		for k, item in list do
			if not (item ~= nil and item ~= "") then
				continue
			end

			local v8 = rawPolicy[item]
			local typeName = typeof(v8)

			if typeName == "string" or typeName == "number" or typeName == "boolean" then
				result[item] = v8
			end
		end

		return result
	end, {})
end

function v6.getCountryCode()
	local item = AppStorageService:GetItem(localStorageKey.CountryCode)

	if item == nil or not (string.len(item) > 0) then
		return "Unknown"
	end

	return item
end

function v6.getSentryUserId()
	local item = AppStorageService:GetItem(localStorageKey.AppInstallationId)

	if item == nil or not (string.len(item) > 0) then
		return HttpService:GenerateGUID(false)
	end

	return item
end

function v6.getIxpEnrolledExperiments()
	return module2(function()
		local robloxClientIxpEnrolledExperiments = RunService:GetRobloxClientIxpEnrolledExperiments()

		if robloxClientIxpEnrolledExperiments == nil or robloxClientIxpEnrolledExperiments == "" then
			return nil
		end

		return robloxClientIxpEnrolledExperiments
	end, nil)
end

function v6.processReport(object)
	if not v7 then
		v7 = v6.getAppStaticAttributes()
	end

	local v8 = {
		AppRunningTime = string.format("%.02f", elapsedTime()),
		CountryCode = 0,
		IxpEnrolledExperiments = 0
	}
	local v9 = if defineFastFlag then v6.getCountryCode() else nil
	v8.CountryCode = v9

	local v10 = if module3 then v6.getIxpEnrolledExperiments() else nil
	v8.IxpEnrolledExperiments = v10
	object:addAttributes(v8)

	object:addAttributes(v7)

	if defineFastFlag2 and type(object.addCustomMetadata) == "function" then
		local appPolicyAttributes = v6.getAppPolicyAttributes(v5)

		if next(appPolicyAttributes) ~= nil and object.addCustomMetadata then
			object:addCustomMetadata({ ["App Policy"] = appPolicyAttributes })
		end
	end

	return object
end

return v6
