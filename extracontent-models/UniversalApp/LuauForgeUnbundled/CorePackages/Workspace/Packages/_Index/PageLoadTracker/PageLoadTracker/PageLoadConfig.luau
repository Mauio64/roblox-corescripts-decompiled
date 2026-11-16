local LoggingProtocol = require("@game/CorePackages/Workspace/Packages/_Index/PageLoadTracker/LoggingProtocol")

return {
	IDLE_TIMEOUT_SECONDS = 1,
	PAGE_LOAD_SUMMARY_CONFIG = {
		eventName = "app_page_load_time",
		backends = { LoggingProtocol.TelemetryBackends.Points, LoggingProtocol.TelemetryBackends.EventIngest },
		throttlingPercentage = 10000,
		lastUpdated = { 25, 6, 18 },
		description = "Page load completion events with automatic idle detection",
		links = ""
	},
	VISUAL_DEBUG = {
		HIGHLIGHT_DURATION = 1,
		FADE_DURATION = 2,
		HIGHLIGHT_COLOR = nil,
		BORDER_COLOR = Color3.fromRGB(255, 0, 0),
		MIN_BORDER_SIZE = 2,
		TRANSPARENCY_REDUCTION = 0.3,
		END_COLOR = Color3.fromRGB(200, 200, 200)
	},
	SCREEN_BOUNDS = {
		DEFAULT_SCREEN_SIZE = Vector2.new(1000, 1000),
		DEFAULT_TOP_BAR_HEIGHT = 0,
		MIN_VISIBILITY_RATIO = 0.5
	}
}
