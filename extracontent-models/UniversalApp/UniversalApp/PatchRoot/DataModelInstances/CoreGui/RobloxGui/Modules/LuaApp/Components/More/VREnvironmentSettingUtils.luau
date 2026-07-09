local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local AppStorageService = game:GetService("AppStorageService")
local Lighting = game:GetService("Lighting")
local Modules = CoreGui.RobloxGui.Modules
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local default = require(CorePackages.Workspace.Packages.AppCommonLib).Utils.AppStorageJsonCacheUtils.default
local GetSystemTheme = require(Modules.LuaApp.Components.EventReceivers.GetSystemTheme)
local SystemThemeFeature = require(Modules.LuaApp.Components.EventReceivers.SystemThemeFeature)
local GetFStringDefaultVREnvironmentSetting = SharedFlags.GetFStringDefaultVREnvironmentSetting
local GetFIntVREnvironmentSettingLightClockTime = SharedFlags.GetFIntVREnvironmentSettingLightClockTime
local GetFIntVREnvironmentSettingDarkClockTime = SharedFlags.GetFIntVREnvironmentSettingDarkClockTime
local t1 = {
	System = "System",
	Light = "Light",
	Dark = "Dark"
}
local v15 = t1[GetFStringDefaultVREnvironmentSetting()] or t1.Light
local v16 = GetFIntVREnvironmentSettingLightClockTime()
local v17 = GetFIntVREnvironmentSettingDarkClockTime()
local t2 = {
	VREnvironmentSettingEnum = t1,
	isValidLocalUserId = function(s1: string?) -- line: 48
		local num = tonumber(s1)

		return num ~= nil and num > 0
	end,
	getEnvironmentSettingFromName = function(s2: string?) -- line: 53
		-- upvalues: t1 (copy)
		if not s2 then
			return nil
		end

		return t1[s2]
	end
}

function t2.getCachedEnvironmentSetting(s3: string?, t3: {[any]: any}?) -- line: 61
	-- upvalues: t2 (copy), v15 (copy), default (copy)
	if not t2.isValidLocalUserId(s3) then
		return v15
	end

	local result = ((t3 or {}).appStorageJsonCacheUtils or default):decodeInternal("VREnvironmentSetting").result
	local v25 = if type(result) ~= "table" then nil else result[s3]

	return t2.getEnvironmentSettingFromName(v25) or v15
end
function t2.setCachedEnvironmentSetting(s4: string?, s5: string, t4: {[any]: any}?) -- line: 76
	-- upvalues: t2 (copy), default (copy), AppStorageService (copy), HttpService (copy)
	if not t2.isValidLocalUserId(s4) then
		return
	end

	local v29 = t2.getEnvironmentSettingFromName(s5)

	if not v29 then
		return
	end

	local v30 = t4 or {}
	local v31 = v30.appStorageJsonCacheUtils or default
	local v32 = v30.appStorageService or AppStorageService
	local v33 = v30.httpService or HttpService
	local result = v31:decodeInternal("VREnvironmentSetting").result

	if type(result) ~= "table" then
		result = {}
	end

	result[s4] = v29
	v32:SetItem("VREnvironmentSetting", v33:JSONEncode(result))
	v32:Flush()
end
function t2.applyLightSetting(t5: {[any]: any}?) -- line: 101
	-- upvalues: Lighting (copy), v16 (copy);
	((t5 or {}).lighting or Lighting).ClockTime = v16
end
function t2.applyDarkSetting(t6: {[any]: any}?) -- line: 107
	-- upvalues: Lighting (copy), v17 (copy);
	((t6 or {}).lighting or Lighting).ClockTime = v17
end
function t2.applyEnvironmentSetting(s6: string, t7: {[any]: any}?) -- line: 113
	-- upvalues: t1 (copy), SystemThemeFeature (copy), GetSystemTheme (copy), t2 (copy)
	local v39 = t7 or {}

	if s6 == t1.System then
		local v40 = if v39.systemThemeEnabled == nil then SystemThemeFeature.GetSystemThemeEnabled() else v39.systemThemeEnabled
		local v41 = v39.systemThemeEnum or SystemThemeFeature.GetSystemThemeEnum()
		local v42 = v39.systemThemeService or SystemThemeFeature.GetSystemThemeService()

		if not v40 or not v41 or not v42 then
			return
		end

		local v43 = if not v39.getSystemTheme then GetSystemTheme(v42) else v39.getSystemTheme(v42)

		if v41.isLightTheme(v43) then
			t2.applyLightSetting(v39)

			return
		end

		if v41.isDarkTheme(v43) then
			t2.applyDarkSetting(v39)

			return
		end
	else
		if s6 == t1.Light then
			t2.applyLightSetting(v39)

			return
		end

		if s6 == t1.Dark then
			t2.applyDarkSetting(v39)
		end
	end
end
function t2.applyCachedEnvironmentSetting(s7: string?, t8: {[any]: any}?) -- line: 142
	-- upvalues: t2 (copy)
	local v46 = t2.getCachedEnvironmentSetting(s7, t8)

	t2.applyEnvironmentSetting(v46, t8)
end

return t2
