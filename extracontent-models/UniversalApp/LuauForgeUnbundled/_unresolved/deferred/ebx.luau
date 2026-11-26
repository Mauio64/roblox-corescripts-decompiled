local supportedTelemetryBackends = require("@game/CorePackages/Workspace/Packages/_Workspace/CapturesInExperience/SocialLuaAnalytics").Analytics.Enums.SupportedTelemetryBackends

local module = require("@luauforge/deferred/eam")

return {
	defaults = {
		throttlingThousandths = game:DefineFastInt("ContentFeedTelemetryThrottlingThousandths", 1000),
		links = ""
	},
	[module.ContentFeedCloseShortcutPressed] = {
		backendsList = {
			{ type = supportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[module.ContentFeedDeleteCtaPressed] = {
		backendsList = {
			{ type = supportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[module.ContentFeedExitCtaPressed] = {
		backendsList = {
			{ type = supportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[module.ContentFeedInspectCtaPressed] = {
		backendsList = {
			{ type = supportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[module.ContentFeedInspectItemPressed] = {
		backendsList = {
			{ type = supportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[module.ContentFeedImageLatency] = {
		backendsList = {
			{ type = supportedTelemetryBackends.RobloxTelemetryStat }
		}
	},
	[module.ContentFeedImageLoadFailed] = {
		backendsList = {
			{ type = supportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[module.ContentFeedMoreMenuButtonPressed] = {
		backendsList = {
			{ type = supportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[module.ContentFeedPlayButtonPressed] = {
		backendsList = {
			{ type = supportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[module.ContentFeedPostViewed] = {
		backendsList = {
			{ type = supportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[module.ContentFeedReportCtaPressed] = {
		backendsList = {
			{ type = supportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[module.ContentFeedShareCtaPressed] = {
		backendsList = {
			{ type = supportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[module.ContentFeedVideoLatency] = {
		backendsList = {
			{ type = supportedTelemetryBackends.RobloxTelemetryStat }
		}
	},
	[module.ContentFeedVideoLoadFailed] = {
		backendsList = {
			{ type = supportedTelemetryBackends.RobloxTelemetryCounter }
		}
	}
}
