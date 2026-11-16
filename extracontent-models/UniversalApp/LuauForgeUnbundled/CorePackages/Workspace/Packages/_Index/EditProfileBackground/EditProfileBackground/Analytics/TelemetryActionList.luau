local EventNames = require("@game/CorePackages/Workspace/Packages/_Index/EditProfileBackground/EditProfileBackground/Analytics/Enums/EventNames")

local supportedTelemetryBackends = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfileBackground/SocialLuaAnalytics").Analytics.Enums.SupportedTelemetryBackends

return {
	defaults = {
		throttlingThousandths = game:DefineFastInt(
			"EditProfileBackgroundAnalyticsThrottlingThousandths",
			1000
		),
		links = ""
	},
	[EventNames.EditProfileBackgroundOpened] = {
		description = "Edit Profile Background Page Opened",
		lastUpdated = { 25, 7, 30 },
		backendsList = {
			{ type = supportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[EventNames.EditProfileBackgroundLoadingStage] = {
		description = "Edit Profile Background Loading Stage",
		lastUpdated = { 25, 7, 30 },
		backendsList = {
			{
				type = supportedTelemetryBackends.RobloxTelemetryStat,
				dynamicCustomFields = {
					status = function(p2)
						return p2
					end
				}
			}
		}
	},
	[EventNames.BackgroundSelected] = {
		description = "Background Selected",
		lastUpdated = { 25, 7, 30 },
		backendsList = {
			{
				type = supportedTelemetryBackends.RobloxTelemetryCounter,
				dynamicCustomFields = {
					backgroundId = function(p2)
						return p2
					end
				}
			}
		}
	},
	[EventNames.EditProfileBackgroundFailure] = {
		description = "Edit Profile Background Failure",
		lastUpdated = { 25, 8, 4 },
		backendsList = {
			{
				type = supportedTelemetryBackends.RobloxTelemetryCounter,
				dynamicCustomFields = {
					errorType = function(p2)
						return p2
					end,
					errorCode = function(p2)
						return p2
					end
				}
			}
		}
	}
}
