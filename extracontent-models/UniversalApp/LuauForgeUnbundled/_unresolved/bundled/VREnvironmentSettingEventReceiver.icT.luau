local CorePackages = game:GetService("CorePackages")

local Lighting = game:GetService("Lighting")

local React = require(CorePackages.Packages.React)
local useLocalUserId = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks").useLocalUserId
local useIsSpatial = require("@game/CorePackages/Workspace/Packages/Responsive").useIsSpatial

local module = require("@luauforge/bundled/fyS")
local module2 = require("@luauforge/bundled/fyV")

local function buildOptions(data)
	return {
		appStorageJsonCacheUtils = data.AppStorageJsonCacheUtils,
		appStorageService = data.AppStorageService,
		httpService = data.HttpService,
		lighting = data.Lighting,
		systemThemeEnabled = data.SystemThemeEnabled,
		systemThemeEnum = data.SystemThemeEnum,
		systemThemeService = data.SystemThemeService,
		getSystemTheme = data.getSystemTheme
	}
end

local function VREnvironmentSettingEventReceiver(data): nil
	local v5 = useLocalUserId()
	local v6 = useIsSpatial()

	local v7 = React.useMemo(function()
		local v8 = data
		return {
			appStorageJsonCacheUtils = v8.AppStorageJsonCacheUtils,
			appStorageService = v8.AppStorageService,
			httpService = v8.HttpService,
			lighting = v8.Lighting,
			systemThemeEnabled = v8.SystemThemeEnabled,
			systemThemeEnum = v8.SystemThemeEnum,
			systemThemeService = v8.SystemThemeService,
			getSystemTheme = v8.getSystemTheme
		}
	end, {
		data.AppStorageJsonCacheUtils,
		data.AppStorageService,
		data.HttpService,
		data.Lighting,
		data.SystemThemeEnabled,
		data.SystemThemeEnum,
		data.SystemThemeService,
		data.getSystemTheme
	})

	React.useEffect(function()
		if not v6 then
			return
		end

		pcall(function()
			local sky = Lighting:FindFirstChild("Sky")

			if sky then
				sky:Destroy()
			end
		end)
	end, { v6 })

	React.useEffect(function()
		if not v6 then
			return
		end

		module.applyCachedEnvironmentSetting(v5, v7)

		local systemThemeService = v7.systemThemeService or module2.GetSystemThemeService()
		local onLuaThemeUpdated = systemThemeService and systemThemeService.OnLuaThemeUpdated

		if not onLuaThemeUpdated then
			return
		end

		local connection = onLuaThemeUpdated:Connect(function()
			local cachedEnvironmentSetting = module.getCachedEnvironmentSetting(v5, v7)

			if cachedEnvironmentSetting == module.VREnvironmentSettingEnum.System then
				module.applyEnvironmentSetting(cachedEnvironmentSetting, v7)
			end
		end)

		return function()
			connection:Disconnect()
		end
	end, { v6, v5, v7 })

	return nil
end

return VREnvironmentSettingEventReceiver
