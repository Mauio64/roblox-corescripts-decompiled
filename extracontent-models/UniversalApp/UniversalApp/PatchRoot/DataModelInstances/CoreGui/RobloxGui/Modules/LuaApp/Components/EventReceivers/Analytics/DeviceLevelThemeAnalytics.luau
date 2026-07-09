local v1 = game:DefineFastInt("SystemThemeSnapshotTimeDiffMins", 1440)
local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local SystemThemeEnum = require(Modules.LuaApp.Components.EventReceivers.SystemThemeEnum)
local GetFFlagEnableThemeUpdatedLoggingFix = require(Modules.LuaApp.Flags.GetFFlagEnableThemeUpdatedLoggingFix)
local AppStorageService = game:GetService("AppStorageService")
local LoggingProtocol = require(CorePackages.Workspace.Packages.LoggingProtocol)
local t1 = {}

t1.__index = t1

local v10 = game:DefineFastInt("DeviceLevelThemeAnalyticsHundredthsPercent", 10000)

t1.EventName = {
	ThemeSnapshot = "DeviceThemeSnapshot",
	ThemeChanged = "DeviceThemeChanged",
	SystemThemeRequest = "SystemThemeRequestCounter",
	SystemThemeObtainedSuccess = "SystemThemeLuaObtainedSuccess",
	SystemThemeObtainedError = "SystemThemeLuaObtainedError",
	SystemThemeUpdated = "SystemThemeUpdated",
	SystemThemeChangeRequest = "SystemThemeAppChange"
}
t1.ThemeName = {
	ThemeSystemDark = "SystemDark",
	ThemeSystemLight = "SystemLight",
	ThemeSystem = "System",
	ThemeDark = "Dark",
	ThemeLight = "Light",
	ThemeError = "Error"
}

function t1.onThemeSnapshot(p1, p2) -- line: 40
	-- upvalues: AppStorageService (copy), v1 (copy), t1 (copy), LoggingProtocol (copy), v10 (copy), GetFFlagEnableThemeUpdatedLoggingFix (copy), SystemThemeEnum (copy)
	if not game:GetEngineFeature("SystemThemeSnapshotTimeKeyAvailble") then
		return
	end

	local UnixTimestamp = DateTime.now().UnixTimestamp
	local Item = AppStorageService:GetItem("DeviceLevelThemeSnapshotTimestamp")

	if Item == "" then
		AppStorageService:SetItem("DeviceLevelThemeSnapshotTimestamp", (tostring(UnixTimestamp)))
		AppStorageService:Flush()

		return
	end

	if (tonumber(UnixTimestamp) or 0) - (tonumber(Item) or 0) > v1 * 60 then
		local t2 = {
			description = "Event sent once a day to show the current selected theme",
			links = "",
			eventName = t1.EventName.ThemeSnapshot,
			backends = { LoggingProtocol.TelemetryBackends.EventIngest },
			throttlingPercentage = v10,
			lastUpdated = {
				2025,
				5,
				13
			}
		}
		local ThemeError

		if GetFFlagEnableThemeUpdatedLoggingFix() then
			ThemeError = t1.ThemeName.ThemeError

			if p2 == SystemThemeEnum.Light then
				ThemeError = t1.ThemeName.ThemeLight
			elseif p2 == SystemThemeEnum.Dark then
				ThemeError = t1.ThemeName.ThemeDark
			elseif p2 == SystemThemeEnum.SystemLight then
				ThemeError = t1.ThemeName.ThemeSystemLight
			elseif p2 == SystemThemeEnum.SystemDark then
				ThemeError = t1.ThemeName.ThemeSystemDark
			end
		else
			ThemeError = t1.ThemeName.ThemeSystem

			if p2 == SystemThemeEnum.Light then
				ThemeError = t1.ThemeName.ThemeLight
			elseif p2 == SystemThemeEnum.Dark then
				ThemeError = t1.ThemeName.ThemeDark
			end
		end

		local t3 = {
			selectedTheme = ThemeError
		}

		p1.telemetryService:LogEvent(t2, {
			customFields = t3
		})
		AppStorageService:SetItem("DeviceLevelThemeSnapshotTimestamp", (tostring(UnixTimestamp)))
		AppStorageService:Flush()
	end
end
function t1.onThemeChanged(p3, p4) -- line: 99
	-- upvalues: t1 (copy), LoggingProtocol (copy), v10 (copy), SystemThemeEnum (copy)
	local t4 = {
		description = "Event sent when the selected theme has been changed",
		links = "",
		eventName = t1.EventName.ThemeChanged,
		backends = { LoggingProtocol.TelemetryBackends.EventIngest },
		throttlingPercentage = v10,
		lastUpdated = {
			2025,
			5,
			13
		}
	}
	local ThemeSystem = t1.ThemeName.ThemeSystem

	if p4 == SystemThemeEnum.Light then
		ThemeSystem = t1.ThemeName.ThemeLight
	elseif p4 == SystemThemeEnum.Dark then
		ThemeSystem = t1.ThemeName.ThemeDark
	end

	local t5 = {
		selectedTheme = ThemeSystem
	}

	p3.telemetryService:LogEvent(t4, {
		customFields = t5
	})
end
function t1.onReceivedSystemThemeUpdated(p5) -- line: 122
	-- upvalues: t1 (copy)
	local t6 = {
		description = "Counter to be updated when lua receives a notification from the native layer that the system theme is updated",
		eventName = t1.EventName.SystemThemeUpdated,
		backends = { "RobloxTelemetryCounter" },
		lastUpdated = {
			2025,
			5,
			13
		}
	}

	p5.telemetryService:LogCounter(t6)
end
function t1.onRequestSystemTheme(p6) -- line: 132
	-- upvalues: t1 (copy)
	local t7 = {
		description = "Counter to be updated when lua requests the system theme from the native layer",
		eventName = t1.EventName.SystemThemeRequest,
		backends = { "RobloxTelemetryCounter" },
		lastUpdated = {
			2025,
			5,
			13
		}
	}

	p6.telemetryService:LogCounter(t7)
end
function t1.onGetSystemTheme(p7, p8) -- line: 142
	-- upvalues: SystemThemeEnum (copy), t1 (copy)
	if p8 == SystemThemeEnum.Error then
		local t8 = {
			description = "Counter to be updated when lua receives an error for system theme value from the native layer",
			eventName = t1.EventName.SystemThemeObtainedError,
			backends = { "RobloxTelemetryCounter" },
			lastUpdated = {
				2025,
				5,
				13
			}
		}

		p7.telemetryService:LogCounter(t8)

		return
	end

	local t9 = {
		description = "Counter to be updated when lua receives the system theme value from the native layer",
		eventName = t1.EventName.SystemThemeObtainedSuccess,
		backends = { "RobloxTelemetryCounter" },
		lastUpdated = {
			2025,
			5,
			13
		}
	}

	p7.telemetryService:LogCounter(t9)
end
function t1.onSetNativeTheme(p9) -- line: 162
	-- upvalues: t1 (copy)
	local t10 = {
		description = "Counter to be updated when lua send the native layer a set theme",
		eventName = t1.EventName.SystemThemeChangeRequest,
		backends = { "RobloxTelemetryCounter" },
		lastUpdated = {
			2025,
			5,
			13
		}
	}

	p9.telemetryService:LogCounter(t10)
end
function t1.new(p10) -- line: 172
	-- upvalues: t1 (copy)
	local t11 = {
		telemetryService = p10
	}

	setmetatable(t11, t1)

	return t11
end

return t1
