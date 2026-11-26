local HttpService = game:GetService("HttpService")
local AppStorageService = game:GetService("AppStorageService")
local Lighting = game:GetService("Lighting")

local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")

local default = require("@game/CorePackages/Workspace/Packages/AppCommonLib").Utils.AppStorageJsonCacheUtils.default

local module2 = require("@luauforge/bundled/fGJ")
local module3 = require("@luauforge/bundled/fGL")

local getFStringDefaultVREnvironmentSetting = SharedFlags.GetFStringDefaultVREnvironmentSetting
local getFIntVREnvironmentSettingLightClockTime = SharedFlags.GetFIntVREnvironmentSettingLightClockTime
local getFIntVREnvironmentSettingDarkClockTime = SharedFlags.GetFIntVREnvironmentSettingDarkClockTime

local v5 = { System = "System", Light = "Light", Dark = "Dark" }

local v6 = v5[getFStringDefaultVREnvironmentSetting()] or v5.Light
local fIntVREnvironmentSettingLightClockTime = getFIntVREnvironmentSettingLightClockTime()
local fIntVREnvironmentSettingDarkClockTime = getFIntVREnvironmentSettingDarkClockTime()

local v7 = { VREnvironmentSettingEnum = v5 }

function v7.isValidLocalUserId(p2): boolean
	local v8 = tonumber(p2)
	return v8 ~= nil and v8 > 0
end

function v7.getEnvironmentSettingFromName(p2)
	if p2 then
		return v5[p2]
	end

	return nil
end

function v7.getCachedEnvironmentSetting(p2, options)
	if not v7.isValidLocalUserId(p2) then
		return v6
	end

	local result = ((options or {}).appStorageJsonCacheUtils or default):decodeInternal("VREnvironmentSetting").result
	local v8 = if type(result) == "table" then result[p2] else nil
	return v7.getEnvironmentSettingFromName(v8) or v6
end

function v7.setCachedEnvironmentSetting(p2, p3, options)
	if not v7.isValidLocalUserId(p2) then
		return
	end

	local environmentSettingFromName = v7.getEnvironmentSettingFromName(p3)

	if not environmentSettingFromName then
		return
	end

	local v8 = options or {}
	local appStorageJsonCacheUtils = v8.appStorageJsonCacheUtils or default
	local appStorageService = v8.appStorageService or AppStorageService
	local httpService = v8.httpService or HttpService
	local result = appStorageJsonCacheUtils:decodeInternal("VREnvironmentSetting").result

	local environmentSettingFromNames = type(result) ~= "table" and {} or result

	environmentSettingFromNames[p2] = environmentSettingFromName
	appStorageService:SetItem("VREnvironmentSetting", httpService:JSONEncode(environmentSettingFromNames))
	appStorageService:Flush()
end

function v7.applyLightSetting(options)
	((options or {}).lighting or Lighting).ClockTime = fIntVREnvironmentSettingLightClockTime
end

function v7.applyDarkSetting(options)
	((options or {}).lighting or Lighting).ClockTime = fIntVREnvironmentSettingDarkClockTime
end

function v7.applyEnvironmentSetting(p2, options)
	local v8 = options or {}

	if p2 == v5.System then
		local v9

		if v8.systemThemeEnabled == nil then
			v9 = module3.GetSystemThemeEnabled()
		else
			v9 = v8.systemThemeEnabled
		end

		local systemThemeEnum = v8.systemThemeEnum or module3.GetSystemThemeEnum()
		local systemThemeService = v8.systemThemeService or module3.GetSystemThemeService()

		if not (v9 and systemThemeEnum and systemThemeService) then
			return
		end

		local v10

		if v8.getSystemTheme then
			v10 = v8.getSystemTheme(systemThemeService)
		else
			v10 = module2(systemThemeService)
		end

		if systemThemeEnum.isLightTheme(v10) then
			v7.applyLightSetting(v8)
		elseif systemThemeEnum.isDarkTheme(v10) then
			v7.applyDarkSetting(v8)
		end
	elseif p2 == v5.Light then
		v7.applyLightSetting(v8)
	elseif p2 == v5.Dark then
		v7.applyDarkSetting(v8)
	end
end

function v7.applyCachedEnvironmentSetting(p2, p3)
	local cachedEnvironmentSetting = v7.getCachedEnvironmentSetting(p2, p3)
	v7.applyEnvironmentSetting(cachedEnvironmentSetting, p3)
end

return v7
