local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local default = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthAnalytics/LoggingProtocol").default
local TelemetryConfigs = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthAnalytics/AuthAnalytics/RobloxTelemetry/TelemetryConfigs")
local getFFlagEnableIosAuthServiceLuaIXP = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthAnalytics/SharedFlags").GetFFlagEnableIosAuthServiceLuaIXP

local function isIos(): boolean
	return UserInputService:GetPlatform() == Enum.Platform.IOS
end

local function majorMinor(value)
	if value == nil or value == "" then
		return nil
	end

	local v5 = string.split(value, ".")

	if #v5 == 0 then
		return nil
	end

	if #v5 == 1 then
		return v5[1]
	end

	return v5[1] .. "." .. v5[2]
end

local function buildCustomFields(p2, credentialType, errorCode, p3)
	local customFields = {
		source = "lua",
		surface = p2,
		iosAuthServiceEnabled = p3 and "true" or "false"
	}

	if credentialType ~= nil and credentialType ~= "" then
		customFields.credentialType = credentialType
	end

	if errorCode ~= nil and errorCode ~= "" then
		customFields.errorCode = errorCode
	end

	local robloxVersion = RunService:GetRobloxVersion()
	local v5

	if not (robloxVersion == nil or robloxVersion == "") then
		local v6 = string.split(robloxVersion, ".")

		if #v6 ~= 0 then
			v5 = if #v6 == 1 then v6[1] else v6[1] .. "." .. v6[2]
		end
	end

	if v5 ~= nil and v5 ~= "" then
		customFields.robloxVersion = v5
	end

	return customFields
end

local function logCounter(p2, p3, p4, p5, p6)
	if not (getFFlagEnableIosAuthServiceLuaIXP() and UserInputService:GetPlatform() == Enum.Platform.IOS) then
		return
	end

	default:logRobloxTelemetryCounter(p2, 1, buildCustomFields(p3, p4, p5, p6))
end

return {
	reportLoginSuccess = function(p2)
		local iosAuthServiceLoginSuccessConfig = TelemetryConfigs.IosAuthServiceLoginSuccessConfig

		local credentialType = p2.credentialType

		local iosAuthServiceEnabled = p2.iosAuthServiceEnabled

		if not (getFFlagEnableIosAuthServiceLuaIXP() and UserInputService:GetPlatform() == Enum.Platform.IOS) then
			return
		end

		default:logRobloxTelemetryCounter(
			iosAuthServiceLoginSuccessConfig,
			1,
			buildCustomFields("login", credentialType, nil, iosAuthServiceEnabled)
		)
	end,
	reportLoginFailure = function(data)
		local iosAuthServiceLoginFailureConfig = TelemetryConfigs.IosAuthServiceLoginFailureConfig

		local credentialType = data.credentialType
		local errorCode = data.errorCode
		local iosAuthServiceEnabled = data.iosAuthServiceEnabled

		if not (getFFlagEnableIosAuthServiceLuaIXP() and UserInputService:GetPlatform() == Enum.Platform.IOS) then
			return
		end

		default:logRobloxTelemetryCounter(
			iosAuthServiceLoginFailureConfig,
			1,
			buildCustomFields("login", credentialType, errorCode, iosAuthServiceEnabled)
		)
	end,
	reportLoginTwoStepRequired = function(p2)
		local iosAuthServiceLoginTwoStepRequiredConfig = TelemetryConfigs.IosAuthServiceLoginTwoStepRequiredConfig

		local credentialType = p2.credentialType

		local iosAuthServiceEnabled = p2.iosAuthServiceEnabled

		if not (getFFlagEnableIosAuthServiceLuaIXP() and UserInputService:GetPlatform() == Enum.Platform.IOS) then
			return
		end

		default:logRobloxTelemetryCounter(
			iosAuthServiceLoginTwoStepRequiredConfig,
			1,
			buildCustomFields("login", credentialType, nil, iosAuthServiceEnabled)
		)
	end,
	reportSignupSuccess = function(p2)
		local iosAuthServiceSignupSuccessConfig = TelemetryConfigs.IosAuthServiceSignupSuccessConfig

		local credentialType = p2.credentialType

		local iosAuthServiceEnabled = p2.iosAuthServiceEnabled

		if not (getFFlagEnableIosAuthServiceLuaIXP() and UserInputService:GetPlatform() == Enum.Platform.IOS) then
			return
		end

		default:logRobloxTelemetryCounter(
			iosAuthServiceSignupSuccessConfig,
			1,
			buildCustomFields("signup", credentialType, nil, iosAuthServiceEnabled)
		)
	end,
	reportSignupFailure = function(data)
		local iosAuthServiceSignupFailureConfig = TelemetryConfigs.IosAuthServiceSignupFailureConfig

		local credentialType = data.credentialType
		local errorCode = data.errorCode
		local iosAuthServiceEnabled = data.iosAuthServiceEnabled

		if not (getFFlagEnableIosAuthServiceLuaIXP() and UserInputService:GetPlatform() == Enum.Platform.IOS) then
			return
		end

		default:logRobloxTelemetryCounter(
			iosAuthServiceSignupFailureConfig,
			1,
			buildCustomFields("signup", credentialType, errorCode, iosAuthServiceEnabled)
		)
	end,
	reportPasswordSaveSuccess = function(p2)
		local iosAuthServicePasswordSaveSuccessConfig = TelemetryConfigs.IosAuthServicePasswordSaveSuccessConfig

		local credentialType = p2.credentialType

		local iosAuthServiceEnabled = p2.iosAuthServiceEnabled

		if not (getFFlagEnableIosAuthServiceLuaIXP() and UserInputService:GetPlatform() == Enum.Platform.IOS) then
			return
		end

		default:logRobloxTelemetryCounter(
			iosAuthServicePasswordSaveSuccessConfig,
			1,
			buildCustomFields("passwordSave", credentialType, nil, iosAuthServiceEnabled)
		)
	end,
	reportPasswordSaveFailure = function(data)
		local iosAuthServicePasswordSaveFailureConfig = TelemetryConfigs.IosAuthServicePasswordSaveFailureConfig

		local credentialType = data.credentialType
		local errorCode = data.errorCode
		local iosAuthServiceEnabled = data.iosAuthServiceEnabled

		if not (getFFlagEnableIosAuthServiceLuaIXP() and UserInputService:GetPlatform() == Enum.Platform.IOS) then
			return
		end

		default:logRobloxTelemetryCounter(
			iosAuthServicePasswordSaveFailureConfig,
			1,
			buildCustomFields("passwordSave", credentialType, errorCode, iosAuthServiceEnabled)
		)
	end
}
