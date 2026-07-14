local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Parent = script:FindFirstAncestor("AuthAnalytics").Parent
local default = require(Parent.LoggingProtocol).default
local TelemetryConfigs = require(script.Parent.TelemetryConfigs)
local GetFFlagEnableIosAuthServiceLuaIXP = require(Parent.SharedFlags).GetFFlagEnableIosAuthServiceLuaIXP

local function isIos() -- line: 33
	-- upvalues: UserInputService (copy)
	return UserInputService:GetPlatform() == Enum.Platform.IOS
end
local function majorMinor(s1: string?) -- line: 42
	if s1 == nil or s1 == "" then
		return nil
	end

	local parts = string.split(s1, ".")

	if #parts == 0 then
		return nil
	end

	if #parts == 1 then
		return parts[1]
	end

	return parts[1] .. "." .. parts[2]
end
local function buildCustomFields(s2: string, s3: string?, s4: string?, b1: boolean) -- line: 57
	-- upvalues: RunService (copy)
	local t1 = {
		source = "lua",
		surface = s2,
		iosAuthServiceEnabled = not b1 and "false" or "true"
	}

	if s3 ~= nil and s3 ~= "" then
		t1.credentialType = s3
	end

	if s4 ~= nil and s4 ~= "" then
		t1.errorCode = s4
	end

	local RobloxVersion = RunService:GetRobloxVersion()
	local v19

	if RobloxVersion == nil or RobloxVersion == "" then
		v19 = nil
	else
		local parts = string.split(RobloxVersion, ".")

		v19 = if #parts ~= 0 then if #parts ~= 1 then parts[1] .. "." .. parts[2] else parts[1] else nil
	end

	if v19 ~= nil and v19 ~= "" then
		t1.robloxVersion = v19
	end

	return t1
end
local function logCounter(p1, s5: string, s6: string?, s7: string?, b2: boolean) -- line: 84
	-- upvalues: GetFFlagEnableIosAuthServiceLuaIXP (copy), UserInputService (copy), default (copy), buildCustomFields (copy)
	if not GetFFlagEnableIosAuthServiceLuaIXP() then
		return
	end

	if UserInputService:GetPlatform() ~= Enum.Platform.IOS then
		return
	end

	default:logRobloxTelemetryCounter(p1, 1, (buildCustomFields(s5, s6, s7, b2)))
end

return {
	reportLoginSuccess = function(t2: {[any]: any}) -- line: 108
		-- upvalues: TelemetryConfigs (copy), GetFFlagEnableIosAuthServiceLuaIXP (copy), UserInputService (copy), default (copy), buildCustomFields (copy)
		local IosAuthServiceLoginSuccessConfig = TelemetryConfigs.IosAuthServiceLoginSuccessConfig
		local credentialType = t2.credentialType
		local iosAuthServiceEnabled = t2.iosAuthServiceEnabled

		if not GetFFlagEnableIosAuthServiceLuaIXP() then
			return
		end

		if UserInputService:GetPlatform() ~= Enum.Platform.IOS then
			return
		end

		default:logRobloxTelemetryCounter(IosAuthServiceLoginSuccessConfig, 1, (buildCustomFields("login", credentialType, nil, iosAuthServiceEnabled)))
	end,
	reportLoginFailure = function(t3: {[any]: any}) -- line: 118
		-- upvalues: TelemetryConfigs (copy), GetFFlagEnableIosAuthServiceLuaIXP (copy), UserInputService (copy), default (copy), buildCustomFields (copy)
		local IosAuthServiceLoginFailureConfig = TelemetryConfigs.IosAuthServiceLoginFailureConfig
		local credentialType = t3.credentialType
		local errorCode = t3.errorCode
		local iosAuthServiceEnabled = t3.iosAuthServiceEnabled

		if not GetFFlagEnableIosAuthServiceLuaIXP() then
			return
		end

		if UserInputService:GetPlatform() ~= Enum.Platform.IOS then
			return
		end

		default:logRobloxTelemetryCounter(IosAuthServiceLoginFailureConfig, 1, (buildCustomFields("login", credentialType, errorCode, iosAuthServiceEnabled)))
	end,
	reportLoginTwoStepRequired = function(t4: {[any]: any}) -- line: 130
		-- upvalues: TelemetryConfigs (copy), GetFFlagEnableIosAuthServiceLuaIXP (copy), UserInputService (copy), default (copy), buildCustomFields (copy)
		local IosAuthServiceLoginTwoStepRequiredConfig = TelemetryConfigs.IosAuthServiceLoginTwoStepRequiredConfig
		local credentialType = t4.credentialType
		local iosAuthServiceEnabled = t4.iosAuthServiceEnabled

		if not GetFFlagEnableIosAuthServiceLuaIXP() then
			return
		end

		if UserInputService:GetPlatform() ~= Enum.Platform.IOS then
			return
		end

		default:logRobloxTelemetryCounter(IosAuthServiceLoginTwoStepRequiredConfig, 1, (buildCustomFields("login", credentialType, nil, iosAuthServiceEnabled)))
	end,
	reportSignupSuccess = function(t5: {[any]: any}) -- line: 140
		-- upvalues: TelemetryConfigs (copy), GetFFlagEnableIosAuthServiceLuaIXP (copy), UserInputService (copy), default (copy), buildCustomFields (copy)
		local IosAuthServiceSignupSuccessConfig = TelemetryConfigs.IosAuthServiceSignupSuccessConfig
		local credentialType = t5.credentialType
		local iosAuthServiceEnabled = t5.iosAuthServiceEnabled

		if not GetFFlagEnableIosAuthServiceLuaIXP() then
			return
		end

		if UserInputService:GetPlatform() ~= Enum.Platform.IOS then
			return
		end

		default:logRobloxTelemetryCounter(IosAuthServiceSignupSuccessConfig, 1, (buildCustomFields("signup", credentialType, nil, iosAuthServiceEnabled)))
	end,
	reportSignupFailure = function(t6: {[any]: any}) -- line: 150
		-- upvalues: TelemetryConfigs (copy), GetFFlagEnableIosAuthServiceLuaIXP (copy), UserInputService (copy), default (copy), buildCustomFields (copy)
		local IosAuthServiceSignupFailureConfig = TelemetryConfigs.IosAuthServiceSignupFailureConfig
		local credentialType = t6.credentialType
		local errorCode = t6.errorCode
		local iosAuthServiceEnabled = t6.iosAuthServiceEnabled

		if not GetFFlagEnableIosAuthServiceLuaIXP() then
			return
		end

		if UserInputService:GetPlatform() ~= Enum.Platform.IOS then
			return
		end

		default:logRobloxTelemetryCounter(IosAuthServiceSignupFailureConfig, 1, (buildCustomFields("signup", credentialType, errorCode, iosAuthServiceEnabled)))
	end,
	reportPasswordSaveSuccess = function(t7: {[any]: any}) -- line: 160
		-- upvalues: TelemetryConfigs (copy), GetFFlagEnableIosAuthServiceLuaIXP (copy), UserInputService (copy), default (copy), buildCustomFields (copy)
		local IosAuthServicePasswordSaveSuccessConfig = TelemetryConfigs.IosAuthServicePasswordSaveSuccessConfig
		local credentialType = t7.credentialType
		local iosAuthServiceEnabled = t7.iosAuthServiceEnabled

		if not GetFFlagEnableIosAuthServiceLuaIXP() then
			return
		end

		if UserInputService:GetPlatform() ~= Enum.Platform.IOS then
			return
		end

		default:logRobloxTelemetryCounter(IosAuthServicePasswordSaveSuccessConfig, 1, (buildCustomFields("passwordSave", credentialType, nil, iosAuthServiceEnabled)))
	end,
	reportPasswordSaveFailure = function(t8: {[any]: any}) -- line: 170
		-- upvalues: TelemetryConfigs (copy), GetFFlagEnableIosAuthServiceLuaIXP (copy), UserInputService (copy), default (copy), buildCustomFields (copy)
		local IosAuthServicePasswordSaveFailureConfig = TelemetryConfigs.IosAuthServicePasswordSaveFailureConfig
		local credentialType = t8.credentialType
		local errorCode = t8.errorCode
		local iosAuthServiceEnabled = t8.iosAuthServiceEnabled

		if not GetFFlagEnableIosAuthServiceLuaIXP() then
			return
		end

		if UserInputService:GetPlatform() ~= Enum.Platform.IOS then
			return
		end

		default:logRobloxTelemetryCounter(IosAuthServicePasswordSaveFailureConfig, 1, (buildCustomFields("passwordSave", credentialType, errorCode, iosAuthServiceEnabled)))
	end
}
