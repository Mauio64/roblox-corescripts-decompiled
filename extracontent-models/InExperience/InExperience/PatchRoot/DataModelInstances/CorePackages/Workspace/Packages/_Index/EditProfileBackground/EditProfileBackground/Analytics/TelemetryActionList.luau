local EditProfileBackground = script:FindFirstAncestor("EditProfileBackground")
local EventNames = require(script.Parent.Enums.EventNames)

local parent = EditProfileBackground.Parent
local SocialLuaAnalytics = require(parent.SocialLuaAnalytics)
local SupportedTelemetryBackends = SocialLuaAnalytics.Analytics.Enums.SupportedTelemetryBackends

return {
	defaults = {
		throttlingThousandths = game:DefineFastInt("EditProfileBackgroundAnalyticsThrottlingThousandths", 1000),
		links = ""
	},
	[EventNames.EditProfileBackgroundOpened] = {
		description = "Edit Profile Background Page Opened",
		lastUpdated = { 25, 7, 30 },
		backendsList = {
			{ type = SupportedTelemetryBackends.RobloxTelemetryCounter }
		}
	},
	[EventNames.EditProfileBackgroundLoadingStage] = {
		description = "Edit Profile Background Loading Stage",
		lastUpdated = { 25, 7, 30 },
		backendsList = {
			{
				type = SupportedTelemetryBackends.RobloxTelemetryStat,
				dynamicCustomFields = {
					status = function(p)
						return p
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
				type = SupportedTelemetryBackends.RobloxTelemetryCounter,
				dynamicCustomFields = {
					backgroundId = function(p)
						return p
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
				type = SupportedTelemetryBackends.RobloxTelemetryCounter,
				dynamicCustomFields = {
					errorType = function(p)
						return p
					end,
					errorCode = function(p)
						return p
					end
				}
			}
		}
	}
}
