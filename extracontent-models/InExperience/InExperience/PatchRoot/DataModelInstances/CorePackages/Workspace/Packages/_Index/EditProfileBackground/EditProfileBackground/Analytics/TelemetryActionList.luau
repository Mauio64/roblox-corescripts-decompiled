local EditProfileBackground = script:FindFirstAncestor("EditProfileBackground")
local EventNames = require(script.Parent.Enums.EventNames)
local EditProfileBackgroundParent = EditProfileBackground.Parent
local SupportedTelemetryBackends = require(EditProfileBackgroundParent.SocialLuaAnalytics).Analytics.Enums.SupportedTelemetryBackends

return {
	defaults = {
		links = "",
		throttlingThousandths = game:DefineFastInt("EditProfileBackgroundAnalyticsThrottlingThousandths", 1000)
	},
	[EventNames.EditProfileBackgroundOpened] = {
		description = "Edit Profile Background Page Opened",
		lastUpdated = {
			25,
			7,
			30
		},
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter
		}}
	},
	[EventNames.EditProfileBackgroundLoadingStage] = {
		description = "Edit Profile Background Loading Stage",
		lastUpdated = {
			25,
			7,
			30
		},
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryStat,
			dynamicCustomFields = {
				status = function(p1) -- line: 29
					return p1
				end
			}
		}}
	},
	[EventNames.BackgroundSelected] = {
		description = "Background Selected",
		lastUpdated = {
			25,
			7,
			30
		},
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter,
			dynamicCustomFields = {
				backgroundId = function(p2) -- line: 43
					return p2
				end
			}
		}}
	},
	[EventNames.EditProfileBackgroundFailure] = {
		description = "Edit Profile Background Failure",
		lastUpdated = {
			25,
			8,
			4
		},
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter,
			dynamicCustomFields = {
				errorType = function(p3) -- line: 57
					return p3
				end,
				errorCode = function(p4) -- line: 60
					return p4
				end
			}
		}}
	}
}
