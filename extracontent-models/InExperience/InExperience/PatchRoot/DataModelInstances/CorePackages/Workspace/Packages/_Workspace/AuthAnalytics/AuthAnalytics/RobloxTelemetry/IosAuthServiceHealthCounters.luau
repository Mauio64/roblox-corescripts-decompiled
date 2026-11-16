local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local parent = script:FindFirstAncestor("AuthAnalytics").Parent
local LoggingProtocol = require(parent.LoggingProtocol)
local default = LoggingProtocol.default
local TelemetryConfigs = require(script.Parent.TelemetryConfigs)
local SharedFlags = require(parent.SharedFlags)
local GetFFlagEnableIosAuthServiceLuaIXP = SharedFlags.GetFFlagEnableIosAuthServiceLuaIXP

local function isIos(): boolean -- 1 equivalent call inferred from this helper
	return UserInputService:GetPlatform() == Enum.Platform.IOS
end

local function majorMinor(robloxVersion: string?) -- 1 equivalent call inferred from this helper
	if robloxVersion == nil or robloxVersion == "" then
		return nil
	end

	local v = string.split(robloxVersion, ".")

	if #v == 0 then
		return nil
	end

	if #v == 1 then
		return v[1]
	end

	return v[1] .. "." .. v[2]
end

local function buildCustomFields(surface: string, credentialType: string?, errorCode: string?, flag: boolean)
	local customFields = {
		source = "lua",
		surface = surface,
		iosAuthServiceEnabled = flag and "true" or "false"
	}

	if credentialType ~= nil and credentialType ~= "" then
		customFields.credentialType = credentialType
	end

	if errorCode ~= nil and errorCode ~= "" then
		customFields.errorCode = errorCode
	end

	local robloxVersion = majorMinor(RunService:GetRobloxVersion()) -- inferred equivalent call

	if robloxVersion ~= nil and robloxVersion ~= "" then
		customFields.robloxVersion = robloxVersion
	end

	return customFields
end

local function logCounter(p, surface: string, credentialType: string?, errorCode: string?, iosAuthServiceEnabled: boolean) -- 7 equivalent calls inferred from this helper
	if not (GetFFlagEnableIosAuthServiceLuaIXP() and isIos()) then -- inferred equivalent call
		return
	end

	default:logRobloxTelemetryCounter(
		p,
		1,
		buildCustomFields(surface, credentialType, errorCode, iosAuthServiceEnabled)
	)
end

local IosAuthServiceHealthCounters = {}

function IosAuthServiceHealthCounters.reportLoginSuccess(p)
	logCounter( -- inferred equivalent call
		TelemetryConfigs.IosAuthServiceLoginSuccessConfig,
		"login",
		p.credentialType,
		nil,
		p.iosAuthServiceEnabled
	)
end

function IosAuthServiceHealthCounters.reportLoginFailure(data)
	logCounter( -- inferred equivalent call
		TelemetryConfigs.IosAuthServiceLoginFailureConfig,
		"login",
		data.credentialType,
		data.errorCode,
		data.iosAuthServiceEnabled
	)
end

function IosAuthServiceHealthCounters.reportLoginTwoStepRequired(p)
	logCounter( -- inferred equivalent call
		TelemetryConfigs.IosAuthServiceLoginTwoStepRequiredConfig,
		"login",
		p.credentialType,
		nil,
		p.iosAuthServiceEnabled
	)
end

function IosAuthServiceHealthCounters.reportSignupSuccess(p)
	logCounter( -- inferred equivalent call
		TelemetryConfigs.IosAuthServiceSignupSuccessConfig,
		"signup",
		p.credentialType,
		nil,
		p.iosAuthServiceEnabled
	)
end

function IosAuthServiceHealthCounters.reportSignupFailure(data)
	logCounter( -- inferred equivalent call
		TelemetryConfigs.IosAuthServiceSignupFailureConfig,
		"signup",
		data.credentialType,
		data.errorCode,
		data.iosAuthServiceEnabled
	)
end

function IosAuthServiceHealthCounters.reportPasswordSaveSuccess(p)
	logCounter( -- inferred equivalent call
		TelemetryConfigs.IosAuthServicePasswordSaveSuccessConfig,
		"passwordSave",
		p.credentialType,
		nil,
		p.iosAuthServiceEnabled
	)
end

function IosAuthServiceHealthCounters.reportPasswordSaveFailure(data)
	logCounter( -- inferred equivalent call
		TelemetryConfigs.IosAuthServicePasswordSaveFailureConfig,
		"passwordSave",
		data.credentialType,
		data.errorCode,
		data.iosAuthServiceEnabled
	)
end

return IosAuthServiceHealthCounters
