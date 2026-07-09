local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local Modules = CoreGui.RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local useLocalUserId = require(CorePackages.Workspace.Packages.RobloxAppHooks).useLocalUserId
local useIsSpatial = require(CorePackages.Workspace.Packages.Responsive).useIsSpatial
local VREnvironmentSettingUtils = require(Modules.LuaApp.Components.More.VREnvironmentSettingUtils)
local SystemThemeFeature = require(Modules.LuaApp.Components.EventReceivers.SystemThemeFeature)

local function buildOptions(t1: {[any]: any}) -- line: 24
	return {
		appStorageJsonCacheUtils = t1.AppStorageJsonCacheUtils,
		appStorageService = t1.AppStorageService,
		httpService = t1.HttpService,
		lighting = t1.Lighting,
		systemThemeEnabled = t1.SystemThemeEnabled,
		systemThemeEnum = t1.SystemThemeEnum,
		systemThemeService = t1.SystemThemeService,
		getSystemTheme = t1.getSystemTheme
	}
end
local function VREnvironmentSettingEventReceiver(t2: {[any]: any}) -- line: 37
	-- upvalues: useLocalUserId (copy), useIsSpatial (copy), React (copy), Lighting (copy), VREnvironmentSettingUtils (copy), SystemThemeFeature (copy)
	local v14 = useLocalUserId()
	local v15 = useIsSpatial()
	local v16 = React.useMemo(function() -- line: 42
		-- upvalues: t2 (copy)
		local v17 = t2

		return {
			appStorageJsonCacheUtils = v17.AppStorageJsonCacheUtils,
			appStorageService = v17.AppStorageService,
			httpService = v17.HttpService,
			lighting = v17.Lighting,
			systemThemeEnabled = v17.SystemThemeEnabled,
			systemThemeEnum = v17.SystemThemeEnum,
			systemThemeService = v17.SystemThemeService,
			getSystemTheme = v17.getSystemTheme
		}
	end, {
		t2.AppStorageJsonCacheUtils,
		t2.AppStorageService,
		t2.HttpService,
		t2.Lighting,
		t2.SystemThemeEnabled,
		t2.SystemThemeEnum,
		t2.SystemThemeService,
		t2.getSystemTheme
	})

	React.useEffect(function() -- line: 57
		-- upvalues: v15 (copy), Lighting (copy)
		if not v15 then
			return
		end

		pcall(function() -- line: 62
			-- upvalues: Lighting (copy)
			local Sky = Lighting:FindFirstChild("Sky")

			if Sky then
				Sky:Destroy()
			end
		end)
	end, { v15 })
	React.useEffect(function() -- line: 71
		-- upvalues: v15 (copy), VREnvironmentSettingUtils (copy), v14 (copy), v16 (copy), SystemThemeFeature (copy)
		if not v15 then
			return
		end

		VREnvironmentSettingUtils.applyCachedEnvironmentSetting(v14, v16)

		local v18 = v16.systemThemeService or SystemThemeFeature.GetSystemThemeService()
		local v19 = v18 and v18.OnLuaThemeUpdated

		if not v19 then
			return
		end

		local connection = v19:Connect(function() -- line: 84
			-- upvalues: VREnvironmentSettingUtils (copy), v14 (copy), v16 (copy)
			local v22 = VREnvironmentSettingUtils.getCachedEnvironmentSetting(v14, v16)

			if v22 == VREnvironmentSettingUtils.VREnvironmentSettingEnum.System then
				VREnvironmentSettingUtils.applyEnvironmentSetting(v22, v16)
			end
		end)

		return function() -- line: 91
			-- upvalues: connection (copy)
			connection:Disconnect()
		end
	end, {
		v15,
		v14,
		v16
	})

	return nil
end

return VREnvironmentSettingEventReceiver
