local defineFastInt = game:DefineFastInt("SystemThemeSnapshotTimeDiffMins", 1440)

local module = require("@luauforge/bundled/fzh")
local module2 = require("@luauforge/bundled/fzm")
local AppStorageService = game:GetService("AppStorageService")
local LoggingProtocol = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsErrorBoundary/LoggingProtocol")

local class = {}
class.__index = class

local defineFastInt2 = game:DefineFastInt("DeviceLevelThemeAnalyticsHundredthsPercent", 10000)

class.EventName = {
	ThemeSnapshot = "DeviceThemeSnapshot",
	ThemeChanged = "DeviceThemeChanged",
	SystemThemeRequest = "SystemThemeRequestCounter",
	SystemThemeObtainedSuccess = "SystemThemeLuaObtainedSuccess",
	SystemThemeObtainedError = "SystemThemeLuaObtainedError",
	SystemThemeUpdated = "SystemThemeUpdated",
	SystemThemeChangeRequest = "SystemThemeAppChange"
}

class.ThemeName = {
	ThemeSystemDark = "SystemDark",
	ThemeSystemLight = "SystemLight",
	ThemeSystem = "System",
	ThemeDark = "Dark",
	ThemeLight = "Light",
	ThemeError = "Error"
}

function class:onThemeSnapshot(p3)
	if not game:GetEngineFeature("SystemThemeSnapshotTimeKeyAvailble") then
		return
	end

	local unixTimestamp = DateTime.now().UnixTimestamp
	local item = AppStorageService:GetItem("DeviceLevelThemeSnapshotTimestamp")

	if item == "" then
		AppStorageService:SetItem("DeviceLevelThemeSnapshotTimestamp", (tostring(unixTimestamp)))
		AppStorageService:Flush()
	else
		local v5 = (tonumber(unixTimestamp) or 0) - (tonumber(item) or 0)

		if defineFastInt * 60 < v5 then
			local v6 = {
				eventName = class.EventName.ThemeSnapshot,
				backends = { LoggingProtocol.TelemetryBackends.EventIngest },
				throttlingPercentage = defineFastInt2,
				lastUpdated = { 2025, 5, 13 },
				description = "Event sent once a day to show the current selected theme",
				links = ""
			}
			local v7

			if module2() then
				v7 = class.ThemeName.ThemeError

				if p3 == module.Light then
					v7 = class.ThemeName.ThemeLight
				elseif p3 == module.Dark then
					v7 = class.ThemeName.ThemeDark
				elseif p3 == module.SystemLight then
					v7 = class.ThemeName.ThemeSystemLight
				elseif p3 == module.SystemDark then
					v7 = class.ThemeName.ThemeSystemDark
				end
			else
				v7 = class.ThemeName.ThemeSystem

				if p3 == module.Light then
					v7 = class.ThemeName.ThemeLight
				elseif p3 == module.Dark then
					v7 = class.ThemeName.ThemeDark
				end
			end

			self.telemetryService:LogEvent(v6, {
				customFields = { selectedTheme = v7 }
			})

			AppStorageService:SetItem("DeviceLevelThemeSnapshotTimestamp", (tostring(unixTimestamp)))
			AppStorageService:Flush()
		end
	end
end

function class.onThemeChanged(p2, p3)
	local v5 = {
		eventName = class.EventName.ThemeChanged,
		backends = { LoggingProtocol.TelemetryBackends.EventIngest },
		throttlingPercentage = defineFastInt2,
		lastUpdated = { 2025, 5, 13 },
		description = "Event sent when the selected theme has been changed",
		links = ""
	}

	local v6 = class.ThemeName.ThemeSystem

	if p3 == module.Light then
		v6 = class.ThemeName.ThemeLight
	elseif p3 == module.Dark then
		v6 = class.ThemeName.ThemeDark
	end

	p2.telemetryService:LogEvent(v5, {
		customFields = { selectedTheme = v6 }
	})
end

function class:onReceivedSystemThemeUpdated()
	local v5 = {
		eventName = class.EventName.SystemThemeUpdated,
		backends = { "RobloxTelemetryCounter" },
		lastUpdated = { 2025, 5, 13 },
		description = "Counter to be updated when lua receives a notification from the native layer that the system theme is updated"
	}

	self.telemetryService:LogCounter(v5)
end

function class:onRequestSystemTheme()
	local v5 = {
		eventName = class.EventName.SystemThemeRequest,
		backends = { "RobloxTelemetryCounter" },
		lastUpdated = { 2025, 5, 13 },
		description = "Counter to be updated when lua requests the system theme from the native layer"
	}

	self.telemetryService:LogCounter(v5)
end

function class:onGetSystemTheme(p3)
	if p3 == module.Error then
		local v5 = {
			eventName = class.EventName.SystemThemeObtainedError,
			backends = { "RobloxTelemetryCounter" },
			lastUpdated = { 2025, 5, 13 },
			description = "Counter to be updated when lua receives an error for system theme value from the native layer"
		}

		self.telemetryService:LogCounter(v5)
	else
		local v5 = {
			eventName = class.EventName.SystemThemeObtainedSuccess,
			backends = { "RobloxTelemetryCounter" },
			lastUpdated = { 2025, 5, 13 },
			description = "Counter to be updated when lua receives the system theme value from the native layer"
		}

		self.telemetryService:LogCounter(v5)
	end
end

function class:onSetNativeTheme()
	local v5 = {
		eventName = class.EventName.SystemThemeChangeRequest,
		backends = { "RobloxTelemetryCounter" },
		lastUpdated = { 2025, 5, 13 },
		description = "Counter to be updated when lua send the native layer a set theme"
	}

	self.telemetryService:LogCounter(v5)
end

function class.new(p2)
	local v5 = { telemetryService = p2 }

	setmetatable(v5, class)

	return v5
end

return class
