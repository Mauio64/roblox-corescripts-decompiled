local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local RunService = game:GetService("RunService")
local TelemetryService = game:GetService("TelemetryService")

local v = {
	eventName = "SlimTintModeSelected",
	backends = { "Points", "EventIngest" },
	throttlingPercentage = 10000,
	lastUpdated = { 2026, 10, 13 },
	description = [[
		SLIM tint mode selected by a user. Shared by the Developer Console Debug Visualizations tab
		(ui = "DevConsole") and the Studio Visualization Modes plugin (ui = "VisualizationModes").
		The app field is "Studio" or "Player", since the Developer Console runs in both.
	]]
}

return {
	logSlimTintModeSelected = function(p)
		if p.Name == "None" then
			return
		end

		TelemetryService:LogEvent(v, {
			customFields = {
				tintMode = p.Name,
				ui = "DevConsole",
				app = RunService:IsStudio() and "Studio" or "Player",
				clientId = RbxAnalyticsService:GetClientId()
			}
		})
	end
}
