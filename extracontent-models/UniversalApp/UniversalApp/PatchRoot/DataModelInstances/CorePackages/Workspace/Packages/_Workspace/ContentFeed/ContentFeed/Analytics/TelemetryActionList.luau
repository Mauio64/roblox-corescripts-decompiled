local ParentParent = script.Parent.Parent.Parent
local SupportedTelemetryBackends = require(ParentParent.SocialLuaAnalytics).Analytics.Enums.SupportedTelemetryBackends
local EventNames = require(script.Parent.EventNames)

return {
	defaults = {
		links = "",
		throttlingThousandths = game:DefineFastInt("ContentFeedTelemetryThrottlingThousandths", 1000)
	},
	[EventNames.ContentFeedCloseShortcutPressed] = {
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter
		}}
	},
	[EventNames.ContentFeedDeleteCtaPressed] = {
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter
		}}
	},
	[EventNames.ContentFeedExitCtaPressed] = {
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter
		}}
	},
	[EventNames.ContentFeedInspectCtaPressed] = {
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter
		}}
	},
	[EventNames.ContentFeedInspectItemPressed] = {
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter
		}}
	},
	[EventNames.ContentFeedImageLatency] = {
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryStat
		}}
	},
	[EventNames.ContentFeedImageLoadFailed] = {
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter
		}}
	},
	[EventNames.ContentFeedMoreMenuButtonPressed] = {
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter
		}}
	},
	[EventNames.ContentFeedPlayButtonPressed] = {
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter
		}}
	},
	[EventNames.ContentFeedPostViewed] = {
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter
		}}
	},
	[EventNames.ContentFeedReportCtaPressed] = {
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter
		}}
	},
	[EventNames.ContentFeedShareCtaPressed] = {
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter
		}}
	},
	[EventNames.ContentFeedVideoLatency] = {
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryStat
		}}
	},
	[EventNames.ContentFeedVideoLoadFailed] = {
		backendsList = {{
			type = SupportedTelemetryBackends.RobloxTelemetryCounter
		}}
	}
}
