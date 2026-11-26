game:DefineFastFlag("SystemThemeLuaEnabled10", false)

local v5 = {}

if game:GetFastFlag("SystemThemeLuaEnabled10") then
	local utils = require("@luauforge/bundled/fGM").Utils

	v5.ClearThemeOverride = utils.ClearThemeOverride
	v5.GetSystemThemeEnabled = utils.GetSystemThemeEnabled
	v5.GetSystemThemeEnum = utils.GetSystemThemeEnum
	v5.GetSystemThemeService = utils.GetSystemThemeService
	v5.SetDarkThemeOverride = utils.SetDarkThemeOverride
	v5.DeviceLevelThemeLocalStorageKey = "DeviceLevelTheme"
	return v5
else
	local MessageBusService = game:GetService("MessageBusService")

	local messageId = MessageBusService:GetMessageId("SystemTheme", "systemThemeSetThemeOverride")

	function v5.GetSystemThemeEnabled()
		local v6 = game:GetService("SystemThemeService")

		if v6 then
			local SystemThemeService = game:GetService("SystemThemeService")
			v6 = SystemThemeService:isSystemThemeAvailable()
		end

		return v6
	end

	function v5.GetSystemThemeService()
		local SystemThemeService = game:GetService("SystemThemeService")
		return SystemThemeService or nil
	end

	function v5.GetSystemThemeEnum()
		local SystemThemeService = game:GetService("SystemThemeService")
		local v6

		if SystemThemeService then
			local SystemThemeService2 = game:GetService("SystemThemeService")
			v6 = SystemThemeService2:isSystemThemeAvailable() and require("@luauforge/bundled/fGX") or nil
		end

		return v6
	end

	v5.DeviceLevelThemeLocalStorageKey = "DeviceLevelTheme"

	function v5.SetDarkThemeOverride()
		if v5.GetSystemThemeEnabled() then
			MessageBusService:Publish(messageId, { ThemeOverride = "dark" })
		end
	end

	function v5.ClearThemeOverride()
		if v5.GetSystemThemeEnabled() then
			MessageBusService:Publish(messageId, { ThemeOverride = nil })
		end
	end

	return v5
end
