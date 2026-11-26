local TelemetryService = game:GetService("TelemetryService")

local LoggingProtocol = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsErrorBoundary/LoggingProtocol")

local defineFastInt = game:DefineFastInt("RobloxPlusThemeAnalyticsHundredthsPercent", 10000)

local v5 = { 2026, 10, 14 }
local v6 = { 2026, 11, 9 }

local v7 = { "addSessionInfo", "addOSInfo" }

local function makeEventConfig(p2, p3, p4)
	return {
		eventName = p2,
		backends = { LoggingProtocol.TelemetryBackends.EventIngest },
		throttlingPercentage = defineFastInt,
		lastUpdated = p4 or { 2026, 7, 22 },
		description = p3
	}
end

return {
	reportSubscribeClick = function(p2)
		if p2 == true then
			return
		end

		TelemetryService:LogEvent(
			makeEventConfig(
				"app_theme_upsell_subscribe_click",
				"Fired when a non-subscriber starts the App Themes Plus upsell, from the banner Subscribe link or by tapping a locked theme",
				v6
			),
			{ standardizedFields = v7, customFields = {} }
		)
	end,
	reportThemeSelected = function(p2, value)
		assert(type(value) == "string", "Expected themeKey to be a string")

		local v9 = { theme_key = value }

		v9.is_plus_subscriber = p2 == true

		TelemetryService:LogEvent(
			makeEventConfig("app_theme_selected", "Fired when a user selects an App Theme swatch", v5),
			{ standardizedFields = v7, customFields = v9 }
		)
	end,
	reportPageExit = function(p2)
		if p2 == true then
			return
		end

		TelemetryService:LogEvent(
			makeEventConfig(
				"device_preferences_exit",
				"Fired when a non-subscriber who saw the App Themes upsell leaves Device Preferences"
			),
			{ standardizedFields = v7, customFields = {} }
		)
	end
}
