local TelemetryService = game:GetService("TelemetryService")

local LoggingProtocol = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsErrorBoundary/LoggingProtocol")

local module2 = require("@luauforge/deferred/fyF")

local defineFastInt = game:DefineFastInt("RobloxPlusThemeAnalyticsHundredthsPercent", 10000)

local v5 = { 2026, 10, 14 }

local v6 = { "addSessionInfo", "addOSInfo" }

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
				"Fired when a non-subscriber taps Subscribe in the App Themes upsell banner"
			),
			{ standardizedFields = v6, customFields = {} }
		)
	end,
	reportThemeSelected = function(p2, value)
		if p2 == true and not module2 then
			return
		end

		assert(type(value) == "string", "Expected themeKey to be a string")

		local v8 = { theme_key = value }

		if module2 then
			v8.is_plus_subscriber = p2 == true
		end

		local v13 = if module2 then v5 else nil
		TelemetryService:LogEvent(
			makeEventConfig(
				"app_theme_selected",
				module2 and "Fired when a user selects an App Theme swatch" or "Fired when a non-subscriber previews an App Theme swatch",
				v13
			),
			{ standardizedFields = v6, customFields = v8 }
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
			{ standardizedFields = v6, customFields = {} }
		)
	end
}
